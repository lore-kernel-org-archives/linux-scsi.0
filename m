From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/8] libfc: possible race could panic system due to NULL
	fsp->cmd
Date: Fri, 08 Oct 2010 17:12:31 -0700
Message-ID: <20101009001231.7744.90184.stgit@localhost.localdomain>
References: <20101009001204.7744.21642.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab0JIAMb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2010 20:12:31 -0400
In-Reply-To: <20101009001204.7744.21642.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

It is unlikely but in case if it hits then it would cause panic
due to null cmd ptr, so far only one instance seen recently with
ESX though this was introduced long ago with this commit:-

commit c1ecb90a66c5afc7cc5c9349f9c3714eef4a5cfb
Author: Chris Leech <christopher.leech@intel.com>
Date:   Thu Dec 10 09:59:26 2009 -0800
[SCSI] libfc: reduce hold time on SCSI host lock

Currently fsp->cmd is set to NULL w/o scsi_queue_lock before
dequeuing from scsi_pkt_queue and that could cause NULL
fsp->cmd in fc_fcp_cleanup_each_cmd for cmd completing
with fsp->cmd = NULL after fc_fcp_cleanup_each_cmd taken
reference. No need to set fsp->cmd to NULL as this is also
protected by fc_fcp_lock_pkt(), for above race the
fc_fcp_lock_pkt() in fc_fcp_cleanup_each_cmd() will fail
as that cmd is  already done.

Mike mentioned same issue at
http://www.open-fcoe.org/pipermail/devel/2010-September/010533.html

Similarly moved sc_cmd->SCp.ptr = NULL under scsi_queue_lock so
that scsi abort error handler won't abort on completed cmds.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 43866e6..e340373 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -58,8 +58,7 @@ struct kmem_cache *scsi_pkt_cachep;
 #define FC_SRB_WRITE		(1 << 0)
 
 /*
- * The SCp.ptr should be tested and set under the host lock. NULL indicates
- * that the command has been retruned to the scsi layer.
+ * The SCp.ptr should be tested and set under the scsi_pkt_queue lock
  */
 #define CMD_SP(Cmnd)		    ((struct fc_fcp_pkt *)(Cmnd)->SCp.ptr)
 #define CMD_ENTRY_STATUS(Cmnd)	    ((Cmnd)->SCp.have_data_in)
@@ -1880,8 +1879,6 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 
 	lport = fsp->lp;
 	si = fc_get_scsi_internal(lport);
-	if (!fsp->cmd)
-		return;
 
 	/*
 	 * if can_queue ramp down is done then try can_queue ramp up
@@ -1891,11 +1888,6 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		fc_fcp_can_queue_ramp_up(lport);
 
 	sc_cmd = fsp->cmd;
-	fsp->cmd = NULL;
-
-	if (!sc_cmd->SCp.ptr)
-		return;
-
 	CMD_SCSI_STATUS(sc_cmd) = fsp->cdb_status;
 	switch (fsp->status_code) {
 	case FC_COMPLETE:
@@ -1976,8 +1968,8 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
 	list_del(&fsp->list);
-	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 	sc_cmd->SCp.ptr = NULL;
+	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 	sc_cmd->scsi_done(sc_cmd);
 
 	/* release ref from initial allocation in queue command */
@@ -1995,6 +1987,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 {
 	struct fc_fcp_pkt *fsp;
 	struct fc_lport *lport;
+	struct fc_fcp_internal *si;
 	int rc = FAILED;
 	unsigned long flags;
 
@@ -2004,7 +1997,8 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	else if (!lport->link_up)
 		return rc;
 
-	spin_lock_irqsave(lport->host->host_lock, flags);
+	si = fc_get_scsi_internal(lport);
+	spin_lock_irqsave(&si->scsi_queue_lock, flags);
 	fsp = CMD_SP(sc_cmd);
 	if (!fsp) {
 		/* command completed while scsi eh was setting up */
@@ -2013,7 +2007,7 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
 	}
 	/* grab a ref so the fsp and sc_cmd cannot be relased from under us */
 	fc_fcp_pkt_hold(fsp);
-	spin_unlock_irqrestore(lport->host->host_lock, flags);
+	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);
 
 	if (fc_fcp_lock_pkt(fsp)) {
 		/* completed while we were waiting for timer to be deleted */

