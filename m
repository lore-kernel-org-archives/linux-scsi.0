From: Andy Grover <agrover@redhat.com>
Subject: [RFC 1/2] target: Add documentation on the target userspace pass-through driver
Date: Tue,  1 Jul 2014 12:11:14 -0700
Message-ID: <1404241875-29164-2-git-send-email-agrover@redhat.com>
References: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org, shli@kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Describes the driver and its interface to make it possible for user
programs to back a LIO-exported LUN.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 Documentation/target/tcmu-design.txt | 210 +++++++++++++++++++++++++++++++++++
 1 file changed, 210 insertions(+)
 create mode 100644 Documentation/target/tcmu-design.txt

diff --git a/Documentation/target/tcmu-design.txt b/Documentation/target/tcmu-design.txt
new file mode 100644
index 0000000..200ff3e
--- /dev/null
+++ b/Documentation/target/tcmu-design.txt
@@ -0,0 +1,210 @@
+TCM Userspace Design
+--------------------
+
+
+Background:
+
+In addition to modularizing the transport protocol used for carrying
+SCSI commands ("fabrics"), the Linux kernel target, LIO, also modularizes
+the actual data storage as well. These are referred to as "backstores"
+or "storage engines". The target comes with backstores that allow a
+file, a block device, RAM, or another SCSI device to be used for the
+local storage needed for the exported SCSI LUN. Like the rest of LIO,
+these are implemented entirely as kernel code.
+
+These backstores cover the most common use cases, but not all. One new
+use case that other non-kernel target solutions, such as tgt, are able
+to support is using Gluster's GLFS or Ceph's RBD as a backstore. The
+target then serves as a translator, allowing initiators to store data
+in these non-traditional networked storage systems, while still only
+using standard protocols themselves.
+
+If the target is a userspace process, supporting these is easy. tgt,
+for example, needs only a small adapter module for each, because the
+modules just use the available userspace libraries for RBD and GLFS.
+
+Adding support for these backstores in LIO is considerably more
+difficult, because LIO is entirely kernel code. Instead of undertaking
+the significant work to port the GLFS or RBD APIs and protocols to the
+kernel, another approach is to create a userspace pass-through
+backstore for LIO, "TCMU".
+
+
+Benefits:
+
+In addition to allowing relatively easy support for RBD and GLFS, TCMU
+will also allow easier development of new backstores. TCMU combines
+with the LIO loopback fabric to become something similar to FUSE
+(Filesystem in Userspace), but at the SCSI layer instead of the
+filesystem layer. A SUSE, if you will.
+
+The disadvantage is there are more distinct components to configure, and
+potentially to malfunction. This is unavoidable, but hopefully not
+fatal if we're careful to keep things as simple as possible.
+
+Design constraints:
+
+- Good performance: high throughput, low latency
+- Cleanly handle if userspace:
+   1) never attaches
+   2) hangs
+   3) dies
+   4) misbehaves
+- Allow future flexibility in user & kernel implementations
+- Be reasonably memory-efficient
+- Simple to configure & run
+- Simple to write a userspace backend
+
+
+Implementation overview:
+
+The core of the TCMU interface is a memory region that is shared
+between kernel and userspace. Within this region is: a control area
+(mailbox); a lockless producer/consumer circular buffer for commands
+to be passed up, and status returned; and an in/out data buffer area.
+
+TCMU uses the pre-existing UIO subsystem. UIO allows device driver
+development in userspace, and this is conceptually very close to the
+TCMU use case, except instead of a physical device, TCMU implements a
+memory-mapped layout designed for SCSI commands. Using UIO also
+benefits TCMU by handling device introspection (e.g. a way for
+userspace to determine how large the shared region is) and signaling
+mechanisms in both directions.
+
+There are no embedded pointers in the memory region. Everything is
+expressed as an offset from the region's starting address. This allows
+the ring to still work if the user process dies and is restarted with
+the region mapped at a different virtual address.
+
+See target_core_user.h for the struct definitions.
+
+The Mailbox:
+
+The mailbox is always at the start of the shared memory region, and
+contains a version, details about the starting offset and size of the
+command ring, and head and tail pointers to be used by the kernel and
+userspace (respectively) to put commands on the ring, and indicate
+when the commands are completed.
+
+version - 1 (userspace should abort if otherwise)
+flags - none yet defined.
+cmdr_off - The offset of the start of the command ring from the start
+of the memory region, to account for the mailbox size.
+cmdr_size - The size of the command ring. This does *not* need to be a
+power of two.
+cmd_head - Modified by the kernel to indicate when a command has been
+placed on the ring.
+cmd_tail - Modified by userspace to indicate when it has completed
+processing of a command.
+
+The Command Ring:
+
+Commands are placed on the ring by the kernel incrementing
+mailbox.cmd_head by the size of the command, modulo cmdr_size, and
+then signaling userspace via uio_event_notify(). Once the command is
+completed, userspace updates mailbox.cmd_tail in the same way and
+signals the kernel via a 4-byte write(). When cmd_head equals
+cmd_tail, the ring is empty -- no commands are currently waiting to be
+processed by userspace.
+
+TCMU commands start with a common header containing "len_op", a 32-bit
+value that stores the length, as well as the opcode in the lowest
+unused bits. Currently only two opcodes are defined, TCMU_OP_PAD and
+TCMU_OP_CMD. When userspace encounters a command with PAD opcode, it
+should skip ahead by the bytes in "length". (The kernel inserts PAD
+entries to ensure each CMD entry fits contigously into the circular
+buffer.)
+
+When userspace handles a CMD, it finds the SCSI CDB (Command Data
+Block) via tcmu_cmd_entry.req.cdb_off. This is an offset from the
+start of the overall shared memory region, not the entry. The data
+in/out buffers are accessible via tht req.iov[] array. Note that
+each iov.iov_base is also an offset from the start of the region.
+
+TCMU currently does not support BIDI operations.
+
+When completing a command, userspace sets rsp.scsi_status, and
+rsp.sense_buffer if necessary. Userspace then increments
+mailbox.cmd_tail by entry.hdr.length (mod cmdr_size) and signals the
+kernel via the UIO method, a 4-byte write to the file descriptor.
+
+The Data Area:
+
+This is shared-memory space after the command ring. The organization
+of this area is not defined in the TCMU interface, and userspace
+should access only the parts referenced by pending iovs.
+
+
+Device Discovery:
+
+Other devices may be using UIO besides TCMU. Unrelated user processes
+may also be handling different sets of TCMU devices. TCMU userspace
+processes must find their devices by scanning sysfs
+class/uio/uio*/name. For TCMU devices, these names will be of the
+format:
+
+tcm-user/<subtype>/<path>
+
+where "tcm-user" is common for all TCMU-backed UIO devices. <subtype>
+will be a userspace-process-unique string to identify the TCMU device
+as expecting to be backed by a certain handler, and <path> will be an
+additional handler-specific string for the user process to configure
+the device, if needed. Neither <subtype> or <path> can contain ':',
+due to LIO limitations.
+
+For all devices so discovered, the user handler opens /dev/uioX and
+calls mmap():
+
+mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0)
+
+where size must be equal to the value read from
+/sys/class/uio/uioX/maps/map0/size.
+
+
+Device Events:
+
+If a new device is added or removed, user processes will recieve a HUP
+signal, and should re-scan sysfs. File descriptors for devices no
+longer in sysfs should be closed, and new devices should be opened and
+handled.
+
+
+Other contingencies:
+
+Userspace handler process never attaches:
+
+- TCMU will post commands, and then abort them after a timeout period
+  (30 seconds.)
+
+Userspace handler process is killed:
+
+- It is still possible to restart and re-connect to TCMU
+  devices. Command ring is preserved. However, after the timeout period,
+  the kernel will abort pending tasks.
+
+Userspace handler process hangs:
+
+- The kernel will abort pending tasks after a timeout period.
+
+Userspace handler process is malicious:
+
+- The process can trivially break the handling of devices it controls,
+  but should not be able to access kernel memory outside its shared
+  memory areas.
+
+
+Writing a user backstore handler:
+
+Variable emulation with pass_level:
+
+TCMU supports a "pass_level" option with valid values of 1, 2, or
+3. This controls how many different SCSI commands are passed up,
+versus being emulated by LIO. The purpose of this is to give the user
+handler author a choice of how much of the full SCSI command set they
+care to support.
+
+At level 1, only READ and WRITE commands will be seen. At level 2,
+additional commands defined in the SBC SCSI specification such as
+WRITE SAME, SYNCRONIZE CACHE, and UNMAP will be passed up. Finally, at
+level 3, almost all commands defined in the SPC SCSI specification
+will also be passed up for processing by the user handler.
-- 
1.9.3
