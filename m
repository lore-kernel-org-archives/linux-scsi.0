From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: BusLogic: fix incorrect spelling of adatper_reset_req
Date: Tue, 21 Feb 2017 16:27:11 +0000
Message-ID: <20170221162711.24694-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid@gonehiking.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

trivial fix to spelling mistake, adatper_reset_req should
be adapter_reset_req.  Also break up very long seq_printf statement
into multiple lines.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/BusLogic.c | 14 +++++++++++---
 drivers/scsi/BusLogic.h |  2 +-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index c7be7bb..35380a5 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3009,7 +3009,7 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt)
 
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
-	blogic_inc_count(&stats->adatper_reset_req);
+	blogic_inc_count(&stats->adapter_reset_req);
 
 	rc = blogic_resetadapter(adapter, false);
 	spin_unlock_irq(SCpnt->device->host->host_lock);
@@ -3560,8 +3560,16 @@ Target	Requested Completed  Requested Completed  Requested Completed\n\
 		struct blogic_tgt_flags *tgt_flags = &adapter->tgt_flags[tgt];
 		if (!tgt_flags->tgt_exists)
 			continue;
-		seq_printf(m, "\
-  %2d	 %5d %5d %5d    %5d %5d %5d	   %5d %5d %5d\n", tgt, tgt_stats[tgt].aborts_request, tgt_stats[tgt].aborts_tried, tgt_stats[tgt].aborts_done, tgt_stats[tgt].bdr_request, tgt_stats[tgt].bdr_tried, tgt_stats[tgt].bdr_done, tgt_stats[tgt].adatper_reset_req, tgt_stats[tgt].adapter_reset_attempt, tgt_stats[tgt].adapter_reset_done);
+		seq_printf(m, "  %2d	 %5d %5d %5d    %5d %5d %5d	   %5d %5d %5d\n",
+			   tgt, tgt_stats[tgt].aborts_request,
+			   tgt_stats[tgt].aborts_tried,
+			   tgt_stats[tgt].aborts_done,
+			   tgt_stats[tgt].bdr_request,
+			   tgt_stats[tgt].bdr_tried,
+			   tgt_stats[tgt].bdr_done,
+			   tgt_stats[tgt].adapter_reset_req,
+			   tgt_stats[tgt].adapter_reset_attempt,
+			   tgt_stats[tgt].adapter_reset_done);
 	}
 	seq_printf(m, "\nExternal Host Adapter Resets: %d\n", adapter->ext_resets);
 	seq_printf(m, "Host Adapter Internal Errors: %d\n", adapter->adapter_intern_errors);
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index b53ec2f..8d47e2c 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -935,7 +935,7 @@ struct blogic_tgt_stats {
 	unsigned short bdr_request;
 	unsigned short bdr_tried;
 	unsigned short bdr_done;
-	unsigned short adatper_reset_req;
+	unsigned short adapter_reset_req;
 	unsigned short adapter_reset_attempt;
 	unsigned short adapter_reset_done;
 };
-- 
2.10.2
