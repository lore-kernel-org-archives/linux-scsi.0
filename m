From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/20] libfc: Remove fc_rport_init()
Date: Tue, 18 Oct 2016 10:01:47 +0200
Message-ID: <1476777714-3543-14-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47379 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758743AbcJRICc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:32 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Function is empty now and can be removed.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  1 -
 drivers/scsi/fcoe/fcoe_ctlr.c     |  1 -
 drivers/scsi/libfc/fc_rport.c     | 10 ----------
 include/scsi/libfc.h              |  1 -
 4 files changed, 13 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index f9ddb61..0990130 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -970,7 +970,6 @@ static int bnx2fc_libfc_config(struct fc_lport *lport)
 		sizeof(struct libfc_function_template));
 	fc_elsct_init(lport);
 	fc_exch_init(lport);
-	fc_rport_init(lport);
 	fc_disc_init(lport);
 	fc_disc_config(lport, lport);
 	return 0;
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 12efc1d..cea57e2 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -3235,7 +3235,6 @@ int fcoe_libfc_config(struct fc_lport *lport, struct fcoe_ctlr *fip,
 	fc_exch_init(lport);
 	fc_elsct_init(lport);
 	fc_lport_init(lport);
-	fc_rport_init(lport);
 	fc_disc_init(lport);
 	fcoe_ctlr_mode_set(lport, fip, fip->mode);
 	return 0;
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 6e50226..110a707 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -2182,16 +2182,6 @@ void fc_rport_flush_queue(void)
 EXPORT_SYMBOL(fc_rport_flush_queue);
 
 /**
- * fc_rport_init() - Initialize the remote port layer for a local port
- * @lport: The local port to initialize the remote port layer for
- */
-int fc_rport_init(struct fc_lport *lport)
-{
-	return 0;
-}
-EXPORT_SYMBOL(fc_rport_init);
-
-/**
  * fc_rport_fcp_prli() - Handle incoming PRLI for the FCP initiator.
  * @rdata: remote port private
  * @spp_len: service parameter page length
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 57630c5..a776901 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -978,7 +978,6 @@ static inline bool fc_fcp_is_read(const struct fc_fcp_pkt *fsp)
 /*
  * REMOTE PORT LAYER
  *****************************/
-int fc_rport_init(struct fc_lport *);
 void fc_rport_terminate_io(struct fc_rport *);
 struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
 				      u32 port_id);
-- 
1.8.5.6

