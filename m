From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 05/13] dm: remove dead codes
Date: Fri, 15 Feb 2008 17:30:46 -0500 (EST)
Message-ID: <20080215.173046.31640500.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761879AbYBOWbV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:31:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch removes dead codes for the noflush suspend.
No functional change.

This patch is just a clean up of the codes and not functionally
related to request-based dm.  But included here due to literal
dependency.

The dm_queue_flush(md, DM_WQ_FLUSH_ALL, NULL) in dm_suspend()
is never invoked because:
  - The 'goto flush_and_out' is same as 'goto out', because
    the 'goto flush_and_out' is called only when '!noflush'
  - If the 'r && noflush' is true, the interrupt check code above
    is invoked and 'goto out'

The DM_WQ_FLUSH_ALL type is used only in dm_suspend().
So no need any more.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |   14 +-------------
 1 files changed, 1 insertion(+), 13 deletions(-)

Index: 2.6.25-rc1/drivers/md/dm.c
===================================================================
--- 2.6.25-rc1.orig/drivers/md/dm.c
+++ 2.6.25-rc1/drivers/md/dm.c
@@ -76,7 +76,6 @@ union map_info *dm_get_mapinfo(struct bi
  */
 struct dm_wq_req {
 	enum {
-		DM_WQ_FLUSH_ALL,
 		DM_WQ_FLUSH_DEFERRED,
 	} type;
 	struct work_struct work;
@@ -1340,9 +1339,6 @@ static void dm_wq_work(struct work_struc
 
 	down_write(&md->io_lock);
 	switch (req->type) {
-	case DM_WQ_FLUSH_ALL:
-		__merge_pushback_list(md);
-		/* pass through */
 	case DM_WQ_FLUSH_DEFERRED:
 		__flush_deferred_io(md);
 		break;
@@ -1472,7 +1468,7 @@ int dm_suspend(struct mapped_device *md,
 		if (!md->suspended_bdev) {
 			DMWARN("bdget failed in dm_suspend");
 			r = -ENOMEM;
-			goto flush_and_out;
+			goto out;
 		}
 
 		/*
@@ -1523,14 +1519,6 @@ int dm_suspend(struct mapped_device *md,
 
 	set_bit(DMF_SUSPENDED, &md->flags);
 
-flush_and_out:
-	if (r && noflush)
-		/*
-		 * Because there may be already I/Os in the pushback list,
-		 * flush them before return.
-		 */
-		dm_queue_flush(md, DM_WQ_FLUSH_ALL, NULL);
-
 out:
 	if (r && md->suspended_bdev) {
 		bdput(md->suspended_bdev);
