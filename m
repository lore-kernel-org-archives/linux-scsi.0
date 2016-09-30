From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 3/7] libfc: Do not take rdata->rp_mutex when processing a -FC_EX_CLOSED ELS response.
Date: Fri, 30 Sep 2016 11:01:16 +0200
Message-ID: <1475226080-60365-4-git-send-email-hare@suse.de>
References: <1475226080-60365-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34049 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932303AbcI3JBd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 05:01:33 -0400
In-Reply-To: <1475226080-60365-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Chad Dupuis <chad.dupuis@cavium.com>, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@cavium.com>

When an ELS response handler receives a -FC_EX_CLOSED, the rdata->rp_mutex is
already held which can lead to a deadlock condition like the following stack trace:

[<ffffffffa04d8f18>] fc_rport_plogi_resp+0x28/0x200 [libfc]
[<ffffffffa04cfa1a>] fc_invoke_resp+0x6a/0xe0 [libfc]
[<ffffffffa04d0c08>] fc_exch_mgr_reset+0x1b8/0x280 [libfc]
[<ffffffffa04d87b3>] fc_rport_logoff+0x43/0xd0 [libfc]
[<ffffffffa04ce73d>] fc_disc_stop+0x6d/0xf0 [libfc]
[<ffffffffa04ce7ce>] fc_disc_stop_final+0xe/0x20 [libfc]
[<ffffffffa04d55f7>] fc_fabric_logoff+0x17/0x70 [libfc]

The other ELS handlers need to follow the FLOGI response handler and simply do
a kref_put against the fc_rport_priv struct and exit when receving a
-FC_EX_CLOSED response.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/libfc/fc_rport.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index a0ceba1..ff33ae6 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -952,10 +952,13 @@ static void fc_rport_plogi_resp(struct fc_seq *sp, struct fc_frame *fp,
 	u16 cssp_seq;
 	u8 op;
 
-	mutex_lock(&rdata->rp_mutex);
-
 	FC_RPORT_DBG(rdata, "Received a PLOGI %s\n", fc_els_resp_type(fp));
 
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		goto put;
+
+	mutex_lock(&rdata->rp_mutex);
+
 	if (rdata->rp_state != RPORT_ST_PLOGI) {
 		FC_RPORT_DBG(rdata, "Received a PLOGI response, but in state "
 			     "%s\n", fc_rport_state(rdata));
@@ -994,6 +997,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
+put:
 	kref_put(&rdata->kref, lport->tt.rport_destroy);
 }
 
@@ -1079,10 +1083,13 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	u8 op;
 	u8 resp_code = 0;
 
-	mutex_lock(&rdata->rp_mutex);
-
 	FC_RPORT_DBG(rdata, "Received a PRLI %s\n", fc_els_resp_type(fp));
 
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		goto put;
+
+	mutex_lock(&rdata->rp_mutex);
+
 	if (rdata->rp_state != RPORT_ST_PRLI) {
 		FC_RPORT_DBG(rdata, "Received a PRLI response, but in state "
 			     "%s\n", fc_rport_state(rdata));
@@ -1150,6 +1157,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
+put:
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
@@ -1230,10 +1238,13 @@ static void fc_rport_rtv_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_rport_priv *rdata = rdata_arg;
 	u8 op;
 
-	mutex_lock(&rdata->rp_mutex);
-
 	FC_RPORT_DBG(rdata, "Received a RTV %s\n", fc_els_resp_type(fp));
 
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		goto put;
+
+	mutex_lock(&rdata->rp_mutex);
+
 	if (rdata->rp_state != RPORT_ST_RTV) {
 		FC_RPORT_DBG(rdata, "Received a RTV response, but in state "
 			     "%s\n", fc_rport_state(rdata));
@@ -1275,6 +1286,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
+put:
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
@@ -1374,10 +1386,13 @@ static void fc_rport_adisc_resp(struct fc_seq *sp, struct fc_frame *fp,
 	struct fc_els_adisc *adisc;
 	u8 op;
 
-	mutex_lock(&rdata->rp_mutex);
-
 	FC_RPORT_DBG(rdata, "Received a ADISC response\n");
 
+	if (fp == ERR_PTR(-FC_EX_CLOSED))
+		goto put;
+
+	mutex_lock(&rdata->rp_mutex);
+
 	if (rdata->rp_state != RPORT_ST_ADISC) {
 		FC_RPORT_DBG(rdata, "Received a ADISC resp but in state %s\n",
 			     fc_rport_state(rdata));
@@ -1412,6 +1427,7 @@ out:
 	fc_frame_free(fp);
 err:
 	mutex_unlock(&rdata->rp_mutex);
+put:
 	kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 }
 
-- 
1.8.5.6

