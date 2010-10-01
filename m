From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH 11/19]: SCST core's docs
Date: Sat, 02 Oct 2010 01:48:58 +0400
Message-ID: <4CA6574A.8020800@vlnb.net>
References: <4CA653F0.1010008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62581 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab0JAVtk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2010 17:49:40 -0400
In-Reply-To: <4CA653F0.1010008@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>

This patch contains SCST core's docs.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 README.scst | 1473 +++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
 SysfsRules  |  942 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 2415 insertions(+)

diff -uprN orig/linux-2.6.35/Documentation/scst/README.scst linux-2.6.3=
5/Documentation/scst/README.scst
--- orig/linux-2.6.35/Documentation/scst/README.scst
+++ linux-2.6.35/Documentation/scst/README.scst
@@ -0,0 +1,1473 @@
+Generic SCSI target mid-level for Linux (SCST)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+SCST is designed to provide unified, consistent interface between SCSI
+target drivers and Linux kernel and simplify target drivers developmen=
t
+as much as possible. Detail description of SCST's features and interna=
ls
+could be found on its Internet page http://scst.sourceforge.net.
+
+SCST supports the following I/O modes:
+
+ * Pass-through mode with one to many relationship, i.e. when multiple
+   initiators can connect to the exported pass-through devices, for
+   the following SCSI devices types: disks (type 0), tapes (type 1),
+   processors (type 3), CDROMs (type 5), MO disks (type 7), medium
+   changers (type 8) and RAID controllers (type 0xC).
+
+ * FILEIO mode, which allows to use files on file systems or block
+   devices as virtual remotely available SCSI disks or CDROMs with
+   benefits of the Linux page cache.
+
+ * BLOCKIO mode, which performs direct block IO with a block device,
+   bypassing page-cache for all operations. This mode works ideally wi=
th
+   high-end storage HBAs and for applications that either do not need
+   caching between application and disk or need the large block
+   throughput.
+
+ * "Performance" device handlers, which provide in pseudo pass-through
+   mode a way for direct performance measurements without overhead of
+   actual data transferring from/to underlying SCSI device.
+
+In addition, SCST supports advanced per-initiator access and devices
+visibility management, so different initiators could see different set
+of devices with different access permissions. See below for details.
+
+Full list of SCST features and comparison with other Linux targets you
+can find on http://scst.sourceforge.net/comparison.html.
+
+
+Installation
+------------
+
+To see your devices remotely, you need to add a corresponding LUN for
+them (see below how). By default, no local devices are seen remotely.
+There must be LUN 0 in each LUNs set (security group), i.e. LUs
+numeration must not start from, e.g., 1. Otherwise you will see no
+devices on remote initiators and SCST core will write into the kernel
+log message: "tgt_dev for LUN 0 not found, command to unexisting LU?"
+
+It is highly recommended to use scstadmin utility for configuring
+devices and security groups.
+
+The flow of SCST inialization should be as the following:
+
+1. Load of SCST modules with necessary module parameters, if needed.
+
+2. Configure targets, devices, LUNs, etc. using either scstadmin
+(recommended), or the sysfs interface directly as described below.
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
+IMPORTANT: Working of target and initiator on the same host is
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  supported, except the following 2 cases: =
swap over target exported
+           device and using a writable mmap over a file from target
+	   exported device. The latter means you can't mount a file
+	   system over target exported device. In other words, you can
+	   freely use any sg, sd, st, etc. devices imported from target
+	   on the same host, but you can't mount file systems or put
+	   swap on them. This is a limitation of Linux memory/cache
+	   manager, because in this case an OOM deadlock like: system
+	   needs some memory -> it decides to clear some cache -> cache
+	   needs to write on target exported device -> initiator sends
+	   request to the target -> target needs memory -> system needs
+	   even more memory -> deadlock.
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
+	   devices READ/WRITE commands using direct disk handler are
+	   generally safe.
+
+
+Usage in failover mode
+----------------------
+
+It is recommended to use TEST UNIT READY ("tur") command to check if
+SCST target is alive in MPIO configurations.
+
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
+
+Compilation options
+-------------------
+
+There are the following compilation options, that could be change usin=
g
+your favorite kernel configuration Makefile target, e.g. "make xconfig=
":
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
+   supplied expected data transfer length and direction will be used
+   only for verification purposes to return error or warn in case if o=
ne
+   of them is invalid. Instead, locally decoded from SCSI command valu=
es
+   will be used. This is necessary for security reasons, because
+   otherwise a faulty initiator can crash target by supplying invalid
+   value in one of those parameters. This is especially important in
+   case of pass-through mode. If CONFIG_SCST_USE_EXPECTED_VALUES is
+   defined, initiator supplied expected data transfer length and
+   direction will override the locally decoded values. This might be
+   necessary if internal SCST commands translation table doesn't conta=
in
+   SCSI command, which is used in your environment. You can know that =
if
+   you enable "minor" trace level and have messages like "Unknown
+   opcode XX for YY. Should you update scst_scsi_op_table?" in your
+   kernel log and your initiator returns an error. Also report those
+   messages in the SCST mailing list scst-devel@lists.sourceforge.net.
+   Note, that not all SCSI transports support supplying expected value=
s.
+
+ - CONFIG_SCST_DEBUG_TM - if defined, turns on task management functio=
ns
+   debugging, when on LUN 6 some of the commands will be delayed for
+   about 60 sec., so making the remote initiator send TM functions, eg
+   ABORT TASK and TARGET RESET. Also define
+   CONFIG_SCST_TM_DBG_GO_OFFLINE symbol in the Makefile if you want th=
at
+   the device eventually become completely unresponsive, or otherwise =
to
+   circle around ABORTs and RESETs code. Needs CONFIG_SCST_DEBUG turne=
d
+   on.
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
+   need as much error recovery reliability as possible. As a side effe=
ct
+   of CONFIG_SCST_STRICT_SERIALIZING, on kernels below 2.6.30 no kerne=
l
+   patching is necessary for pass-through device handlers (scst_disk,
+   etc.).
+
+ - CONFIG_SCST_TEST_IO_IN_SIRQ - if defined, allows SCST to submit sel=
ected
+   SCSI commands (TUR and READ/WRITE) from soft-IRQ context (tasklets)=
=2E
+   Enabling it will decrease amount of context switches and slightly
+   improve performance. The goal of this option is to be able to measu=
re
+   overhead of the context switches. If after enabling this option you
+   don't see under load in vmstat output on the target significant
+   decrease of amount of context switches, then your target driver
+   doesn't submit commands to SCST in IRQ context. For instance,
+   iSCSI-SCST doesn't do that, but qla2x00t with
+   CONFIG_QLA_TGT_DEBUG_WORK_IN_THREAD disabled - does. This option is
+   designed to be used with vdisk NULLIO backend.
+
+   WARNING! Using this option enabled with other backend than vdisk
+   NULLIO is unsafe and can lead you to a kernel crash!
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
+ - CONFIG_SCST_MEASURE_LATENCY - if defined, provides in "latency" fil=
es
+   global and per-LUN average commands processing latency statistic. Y=
ou
+   can clear already measured results by writing 0 in each file. Note,
+   you need a non-preemptible kernel to have correct results.
+
+HIGHMEM kernel configurations are fully supported, but not recommended
+for performance reasons.
+
+
+Module parameters
+-----------------
+
+Module scst supports the following parameters:
+
+ - scst_threads - allows to set count of SCST's threads. By default it
+   is CPU count.
+
+ - scst_max_cmd_mem - sets maximum amount of memory in MB allowed to b=
e
+   consumed by the SCST commands for data buffers at any given time. B=
y
+   default it is approximately TotalMem/4.
+
+
+SCST sysfs interface
+--------------------
+
+Root of SCST sysfs interface is /sys/kernel/scst_tgt. It has the
+following entries:
+
+ - devices - this is a root subdirectory for all SCST devices
+
+ - handlers - this is a root subdirectory for all SCST dev handlers
+
+ - sgv - this is a root subdirectory for all SCST SGV caches
+
+ - targets - this is a root subdirectory for all SCST targets
+
+ - setup_id - allows to read and write SCST setup ID. This ID can be
+   used in cases, when the same SCST configuration should be installed
+   on several targets, but exported from those targets devices should
+   have different IDs and SNs. For instance, VDISK dev handler uses th=
is
+   ID to generate T10 vendor specific identifier and SN of the devices=
=2E
+
+ - threads - allows to read and set number of global SCST I/O threads.
+   Those threads used with async. dev handlers, for instance, vdisk
+   BLOCKIO or NULLIO.
+
+ - trace_level - allows to enable and disable various tracing
+   facilities. See content of this file for help how to use it.
+
+ - version - read-only attribute, which allows to see version of
+   SCST and enabled optional features.
+
+ - last_sysfs_mgmt_res - read-only attribute returning completion stat=
us
+   of the last management command. In the sysfs implementation there a=
re
+   some problems between internal sysfs and internal SCST locking. To
+   avoid them in some cases sysfs calls can return error with errno
+   EAGAIN. This doesn't mean the operation failed. It only means that
+   the operation queued and not yet completed. To wait for it to
+   complete, an management tool should poll this file. If the operatio=
n
+   hasn't yet completed, it will also return EAGAIN. But after it's
+   completed, it will return the result of this operation (0 for succe=
ss
+   or -errno for error).
+
+Each SCST sysfs file (attribute) can contain in the last line mark
+"[key]". It is automatically added mark used to allow scstadmin to see
+which attributes it should save in the config file. You can ignore it.
+
+"Devices" subdirectory contains subdirectories for each SCST devices.
+
+Content of each device's subdirectory is dev handler specific. See
+documentation for your dev handlers for more info about it as well as
+SysfsRules file for more info about common to all dev handlers rules.
+SCST dev handlers can have the following common entries:
+
+ - exported - subdirectory containing links to all LUNs where this
+   device was exported.
+
+ - handler - if dev handler determined for this device, this link poin=
ts
+   to it. The handler can be not set for pass-through devices.
+
+ - threads_num - shows and allows to set number of threads in this dev=
ice's
+   threads pool. If 0 - no threads will be created, and global SCST
+   threads pool will be used. If <0 - creation of the threads pool is
+   prohibited.
+
+ - threads_pool_type - shows and allows to sets threads pool type.
+   Possible values: "per_initiator" and "shared". When the value is
+   "per_initiator" (default), each session from each initiator will us=
e
+   separate dedicated pool of threads. When the value is "shared", all
+   sessions from all initiators will share the same per-device pool of
+   threads. Valid only if threads_num attribute >0.
+
+ - dump_prs - allows to dump persistent reservations information in th=
e
+   kernel log.
+
+ - type - SCSI type of this device
+
+See below for more information about other entries of this subdirector=
y
+of the standard SCST dev handlers.
+
+"Handlers" subdirectory contains subdirectories for each SCST dev
+handler.
+
+Content of each handler's subdirectory is dev handler specific. See
+documentation for your dev handlers for more info about it as well as
+SysfsRules file for more info about common to all dev handlers rules.
+SCST dev handlers can have the following common entries:
+
+ - mgmt - this entry allows to create virtual devices and their
+   attributes (for virtual devices dev handlers) or assign/unassign re=
al
+   SCSI devices to/from this dev handler (for pass-through dev
+   handlers).
+
+ - trace_level - allows to enable and disable various tracing
+   facilities. See content of this file for help how to use it.
+
+ - type - SCSI type of devices served by this dev handler.
+
+See below for more information about other entries of this subdirector=
y
+of the standard SCST dev handlers.
+
+"Sgv" subdirectory contains statistic information of SCST SGV caches. =
It
+has the following entries:
+
+ - None, one or more subdirectories for each existing SGV cache.
+
+ - global_stats - file containing global SGV caches statistics.
+
+Each SGV cache's subdirectory has the following item:
+
+ - stats - file containing statistics for this SGV caches.
+
+"Targets" subdirectory contains subdirectories for each SCST target.
+
+Content of each target's subdirectory is target specific. See
+documentation for your target for more info about it as well as
+SysfsRules file for more info about common to all targets rules.
+Every target should have at least the following entries:
+
+ - ini_groups - subdirectory, which contains and allows to define
+   initiator-oriented access control information, see below.
+
+ - luns - subdirectory, which contains list of available LUNs in the
+   target-oriented access control and allows to define it, see below.
+
+ - sessions - subdirectory containing connected to this target session=
s.
+
+ - enabled - using this attribute you can enable or disable this targe=
t/
+   It allows to finish configuring it before it starts accepting new
+   connections. 0 by default.
+
+ - addr_method - used LUNs addressing method. Possible values:
+   "Peripheral" and "Flat". Most initiators work well with Peripheral
+   addressing method (default), but some (HP-UX, for instance) may
+   require Flat method. This attribute is also available in the
+   initiators security groups, so you can assign the addressing method
+   on per-initiator basis.
+
+ - cpu_mask - defines CPU affinity mask for threads serving this targe=
t.
+   For threads serving LUNs it is used only for devices with
+   threads_pool_type "per_initiator".
+
+ - io_grouping_type - defines how I/O from sessions to this target are
+   grouped together. This I/O grouping is very important for
+   performance. By setting this attribute in a right value, you can
+   considerably increase performance of your setup. This grouping is
+   performed only if you use CFQ I/O scheduler on the target and for
+   devices with threads_num >=3D 0 and, if threads_num > 0, with
+   threads_pool_type "per_initiator". Possible values:
+   "this_group_only", "never", "auto", or I/O group number >0. When th=
e
+   value is "this_group_only" all I/O from all sessions in this target
+   will be grouped together. When the value is "never", I/O from
+   different sessions will not be grouped together, i.e. all sessions =
in
+   this target will have separate dedicated I/O groups. When the value
+   is "auto" (default), all I/O from initiators with the same name
+   (iSCSI initiator name, for instance) in all targets will be grouped
+   together with a separate dedicated I/O group for each initiator nam=
e.
+   For iSCSI this mode works well, but other transports usually use
+   different initiator names for different sessions, so using such
+   transports in MPIO configurations you should either use value
+   "this_group_only", or an explicit I/O group number. This attribute =
is
+   also available in the initiators security groups, so you can assign
+   the I/O grouping on per-initiator basis. See below for more info ho=
w
+   to use this attribute.
+
+ - rel_tgt_id - allows to read or write SCSI Relative Target Port
+   Identifier attribute. This identifier is used to identify SCSI Targ=
et
+   Ports by some SCSI commands, mainly by Persistent Reservations
+   commands. This identifier must be unique among all SCST targets, bu=
t
+   for convenience SCST allows disabled targets to have not unique
+   rel_tgt_id. In this case SCST will not allow to enable this target
+   until rel_tgt_id becomes unique. This attribute initialized unique =
by
+   SCST by default.
+
+A target driver may have also the following entries:
+
+ - "hw_target" - if the target driver supports both hardware and virtu=
al
+    targets (for instance, an FC adapter supporting NPIV, which has
+    hardware targets for its physical ports as well as virtual NPIV
+    targets), this read only attribute for all hardware targets will
+    exist and contain value 1.
+
+Subdirectory "sessions" contains one subdirectory for each connected
+session with name equal to name of the connected initiator.
+
+Each session subdirectory contains the following entries:
+
+ - initiator_name - contains initiator name
+
+ - force_close - optional write-only attribute, which allows to force
+   close this session.
+
+ - active_commands - contains number of active, i.e. not yet or being
+   executed, SCSI commands in this session.
+
+ - commands - contains overall number of SCSI commands in this session=
=2E
+
+ - latency - if CONFIG_SCST_MEASURE_LATENCY enabled, contains latency
+   statistics for this session.
+
+ - luns - a link pointing out to the corresponding LUNs set (security
+   group) where this session was attached to.
+
+ - One or more "lunX" subdirectories, where 'X' is a number, for each =
LUN
+   this session has (see below).
+
+ - other target driver specific attributes and subdirectories.
+
+See below description of the VDISK's sysfs interface for samples.
+
+
+Access and devices visibility management (LUN masking)
+------------------------------------------------------
+
+Access and devices visibility management allows for an initiator or
+group of initiators to see different devices with different LUNs
+with necessary access permissions.
+
+SCST supports two modes of access control:
+
+1. Target-oriented. In this mode you define for each target a default
+set of LUNs, which are accessible to all initiators, connected to that
+target. This is a regular access control mode, which people usually me=
an
+thinking about access control in general. For instance, in IET this is
+the only supported mode.
+
+2. Initiator-oriented. In this mode you define which LUNs are accessib=
le
+for each initiator. In this mode you should create for each set of one
+or more initiators, which should access to the same set of devices wit=
h
+the same LUNs, a separate security group, then add to it devices and
+names of allowed initiator(s).
+
+Both modes can be used simultaneously. In this case the
+initiator-oriented mode has higher priority, than the target-oriented,
+i.e. initiators are at first searched in all defined security groups f=
or
+this target and, if none matches, the default target's set of LUNs is
+used. This set of LUNs might be empty, then the initiator will not see
+any LUNs from the target.
+
+You can at any time find out which set of LUNs each session is assigne=
d
+to by looking where link
+/sys/kernel/scst_tgt/targets/target_driver/target_name/sessions/initia=
tor_name/luns
+points to.
+
+To configure the target-oriented access control SCST provides the
+following interface. Each target's sysfs subdirectory
+(/sys/kernel/scst_tgt/targets/target_driver/target_name) has "luns"
+subdirectory. This subdirectory contains the list of already defined
+target-oriented access control LUNs for this target as well as file
+"mgmt". This file has the following commands, which you can send to it=
,
+for instance, using "echo" shell command. You can always get a small
+help about supported commands by looking inside this file. "Parameters=
"
+are one or more param_name=3Dvalue pairs separated by ';'.
+
+ - "add H:C:I:L lun [parameters]" - adds a pass-through device with
+   host:channel:id:lun with LUN "lun". Optionally, the device could be
+   marked as read only by using parameter "read_only". The recommended
+   way to find out H:C:I:L numbers is use of lsscsi utility.
+
+ - "replace H:C:I:L lun [parameters]" - replaces by pass-through devic=
e
+   with host:channel:id:lun existing with LUN "lun" device with
+   generation of INQUIRY DATA HAS CHANGED Unit Attention. If the old
+   device doesn't exist, this command acts as the "add" command.
+   Optionally, the device could be marked as read only by using
+   parameter "read_only". The recommended way to find out H:C:I:L
+   numbers is use of lsscsi utility.
+
+ - "add VNAME lun [parameters]" - adds a virtual device with name VNAM=
E
+   with LUN "lun". Optionally, the device could be marked as read only
+   by using parameter "read_only".
+
+ - "replace VNAME lun [parameters]" - replaces by virtual device
+   with name VNAME existing with LUN "lun" device with generation of
+   INQUIRY DATA HAS CHANGED Unit Attention. If the old device doesn't
+   exist, this command acts as the "add" command. Optionally, the devi=
ce
+   could be marked as read only by using parameter "read_only".
+
+ - "del lun" - deletes LUN lun
+
+ - "clear" - clears the list of devices
+
+To configure the initiator-oriented access control SCST provides the
+following interface. Each target's sysfs subdirectory
+(/sys/kernel/scst_tgt/targets/target_driver/target_name) has "ini_grou=
ps"
+subdirectory. This subdirectory contains the list of already defined
+security groups for this target as well as file "mgmt". This file has
+the following commands, which you can send to it, for instance, using
+"echo" shell command. You can always get a small help about supported
+commands by looking inside this file.
+
+ - "create GROUP_NAME" - creates a new security group.
+
+ - "del GROUP_NAME" - deletes a new security group.
+
+Each security group's subdirectory contains 2 subdirectories: initiato=
rs
+and luns as well as the following attributes: addr_method, cpu_mask an=
d
+io_grouping_type. See above description of them.
+
+Each "initiators" subdirectory contains list of added to this groups
+initiator as well as as well as file "mgmt". This file has the followi=
ng
+commands, which you can send to it, for instance, using "echo" shell
+command. You can always get a small help about supported commands by
+looking inside this file.
+
+ - "add INITIATOR_NAME" - adds initiator with name INITIATOR_NAME to t=
he
+   group.
+
+ - "del INITIATOR_NAME" - deletes initiator with name INITIATOR_NAME
+   from the group.
+
+ - "move INITIATOR_NAME DEST_GROUP_NAME" moves initiator with name
+   INITIATOR_NAME from the current group to group with name
+   DEST_GROUP_NAME.
+
+ - "clear" - deletes all initiators from this group.
+
+For "add" and "del" commands INITIATOR_NAME can be a simple DOS-type
+patterns, containing '*' and '?' symbols. '*' means match all any
+symbols, '?' means match only any single symbol. For instance,
+"blah.xxx" will match "bl?h.*". Additionally, you can use negative sig=
n
+'!' to revert the value of the pattern. For instance, "ah.xxx" will
+match "!bl?h.*".
+
+Each "luns" subdirectory contains the list of already defined LUNs for
+this group as well as file "mgmt". Content of this file as well as lis=
t
+of available in it commands is fully identical to the "luns"
+subdirectory of the target-oriented access control.
+
+Examples:
+
+ - echo "create INI" >/sys/kernel/scst_tgt/targets/iscsi/iqn.2006-10.n=
et.vlnb:tgt1/ini_groups/mgmt -
+   creates security group INI for target iqn.2006-10.net.vlnb:tgt1.
+
+ - echo "add 2:0:1:0 11" >/sys/kernel/scst_tgt/targets/iscsi/iqn.2006-=
10.net.vlnb:tgt1/ini_groups/INI/luns/mgmt -
+   adds a pass-through device sitting on host 2, channel 0, ID 1, LUN =
0
+   to group with name INI as LUN 11.
+
+ - echo "add disk1 0" >/sys/kernel/scst_tgt/targets/iscsi/iqn.2006-10.=
net.vlnb:tgt1/ini_groups/INI/luns/mgmt -
+   adds a virtual disk with name disk1 to group with name INI as LUN 0=
=2E
+
+ - echo "add 21:*:e0:?b:83:*" >/sys/kernel/scst_tgt/targets/21:00:00:a=
0:8c:54:52:12/ini_groups/INI/initiators/mgmt -
+   adds a pattern to group with name INI to Fibre Channel target with
+   WWN 21:00:00:a0:8c:54:52:12, which matches WWNs of Fibre Channel
+   initiator ports.
+
+Consider you need to have an iSCSI target with name
+"iqn.2007-05.com.example:storage.disk1.sys1.xyz", which should export
+virtual device "dev1" with LUN 0 and virtual device "dev2" with LUN 1,
+but initiator with name
+"iqn.2007-05.com.example:storage.disk1.spec_ini.xyz" should see only
+virtual device "dev2" read only with LUN 0. To achieve that you should
+do the following commands:
+
+# echo "iqn.2007-05.com.example:storage.disk1.sys1.xyz" >/sys/kernel/s=
cst_tgt/targets/iscsi/mgmt
+# echo "add dev1 0" >/sys/kernel/scst_tgt/targets/iscsi/iqn.2007-05.co=
m.example:storage.disk1.sys1.xyz/luns/mgmt
+# echo "add dev2 1" >/sys/kernel/scst_tgt/targets/iscsi/iqn.2007-05.co=
m.example:storage.disk1.sys1.xyz/luns/mgmt
+# echo "create SPEC_INI" >/sys/kernel/scst_tgt/targets/iscsi/iqn.2007-=
05.com.example:storage.disk1.sys1.xyz/ini_groups/mgmt
+# echo "add dev2 0 read_only=3D1" \
+	>/sys/kernel/scst_tgt/targets/iscsi/iqn.2007-05.com.example:storage.d=
isk1.sys1.xyz/ini_groups/SPEC_INI/luns/mgmt
+# echo "iqn.2007-05.com.example:storage.disk1.spec_ini.xyz" \
+	>/sys/kernel/scst_tgt/targets/iscsi/iqn.2007-05.com.example:storage.d=
isk1.sys1.xyz/ini_groups/SPEC_INI/initiators/mgmt
+
+For Fibre Channel or SAS in the above example you should use target's
+and initiator ports WWNs instead of iSCSI names.
+
+It is highly recommended to use scstadmin utility instead of described
+in this section low level interface.
+
+IMPORTANT
+=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+There must be LUN 0 in each set of LUNs, i.e. LUs numeration must not
+start from, e.g., 1. Otherwise you will see no devices on remote
+initiators and SCST core will write into the kernel log message: "tgt_=
dev
+for LUN 0 not found, command to unexisting LU?"
+
+IMPORTANT
+=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+All the access control must be fully configured BEFORE the correspondi=
ng
+target is enabled. When you enable a target, it will immediately start
+accepting new connections, hence creating new sessions, and those new
+sessions will be assigned to security groups according to the
+*currently* configured access control settings. For instance, to
+the default target's set of LUNs, instead of "HOST004" group as you ma=
y
+need, because "HOST004" doesn't exist yet. So, you must configure all
+the security groups before new connections from the initiators are
+created, i.e. before the target enabled.
+
+
+VDISK device handler
+--------------------
+
+VDISK has 4 built-in dev handlers: vdisk_fileio, vdisk_blockio,
+vdisk_nullio and vcdrom. Roots of their sysfs interface are
+/sys/kernel/scst_tgt/handlers/handler_name, e.g. for vdisk_fileio:
+/sys/kernel/scst_tgt/handlers/vdisk_fileio. Each root has the followin=
g
+entries:
+
+ - None, one or more links to devices with name equal to names
+   of the corresponding devices.
+
+ - trace_level - allows to enable and disable various tracing
+   facilities. See content of this file for help how to use it.
+
+ - mgmt - main management entry, which allows to add/delete VDISK
+   devices with the corresponding type.
+
+The "mgmt" file has the following commands, which you can send to it,
+for instance, using "echo" shell command. You can always get a small
+help about supported commands by looking inside this file. "Parameters=
"
+are one or more param_name=3Dvalue pairs separated by ';'.
+
+ - echo "add_device device_name [parameters]" - adds a virtual device
+   with name device_name and specified parameters (see below)
+
+ - echo "del_device device_name" - deletes a virtual device with name
+   device_name.
+
+Handler vdisk_fileio provides FILEIO mode to create virtual devices.
+This mode uses as backend files and accesses to them using regular
+read()/write() file calls. This allows to use full power of Linux page
+cache. The following parameters possible for vdisk_fileio:
+
+ - filename - specifies path and file name of the backend file. The pa=
th
+   must be absolute.
+
+ - blocksize - specifies block size used by this virtual device. The
+   block size must be power of 2 and >=3D 512 bytes. Default is 512.
+
+ - write_through - disables write back caching. Note, this option
+   has sense only if you also *manually* disable write-back cache in
+   *all* your backstorage devices and make sure it's actually disabled=
,
+   since many devices are known to lie about this mode to get better
+   benchmark results. Default is 0.
+
+ - read_only - read only. Default is 0.
+
+ - o_direct - disables both read and write caching. This mode isn't
+   currently fully implemented, you should use user space fileio_tgt
+   program in O_DIRECT mode instead (see below).
+
+ - nv_cache - enables "non-volatile cache" mode. In this mode it is
+   assumed that the target has a GOOD UPS with ability to cleanly
+   shutdown target in case of power failure and it is software/hardwar=
e
+   bugs free, i.e. all data from the target's cache are guaranteed
+   sooner or later to go to the media. Hence all data synchronization
+   with media operations, like SYNCHRONIZE_CACHE, are ignored in order
+   to bring more performance. Also in this mode target reports to
+   initiators that the corresponding device has write-through cache to
+   disable all write-back cache workarounds used by initiators. Use wi=
th
+   extreme caution, since in this mode after a crash of the target
+   journaled file systems don't guarantee the consistency after journa=
l
+   recovery, therefore manual fsck MUST be ran. Note, that since usual=
ly
+   the journal barrier protection (see "IMPORTANT" note below) turned
+   off, enabling NV_CACHE could change nothing from data protection
+   point of view, since no data synchronization with media operations
+   will go from the initiator. This option overrides "write_through"
+   option. Disabled by default.
+
+ - thin_provisioned - enables thin provisioning facility, when remote
+   initiators can unmap blocks of storage, if they don't need them
+   anymore. Backend storage also must support this facility.
+
+ - removable - with this flag set the device is reported to remote
+   initiators as removable.
+
+Handler vdisk_blockio provides BLOCKIO mode to create virtual devices.
+This mode performs direct block I/O with a block device, bypassing the
+page cache for all operations. This mode works ideally with high-end
+storage HBAs and for applications that either do not need caching
+between application and disk or need the large block throughput. See
+below for more info.
+
+The following parameters possible for vdisk_blockio: filename,
+blocksize, nv_cache, read_only, removable, thin_provisioned. See
+vdisk_fileio above for description of those parameters.
+
+Handler vdisk_nullio provides NULLIO mode to create virtual devices. I=
n
+this mode no real I/O is done, but success returned to initiators.
+Intended to be used for performance measurements at the same way as
+"*_perf" handlers. The following parameters possible for vdisk_nullio:
+blocksize, read_only, removable. See vdisk_fileio above for descriptio=
n
+of those parameters.
+
+Handler vcdrom allows emulation of a virtual CDROM device using an ISO
+file as backend. It doesn't have any parameters.
+
+For example:
+
+echo "add_device disk1 filename=3D/disk1; blocksize=3D4096; nv_cache=3D=
1" >/sys/kernel/scst_tgt/handlers/vdisk_fileio/mgmt
+
+will create a FILEIO virtual device disk1 with backend file /disk1
+with block size 4K and NV_CACHE enabled.
+
+Each vdisk_fileio's device has the following attributes in
+/sys/kernel/scst_tgt/devices/device_name:
+
+ - filename - contains path and file name of the backend file.
+
+ - blocksize - contains block size used by this virtual device.
+
+ - write_through - contains status of write back caching of this virtu=
al
+   device.
+
+ - read_only - contains read only status of this virtual device.
+
+ - o_direct - contains O_DIRECT status of this virtual device.
+
+ - nv_cache - contains NV_CACHE status of this virtual device.
+
+ - thin_provisioned - contains thin provisioning status of this virtua=
l
+   device
+
+ - removable - contains removable status of this virtual device.
+
+ - size_mb - contains size of this virtual device in MB.
+
+ - t10_dev_id - contains and allows to set T10 vendor specific
+   identifier for Device Identification VPD page (0x83) of INQUIRY dat=
a.
+   By default VDISK handler always generates t10_dev_id for every new
+   created device at creation time based on the device name and
+   scst_vdisk_ID scst_vdisk.ko module parameter (see below).
+
+ - usn - contains the virtual device's serial number of INQUIRY data. =
It
+   is created at the device creation time based on the device name and
+   scst_vdisk_ID scst_vdisk.ko module parameter (see below).
+
+ - type - contains SCSI type of this virtual device.
+
+ - resync_size - write only attribute, which makes vdisk_fileio to
+   rescan size of the backend file. It is useful if you changed it, fo=
r
+   instance, if you resized it.
+
+For example:
+
+/sys/kernel/scst_tgt/devices/disk1
+|-- blocksize
+|-- exported
+|   |-- export0 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt/lun=
s/0
+|   |-- export1 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt/ini=
_groups/INI/luns/0
+|   |-- export2 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt1/lu=
ns/0
+|   |-- export3 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt1/in=
i_groups/INI1/luns/0
+|   |-- export4 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt1/in=
i_groups/INI2/luns/0
+|-- filename
+|-- handler -> ../../handlers/vdisk_fileio
+|-- nv_cache
+|-- o_direct
+|-- read_only
+|-- removable
+|-- resync_size
+|-- size_mb
+|-- t10_dev_id
+|-- thin_provisioned
+|-- threads_num
+|-- threads_pool_type
+|-- type
+|-- usn
+`-- write_through
+
+Each vdisk_blockio's device has the following attributes in
+/sys/kernel/scst_tgt/devices/device_name: blocksize, filename, nv_cach=
e,
+read_only, removable, resync_size, size_mb, t10_dev_id,
+thin_provisioned, threads_num, threads_pool_type, type, usn. See above
+description of those parameters.
+
+Each vdisk_nullio's device has the following attributes in
+/sys/kernel/scst_tgt/devices/device_name: blocksize, read_only,
+removable, size_mb, t10_dev_id, threads_num, threads_pool_type, type,
+usn. See above description of those parameters.
+
+Each vcdrom's device has the following attributes in
+/sys/kernel/scst_tgt/devices/device_name: filename, size_mb,
+t10_dev_id, threads_num, threads_pool_type, type, usn. See above
+description of those parameters. Exception is filename attribute. For
+vcdrom it is writable. Writing to it allows to virtually insert or
+change virtual CD media in the virtual CDROM device. For example:
+
+ - echo "/image.iso" >/sys/kernel/scst_tgt/devices/cdrom/filename - wi=
ll
+   insert file /image.iso as virtual media to the virtual CDROM cdrom.
+
+ - echo "" >/sys/kernel/scst_tgt/devices/cdrom/filename - will remove
+   "media" from the virtual CDROM cdrom.
+
+Additionally VDISK handler has module parameter "num_threads", which
+specifies count of I/O threads for each FILEIO VDISK's or VCDROM devic=
e.
+If you have a workload, which tends to produce rather random accesses
+(e.g. DB-like), you should increase this count to a bigger value, like
+32. If you have a rather sequential workload, you should decrease it t=
o
+a lower value, like number of CPUs on the target or even 1. Due to som=
e
+limitations of Linux I/O subsystem, increasing number of I/O threads t=
oo
+much leads to sequential performance drop, especially with deadline
+scheduler, so decreasing it can improve sequential performance. The
+default provides a good compromise between random and sequential
+accesses.
+
+You shouldn't be afraid to have too many VDISK I/O threads if you have
+many VDISK devices. Kernel threads consume very little amount of
+resources (several KBs) and only necessary threads will be used by SCS=
T,
+so the threads will not trash your system.
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
+
+Persistent Reservations
+-----------------------
+
+SCST implements Persistent Reservations with full set of capabilities,
+including "Persistence Through Power Loss".
+
+The "Persistence Through Power Loss" data are saved in /var/lib/scst/p=
r
+with files with names the same as the names of the corresponding
+devices. Also this directory contains backup versions of those files
+with suffix ".1". Those backup files are used in case of power or othe=
r
+failure to prevent Persistent Reservation information from corruption
+during update.
+
+The Persistent Reservations available on all transports implementing
+get_initiator_port_transport_id() callback. Transports not implementin=
g
+this callback will act in one of 2 possible scenarios ("all or
+nothing"):
+
+1. If a device has such transport connected and doesn't have persisten=
t
+reservations, it will refuse Persistent Reservations commands as if it
+doesn't support them.
+
+2. If a device has persistent reservations, all initiators newly
+connecting via such transports will not see this device. After all
+persistent reservations from this device are released, upon reconnect
+the initiators will see it.
+
+
+Caching
+-------
+
+By default for performance reasons VDISK FILEIO devices use write back
+caching policy.
+
+Generally, write back caching is safe for use and danger of it is
+greatly overestimated, because most modern (especially, Enterprise
+level) applications are well prepared to work with write back cached
+storage. Particularly, such are all transactions-based applications.
+Those applications flush cache to completely avoid ANY data loss on a
+crash or power failure. For instance, journaled file systems flush cac=
he
+on each meta data update, so they survive power/hardware/software
+failures pretty well.
+
+Since locally on initiators write back caching is always on, if an
+application cares about its data consistency, it does flush the cache
+when necessary or on any write, if open files with O_SYNC. If it doesn=
't
+care, it doesn't flush the cache. As soon as the cache flushes
+propagated to the storage, write back caching on it doesn't make any
+difference. If application doesn't flush the cache, it's doomed to loo=
se
+data in case of a crash or power failure doesn't matter where this cac=
he
+located, locally or on the storage.
+
+To illustrate that consider, for example, a user who wants to copy /sr=
c
+directory to /dst directory reliably, i.e. after the copy finished no
+power failure or software/hardware crash could lead to a loss of the
+data in /dst. There are 2 ways to achieve this. Let's suppose for
+simplicity cp opens files for writing with O_SYNC flag, hence bypassin=
g
+the local cache.
+
+1. Slow. Make the device behind /dst working in write through caching
+mode and then run "cp -a /src /dst".
+
+2. Fast. Let the device behind /dst working in write back caching mode
+and then run "cp -a /src /dst; sync". The reliability of the result is
+the same, but it's much faster than (1). Nobody would care if a crash
+happens during the copy, because after recovery simply leftovers from
+the not completed attempt would be deleted and the operation would be
+restarted from the very beginning.
+
+So, you can see in (2) there is no danger of ANY data loss from the
+write back caching. Moreover, since on practice cp doesn't open files
+for writing with O_SYNC flag, to get the copy done reliably, sync
+command must be called after cp anyway, so enabling write back caching
+wouldn't make any difference for reliability.
+
+Also you can consider it from another side. Modern HDDs have at least
+16MB of cache working in write back mode by default, so for a 10 drive=
s
+RAID it is 160MB of a write back cache. How many people are happy with
+it and how many disabled write back cache of their HDDs? Almost all an=
d
+almost nobody correspondingly? Moreover, many HDDs lie about state of
+their cache and report write through while working in write back mode.
+They are also successfully used.
+
+Note, Linux I/O subsystem guarantees to propagated cache flushes to th=
e
+storage only using data protection barriers, which usually turned off =
by
+default (see http://lwn.net/Articles/283161). Without barriers enabled
+Linux doesn't provide a guarantee that after sync()/fsync() all writte=
n
+data really hit permanent storage. They can be stored in the cache of
+your backstorage devices and, hence, lost on a power failure event.
+Thus, ever with write-through cache mode, you still either need to
+enable barriers on your backend file system on the target (for direct
+/dev/sdX devices this is, indeed, impossible), or need a good UPS to
+protect yourself from not committed data loss. Some info about barrier=
s
+from the XFS point of view could be found at
+http://oss.sgi.com/projects/xfs/faq.html#wcache. On Linux initiators f=
or
+Ext3 and ReiserFS file systems the barrier protection could be turned =
on
+using "barrier=3D1" and "barrier=3Dflush" mount options correspondingl=
y. You
+can check if the barriers turn on or off by looking in /proc/mounts.
+Windows and, AFAIK, other UNIX'es don't need any special explicit
+options and do necessary barrier actions on write-back caching devices
+by default.
+
+To limit this data loss with write back caching you can use files in
+/proc/sys/vm to limit amount of unflushed data in the system cache.
+
+If you for some reason have to use VDISK FILEIO devices in write throu=
gh
+caching mode, don't forget to disable internal caching on their backen=
d
+devices or make sure they have additional battery or supercapacitors
+power supply on board. Otherwise, you still on a power failure would
+loose all the unsaved yet data in the devices internal cache.
+
+Note, on some real-life workloads write through caching might perform
+better, than write back one with the barrier protection turned on.
+
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
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  each other, if you try to use a device in=
 both those modes
+	   simultaneously, you will almost instantly corrupt your data
+	   on that device.
+
+IMPORTANT: If SCST 1.x BLOCKIO worked by default in NV_CACHE mode, whe=
n
+=3D=3D=3D=3D=3D=3D=3D=3D=3D  each device reported to remote initiators=
 as having write through
+           caching. But if your backend block device has internal writ=
e
+	   back caching it might create a possibility for data loss of
+	   the cached in the internal cache data in case of a power
+	   failure. Starting from SCST 2.0 BLOCKIO works by default in
+	   non-NV_CACHE mode, when each device reported to remote
+	   initiators as having write back caching, and synchronizes the
+	   internal device's cache on each SYNCHRONIZE_CACHE command
+	   from the initiators. It might lead to some PERFORMANCE LOSS,
+	   so if you are are sure in your power supply and want to
+	   restore 1.x behavior, your should recreate your BLOCKIO
+	   devices in NV_CACHE mode.
+
+
+Pass-through mode
+-----------------
+
+In the pass-through mode (i.e. using the pass-through device handlers
+scst_disk, scst_tape, etc) SCSI commands, coming from remote initiator=
s,
+are passed to local SCSI devices on target as is, without any
+modifications.
+
+SCST supports 1 to many pass-through, when several initiators can safe=
ly
+connect a single pass-through device (a tape, for instance). For such
+cases SCST emulates all the necessary functionality.
+
+In the sysfs interface all real SCSI devices are listed in
+/sys/kernel/scst_tgt/devices in form host:channel:id:lun numbers, for
+instance 1:0:0:0. The recommended way to match those numbers to your
+devices is use of lsscsi utility.
+
+Each pass-through dev handler has in its root subdirectory
+/sys/kernel/scst_tgt/handlers/handler_name, e.g.
+/sys/kernel/scst_tgt/handlers/dev_disk, "mgmt" file. It allows the
+following commands. They can be sent to it using, e.g., echo command.
+
+ - "add_device" - this command assigns SCSI device with
+host:channel:id:lun numbers to this dev handler.
+
+echo "add_device 1:0:0:0" >/sys/kernel/scst_tgt/handlers/dev_disk/mgmt
+
+will assign SCSI device 1:0:0:0 to this dev handler.
+
+ - "del_device" - this command unassigns SCSI device with
+host:channel:id:lun numbers from this dev handler.
+
+As usually, on read the "mgmt" file returns small help about available
+commands.
+
+You need to manually assign each your real SCSI device to the
+corresponding pass-through dev handler using the "add_device" command,
+otherwise the real SCSI devices will not be visible remotely. The
+assignment isn't done automatically, because it could lead to the
+pass-through dev handlers load and initialization problems if any of t=
he
+local real SCSI devices are malfunctioning.
+
+As any other hardware, the local SCSI hardware can not handle commands
+with amount of data and/or segments count in scatter-gather array bigg=
er
+some values. Therefore, when using the pass-through mode you should no=
te
+that values for maximum number of segments and maximum amount of
+transferred data for each SCSI command on devices on initiators can no=
t
+be bigger, than corresponding values of the corresponding SCSI devices
+on the target. Otherwise you will see symptoms like small transfers wo=
rk
+well, but large ones stall and messages like: "Unable to complete
+command due to SG IO count limitation" are printed in the kernel logs.
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
+Another way to solve this issue is to build SG entries with more than =
1
+page each. See the following patch as an example:
+http://scst.sourceforge.net/sgv_big_order_alloc.diff
+
+
+Performance
+-----------
+
+SCST from the very beginning has been designed and implemented to
+provide the best possible performance. Since there is no "one fit all"
+the best performance configuration for different setups and loads, SCS=
T
+provides extensive set of settings to allow to tune it for the best
+performance in each particular case. You don't have to necessary use
+those settings. If you don't, SCST will do very good job to autotune f=
or
+you, so the resulting performance will, in average, be better
+(sometimes, much better) than with other SCSI targets. But in some cas=
es
+you can by manual tuning improve it even more.
+
+Before doing any performance measurements note that performance result=
s
+are very much dependent from your type of load, so it is crucial that
+you choose access mode (FILEIO, BLOCKIO, O_DIRECT, pass-through), whic=
h
+suits your needs the best.
+
+In order to get the maximum performance you should:
+
+1. For SCST:
+
+ - Disable in Makefile CONFIG_SCST_STRICT_SERIALIZING, CONFIG_SCST_EXT=
RACHECKS,
+   CONFIG_SCST_TRACING, CONFIG_SCST_DEBUG*, CONFIG_SCST_STRICT_SECURIT=
Y,
+   CONFIG_SCST_MEASURE_LATENCY
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
+4. Make sure you have io_grouping_type option set correctly, especiall=
y
+in the following cases:
+
+ - Several initiators share your target's backstorage. It can be a
+   shared LU using some cluster FS, like VMFS, as well as can be
+   different LUs located on the same backstorage (RAID array). For
+   instance, if you have 3 initiators and each of them using its own
+   dedicated FILEIO device file from the same RAID-6 array on the
+   target.
+
+   In this case for the best performance you should have
+   io_grouping_type option set in value "never" in all the LUNs' targe=
ts
+   and security groups.
+
+ - Your initiator connected to your target in MPIO mode. In this case =
for
+   the best performance you should:
+
+    * Either connect all the sessions from the initiator to a single
+      target or security group and have io_grouping_type option set in
+      value "this_group_only" in the target or security group,
+
+    * Or, if it isn't possible to connect all the sessions from the
+      initiator to a single target or security group, assign the same
+      numeric io_grouping_type value for each target/security group th=
is
+      initiator connected to. The exact value itself doesn't matter,
+      important only that all the targets/security groups use the same
+      value.
+
+Don't forget, io_grouping_type makes sense only if you use CFQ I/O
+scheduler on the target and for devices with threads_num >=3D 0 and, i=
f
+threads_num > 0, with threads_pool_type "per_initiator".
+
+You can check if in your setup io_grouping_type set correctly as well =
as
+if the "auto" io_grouping_type value works for you by tests like the
+following:
+
+ - For not MPIO case you can run single thread sequential reading, e.g=
=2E
+   using buffered dd, from one initiator, then run the same single
+   thread sequential reading from the second initiator in parallel. If
+   io_grouping_type is set correctly the aggregate throughput measured
+   on the target should only slightly decrease as well as all initiato=
rs
+   should have nearly equal share of it. If io_grouping_type is not se=
t
+   correctly, the aggregate throughput and/or throughput on any
+   initiator will decrease significantly, in 2 times or even more. For
+   instance, you have 80MB/s single thread sequential reading from the
+   target on any initiator. When then both initiators are reading in
+   parallel you should see on the target aggregate throughput somethin=
g
+   like 70-75MB/s with correct io_grouping_type and something like
+   35-40MB/s or 8-10MB/s on any initiator with incorrect.
+
+ - For the MPIO case it's quite easier. With incorrect io_grouping_typ=
e
+   you simply won't see performance increase from adding the second
+   session (assuming your hardware is capable to transfer data through
+   both sessions in parallel), or can even see a performance decrease.
+
+5. If you are going to use your target in an VM environment, for
+instance as a shared storage with VMware, make sure all your VMs
+connected to the target via *separate* sessions. For instance, for iSC=
SI
+it means that each VM has own connection to the target, not all VMs
+connected using a single connection. You can check it using SCST sysfs
+interface. For other transports you should use available facilities,
+like NPIV for Fibre Channel, to make separate sessions for each VM. If
+you miss it, you can greatly loose performance of parallel access to
+your target from different VMs. This isn't related to the case if your
+VMs are using the same shared storage, like with VMFS, for instance. I=
n
+this case all your VM hosts will be connected to the target via separa=
te
+sessions, which is enough.
+
+6. For other target and initiator software parts:
+
+ - Make sure you applied on your kernel all available SCST patches.
+   If for your kernel version this patch doesn't exist, it is strongly
+   recommended to upgrade your kernel to version, for which this patch
+   exists.
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
+   SCSI command. This tuning is also recommended on targets with large
+   read-ahead values. To do it on Linux, run:
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
+   Note2: you need to restart SCST after you changed read-ahead settin=
gs
+   on the target.
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
+ - On the target use CFQ IO scheduler. In most cases it has performanc=
e
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
+7. For hardware on target.
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
+8. If you use VDISK IO module in FILEIO mode, NV_CACHE option will
+provide you the best performance. But using it make sure you use a goo=
d
+UPS with ability to shutdown the target on the power failure.
+
+Baseline performance numbers you can find in those measurements:
+http://lkml.org/lkml/2009/3/30/283.
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
+9. In some cases, for instance working with SSD devices, which consume
+100% of a single CPU load for data transfers in their internal threads=
,
+to maximize IOPS it can be needed to assign for those threads dedicate=
d
+CPUs. Consider using cpu_mask attribute for devices with
+threads_pool_type "per_initiator" or Linux CPU affinity facilities for
+other threads_pool_types. No IRQ processing should be done on those
+CPUs. Check that using /proc/interrupts. See taskset command and
+Documentation/IRQ-affinity.txt in your kernel's source tree for how to
+assign IRQ affinity to tasks and IRQs.
+
+The reason for that is that processing of coming commands in SIRQ
+context might be done on the same CPUs as SSD devices' threads doing d=
ata
+transfers. As the result, those threads won't receive all the processi=
ng
+power of those CPUs and perform worse.
+
+
+Work if target's backstorage or link is too slow
+------------------------------------------------
+
+Under high I/O load, when your target's backstorage gets overloaded, o=
r
+working over a slow link between initiator and target, when the link
+can't serve all the queued commands on time, you can experience I/O
+stalls or see in the kernel log abort or reset messages.
+
+At first, consider the case of too slow target's backstorage. On some
+seek intensive workloads even fast disks or RAIDs, which able to serve
+continuous data stream on 500+ MB/s speed, can be as slow as 0.3 MB/s.
+Another possible cause for that can be MD/LVM/RAID on your target as i=
n
+http://lkml.org/lkml/2008/2/27/96 (check the whole thread as well).
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
+there are 6 possible actions, which you can do to workaround or fix th=
is
+issue in this case:
+
+1. Ignore incoming task management (TM) commands. It's fine if there a=
re
+not too many of them, so average performance isn't hurt and the
+corresponding device isn't getting put offline, i.e. if the backstorag=
e
+isn't too slow.
+
+2. Decrease /sys/block/sdX/device/queue_depth on the initiator in case
+if it's Linux (see below how) or/and SCST_MAX_TGT_DEV_COMMANDS constan=
t
+in scst_priv.h file until you stop seeing incoming TM commands.
+ISCSI-SCST driver also has its own iSCSI specific parameter for that,
+see its README file.
+
+To decrease device queue depth on Linux initiators you can run command=
:
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
+3. Increase the corresponding timeout on the initiator. For Linux it i=
s
+located in
+/sys/devices/platform/host*/session*/target*:0:0/*:0:0:1/timeout. It c=
an
+be done automatically by an udev rule. For instance, the following
+rule will increase it to 300 seconds:
+
+SUBSYSTEM=3D=3D"scsi", KERNEL=3D=3D"[0-9]*:[0-9]*", ACTION=3D=3D"add",=
 ATTR{type}=3D=3D"0|7|14", ATTR{timeout}=3D"300"
+
+By default, this timeout is 30 or 60 seconds, depending on your distri=
bution.
+
+4. Try to avoid such seek intensive workloads.
+
+5. Increase speed of the target's backstorage.
+
+6. Implement in SCST dynamic I/O flow control. This will be an ultimat=
e
+solution. See "Dynamic I/O flow control" section on
+http://scst.sourceforge.net/contributing.html page for possible
+implementation idea.
+
+Next, consider the case of too slow link between initiator and target,
+when the initiator tries to simultaneously push N commands to the targ=
et
+over it. In this case time to serve those commands, i.e. send or recei=
ve
+data for them over the link, can be more, than timeout for any single
+command, hence one or more commands in the tail of the queue can not b=
e
+served on time less than the timeout, so the initiator will decide tha=
t
+they are stuck on the target and will try to recover.
+
+To workaround/fix this issue in this case you can use ways 1, 2, 3, 6
+above or (7): increase speed of the link between target and initiator.
+But for some initiators implementations for WRITE commands there might
+be cases when target has no way to detect the issue, so dynamic I/O fl=
ow
+control will not be able to help. In those cases you could also need o=
n
+the initiator(s) to either decrease the queue depth (way 2), or increa=
se
+the corresponding timeout (way 3).
+
+Note, that logged messages about QUEUE_FULL status are quite different
+by nature. This is a normal work, just SCSI flow control in action.
+Simply don't enable "mgmt_minor" logging level, or, alternatively, if
+you are confident in the worst case performance of your back-end stora=
ge
+or initiator-target link, you can increase SCST_MAX_TGT_DEV_COMMANDS i=
n
+scst_priv.h to 64. Usually initiators don't try to push more commands =
on
+the target.
+
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
+ * Ross S. W. Walker <rswwalker@hotmail.com> for BLOCKIO inspiration
+   and Vu Pham <huongvp@yahoo.com> who implemented it for VDISK dev ha=
ndler.
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
+ * Daniel Debonzi <debonzi@linux.vnet.ibm.com> for a big part of the
+   initial SCST sysfs tree implementation
+
+
+Vladislav Bolkhovitin <vst@vlnb.net>, http://scst.sourceforge.net
diff -uprN orig/linux-2.6.35/Documentation/scst/SysfsRules linux-2.6.35=
/Documentation/scst/SysfsRules
--- orig/linux-2.6.35/Documentation/scst/SysfsRules
+++ linux-2.6.35/Documentation/scst/SysfsRules
@@ -0,0 +1,942 @@
+		SCST SYSFS interface rules
+		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+This file describes SYSFS interface rules, which all SCST target
+drivers, dev handlers and management utilities MUST follow. This allow=
s
+to have a simple, self-documented, target drivers and dev handlers
+independent management interface.
+
+Words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
+"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
+document are to be interpreted as described in RFC 2119.
+
+In this document "key attribute" means a configuration attribute with
+not default value, which must be configured during the target driver's
+initialization. A key attribute MUST have in the last line keyword
+"[key]". If a default value set to a key attribute, it becomes a regul=
ar
+none-key attribute. For instance, iSCSI target has attribute DataDiges=
t.
+Default value for this attribute is "None". It value "CRC32C" is set t=
o
+this attribute, it will become a key attribute. If value "None" is aga=
in
+set, this attribute will become back to a none-key attribute.
+
+Each user configurable attribute with a not default value MUST be mark=
ed
+as key attribute.
+
+Key attributes SHOULD NOT have sysfs names finished on digits, because
+such names SHOULD be used to store several attributes with the same na=
me
+on the sysfs tree where duplicated names are not allowed. For instance=
,
+iSCSI targets can have several incoming user names, so the correspondi=
ng
+attribute should have sysfs name "IncomingUser". If there are 2 user
+names, they should have sysfs names "IncomingUser" and "IncomingUser1"=
=2E
+In other words, all "IncomingUser[0-9]*" names should be considered as
+different instances of the same "IncomingUser" attribute.
+
+
+I. Rules for target drivers
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+SCST core for each target driver (struct scst_tgt_template) creates a
+root subdirectory in /sys/kernel/scst_tgt/targets with name
+scst_tgt_template.name (called "target_driver_name" further in this
+document).
+
+For each target (struct scst_tgt) SCST core creates a root subdirector=
y
+in /sys/kernel/scst_tgt/targets/target_driver_name with name
+scst_tgt.tgt_name (called "target_name" further in this document).
+
+There are 2 type of targets possible: hardware and virtual targets.
+Hardware targets are targets corresponding to real hardware, for
+instance, a Fibre Channel adapter's port. Virtual targets are hardware
+independent targets, which can be dynamically added or removed, for
+instance, an iSCSI target, or NPIV Fibre Channel target.
+
+A target driver supporting virtual targets MUST support "mgmt" attribu=
te
+and "add_target"/"del_target" commands.
+
+If target driver supports both hardware and virtual targets (for
+instance, an FC adapter supporting NPIV, which has hardware targets fo=
r
+its physical ports as well as virtual NPIV targets), it MUST create ea=
ch
+hardware target with hw_target mark to make SCST core create "hw_targe=
t"
+attribute (see below).
+
+Attributes for target drivers
+-----------------------------
+
+A target driver MAY support in its root subdirectory the following
+optional attributes. Target drivers MAY also support there other
+read-only or read-writable attributes.
+
+1. "enabled" - this attribute MUST allow to enable and disable target
+driver as a whole, i.e. if disabled, the target driver MUST NOT accept
+new connections. The goal of this attribute is to allow the target
+driver's initial configuration. For instance, iSCSI target may need to
+have discovery user names and passwords set before it starts serving
+discovery connections.
+
+This attribute MUST have read and write permissions for superuser and =
be
+read-only for other users.
+
+On read it MUST return 0, if the target driver is disabled, and 1, if =
it
+is enabled.
+
+On write it MUST accept '0' character as request to disable and '1' as
+request to enable, but MAY also accept other driver specific commands.
+
+During disabling the target driver MAY close already connected session=
s
+in all targets, but this is OPTIONAL.
+
+MUST be 0 by default.
+
+2. "trace_level" - this attribute SHOULD allow to change log level of =
this
+driver.
+
+This attribute SHOULD have read and write permissions for superuser an=
d be
+read-only for other users.
+
+On read it SHOULD return a help text about available command and log l=
evels.
+
+On write it SHOULD accept commands to change log levels according to t=
he
+help text.
+
+For example:
+
+out_of_mem | minor | pid | line | function | special | mgmt | mgmt_dbg=
 | flow_control | conn
+
+Usage:
+        echo "all|none|default" >trace_level
+        echo "value DEC|0xHEX|0OCT" >trace_level
+        echo "add|del TOKEN" >trace_level
+
+where TOKEN is one of [debug, function, line, pid,
+		       entryexit, buff, mem, sg, out_of_mem,
+		       special, scsi, mgmt, minor,
+		       mgmt_dbg, scsi_serializing,
+		       retry, recv_bot, send_bot, recv_top,
+		       send_top, d_read, d_write, conn, conn_dbg, iov, pdu, net_page=
]
+
+
+3. "version" - this read-only for all attribute SHOULD return version =
of
+the target driver and some info about its enabled compile time facilit=
ies.
+
+For example:
+
+2.0.0
+EXTRACHECKS
+DEBUG
+
+4. "mgmt" - if supported this attribute MUST allow to add and delete
+targets, if virtual targets are supported by this driver, as well as i=
t
+MAY allow to add and delete the target driver's or its targets'
+attributes.
+
+This attribute MUST have read and write permissions for superuser and =
be
+read-only for other users.
+
+On read it MUST return a help string describing available commands,
+parameters and attributes.
+
+To achieve that the target driver should just set in its struct
+scst_tgt_template correctly the following fields: mgmt_cmd_help,
+add_target_parameters, tgtt_optional_attributes and
+tgt_optional_attributes.
+
+For example:
+
+Usage: echo "add_target target_name [parameters]" >mgmt
+       echo "del_target target_name" >mgmt
+       echo "add_attribute <attribute> <value>" >mgmt
+       echo "del_attribute <attribute> <value>" >mgmt
+       echo "add_target_attribute target_name <attribute> <value>" >mg=
mt
+       echo "del_target_attribute target_name <attribute> <value>" >mg=
mt
+
+where parameters are one or more param_name=3Dvalue pairs separated by=
 ';'
+
+The following target driver attributes available: IncomingUser, Outgoi=
ngUser
+The following target attributes available: IncomingUser, OutgoingUser,=
 allowed_portal
+
+4.1. "add_target" - if supported, this command MUST add new target wit=
h
+name "target_name" and specified optional or required parameters. Each
+parameter MUST be in form "parameter=3Dvalue". All parameters MUST be
+separated by ';' symbol.
+
+All target drivers supporting creation of virtual targets MUST support
+this command.
+
+All target drivers supporting "add_target" command MUST support all
+read-only targets' key attributes as parameters to "add_target" comman=
d
+with the attributes' names as parameters' names and the attributes'
+values as parameters' values.
+
+For example:
+
+echo "add_target TARGET1 parameter1=3D1; parameter2=3D2" >mgmt
+
+will add target with name "TARGET1" and parameters with names
+"parameter1" and "parameter2" with values 1 and 2 correspondingly.
+
+4.2. "del_target" - if supported, this command MUST delete target with
+name "target_name". If "add_target" command is supported "del_target"
+MUST also be supported.
+
+4.3. "add_attribute" - if supported, this command MUST add a target
+driver's attribute with the specified name and one or more values.
+
+All target drivers supporting run time creation of the target driver's
+key attributes MUST support this command.
+
+For example, for iSCSI target:
+
+echo "add_attribute IncomingUser name password" >mgmt
+
+will add for discovery sessions an incoming user (attribute
+/sys/kernel/scst_tgt/targets/iscsi/IncomingUser) with name "name" and
+password "password".
+
+4.4. "del_attribute" - if supported, this command MUST delete  target
+driver's attribute with the specified name and values. The values MUST
+be specified, because in some cases attributes MAY internally be
+distinguished by values. For instance, iSCSI target might have several
+incoming users. If not needed, target driver might ignore the values.
+
+If "add_attribute" command is supported "del_attribute" MUST
+also be supported.
+
+4.5. "add_target_attribute" - if supported, this command MUST add new
+attribute for the specified target with the specified name and one or
+more values.
+
+All target drivers supporting run time creation of targets' key
+attributes MUST support this command.
+
+For example:
+
+echo "add_target_attribute iqn.2006-10.net.vlnb:tgt IncomingUser name =
password" >mgmt
+
+will add for target with name "iqn.2006-10.net.vlnb:tgt" an incoming
+user (attribute
+/sys/kernel/scst_tgt/targets/iscsi/iqn.2006-10.net.vlnb:tgt/IncomingUs=
er)
+with name "name" and password "password".
+
+4.6. "del_target_attribute" - if supported, this command MUST delete
+target's attribute with the specified name and values. The values MUST
+be specified, because in some cases attributes MAY internally be
+distinguished by values. For instance, iSCSI target might have several
+incoming users. If not needed, target driver might ignore the values.
+
+If "add_target_attribute" command is supported "del_target_attribute"
+MUST also be supported.
+
+Attributes for targets
+----------------------
+
+Each target MAY support in its root subdirectory the following optiona=
l
+attributes. Target drivers MAY also support there other read-only or
+read-writable attributes.
+
+1. "enabled" - this attribute MUST allow to enable and disable the
+corresponding target, i.e. if disabled, the target MUST NOT accept new
+connections. The goal of this attribute is to allow the target's initi=
al
+configuration. For instance, each target needs to have its LUNs setup
+before it starts serving initiators. Another example is iSCSI target,
+which may need to have initialized a number of iSCSI parameters before
+it starts accepting new iSCSI connections.
+
+This attribute MUST have read and write permissions for superuser and =
be
+read-only for other users.
+
+On read it MUST return 0, if the target is disabled, and 1, if it is
+enabled.
+
+On write it MUST accept '0' character as request to disable and '1' as
+request to enable. Other requests MUST be rejected.
+
+SCST core provides some facilities, which MUST be used to implement th=
is
+attribute.
+
+During disabling the target driver MAY close already connected session=
s
+to the target, but this is OPTIONAL.
+
+MUST be 0 by default.
+
+SCST core will automatically create for all targets the following
+attributes:
+
+1. "rel_tgt_id" - allows to read or write SCSI Relative Target Port
+Identifier attribute.
+
+2. "hw_target" - allows to distinguish hardware and virtual targets, i=
f
+the target driver supports both.
+
+To provide OPTIONAL force close session functionality target drivers
+MUST implement it using "force_close" write only session's attribute,
+which on write to it MUST close the corresponding session.
+
+See SCST core's README for more info about those attributes.
+
+
+II. Rules for dev handlers
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
+
+There are 2 types of dev handlers: parent dev handlers and children de=
v
+handlers. The children dev handlers depend from the parent dev handler=
s.
+
+SCST core for each parent dev handler (struct scst_dev_type with
+parent member with value NULL) creates a root subdirectory in
+/sys/kernel/scst_tgt/handlers with name scst_dev_type.name (called
+"dev_handler_name" further in this document).
+
+Parent dev handlers can have one or more subdirectories for children d=
ev
+handlers with names scst_dev_type.name of them.
+
+Only one level of the dev handlers' parent/children hierarchy is
+allowed. Parent dev handlers, which support children dev handlers, MUS=
T
+NOT handle devices and MUST be only placeholders for the children dev
+handlers.
+
+Further in this document children dev handlers or parent dev handlers,
+which don't support children, will be called "end level dev handlers".
+
+End level dev handlers can be recognized by existence of the "mgmt"
+attribute.
+
+For each device (struct scst_device) SCST core creates a root
+subdirectory in /sys/kernel/scst_tgt/devices/device_name with name
+scst_device.virt_name (called "device_name" further in this document).
+
+Attributes for dev handlers
+---------------------------
+
+Each dev handler MUST have it in its root subdirectory "mgmt" attribut=
e,
+which MUST support "add_device" and "del_device" attributes as describ=
ed
+below.
+
+Parent dev handlers and end level dev handlers without parents MAY
+support in its root subdirectory the following optional attributes. Th=
ey
+MAY also support there other read-only or read-writable attributes.
+
+1. "trace_level" - this attribute SHOULD allow to change log level of =
this
+driver.
+
+This attribute SHOULD have read and write permissions for superuser an=
d be
+read-only for other users.
+
+On read it SHOULD return a help text about available command and log l=
evels.
+
+On write it SHOULD accept commands to change log levels according to t=
he
+help text.
+
+For example:
+
+out_of_mem | minor | pid | line | function | special | mgmt | mgmt_dbg
+
+
+Usage:
+	echo "all|none|default" >trace_level
+	echo "value DEC|0xHEX|0OCT" >trace_level
+	echo "add|del TOKEN" >trace_level
+
+where TOKEN is one of [debug, function, line, pid,
+		       entryexit, buff, mem, sg, out_of_mem,
+		       special, scsi, mgmt, minor,
+		       mgmt_dbg, scsi_serializing,
+		       retry, recv_bot, send_bot, recv_top,
+		       send_top]
+
+2. "version" - this read-only for all attribute SHOULD return version =
of
+the dev handler and some info about its enabled compile time facilitie=
s.
+
+For example:
+
+2.0.0
+EXTRACHECKS
+DEBUG
+
+End level dev handlers in their root subdirectories MUST support "mgmt=
"
+attribute and MAY support other read-only or read-writable attributes.
+This attribute MUST have read and write permissions for superuser and =
be
+read-only for other users.
+
+Attribute "mgmt" for virtual devices dev handlers
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+For virtual devices dev handlers "mgmt" attribute MUST allow to add an=
d
+delete devices as well as it MAY allow to add and delete the dev
+handler's or its devices' attributes.
+
+On read it MUST return a help string describing available commands and
+parameters.
+
+To achieve that the dev handler should just set in its struct
+scst_dev_type correctly the following fields: mgmt_cmd_help,
+add_device_parameters, devt_optional_attributes and
+dev_optional_attributes.
+
+For example:
+
+Usage: echo "add_device device_name [parameters]" >mgmt
+       echo "del_device device_name" >mgmt
+       echo "add_attribute <attribute> <value>" >mgmt
+       echo "del_attribute <attribute> <value>" >mgmt
+       echo "add_device_attribute device_name <attribute> <value>" >mg=
mt
+       echo "del_device_attribute device_name <attribute> <value>" >mg=
mt
+
+where parameters are one or more param_name=3Dvalue pairs separated by=
 ';'
+
+The following parameters available: filename, blocksize, write_through=
, nv_cache, o_direct, read_only, removable
+The following device driver attributes available: AttributeX, Attribut=
eY
+The following device attributes available: AttributeDX, AttributeDY
+
+1. "add_device" - this command MUST add new device with name
+"device_name" and specified optional or required parameters. Each
+parameter MUST be in form "parameter=3Dvalue". All parameters MUST be
+separated by ';' symbol.
+
+All dev handlers supporting "add_device" command MUST support all
+read-only devices' key attributes as parameters to "add_device" comman=
d
+with the attributes' names as parameters' names and the attributes'
+values as parameters' values.
+
+For example:
+
+echo "add_device device1 parameter1=3D1; parameter2=3D2" >mgmt
+
+will add device with name "device1" and parameters with names
+"parameter1" and "parameter2" with values 1 and 2 correspondingly.
+
+2. "del_device" - this command MUST delete device with name
+"device_name".
+
+3. "add_attribute" - if supported, this command MUST add a device
+driver's attribute with the specified name and one or more values.
+
+All dev handlers supporting run time creation of the dev handler's
+key attributes MUST support this command.
+
+For example:
+
+echo "add_attribute AttributeX ValueX" >mgmt
+
+will add attribute
+/sys/kernel/scst_tgt/handlers/dev_handler_name/AttributeX with value V=
alueX.
+
+4. "del_attribute" - if supported, this command MUST delete device
+driver's attribute with the specified name and values. The values MUST
+be specified, because in some cases attributes MAY internally be
+distinguished by values. If not needed, dev handler might ignore the
+values.
+
+If "add_attribute" command is supported "del_attribute" MUST also be
+supported.
+
+5. "add_device_attribute" - if supported, this command MUST add new
+attribute for the specified device with the specified name and one or
+more values.
+
+All dev handlers supporting run time creation of devices' key attribut=
es
+MUST support this command.
+
+For example:
+
+echo "add_device_attribute device1 AttributeDX ValueDX" >mgmt
+
+will add for device with name "device1" attribute
+/sys/kernel/scst_tgt/devices/device_name/AttributeDX) with value
+ValueDX.
+
+6. "del_device_attribute" - if supported, this command MUST delete
+device's attribute with the specified name and values. The values MUST
+be specified, because in some cases attributes MAY internally be
+distinguished by values. If not needed, dev handler might ignore the
+values.
+
+If "add_device_attribute" command is supported "del_device_attribute"
+MUST also be supported.
+
+Attribute "mgmt" for pass-through devices dev handlers
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+For pass-through devices dev handlers "mgmt" attribute MUST allow to
+assign and unassign this dev handler to existing SCSI devices via
+"add_device" and "del_device" commands correspondingly.
+
+On read it MUST return a help string describing available commands and
+parameters.
+
+For example:
+
+Usage: echo "add_device H:C:I:L" >mgmt
+       echo "del_device H:C:I:L" >mgmt
+
+1. "add_device" - this command MUST assign SCSI device with
+host:channel:id:lun numbers to this dev handler.
+
+All pass-through dev handlers MUST support this command.
+
+For example:
+
+echo "add_device 1:0:0:0" >mgmt
+
+will assign SCSI device 1:0:0:0 to this dev handler.
+
+2. "del_device" - this command MUST unassign SCSI device with
+host:channel:id:lun numbers from this dev handler.
+
+SCST core will automatically create for all dev handlers the following
+attributes:
+
+1. "type" - SCSI type of device this dev handler can handle.
+
+See SCST core's README for more info about those attributes.
+
+Attributes for devices
+----------------------
+
+Each device MAY support in its root subdirectory any read-only or
+read-writable attributes.
+
+SCST core will automatically create for all devices the following
+attributes:
+
+1. "type" - SCSI type of this device
+
+See SCST core's README for more info about those attributes.
+
+
+III. Rules for management utilities
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Rules summary
+-------------
+
+A management utility (scstadmin) SHOULD NOT keep any knowledge specifi=
c
+to any device, dev handler, target or target driver. It SHOULD only kn=
ow
+the common SCST SYSFS rules, which all dev handlers and target drivers
+MUST follow. Namely:
+
+Common rules:
+~~~~~~~~~~~~~
+
+1. All key attributes MUST be marked by mark "[key]" in the last line =
of
+the attribute.
+
+2. All not key attributes don't matter and SHOULD be ignored.
+
+For target drivers and targets:
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+1. If target driver supports adding new targets, it MUST have "mgmt"
+attribute, which MUST support "add_target" and "del_target" commands a=
s
+specified above.
+
+2. If target driver supports run time adding new key attributes, it MU=
ST
+have "mgmt" attribute, which MUST support "add_attribute" and
+"del_attribute" commands as specified above.
+
+3. If target driver supports both hardware and virtual targets, all it=
s
+hardware targets MUST have "hw_target" attribute with value 1.
+
+4. If target has read-only key attributes, the add_target command MUST
+support them as parameters.
+
+5. If target supports run time adding new key attributes, the target
+driver MUST have "mgmt" attribute, which MUST support
+"add_target_attribute" and "del_target_attribute" commands as specifie=
d
+above.
+
+6. Both target drivers and targets MAY support "enable" attribute. If
+supported, after configuring the corresponding target driver or target
+"1" MUST be written to this attribute in the following order: at first=
,
+for all targets of the target driver, then for the target driver.
+
+For devices and dev handlers:
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+1. Each dev handler in its root subdirectory MUST have "mgmt" attribut=
e.
+
+2. Each dev handler MUST support "add_device" and "del_device" command=
s
+to the "mgmt" attribute as specified above.
+
+3. If dev handler driver supports run time adding new key attributes, =
it
+MUST support "add_attribute" and "del_attribute" commands to the "mgmt=
"
+attribute as specified above.
+
+4. All device handlers have links in the root subdirectory pointing to
+their devices.
+
+5. If device has read-only key attributes, the "add_device" command MU=
ST
+support them as parameters.
+
+6. If device supports run time adding new key attributes, its dev
+handler MUST support "add_device_attribute" and "del_device_attribute"
+commands to the "mgmt" attribute as specified above.
+
+7. Each device has "handler" link to its dev handler's root
+subdirectory.
+
+How to distinguish and process different types of attributes
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Since management utilities only interested in key attributes, they
+should simply ignore all non-key attributes, like
+devices/device_name/type or targets/target_driver/target_name/version
+doesn't matter if they are read-only or writable. So, the word "key"
+will be omitted later in this section.
+
+At first, any attribute can be a key attribute, doesn't matter how it'=
s
+created.
+
+All the existing on the configuration save time attributes should be
+treated the same. Management utilities shouldn't try to separate anyho=
w
+them in config files.
+
+1. Always existing attributes
+-----------------------------
+
+There are 2 type of them:
+
+1.1. Writable, like devices/device_name/t10_dev_id or
+targets/qla2x00tgt/target_name/explicit_confirmation. They are the
+simplest and all the values can just be read and written from/to them.
+
+On the configuration save time they can be distinguished as existing.
+
+On the write configuration time they can be distinguished as existing
+and writable.
+
+1.2. Read-only, like devices/fileio_device_name/filename or
+devices/fileio_device_name/block_size. They are also easy to distingui=
sh
+looking at the permissions.
+
+On the configuration save time they can be distinguished the same as f=
or
+(1.1) as existing.
+
+On the write configuration time they can be distinguished as existing
+and read-only. They all should be passed to "add_target" or
+"add_device" commands for virtual targets and devices correspondingly.
+To apply changes to them, the whole corresponding object
+(fileio_device_name in this example) should be removed then recreated.
+
+2. Optional
+-----------
+
+For instance, targets/iscsi/IncomingUser or
+targets/iscsi/target_name/IncomingUser. There are 4 types of them:
+
+2.1. Global for target drivers and dev handlers
+-----------------------------------------------
+
+For instance, targets/iscsi/IncomingUser or handlers/vdisk_fileio/XX
+(none at the moment).
+
+On the configuration save time they can be distinguished the same as f=
or
+(1.1).
+
+On the write configuration time they can be distinguished as one of 4
+choices:
+
+2.1.1. Existing and writable. In this case they should be treated  as
+(1.1)
+
+2.1.2. Existing and read-only. In this case they should be treated as
+(1.2).
+
+2.1.3. Not existing. In this case they should be added using
+"add_attribute" command.
+
+2.1.4. Existing in the sysfs tree and not existing in the config file.
+In this case they should be deleted using "del_attribute" command.
+
+2.2. Global for targets
+-----------------------
+
+For instance, targets/iscsi/target_name/IncomingUser.
+
+On the configuration save time they can be distinguished the same as (=
1.1).
+
+On the write configuration time they can be distinguished as one of 4
+choices:
+
+2.2.1. Existing and writable. In this case they should be treated  as
+(1.1).
+
+2.2.2. Existing and read-only. In this case they should be treated  as
+(1.2).
+
+2.2.3. Not existing. In this case they should be added using
+"add_target_attribute" command.
+
+2.2.4. Existing in the sysfs tree and not existing in the config  file=
=2E
+In this case they should be deleted using "del_target_attribute"
+command.
+
+2.3. Global for devices
+-----------------------
+
+For instance, devices/nullio/t10_dev_id.
+
+On the configuration save time they can be distinguished the same as (=
1.1).
+
+On the write configuration time they can be distinguished as one of 4
+choices:
+
+2.3.1. Existing and writable. In this case they should be treated  as
+(1.1)
+
+2.3.2. Existing and read-only. In this case they should be treated  as
+(1.2).
+
+2.3.3. Not existing. In this case they should be added using
+"add_device_attribute" command for the corresponding handler, e.g.
+devices/nullio/handler/.
+
+2.3.4. Existing in the sysfs tree and not existing in the config  file=
=2E
+In this case they should be deleted using "del_device_attribute"
+command for the corresponding handler, e.g. devices/nullio/handler/.
+
+Thus, management utility should implement only 8 procedures: (1.1),
+(1.2), (2.1.3), (2.1.4), (2.2.3), (2.2.4), (2.3.3), (2.3.4).
+
+
+How to distinguish hardware and virtual targets
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+A target is hardware:
+
+  * if exist both "hw_target" attribute and "mgmt" management file
+
+  * or if both don't exist
+
+A target is virtual if there is "mgmt" file and "hw_target" attribute
+doesn't exist.
+
+
+Algorithm to convert current SCST configuration to config file
+--------------------------------------------------------------
+
+A management utility SHOULD use the following algorithm when convertin=
g
+current SCST configuration to a config file.
+
+For all attributes with digits at the end the name, the digits part
+should be omitted from the attributes' names during the store. For
+instance, "IncomingUser1" should be stored as "IncomingUser".
+
+1. Scan all attributes in /sys/kernel/scst_tgt (not recursive) and sto=
re
+all found key attributes.
+
+2. Scan all subdirectories of /sys/kernel/scst_tgt/handlers. Each
+subdirectory with "mgmt" attribute is a root subdirectory of a dev
+handler with name the name of the subdirectory. For each found dev
+handler do the following:
+
+2.1. Store the dev handler's name. Store also its path to the root
+subdirectory, if it isn't default (/sys/kernel/scst_tgt/handlers/handl=
er_name).
+
+2.2. Store all dev handler's key attributes.
+
+2.3. Go through all links in the root subdirectory pointing to
+/sys/kernel/scst_tgt/devices and for each device:
+
+2.3.1. For virtual devices dev handlers:
+
+2.3.1.1. Store the name of the device.
+
+2.3.1.2. Store all key attributes. Mark all read only key attributes
+during storing, they will be parameters for the device's creation.
+
+2.3.2. For pass-through devices dev handlers:
+
+2.3.2.1. Store the H:C:I:L name of the device. Optionally, instead of
+the name unique T10 vendor device ID found using command:
+
+sg_inq -p 0x83 /dev/sdX
+
+can be stored. It will allow to reliably find out this device if on th=
e
+next reboot it will have another host:channel:id:lin numbers. The sdX
+device can be found as the last letters after ':' in
+/sys/kernel/scst_tgt/devices/H:C:I:L/scsi_device/device/block:sdX.
+
+3. Go through all subdirectories in /sys/kernel/scst_tgt/targets. For
+each target driver:
+
+3.1. Store the name of the target driver.
+
+3.2. Store all its key attributes.
+
+3.3. Go through all target's subdirectories. For each target:
+
+3.3.1. Store the name of the target.
+
+3.3.2. Mark if the target is hardware or virtual target. The target is=
 a
+hardware target if it has "hw_target" attribute or its target driver
+doesn't have "mgmt" attribute.
+
+3.3.3. Store all key attributes. Mark all read only key attributes
+during storing, they will be parameters for the target's creation.
+
+3.3.4. Scan all "luns" subdirectory and store:
+
+ - LUN.
+
+ - LU's device name.
+
+ - Key attributes.
+
+3.3.5. Scan all "ini_groups" subdirectories. For each group store the =
following:
+
+ - The group's name.
+
+ - The group's LUNs (the same info as for 3.3.4).
+
+ - The group's initiators.
+
+3.3.6. Store value of "enabled" attribute, if it exists.
+
+3.4. Store value of "enabled" attribute, if it exists.
+
+
+Algorithm to initialize SCST from config file
+---------------------------------------------
+
+A management utility SHOULD use the following algorithm when doing
+initial SCST configuration from a config file. All necessary kernel
+modules and user space programs supposed to be already loaded, hence a=
ll
+dev handlers' entries in /sys/kernel/scst_tgt/handlers as well as all
+entries for hardware targets already created.
+
+1. Set stored values for all stored global (/sys/kernel/scst_tgt)
+attributes.
+
+2. For each dev driver:
+
+2.1. Set stored values for all already existing stored attributes.
+
+2.2. Create not existing stored attributes using "add_attribute" comma=
nd.
+
+2.3. For virtual devices dev handlers for each stored device:
+
+2.3.1. Create the device using "add_device" command using marked read
+only attributes as parameters.
+
+2.3.2. Set stored values for all already existing stored attributes.
+
+2.3.3. Create not existing stored attributes using
+"add_device_attribute" command.
+
+2.4. For pass-through dev handlers for each stores device:
+
+2.4.1. Assign the corresponding pass-through device to this dev handle=
r
+using "add_device" command.
+
+3. For each target driver:
+
+3.1. Set stored values for all already existing stored attributes.
+
+3.2. Create not existing stored attributes using "add_attribute" comma=
nd.
+
+3.3. For each target:
+
+3.3.1. For virtual targets:
+
+3.3.1.1. Create the target using "add_target" command using marked rea=
d
+only attributes as parameters.
+
+3.3.1.2. Set stored values for all already existing stored attributes.
+
+3.3.1.3. Create not existing stored attributes using
+"add_target_attribute" command.
+
+3.3.2. For hardware targets for each target:
+
+3.3.2.1. Set stored values for all already existing stored attributes.
+
+3.3.2.2. Create not existing stored attributes using
+"add_target_attribute" command.
+
+3.3.3. Setup LUNs
+
+3.3.4. Setup ini_groups, their LUNs and initiators' names.
+
+3.3.5. If this target supports enabling, enable it.
+
+3.4. If this target driver supports enabling, enable it.
+
+
+Algorithm to apply changes in config file to currently running SCST
+-------------------------------------------------------------------
+
+A management utility SHOULD use the following algorithm when applying
+changes in config file to currently running SCST.
+
+Not all changes can be applied on enabled targets or enabled target
+drivers. From other side, for some target drivers enabling/disabling i=
s
+a very long and disruptive operation, which should be performed as rar=
e
+as possible. Thus, the management utility SHOULD support additional
+option, which, if set, will make it to disable all affected targets
+before doing any change with them.
+
+1. Scan all attributes in /sys/kernel/scst_tgt (not recursive) and
+compare stored and actual key attributes. Apply all changes.
+
+2. Scan all subdirectories of /sys/kernel/scst_tgt/handlers. Each
+subdirectory with "mgmt" attribute is a root subdirectory of a dev
+handler with name the name of the subdirectory. For each found dev
+handler do the following:
+
+2.1. Compare stored and actual key attributes. Apply all changes. Crea=
te
+new attributes using "add_attribute" commands and delete not needed an=
y
+more attributes using "del_attribute" command.
+
+2.2. Compare existing devices (links in the root subdirectory pointing
+to /sys/kernel/scst_tgt/devices) and stored devices in the config file=
=2E
+Delete all not needed devices and create new devices.
+
+2.3. For all existing devices:
+
+2.3.1. Compare stored and actual key attributes. Apply all changes.
+Create new attributes using "add_device_attribute" commands and delete
+not needed any more attributes using "del_device_attribute" command.
+
+2.3.2. If any read only key attribute for virtual device should be
+changed, delete the devices and recreate it.
+
+3. Go through all subdirectories in /sys/kernel/scst_tgt/targets. For
+each target driver:
+
+3.1. If this target driver should be disabled, disable it.
+
+3.2. Compare stored and actual key attributes. Apply all changes. Crea=
te
+new attributes using "add_attribute" commands and delete not needed an=
y
+more attributes using "del_attribute" command.
+
+3.3. Go through all target's subdirectories. Compare existing and stor=
ed
+targets. Delete all not needed targets and create new targets.
+
+3.4. For all existing targets:
+
+3.4.1. If this target should be disabled, disable it.
+
+3.4.2. Compare stored and actual key attributes. Apply all changes.
+Create new attributes using "add_target_attribute" commands and delete
+not needed any more attributes using "del_target_attribute" command.
+
+3.4.3. If any read only key attribute for virtual target should be
+changed, delete the target and recreate it.
+
+3.4.4. Scan all "luns" subdirectory and apply necessary changes, using
+"replace" commands to replace one LUN by another, if needed.
+
+3.4.5. Scan all "ini_groups" subdirectories and apply necessary change=
s,
+using "replace" commands to replace one LUN by another and "move"
+command to move initiator from one group to another, if needed. It MUS=
T
+be done in the following order:
+
+ - Necessary initiators deleted, if they aren't going to be moved
+
+ - LUNs updated
+
+ - Necessary initiators added or moved
+
+3.4.6. If this target should be enabled, enable it.
+
+3.5. If this target driver should be enabled, enable it.
+


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
