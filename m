From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v3,repost 02/10] scsi: make __scsi_alloc_queue numa-aware
Date: Tue, 27 Nov 2012 11:46:30 -0500
Message-ID: <1354034799-8460-3-git-send-email-jmoyer@redhat.com>
References: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Pass the numa node id set in the Scsi_Host on to blk_init_queue_node
in order to keep all allocations local to the numa node the device is
closest to.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/scsi_lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index da36a3a..ebad5e8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1664,7 +1664,8 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	struct request_queue *q;
 	struct device *dev = shost->dma_dev;
 
-	q = blk_init_queue(request_fn, NULL);
+	q = blk_init_queue_node(request_fn, NULL,
+				scsi_host_get_numa_node(shost));
 	if (!q)
 		return NULL;
 
-- 
1.7.1
