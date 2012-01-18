From: Sander Smeenk <ssmeenk@freshdot.net>
Subject: scsi_scan.c reports 'target allocation failed, error -6' w/ mptsas
Date: Wed, 18 Jan 2012 11:06:35 +0100
Message-ID: <20120118100635.GA19750@dot.freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dot.freshdot.net ([213.154.236.176]:51628 "EHLO
	dot.freshdot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab2ARKXb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2012 05:23:31 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

i'm experiencing issues while hot(re)plugging SAS-drives in a server
running 2.6.32-37 (stock Ubuntu Lucid). The disks are connected to an
LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS HBA (1000:0500 r2)
Google has no information at all on this specific errormessage.

Situation:
The server is running on 4xSAS drives with the mptsas module, disks are
JBODed to the OS, the OS has them in mdadm software raid.

Each disk needs to be replaced so i unconfigure one in mdadm, ask the
kernel to 'delete' the device node:
| # echo 1 > /sys/block/sdN/device/delete

And then i pull the disk after which the kernel logs:
| scsi: killing requests for dead queue
| scsi target4:0:1: mptsas: ioc0: delete device: fw_channel 0, fw_id 1,
|                   phy 1, sas_addr 0x500000e019670902

When i reseat the replacement disk, nothing gets logged. When i then ask
the kernel to rescan the scsi bus on host4, the kernel logs an error:

| # echo '- - -' > /sys/class/scsi_host/host4/scan
| scsi target4:0:4: target allocation failed, error -6

The replacement drive will not be available to the OS until the system
is rebooted after which the drive works like a charm. 

The error message is produced in drivers/scsi/scsi_scan.c but i believe
the target_alloc() call comes from the drivers/scsi/mtpsas/mptsas.c
driver. Unfortunately my kernelhack-fu is lacking to look into this
further. As stated, Google has no information about this either.

Anyone on this list with clues as to why this happens or how to
circumvent it from happening with the other three disks?

Thanks,
With regards,
-Sander.
-- 
| How do you write zero in Roman numerals?
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
