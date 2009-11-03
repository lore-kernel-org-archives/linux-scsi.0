From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 04/54] libfc: Remove fc_fcp_complete
Date: Tue, 03 Nov 2009 11:45:52 -0800
Message-ID: <20091103194552.4085.94465.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23103 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbZKCTpr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:45:47 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

This function is never used, let's remove it.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |   17 -----------------
 include/scsi/libfc.h        |    8 --------
 2 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 479af93..3ab08f8 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1875,23 +1875,6 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 }
 
 /**
- * fc_fcp_complete() - complete processing of a fcp packet
- * @fsp:	fcp packet
- *
- * This function may sleep if a fsp timer is pending.
- * The host lock must not be held by caller.
- */
-void fc_fcp_complete(struct fc_fcp_pkt *fsp)
-{
-	if (fc_fcp_lock_pkt(fsp))
-		return;
-
-	fc_fcp_complete_locked(fsp);
-	fc_fcp_unlock_pkt(fsp);
-}
-EXPORT_SYMBOL(fc_fcp_complete);
-
-/**
  * fc_eh_abort() - Abort a command
  * @sc_cmd:	scsi command to abort
  *
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index f207b6c..db2175d 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -888,14 +888,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd,
 		    void (*done)(struct scsi_cmnd *));
 
 /*
- * complete processing of a fcp packet
- *
- * This function may sleep if a fsp timer is pending.
- * The host lock must not be held by caller.
- */
-void fc_fcp_complete(struct fc_fcp_pkt *fsp);
-
-/*
  * Send an ABTS frame to the target device. The sc_cmd argument
  * is a pointer to the SCSI command to be aborted.
  */

