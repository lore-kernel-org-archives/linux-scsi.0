From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 05/17] libfc: Honor LS_ACC response codes for PRLI
Date: Fri, 11 Jun 2010 16:43:54 -0700
Message-ID: <20100611234354.4616.31826.stgit@localhost.localdomain>
References: <20100611234328.4616.95199.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9073 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab0FKXnz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2010 19:43:55 -0400
In-Reply-To: <20100611234328.4616.95199.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

As per FC-LS Rev 1.62 table 46, response codes are handled as follows:

1. If the Req executed is true, PRLI is accepted.
2. If Req executed is not set,  if resp code is 5,
   PRLI is not retried and port is logged out.
3. If resp code is anything apart from 1 or 5, PRLI is retired
   upto max retry count.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_rport.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 3ee497a..e33c5c7 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -698,6 +698,7 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	u32 roles = FC_RPORT_ROLE_UNKNOWN;
 	u32 fcp_parm = 0;
 	u8 op;
+	u8 resp_code = 0;
 
 	mutex_lock(&rdata->rp_mutex);
 
@@ -722,11 +723,25 @@ static void fc_rport_prli_resp(struct fc_seq *sp, struct fc_frame *fp,
 	op = fc_frame_payload_op(fp);
 	if (op == ELS_LS_ACC) {
 		pp = fc_frame_payload_get(fp, sizeof(*pp));
-		if (pp && pp->prli.prli_spp_len >= sizeof(pp->spp)) {
-			fcp_parm = ntohl(pp->spp.spp_params);
-			if (fcp_parm & FCP_SPPF_RETRY)
-				rdata->flags |= FC_RP_FLAGS_RETRY;
+		if (!pp)
+			goto out;
+
+		resp_code = (pp->spp.spp_flags & FC_SPP_RESP_MASK);
+		FC_RPORT_DBG(rdata, "PRLI spp_flags = 0x%x\n",
+			     pp->spp.spp_flags);
+		if (resp_code != FC_SPP_RESP_ACK) {
+			if (resp_code == FC_SPP_RESP_CONF)
+				fc_rport_error(rdata, fp);
+			else
+				fc_rport_error_retry(rdata, fp);
+			goto out;
 		}
+		if (pp->prli.prli_spp_len < sizeof(pp->spp))
+			goto out;
+
+		fcp_parm = ntohl(pp->spp.spp_params);
+		if (fcp_parm & FCP_SPPF_RETRY)
+			rdata->flags |= FC_RP_FLAGS_RETRY;
 
 		rdata->supported_classes = FC_COS_CLASS3;
 		if (fcp_parm & FCP_SPPF_INIT_FCN)

