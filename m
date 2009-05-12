From: akpm@linux-foundation.org
Subject: [patch 5/9] scsi: ncr53c8xx: div reaches -1
Date: Tue, 12 May 2009 13:49:46 -0700
Message-ID: <200905122109.n4CL92IY011428@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753738AbZELVNH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2009 17:13:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, matthew@wil.cx

From: Roel Kluin <roel.kluin@gmail.com>

With while(--div >= 0) { ... } div reaches -1.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ncr53c8xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ncr53c8xx.c~scsi-ncr53c8xx-div-reaches-1 drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c~scsi-ncr53c8xx-div-reaches-1
+++ a/drivers/scsi/ncr53c8xx.c
@@ -5444,7 +5444,7 @@ static void ncr_getsync(struct ncb *np, 
 	**	input speed faster than the period.
 	*/
 	kpc = per * clk;
-	while (--div >= 0)
+	while (--div > 0)
 		if (kpc >= (div_10M[div] << 2)) break;
 
 	/*
_
