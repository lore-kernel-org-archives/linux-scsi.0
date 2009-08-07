From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] ipr: Read buffer overflow
Date: Sat, 08 Aug 2009 00:05:32 +0200
Message-ID: <4A7CA52C.9030407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57381 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbZHGWBz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 18:01:55 -0400
Received: by ewy10 with SMTP id 10so1846629ewy.37
        for <linux-scsi@vger.kernel.org>; Fri, 07 Aug 2009 15:01:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

If `sglist->num_dma_sg' is zero we write ioadl[-1]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is it possible for sglist->num_dma_sg to be 0?

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5f04550..736ad07 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3004,8 +3004,9 @@ static void ipr_build_ucode_ioadl(struct ipr_cmnd *ipr_cmd,
 			cpu_to_be32(sg_dma_address(&scatterlist[i]));
 	}
 
-	ioadl[i-1].flags_and_data_len |=
-		cpu_to_be32(IPR_IOADL_FLAGS_LAST);
+	if (i != 0)
+		ioadl[i-1].flags_and_data_len |=
+			cpu_to_be32(IPR_IOADL_FLAGS_LAST);
 }
 
 /**
