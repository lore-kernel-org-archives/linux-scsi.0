From: Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: Re: [PATCH 3/3] [SCSI] scst: Move SCST devices documentation to Documentation/ABI
Date: Thu, 23 Dec 2010 10:11:47 -0500
Message-ID: <201012231011.47995.konrad@darnok.org>
References: <201012222144.47522.bvanassche@acm.org> <201012222147.00547.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:38164 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0LWTtm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 14:49:42 -0500
In-Reply-To: <201012222147.00547.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, vst@vlnb.net, realrichardsharpe@gmail.com, scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>


> +
> +What:           /sys/bus/scst_tgt_dev/device/*/exported/export<nr>
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		Zero or more soft links to the LUNs through which this device
> +		has been exported. An example:
> +
> +		$ readlink /sys/bus/scst_tgt_dev/devices/disk01/exported/export0
> +		../../scst_local_tgt/luns/0
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/filename
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		For virtual devices, the absolute path of the associated file
> +		or device. Read-only. An example:
> +
> +		# cat /sys/devices/disk01/filename
> +		/dev/sdc
> +		[key]

Key?
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/nv_cache
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		Whether or not the device has a non-volatile cache. SCST uses
> +		this information to decide whether or not it is safe to
> +		acknowledge writes early to the initiator. Setting this
> +		attribute to 1 for a device that neither has a non-volatile
> +		cache nor an UPS will decrease I/O latency but may result in
> +		data loss in case of a power failure. Read-only.
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/o_direct
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		The value 1 means that all caching has been disabled for
> +		a virtual device (direct I/O) and the value 0 means that caching
> +		is enabled. Read-only.
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/read_only
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		For virtual devices, whether or not to deny write commands.
> +		Read-only.

So earlier on (in o_direct) you mentioned the proper values (0 or 1). Would it 
make sense to have that here too?

> +
> +What:           /sys/bus/scst_tgt_dev/device/*/removable
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		For virtual devices, whether or not the underlying storage
> +		medium is removable. Read-only.

Ditto.
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/resync_size
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		For virtual devices, writing to this attribute will update the
> +		internally cached device size. Write-only.

Is this in kB or bytes or pages?
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/scsi_device
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		For SCSI devices, the device identification. Read-only. An
> +		example:
> +
> +		$ cat /sys/bus/scst_tgt_dev/devices/1:0:0:0/scsi_device
> +		1:0:0:0
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/size_mb
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		For virtual devices, the internally cached size in MB of the
> +		underlying storage device. Read-only.
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/t10_dev_id
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		SCSI device ID associated with the virtual device. This is the
> +		ID reported e.g. via the Device Identification page (0x83) of
> +		the INQUIRY command. Read-write.
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/thin_provisioned
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		Whether or not the virtual device supports thin provisioning,
> +		or in other words, that remote initiators can mark storage as
> +		unallocated. Read-only.

Wouldn't you want to be able to toggle that? Say if the device does support 
thin provisioning but you want to disable it?
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/threads_num
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		Number of threads in the thread pool that is used for
> +		processing SCSI commands for this device. Read-only.
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/threads_pool_type
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		Whether to use a distinct thread pool per initiator

Whether would imply you can change the allocation. It sounds however you are 
just told what it is. Perhaps "What type of thread pool pool is used per 
initiator."?

> +		("per_initiator") or one thread pool for all initiators
> +		accessing this device ("shared"). Read-only.
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/type
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		SCSI type of this device. Read-only.
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/usn
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		Unique serial number as reported e.g. by the SCSI INQUIRY
> +		response. Read-only.
> +
> +What:           /sys/bus/scst_tgt_dev/device/*/write_through
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		Whether or not write-back caching has been disabled for a
> +		virtual device. The value 0 stands for write-back mode and the
> +		value 1 stands for write-through mode. Read-only.
> diff --git a/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
> b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev new file mode 100644
> index 0000000..33a9221
> --- /dev/null
> +++ b/Documentation/ABI/stable/sysfs-driver-scst_tgt_dev
> @@ -0,0 +1,29 @@
> +What:           /sys/bus/scst_tgt_dev/drivers/*/add_device_parameters
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		Names of the parameters supported when adding a device. Each
> +		parameter name appears on a separate line. Read-only.
> +		An example:
> +
> +		$ cat /sys/bus/scst_tgt_dev/drivers/vdisk_fileio/add_device_parameters
> +		filename
> +		blocksize
> +		write_through
> +		nv_cache
> +		o_direct
> +		read_only
> +		removable
> +		thin_provisioned
> +
> +What:           /sys/bus/scst_tgt_dev/drivers/*/type
> +Date:           December 2010
> +KernelVersion:  2.6.38
> +Contact:        linux-scsi@vger.kernel.org
> +Description:
> +		SCSI type of the devices managed by this driver. Read-only.
> +		An example:
> +
> +		$ cat /sys/bus/scst_tgt_dev/drivers/vcdrom/type
> +		5 - CD-ROM device
