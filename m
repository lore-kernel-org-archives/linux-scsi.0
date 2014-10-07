From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/26] scsi: correct return values for .eh_abort_handler implementations
Date: Tue,  7 Oct 2014 11:03:25 +0200
Message-ID: <1412672605-42868-27-git-send-email-hare@suse.de>
References: <1412672605-42868-1-git-send-email-hare@suse.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1412672605-42868-1-git-send-email-hare@suse.de>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The .eh_abort_handler needs to return SUCCESS, FAILED, or
FAST_IO_FAIL. So fixup all callers to adhere to this requirement.

Cc: Robert Elliott <elliott@hp.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/NCR5380.c            | 2 +-
 drivers/scsi/aha1740.c            | 2 +-
 drivers/scsi/esas2r/esas2r_main.c | 2 +-
 drivers/scsi/megaraid.c           | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 50873bb..e2c9e73 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2703,7 +2703,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
  * aborted flag and get back into our main loop.
  */
 
-		return 0;
+		return SUCCESS;
 	}
 #endif
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 5f31017..31ace4b 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -531,7 +531,7 @@ static int aha1740_eh_abort_handler (Scsi_Cmnd *dummy)
  * quiet as possible...
  */
 
-	return 0;
+	return SUCCESS;
 }
 
 static struct scsi_host_template aha1740_template = {
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 6504a19..45aa684 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1057,7 +1057,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 
 		cmd->scsi_done(cmd);
 
-		return 0;
+		return SUCCESS;
 	}
 
 	spin_lock_irqsave(&a->queue_lock, flags);
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index ac5d94c..2485255 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1945,7 +1945,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 	     cmd->device->id, (u32)cmd->device->lun);
 
 	if(list_empty(&adapter->pending_list))
-		return FALSE;
+		return FAILED;
 
 	list_for_each_safe(pos, next, &adapter->pending_list) {
 
@@ -1968,7 +1968,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					scb->idx);
 
-				return FALSE;
+				return FAILED;
 			}
 			else {
 
@@ -1993,12 +1993,12 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 				list_add_tail(SCSI_LIST(cmd),
 						&adapter->completed_list);
 
-				return TRUE;
+				return SUCCESS;
 			}
 		}
 	}
 
-	return FALSE;
+	return FAILED;
 }
 
 static inline int
-- 
1.8.5.2
