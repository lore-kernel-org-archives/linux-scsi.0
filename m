From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/7] hpsa: fix transfer length 0 for 6-byte r/w commands
Date: Sat, 16 May 2015 16:17:47 +0900
Message-ID: <1431760673-7180-2-git-send-email-akinobu.mita@gmail.com>
References: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33361 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbEPHS0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 May 2015 03:18:26 -0400
Received: by padbw4 with SMTP id bw4so53488273pad.0
        for <linux-scsi@vger.kernel.org>; Sat, 16 May 2015 00:18:26 -0700 (PDT)
In-Reply-To: <1431760673-7180-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Don Brace <don.brace@pmcs.com>, iss_storagedev@hp.com, storagedev@pmcs.com

For 6-byte r/w commands, transfer length 0 means 256 blocks of data,
not 0 block.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Don Brace <don.brace@pmcs.com>
Cc: iss_storagedev@hp.com
Cc: storagedev@pmcs.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/hpsa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8895bc9..f1d667c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3326,6 +3326,8 @@ static int fixup_ioaccel_cdb(u8 *cdb, int *cdb_len)
 		if (*cdb_len == 6) {
 			block = (((u32) cdb[2]) << 8) | cdb[3];
 			block_cnt = cdb[4];
+			if (block_cnt == 0)
+				block_cnt = 256;
 		} else {
 			BUG_ON(*cdb_len != 12);
 			block = (((u32) cdb[2]) << 24) |
-- 
1.9.1

