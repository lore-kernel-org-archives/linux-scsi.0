From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 21/27] blk_end_request: changing ide-scsi (take 2)
Date: Tue, 11 Sep 2007 15:03:19 -0400 (EDT)
Message-ID: <20070911.150319.91214042.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts ide-scsi to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/ide-scsi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -rupN 20-scsi-mid-caller-change/drivers/scsi/ide-scsi.c 21-ide-scsi-caller-change/drivers/scsi/ide-scsi.c
--- 20-scsi-mid-caller-change/drivers/scsi/ide-scsi.c	2007-09-10 17:32:15.000000000 -0400
+++ 21-ide-scsi-caller-change/drivers/scsi/ide-scsi.c	2007-09-10 18:13:51.000000000 -0400
@@ -1042,8 +1042,8 @@ static int idescsi_eh_reset (struct scsi
 	}
 
 	/* kill current request */
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, 0);
+	if (__blk_end_request(req, 0, 0))
+		BUG();
 	if (blk_sense_request(req))
 		kfree(scsi->pc->buffer);
 	kfree(scsi->pc);
@@ -1052,8 +1052,8 @@ static int idescsi_eh_reset (struct scsi
 
 	/* now nuke the drive queue */
 	while ((req = elv_next_request(drive->queue))) {
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, 0);
+		if (__blk_end_request(req, 0, 0))
+			BUG();
 	}
 
 	HWGROUP(drive)->rq = NULL;
