From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 7/8] dm core: reject I/O violating new queue
	limits
Date: Fri, 03 Oct 2008 11:19:31 -0400 (EDT)
Message-ID: <20081003.111931.39152902.k-ueda@ct.jp.nec.com>
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

This patch detects requests violating the queue limitations
and rejects them.

The same limitation checks are done when requests are submitted
to the queue by blk_insert_cloned_request().
However, such violation can happen if a table is swapped and
the queue limitations are shrunk while some requests are
in the queue.

Since struct request is a reliable one in the block layer and
device drivers, dispatching such requests is pretty dangerous.
(e.g. it may cause kernel panic easily.)
So avoid to dispatch such problematic requests in request-based dm.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+)

Index: 2.6.27-rc8/drivers/md/dm.c
===================================================================
--- 2.6.27-rc8.orig/drivers/md/dm.c
+++ 2.6.27-rc8/drivers/md/dm.c
@@ -1472,6 +1472,30 @@ static void map_request(struct dm_target
 
 	tio->ti = ti;
 	atomic_inc(&md->pending);
+
+	/*
+	 * Although submitted requests to the md->queue are checked against
+	 * the table/queue limitations at the submission time, the limitations
+	 * may be changed by a table swapping while those already checked
+	 * requests are in the md->queue.
+	 * If the limitations have been shrunk in such situations, we may be
+	 * dispatching requests violating the current limitations here.
+	 * Since struct request is a reliable one in the block-layer
+	 * and device drivers, dispatching such requests is dangerous.
+	 * (e.g. it may cause kernel panic easily.)
+	 * Avoid to dispatch such problematic requests in request-based dm.
+	 *
+	 * Since dm_kill_request() decrements the md->pending, this have to
+	 * be done after incrementing the md->pending.
+	 */
+	r = blk_rq_check_limits(rq->q, rq);
+	if (unlikely(r)) {
+		DMWARN("violating the queue limitation. the limitation may be"
+		       " shrunk while there are some requests in the queue.");
+		dm_kill_request(clone, r);
+		return;
+	}
+
 	r = ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
 	case DM_MAPIO_SUBMITTED:
