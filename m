From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/8] libfc: use DID_TRANSPORT_DISRUPTED while lport not ready
Date: Fri, 08 Oct 2010 17:12:15 -0700
Message-ID: <20101009001215.7744.35788.stgit@localhost.localdomain>
References: <20101009001204.7744.21642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9939 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JIAMQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 20:12:16 -0400
In-Reply-To: <20101009001204.7744.21642.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

This is per Mile Christie feedback since in this case IO
could get retried for tape devices and therefore DID_REQUEUE
cannot be used, more details in this thread.

http://marc.info/?l=linux-scsi&m=127970522630136&w=2

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c797f6b..43866e6 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1971,10 +1971,8 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		break;
 	}
 
-	if (lport->state != LPORT_ST_READY && fsp->status_code != FC_COMPLETE) {
-		sc_cmd->result = (DID_REQUEUE << 16);
-		FC_FCP_DBG(fsp, "Returning DID_REQUEUE to scsi-ml\n");
-	}
+	if (lport->state != LPORT_ST_READY && fsp->status_code != FC_COMPLETE)
+		sc_cmd->result = (DID_TRANSPORT_DISRUPTED << 16);
 
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
 	list_del(&fsp->list);

