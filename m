From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v2 02/10] scsi: make __scsi_alloc_queue numa-aware
Date: Fri,  2 Nov 2012 17:45:55 -0400
Message-ID: <1351892763-21325-3-git-send-email-jmoyer@redhat.com>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

Pass the numa node id set in the Scsi_Host on to blk_init_queue_node
in order to keep all allocations local to the numa node the device is
closest to.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index da36a3a..8662a09 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1664,7 +1664,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	struct request_queue *q;
 	struct device *dev = shost->dma_dev;
 
-	q = blk_init_queue(request_fn, NULL);
+	q = blk_init_queue_node(request_fn, NULL, shost->numa_node);
 	if (!q)
 		return NULL;
 
-- 
1.7.1
