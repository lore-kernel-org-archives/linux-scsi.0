From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 5/7] staging: rts5208: fix transfer length 0 for 6-byte r/w commands
Date: Sat, 16 May 2015 16:17:51 +0900
Message-ID: <1431760673-7180-6-git-send-email-akinobu.mita@gmail.com>
References: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34456 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859AbbEPHSk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 03:18:40 -0400
Received: by pabru16 with SMTP id ru16so53525190pab.1
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 00:18:39 -0700 (PDT)
In-Reply-To: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Micky Ching <micky_ching@realsil.com.cn>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

For 6-byte r/w commands, transfer length 0 means 256 blocks of data,
not 0 block.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Micky Ching <micky_ching@realsil.com.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org
---
 drivers/staging/rts5208/rtsx_scsi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts5208/rtsx_scsi.c b/drivers/staging/rts5208/rtsx_scsi.c
index 8a5d6a8..60871f3 100644
--- a/drivers/staging/rts5208/rtsx_scsi.c
+++ b/drivers/staging/rts5208/rtsx_scsi.c
@@ -915,6 +915,8 @@ static int read_write(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 		start_sec = ((u32)(srb->cmnd[1] & 0x1F) << 16) |
 			((u32)srb->cmnd[2] << 8) | ((u32)srb->cmnd[3]);
 		sec_cnt = srb->cmnd[4];
+		if (sec_cnt == 0)
+			sec_cnt = 256;
 	} else if ((srb->cmnd[0] == VENDOR_CMND) &&
 		(srb->cmnd[1] == SCSI_APP_CMD) &&
 		((srb->cmnd[2] == PP_READ10) || (srb->cmnd[2] == PP_WRITE10))) {
@@ -2904,9 +2906,11 @@ void led_shine(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 
 	if ((srb->cmnd[0] == READ_10) || (srb->cmnd[0] == WRITE_10))
 		sec_cnt = ((u16)(srb->cmnd[7]) << 8) | srb->cmnd[8];
-	else if ((srb->cmnd[0] == READ_6) || (srb->cmnd[0] == WRITE_6))
+	else if ((srb->cmnd[0] == READ_6) || (srb->cmnd[0] == WRITE_6)) {
 		sec_cnt = srb->cmnd[4];
-	else
+		if (sec_cnt == 0)
+			sec_cnt = 256;
+	} else
 		return;
 
 	if (chip->rw_cap[lun] >= GPIO_TOGGLE_THRESHOLD) {
-- 
1.9.1

