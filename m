From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill last users of the ScsiLun typedef
Date: Sat, 20 Sep 2003 15:25:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030920132513.GB23038@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:54401 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261868AbTITNZR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2003 09:25:17 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

everyone else uses struct scsi_lun already.


--- 1.44/drivers/scsi/scsi_debug.c	Fri Aug 15 19:07:53 2003
+++ edited/drivers/scsi/scsi_debug.c	Sat Sep 20 11:07:21 2003
@@ -861,7 +861,7 @@
 	unsigned int alloc_len; 
 	int lun_cnt, i, upper;
 	int select_report = (int)cmd[2];
-	ScsiLun *one_lun;
+	struct scsi_lun *one_lun;
 
 	alloc_len = cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << 24);
 	if ((alloc_len < 16) || (select_report > 2)) {
@@ -873,11 +873,11 @@
 			      (lun 0 to lun 16383) */
 		memset(buff, 0, bufflen);
 		lun_cnt = scsi_debug_max_luns;
-		buff[2] = ((sizeof(ScsiLun) * lun_cnt) >> 8) & 0xff;
-		buff[3] = (sizeof(ScsiLun) * lun_cnt) & 0xff;
-		lun_cnt = min((int)((bufflen - 8) / sizeof(ScsiLun)), 
+		buff[2] = ((sizeof(struct scsi_lun) * lun_cnt) >> 8) & 0xff;
+		buff[3] = (sizeof(struct scsi_lun) * lun_cnt) & 0xff;
+		lun_cnt = min((int)((bufflen - 8) / sizeof(struct scsi_lun)), 
 			      lun_cnt);
-		one_lun = (ScsiLun*) &buff[8];
+		one_lun = (struct scsi_lun *) &buff[8];
 		for (i = 0; i < lun_cnt; i++) {
 			upper = (i >> 8) & 0x3f;
 			if (upper)
