Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85133770D;
	Fri,  9 Aug 2024 16:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723221946; cv=none; b=lOob7YZ6kndny9FXiCwfXX1cCEix1vtOboOocAzBrgA3AGgC0HdQk+5GkmKItT5+SRvzNhhP3TZ4HeSk83YnFUOfBkP7VbLM1HAzNZrfdiksSlofpQiFKfVeeJ5i0IQRsav1u1bp1xXaJpp2sogpt4O1t5zhBpa9g7VBVeixCrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723221946; c=relaxed/simple;
	bh=+MZJo4QXo4cyj1137tN75KyjAx49Sign0KQK2IGS+QQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h+abxAHjGfnnKoVkvbomySZgIGJLOX003ruo0ukiXrd1RM+M0nYFeE/sb50VT7cxKlLrK1kk67Dk6P57VXaYwtZVKPmTenqCCPZVOin4kypd1AvXxrEl289P9wRy3k5L1bJt5jtzxxHiaYSsDAS3xf2PO61KgxeIshhAxXueyYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=Krif08RB; arc=none smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="Krif08RB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=20767; q=dns/txt;
  s=iport; t=1723221944; x=1724431544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=inuZ1uv72EbR9/FLJkvQd/AL2wG6kL6w4MuLlJFgmu4=;
  b=Krif08RBrcryc1bq5wHPN29vCICMRISO+d8XYrzf6ZV4L+Lwn+YffZNh
   GMY17IZcYF933/k3B5H+1C3kNd3tkNh4Eo5gDFBaCocnu7rQAV0ZH2atk
   zD9tN3QI6gcymshlrpZg4f8To/pKm7BtufLHSlfGnUn4/ef/qqcNvoEuh
   Q=;
X-CSE-ConnectionGUID: EQlrUWeLQGKKma7rrsqkmw==
X-CSE-MsgGUID: OnxPpSxwRX6BA8PTB1ggWA==
X-IronPort-AV: E=Sophos;i="6.09,276,1716249600"; 
   d="scan'208";a="337402125"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by alln-iport-3.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 16:45:42 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 479Ggo2a031305
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 9 Aug 2024 16:45:42 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 05/14] scsi: fnic: Add support for unsolicited requests and responses
Date: Fri,  9 Aug 2024 09:42:31 -0700
Message-Id: <20240809164240.47561-6-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240809164240.47561-1-kartilak@cisco.com>
References: <20240809164240.47561-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: rcdn-core-5.cisco.com

Add support for unsolicited requests and responses.
Add support to accept and reject frames.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v1 and v2:
    Incorporate review comments from Hannes:
	Replace fnic_del_tport_timer_sync macro calls with function
	calls.
	Fix indentation.
	Replace definitions with standard definitions from fc_els.h.
---
 drivers/scsi/fnic/fdls_disc.c | 566 +++++++++++++++++++++++++++++++++-
 1 file changed, 563 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 696f8d926865..10691335e4c0 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -125,6 +125,21 @@ struct fc_scr_s fnic_scr_req = {
 	.reg_func = 0x03
 };
 
+/*
+ * Variables:
+ * did, ox_id, rx_id
+ */
+struct fc_els_acc_s fnic_els_acc = {
+	.fchdr = {.r_ctl = 0x23, .did = {0xFF, 0xFF, 0xFD}, .type = 0x01,
+			  .f_ctl = FNIC_ELS_REP_FCTL},
+	.command = ELS_LS_ACC,
+};
+
+struct fc_els_reject_s fnic_els_rjt = {
+	.fchdr = {.r_ctl = 0x23, .type = 0x01, .f_ctl = FNIC_ELS_REP_FCTL},
+	.command = ELS_LS_RJT,
+};
+
 /*
  * Variables:
  * did, ox_id, rx_id, fcid, wwpn
@@ -150,6 +165,13 @@ struct fc_hdr_s fc_tport_abts_s = {
 	.param = 0x00000000,	/* bit:0 = 0 Abort a exchange */
 };
 
+static struct fc_abts_ba_acc_s fnic_ba_acc = {
+	.fchdr = {.r_ctl = 0x84,
+			  .f_ctl = FNIC_FCP_RSP_FCTL},
+	.low_seq_cnt = 0,
+	.high_seq_cnt = 0xFFFF,
+};
+
 #define RETRIES_EXHAUSTED(iport)      \
 	(iport->fabric.retry_counter == FABRIC_LOGO_MAX_RETRY)
 
@@ -165,7 +187,6 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
 static void fdls_target_restart_nexus(struct fnic_tport_s *tport);
 static void fdls_start_tport_timer(struct fnic_iport_s *iport,
 					struct fnic_tport_s *tport, int timeout);
-
 static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
 			int timeout);
 static void fdls_tport_timer_callback(struct timer_list *t);
@@ -265,6 +286,48 @@ fdls_start_tport_timer(struct fnic_iport_s *iport,
 	tport->timer_pending = 1;
 }
 
+static void
+fdls_send_rscn_resp(struct fnic_iport_s *iport,
+					struct fc_hdr_s *rscn_fchdr)
+{
+	struct fc_els_acc_s els_acc;
+	uint16_t oxid;
+	uint8_t fcid[3];
+
+	memcpy(&els_acc, &fnic_els_acc, sizeof(struct fc_els_acc_s));
+
+	hton24(fcid, iport->fcid);
+	FNIC_SET_S_ID((&els_acc.fchdr), fcid);
+	FNIC_SET_D_ID((&els_acc.fchdr), rscn_fchdr->sid);
+
+	oxid = FNIC_GET_OX_ID(rscn_fchdr);
+	FNIC_SET_OX_ID((&els_acc.fchdr), oxid);
+
+	FNIC_SET_RX_ID((&els_acc.fchdr), FNIC_RSCN_RESP_OXID);
+
+	fnic_send_fcoe_frame(iport, &els_acc, sizeof(struct fc_els_acc_s));
+}
+
+static void
+fdls_send_logo_resp(struct fnic_iport_s *iport, struct fc_hdr_s *req_fchdr)
+{
+	struct fc_els_acc_s logo_resp;
+	uint16_t oxid;
+	uint8_t fcid[3];
+
+	memcpy(&logo_resp, &fnic_els_acc, sizeof(struct fc_els_acc_s));
+
+	hton24(fcid, iport->fcid);
+	FNIC_SET_S_ID((&logo_resp.fchdr), fcid);
+	FNIC_SET_D_ID((&logo_resp.fchdr), req_fchdr->sid);
+
+	oxid = FNIC_GET_OX_ID(req_fchdr);
+	FNIC_SET_OX_ID((&logo_resp.fchdr), oxid);
+
+	FNIC_SET_RX_ID((&logo_resp.fchdr), FNIC_LOGO_RESP_OXID);
+	fnic_send_fcoe_frame(iport, &logo_resp, sizeof(struct fc_els_acc_s));
+}
+
 void
 fdls_send_tport_abts(struct fnic_iport_s *iport,
 					 struct fnic_tport_s *tport)
@@ -2501,6 +2564,188 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 	}
 }
 
+static void
+fdls_process_abts_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
+{
+	struct fc_abts_ba_acc_s ba_acc;
+	uint32_t nport_id;
+	uint16_t oxid;
+	struct fnic_tport_s *tport;
+	struct fnic *fnic = iport->fnic;
+
+	nport_id = ntoh24(fchdr->sid);
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Received abort from SID %8x", nport_id);
+
+	tport = fnic_find_tport_by_fcid(iport, nport_id);
+	if (tport) {
+		oxid = FNIC_GET_OX_ID(fchdr);
+		if (tport->oxid_used == oxid) {
+			tport->flags |= FNIC_FDLS_TGT_ABORT_ISSUED;
+			fdls_free_tgt_oxid(iport, ntohs(oxid));
+		}
+	}
+
+	memcpy(&ba_acc, &fnic_ba_acc, sizeof(struct fc_abts_ba_acc_s));
+	FNIC_SET_S_ID((&ba_acc.fchdr), fchdr->did);
+	FNIC_SET_D_ID((&ba_acc.fchdr), fchdr->sid);
+
+	ba_acc.fchdr.rx_id = fchdr->rx_id;
+	ba_acc.rx_id = ba_acc.fchdr.rx_id;
+	ba_acc.fchdr.ox_id = fchdr->ox_id;
+	ba_acc.ox_id = ba_acc.fchdr.ox_id;
+
+	fnic_send_fcoe_frame(iport, &ba_acc, sizeof(struct fc_abts_ba_acc_s));
+}
+
+static void
+fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
+								 struct fc_hdr_s *fchdr)
+{
+	struct fc_els_reject_s ls_rsp;
+	uint16_t oxid;
+	uint32_t d_id = ntoh24(fchdr->did);
+	struct fnic *fnic = iport->fnic;
+
+	memcpy(&ls_rsp, &fnic_els_rjt, sizeof(struct fc_els_reject_s));
+
+	if (iport->fcid != d_id) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Dropping unsupported ELS with illegal frame bits 0x%x\n",
+			 d_id);
+		return;
+	}
+
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Dropping unsupported ELS request in iport state: %d",
+			 iport->state);
+		return;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process unsupported ELS request from SID: 0x%x",
+				 ntoh24(fchdr->sid));
+	/* We don't support this ELS request, send a reject */
+	ls_rsp.reason_code = 0x0B;
+	ls_rsp.reason_expl = 0x0;
+	ls_rsp.vendor_specific = 0x0;
+
+	FNIC_SET_S_ID((&ls_rsp.fchdr), fchdr->did);
+	FNIC_SET_D_ID((&ls_rsp.fchdr), fchdr->sid);
+	oxid = FNIC_GET_OX_ID(fchdr);
+	FNIC_SET_OX_ID((&ls_rsp.fchdr), oxid);
+
+	FNIC_SET_RX_ID((&ls_rsp.fchdr), FNIC_UNSUPPORTED_RESP_OXID);
+	fnic_send_fcoe_frame(iport, &ls_rsp, sizeof(struct fc_els_reject_s));
+}
+
+static void
+fdls_process_rls_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
+{
+	struct fc_els_rls_ls_acc_s rls_acc_rsp;
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process RLS request %d", iport->fnic->fnic_num);
+
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Received RLS req in iport state: %d. Dropping the frame.",
+			 iport->state);
+		return;
+	}
+
+	memset(&rls_acc_rsp, 0, sizeof(struct fc_els_rls_ls_acc_s));
+
+	FNIC_SET_S_ID((&rls_acc_rsp.fchdr), fchdr->did);
+	FNIC_SET_D_ID((&rls_acc_rsp.fchdr), fchdr->sid);
+	oxid = FNIC_GET_OX_ID(fchdr);
+	FNIC_SET_OX_ID((&rls_acc_rsp.fchdr), oxid);
+	FNIC_SET_RX_ID((&rls_acc_rsp.fchdr), 0xffff);
+	rls_acc_rsp.fchdr.f_ctl = FNIC_ELS_REP_FCTL;
+	rls_acc_rsp.fchdr.r_ctl = 0x23;
+	rls_acc_rsp.fchdr.type = 0x01;
+	rls_acc_rsp.command = ELS_LS_ACC;
+	rls_acc_rsp.link_fail_count = htonl(iport->fnic->link_down_cnt);
+
+	fnic_send_fcoe_frame(iport, &rls_acc_rsp,
+			 sizeof(struct fc_els_rls_ls_acc_s));
+}
+
+static void
+fdls_process_els_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
+					 uint32_t len)
+{
+	struct fc_els_acc_s *els_acc;
+	uint16_t oxid;
+	uint8_t fcid[3];
+	uint8_t *fc_payload;
+	uint8_t *dst_frame;
+	uint8_t type;
+	struct fnic *fnic = iport->fnic;
+
+	fc_payload = (uint8_t *) fchdr + sizeof(struct fc_hdr_s);
+	type = *fc_payload;
+
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Dropping ELS frame type :%x in iport state: %d",
+				 type, iport->state);
+		return;
+	}
+	switch (type) {
+	case ELS_ECHO:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "sending LS_ACC for ECHO request %d\n",
+					 iport->fnic->fnic_num);
+		break;
+
+	case ELS_RRQ:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "sending LS_ACC for RRQ request %d\n",
+					 iport->fnic->fnic_num);
+		break;
+
+	default:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "sending LS_ACC for %x ELS frame\n", type);
+		break;
+	}
+	dst_frame = kzalloc(len, GFP_ATOMIC);
+	if (!dst_frame) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Failed to allocate ELS response for %x", type);
+		return;
+	}
+	if (type == ELS_ECHO) {
+		/* Brocade sends a longer payload, copy all frame back */
+		memcpy(dst_frame, fchdr, len);
+	}
+
+	els_acc = (struct fc_els_acc_s *) dst_frame;
+	memcpy(els_acc, &fnic_els_acc, sizeof(struct fc_els_acc_s));
+
+	hton24(fcid, iport->fcid);
+	FNIC_SET_S_ID((&els_acc->fchdr), fcid);
+	FNIC_SET_D_ID((&els_acc->fchdr), fchdr->sid);
+
+	oxid = FNIC_GET_OX_ID(fchdr);
+	FNIC_SET_OX_ID((&els_acc->fchdr), oxid);
+	FNIC_SET_RX_ID((&els_acc->fchdr), 0xffff);
+
+	if (type == ELS_ECHO)
+		fnic_send_fcoe_frame(iport, els_acc, len);
+	else
+		fnic_send_fcoe_frame(iport, els_acc, sizeof(struct fc_els_acc_s));
+
+	kfree(dst_frame);
+}
+
 static void
 fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 						  struct fc_hdr_s *fchdr)
@@ -2544,8 +2789,8 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 	if ((oxid >= FDLS_ADISC_OXID_BASE) && (oxid < FDLS_TGT_OXID_POOL_END)) {
 		if (fchdr->r_ctl == FNIC_BA_ACC_RCTL) {
 			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
-						 "Received tgt ADISC abts response BA_ACC for OX_ID: 0x%x tgt_fcid: 0x%x",
-						 ba_acc->ox_id, tport->fcid);
+				 "OX_ID: 0x%x tgt_fcid: 0x%x rcvd tgt adisc abts resp BA_ACC",
+				 ba_acc->ox_id, tport->fcid);
 		} else if (fchdr->r_ctl == FNIC_BA_RJT_RCTL) {
 			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
 				 "ADISC BA_RJT rcvd tport_fcid: 0x%x tport_state: %d ",
@@ -2636,6 +2881,296 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 				 "Received ABTS response for unknown frame %p", iport);
 }
 
+static void
+fdls_process_plogi_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
+{
+	struct fc_els_reject_s plogi_rsp;
+	uint16_t oxid;
+	uint32_t d_id = ntoh24(fchdr->did);
+	struct fnic *fnic = iport->fnic;
+
+	memcpy(&plogi_rsp, &fnic_els_rjt, sizeof(struct fc_els_reject_s));
+
+	if (iport->fcid != d_id) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Received PLOGI with illegal frame bits. Dropping frame %p",
+			 iport);
+		return;
+	}
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Received PLOGI request in iport state: %d Dropping frame",
+			 iport->state);
+		return;
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process PLOGI request from SID: 0x%x",
+				 ntoh24(fchdr->sid));
+
+	/* We don't support PLOGI request, send a reject */
+	plogi_rsp.reason_code = 0x0B;
+	plogi_rsp.reason_expl = 0x0;
+	plogi_rsp.vendor_specific = 0x0;
+
+	FNIC_SET_S_ID((&plogi_rsp.fchdr), fchdr->did);
+	FNIC_SET_D_ID((&plogi_rsp.fchdr), fchdr->sid);
+
+	oxid = FNIC_GET_OX_ID(fchdr);
+	FNIC_SET_OX_ID((&plogi_rsp.fchdr), oxid);
+
+	FNIC_SET_RX_ID((&plogi_rsp.fchdr), FNIC_PLOGI_RESP_OXID);
+	fnic_send_fcoe_frame(iport, &plogi_rsp,
+			 sizeof(struct fc_els_reject_s));
+}
+
+static void
+fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
+{
+	struct fc_logo_req_s *logo = (struct fc_logo_req_s *) fchdr;
+	uint32_t nport_id;
+	uint64_t nport_name;
+	struct fnic_tport_s *tport;
+	struct fnic *fnic = iport->fnic;
+	uint16_t oxid;
+
+	nport_id = ntoh24(logo->fcid);
+	nport_name = logo->wwpn;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process LOGO request from fcid: 0x%x", nport_id);
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			 "Dropping LOGO req from 0x%x in iport state: %d",
+			 nport_id, iport->state);
+		return;
+	}
+
+	tport = fnic_find_tport_by_fcid(iport, nport_id);
+
+	if (!tport) {
+		/* We are not logged in with the nport, log and drop... */
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "Received LOGO from an nport not logged in: 0x%x",
+					 nport_id);
+		return;
+	}
+	if (tport->fcid != nport_id) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "Received LOGO with invalid target port fcid: 0x%x",
+					 nport_id);
+		return;
+	}
+	if (tport->timer_pending) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "tport fcid 0x%x: Canceling disc timer\n",
+					 tport->fcid);
+		fnic_del_tport_timer_sync(fnic, tport);
+		tport->timer_pending = 0;
+	}
+
+	/* got a logo in response to adisc to a target which has logged out */
+	if (tport->state == FDLS_TGT_STATE_ADISC) {
+		tport->retry_counter = 0;
+		oxid = ntohs(tport->oxid_used);
+		fdls_free_tgt_oxid(iport, oxid);
+		fdls_delete_tport(iport, tport);
+		fdls_send_logo_resp(iport, &logo->fchdr);
+		if ((iport->state == FNIC_IPORT_STATE_READY)
+			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT)
+			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+						 "Sending GPNFT in response to LOGO from Target:0x%x",
+						 nport_id);
+			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
+			return;
+		}
+	} else {
+		fdls_delete_tport(iport, tport);
+	}
+	if (iport->state == FNIC_IPORT_STATE_READY) {
+		fdls_send_logo_resp(iport, &logo->fchdr);
+		if ((fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT) &&
+			(fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+						 "Sending GPNFT in response to LOGO from Target:0x%x",
+						 nport_id);
+			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
+		}
+	}
+}
+
+static void
+fdls_process_rscn(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
+{
+	struct fc_rscn_hdr_s *rscn;
+	struct fc_rscn_port_s *rscn_port = NULL;
+	int num_ports;
+	struct fnic_tport_s *tport, *next;
+	uint32_t nport_id;
+	uint8_t fcid[3];
+	int newports = 0;
+	struct fnic_fdls_fabric_s *fdls = &iport->fabric;
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS process RSCN %p", iport);
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "FDLS RSCN received in state(%d). Dropping",
+					 fdls_get_state(fdls));
+		return;
+	}
+
+	rscn = (struct fc_rscn_hdr_s *) fchdr;
+	/* frame validation */
+	if ((rscn->payload_len % 4 != 0) || (rscn->payload_len < 8)
+		|| (rscn->payload_len > 1024) || (rscn->page_len != 4)) {
+		num_ports = 0;
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "RSCN payload_len: 0x%x page_len: 0x%x",
+					 rscn->payload_len, rscn->page_len);
+		/* if this happens then we need to send ADISC to all the tports. */
+		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+			if (tport->state == FDLS_TGT_STATE_READY)
+				tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "RSCN for port id: 0x%x", tport->fcid);
+		}
+	} else {
+		num_ports = (rscn->payload_len - 4) / rscn->page_len;
+		rscn_port = (struct fc_rscn_port_s *) (rscn + 1);
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "RSCN received for num_ports: %d payload_len: %d page_len: %d ",
+			 num_ports, rscn->payload_len, rscn->page_len);
+
+	/*
+	 * RSCN have at least one Port_ID page , but may not have any port_id
+	 * in it. If no port_id is specified in the Port_ID page , we send
+	 * ADISC to all the tports
+	 */
+
+	while (num_ports) {
+
+		memcpy(fcid, rscn_port->port_id, 3);
+
+		nport_id = ntoh24(fcid);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "RSCN event: 0x%x for 0x%x", rscn_port->rscn_evt_q,
+					 nport_id);
+		rscn_port++;
+		num_ports--;
+		/* if this happens then we need to send ADISC to all the tports. */
+		if (nport_id == 0) {
+			list_for_each_entry_safe(tport, next, &iport->tport_list,
+									 links) {
+				if (tport->state == FDLS_TGT_STATE_READY)
+					tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
+
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+							 "RSCN for port id: 0x%x", tport->fcid);
+			}
+			break;
+		}
+		tport = fnic_find_tport_by_fcid(iport, nport_id);
+
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "RSCN port id list: 0x%x", nport_id);
+
+		if (!tport) {
+			newports++;
+			continue;
+		}
+		if (tport->state == FDLS_TGT_STATE_READY)
+			tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS process RSCN sending GPN_FT %p", iport);
+	fdls_send_gpn_ft(iport, FDLS_STATE_RSCN_GPN_FT);
+	fdls_send_rscn_resp(iport, fchdr);
+}
+
+static void
+fdls_process_adisc_req(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
+{
+	struct fc_els_adisc_ls_acc_s adisc_acc;
+	struct fc_els_adisc_s *adisc_req = (struct fc_els_adisc_s *) fchdr;
+	uint64_t frame_wwnn;
+	uint64_t frame_wwpn;
+	uint32_t tgt_fcid;
+	struct fnic_tport_s *tport;
+	uint8_t *fcid;
+	struct fc_els_reject_s rjts_rsp;
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process ADISC request %d", iport->fnic->fnic_num);
+
+	fcid = FNIC_GET_S_ID(fchdr);
+	tgt_fcid = ntoh24(fcid);
+	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
+	if (!tport) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "tport for fcid: 0x%x not found. Dropping ADISC req.",
+					 tgt_fcid);
+		return;
+	}
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			 "Dropping ADISC req from fcid: 0x%x in iport state: %d",
+			 tgt_fcid, iport->state);
+		return;
+	}
+
+	frame_wwnn = ntohll(adisc_req->node_name);
+	frame_wwpn = ntohll(adisc_req->nport_name);
+
+	if ((frame_wwnn != tport->wwnn) || (frame_wwpn != tport->wwpn)) {
+		/* send reject */
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			 "ADISC req from fcid: 0x%x mismatch wwpn: 0x%llx wwnn: 0x%llx",
+			 tgt_fcid, frame_wwpn, frame_wwnn);
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			 "local tport wwpn: 0x%llx wwnn: 0x%llx. Sending RJT",
+			 tport->wwpn, tport->wwnn);
+
+		memcpy(&rjts_rsp, &fnic_els_rjt, sizeof(struct fc_els_reject_s));
+
+		rjts_rsp.reason_code = 0x03;	/*  logical error */
+		rjts_rsp.reason_expl = 0x1E;	/*  N_port login required */
+		rjts_rsp.vendor_specific = 0x0;
+		FNIC_SET_S_ID((&rjts_rsp.fchdr), fchdr->did);
+		FNIC_SET_D_ID((&rjts_rsp.fchdr), fchdr->sid);
+		oxid = FNIC_GET_OX_ID(fchdr);
+		FNIC_SET_OX_ID((&rjts_rsp.fchdr), oxid);
+		FNIC_SET_RX_ID((&rjts_rsp.fchdr), FNIC_ADISC_RESP_OXID);
+		fnic_send_fcoe_frame(iport, &rjts_rsp,
+							 sizeof(struct fc_els_reject_s));
+		return;
+	}
+	memset(&adisc_acc.fchdr, 0, sizeof(struct fc_hdr_s));
+	FNIC_SET_S_ID((&adisc_acc.fchdr), fchdr->did);
+	FNIC_SET_D_ID((&adisc_acc.fchdr), fchdr->sid);
+	adisc_acc.fchdr.f_ctl = FNIC_ELS_REP_FCTL;
+	adisc_acc.fchdr.r_ctl = 0x23;
+	adisc_acc.fchdr.type = 0x01;
+	oxid = FNIC_GET_OX_ID(fchdr);
+	FNIC_SET_OX_ID((&adisc_acc.fchdr), oxid);
+	FNIC_SET_RX_ID((&adisc_acc.fchdr), FNIC_ADISC_RESP_OXID);
+	adisc_acc.command = ELS_LS_ACC;
+
+	FNIC_SET_NPORT_NAME(adisc_acc, iport->wwpn);
+	FNIC_SET_NODE_NAME(adisc_acc, iport->wwnn);
+	memcpy(adisc_acc.fcid, fchdr->did, 3);
+	fnic_send_fcoe_frame(iport, &adisc_acc,
+			 sizeof(struct fc_els_adisc_ls_acc_s));
+}
+
 /*
  * Performs a validation for all FCOE frames and return the frame type
  */
@@ -2914,6 +3449,31 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 		} else
 			fdls_process_tgt_abts_rsp(iport, fchdr);
 		break;
+	case FNIC_BLS_ABTS_REQ:
+		fdls_process_abts_req(iport, fchdr);
+		break;
+	case FNIC_ELS_UNSUPPORTED_REQ:
+		fdls_process_unsupported_els_req(iport, fchdr);
+		break;
+	case FNIC_ELS_PLOGI_REQ:
+		fdls_process_plogi_req(iport, fchdr);
+		break;
+	case FNIC_ELS_RSCN_REQ:
+		fdls_process_rscn(iport, fchdr);
+		break;
+	case FNIC_ELS_LOGO_REQ:
+		fdls_process_logo_req(iport, fchdr);
+		break;
+	case FNIC_ELS_RRQ:
+	case FNIC_ELS_ECHO_REQ:
+		fdls_process_els_req(iport, fchdr, len);
+		break;
+	case FNIC_ELS_ADISC:
+		fdls_process_adisc_req(iport, fchdr);
+		break;
+	case FNIC_ELS_RLS:
+		fdls_process_rls_req(iport, fchdr);
+		break;
 	default:
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 			 "Received unknown FCoE frame of len: %d. Dropping frame", len);
-- 
2.31.1

