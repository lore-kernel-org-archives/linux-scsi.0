From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist
Date: Tue, 31 May 2016 09:42:29 -0400
Message-ID: <1464702149-26573-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbcEaNmc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2016 09:42:32 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 51A8962664
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2016 13:42:31 +0000 (UTC)
Received: from emilne.csb (dhcp-25-104.bos.redhat.com [10.18.25.104])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u4VDgUQn032488
	for <linux-scsi@vger.kernel.org>; Tue, 31 May 2016 09:42:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Linux fails to boot as a guest with a QEMU CD-ROM:

[    4.439488] ata2.00: ATAPI: QEMU CD-ROM, 0.8.2, max UDMA/100
[    4.443649] ata2.00: configured for MWDMA2
[    4.450267] scsi 1:0:0:0: CD-ROM            QEMU     QEMU CD-ROM      0.8. PQ: 0 ANSI: 5
[    4.464317] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[    4.464319] ata2.00: BMDMA stat 0x5
[    4.464339] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0 dma 16640 in
[    4.464339]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
[    4.464341] ata2.00: status: { DRDY DRQ }
[    4.465864] ata2: soft resetting link
[    4.625971] ata2.00: configured for MWDMA2
[    4.628290] ata2: EH complete
[    4.646670] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[    4.646671] ata2.00: BMDMA stat 0x5
[    4.646683] ata2.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 0 dma 16640 in
[    4.646683]          Inquiry 12 01 00 00 ff 00res 48/20:02:00:24:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
[    4.646685] ata2.00: status: { DRDY DRQ }
[    4.648193] ata2: soft resetting link

...

Fix this by suppressing VPD inquiry for this device.

Reported-by: Jan Stancek <jstancek@redhat.com>
Tested-by: Jan Stancek <jstancek@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_devinfo.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index bbfbfd9..09bbd3f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -228,6 +228,7 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "", NULL, BLIST_SPARSELUN},
+	{"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
 	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
 	{"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},
 	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
-- 
1.7.1

