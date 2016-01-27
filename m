From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] SCSI: Add Marvell Console to VPD blacklist
Date: Wed, 27 Jan 2016 16:19:13 +0200
Message-ID: <1453904353-42756-1-git-send-email-mika.westerberg@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23445 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932555AbcA0OTV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 09:19:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Mika Westerberg <mika.westerberg@linux.intel.com>, linux-scsi@vger.kernel.org

I have a Marvell 88SE9230 SATA Controller that has some sort of
integrated console SCSI device attached to one of the ports.

  ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  ata14.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
  ata14.00: configured for UDMA/66
  scsi 13:0:0:0: Processor         Marvell  Console 1.01 PQ: 0 ANSI: 5

Sending it VPD INQUIRY command seem to always fail with following error:

  ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
  ata14.00: irq_stat 0x40000001
  ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 2 dma 16640 in
            Inquiry 12 01 00 00 ff 00res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
  ata14: hard resetting link

This has been minor annoyance (only error printed on dmesg) until commit
09e2b0b14690 ("scsi: rescan VPD attributes") added call to scsi_attach_vpd()
in scsi_rescan_device(). The commit causes the system to splat out
following errors continuously without ever reaching the UI:

  ata14.00: configured for UDMA/66
  ata14: EH complete
  ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
  ata14.00: irq_stat 0x40000001
  ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 6 dma 16640 in
            Inquiry 12 01 00 00 ff 00res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)
  ata14: hard resetting link
  ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
  ata14.00: configured for UDMA/66
  ata14: EH complete
  ata14.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
  ata14.00: irq_stat 0x40000001
  ata14.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 7 dma 16640 in
            Inquiry 12 01 00 00 ff 00res 00/00:00:00:00:00/00:00:00:00:00/00 Emask 0x3 (HSM violation)

Without in-depth understanding of SCSI layer and the Marvell controller, I
suspect this happens because when the link goes down (because of an error)
we schedule scsi_rescan_device() which again fails to read VPD data... ad
infinitum.

Since VPD data cannot be read from the device anyway we prevent the SCSI
layer from even trying by blacklisting the device. This gets away the error
and the system starts up normally.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Hannes Reinecke <hare@suse.de>
---
I'm not sure if this is most ideal fix. Comment on top of
scsi_static_device_list[] says that the list is going away eventually and
suggest me to use command line instead. I can do that but then everyone
else having similar device will need to do the same to get rid of the boot
failure.

 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 47b9d13..350cbed 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -205,6 +205,7 @@ static struct {
 	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
 	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
+	{"Marvell", "Console", "1.01", BLIST_SKIP_VPD_PAGES},
 	{"MATSHITA", "PD-1", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"MATSHITA", "DMC-LC5", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
 	{"MATSHITA", "DMC-LC40", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_36},
-- 
2.5.0

