From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] Fix mistaken uses of ->done
Date: Tue, 25 Sep 2007 12:42:01 -0400
Message-ID: <11907385241071-git-send-email-willy@linux.intel.com>
References: <1190738524460-git-send-email-willy@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:54549 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813AbXIYQmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 12:42:07 -0400
In-Reply-To: <1190738524460-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

From: Matthew Wilcox <matthew@wil.cx>

All these drivers meant to call ->scsi_done() but got confused.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/NCR5380.c       |    8 ++++----
 drivers/scsi/NCR53C9x.c      |    2 +-
 drivers/scsi/atari_NCR5380.c |    4 ++--
 drivers/scsi/sun3_NCR5380.c  |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index f8e449a..5b27966 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2133,7 +2133,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 				sink = 1;
 				do_abort(instance);
 				cmd->result = DID_ERROR << 16;
-				cmd->done(cmd);
+				cmd->scsi_done(cmd);
 				return;
 #endif
 				/* 
@@ -2196,7 +2196,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 						sink = 1;
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
-						cmd->done(cmd);
+						cmd->scsi_done(cmd);
 						/* XXX - need to source or sink data here, as appropriate */
 					} else
 						cmd->SCp.this_residual -= transfersize - len;
@@ -2740,7 +2740,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 			tmp->host_scribble = NULL;
 			tmp->result = DID_ABORT << 16;
 			dprintk(NDEBUG_ABORT, ("scsi%d : abort removed command from issue queue.\n", instance->host_no));
-			tmp->done(tmp);
+			tmp->scsi_done(tmp);
 			return SUCCESS;
 		}
 #if (NDEBUG  & NDEBUG_ABORT)
@@ -2805,7 +2805,7 @@ static int NCR5380_abort(Scsi_Cmnd * cmd) {
 					*prev = (Scsi_Cmnd *) tmp->host_scribble;
 					tmp->host_scribble = NULL;
 					tmp->result = DID_ABORT << 16;
-					tmp->done(tmp);
+					tmp->scsi_done(tmp);
 					return SUCCESS;
 				}
 		}
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 79b4df1..96e8e29 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -1385,7 +1385,7 @@ int esp_abort(Scsi_Cmnd *SCptr)
 				this->host_scribble = NULL;
 				esp_release_dmabufs(esp, this);
 				this->result = DID_ABORT << 16;
-				this->done(this);
+				this->scsi_done(this);
 				if(don)
 					esp->dma_ints_on(esp);
 				return SUCCESS;
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 03dbe60..743df4c 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -2041,7 +2041,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				sink = 1;
 				do_abort(instance);
 				cmd->result = DID_ERROR << 16;
-				cmd->done(cmd);
+				cmd->scsi_done(cmd);
 				return;
 #endif
 			case PHASE_DATAIN:
@@ -2100,7 +2100,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						sink = 1;
 						do_abort(instance);
 						cmd->result = DID_ERROR << 16;
-						cmd->done(cmd);
+						cmd->scsi_done(cmd);
 						/* XXX - need to source or sink data here, as appropriate */
 					} else {
 #ifdef REAL_DMA
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 98e3fe1..3769537 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2055,7 +2055,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		sink = 1;
 		do_abort(instance);
 		cmd->result = DID_ERROR  << 16;
-		cmd->done(cmd);
+		cmd->scsi_done(cmd);
 		return;
 #endif
 	    case PHASE_DATAIN:
@@ -2115,7 +2115,7 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 			sink = 1;
 			do_abort(instance);
 			cmd->result = DID_ERROR  << 16;
-			cmd->done(cmd);
+			cmd->scsi_done(cmd);
 			/* XXX - need to source or sink data here, as appropriate */
 		    } else {
 #ifdef REAL_DMA
-- 
1.5.3.1

