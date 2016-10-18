From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/20] libfc: Replace ->rport_recv_req callback with function call
Date: Tue, 18 Oct 2016 10:01:45 +0200
Message-ID: <1476777714-3543-12-git-send-email-hare@suse.de>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47357 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758304AbcJRIC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:02:29 -0400
In-Reply-To: <1476777714-3543-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The ->rport_recv_req callback only ever had one implementation,
so we can as well call it directly and drop the callback.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_lport.c | 2 +-
 drivers/scsi/libfc/fc_rport.c | 6 ++----
 include/scsi/libfc.h          | 8 +-------
 3 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index a391cb1..937a442 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -902,7 +902,7 @@ static void fc_lport_recv_els_req(struct fc_lport *lport,
 		/*
 		 * Check opcode.
 		 */
-		recv = lport->tt.rport_recv_req;
+		recv = fc_rport_recv_req;
 		switch (fc_frame_payload_op(fp)) {
 		case ELS_FLOGI:
 			if (!lport->point_to_multipoint)
diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 22c8c92..feae7ab 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1786,7 +1786,7 @@ static void fc_rport_recv_els_req(struct fc_lport *lport, struct fc_frame *fp)
  *
  * Reference counting: does not modify kref
  */
-static void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp)
+void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp)
 {
 	struct fc_seq_els_data els_data;
 
@@ -1823,6 +1823,7 @@ static void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp)
 		break;
 	}
 }
+EXPORT_SYMBOL(fc_rport_recv_req);
 
 /**
  * fc_rport_recv_plogi_req() - Handler for Port Login (PLOGI) requests
@@ -2185,9 +2186,6 @@ static void fc_rport_flush_queue(void)
  */
 int fc_rport_init(struct fc_lport *lport)
 {
-	if (!lport->tt.rport_recv_req)
-		lport->tt.rport_recv_req = fc_rport_recv_req;
-
 	if (!lport->tt.rport_flush_queue)
 		lport->tt.rport_flush_queue = fc_rport_flush_queue;
 
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index b75a182..1e1dbc9 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -610,13 +610,6 @@ struct libfc_function_template {
 				  struct fc_frame *);
 
 	/*
-	 * Receive a request from a remote port.
-	 *
-	 * STATUS: OPTIONAL
-	 */
-	void (*rport_recv_req)(struct fc_lport *, struct fc_frame *);
-
-	/*
 	 * Callback routine after the remote port is logged in
 	 *
 	 * STATUS: OPTIONAL
@@ -1000,6 +993,7 @@ struct fc_rport_priv *fc_rport_lookup(const struct fc_lport *lport,
 void fc_rport_destroy(struct kref *kref);
 int fc_rport_login(struct fc_rport_priv *rdata);
 int fc_rport_logoff(struct fc_rport_priv *rdata);
+void fc_rport_recv_req(struct fc_lport *lport, struct fc_frame *fp);
 
 /*
  * DISCOVERY LAYER
-- 
1.8.5.6

