From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/3] [SCSI] scst: Move SCST devices documentation to Documentation/ABI
Date: Wed, 22 Dec 2010 21:47:00 +0100
Message-ID: <201012222147.00547.bvanassche@acm.org>
References: <201012222144.47522.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:59388 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab0LVUrQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2010 15:47:16 -0500
In-Reply-To: <201012222144.47522.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: vst@vlnb.net, realrichardsharpe@gmail.com, scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>

Move the documentation about the sysfs attributes of the SCST
pass-through and virtual devices to Documentation/ABI/stable.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
---
 .../ABI/stable/sysfs-devices-scst_tgt_dev          |  153 ++++++++++++++++++++
 Documentation/ABI/stable/sysfs-driver-scst_tgt_dev |   29 ++++
 2 files changed, 182 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
 create mode 100644 Documentation/ABI/stable/sysfs-driver-scst_tgt_dev

diff --git a/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
new file mode 100644
index 0000000..ab09c21
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-devices-scst_tgt_dev
@@ -0,0 +1,153 @@
+What:           /sys/bus/scst_tgt_dev/device/*/blocksize
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Block size used by the virtual device. Must be a power of two
+		and equal to or above 512. Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/exported/export<nr>
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Zero or more soft links to the LUNs through which this device
+		has been exported. An example:
+
+		$ readlink /sys/bus/scst_tgt_dev/devices/disk01/exported/export0
+		../../scst_local_tgt/luns/0
+
+What:           /sys/bus/scst_tgt_dev/device/*/filename
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		For virtual devices, the absolute path of the associated file
+		or device. Read-only. An example:
+
+		# cat /sys/devices/disk01/filename
+		/dev/sdc
+		[key]
+
+What:           /sys/bus/scst_tgt_dev/device/*/nv_cache
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Whether or not the device has a non-volatile cache. SCST uses
+		this information to decide whether or not it is safe to
+		acknowledge writes early to the initiator. Setting this
+		attribute to 1 for a device that neither has a non-volatile
+		cache nor an UPS will decrease I/O latency but may result in
+		data loss in case of a power failure. Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/o_direct
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		The value 1 means that all caching has been disabled for
+		a virtual device (direct I/O) and the value 0 means that caching
+		is enabled. Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/read_only
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		For virtual devices, whether or not to deny write commands.
+		Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/removable
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		For virtual devices, whether or not the underlying storage
+		medium is removable. Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/resync_size
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		For virtual devices, writing to this attribute will update the
+		internally cached device size. Write-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/scsi_device
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		For SCSI devices, the device identification. Read-only. An
+		example:
+
+		$ cat /sys/bus/scst_tgt_dev/devices/1:0:0:0/scsi_device
+		1:0:0:0
+
+What:           /sys/bus/scst_tgt_dev/device/*/size_mb
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		For virtual devices, the internally cached size in MB of the
+		underlying storage device. Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/t10_dev_id
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		SCSI device ID associated with the virtual device. This is the
+		ID reported e.g. via the Device Identification page (0x83) of
+		the INQUIRY command. Read-write.
+
+What:           /sys/bus/scst_tgt_dev/device/*/thin_provisioned
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Whether or not the virtual device supports thin provisioning,
+		or in other words, that remote initiators can mark storage as
+		unallocated. Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/threads_num
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Number of threads in the thread pool that is used for
+		processing SCSI commands for this device. Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/threads_pool_type
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Whether to use a distinct thread pool per initiator
+		("per_initiator") or one thread pool for all initiators
+		accessing this device ("shared"). Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/type
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		SCSI type of this device. Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/usn
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Unique serial number as reported e.g. by the SCSI INQUIRY
+		response. Read-only.
+
+What:           /sys/bus/scst_tgt_dev/device/*/write_through
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		Whether or not write-back caching has been disabled for a
+		virtual device. The value 0 stands for write-back mode and the
+		value 1 stands for write-through mode. Read-only.
diff --git a/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
new file mode 100644
index 0000000..33a9221
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
@@ -0,0 +1,29 @@
+What:           /sys/bus/scst_tgt_dev/drivers/*/add_device_parameters
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
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
+What:           /sys/bus/scst_tgt_dev/drivers/*/type
+Date:           December 2010
+KernelVersion:  2.6.38
+Contact:        linux-scsi@vger.kernel.org
+Description:
+		SCSI type of the devices managed by this driver. Read-only.
+		An example:
+
+		$ cat /sys/bus/scst_tgt_dev/drivers/vcdrom/type
+		5 - CD-ROM device
-- 
1.7.1

