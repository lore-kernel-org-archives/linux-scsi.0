From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] fix scsi_setup_command_freelist failure path race
Date: Tue, 08 Jan 2008 07:59:05 +0900
Message-ID: <20080108075905V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:41632 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbYAGW7L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 17:59:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Looks like that host_cmd_pool_mutex are necessary here.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ebc0193..54ff611 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -319,17 +319,16 @@ int scsi_setup_command_freelist(struct Scsi_Host *shost)
 			GFP_KERNEL | shost->cmd_pool->gfp_mask);
 	if (!cmd)
 		goto fail2;
-	list_add(&cmd->list, &shost->free_list);		
+	list_add(&cmd->list, &shost->free_list);
 	return 0;
 
  fail2:
+	mutex_lock(&host_cmd_pool_mutex);
 	if (!--pool->users)
 		kmem_cache_destroy(pool->slab);
-	return -ENOMEM;
  fail:
 	mutex_unlock(&host_cmd_pool_mutex);
 	return -ENOMEM;
-
 }
 
 /**
-- 
1.5.3.4

