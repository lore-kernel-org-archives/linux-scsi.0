From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.17-rc1
Date: Tue, 19 Aug 2014 13:54:32 -0500
Message-ID: <1408474472.14668.6.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53475 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753804AbaHSSyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2014 14:54:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

These are the two bug fixes I mentioned in the final merge window pull.
One is a reversed logic check in the device busy tests which can cause a
nasty hang and another crash seen in the new SCSI pool support if the
use count ever goes to zero.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Guenter Roeck (1):
      fix qemu boot hang problem

Juergen Gross (1):
      save command pool address of Scsi_Host

And the diffstat:

 drivers/scsi/scsi.c     | 12 ++++++++++--
 drivers/scsi/scsi_lib.c |  2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index df33060..d81f3cc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -377,6 +377,10 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
 		pool->slab_flags |= SLAB_CACHE_DMA;
 		pool->gfp_mask = __GFP_DMA;
 	}
+
+	if (hostt->cmd_size)
+		hostt->cmd_pool = pool;
+
 	return pool;
 }
 
@@ -421,8 +425,10 @@ out:
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
 
@@ -444,8 +450,10 @@ static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
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
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c44392..ce62e87 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_queue *q)
 	blk_requeue_request(q, req);
 	atomic_dec(&sdev->device_busy);
 out_delay:
-	if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
+	if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 }
 


