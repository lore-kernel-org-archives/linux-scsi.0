From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] tgt: use KMEM_CACHE macro
Date: Thu, 10 Apr 2008 23:48:14 +0900
Message-ID: <1207838894-24527-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:46471 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbYDJPIS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2008 11:08:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>

This uses new KMEM_CACHE() macro instead of kmem_cache_create directly
to simplify slab cache creation.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_tgt_lib.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index a0f308b..ee8496a 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -621,9 +621,7 @@ static int __init scsi_tgt_init(void)
 {
 	int err;
 
-	scsi_tgt_cmd_cache = kmem_cache_create("scsi_tgt_cmd",
-					       sizeof(struct scsi_tgt_cmd),
-					       0, 0, NULL);
+	scsi_tgt_cmd_cache =  KMEM_CACHE(scsi_tgt_cmd, 0);
 	if (!scsi_tgt_cmd_cache)
 		return -ENOMEM;
 
-- 
1.5.4.2

