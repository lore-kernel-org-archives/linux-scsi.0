From: jgross@suse.com
Subject: [PATCH V4 4/4] Save command pool address of Scsi_Host
Date: Fri,  8 Aug 2014 09:44:00 +0200
Message-ID: <1407483840-31436-5-git-send-email-jgross@suse.com>
References: <1407483840-31436-1-git-send-email-jgross@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47559 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723AbaHHHoQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2014 03:44:16 -0400
In-Reply-To: <1407483840-31436-1-git-send-email-jgross@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com, JBeulich@suse.com
Cc: Juergen Gross <jgross@suse.com>

From: Juergen Gross <jgross@suse.com>

If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.

This will result in an access error when the host is removed.

Avoid the problem by saving the address of a new allocated command pool where
it is expected.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/scsi/scsi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..b0cef5b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -380,6 +380,10 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
 		pool->slab_flags |= SLAB_CACHE_DMA;
 		pool->gfp_mask = __GFP_DMA;
 	}
+
+	if (hostt->cmd_size)
+		hostt->cmd_pool = pool;
+
 	return pool;
 }
 
@@ -424,8 +428,10 @@ out:
 out_free_slab:
 	kmem_cache_destroy(pool->cmd_slab);
 out_free_pool:
-	if (hostt->cmd_size)
+	if (hostt->cmd_size) {
 		scsi_free_host_cmd_pool(pool);
+		hostt->cmd_pool = NULL;
+	}
 	goto out;
 }
 
@@ -447,8 +453,10 @@ static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
 	if (!--pool->users) {
 		kmem_cache_destroy(pool->cmd_slab);
 		kmem_cache_destroy(pool->sense_slab);
-		if (hostt->cmd_size)
+		if (hostt->cmd_size) {
 			scsi_free_host_cmd_pool(pool);
+			hostt->cmd_pool = NULL;
+		}
 	}
 	mutex_unlock(&host_cmd_pool_mutex);
 }
-- 
1.8.4.5

