From: Sage Weil <sage@newdream.net>
Subject: [PATCH] ibmvscsi: avoid unnecessary use of kzalloc_pool
Date: Mon,  3 Aug 2009 13:54:47 -0700
Message-ID: <1249332888-13440-2-git-send-email-sage@newdream.net>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:34203 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZHCUzF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 16:55:05 -0400
In-Reply-To: <1249332888-13440-1-git-send-email-sage@newdream.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

The allocated struct is manually zeroed after allocation, so avoid using
the (broken) kzalloc mempool (which does not re-zero previously used items
when they are returned to the pool).

CC: linux-scsi@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Sage Weil <sage@newdream.net>
---
 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 166d964..bb2c696 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4217,7 +4217,7 @@ static int ibmvfc_alloc_mem(struct ibmvfc_host *vhost)
 	if (!vhost->trace)
 		goto free_disc_buffer;
 
-	vhost->tgt_pool = mempool_create_kzalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
+	vhost->tgt_pool = mempool_create_kmalloc_pool(IBMVFC_TGT_MEMPOOL_SZ,
 						      sizeof(struct ibmvfc_target));
 
 	if (!vhost->tgt_pool) {
-- 
1.5.6.5

