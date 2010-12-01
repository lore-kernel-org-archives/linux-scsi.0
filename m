From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/27] libfc: remove tgt_flags from fc_fcp_pkt struct
Date: Tue, 30 Nov 2010 16:18:49 -0800
Message-ID: <20101201001849.18369.92955.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29401 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab0LAASt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:49 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: John Fastabend <john.r.fastabend@intel.com>

From: john fastabend <john.r.fastabend@intel.com>

We can easily remove the tgt_flags from fc_fcp_pkt struct
and use rpriv->tgt_flags directly where needed.

Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    5 ++---
 include/scsi/libfc.h        |    2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 3cf81b9..c12994b 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1150,8 +1150,9 @@ static int fc_fcp_cmd_send(struct fc_lport *lport, struct fc_fcp_pkt *fsp,
 
 	setup_timer(&fsp->timer, fc_fcp_timeout, (unsigned long)fsp);
 
-	if (fsp->tgt_flags & FC_RP_FLAGS_REC_SUPPORTED)
+	if (rpriv->flags & FC_RP_FLAGS_REC_SUPPORTED)
 		fc_fcp_timer_set(fsp, rec_tov);
+
 unlock:
 	fc_fcp_unlock_pkt(fsp);
 	return rc;
@@ -1867,8 +1868,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	}
 	put_cpu();
 
-	fsp->tgt_flags = rpriv->flags;
-
 	init_timer(&fsp->timer);
 	fsp->timer.data = (unsigned long)fsp;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index f986ab7..1463660 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -263,7 +263,6 @@ struct fc_seq_els_data {
  * struct fc_fcp_pkt - FCP request structure (one for each scsi_cmnd request)
  * @lp:              The associated local port
  * @state:           The state of the I/O
- * @tgt_flags:       Target's flags
  * @ref_cnt:         Reference count
  * @scsi_pkt_lock:   Lock to protect the SCSI packet (must be taken before the
  *                   host_lock if both are to be held at the same time)
@@ -298,7 +297,6 @@ struct fc_fcp_pkt {
 	/* Housekeeping information */
 	struct fc_lport   *lp;
 	u16		  state;
-	u16		  tgt_flags;
 	atomic_t	  ref_cnt;
 	spinlock_t	  scsi_pkt_lock;
 

