From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: scsi_scan.c reports 'target allocation failed, error -6' w/
 mptsas
Date: Fri, 20 Jan 2012 09:27:43 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A60481F5304E@inbmail02.lsi.com>
References: <20120118100635.GA19750@dot.freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:54456 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab2ATD5v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jan 2012 22:57:51 -0500
In-Reply-To: <20120118100635.GA19750@dot.freshdot.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sander Smeenk <ssmeenk@freshdot.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Request you to provide the response of  "modinfo mptsas".
Also please capture the logs with the scsi logging set to 0x180000DB.
"echo 0x180000db > /proc/sys/dev/scsi/logging_level".

And mptsas debug level set to 0x3f8
"echo 3f8 > /sys/module/mptbase/parameters/mpt_debug_level"

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Sander Smeenk
Sent: Wednesday, January 18, 2012 3:37 PM
To: linux-scsi@vger.kernel.org
Subject: scsi_scan.c reports 'target allocation failed, error -6' w/ mptsas

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
