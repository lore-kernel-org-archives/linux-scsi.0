From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 19/28] blk_end_request: changing scsi (take 3)
Date: Fri, 30 Nov 2007 18:32:26 -0500 (EST)
Message-ID: <20071130.183226.131913635.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts scsi mid-layer to use blk_end_request().

The comment above scsi_next_command() is not related to this change.
It had originally been there before scsi_next_command() was included
in scsi_finalize_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/scsi/scsi_lib.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/scsi/scsi_lib.c
+++ 2.6.24-rc3-mm2/drivers/scsi/scsi_lib.c
@@ -683,7 +683,7 @@ static struct scsi_cmnd *scsi_end_reques
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
-	if (end_that_request_chunk(req, uptodate, bytes)) {
+	if (blk_end_request(req, uptodate, bytes)) {
 		int leftover = (req->hard_nr_sectors << 9);
 
 		if (blk_pc_request(req))
@@ -691,7 +691,7 @@ static struct scsi_cmnd *scsi_end_reques
 
 		/* kill remainder if no retrys */
 		if (!uptodate && blk_noretry_request(req))
-			end_that_request_chunk(req, 0, leftover);
+			blk_end_request(req, 0, leftover);
 		else {
 			if (requeue) {
 				/*
@@ -706,7 +706,11 @@ static struct scsi_cmnd *scsi_end_reques
 		}
 	}
 
-	scsi_finalize_request(cmd, uptodate);
+	/*
+	 * This will goose the queue request function at the end, so we don't
+	 * need to worry about launching another command.
+	 */
+	scsi_next_command(cmd);
 	return NULL;
 }
 
