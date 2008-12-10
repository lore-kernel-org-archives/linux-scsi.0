From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 3/23]: SCST core docs
Date: Wed, 10 Dec 2008 21:34:05 +0300
Message-ID: <49400B9D.6060903@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50850 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbYLJSea (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:34:30 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains documentation for SCST core.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  Documentation/scst/README.scst |  823=20
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  1 file changed, 823 insertions(+)

diff -uprN orig/linux-2.6.27/Documentation/scst/README.scst linux-2.6.2=
7/Documentation/scst/README.scst
--- orig/linux-2.6.27/Documentation/scst/README.scst
+++ linux-2.6.27/Documentation/scst/README.scst
@@ -0,0 +1,823 @@
+Generic SCSI target mid-level for Linux (SCST)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+SCST is designed to provide unified, consistent interface between SCSI
+target drivers and Linux kernel and simplify target drivers developmen=
t
+as much as possible. Detail description of SCST's features and interna=
ls
+could be found in "Generic SCSI Target Middle Level for Linux" documen=
t
+SCST's Internet page http://scst.sourceforge.net.
+
+SCST supports the following I/O modes:
+
+ * Pass-through mode with one to many relationship, i.e. when multiple
+   initiators can connect to the exported pass-through devices, for
+   the following SCSI devices types: disks (type 0), tapes (type 1),
+   processors (type 3), CDROMs (type 5), MO disks (type 7), medium
+   changers (type 8) and RAID controllers (type 0xC)
+
+ * FILEIO mode, which allows to use files on file systems or block
+   devices as virtual remotely available SCSI disks or CDROMs with
+   benefits of the Linux page cache
+
+ * BLOCKIO mode, which performs direct block IO with a block device,
+   bypassing page-cache for all operations. This mode works ideally wi=
th
+   high-end storage HBAs and for applications that either do not need
+   caching between application and disk or need the large block
+   throughput
+
+ * User space mode using scst_user device handler, which allows to
+   implement in the user space virtual SCSI devices in the SCST
+   environment
+
+ * "Performance" device handlers, which provide in pseudo pass-through
+   mode a way for direct performance measurements without overhead of
+   actual data transferring from/to underlying SCSI device
+
+In addition, SCST supports advanced per-initiator access and devices
+visibility management, so different initiators could see different set
+of devices with different access permissions. See below for details.
+
+This is quite stable (but still beta) version.
+
+Installation
+------------
+
+To see your devices remotely, you need to add them to at least "Defaul=
t"
+security group (see below how). By default, no local devices are seen
+remotely. There must be LUN 0 in each security group, i.e. LUs
+numeration must not start from, e.g., 1.
+
+It is highly recommended to use scstadmin utility for configuring
+devices and security groups.
+
+If you experience problems during modules load or running, check your
+kernel logs (or run dmesg command for the few most recent messages).
+
+IMPORTANT: Without loading appropriate device handler, corresponding d=
evices
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  will be invisible for remote initiators, =
which could lead to holes
+           in the LUN addressing, so automatic device scanning by remo=
te SCSI
+           mid-level could not notice the devices. Therefore you will =
have
+	   to add them manually via
+	   'echo "- - -" >/sys/class/scsi_host/hostX/scan',
+	   where X - is the host number.
+
+IMPORTANT: Working of target and initiator on the same host isn't
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  supported. This is a limitation of the Li=
nux memory/cache
+           manager, because in this case an OOM deadlock like: system
+	   needs some memory -> it decides to clear some cache -> cache
+	   needs to write on a target exported device -> initiator sends
+	   request to the target -> target needs memory -> problem is
+	   possible.
+
+IMPORTANT: In the current version simultaneous access to local SCSI de=
vices
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  via standard high-level SCSI drivers (sd,=
 st, sg, etc.) and
+           SCST's target drivers is unsupported. Especially it is
+	   important for execution via sg and st commands that change
+	   the state of devices and their parameters, because that could
+	   lead to data corruption. If any such command is done, at
+	   least related device handler(s) must be restarted. For block
+	   devices READ/WRITE commands using direct disk handler look to
+	   be safe.
+
+Device handlers
+---------------
+
+Device specific drivers (device handlers) are plugins for SCST, which
+help SCST to analyze incoming requests and determine parameters,
+specific to various types of devices. If an appropriate device handler
+for a SCSI device type isn't loaded, SCST doesn't know how to handle
+devices of this type, so they will be invisible for remote initiators
+(more precisely, "LUN not supported" sense code will be returned).
+
+In addition to device handlers for real devices, there are VDISK, user
+space and "performance" device handlers.
+
+VDISK device handler works over files on file systems and makes from
+them virtual remotely available SCSI disks or CDROM's. In addition, it
+allows to work directly over a block device, e.g. local IDE or SCSI di=
sk
+or ever disk partition, where there is no file systems overhead. Using
+block devices comparing to sending SCSI commands directly to SCSI
+mid-level via scsi_do_req()/scsi_execute_async() has advantage that da=
ta
+are transferred via system cache, so it is possible to fully benefit f=
rom
+caching and read ahead performed by Linux's VM subsystem. The only
+disadvantage here that in the FILEIO mode there is superfluous data
+copying between the cache and SCST's buffers. This issue is going to b=
e
+addressed in the next release. Virtual CDROM's are useful for remote
+installation. See below for details how to setup and use VDISK device
+handler.
+
+SCST user space device handler provides an interface between SCST and
+the user space, which allows to create pure user space devices. The
+simplest example, where one would want it is if he/she wants to write =
a
+VTL. With scst_user he/she can write it purely in the user space. Or o=
ne
+would want it if he/she needs some sophisticated for kernel space
+processing of the passed data, like encrypting them or making snapshot=
s.
+
+"Performance" device handlers for disks, MO disks and tapes in their
+exec() method skip (pretend to execute) all READ and WRITE operations
+and thus provide a way for direct link performance measurements withou=
t
+overhead of actual data transferring from/to underlying SCSI device.
+
+NOTE: Since "perf" device handlers on READ operations don't touch the
+=3D=3D=3D=3D  commands' data buffer, it is returned to remote initiato=
rs as it
+      was allocated, without even being zeroed. Thus, "perf" device
+      handlers impose some security risk, so use them with caution.
+
+Compilation options
+-------------------
+
+There are the following compilation options, that could be change usin=
g
+your favorit kernel configuration Makefile target, e.g. "make xconfig"=
:
+
+ - CONFIG_SCST_DEBUG - if defined, turns on some debugging code,
+   including some logging. Makes the driver considerably bigger and sl=
ower,
+   producing large amount of log data.
+
+ - CONFIG_SCST_TRACING - if defined, turns on ability to log events. M=
akes the
+   driver considerably bigger and leads to some performance loss.
+
+ - CONFIG_SCST_EXTRACHECKS - if defined, adds extra validity checks in
+   the various places.
+
+ - CONFIG_SCST_USE_EXPECTED_VALUES - if not defined (default), initiat=
or
+   supplied expected data transfer length and direction will be used o=
nly for
+   verification purposes to return error or warn in case if one of the=
m
+   is invalid. Instead, locally decoded from SCSI command values will =
be
+   used. This is necessary for security reasons, because otherwise a
+   faulty initiator can crash target by supplying invalid value in one
+   of those parameters. This is especially important in case of
+   pass-through mode. If CONFIG_SCST_USE_EXPECTED_VALUES is defined, i=
nitiator
+   supplied expected data transfer length and direction will override
+   the locally decoded values. This might be necessary if internal SCS=
T
+   commands translation table doesn't contain SCSI command, which is
+   used in your environment. You can know that if you have messages li=
ke
+   "Unknown opcode XX for YY. Should you update scst_scsi_op_table?" i=
n
+   your kernel log and your initiator returns an error. Also report
+   those messages in the SCST mailing list
+   scst-devel@lists.sourceforge.net. Note, that not all SCSI transport=
s
+   support supplying expected values.
+
+ - CONFIG_SCST_DEBUG_TM - if defined, turns on task management functio=
ns
+   debugging, when on LUN 0 in the default access control group some o=
f the
+   commands will be delayed for about 60 sec., so making the remote
+   initiator send TM functions, eg ABORT TASK and TARGET RESET. Also
+   define CONFIG_SCST_TM_DBG_GO_OFFLINE symbol in the Makefile if you
+   want that the device eventually become completely unresponsive, or
+   otherwise to circle around ABORTs and RESETs code. Needs CONFIG_SCS=
T_DEBUG
+   turned on.
+
+ - CONFIG_SCST_STRICT_SERIALIZING - if defined, makes SCST send all co=
mmands to
+   underlying SCSI device synchronously, one after one. This makes tas=
k
+   management more reliable, with cost of some performance penalty. Th=
is
+   is mostly actual for stateful SCSI devices like tapes, where the
+   result of command's execution depends from device's settings define=
d
+   by previous commands. Disk and RAID devices are stateless in the mo=
st
+   cases. The current SCSI core in Linux doesn't allow to abort all
+   commands reliably if they sent asynchronously to a stateful device.
+   Turned off by default, turn it on if you use stateful device(s) and
+   need as much error recovery reliability as possible. As a side
+   effect, no kernel patching is necessary.
+
+ - CONFIG_SCST_ALLOW_PASSTHROUGH_IO_SUBMIT_IN_SIRQ - if defined, it wi=
ll be
+   allowed to submit pass-through commands to real SCSI devices via th=
e SCSI
+   middle layer using scsi_execute_async() function from soft IRQ
+   context (tasklets). This used to be the default, but currently it
+   seems the SCSI middle layer starts expecting only thread context on
+   the IO submit path, so it is disabled now by default. Enabling it
+   will decrease amount of context switches and improve performance. I=
t
+   is more or less safe, in the worst case, if in your configuration t=
he
+   SCSI middle layer really doesn't expect SIRQ context in
+   scsi_execute_async() function, you will get a warning message in th=
e
+   kernel log.
+
+ - CONFIG_SCST_STRICT_SECURITY - if defined, makes SCST zero allocated=
 data
+   buffers. Undefining it (default) considerably improves performance
+   and eases CPU load, but could create a security hole (information
+   leakage), so enable it, if you have strict security requirements.
+
+ - CONFIG_SCST_ABORT_CONSIDER_FINISHED_TASKS_AS_NOT_EXISTING - if defi=
ned,
+   in case when TASK MANAGEMENT function ABORT TASK is trying to abort=
 a
+   command, which has already finished, remote initiator, which sent t=
he
+   ABORT TASK request, will receive TASK NOT EXIST (or ABORT FAILED)
+   response for the ABORT TASK request. This is more logical response,
+   since, because the command finished, attempt to abort it failed, bu=
t
+   some initiators, particularly VMware iSCSI initiator, consider TASK
+   NOT EXIST response as if the target got crazy and try to RESET it.
+   Then sometimes get crazy itself. So, this option is disabled by
+   default.
+
+ - CONFIG_SCST_MEASURE_LATENCY - if defined, provides in /proc/scsi_tg=
t/latency
+   file average commands processing latency. You can clear already
+   measured results by writing 0 in this file. Note, you need a
+   non-preemtible kernel to have correct results.
+
+HIGHMEM kernel configurations are fully supported, but not recommended
+for performance reasons, except for scst_user, where they are not
+supported, because this module deals with user supplied memory on a
+zero-copy manner. If you need to use it, consider change VMSPLIT optio=
n
+or use 64-bit system configuration instead.
+
+For changing VMSPLIT option (CONFIG_VMSPLIT to be precise) you should =
in
+"make menuconfig" command set the following variables:
+
+ - General setup->Configure standard kernel features (for small system=
s): ON
+
+ - General setup->Prompt for development and/or incomplete code/driver=
s: ON
+
+ - Processor type and features->High Memory Support: OFF
+
+ - Processor type and features->Memory split: according to amount of
+   memory you have. If it is less than 800MB, you may not touch this
+   option at all.
+
+Module parameters
+-----------------
+
+Module scst supports the following parameters:
+
+ - scst_threads - allows to set count of SCST's threads. By default it
+   is CPU count.
+
+ - scst_max_cmd_mem - sets maximum amount of memory in Mb allowed to b=
e
+   consumed by the SCST commands for data buffers at any given time. B=
y
+   default it is approximately TotalMem/4.
+
+SCST "/proc" commands
+---------------------
+
+For communications with user space programs SCST provides proc-based
+interface in "/proc/scsi_tgt" directory. It contains the following
+entries:
+
+  - "help" file, which provides online help for SCST commands
+
+  - "scsi_tgt" file, which on read provides information of serving by =
SCST
+    devices and their dev handlers. On write it supports the following
+    command:
+
+      * "assign H:C:I:L HANDLER_NAME" assigns dev handler "HANDLER_NAM=
E"
+        on device with host:channel:id:lun
+
+  - "sessions" file, which lists currently connected initiators (open =
sessions)
+
+  - "sgv" file provides some statistic about with which block sizes
+    commands from remote initiators come and how effective sgv_pool in
+    serving those allocations from the cache, i.e. without memory
+    allocations requests to the kernel. "Size" - is the commands data
+    size upper rounded to power of 2, "Hit" - how many there are
+    allocations from the cache, "Total" - total number of allocations.
+
+  - "threads" file, which allows to read and set number of SCST's thre=
ads
+
+  - "version" file, which shows version of SCST
+
+  - "trace_level" file, which allows to read and set trace (logging) l=
evel
+    for SCST. See "help" file for list of trace levels. If you want to
+    enable logging options, which produce a lot of events, like "debug=
",
+    to not loose logged events you should also:
+
+     * Increase in .config of your kernel CONFIG_LOG_BUF_SHIFT variabl=
e
+       to much bigger value, then recompile it. For example, I use 25,
+       but to use it I needed to modify the maximum allowed value for
+       CONFIG_LOG_BUF_SHIFT in the corresponding Kconfig.
+
+     * Change in your /etc/syslog.conf or other config file of your fa=
vorite
+       logging program to store kernel logs in async manner. For examp=
le,
+       I added in my rsyslog.conf line "kern.info -/var/log/kernel"
+       and added "kern.none" in line for /var/log/messages, so I had:
+       "*.info;kern.none;mail.none;authpriv.none;cron.none /var/log/me=
ssages"
+
+Each dev handler has own subdirectory. Most dev handler have only two
+files in this subdirectory: "trace_level" and "type". The first one is
+similar to main SCST "trace_level" file, the latter one shows SCSI typ=
e
+number of this handler as well as some text description.
+
+For example, "echo "assign 1:0:1:0 dev_disk" >/proc/scsi_tgt/scsi_tgt"
+will assign device handler "dev_disk" to real device sitting on host 1=
,
+channel 0, ID 1, LUN 0.
+
+Access and devices visibility management (LUN masking)
+------------------------------------------------------
+
+Access and devices visibility management allows for an initiator or
+group of initiators to have different views of LUs/LUNs (security grou=
ps)
+each with appropriate access permissions. It is highly recommended to
+use scstadmin utility for that purpose instead of described in this
+section low level interface.
+
+Initiator is represented as an SCST session. The session is bound to
+security group on its registration time by character "name" parameter =
of
+the registration function, which provided by target driver, based on i=
ts
+internal authentication. For example, for FC "name" could be WWN or ju=
st
+loop ID. For iSCSI this could be iSCSI login credentials or iSCSI
+initiator name. Each security group has set of names assigned to it by
+system administrator. Session is bound to security group with provided
+name. If no such groups found, the session bound to either
+"Default_target_name", or "Default" group, depending from either
+"Default_target_name" exists or not. In "Default_target_name" target
+name means name of the target.
+
+In /proc/scsi_tgt each group represented as "groups/GROUP_NAME/"
+subdirectory. In it there are files "devices" and "names". File
+"devices" lists all devices and their LUNs in the group, file "names"
+lists all names that should be bound to this group.
+
+To configure access and devices visibility management SCST provides th=
e
+following files and directories under /proc/scsi_tgt:
+
+  - "add_group GROUP" to /proc/scsi_tgt/scsi_tgt adds group "GROUP"
+
+  - "del_group GROUP" to /proc/scsi_tgt/scsi_tgt deletes group "GROUP"
+
+  - "add H:C:I:L lun [READ_ONLY]" to /proc/scsi_tgt/groups/GROUP/devic=
es adds
+    device with host:channel:id:lun as LUN "lun" in group "GROUP". Opt=
ionally,
+    the device could be marked as read only.
+
+  - "del H:C:I:L" to /proc/scsi_tgt/groups/GROUP/devices deletes devic=
e with
+    host:channel:id:lun from group "GROUP"
+
+  - "add V_NAME lun [READ_ONLY]" to /proc/scsi_tgt/groups/GROUP/device=
s adds
+    device with virtual name "V_NAME" as LUN "lun" in group "GROUP".
+    Optionally, the device could be marked as read only.
+
+  - "del V_NAME" to /proc/scsi_tgt/groups/GROUP/devices deletes device=
 with
+    virtual name "V_NAME" from group "GROUP"
+
+  - "clear" to /proc/scsi_tgt/groups/GROUP/devices clears the list of =
devices
+    for group "GROUP"
+
+  - "add NAME" to /proc/scsi_tgt/groups/GROUP/names adds name "NAME" t=
o group
+    "GROUP"
+
+  - "del NAME" to /proc/scsi_tgt/groups/GROUP/names deletes name "NAME=
" from group
+    "GROUP"
+
+  - "clear" to /proc/scsi_tgt/groups/GROUP/names clears the list of na=
mes
+    for group "GROUP"
+
+There must be LUN 0 in each security group, i.e. LUs numeration must n=
ot
+start from, e.g., 1.
+
+Examples:
+
+ - "echo "add 1:0:1:0 0" >/proc/scsi_tgt/groups/Default/devices" will
+ add real device sitting on host 1, channel 0, ID 1, LUN 0 to "Default=
"
+ group with LUN 0.
+
+ - "echo "add disk1 1" >/proc/scsi_tgt/groups/Default/devices" will
+ add virtual VDISK device with name "disk1" to "Default" group
+ with LUN 1.
+
+VDISK device handler
+--------------------
+
+After loading VDISK device handler creates in "/proc/scsi_tgt/"
+subdirectories "vdisk" and "vcdrom". They have similar layout:
+
+  - "trace_level" and "type" files as described for other dev handlers
+
+  - "help" file, which provides online help for VDISK commands
+
+  - "vdisk"/"vcdrom" files, which on read provides information of
+    currently open device files. On write it supports the following
+    command:
+
+    * "open NAME [PATH] [BLOCK_SIZE] [FLAGS]" - opens file "PATH" as
+      device "NAME" with block size "BLOCK_SIZE" bytes with flags
+      "FLAGS". "PATH" could be empty only for VDISK CDROM. "BLOCK_SIZE=
"
+      and "FLAGS" are valid only for disk VDISK. The block size must b=
e
+      power of 2 and >=3D 512 bytes. Default is 512. Possible flags:
+
+      - WRITE_THROUGH - write back caching disabled. Note, this option
+        has sense only if you also *manually* disable write-back cache
+	in *all* your backstorage devices and make sure it's actually
+	disabled, since many devices are known to lie about this mode to
+	get better benchmark results.
+
+      - READ_ONLY - read only
+
+      - O_DIRECT - both read and write caching disabled. This mode
+        isn't currently fully implemented, you should use user space
+	fileio_tgt program in O_DIRECT mode instead (see below).
+
+      - NULLIO - in this mode no real IO will be done, but success wil=
l be
+        returned. Intended to be used for performance measurements at =
the same
+        way as "*_perf" handlers.
+
+      - NV_CACHE - enables "non-volatile cache" mode. In this mode it =
is
+        assumed that the target has a GOOD UPS with ability to cleanly
+	shutdown target in case of power failure and it is
+	software/hardware bugs free, i.e. all data from the target's
+	cache are guaranteed sooner or later to go to the media. Hence
+	all data synchronization with media operations, like
+	SYNCHRONIZE_CACHE, are ignored in order to bring more
+	performance. Also in this mode target reports to initiators that
+	the corresponding device has write-through cache to disable all
+	write-back cache workarounds used by initiators. Use with
+	extreme caution, since in this mode after a crash of the target
+	journaled file systems don't guarantee the consistency after
+	journal recovery, therefore manual fsck MUST be ran. Note, that
+	since usually the journal barrier protection (see "IMPORTANT"
+	note below) turned off, enabling NV_CACHE could change nothing
+	from data protection point of view, since no data
+	synchronization with media operations will go from the
+	initiator. This option overrides WRITE_THROUGH.
+
+      - BLOCKIO - enables block mode, which will perform direct block
+        IO with a block device, bypassing page-cache for all operation=
s.
+	This mode works ideally with high-end storage HBAs and for
+	applications that either do not need caching between application
+	and disk or need the large block throughput. See also below.
+
+      - REMOVABLE - with this flag set the device is reported to remot=
e
+        initiators as removable.
+
+    * "close NAME" - closes device "NAME".
+
+    * "change NAME [PATH]" - changes a virtual CD in the VDISK CDROM.
+
+By default, if neither BLOCKIO, nor NULLIO option is supplied, FILEIO
+mode is used.
+
+For example, "echo "open disk1 /vdisks/disk1" >/proc/scsi_tgt/vdisk/vd=
isk"
+will open file /vdisks/disk1 as virtual FILEIO disk with name "disk1".
+
+CAUTION: If you partitioned/formatted your device with block size X, *=
NEVER*
+=3D=3D=3D=3D=3D=3D=3D=3D ever try to export and then mount it (even ac=
cidentally) with another
+         block size. Otherwise you can *instantly* damage it pretty
+	 badly as well as all your data on it. Messages on initiator
+	 like: "attempt to access beyond end of device" is the sign of
+	 such damage.
+
+	 Moreover, if you want to compare how well different block sizes
+	 work for you, you **MUST** EVERY TIME AFTER CHANGING BLOCK SIZE
+	 **COMPLETELY** **WIPE OFF** ALL THE DATA FROM THE DEVICE. In
+	 other words, THE **WHOLE** DEVICE **MUST** HAVE ONLY **ZEROS**
+	 AS THE DATA AFTER YOU SWITCH TO NEW BLOCK SIZE. Switching block
+	 sizes isn't like switching between FILEIO and BLOCKIO, after
+	 changing block size all previously written with another block
+	 size data MUST BE ERASED. Otherwise you will have a full set of
+	 very weird behaviors, because blocks addressing will be
+	 changed, but initiators in most cases will not have a
+	 possibility to detect that old addresses written on the device
+	 in, e.g., partition table, don't refer anymore to what they are
+	 intended to refer.
+
+IMPORTANT: By default for performance reasons VDISK FILEIO devices use=
 write
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  back caching policy. This is generally sa=
fe from the consistence of
+           journaled file systems, laying over them, point of view, bu=
t
+	   your unsaved cached data will be lost in case of
+	   power/hardware/software failure, so you must supply your
+	   target server with some kind of UPS or disable write back
+	   caching using WRITE_THROUGH flag. You also should note, that
+	   the file systems journaling over write back caching enabled
+	   devices works reliably *ONLY* if the order of journal writes
+	   is guaranteed or it uses some kind of data protection
+	   barriers (i.e. after writing journal data some kind of
+	   synchronization with media operations is used), otherwise,
+	   because of possible reordering in the cache, even after
+	   successful journal rollback, you very much risk to loose your
+	   data on the FS. Currently, Linux IO subsystem guarantees
+	   order of write operations only using data protection
+	   barriers. Some info about it from the XFS point of view could
+	   be found at http://oss.sgi.com/projects/xfs/faq.html#wcache.
+	   On Linux initiators for EXT3 and ReiserFS file systems the
+	   barrier protection could be turned on using "barrier=3D1" and
+	   "barrier=3Dflush" mount options correspondingly. Note, that
+	   usually it turned off by default and the status of barriers
+	   usage isn't reported anywhere in the system logs as well as
+	   there is no way to know it on the mounted file system (at
+	   least no known one). Windows and, AFAIK, other UNIX'es don't
+	   need any special explicit options and do necessary barrier
+	   actions on write-back caching devices by default. Also note
+	   that on some real-life workloads write through caching might
+	   perform better, than write back one with the barrier
+	   protection turned on.
+	   Also you should realize that Linux doesn't provide a
+	   guarantee that after sync()/fsync() all written data really
+	   hit permanent storage, they can be then in the cache of your
+	   backstorage device and lost on power failure event. Thus,
+	   ever with write-through cache mode, you still need a good UPS
+	   to protect yourself from your data loss (note, data loss, not
+	   the file system integrity corruption).
+
+IMPORTANT: Some disk and partition table management utilities don't su=
pport
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  block sizes >512 bytes, therefore make su=
re that your favorite one
+           supports it. Currently only cfdisk is known to work only wi=
th
+	   512 bytes blocks, other utilities like fdisk on Linux or
+	   standard disk manager on Windows are proved to work well with
+	   non-512 bytes blocks. Note, if you export a disk file or
+	   device with some block size, different from one, with which
+	   it was already partitioned, you could get various weird
+	   things like utilities hang up or other unexpected behavior.
+	   Hence, to be sure, zero the exported file or device before
+	   the first access to it from the remote initiator with another
+	   block size. On Window initiator make sure you "Set Signature"
+	   in the disk manager on the imported from the target drive
+	   before doing any other partitioning on it. After you
+	   successfully mounted a file system over non-512 bytes block
+	   size device, the block size stops matter, any program will
+	   work with files on such file system.
+
+BLOCKIO VDISK mode
+------------------
+
+This module works best for these types of scenarios:
+
+1) Data that are not aligned to 4K sector boundaries and <4K block siz=
es
+are used, which is normally found in virtualization environments where
+operating systems start partitions on odd sectors (Windows and it's
+sector 63).
+
+2) Large block data transfers normally found in database loads/dumps a=
nd
+streaming media.
+
+3) Advanced relational database systems that perform their own caching
+which prefer or demand direct IO access and, because of the nature of
+their data access, can actually see worse performance with
+non-discriminate caching.
+
+4) Multiple layers of targets were the secondary and above layers need
+to have a consistent view of the primary targets in order to preserve
+data integrity which a page cache backed IO type might not provide
+reliably.
+
+Also it has an advantage over FILEIO that it doesn't copy data between
+the system cache and the commands data buffers, so it saves a
+considerable amount of CPU power and memory bandwidth.
+
+IMPORTANT: Since data in BLOCKIO and FILEIO modes are not consistent b=
etween
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  them, if you try to use a device in both =
those modes simultaneously,
+           you will almost instantly corrupt your data on that device.
+
+Pass-through mode
+-----------------
+
+In the pass-through mode (i.e. using the pass-through device handlers
+scst_disk, scst_tape, etc) SCSI commands, coming from remote initiator=
s,
+are passed to local SCSI hardware on target as is, without any
+modifications. As any other hardware, the local SCSI hardware can not
+handle commands with amount of data and/or segments count in
+scatter-gather array bigger some values. Therefore, when using the
+pass-through mode you should note that values for maximum number of
+segments and maximum amount of transferred data for each SCSI command =
on
+devices on initiators can not be bigger, than corresponding values of
+the corresponding SCSI devices on the target. Otherwise you will see
+symptoms like small transfers work well, but large ones stall and
+messages like: "Unable to complete command due to SG IO count
+limitation" are printed in the kernel logs.
+
+You can't control from the user space limit of the scatter-gather
+segments, but for block devices usually it is sufficient if you set on
+the initiators /sys/block/DEVICE_NAME/queue/max_sectors_kb in the same
+or lower value as in /sys/block/DEVICE_NAME/queue/max_hw_sectors_kb fo=
r
+the corresponding devices on the target.
+
+For not-block devices SCSI commands are usually generated directly by
+applications, so, if you experience large transfers stalls, you should
+check documentation for your application how to limit the transfer
+sizes.
+
+User space mode using scst_user dev handler
+-------------------------------------------
+
+User space program fileio_tgt uses interface of scst_user dev handler
+and allows to see how it works in various modes. Fileio_tgt provides
+mostly the same functionality as scst_vdisk handler with the most
+noticeable difference that it supports O_DIRECT mode. O_DIRECT mode is
+basically the same as BLOCKIO, but also supports files, so for some
+loads it could be significantly faster, than the regular FILEIO access=
=2E
+All the words about BLOCKIO from above apply to O_DIRECT as well. See
+fileio_tgt's README file for more details.
+
+Performance
+-----------
+
+Before doing any performance measurements note that:
+
+I. Performance results are very much dependent from your type of load,
+so it is crucial that you choose access mode (FILEIO, BLOCKIO,
+O_DIRECT, pass-through), which suits your needs the best.
+
+II. In order to get the maximum performance you should:
+
+1. For SCST:
+
+ - Disable in Makefile CONFIG_SCST_STRICT_SERIALIZING, CONFIG_SCST_EXT=
RACHECKS,
+   CONFIG_SCST_TRACING, CONFIG_SCST_DEBUG*, CONFIG_SCST_STRICT_SECURIT=
Y
+
+ - For pass-through devices enable
+   CONFIG_SCST_ALLOW_PASSTHROUGH_IO_SUBMIT_IN_SIRQ.
+
+2. For target drivers:
+
+ - Disable in Makefiles CONFIG_SCST_EXTRACHECKS, CONFIG_SCST_TRACING,
+   CONFIG_SCST_DEBUG*
+
+3. For device handlers, including VDISK:
+
+ - Disable in Makefile CONFIG_SCST_TRACING and CONFIG_SCST_DEBUG.
+
+ - If your initiator(s) use dedicated exported from the target virtual
+   SCSI devices and have more or equal amount of memory, than the
+   target, it is recommended to use O_DIRECT option (currently it is
+   available only with fileio_tgt user space program) or BLOCKIO. With
+   them you could have up to 100% increase in throughput.
+
+IMPORTANT: Some of the compilation options enabled by default, i.e. SC=
ST
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  is optimized currently rather for develop=
ment and bug hunting,
+           than for performance.
+
+If you use SCST version taken directly from the SVN repository, you ca=
n
+set the above options, except CONFIG_SCST_ALLOW_PASSTHROUGH_IO_SUBMIT_=
IN_SIRQ,
+using debug2perf Makefile target.
+
+4. For other target and initiator software parts:
+
+ - Don't enable debug/hacking features in the kernel, i.e. use them as
+   they are by default.
+
+ - The default kernel read-ahead and queuing settings are optimized
+   for locally attached disks, therefore they are not optimal if they
+   attached remotely (SCSI target case), which sometimes could lead to
+   unexpectedly low throughput. You should increase read-ahead size to=
 at
+   least 512KB or even more on all initiators and the target.
+
+   You should also limit on all initiators maximum amount of sectors p=
er
+   SCSI command. To do it on Linux initiators, run:
+
+   echo =9364=94 > /sys/block/sdX/queue/max_sectors_kb
+
+   where specify instead of X your imported from target device letter,
+   like 'b', i.e. sdb.
+
+   To increase read-ahead size on Linux, run:
+
+   blockdev --setra N /dev/sdX
+
+   where N is a read-ahead number in 512-byte sectors and X is a devic=
e
+   letter like above.
+
+   Note: you need to set read-ahead setting for device sdX again after
+   you changed the maximum amount of sectors per SCSI command for that
+   device.
+
+ - You may need to increase amount of requests that OS on initiator
+   sends to the target device. To do it on Linux initiators, run
+
+   echo =9364=94 > /sys/block/sdX/queue/nr_requests
+
+   where X is a device letter like above.
+
+   You may also experiment with other parameters in /sys/block/sdX
+   directory, they also affect performance. If you find the best value=
s,
+   please share them with us.
+
+ - On the target CFQ IO scheduler. In most cases it has performance
+   advantage over other IO schedulers, sometimes huge (2+ times
+   aggregate throughput increase).
+
+ - It is recommended to turn the kernel preemption off, i.e. set
+   the kernel preemption model to "No Forced Preemption (Server)".
+
+ - Looks like XFS is the best filesystem on the target to store device
+   files, because it allows considerably better linear write throughpu=
t,
+   than ext3.
+
+5. For hardware on target.
+
+ - Make sure that your target hardware (e.g. target FC or network card=
)
+   and underlaying IO hardware (e.g. IO card, like SATA, SCSI or RAID =
to
+   which your disks connected) don't share the same PCI bus. You can
+   check it using lspci utility. They have to work in parallel, so it
+   will be better if they don't compete for the bus. The problem is no=
t
+   only in the bandwidth, which they have to share, but also in the
+   interaction between cards during that competition. This is very
+   important, because in some cases if target and backend storage
+   controllers share the same PCI bus, it could lead up to 5-10 times
+   less performance, than expected. Moreover, some motherboard (by
+   Supermicro, particularly) have serious stability issues if there ar=
e
+   several high speed devices on the same bus working in parallel. If
+   you have no choice, but PCI bus sharing, set in the BIOS PCI latenc=
y
+   as low as possible.
+
+6. If you use VDISK IO module in FILEIO mode, NV_CACHE option will
+provide you the best performance. But using it make sure you use a goo=
d
+UPS with ability to shutdown the target on the power failure.
+
+IMPORTANT: If you use on initiator some versions of Windows (at least =
W2K)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  you can't get good write performance for =
VDISK FILEIO devices with
+           default 512 bytes block sizes. You could get about 10% of t=
he
+	   expected one. This is because of the partition alignment, which
+	   is (simplifying) incompatible with how Linux page cache
+	   works, so for each write the corresponding block must be read
+	   first. Use 4096 bytes block sizes for VDISK devices and you
+	   will have the expected write performance. Actually, any OS on
+	   initiators, not only Windows, will benefit from block size
+	   max(PAGE_SIZE, BLOCK_SIZE_ON_UNDERLYING_FS), where PAGE_SIZE
+	   is the page size, BLOCK_SIZE_ON_UNDERLYING_FS is block size
+	   on the underlying FS, on which the device file located, or 0,
+	   if a device node is used. Both values are from the target.
+	   See also important notes about setting block sizes >512 bytes
+	   for VDISK FILEIO devices above.
+
+What if target's backstorage is too slow
+----------------------------------------
+
+If under high load you experience I/O stalls or see in the kernel log =
on
+the target abort or reset messages, then your backstorage is too slow
+comparing with your target link speed and amount of simultaneously
+queued commands. On some seek intensive workloads even fast disks or
+RAIDs, which able to serve continuous data stream on 500+ MB/s speed,
+can be as slow as 0.3 MB/s. Another possible cause for that can be
+MD/LVM/RAID on your target as in http://lkml.org/lkml/2008/2/27/96
+(check the whole thread as well).
+
+Thus, in such situations simply processing of one or more commands tak=
es
+too long time, hence initiator decides that they are stuck on the targ=
et
+and tries to recover. Particularly, it is known that the default amoun=
t
+of simultaneously queued commands (48) is sometimes too high if you do
+intensive writes from VMware on a target disk, which uses LVM in the
+snapshot mode. In this case value like 16 or even 8-10 depending of yo=
ur
+backstorage speed could be more appropriate.
+
+Unfortunately, currently SCST lacks dynamic I/O flow control, when the
+queue depth on the target is dynamically decreased/increased based on
+how slow/fast the backstorage speed comparing to the target link. So,
+there are only 5 possible actions, which you can do to workaround or f=
ix
+this issue:
+
+1. Ignore incoming task management (TM) commands. It's fine if there a=
re
+not too many of them, so average performance isn't hurt and the
+corresponding device isn't put offline, i.e. if the backstorage isn't
+too much slow.
+
+2. Decrease /sys/block/sdX/device/queue_depth on the initiator in case
+if it's Linux (see below how) or/and SCST_MAX_TGT_DEV_COMMANDS constan=
t
+in scst_priv.h file until you stop seeing incoming TM commands.
+ISCSI-SCST driver also has its own iSCSI specific parameter for that.
+
+3. Try to avoid such seek intensive workloads.
+
+4. Insrease speed of the target's backstorage.
+
+5. Implement in SCST the dynamic I/O flow control.
+
+To decrease device queue depth on Linux initiators run command:
+
+# echo Y >/sys/block/sdX/device/queue_depth
+
+where Y is the new number of simultaneously queued commands, X - your
+imported device letter, like 'a' for sda device. There are no special
+limitations for Y value, it can be any value from 1 to possible maximu=
m
+(usually, 32), so start from dividing the current value on 2, i.e. set
+16, if /sys/block/sdX/device/queue_depth contains 32.
+
+Note, that logged messages about QUEUE_FULL status are quite different
+by nature. This is a normal work, just SCSI flow control in action.
+Simply don't enable "mgmt_minor" logging level, or, alternatively, if
+you are confident in the worst case performance of your back-end
+storage, you can increase SCST_MAX_TGT_DEV_COMMANDS in scst_priv.h to
+64. Usually initiators don't try to push more commands on the target.
+
+Credits
+-------
+
+Thanks to:
+
+ * Mark Buechler <mark.buechler@gmail.com> for a lot of useful
+   suggestions, bug reports and help in debugging.
+
+ * Ming Zhang <mingz@ele.uri.edu> for fixes and comments.
+
+ * Nathaniel Clark <nate@misrule.us> for fixes and comments.
+
+ * Calvin Morrow <calvin.morrow@comcast.net> for testing and useful
+   suggestions.
+
+ * Hu Gang <hugang@soulinfo.com> for the original version of the
+   LSI target driver.
+
+ * Erik Habbinga <erikhabbinga@inphase-tech.com> for fixes and support
+   of the LSI target driver.
+
+ * Ross S. W. Walker <rswwalker@hotmail.com> for the original block IO
+   code and Vu Pham <huongvp@yahoo.com> who updated it for the VDISK d=
ev
+   handler.
+
+ * Michael G. Byrnes <michael.byrnes@hp.com> for fixes.
+
+ * Alessandro Premoli <a.premoli@andxor.it> for fixes
+
+ * Nathan Bullock <nbullock@yottayotta.com> for fixes.
+
+ * Terry Greeniaus <tgreeniaus@yottayotta.com> for fixes.
+
+ * Krzysztof Blaszkowski <kb@sysmikro.com.pl> for many fixes and bug r=
eports.
+
+ * Jianxi Chen <pacers@users.sourceforge.net> for fixing problem with
+   devices >2TB in size
+
+ * Bart Van Assche <bart.vanassche@gmail.com> for a lot of help
+
+Vladislav Bolkhovitin <vst@vlnb.net>, http://scst.sourceforge.net


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
