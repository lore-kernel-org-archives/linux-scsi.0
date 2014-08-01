From: jgross@suse.com
Subject: [V2 PATCH] Save command pool address of Scsi_Host
Date: Fri,  1 Aug 2014 14:46:30 +0200
Message-ID: <1406897190-28427-1-git-send-email-jgross@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org
Cc: Juergen Gross <jgross@suse.com>
List-Id: linux-scsi@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.

This will result in an access error when the host is removed.

Avoid the problem by saving the address of a new allocated command pool where
it is expected.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/scsi/scsi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..e8e8428 100644
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
 
-- 
1.8.4.5
