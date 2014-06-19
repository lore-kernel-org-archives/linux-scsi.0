From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] bnx2fc: do not scan uninitialized lists in case of error.
Date: Thu, 19 Jun 2014 15:05:00 +0200
Message-ID: <1403183100-15011-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbaFSNFJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2014 09:05:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eddie.wai@broadcom.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@HansenPartnership.com

In case of of error, the bnx2fc_cmd_mgr_alloc() function will call
the bnx2fc_cmd_mgr_free() to perform the cleanup.
The problem is that in one case the latter may try to scan
some not-yet initialized lists, resulting in a kernel panic.

This patch prevents this from happening by freeing the lists
before calling bnx2fc_cmd_mgr_free().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 32a5e0a..7bc47fc 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -282,6 +282,8 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba)
 				       arr_sz, GFP_KERNEL);
 	if (!cmgr->free_list_lock) {
 		printk(KERN_ERR PFX "failed to alloc free_list_lock\n");
+		kfree(cmgr->free_list);
+		cmgr->free_list = NULL;
 		goto mem_err;
 	}
 
-- 
Maurizio Lombardi

