From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 8/9] osdfs: Documentation
Date: Thu, 30 Oct 2008 17:03:34 +0200
Message-ID: <1225379014-25733-1-git-send-email-bharrosh@panasas.com>
References: <4909C41A.7000406@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:33660 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbYJ3PDn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 11:03:43 -0400
In-Reply-To: <4909C41A.7000406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Avishay Traeger <avishay@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

Added some documentation in osdfs.txt, as well as a BUGS file.

For further reading, operation instructions, example scripts
and up to date infomation and code please see:
http://open-osd.org

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 Documentation/filesystems/osdfs.txt |  173 +++++++++++++++++++++++++++++++++++
 fs/osdfs/BUGS                       |    6 +
 2 files changed, 179 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/osdfs.txt
 create mode 100644 fs/osdfs/BUGS

diff --git a/Documentation/filesystems/osdfs.txt b/Documentation/filesystems/osdfs.txt
new file mode 100644
index 0000000..2579b3c
--- /dev/null
+++ b/Documentation/filesystems/osdfs.txt
@@ -0,0 +1,173 @@
+===============================================================================
+WHAT IS OSDFS?
+===============================================================================
+
+osdfs is a file system that uses an OSD and exports the API of a normal Linux
+file system. Users access osdfs like any other local file system, and osdfs
+will in turn issue commands to the local initiator.
+
+===============================================================================
+ENVIRONMENT
+===============================================================================
+
+To use this file system, you need to have an object store to run it on.  You
+may download a target from:
+http://open-osd.org
+
+See drivers/scsi/osd/README for how to setup a working osd environment.
+
+===============================================================================
+USAGE
+===============================================================================
+
+1. Download and compile osdfs and open-osd initiator:
+  You need an external Kernel source tree or kernel headers from your
+  distribution. (anything based on 2.6.26 or later).
+
+  a. download open-osd including osdfs source using:
+     [parent-directory]$ git clone git://git.open-osd.org/open-osd.git
+
+  b. Build the library module like this:
+     [parent-directory]$ make -C KSRC=$(KER_DIR) open-osd
+
+     This will build both the open-osd initiator as well as the osdfs kernel
+     module. Use whatever parameters you compiled your Kernel with and 
+     $(KER_DIR) above pointing to the Kernel you compile against. See the file
+     open-osd/top-level-Makefile for an example.
+
+2. Get the OSD initiator and target set up properly, and login to the target.
+  See drivers/scsi/osd/README for farther instructions. Also see ./do-osd-test
+  for example script that does all these steps.
+
+3. Insmod the osdfs.ko module:
+   [osdfs]$ insmod osdfs.ko
+
+4. Make sure the directory where you want to mount exists. If not, create it.
+   (For example, /mnt/osdfs)
+
+5. At first run you will need to invoke the mkosdfs.c routine
+
+   As an example, this will create the file system on:
+   /dev/osd0 partition ID 65540, max capacity 1024 Mg bytes
+
+   mount -t osdfs -o pid=65540,mkfs=1,format=1024 /dev/osd0 /mnt/osdfs/
+
+   The format=1024 is optional if not specified no OSD_FORMAT will be preformed
+   and a clean file system will be created in the specified pid, in the
+   available space of the target.
+   If pid already exist it will be deleted and a new one will be created in it's
+   place. Be careful.
+
+6. Mount the file system. The above command left the filesystem mounted,
+   but on subsequent runs the mkfs=1 should not be invoked.
+
+   For example, to mount /dev/osd0, partition ID 65540 on /mnt/osdfs:
+
+	mount -t osdfs -o pid=65540 /dev/osd0 /mnt/osdfs/
+
+7. For reference (under fs/osdfs/):
+	do-osdfs start - an example of how to perform the above steps.
+	do-osdfs stop -  an example of how to unmount the file system.
+
+8. Extra compilation flags (uncomment in fs/osdfs/Kbuild):
+	OSDFS_DEBUG - for debug messages and extra checks.
+
+===============================================================================
+osdfs mount options
+===============================================================================
+Similar to any mount command:
+	mount -t osdfs -o osdfs_options /dev/osdX mount_osdfs_directory
+
+Where:
+    -t osdfs: specifies the osdfs file system
+
+    /dev/osdX: X is a decimal number. /dev/osdX was created after a successful
+               login into an OSD target.
+
+    mount_osdfs_directory: The directory to mount the file system on
+
+    osdfs_options: Options are separated by commas (,)
+		pid=<integer> - The partition number to mount/create as
+                                container of the filesystem.
+                                This option is mandatory
+		mkfs=<1/0>    - If mkfs=1 make a new filesystem before mount.
+                                Default is 0 - don't make. If mkfs=0 pid must
+                                exist and an mkfs=1 was previously preformed
+                                on it.
+               format=<integer>- If mkfs=1 is specified then the format=
+                                 parameter will also invoke an OSD_FORMAT
+                                 command prior to creation of the filesystem
+                                 partition (mkfs). The integer specified is in
+                                 Mega bytes. If not specified or set to 0 then
+                                 no format is executed, and a partition is
+                                 created in the available space.
+                                 If mkfs=0 this option is ignored.
+                to=<integer>  - Timeout in ticks for a single command
+                                default is (60 * HZ) [for debugging only]
+
+===============================================================================
+DESIGN
+===============================================================================
+
+* The file system control block (AKA on-disk superblock) resides in an object
+  with a special ID (defined in common.h).
+  Information included in the file system control block is used to fill the
+  in-memory superblock structure at mount time. This object is created before
+  the file system is used by mkosdfs.c It contains information such as:
+	- The file system's magic number
+	- The next inode number to be allocated
+
+* Each file resides in its own object and contains the data (and it will be
+  possible to extend the file over multiple objects, though this has not been
+  implemented yet).
+
+* A directory is treated as a file, and essentially contains a list of <file
+  name, inode #> pairs for files that are found in that directory. The object
+  IDs correspond to the files' inode numbers and will be allocated according to
+  a bitmap (stored in a separate object). Now they are allocated using a
+  counter.
+
+* Each file's control block (AKA on-disk inode) is stored in its object's
+  attributes. This applies to both regular files and other types (directories,
+  device files, symlinks, etc.).
+
+* Credentials are generated per object (inode and superblock) when they is
+  created in memory (read off disk or created). The credential works for all
+  operations and is used as long as the object remains in memory.
+
+* Async OSD operations are used whenever possible, but the target may execute
+  them out of order. The operations that concern us are create, delete,
+  readpage, writepage, update_inode, and truncate. The following pairs of
+  operations should execute in the order written, and we need to prevent them
+  from executing in reverse order:
+	- The following are handled with the OBJ_CREATED and OBJ_2BCREATED
+	  flags. OBJ_CREATED is set when we know the object exists on the OSD -
+	  in create's callback function, and when we successfully do a read_inode.
+	  OBJ_2BCREATED is set in the beginning of the create function, so we
+	  know that we should wait.
+		- create/delete: delete should wait until the object is created
+		  on the OSD.
+		- create/readpage: readpage should be able to return a page
+		  full of zeroes in this case. If there was a write already
+		  en-route (i.e. create, writepage, readpage) then the page
+		  would be locked, and so it would really be the same as
+		  create/writepage.
+		- create/writepage: if writepage is called for a sync write, it
+		  should wait until the object is created on the OSD.
+		  Otherwise, it should just return.
+		- create/truncate: truncate should wait until the object is
+		  created on the OSD.
+		- create/update_inode: update_inode should wait until the
+		  object is created on the OSD.
+	- Handled by VFS locks:
+		- readpage/delete: shouldn't happen because of page lock.
+		- writepage/delete: shouldn't happen because of page lock.
+		- readpage/writepage: shouldn't happen because of page lock.
+
+===============================================================================
+LICENSE/COPYRIGHT
+===============================================================================
+The osdfs file system is based on ext2 v0.5b (distributed with the Linux kernel
+version 2.6.10).  All files include the original copyrights, and the license
+is GPL version 2 (only version 2, as is true for the Linux kernel).  The
+Linux kernel can be downloaded from www.kernel.org.
diff --git a/fs/osdfs/BUGS b/fs/osdfs/BUGS
new file mode 100644
index 0000000..6d6e1f9
--- /dev/null
+++ b/fs/osdfs/BUGS
@@ -0,0 +1,6 @@
+- Some mount time options should have been 64-bit, but are declared as 32-bit
+  because that's what the kernel's parsing methods support at this time.
+
+- Out-of-space may cause a severe problem if the object (and directory entry)
+  were written, but the inode attributes failed. Then if the filesystem was
+  unmounted and mounted the kernel can get into an endless loop doing a readdir.
-- 
1.6.0.1

