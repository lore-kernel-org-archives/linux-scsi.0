From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH 4/7] [SCSI] scst: Add SRP target driver
Date: Tue, 21 Dec 2010 09:50:18 +0800
Message-ID: <544F03C80B314396A5517F4CD1A848B6@usish.com.cn>
References: <201012201849.27639.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:33597 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933397Ab0LUBuc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2010 20:50:32 -0500
In-Reply-To: <201012201849.27639.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Bart Van Assche' <bvanassche@acm.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-rdma@vger.kernel.org, James.Bottomley@suse.de
Cc: 'Vu Pham' <vu@mellanox.com>, 'Roland Dreier' <rolandd@cisco.com>, 'David Dillow' <dave@thedillows.org>

> 
> This patch adds the kernel module ib_srpt, which is a SCSI RDMA Protocol
(SRP)
> target implementation. This driver uses the InfiniBand stack and the SCST
core.
> 
> It is a high performance driver capable of handling 600K+ 4K random write
> IOPS by a single target as well as 2.5+ GB/s sequential throughput over
> a single QDR IB port.
> 
> This driver was originally developed by Vu Pham (Mellanox) and has been
> optimized by Bart Van Assche.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
> Cc: Vu Pham <vu@mellanox.com>
> Cc: Roland Dreier <rdreier@cisco.com>
> Cc: David Dillow <dillowda@ornl.gov>
> ---
>  Documentation/scst/README.srpt |  112 ++
>  drivers/scst/Kconfig           |    1 +
>  drivers/scst/Makefile          |    2 +-
>  drivers/scst/srpt/Kconfig      |   12 +
>  drivers/scst/srpt/Makefile     |    1 +
>  drivers/scst/srpt/ib_dm_mad.h  |  139 ++
>  drivers/scst/srpt/ib_srpt.c    | 3613
> ++++++++++++++++++++++++++++++++++++++++
>  drivers/scst/srpt/ib_srpt.h    |  352 ++++
>  8 files changed, 4231 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/scst/README.srpt
>  create mode 100644 drivers/scst/srpt/Kconfig
>  create mode 100644 drivers/scst/srpt/Makefile
>  create mode 100644 drivers/scst/srpt/ib_dm_mad.h
>  create mode 100644 drivers/scst/srpt/ib_srpt.c
>  create mode 100644 drivers/scst/srpt/ib_srpt.h
> 
> diff --git a/Documentation/scst/README.srpt
> b/Documentation/scst/README.srpt
> new file mode 100644
> index 0000000..6f8b3ca
> --- /dev/null
> +++ b/Documentation/scst/README.srpt
> @@ -0,0 +1,112 @@
> +SCSI RDMA Protocol (SRP) Target driver for Linux
> +=================================================
> +
> +The SRP Target driver is designed to work directly on top of the
> +OpenFabrics OFED-1.x software stack (http://www.openfabrics.org) or
> +the Infiniband drivers in the Linux kernel tree
> +(http://www.kernel.org). The SRP target driver also interfaces with
> +the generic SCSI target mid-level driver called SCST
> +(http://scst.sourceforge.net).
> +
> +How-to run
> +-----------
> +
> +A. On srp target machine
> +1. Please refer to SCST's README for loading scst driver and its
> +dev_handlers drivers (scst_disk, scst_vdisk block or file IO mode,
> nullio, ...)
> +
> +Example 1: working with real back-end scsi disks
> +a. modprobe scst
> +b. modprobe scst_disk
> +c. cat /proc/scsi_tgt/scsi_tgt
> +
> +ibstor00:~ # cat /proc/scsi_tgt/scsi_tgt
> +Device (host:ch:id:lun or name)                             Device
handler
> +0:0:0:0                                                     dev_disk
> +4:0:0:0                                                     dev_disk
> +5:0:0:0                                                     dev_disk
> +6:0:0:0                                                     dev_disk
> +7:0:0:0                                                     dev_disk
> +
> +Now you want to exclude the first scsi disk and expose the last 4 scsi
disks
> as
> +IB/SRP luns for I/O
> +echo "add 4:0:0:0 0" >/proc/scsi_tgt/groups/Default/devices
> +echo "add 5:0:0:0 1" >/proc/scsi_tgt/groups/Default/devices
> +echo "add 6:0:0:0 2" >/proc/scsi_tgt/groups/Default/devices
> +echo "add 7:0:0:0 3" >/proc/scsi_tgt/groups/Default/devices
> +
> +Example 2: working with VDISK FILEIO mode (using md0 device and file
10G-file)
> +a. modprobe scst
> +b. modprobe scst_vdisk
> +c. echo "open vdisk0 /dev/md0" > /proc/scsi_tgt/vdisk/vdisk
> +d. echo "open vdisk1 /10G-file" > /proc/scsi_tgt/vdisk/vdisk
> +e. echo "add vdisk0 0" >/proc/scsi_tgt/groups/Default/devices
> +f. echo "add vdisk1 1" >/proc/scsi_tgt/groups/Default/devices
> +
> +Example 3: working with VDISK BLOCKIO mode (using md0 device, sda, and
> cciss/c1d0)
> +a. modprobe scst
> +b. modprobe scst_vdisk
> +c. echo "open vdisk0 /dev/md0 BLOCKIO" > /proc/scsi_tgt/vdisk/vdisk
> +d. echo "open vdisk1 /dev/sda BLOCKIO" > /proc/scsi_tgt/vdisk/vdisk
> +e. echo "open vdisk2 /dev/cciss/c1d0 BLOCKIO" >
/proc/scsi_tgt/vdisk/vdisk
> +f. echo "add vdisk0 0" >/proc/scsi_tgt/groups/Default/devices
> +g. echo "add vdisk1 1" >/proc/scsi_tgt/groups/Default/devices
> +h. echo "add vdisk2 2" >/proc/scsi_tgt/groups/Default/devices
> +

[Jack] This README looks should update to new sysfs interface too.


