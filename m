From: James Smart <james.smart@emulex.com>
Subject: [PATCH] scsi_transport_fc:  fix blocked bsg request when fc object
 deleted
Date: Tue, 31 Aug 2010 22:27:31 -0400
Message-ID: <8a40ef31-efb0-44c2-a92a-c2072a670748@exht1.ad.emulex.com>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:53786 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751972Ab0IAC2O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Aug 2010 22:28:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: carl.lajeunesse@emulex.com

When an rport is "blocked" and a bsg request is received, the bsg request gets
placed on the queue but the queue stalls. If the fc object is then deleted - the
bsg queue never restarts and keeps the reference on the object, and stops the
overall teardown.

This patch restarts the bsg queue on teardown and drains any pending requests,
allowing the teardown to succeed.

-- james s


 Signed-off-by: Carl Lajeunesse <carl.lajeunesse@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 scsi_transport_fc.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)


diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
--- a/drivers/scsi/scsi_transport_fc.c	2010-08-06 12:23:59.000000000 -0400
+++ b/drivers/scsi/scsi_transport_fc.c	2010-08-31 22:14:12.000000000 -0400
@@ -4044,11 +4044,54 @@ fc_bsg_rportadd(struct Scsi_Host *shost,
 /**
  * fc_bsg_remove - Deletes the bsg hooks on fchosts/rports
  * @q:	the request_queue that is to be torn down.
+ *
+ * Notes:
+ *   Before unregistering the queue empty any requests that are blocked
+ *
+ *
  */
 static void
 fc_bsg_remove(struct request_queue *q)
 {
+	struct request *req; /* block request */
+	int counts; /* totals for request_list count and starved */
+
 	if (q) {
+		/* Stop taking in new requests */
+		spin_lock_irq(q->queue_lock);
+		blk_stop_queue(q);
+
+		/* drain all requests in the queue */
+		while (1) {
+			/* need the lock to fetch a request
+			 * this may fetch the same reqeust as the previous pass
+			 */
+			req = blk_fetch_request(q);
+			/* save requests in use and starved */
+			counts = q->rq.count[0] + q->rq.count[1] +
+				q->rq.starved[0] + q->rq.starved[1];
+			spin_unlock_irq(q->queue_lock);
+			/* any requests still outstanding? */
+			if (counts == 0)
+				break;
+
+			/* This may be the same req as the previous iteration,
+			 * always send the blk_end_request_all after a prefetch.
+			 * It is not okay to not end the request because the
+			 * prefetch started the request.
+			 */
+			if (req) {
+				/* return -ENXIO to indicate that this queue is
+				 * going away
+				 */
+				req->errors = -ENXIO;
+				blk_end_request_all(req, -ENXIO);
+			}
+
+			msleep(200); /* allow bsg to possibly finish */
+			spin_lock_irq(q->queue_lock);
+		}
+
 		bsg_unregister_queue(q);
 		blk_cleanup_queue(q);
 	}


