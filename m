From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 3/7] 3w-9xxx: fix transfer length 0 for 6-byte r/w commands
Date: Sat, 16 May 2015 16:17:49 +0900
Message-ID: <1431760673-7180-4-git-send-email-akinobu.mita@gmail.com>
References: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34164 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbbEPHSd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 03:18:33 -0400
Received: by pabru16 with SMTP id ru16so53520747pab.1
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 00:18:33 -0700 (PDT)
In-Reply-To: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Adam Radford <linuxraid@lsi.com>

For 6-byte r/w commands, transfer length 0 means 256 blocks of data,
not 0 block.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Adam Radford <linuxraid@lsi.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/3w-9xxx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index add419d..71ddb7f 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1870,8 +1870,11 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 	}
 
 	if (srb) {
-		if (srb->cmnd[0] == READ_6 || srb->cmnd[0] == WRITE_6)
+		if (srb->cmnd[0] == READ_6 || srb->cmnd[0] == WRITE_6) {
 			num_sectors = (u32)srb->cmnd[4];
+			if (num_sectors == 0)
+				num_sectors = 256;
+		}
 
 		if (srb->cmnd[0] == READ_10 || srb->cmnd[0] == WRITE_10)
 			num_sectors = (u32)srb->cmnd[8] | ((u32)srb->cmnd[7] << 8);
-- 
1.9.1

