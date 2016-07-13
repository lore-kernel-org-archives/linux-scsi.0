From: tom.ty89@gmail.com
Subject: [RFC 2/3] ata: make lba_{28,48}_ok() use ATA_MAX_SECTORS{,_LBA48}
Date: Wed, 13 Jul 2016 12:47:07 +0800
Message-ID: <91a6bb6f4c04eb617a49d9a51f261b661c179de0.1468384890.git.tom.ty89@gmail.com>
References: <1c10437e3cd9be8556e77462b40ad53be542dfba.1468384890.git.tom.ty89@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36320 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbcGMEsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2016 00:48:09 -0400
In-Reply-To: <1c10437e3cd9be8556e77462b40ad53be542dfba.1468384890.git.tom.ty89@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/include/linux/ata.h b/include/linux/ata.h
index 24f886c..d4bb802 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -1095,13 +1095,13 @@ static inline bool ata_ok(u8 status)
 static inline bool lba_28_ok(u64 block, u32 n_block)
 {
 	/* check the ending block number: must be LESS THAN 0x0fffffff */
-	return ((block + n_block) < ((1 << 28) - 1)) && (n_block <= 256);
+	return ((block + n_block) < ((1 << 28) - 1)) && (n_block <= ATA_MAX_SECTORS);
 }
 
 static inline bool lba_48_ok(u64 block, u32 n_block)
 {
 	/* check the ending block number */
-	return ((block + n_block - 1) < ((u64)1 << 48)) && (n_block <= 65536);
+	return ((block + n_block - 1) < ((u64)1 << 48)) && (n_block <= ATA_MAX_SECTORS_LBA48);
 }
 
 #define sata_pmp_gscr_vendor(gscr)	((gscr)[SATA_PMP_GSCR_PROD_ID] & 0xffff)
-- 
2.9.0

