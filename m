From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH] SCSI: remove one useless stack variable
Date: Mon, 10 Oct 2016 23:25:33 +0800
Message-ID: <1476113133-24092-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35954 "EHLO
        mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752553AbcJJPZj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Oct 2016 11:25:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>

The local variable of 'devname' in scsi_report_lun_scan()
isn't used any more, so remove it.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/scsi/scsi_scan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index bb9b58e21d95..6f7128f49c30 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1307,7 +1307,6 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				enum scsi_scan_mode rescan)
 {
-	char devname[64];
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
 	u64 lun;
@@ -1349,9 +1348,6 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 		}
 	}
 
-	sprintf(devname, "host %d channel %d id %d",
-		shost->host_no, sdev->channel, sdev->id);
-
 	/*
 	 * Allocate enough to hold the header (the same size as one scsi_lun)
 	 * plus the number of luns we are requesting.  511 was the default
-- 
2.7.4

