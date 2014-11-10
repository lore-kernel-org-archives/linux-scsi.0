From: Hiral Shah <hishah@cisco.com>
Subject: [PATCH 3/5] [SCSI] Fnic: Improper resue of exchange Ids
Date: Mon, 10 Nov 2014 12:54:34 -0800
Message-ID: <1415652876-24570-3-git-send-email-hishah@cisco.com>
References: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-1.cisco.com ([173.37.142.88]:37993 "EHLO
	alln-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbaKJVCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2014 16:02:43 -0500
In-Reply-To: <1415652876-24570-1-git-send-email-hishah@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hiral Shah <hishah@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, Anil Chintalapati <achintal@cisco.com>

IOs belonging to an rport are aborted with Internal terminate option
when rport goes offline. Any new IO issued to the rport during this
time can reuse the terminated exchange which will cause inconsistent
state of the exchange between local port and remote port.

fc_rport_priv is set to RPORT_ST_DELETE before exchanges are aborted by libfc.
Not issuing amy more I/O requests when RPORT_ST_DELETE is set, will avoid
inconsistent state of the exchange between local port and remote port.

- Increment fnic version from 1.6.0.13 to 1.6.0.14

Signed-off-by: Hiral Shah <hishah@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Anil Chintalapati <achintal@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_scsi.c | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index dbc69ad..5336e8d 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.13"
+#define DRV_VERSION		"1.6.0.14"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 961bdf5..d59d4c1 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -430,6 +430,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	int sg_count = 0;
 	unsigned long flags;
 	unsigned long ptr;
+	struct fc_rport_priv *rdata;
 
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED)))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -443,6 +444,16 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 		return 0;
 	}
 
+	rdata = lp->tt.rport_lookup(lp, rport->port_id);
+	if (!rdata || (rdata->rp_state == RPORT_ST_DELETE)) {
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"returning IO as rport is removed\n");
+		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
+		sc->result = DID_NO_CONNECT;
+		done(sc);
+		return 0;
+	}
+
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-- 
1.8.5.4

