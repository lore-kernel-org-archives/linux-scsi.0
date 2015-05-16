From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 6/7] megaraid_mbox: fix transfer length 0 for 6-byte r/w commands
Date: Sat, 16 May 2015 16:17:52 +0900
Message-ID: <1431760673-7180-7-git-send-email-akinobu.mita@gmail.com>
References: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:36558 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859AbbEPHSo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 03:18:44 -0400
Received: by pdfh10 with SMTP id h10so52169239pdf.3
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 00:18:43 -0700 (PDT)
In-Reply-To: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com

For 6-byte r/w commands, transfer length 0 means 256 blocks of data,
not 0 block.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: Uday Lingala <uday.lingala@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_mbox.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index f0987f2..bed00d4 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1691,6 +1691,8 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			 */
 			if (scp->cmd_len == 6) {
 				mbox->numsectors = (uint32_t)scp->cmnd[4];
+				if (mbox->numsectors == 0)
+					mbox->numsectors = 256;
 				mbox->lba =
 					((uint32_t)scp->cmnd[1] << 16)	|
 					((uint32_t)scp->cmnd[2] << 8)	|
-- 
1.9.1

