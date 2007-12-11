From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 19/30] blk_end_request: changing ide-scsi (take 4)
Date: Tue, 11 Dec 2007 17:49:29 -0500 (EST)
Message-ID: <20071211.174929.129777486.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com
Cc: bzolnier@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts ide-scsi to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/ide-scsi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Index: 2.6.24-rc4/drivers/scsi/ide-scsi.c
===================================================================
--- 2.6.24-rc4.orig/drivers/scsi/ide-scsi.c
+++ 2.6.24-rc4/drivers/scsi/ide-scsi.c
@@ -921,8 +921,8 @@ static int idescsi_eh_reset (struct scsi
 	}
 
 	/* kill current request */
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, 0);
+	if (__blk_end_request(req, -EIO, 0))
+		BUG();
 	if (blk_sense_request(req))
 		kfree(scsi->pc->buffer);
 	kfree(scsi->pc);
@@ -931,8 +931,8 @@ static int idescsi_eh_reset (struct scsi
 
 	/* now nuke the drive queue */
 	while ((req = elv_next_request(drive->queue))) {
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, 0);
+		if (__blk_end_request(req, -EIO, 0))
+			BUG();
 	}
 
 	HWGROUP(drive)->rq = NULL;
