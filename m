From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 1/8] dm core: remove unused DM_WQ_FLUSH_ALL
Date: Fri, 03 Oct 2008 11:09:42 -0400 (EDT)
Message-ID: <20081003.110942.41628922.k-ueda@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, mbroz@redhat.com
List-Id: linux-scsi@vger.kernel.org

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

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   14 +-------------
 1 files changed, 1 insertion(+), 13 deletions(-)

Index: 2.6.27-rc8/drivers/md/dm.c
===================================================================
--- 2.6.27-rc8.orig/drivers/md/dm.c
+++ 2.6.27-rc8/drivers/md/dm.c
@@ -76,7 +76,6 @@ union map_info *dm_get_mapinfo(struct bi
  */
 struct dm_wq_req {
 	enum {
-		DM_WQ_FLUSH_ALL,
 		DM_WQ_FLUSH_DEFERRED,
 	} type;
 	struct work_struct work;
@@ -1388,9 +1387,6 @@ static void dm_wq_work(struct work_struc
 
 	down_write(&md->io_lock);
 	switch (req->type) {
-	case DM_WQ_FLUSH_ALL:
-		__merge_pushback_list(md);
-		/* pass through */
 	case DM_WQ_FLUSH_DEFERRED:
 		__flush_deferred_io(md);
 		break;
@@ -1520,7 +1516,7 @@ int dm_suspend(struct mapped_device *md,
 		if (!md->suspended_bdev) {
 			DMWARN("bdget failed in dm_suspend");
 			r = -ENOMEM;
-			goto flush_and_out;
+			goto out;
 		}
 
 		/*
@@ -1571,14 +1567,6 @@ int dm_suspend(struct mapped_device *md,
 
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
