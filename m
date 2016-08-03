From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/22] libfc: Debug PRLI failures
Date: Wed,  3 Aug 2016 15:13:06 +0200
Message-ID: <1470230002-37737-7-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40093 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbcHCNNd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:33 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The initial PRLI is errored out with these messages:
[ 5424.530686] host8: rport 001a1e: Received a PRLI accept
[ 5424.530687] host8: rport 001a1e: PRLI spp_flags = 0x0
[ 5424.530688] host8: rport 001a1e: Error -131938289606656 in state PRLI, retrying

'spp_flags=0' is decidedly dodgy, as we should always return a valid PRLI
state here.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 8dd656e..1f22c2e 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -1094,8 +1094,8 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 			goto out;
 
 		resp_code = (pp->spp.spp_flags & FC_SPP_RESP_MASK);
-		FC_RPORT_DBG(rdata, "PRLI spp_flags = 0x%x\n",
-			     pp->spp.spp_flags);
+		FC_RPORT_DBG(rdata, "PRLI spp_flags = 0x%x spp_type 0x%x\n",
+			     pp->spp.spp_flags, pp->spp.spp_type);
 		rdata->spp_type = pp->spp.spp_type;
 		if (resp_code != FC_SPP_RESP_ACK) {
 			if (resp_code == FC_SPP_RESP_CONF)
@@ -1805,7 +1805,6 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 	unsigned int len;
 	unsigned int plen;
 	enum fc_els_spp_resp resp;
-	enum fc_els_spp_resp passive;
 	struct fc_seq_els_data rjt_data;
 	struct fc4_prov *prov;
 
@@ -1855,15 +1854,21 @@ static void fc_rport_recv_prli_req(struct fc_rport_priv *rdata,
 		resp = 0;
 
 		if (rspp->spp_type < FC_FC4_PROV_SIZE) {
+			enum fc_els_spp_resp active = 0, passive = 0;
+
 			prov = fc_active_prov[rspp->spp_type];
 			if (prov)
-				resp = prov->prli(rdata, plen, rspp, spp);
+				active = prov->prli(rdata, plen, rspp, spp);
 			prov = fc_passive_prov[rspp->spp_type];
-			if (prov) {
+			if (prov)
 				passive = prov->prli(rdata, plen, rspp, spp);
-				if (!resp || passive == FC_SPP_RESP_ACK)
-					resp = passive;
-			}
+			if (!active || passive == FC_SPP_RESP_ACK)
+				resp = passive;
+			else
+				resp = active;
+			FC_RPORT_DBG(rdata, "PRLI rspp type %x "
+				     "active %x passive %x\n",
+				     rspp->spp_type, active, passive);
 		}
 		if (!resp) {
 			if (spp->spp_flags & FC_SPP_EST_IMG_PAIR)
-- 
1.8.5.6

