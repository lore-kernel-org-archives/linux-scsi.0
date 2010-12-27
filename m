From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 8/8] Make SCST sysfs documentation more complete
Date: Mon, 27 Dec 2010 14:43:13 +0100
Message-ID: <201012271443.14021.bvanassche@acm.org>
References: <201012271435.33778.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:52750 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab0L0NnX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 08:43:23 -0500
In-Reply-To: <201012271435.33778.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

Since the previous time the SCST sysfs documentation has been posted, detailed
documentation about /sys/devices/scst/mgmt has been added and the
documentation of several sysfs attributes has been made more clear.

Note: this patch contains the entire SCST sysfs documentation since it has
been generated as follows:

git diff origin/master..scst Documentation/ABI/stable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 sysfs-devices-scst                   |  318 +++++++++++++++++++++++++++++++++++
 sysfs-devices-scst_target            |  226 ++++++++++++++++++++++++
 sysfs-devices-scst_target-scst_local |   23 ++
 sysfs-devices-scst_tgt_dev           |  217 +++++++++++++++++++++++
 sysfs-driver-scst_target             |   55 ++++++
 sysfs-driver-scst_target-scst_local  |   20 ++
 sysfs-driver-scst_tgt_dev            |   51 +++++
 7 files changed, 910 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-devices-scst b/Documentation/ABI/stable/sysfs-devices-scst
new file mode 100644
index 0000000..e25d1a4
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-scst
@@ -0,0 +1,318 @@
+What:		/sys/devices/scst/mgmt
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Interface through which SCST management commands can be
+		issued. Read-write. Brief documentation of the syntax of these
+		commands can be obtained by reading this file (e.g. cat
+		/sys/devices/scst/mgmt). Detailed information is available
+		below.
+
+What:		/sys/devices/scst/setup_id
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		SCST setup ID. Allows to identify otherwise identical SCST
+		setups on different systems. As an example, the
+		vdisk device handler uses this to generate the T10 vendor
+		specific identifier ID and USN of virtual devices. Must be
+		set before any virtual devices are created. Read-write.
+
+What:		/sys/devices/scst/sgv/global_stats
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Global SGV (scatter/gather vector) cache statistics. Read-only.
+		An example:
+
+		$ cat sgv/global_stats
+		Inactive/active pages			0/0
+		Hi/lo watermarks [pages]		62208/0
+		Hi watermark releases/failures		0/0
+		Other allocs				0
+
+What:		/sys/devices/scst/sgv/sgv/stats
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Statistics for the regular SGV cache. Read-only.
+
+What:		/sys/devices/scst/sgv/sgv-clust/stats
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Statistics for the clustering SGV cache. Read-only.
+
+What:		/sys/devices/scst/sgv/sgv-dma/stats
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Statistics for the DMA SGV cache. Read-only.
+
+What:		/sys/devices/scst/threads
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Number of global I/O threads. The global I/O threads are used
+		by asynchronous device handlers or when explicitly configured
+		(i.e. when threads_num has been set to zero). Read-write.
+
+What:		/sys/devices/scst/version
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		SCST version number. Read-only. An example:
+
+		$ cat /sys/devices/scst/version
+		2.0.0
+
+-------------------------------------------------------------------------------
+
+
+Issuing management commands via /sys/devices/scst/mgmt
+
+
+1 Device driver commands
+========================
+
+1.1 Managing virtual devices
+----------------------------
+
+The syntax for creating a virtual device is as follows:
+
+echo "in device_driver/<devt> add_device <device_name> [<parameters>]" \
+  >/sys/devices/scst/mgmt
+
+where <devt> is the name of a virtual device handler and <parameters> is a
+semicolon-separated list of <name>=<value> pairs. The supported parameters are
+enumerated in the add_device_parameters file of each virtual device
+driver. E.g. for vdisk_fileio the parameters supported at device creation time
+are:
+
+$ cat /sys/bus/scst_tgt_dev/drivers/vdisk_fileio/add_device_parameters
+filename
+blocksize
+write_through
+nv_cache
+o_direct
+read_only
+removable
+thin_provisioned
+
+An example of how to create a vdisk_fileio device with NV-cache and thin
+provisioning enabled:
+
+echo "in device_driver/vdisk_fileio add_device disk01 filename=/home/exported-storage;nv_cache=1;thin_provisioned=1" >/sys/devices/scst/mgmt
+
+Removing virtual devices is possible via the del_device command. An example:
+
+echo "in device_driver/vdisk_fileio del_device disk01" >/sys/devices/scst/mgmt
+
+The remaining commands (add_attribute, del_attribute, add_device_attribute and
+del_device_attribute) allow to add or remove dynamically sysfs files for
+virtual devices and their drivers. There are not yet any virtual devices or
+virtual device drivers that allow this.
+
+1.2 Managing pass-through devices
+---------------------------------
+
+SCST supports SCSI pass-through. Before a LUN number can be assigned to a SCSI
+device, a device handler has to be assigned via the add_device command:
+
+echo "in device_driver/<devt> add_device H:C:I:L" >/sys/devices/scst/mgmt
+
+The syntax for disabling SCSI passthrough is similar:
+
+echo "in device_driver/<devt> del_device H:C:I:L" >/sys/devices/scst/mgmt
+
+In the above <devt> is the name of a pass-through handler and H:C:I:L is a
+quadruplet identifying a local SCSI device. An example:
+
+echo "in device_driver/dev_disk add_device 2:0:0:0" >/sys/devices/scst/mgmt
+echo "in device_driver/dev_disk del_device 2:0:0:0" >/sys/devices/scst/mgmt
+
+A list with the names of all currently loaded virtual and pass-through drivers
+can be obtained as follows:
+
+$ ls /sys/bus/scst_tgt_dev/drivers
+dev_cdrom    dev_disk_perf    dev_processor  dev_tape_perf  vdisk_fileio
+dev_changer  dev_modisk       dev_raid       vcdrom         vdisk_nullio
+dev_disk     dev_modisk_perf  dev_tape       vdisk_blockio
+
+
+2 Device management commands
+============================
+
+The syntax of device management commands is as follows:
+
+echo "in device/<dev> <dev_cmd>" >/sys/devices/scst/mgmt
+
+where <dev> is a device name and <dev_cmd> is one of:
+
+set_filename <filename>
+set_threads_num <n>
+set_thread_pool_type <thread_pool_type>
+
+These commands are documented in
+Documentation/ABI/stable/sysfs-devices-scst_tgt_dev.
+
+
+3 Target driver commands
+========================
+
+3.1 Adding and removing targets
+-------------------------------
+
+Adding and removing targets dynamically is possible with the add_target and
+remove_target commands. This is supported by scst_local but not by ib_srpt. An
+example for scst_local:
+
+# echo "in target_driver/scst_local add_target tgt2 session_name=tgt2_sess" >/sys/devices/scst/mgmt
+# ls /sys/bus/scst_target/drivers/scst_local/tgt2/sessions
+tgt2_sess
+# echo "in target_driver/scst_local del_target tgt2" >/sys/devices/scst/mgmt
+# ls /sys/bus/scst_target/drivers/scst_local/tgt2/sessions
+ls: cannot access /sys/bus/scst_target/drivers/scst_local/tgt2/sessions: No such file or directory
+
+3.2 Driver-specific commands
+----------------------------
+
+Each driver can define additional commands. As an example, the scst_local
+driver supports the add_session and del_session commands. See also the
+driver-specific documentation for more information.
+
+
+4 Target commands
+=================
+
+The following target commands are supported via /sys/devices/scst/mgmt:
+enable, disable and set_cpu_mask. These commands are documented in
+Documentation/ABI/stable/sysfs-devices-scst_target.
+
+
+5 Target LUN commands
+=====================
+
+The syntax of the commands for managing the set of LUNs associated with a
+target is as follows:
+
+in target_driver/<tgtt>/<target>/luns <lun_cmd>
+
+where lun_cmd is one of:
+
+add|del H:C:I:L <lun> [<parameters>]
+add <vname> <lun> [<parameters>]
+del <lun>
+replace H:C:I:L <lun> [<parameters>]
+replace <vname> <lun> [<parameters>]
+clear
+
+and where <vname> is the name of a virtual device, <lun> is a LUN number and
+<parameters> is a semicolon-separated list of parameters. Currently the only
+supported parameter is the parameter called "read_only" (either 0 or 1).
+
+# echo "in target_driver/ib_srpt/ib_srpt_target_0/luns clear" >/sys/devices/scst/mgmt
+# echo "in target_driver/ib_srpt/ib_srpt_target_0/luns add disk01 0" >/sys/devices/scst/mgmt
+# readlink /sys/bus/scst_target/drivers/ib_srpt/ib_srpt_target_0/luns/0/device
+../../../disk01
+# echo "in target_driver/ib_srpt/ib_srpt_target_0/luns replace disk02 0" >/sys/devices/scst/mgmt
+# readlink /sys/bus/scst_target/drivers/ib_srpt/ib_srpt_target_0/luns/0/device
+../../../disk02
+
+
+6 Access control group commands
+===============================
+
+6.1 Access control group creation and removal
+---------------------------------------------
+
+A list of zero or more access control groups (ACGs) can be associated with
+each target. ACGs allow to define which initiator has access to which LUNs.
+The syntax for creating and removing ACGs is:
+
+in target_driver/<tgtt>/<target>/ini_groups <acg_mgmt_cmd>
+
+where <acg_mgmt_cmd> is one of:
+
+create <group_name>
+del <group_name>
+
+An example:
+
+# echo "in target_driver/ib_srpt/ib_srpt_target_0/ini_groups create group1" >/sys/devices/scst/mgmt
+# ls /sys/bus/scst_target/drivers/ib_srpt/ib_srpt_target_0/ini_groups
+group1
+
+6.2 Access control group properties
+-----------------------------------
+
+The access control group CPU mask can be modified via the set_cpu_mask
+command. See also Documentation/ABI/stable/sysfs-devices-scst_target for more
+information.
+
+6.3 Managing ACG LUNs
+---------------------
+
+The syntax of the commands for managing the LUNs associated with an ACG is as
+follows:
+
+in target_driver/<tgtt>/<target>/ini_groups/<acg>/luns <lun_cmd>
+
+add|del H:C:I:L <lun> [<parameters>]
+add <vname> <lun> [<parameters>]
+del <lun>
+replace H:C:I:L <lun> [<parameters>]
+replace <vname> <lun> [<parameters>]
+clear
+
+See also section 5 for more information about these commands. An example:
+
+# echo "in target_driver/ib_srpt/ib_srpt_target_0/ini_groups/group1/luns add disk01 0" >/sys/devices/scst/mgmt
+# readlink /sys/bus/scst_target/drivers/ib_srpt/ib_srpt_target_0/ini_groups/group1/luns/0/device
+../../../disk01
+
+6.4 Associating initiators with an ACG
+--------------------------------------
+
+The syntax of the commands for manipulating the list of initiators associated
+with an ACG is as follows:
+
+in target_driver/<tgtt>/<target>/ini_groups/<acg>/initiators <acg_ini_cmd>
+
+where <acg_ini_cmd> is one of:
+
+add <initiator_name>
+del <initiator_name>
+move <initiator_name> <dest_group_name>
+clear
+
+These commands allow to add an initiator name to the initiator name list of an
+ACG, remove an initiator name from that list, move an initatior name from one
+ACG to another or to clear that initiator name list entirely. For the "add"
+and "del" commands the initiator name may be a pattern instead of a literal
+initator name. The following wildcard characters are supported:
+- '*' matches any substring.
+- '?' matches any character.
+- '!' at the start of a pattern will cause the pattern to match with every
+  initiator name that does not match with the subsequent pattern.
+As an example, the pattern "!abc*" will match with every initiator name that
+does not start with the sequence "abc".
+
+Below one can find an example for the target driver ib_srpt. For the SRP
+protocol initiator names are 128-bit hexadecimal numbers (a HCA port GUID).
+Associating the ACG called "group1" with the two HCA ports with GUIDs $port1
+and $port2 is possible as follows:
+
+# port1="0x00000000000000000002c9030005f34b"
+# port2="0x00000000000000000002c9030005f34c"
+# echo "in target_driver/ib_srpt/ib_srpt_target_0/ini_groups/group1/initiators add $port1" >/sys/devices/scst/mgmt
+# echo "in target_driver/ib_srpt/ib_srpt_target_0/ini_groups/group1/initiators add $port2" >/sys/devices/scst/mgmt
+# ls /sys/bus/scst_target/drivers/ib_srpt/ib_srpt_target_0/ini_groups/group1/initiators
+0x00000000000000000002c9030005f34b 0x00000000000000000002c9030005f34c
+
+The cumulative effect of the commands shown as examples in sections 6.1, 6.3
+and this section is that the initiator identified by GUID $ini1 and only that
+initiator will see the LUNs defined in the ACG with name "group1". If no other
+ACGs have been defined, all other initiators that log in to the same target
+will see the LUNs associated with the target itself. Making a LUN available to
+some hosts and not available to other hosts is also called LUN masking.
diff --git a/Documentation/ABI/stable/sysfs-devices-scst_target b/Documentation/ABI/stable/sysfs-devices-scst_target
new file mode 100644
index 0000000..2d3a388
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-scst_target
@@ -0,0 +1,226 @@
+What:		/sys/bus/scst_target/devices/*/addr_method
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		LUN addressing method used by this target when e.g. responding
+		to a REPORT_LUNS command. One of the values PERIPHERAL, FLAT
+		or LUN. Read-write. While most initiators work well with the
+		default addressing method (PERIPHERAL), some initiators need
+		the FLAT addressing method (HP/UX) or LUN addressing (AIX).
+		Note: the LUN addressing method can also be configured for a
+		security group. That allows to define the LUN addressing
+		method on a per-initiator basis. See also SAM-4, section 4.6,
+		Logical Unit Numbers.
+
+What:		/sys/bus/scst_target/devices/*/cpu_mask
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Target-specific CPU mask in hexadecimal format. While this
+		file is read-only, changing the CPU mask is possible via
+		the set_cpu_mask command. As an example, the commands below
+		show how to make scst_local use any CPU for processing SCSI
+		commands except CPUs 0, 1, 2 or 3:
+
+		# cat /sys/bus/scst_target/devices/scst_local_tgt/cpu_mask
+		ffffffff,ffffffff
+		# echo "in target_driver/scst_local/scst_local_tgt set_cpu_mask ffffffff,fffffff0" >/sys/devices/scst/mgmt
+		# cat /sys/bus/scst_target/devices/scst_local_tgt/cpu_mask
+		ffffffff,fffffff0
+
+What:		/sys/bus/scst_target/devices/*/force_close
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		If this file exists, writing any data to this file will
+		forcibly close all sessions associated with a target.
+		Write-only.
+
+What:		/sys/bus/scst_target/devices/*/enabled
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether a target is currently enabled ("1") or disabled ("0").
+		No new connections are accepted for a
+		target that is in the disabled state. Defaults to disabled
+		("0"). This allows to configure a target before any connections
+		are accepted. Read-only. Notes:
+		- Enabling a target is only allowed if its relative target
+		  port identifier is unique.
+		- Enabling or disabling a target is possible via the SCST
+		  device. An example:
+
+		$ echo "in target_driver/ib_srpt/ib_srpt_target_0 disable" >/sys/devices/scst/mgmt
+		$ cat /sys/devices/ib_srpt_target_0/enabled
+		0
+		$ echo "in target_driver/ib_srpt/ib_srpt_target_0 enable" >/sys/devices/scst/mgmt
+		$ cat /sys/devices/ib_srpt_target_0/enabled
+
+What:		/sys/bus/scst_target/devices/*/hw_target
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Allows to distinguish hardware and virtual targets. The value
+		1 means that there is a one-to-one correspondence between this
+		target and a hardware entity, and the value 0 means that there
+		is no such one-to-one correspondence. This file only exists
+		when the target driver supports both hardware and virtual
+		targets. Read-only.
+
+What:		/sys/bus/scst_target/devices/*/ini_groups/<acg>/addr_method
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		LUN addressing method for this ACG (access control group).
+		Read-write.
+
+What:		/sys/bus/scst_target/devices/*/ini_groups/<acg>/cpu_mask
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		CPU mask associated with this ACG. Read-only. Modifying this
+		CPU mask is possible via the set_cpu_mask command. An example:
+
+		# cat /sys/bus/scst_target/devices/scst_local_tgt/ini_groups/group1/cpu_mask
+		ffffffff,ffffffff
+		# echo "in target_driver/scst_local/scst_local_tgt/ini_groups/group1 set_cpu_mask 1" >/sys/devices/scst/mgmt
+		# cat /sys/bus/scst_target/devices/scst_local_tgt/ini_groups/group1/cpu_mask
+		00000000,00000001
+
+What:		/sys/bus/scst_target/devices/*/ini_groups/<acg>/initiators/<ini>
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Name of an initiator associated with this ACG. The contents
+		of this file is the same as the filename. Read-only.
+
+What:		/sys/bus/scst_target/devices/*/ini_groups/<acg>/initiators/luns/parameters
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Names of the parameters supported when adding a LUN to an ACG,
+		one per line. Read-only.
+
+What:		/sys/bus/scst_target/devices/*/ini_groups/<acg>/initiators/luns/<number>/device
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Soft link to the SCST device associated with this LUN. An
+		example:
+		$ readlink /sys/bus/scst_target/devices/scst_local_tgt/ini_groups/group1/luns/0/device
+		../../../../../disk01
+
+What:		/sys/bus/scst_target/devices/*/ini_groups/<acg>/initiators/luns/<number>/read_only
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether the LUN has been exported read-only ("1") or
+		read-write ("0"). This file is read-only.
+
+What:		/sys/bus/scst_target/devices/*/io_grouping_type
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		I/O context sharing setting. I/O context sharing may improve
+		I/O performance significantly when using the CFQ I/O scheduler
+		and rotating storage media. The allowed values for this
+		parameter are:
+		* "auto"		Use one I/O context per initiator.
+		* "this_group_only"	Use the same I/O context for all
+					sessions associated with this target.
+		* "never"		Never share I/O contexts.
+		* <I/O context number>	Share an I/O context over all targets
+					that have this I/O context number. Must
+					be a number above zero.
+		Read-write.
+
+What:		/sys/bus/scst_target/devices/*/luns/parameters
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Names of the parameters supported when adding a LUN to a
+		target, one per line. Read-only.
+
+What:		/sys/bus/scst_target/devices/*/luns/<number>/device
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Soft link to the exported SCST device. Read-only.
+
+What:		/sys/bus/scst_target/devices/*/luns/<number>/read_only
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether this LUN is read-only (1) or read-write (0).
+		Read-create.
+
+What:		/sys/bus/scst_target/devices/*/sessions/<session>/active_commands
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Number of SCSI commands being executed for this session.
+		Read-only.
+
+What:		/sys/bus/scst_target/devices/*/sessions/<session>/commands
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Number of SCSI commands being executed for this session.
+		Read-only.
+
+What:		/sys/bus/scst_target/devices/*/sessions/<session>/force_close
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Attribute that allows to forcibly close a session. Optional,
+		write-only.
+
+What:		/sys/bus/scst_target/devices/*/sessions/<session>/initiator_name
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Session name. For most target drivers this is a name that
+		identifies the initiator. Read-only.
+
+What:		/sys/bus/scst_target/devices/*/sessions/<session>/latency
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Latency statistics for this session. Only available if
+		CONFIG_SCST_MEASURE_LATENCY has been enabled in the
+		kernel configuration. Read-only.
+
+What:		/sys/bus/scst_target/devices/*/sessions/<session>/lun<number>/active_commands
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Number of active commands. Read-only.
+
+What:		/sys/bus/scst_target/devices/*/sessions/<session>/lun<number>/latency
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Latency statistics for this LUN. Only available if
+		CONFIG_SCST_MEASURE_LATENCY has been enabled in the kernel
+		configuration. Read-only.
+
+What:		/sys/bus/scst_target/devices/*/sessions/<session>/luns
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Soft link to the LUNs exported via this session. That soft
+		link either points to the LUNs associated with the
+		corresponding target or to the LUNs associated with an ACG.
+		Examples:
+
+		$ readlink /sys/devices/scst_local_tgt/sessions/scst_local_host/luns
+		../../luns
+		$ readlink /sys/devices/ib_srpt_target_0/sessions/0x00000000000000000002c9030005f34b/luns
+../../ini_groups/initiator1/luns
+
+What:		/sys/bus/scst_target/devices/*/rel_tgt_id
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		SCSI Relative Target Port Identifier, which is used by e.g.
+		persistent reservation commands. Read-write.
diff --git a/Documentation/ABI/stable/sysfs-devices-scst_target-scst_local b/Documentation/ABI/stable/sysfs-devices-scst_target-scst_local
new file mode 100644
index 0000000..4306ee0
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-scst_target-scst_local
@@ -0,0 +1,23 @@
+What:		/sys/bus/scst_target/devices/scst_local/phys_transport_version
+Date:		December 2010
+Contact:	Richard Sharpe <realrichardsharpe@gmail.com>
+Description:
+		SCSI physical transport version. Defines which physical
+		interface scst_local will resemble. See also SPC-4 for more
+		information. Read-write.
+
+What:		/sys/bus/scst_target/devices/scst_local/scsi_transport_version
+Date:		December 2010
+Contact:	Richard Sharpe <realrichardsharpe@gmail.com>
+Description:
+		SCSI transport version. Defines which SCSI transport
+		scst_local will resemble. The default is SAS. See also SPC-4
+		for more information. Read-write.
+
+What:		/sys/bus/scst_target/devices/scst_local/sessions/*/transport_id
+Date:		December 2010
+Contact:	Richard Sharpe <realrichardsharpe@gmail.com>
+Description:
+		SCSI transport ID in binary format. Necessary e.g. for
+		implementing persistent reservation support. See also SPC-4
+		for more information. Read-write.
diff --git a/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
new file mode 100644
index 0000000..698249a
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
@@ -0,0 +1,217 @@
+What:		/sys/bus/scst_tgt_dev/device/*/blocksize
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Block size that has been configured for a virtual device. Must
+		be a power of two and equal to or above 512. Read-create.
+
+What:		/sys/bus/scst_tgt_dev/device/*/exported/export<nr>
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Zero or more soft links to the LUNs via which this device
+		has been exported. An example:
+
+		$ for f in /sys/bus/scst_tgt_dev/devices/disk01/exported/export*; do echo $f; readlink $f; done
+		/sys/bus/scst_tgt_dev/devices/disk01/exported/export0
+		../../ib_srpt_target_0/ini_groups/initiator1/luns/0
+		/sys/bus/scst_tgt_dev/devices/disk01/exported/export1
+		../../ib_srpt_target_0/luns/0
+		/sys/bus/scst_tgt_dev/devices/disk01/exported/export2
+		../../ib_srpt_target_1/luns/0
+
+What:		/sys/bus/scst_tgt_dev/device/*/filename
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For virtual devices, the absolute path of the associated file
+		or device. Read-create for vdisk_blockio and vdisk_fileio
+		devices and read-only for vcdrom devices. For vcdrom devices
+		this parameter can be modified via the set_filename
+		command. Configuring a non-empty path is interpret as
+		inserting a medium and setting an empty path is interpret as
+		removing a medium. An example of how to add a vcdrom device,
+		how to trigger medium insertion and medium removal:
+
+		# echo "in device_driver/vcdrom add_device vcdrom1" >/sys/devices/scst/mgmt
+		# echo "in device/vcdrom1 set_filename /cdrom.iso" >/sys/devices/scst/mgmt
+		# cat /sys/bus/scst_tgt_dev/devices/vcdrom1/filename
+		/cdrom.iso
+		# echo "in device/vcdrom1 set_filename" >/sys/devices/scst/mgmt
+		# od -c /sys/bus/scst_tgt_dev/devices/vcdrom1/filename
+		0000000  \n
+		0000001
+
+What:		/sys/bus/scst_tgt_dev/device/*/nv_cache
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether or not acknowledging writes early has been enabled for
+		a vdisk_blockio or vdisk_fileio device. The value 1 means that
+		acknowledging writes early has been enabled and the value 0
+		means that acknowledging writes early has been disabled.
+		Warning: while enabling early write acknowledgements does
+		decrease I/O latency, for a storage medium that neither has a
+		non-volatile cache nor an UPS enabling early write
+		acknowledgements may result in data loss in case of a power
+		failure. Read-create.
+
+What:		/sys/bus/scst_tgt_dev/device/*/o_direct
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		The value 1 means that all caching has been disabled (direct
+		or non-buffered I/O) for a vdisk_fileio device and the value 0
+		means that caching is enabled (asynchronous or buffered
+		I/O). Read-create.
+
+What:		/sys/bus/scst_tgt_dev/device/*/read_only
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For virtual devices, whether or not to deny write commands. 1
+		stands for read-only and 0 for read-write. The "read_only"
+		file itself is read-create.
+
+What:		/sys/bus/scst_tgt_dev/device/*/removable
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For vdisk_blockio, vdisk_fileio and vdisk_nullio devices,
+		whether or not the underlying storage medium has been
+		configured as removable when the virtual device was
+		created. The value "1" means removable and the value "0" means
+		not removable. Read-create.
+
+What:		/sys/bus/scst_tgt_dev/device/*/resync_size
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For vdisk_fileio and vdisk_blockio devices, writing any data
+		to this file will cause SCST to reexamine the size of the
+		underlying storage medium. Write-only. See also the "filename"
+		and "size_mb" files.
+
+What:		/sys/bus/scst_tgt_dev/device/*/scsi_device
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For SCSI devices, the device identification in H:C:I:L format.
+		Read-only. An example:
+
+		$ cat /sys/bus/scst_tgt_dev/devices/1:0:0:0/scsi_device
+		1:0:0:0
+
+What:		/sys/bus/scst_tgt_dev/device/*/size_mb
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For virtual devices, the internally cached size in MB of the
+		underlying storage device (1 MB = 1048576 bytes). Read-only.
+		See also the "filename" and "resync_size" files.
+
+What:		/sys/bus/scst_tgt_dev/device/*/t10_dev_id
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		SCSI device ID associated with the virtual device. This is the
+		ID reported e.g. via the Device Identification page (0x83) of
+		the INQUIRY command. Read-write.
+
+What:		/sys/bus/scst_tgt_dev/device/*/thin_provisioned
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether or not thin provisioning support has been enabled (1)
+		or not (0) for a virtual device. If thin provisioning support
+		has been enabled, SCST will report to the SCSI initiator that
+		thin provisioning is supported and SCSI UNMAP commands will be
+		translated to deallocation requests for the underlying
+		storage. See also SBC-3 for further information. Read-create.
+
+What:		/sys/bus/scst_tgt_dev/device/*/threads_num
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Zero if the global thread pool is used for processing SCSI
+		commands received for a device or the number of threads of a
+		dedicated thread pool that is used for processing SCSI
+		commands received for this device (any number above zero).
+		Read-create. Modifying this parameter is possible via the
+		set_threads_num command. An example:
+
+		# cat /sys/bus/scst_tgt_dev/devices/disk01/threads_num
+		2
+		# echo "in device/disk01 set_threads_num 4" >/sys/devices/scst/mgmt
+		# cat /sys/bus/scst_tgt_dev/devices/disk01/threads_num
+		4
+
+What:		/sys/bus/scst_tgt_dev/device/*/threads_pool_type
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Thread pool configuration setting. This file will contain the
+		text "Async" if the global thread pool is used for processing
+		SCSI commands for this device. If a dedicated thread pool has
+		been configured then there is either one thread pool per
+		initiator ("per_initiator") or one thread pool for all
+		initiators ("shared"). Read-create. Modifying this parameter
+		is possible via the set_thread_pool_type command. An example:
+
+		# cat /sys/bus/scst_tgt_dev/devices/disk01/threads_pool_type
+		shared
+		# echo "in device/disk01 set_thread_pool_type per_initiator" >/sys/devices/scst/mgmt
+		# cat /sys/bus/scst_tgt_dev/devices/disk01/threads_pool_type
+		per_initiator
+
+What:		/sys/bus/scst_tgt_dev/device/*/type
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		A number in the range 0..17 representing the SCSI peripheral
+		device type as defined in SPC-4. Read-only. The defined types
+		and their meaning are:
+
+		 0 Direct access block device (e.g., magnetic disk)
+		 1 Sequential-access device (e.g., magnetic tape)
+		 2 Printer device
+		 3 Processor device
+		 4 Write-once device (e.g., some optical disks)
+		 5 CD/DVD device
+		 6 Scanner device (obsolete)
+		 7 Optical memory device (e.g., some optical disks)
+		 8 Media changer device (e.g., jukeboxes)
+		 9 Communications device (obsolete)
+		10 Obsolete
+		11 Obsolete
+		12 Storage array controller device (e.g., RAID)
+		13 Enclosure services device
+		14 Simplified direct-access device (e.g., magnetic disk)
+		15 Optical card reader/writer device
+		16 Bridge Controller Commands
+		17 Object-based Storage Device
+
+What:		/sys/bus/scst_tgt_dev/device/*/type_description
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Textual description of the SCSI peripheral device type as
+		defined in SPC-4. See also the description of the
+		"type" file for a list of descriptions. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/usn
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Unique serial number of a virtual device as reported e.g. by
+		the SCSI INQUIRY response. This number is generated by SCST
+		during creation of the virtual device by hashing the device
+		name and the setup ID. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/write_through
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether or not write-back caching has been disabled for a
+		vdisk_fileio device. The value 0 stands for write-back mode
+		and the value 1 stands for write-through mode. Read-create.
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_target b/Documentation/ABI/stable/sysfs-driver-scst_target
new file mode 100644
index 0000000..8592cec
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-scst_target
@@ -0,0 +1,55 @@
+What:		/sys/bus/scst_target/drivers/*/add_target
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether or not dynamic creation and removal of SCSI targets is
+		supported by a particular SCST target driver. The value 1
+		means that dynamic target creation/removal is supported
+		and the value 0 means that dynamic target creation/removal is
+		not supported. Read-only.
+
+What:		/sys/bus/scst_target/drivers/*/add_target_parameters
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Names of the parameters that may be specified at target
+		creation time. Each parameter name appears on a separate
+		line. This file only exists if dynamic target creation and
+		removal is supported. Read-only.
+
+What:		/sys/bus/scst_target/drivers/*/driver_attributes
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Names of the SCSI target driver sysfs files that may be created
+		or removed dynamically. Each file name appears on a
+		separate line. This file only exists if dynamic target driver
+		file creation and removal is supported. Read-only.
+
+What:		/sys/bus/scst_target/drivers/*/enabled
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Allows to enable or disable the operation of a SCST target
+		driver. The value 1 means enabled and 0 means disabled.
+		Defaults to 0 (disabled). This allows to configure a target
+		driver before it becomes operational. Only exists if disabling
+		the particual target driver is supported. Read-write.
+
+What:		/sys/bus/scst_target/drivers/*/target_attributes
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Names of the sysfs files that may be created and/or removed
+		dynamically for a target. Each file name appears on a separate
+		line. This file only exists if dynamic target file creation
+		and removal is supported. Read-only.
+
+What:		/sys/bus/scst_target/drivers/*/version
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Target driver version. Read-only. An example:
+
+		$ cat /sys/bus/scst_target/drivers/scst_local/version
+		1.0.0
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local b/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local
new file mode 100644
index 0000000..3ea28dc
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-scst_target-scst_local
@@ -0,0 +1,20 @@
+What:		/sys/bus/scst_target/drivers/scst_local/aborts
+Date:		December 2010
+Contact:	Richard Sharpe <realrichardsharpe@gmail.com>
+Description:
+		Number of SCSI commands that have been aborted by the SCSI
+		initiator. Read-only.
+
+What:		/sys/bus/scst_target/drivers/scst_local/device_resets
+Date:		December 2010
+Contact:	Richard Sharpe <realrichardsharpe@gmail.com>
+Description:
+		Number of SCSI device resets that have been performed by the
+		SCSI initiator. Read-only.
+
+What:		/sys/bus/scst_target/drivers/scst_local/target_resets
+Date:		December 2010
+Contact:	Richard Sharpe <realrichardsharpe@gmail.com>
+Description:
+		Number of SCSI target resets that have been performed by the
+		SCSI initiator. Read-only.
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
new file mode 100644
index 0000000..87fc58f
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
@@ -0,0 +1,51 @@
+What:		/sys/bus/scst_tgt_dev/drivers/*/add_device_parameters
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Names of the parameters supported when adding a device. Each
+		parameter name appears on a separate line. Read-only.
+		An example:
+
+		$ cat /sys/bus/scst_tgt_dev/drivers/vdisk_fileio/add_device_parameters
+		filename
+		blocksize
+		write_through
+		nv_cache
+		o_direct
+		read_only
+		removable
+		thin_provisioned
+
+What:		/sys/bus/scst_tgt_dev/drivers/*/type
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		A number in the range 0..17 representing the SCSI peripheral
+		device type of the devices managed by this driver as defined
+		in SPC-4. Read-only. The defined types and their meaning are:
+
+		 0 Direct access block device (e.g., magnetic disk)
+		 1 Sequential-access device (e.g., magnetic tape)
+		 2 Printer device
+		 3 Processor device
+		 4 Write-once device (e.g., some optical disks)
+		 5 CD/DVD device
+		 6 Scanner device (obsolete)
+		 7 Optical memory device (e.g., some optical disks)
+		 8 Media changer device (e.g., jukeboxes)
+		 9 Communications device (obsolete)
+		10 Obsolete
+		11 Obsolete
+		12 Storage array controller device (e.g., RAID)
+		13 Enclosure services device
+		14 Simplified direct-access device (e.g., magnetic disk)
+		15 Optical card reader/writer device
+		16 Bridge Controller Commands
+		17 Object-based Storage Device
+
+What:		/sys/bus/scst_tgt_dev/drivers/*/type_description
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Textual description of the SCSI peripheral type of the devices
+		managed by this driver. Read-only.
