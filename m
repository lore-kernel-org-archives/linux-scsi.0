From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCHv2 3/3] [SCSI] scst: Move devices doc to Documentation/ABI
Date: Thu, 23 Dec 2010 19:58:51 +0100
Message-ID: <201012231958.51847.bvanassche@acm.org>
References: <201012231956.54825.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:46562 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab0LWS7B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 13:59:01 -0500
In-Reply-To: <201012231956.54825.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

Move the documentation about the sysfs attributes of the SCST
pass-through and virtual devices to Documentation/ABI/stable.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Richard Sharpe <realrichardsharpe@gmail.com>
---
 .../ABI/stable/sysfs-devices-scst_tgt_dev          |  136 ++++++++++++++++++++
 Documentation/ABI/stable/sysfs-driver-scst_tgt_dev |   27 ++++
 Documentation/scst/README.scst                     |  106 ---------------
 3 files changed, 163 insertions(+), 106 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
 create mode 100644 Documentation/ABI/stable/sysfs-driver-scst_tgt_dev

diff --git a/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
new file mode 100644
index 0000000..cfa791e
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
@@ -0,0 +1,136 @@
+What:		/sys/bus/scst_tgt_dev/device/*/blocksize
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Block size used by the virtual device. Must be a power of two
+		and equal to or above 512. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/exported/export<nr>
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Zero or more soft links to the LUNs through which this device
+		has been exported. An example:
+
+		$ readlink /sys/bus/scst_tgt_dev/devices/disk01/exported/export0
+		../../scst_local_tgt/luns/0
+
+What:		/sys/bus/scst_tgt_dev/device/*/filename
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For virtual devices, the absolute path of the associated file
+		or device. Read-only. An example:
+
+		# cat /sys/devices/disk01/filename
+		/dev/sdc
+		[key]
+
+What:		/sys/bus/scst_tgt_dev/device/*/nv_cache
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether or not the device has a non-volatile cache. SCST uses
+		this information to decide whether or not it is safe to
+		acknowledge writes early to the initiator. Setting this
+		attribute to 1 for a device that neither has a non-volatile
+		cache nor an UPS will decrease I/O latency but may result in
+		data loss in case of a power failure. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/o_direct
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		The value 1 means that all caching has been disabled for
+		a virtual device (direct I/O) and the value 0 means that caching
+		is enabled. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/read_only
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For virtual devices, whether or not to deny write commands.
+		Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/removable
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For virtual devices, whether or not the underlying storage
+		medium is removable. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/resync_size
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For virtual devices, writing to this attribute will update the
+		internally cached device size. Write-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/scsi_device
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For SCSI devices, the device identification. Read-only. An
+		example:
+
+		$ cat /sys/bus/scst_tgt_dev/devices/1:0:0:0/scsi_device
+		1:0:0:0
+
+What:		/sys/bus/scst_tgt_dev/device/*/size_mb
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		For virtual devices, the internally cached size in MB of the
+		underlying storage device. Read-only.
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
+		Whether or not the virtual device supports thin provisioning,
+		or in other words, that remote initiators can mark storage as
+		unallocated. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/threads_num
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Number of threads in the thread pool that is used for
+		processing SCSI commands for this device. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/threads_pool_type
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether to use a distinct thread pool per initiator
+		("per_initiator") or one thread pool for all initiators
+		accessing this device ("shared"). Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/type
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		SCSI type of this device. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/usn
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Unique serial number as reported e.g. by the SCSI INQUIRY
+		response. Read-only.
+
+What:		/sys/bus/scst_tgt_dev/device/*/write_through
+Date:		December 2010
+Contact:	Bart Van Assche <bvanassche@acm.org>
+Description:
+		Whether or not write-back caching has been disabled for a
+		virtual device. The value 0 stands for write-back mode and the
+		value 1 stands for write-through mode. Read-only.
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
new file mode 100644
index 0000000..c79aee0
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
@@ -0,0 +1,27 @@
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
+		SCSI type of the devices managed by this driver. Read-only.
+		An example:
+
+		$ cat /sys/bus/scst_tgt_dev/drivers/vcdrom/type
+		5 - CD-ROM device
diff --git a/Documentation/scst/README.scst b/Documentation/scst/README.scst
index d098c3b..27e2a0c 100644
--- a/Documentation/scst/README.scst
+++ b/Documentation/scst/README.scst
@@ -571,112 +571,6 @@ echo "add_device disk1 filename=/disk1; blocksize=4096; nv_cache=1" >/sys/kernel
 will create a FILEIO virtual device disk1 with backend file /disk1
 with block size 4K and NV_CACHE enabled.
 
-Each vdisk_fileio's device has the following attributes in
-/sys/kernel/scst_tgt/devices/device_name:
-
- - filename - contains path and file name of the backend file.
-
- - blocksize - contains block size used by this virtual device.
-
- - write_through - contains status of write back caching of this virtual
-   device.
-
- - read_only - contains read only status of this virtual device.
-
- - o_direct - contains O_DIRECT status of this virtual device.
-
- - nv_cache - contains NV_CACHE status of this virtual device.
-
- - thin_provisioned - contains thin provisioning status of this virtual
-   device
-
- - removable - contains removable status of this virtual device.
-
- - size_mb - contains size of this virtual device in MB.
-
- - t10_dev_id - contains and allows to set T10 vendor specific
-   identifier for Device Identification VPD page (0x83) of INQUIRY data.
-   By default VDISK handler always generates t10_dev_id for every new
-   created device at creation time based on the device name and
-   scst_vdisk_ID scst_vdisk.ko module parameter (see below).
-
- - usn - contains the virtual device's serial number of INQUIRY data. It
-   is created at the device creation time based on the device name and
-   scst_vdisk_ID scst_vdisk.ko module parameter (see below).
-
- - type - contains SCSI type of this virtual device.
-
- - resync_size - write only attribute, which makes vdisk_fileio to
-   rescan size of the backend file. It is useful if you changed it, for
-   instance, if you resized it.
-
-For example:
-
-/sys/kernel/scst_tgt/devices/disk1
-|-- blocksize
-|-- exported
-|   |-- export0 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt/luns/0
-|   |-- export1 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt/ini_groups/INI/luns/0
-|   |-- export2 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt1/luns/0
-|   |-- export3 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt1/ini_groups/INI1/luns/0
-|   |-- export4 -> ../../../targets/iscsi/iqn.2006-10.net.vlnb:tgt1/ini_groups/INI2/luns/0
-|-- filename
-|-- handler -> ../../handlers/vdisk_fileio
-|-- nv_cache
-|-- o_direct
-|-- read_only
-|-- removable
-|-- resync_size
-|-- size_mb
-|-- t10_dev_id
-|-- thin_provisioned
-|-- threads_num
-|-- threads_pool_type
-|-- type
-|-- usn
-`-- write_through
-
-Each vdisk_blockio's device has the following attributes in
-/sys/kernel/scst_tgt/devices/device_name: blocksize, filename, nv_cache,
-read_only, removable, resync_size, size_mb, t10_dev_id,
-thin_provisioned, threads_num, threads_pool_type, type, usn. See above
-description of those parameters.
-
-Each vdisk_nullio's device has the following attributes in
-/sys/kernel/scst_tgt/devices/device_name: blocksize, read_only,
-removable, size_mb, t10_dev_id, threads_num, threads_pool_type, type,
-usn. See above description of those parameters.
-
-Each vcdrom's device has the following attributes in
-/sys/kernel/scst_tgt/devices/device_name: filename, size_mb,
-t10_dev_id, threads_num, threads_pool_type, type, usn. See above
-description of those parameters. Exception is filename attribute. For
-vcdrom it is writable. Writing to it allows to virtually insert or
-change virtual CD media in the virtual CDROM device. For example:
-
- - echo "/image.iso" >/sys/kernel/scst_tgt/devices/cdrom/filename - will
-   insert file /image.iso as virtual media to the virtual CDROM cdrom.
-
- - echo "" >/sys/kernel/scst_tgt/devices/cdrom/filename - will remove
-   "media" from the virtual CDROM cdrom.
-
-Additionally VDISK handler has module parameter "num_threads", which
-specifies count of I/O threads for each FILEIO VDISK's or VCDROM device.
-If you have a workload, which tends to produce rather random accesses
-(e.g. DB-like), you should increase this count to a bigger value, like
-32. If you have a rather sequential workload, you should decrease it to
-a lower value, like number of CPUs on the target or even 1. Due to some
-limitations of Linux I/O subsystem, increasing number of I/O threads too
-much leads to sequential performance drop, especially with deadline
-scheduler, so decreasing it can improve sequential performance. The
-default provides a good compromise between random and sequential
-accesses.
-
-You shouldn't be afraid to have too many VDISK I/O threads if you have
-many VDISK devices. Kernel threads consume very little amount of
-resources (several KBs) and only necessary threads will be used by SCST,
-so the threads will not trash your system.
-
 CAUTION: If you partitioned/formatted your device with block size X, *NEVER*
 ======== ever try to export and then mount it (even accidentally) with another
          block size. Otherwise you can *instantly* damage it pretty
-- 
1.7.1

