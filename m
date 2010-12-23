From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCHv2 2/3] [SCSI] scst: Move device docs to Documentation/ABI
Date: Thu, 23 Dec 2010 19:58:10 +0100
Message-ID: <201012231958.10233.bvanassche@acm.org>
References: <201012231956.54825.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:46427 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab0LWS6S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 13:58:18 -0500
In-Reply-To: <201012231956.54825.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

Move the documentation about the sysfs attributes of the SCST
virtual device to Documentation/ABI/stable.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Richard Sharpe <realrichardsharpe@gmail.com>
---
 Documentation/ABI/stable/sysfs-devices-scst |  142 +++++++++++++++++++++++++++
 Documentation/scst/README.scst              |   71 -------------
 2 files changed, 142 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-devices-scst

diff --git a/Documentation/ABI/stable/sysfs-devices-scst b/Documentation/ABI/stable/sysfs-devices-scst
new file mode 100644
index 0000000..03972c4
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-scst
@@ -0,0 +1,142 @@
+What:		/sys/devices/scst/mgmt
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Interface through which SCST management commands can be issued.
+		The documentation of the syntax of these commands can be
+		obtained by reading this file:
+
+		# cat mgmt
+		in device/<dev> <dev_cmd>
+		in device_driver/<devt> <devt_cmd>
+		in target_driver/<tgtt> <tgtt_cmd>
+		in target_driver/<tgtt>/<target>/luns <tgt_cmd>
+		in target_driver/<tgtt>/<target>/luns <luns_cmd>
+		in target_driver/<tgtt>/<target>/ini_groups <acg_mgmt_cmd>
+		in target_driver/<tgtt>/<target>/ini_groups/<acg> <acg_cmd>
+		in target_driver/<tgtt>/<target>/ini_groups/<acg>/luns <luns_cmd>
+		in target_driver/<tgtt>/<target>/ini_groups/<acg>/initiators <acg_ini_cmd>
+
+		dev_cmd syntax:
+
+		set_filename <filename>
+		set_threads_num <n>
+		set_thread_pool_type <thread_pool_type>
+
+		devt_cmd syntax:
+
+		add_device device_name [parameters]
+		del_device device_name
+		add_attribute <attribute> <value>
+		del_attribute <attribute> <value>
+		add_device_attribute device_name <attribute> <value>
+		del_device_attribute device_name <attribute> <value>
+
+		devt_cmd syntax for pass-through device types:
+
+		add_device H:C:I:L
+		del_device H:C:I:L
+
+		tgtt_cmd syntax:
+
+		add_target target_name [parameters]
+		del_target target_name
+		add_attribute <attribute> <value>
+		del_attribute <attribute> <value>
+		add_target_attribute target_name <attribute> <value>"
+		del_target_attribute target_name <attribute> <value>"
+
+		where parameters is one or more <name>=<value> pairs separated by ';'
+
+		tgt_cmd syntax:
+
+		enable
+		disable
+		set_cpu_mask <mask>
+
+		luns_cmd syntax:
+
+		add|del H:C:I:L lun [parameters]
+		add VNAME lun [parameters]
+		del lun
+		replace H:C:I:L lun [parameters]
+		replace VNAME lun [parameters]
+		clear
+
+		where parameters is either 'read_only' or empty.
+
+		acg_mgmt_cmd syntax:
+
+		create <group_name>
+		del <group_name>
+
+		acg_cmd syntax:
+		set_cpu_mask <mask>
+
+		acg_ini_cmd syntax:
+
+		add <initiator_name>
+		del <initiator_name>
+		move <initiator_name> <dest_group_name>
+		clear
+
+What:		/sys/devices/scst/setup_id
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		SCST setup ID. Allows to identify otherwise identical SCST
+		setups on different systems. Makes the IDs and SNs of
+		otherwise identical SCST devices unique. As an example,	the
+		vdisk device handler uses this to generate the T10 vendor
+		specific identifier and SN of vdisk devices. Read-write.
+
+What:		/sys/devices/scst/sgv/global_stats
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Global SGV (scatter/gather vector) cache statistics. Read-only.
+		An example:
+
+		$ cat sgv/global_stats
+		Inactive/active pages		0/0
+		Hi/lo watermarks [pages]		62208/0
+		Hi watermark releases/failures		0/0
+		Other allocs		0
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
+		Number of global I/O threads. Global I/O threads are used by
+		asynchronous device handlers, e.g. the vdisk blockio handler.
+		Read-write.
+
+What:		/sys/devices/scst/version
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		SCST version (first line) and compile-time configuration
+		(subsequent lines). Read-only. An example:
+
+		$ cat /sys/devices/scst/version
+		2.0.0
+		TRACING
+		DEBUG
diff --git a/Documentation/scst/README.scst b/Documentation/scst/README.scst
index 7c16d5c..d098c3b 100644
--- a/Documentation/scst/README.scst
+++ b/Documentation/scst/README.scst
@@ -253,45 +253,6 @@ SCST sysfs interface
 Root of SCST sysfs interface is /sys/kernel/scst_tgt. It has the
 following entries:
 
- - devices - this is a root subdirectory for all SCST devices
-
- - handlers - this is a root subdirectory for all SCST dev handlers
-
- - sgv - this is a root subdirectory for all SCST SGV caches
-
- - targets - this is a root subdirectory for all SCST targets
-
- - setup_id - allows to read and write SCST setup ID. This ID can be
-   used in cases, when the same SCST configuration should be installed
-   on several targets, but exported from those targets devices should
-   have different IDs and SNs. For instance, VDISK dev handler uses this
-   ID to generate T10 vendor specific identifier and SN of the devices.
-
- - threads - allows to read and set number of global SCST I/O threads.
-   Those threads used with async. dev handlers, for instance, vdisk
-   BLOCKIO or NULLIO.
-
- - trace_level - allows to enable and disable various tracing
-   facilities. See content of this file for help how to use it.
-
- - version - read-only attribute, which allows to see version of
-   SCST and enabled optional features.
-
- - last_sysfs_mgmt_res - read-only attribute returning completion status
-   of the last management command. In the sysfs implementation there are
-   some problems between internal sysfs and internal SCST locking. To
-   avoid them in some cases sysfs calls can return error with errno
-   EAGAIN. This doesn't mean the operation failed. It only means that
-   the operation queued and not yet completed. To wait for it to
-   complete, an management tool should poll this file. If the operation
-   hasn't yet completed, it will also return EAGAIN. But after it's
-   completed, it will return the result of this operation (0 for success
-   or -errno for error).
-
-Each SCST sysfs file (attribute) can contain in the last line mark
-"[key]". It is automatically added mark used to allow scstadmin to see
-which attributes it should save in the config file. You can ignore it.
-
 "Devices" subdirectory contains subdirectories for each SCST devices.
 
 Content of each device's subdirectory is dev handler specific. See
@@ -325,38 +286,6 @@ SCST dev handlers can have the following common entries:
 See below for more information about other entries of this subdirectory
 of the standard SCST dev handlers.
 
-"Handlers" subdirectory contains subdirectories for each SCST dev
-handler.
-
-Content of each handler's subdirectory is dev handler specific. See
-documentation for your dev handlers for more info about it as well as
-SysfsRules file for more info about common to all dev handlers rules.
-SCST dev handlers can have the following common entries:
-
- - mgmt - this entry allows to create virtual devices and their
-   attributes (for virtual devices dev handlers) or assign/unassign real
-   SCSI devices to/from this dev handler (for pass-through dev
-   handlers).
-
- - trace_level - allows to enable and disable various tracing
-   facilities. See content of this file for help how to use it.
-
- - type - SCSI type of devices served by this dev handler.
-
-See below for more information about other entries of this subdirectory
-of the standard SCST dev handlers.
-
-"Sgv" subdirectory contains statistic information of SCST SGV caches. It
-has the following entries:
-
- - None, one or more subdirectories for each existing SGV cache.
-
- - global_stats - file containing global SGV caches statistics.
-
-Each SGV cache's subdirectory has the following item:
-
- - stats - file containing statistics for this SGV caches.
-
 
 Access and devices visibility management (LUN masking)
 ------------------------------------------------------
-- 
1.7.1

