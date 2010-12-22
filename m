From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/3] [SCSI] scst: Move target sysfs documentation to Documentation/ABI
Date: Wed, 22 Dec 2010 21:45:49 +0100
Message-ID: <201012222145.49288.bvanassche@acm.org>
References: <201012222144.47522.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:59354 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0LVUrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2010 15:47:07 -0500
In-Reply-To: <201012222144.47522.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: vst@vlnb.net, realrichardsharpe@gmail.com, scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>

Move the documentation about SCSI target drivers and devices from
Documentation/scst/SysfsRules and Documentation/scst/README.scst to
Documentation/ABI/stable.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Richard Sharpe <realrichardsharpe@gmail.com>
---
 Documentation/ABI/stable/sysfs-devices-scst_target |  213 ++++++++++++++++++++
 .../stable/sysfs-devices-scst_target-scst_local    |   21 ++
 Documentation/ABI/stable/sysfs-driver-scst_target  |   65 ++++++
 .../ABI/stable/sysfs-driver-scst_target-scst_local |   12 +
 Documentation/scst/README.scst                     |   98 ---------
 Documentation/scst/SysfsRules                      |   63 ------
 6 files changed, 311 insertions(+), 161 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-devices-scst_target
 create mode 100644 Documentation/ABI/stable/sysfs-devices-scst_target-scst_local
 create mode 100644 Documentation/ABI/stable/sysfs-driver-scst_target
 create mode 100644 Documentation/ABI/stable/sysfs-driver-scst_target-scst_local

diff --git a/Documentation/ABI/stable/sysfs-devices-scst_target b/Documentation/ABI/stable/sysfs-devices-scst_target
new file mode 100644
index 0000000..7e920f9
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-scst_target
@@ -0,0 +1,213 @@
+What:           /sys/bus/scst_target/devices/*/addr_method
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		LUN addressing method used by this target when e.g. responding
+		to a REPORT_LUNS command. One of the values FLAT, PERIPHERAL
+		or LUN. See also SAM-3, section 4.9, Logical Unit Numbers.
+		Read-write.
+
+What:           /sys/bus/scst_target/devices/*/cpu_mask
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Target-specific CPU mask. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/force_close
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		If this file exists, allows to forcibly close all sessions
+		associated with a target. Optional / write-only.
+
+What:           /sys/bus/scst_target/devices/*/enabled
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Allows to enable or disable a target by setting this attribute
+		to 1 or 0 respectively. No new connections are accepted for a
+		target that is in the disabled state. Defaults to disabled
+		(0). This allows to configure a target before any connections
+		are accepted. Enabling a target is only allowed if its relative
+		target port identifier is unique. Read-write.
+
+What:           /sys/bus/scst_target/devices/*/hw_target
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Allows to distinguish hardware and virtual targets. The value
+		1 means that there is a one-to-one correspondence between this
+		target and a hardware entity, and the value 0 means that there
+		is no such one-to-one correspondence. Only exists when the
+		target driver supports both hardware and virtual targets.
+		Read-only.
+
+What:           /sys/bus/scst_target/devices/*/ini_groups/<acg>/addr_method
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		LUN addressing method for this ACG (access control group).
+		Read-write.
+
+What:           /sys/bus/scst_target/devices/*/ini_groups/<acg>/cpu_mask
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		CPU mask associated with this ACG. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/ini_groups/<acg>/initiators/<ini>
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Name of an initiator associated with this ACG. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/ini_groups/<acg>/initiators/luns/parameters
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Names of the parameters supported when adding a LUN to an ACG,
+		one per line. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/ini_groups/<acg>/initiators/luns/<number>
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Soft link to the SCST device associated with this LUN.
+
+What:           /sys/bus/scst_target/devices/*/io_grouping_type
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Defines whether and how to share I/O contexts. I/O context
+		sharing may improve I/O performance significantly when using
+		the CFQ I/O scheduler and multithreaded I/O processing.
+		The allowed values for this parameter are:
+		* "auto"               Use one I/O context per initiator.
+		* "this_group_only"    Use the same I/O context for all sessions
+		  		       associated with this target.
+		* "never"              Never share I/O contexts.
+		* <I/O context number> Share an I/O context over all targets
+		                       that have this I/O context number. Must
+				       be a number above zero.
+		Read-write.
+
+What:           /sys/bus/scst_target/devices/*/luns/parameters
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Names of the parameters supported when adding a LUN to a target,
+		one per line. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/luns/<number>/device
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Soft link to the exported SCST device. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/luns/<number>/read_only
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Whether this LUN is read-only (1) or read-write (0). Read-only.
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/active_commands
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Number of SCSI commands being executed for the device
+		associated with this session. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/commands
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Number of SCSI commands being executed for this session.
+		Read-only.
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/force_close
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Attribute that allows to forcibly close a session. Optional,
+		write-only.
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/initiator_name
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Session name. For most target drivers this is a name that
+		identifies the initiator. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/latency
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		If CONFIG_SCST_MEASURE_LATENCY has been enabled, latency
+		statistics for this session. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/lun<number>/active_commands
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Number of active commands. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/lun<number>/latency
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Latency statistics. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/luns/parameters
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Names of the parameters that may be specified when adding a
+		LUN, one per line. Read-only.
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/luns/<number>/device
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Soft link to the SCST device that is exported via this LUN. An
+		example:
+		$ readlink /sys/bus/scst_target/devices/scst_local_tgt/sessions/scst_local_host/luns/0/device
+		../../../disk01
+
+What:           /sys/bus/scst_target/devices/*/sessions/<session>/luns/<number>/read_only
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Whether a LUN has been exported read-only (1) or read-write (0).
+		Read-only.
+
+What:           /sys/bus/scst_target/devices/*/rel_tgt_id
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		SCSI Relative Target Port Identifier, which is used by e.g.
+		persistent reservation commands. Read-write.
diff --git a/Documentation/ABI/stable/sysfs-devices-scst_target-scst_local b/Documentation/ABI/stable/sysfs-devices-scst_target-scst_local
new file mode 100644
index 0000000..c659c60
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-scst_target-scst_local
@@ -0,0 +1,21 @@
+What:           /sys/bus/scst_target/devices/scst_local/phys_transport_version
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		SCSI physical transport version. Read-write.
+
+What:           /sys/bus/scst_target/devices/scst_local/scsi_transport_version
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		SCSI transport version. Read-write.
+
+What:           /sys/bus/scst_target/devices/scst_local/sessions/transport_id
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		SCSI transport ID in binary format. Necessary e.g. for
+		implementing persistent reservation support. Read-write.
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_target b/Documentation/ABI/stable/sysfs-driver-scst_target
new file mode 100644
index 0000000..0d682b0
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-scst_target
@@ -0,0 +1,65 @@
+What:           /sys/bus/scst_target/drivers/*/add_target
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Whether or not dynamic creation and removal of SCSI targets is
+		supported by a particular SCSI target driver. The value 1
+		means that dynamic target creation/removal is supported
+		and the value 0 means that dynamic target creation/removal is
+		not supported. Read-only.
+
+What:           /sys/bus/scst_target/drivers/*/add_target_parameters
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Names of the parameters that may be specified at target
+		creation time. Each parameter name appears on a separate
+		line. This file only exists if dynamic target creation and
+		removal is supported. Read-only.
+
+What:           /sys/bus/scst_target/drivers/*/driver_attributes
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Names of the SCSI target driver attributes that may be created
+		or removed dynamically. Each attribute name appears on a
+		separate line. This file only exists if dynamic target driver
+		attribute creation and removal is supported. Read-only.
+
+What:           /sys/bus/scst_target/drivers/*/enabled
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Allows to enable or disable the operation of a SCSI target
+		driver. The value 1 means enabled and 0 means disabled.
+		Defaults to 0 (disabled). This allows to configure a target
+		driver before it becomes operational. Optional / read-write.
+
+What:           /sys/bus/scst_target/drivers/*/target_attributes
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Names of the SCSI target attributes that may be created and/or
+		removed dynamically. Each attribute name appears on a separate
+		line. This file only exists if dynamic target attribute
+		creation and removal is supported. Read-only.
+
+What:           /sys/bus/scst_target/drivers/*/version
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Target driver version and build options. The driver version
+		and build date appear on the first line separated by a
+		slash and the build options appear on subsequent
+		lines. Read-only. An example:
+
+		$ cat /sys/bus/scst_target/drivers/scst_local/version
+		1.0.0/20100910
+		TRACING
+		DEBUG
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local b/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local
new file mode 100644
index 0000000..9c85701
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local
@@ -0,0 +1,12 @@
+What:           /sys/bus/scst_target/drivers/scst_local/stats
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Statistics about processing of SCSI commands received via the
+		Linux SCSI initiator: the number of SCSI commands that have
+		been aborted, the number of SCSI device resets and the number
+		of SCSI target resets. Read-only. An example:
+
+		# cat /sys/bus/scst_target/drivers/scst_local/stats
+		Aborts: 0, Device Resets: 0, Target Resets: 0
diff --git a/Documentation/scst/README.scst b/Documentation/scst/README.scst
index 333daa5..7c16d5c 100644
--- a/Documentation/scst/README.scst
+++ b/Documentation/scst/README.scst
@@ -357,104 +357,6 @@ Each SGV cache's subdirectory has the following item:
 
  - stats - file containing statistics for this SGV caches.
 
-"Targets" subdirectory contains subdirectories for each SCST target.
-
-Content of each target's subdirectory is target specific. See
-documentation for your target for more info about it as well as
-SysfsRules file for more info about common to all targets rules.
-Every target should have at least the following entries:
-
- - ini_groups - subdirectory, which contains and allows to define
-   initiator-oriented access control information, see below.
-
- - luns - subdirectory, which contains list of available LUNs in the
-   target-oriented access control and allows to define it, see below.
-
- - sessions - subdirectory containing connected to this target sessions.
-
- - enabled - using this attribute you can enable or disable this target/
-   It allows to finish configuring it before it starts accepting new
-   connections. 0 by default.
-
- - addr_method - used LUNs addressing method. Possible values:
-   "Peripheral" and "Flat". Most initiators work well with Peripheral
-   addressing method (default), but some (HP-UX, for instance) may
-   require Flat method. This attribute is also available in the
-   initiators security groups, so you can assign the addressing method
-   on per-initiator basis.
-
- - cpu_mask - defines CPU affinity mask for threads serving this target.
-   For threads serving LUNs it is used only for devices with
-   threads_pool_type "per_initiator".
-
- - io_grouping_type - defines how I/O from sessions to this target are
-   grouped together. This I/O grouping is very important for
-   performance. By setting this attribute in a right value, you can
-   considerably increase performance of your setup. This grouping is
-   performed only if you use CFQ I/O scheduler on the target and for
-   devices with threads_num >= 0 and, if threads_num > 0, with
-   threads_pool_type "per_initiator". Possible values:
-   "this_group_only", "never", "auto", or I/O group number >0. When the
-   value is "this_group_only" all I/O from all sessions in this target
-   will be grouped together. When the value is "never", I/O from
-   different sessions will not be grouped together, i.e. all sessions in
-   this target will have separate dedicated I/O groups. When the value
-   is "auto" (default), all I/O from initiators with the same name
-   (iSCSI initiator name, for instance) in all targets will be grouped
-   together with a separate dedicated I/O group for each initiator name.
-   For iSCSI this mode works well, but other transports usually use
-   different initiator names for different sessions, so using such
-   transports in MPIO configurations you should either use value
-   "this_group_only", or an explicit I/O group number. This attribute is
-   also available in the initiators security groups, so you can assign
-   the I/O grouping on per-initiator basis. See below for more info how
-   to use this attribute.
-
- - rel_tgt_id - allows to read or write SCSI Relative Target Port
-   Identifier attribute. This identifier is used to identify SCSI Target
-   Ports by some SCSI commands, mainly by Persistent Reservations
-   commands. This identifier must be unique among all SCST targets, but
-   for convenience SCST allows disabled targets to have not unique
-   rel_tgt_id. In this case SCST will not allow to enable this target
-   until rel_tgt_id becomes unique. This attribute initialized unique by
-   SCST by default.
-
-A target driver may have also the following entries:
-
- - "hw_target" - if the target driver supports both hardware and virtual
-    targets (for instance, an FC adapter supporting NPIV, which has
-    hardware targets for its physical ports as well as virtual NPIV
-    targets), this read only attribute for all hardware targets will
-    exist and contain value 1.
-
-Subdirectory "sessions" contains one subdirectory for each connected
-session with name equal to name of the connected initiator.
-
-Each session subdirectory contains the following entries:
-
- - initiator_name - contains initiator name
-
- - force_close - optional write-only attribute, which allows to force
-   close this session.
-
- - active_commands - contains number of active, i.e. not yet or being
-   executed, SCSI commands in this session.
-
- - commands - contains overall number of SCSI commands in this session.
-
- - latency - if CONFIG_SCST_MEASURE_LATENCY enabled, contains latency
-   statistics for this session.
-
- - luns - a link pointing out to the corresponding LUNs set (security
-   group) where this session was attached to.
-
- - One or more "lunX" subdirectories, where 'X' is a number, for each LUN
-   this session has (see below).
-
- - other target driver specific attributes and subdirectories.
-
-See below description of the VDISK's sysfs interface for samples.
-
 
 Access and devices visibility management (LUN masking)
 ------------------------------------------------------
diff --git a/Documentation/scst/SysfsRules b/Documentation/scst/SysfsRules
index 2e594bd..5790511 100644
--- a/Documentation/scst/SysfsRules
+++ b/Documentation/scst/SysfsRules
@@ -60,69 +60,6 @@ the management commands can be revealed by reading that attribute. An example:
 [key]
 
 
-Target driver attributes
-------------------------
-
-Target drivers may support the following attributes:
-
-1. "enabled" - allows to enable and disable a target driver as a whole. If
-disabled, the target driver must not accept any new connection. Allows to
-configure a target driver before it becomes operational. Disabling a target
-driver may have the effect of closing all existing sessions for all
-targets. Defaults to 0 (disabled). Set this attribute to 1 to enable a target
-driver.
-
-2. "trace_level" - allows to manage the trace level of a target driver. An
-example:
-
-echo "add debug" >/sys/bus/scst_target/drivers/scst_local/trace_level
-
-3. "version" - Allows to query the target driver version and compilation
-options.
-
-An example:
-
-$ cat /sys/bus/scst_target/drivers/scst_local/version
-1.0.0/20100910
-EXTRACHECKS
-DEBUG
-
-4. "add_target" - If this attribute exists and equals 1 this means that the
-target driver supports the "add_target" command.
-
-5. "add_target_parameters" - Names of the parameters supported by the
-"add_target" command (one per line).
-
-6. "driver_attributes" - Names of the target driver attributes that can be
-created or removed dynamically by the add_attribute and del_attribute
-commands.
-
-7. "target_attributes" - Names of the target attributes that can be created or
-removed dynamically by the add_target_attribute and del_target_attribute
-commands.
-
-
-Target attributes
------------------
-
-Each SCSI target may support the following attributes:
-
-1. "enabled" - Allows to enable or disable a target by setting this attribute
-to 1 or 0 respectively. No new connections are accepted for a disabled
-target. This allows to configure a target before any connections are accepted.
-Must default to disabled.
-
-2. "rel_tgt_id" - SCSI Relative Target Port Identifier.
-
-3. "hw_target" (optional) - Allows to distinguish hardware and virtual
-targets, if the target driver supports both.
-
-4. "force_close" (optional) - Allows to forcibly close all sessions associated
-with a target.
-
-See also the SCST readme for further information.
-
-
 II. Rules for device handlers
 =============================
 
-- 
1.7.1

