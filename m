From: Pete Wyckoff <pw@osc.edu>
Subject: [ofa-general] [PATCH 2/2] ib fmr pool: flush used clean entries
Date: Tue, 26 Feb 2008 13:27:53 -0500
Message-ID: <20080226182753.GF7033@osc.edu>
References: <20080225225330.GA3316@osc.edu> <ada1w70zlkf.fsf@cisco.com>
	<20080226182655.GD7033@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
Content-Disposition: inline
In-Reply-To: <20080226182655.GD7033@osc.edu>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, Olaf Kirch <olaf.kirch@oracle.com>, general@lists.openfabrics.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Commit a3cd7d9070be417a21905c997ee32d756d999b38 (IB/fmr_pool:
ib_fmr_pool_flush() should flush all dirty FMRs) caused a
regression for iSER and was reverted in
e5507736c6449b3253347eed6f8ea77a28cf688e.

This change attempts to redo the original patch so that all used
FMR entries are flushed when ib_flush_fmr_pool() is called,
and other FMR users are not affected.  Simply move used entries
from the clean list onto the dirty list before letting the
cleanup thread do its job.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/infiniband/core/fmr_pool.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index 4044fdf..06d502c 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -398,8 +398,23 @@ EXPORT_SYMBOL(ib_destroy_fmr_pool);
  */
 int ib_flush_fmr_pool(struct ib_fmr_pool *pool)
 {
-	int serial = atomic_inc_return(&pool->req_ser);
+	int serial;
+	struct ib_pool_fmr *fmr, *next;
+
+	/*
+	 * The free_list holds FMRs that may have been used
+	 * but have not been remapped enough times to be dirty.
+	 * Put them on the dirty list now so that the cleanup
+	 * thread will reap them too.
+	 */
+	spin_lock_irq(&pool->pool_lock);
+	list_for_each_entry_safe(fmr, next, &pool->free_list, list) {
+		if (fmr->remap_count > 0)
+			list_move(&fmr->list, &pool->dirty_list);
+	}
+	spin_unlock_irq(&pool->pool_lock);
 
+	serial = atomic_inc_return(&pool->req_ser);
 	wake_up_process(pool->thread);
 
 	if (wait_event_interruptible(pool->force_wait,
-- 
1.5.4.1
