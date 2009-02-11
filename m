From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] SCSI: ncr53c8xx: div reaches -1
Date: Wed, 11 Feb 2009 13:22:01 +0100
Message-ID: <4992C2E9.8040307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:50825 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbZBKMWB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 07:22:01 -0500
Received: by fxm13 with SMTP id 13so425507fxm.13
        for <linux-scsi@vger.kernel.org>; Wed, 11 Feb 2009 04:21:59 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

With while(--div >= 0) { ... } div reaches -1.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 3b7240e..e3c482a 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -5444,7 +5444,7 @@ static void ncr_getsync(struct ncb *np, u_char sfac, u_char *fakp, u_char *scntl
 	**	input speed faster than the period.
 	*/
 	kpc = per * clk;
-	while (--div >= 0)
+	while (--div > 0)
 		if (kpc >= (div_10M[div] << 2)) break;
 
 	/*
