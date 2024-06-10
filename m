Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A3212F5B6;
	Mon, 10 Jun 2024 21:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718056443; cv=none; b=TPCZbcqaQgVCdQsbtKK2XYvanG0VxjJoKuo+PLz3dGRyfIAIB6+2w/ASGDMiuXwudTF2YecHz5oPWLK3V1r8zk1MZQsOnwS27RidC7WPLCNCmeuqpTTw2zibATDpRJOFhP1Wu5+gapvKqSOy5ustAiBk4Eti9tchTXA06FCtXME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718056443; c=relaxed/simple;
	bh=lFuDAofhdQYkJ+J13EPMV4bJAv+em9ypCa9aLeq9Sag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i7DfPPHUAyWcD07OwdT+EB+WhmTAlEGXpw/tqsJavt/+/EUiwEJS+Uxtv4owYEnF+i99PiQBgB+7VnXJlFU2HtMW6v+Taq3Z8szCEgfzIvyomQlm4BCusaTDvFATiJUPtyVXIYd43pCTgIhiFJ7+JKFdt8W1/unS5wRV/she0Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=SONdn+74; arc=none smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="SONdn+74"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=57124; q=dns/txt;
  s=iport; t=1718056439; x=1719266039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mTHoJ6uhUib+LmJtF0YjqK9CIj4w7S9XzEhaTc2iHr0=;
  b=SONdn+74QZth0q26CPMmPnzC9MfRK4rLvDHyJon9oN8qGBxTXcwvbOnp
   emdzTvvi3Nfo1dl8ryqU6LtLw5LZAzmymHPRbGA9DV63xIUhvFdqvrdcC
   04m1gptCAqP3HOY1+SNuwNKAHarlv6JnW4mBFMMfunVvtmUdcESp6b/QR
   Q=;
X-CSE-ConnectionGUID: 3uPt4y4CTiOpW9tKyX98TQ==
X-CSE-MsgGUID: rYh4OE7cT86z1lI55TZRVA==
X-IronPort-AV: E=Sophos;i="6.08,227,1712620800"; 
   d="scan'208";a="294296209"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by alln-iport-4.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 21:52:50 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPSA id 45ALpBCS012699
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 10 Jun 2024 21:52:50 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 04/14] scsi: fnic: Add support for target based solicited requests and responses
Date: Mon, 10 Jun 2024 14:50:50 -0700
Message-Id: <20240610215100.673158-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240610215100.673158-1-kartilak@cisco.com>
References: <20240610215100.673158-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.193.101.253, [10.193.101.253]
X-Outbound-Node: alln-core-4.cisco.com

Add support for target based solicited requests and responses.
Add support for tport definitions and processing.
Add support for restarting the IT nexus.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 1540 +++++++++++++++++++++++++++++++--
 drivers/scsi/fnic/fnic.h      |    6 +
 drivers/scsi/fnic/fnic_fdls.h |    4 +
 3 files changed, 1473 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 22a2d0c1c78f..d920202d413d 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -11,6 +11,8 @@
 #include <scsi/fc/fc_fcp.h>
 #include <linux/utsname.h>
 
+#define FC_FC4_TYPE_SCSI 0x08
+
 static void fdls_send_rpn_id(struct fnic_iport_s *iport);
 
 /* Frame initialization */
@@ -59,6 +61,19 @@ struct fc_rpn_id_s fnic_rpn_id_req = {
 				  .command = FC_CT_RPN_CMD}
 };
 
+/*
+ * Variables:
+ * did, sid, oxid
+ */
+struct fc_els_prli_s fnic_prli_req = {
+	.fchdr = {.r_ctl = 0x22, .type = 0x01,
+			  .f_ctl = FNIC_ELS_REQ_FCTL, .rx_id = 0xFFFF},
+	.command = FC_ELS_PRLI_REQ,
+	.page_len = 16,
+	.payload_len = 0x1400,
+	.sp = {.type = 0x08, .flags = 0x0020, .csp = 0xA2000000}
+};
+
 /*
  * Variables:
  * fh_s_id, port_id, port_name
@@ -123,11 +138,51 @@ struct fc_logo_req_s fnic_logo_req = {
 #define RETRIES_EXHAUSTED(iport)      \
 	(iport->fabric.retry_counter == FABRIC_LOGO_MAX_RETRY)
 
+#define FNIC_TPORT_MAX_NEXUS_RESTART (8)
+
+/* Private Functions */
 static void fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 		   struct fc_hdr_s *fchdr, void *rx_frame);
 static void fnic_fdls_start_plogi(struct fnic_iport_s *iport);
+static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
+									  uint32_t fcid,
+									  uint64_t wwpn);
+static void fdls_target_restart_nexus(struct fnic_tport_s *tport);
+static void fdls_start_tport_timer(struct fnic_iport_s *iport,
+					struct fnic_tport_s *tport, int timeout);
+
 static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
 			int timeout);
+static void fdls_tport_timer_callback(struct timer_list *t);
+
+static uint16_t fdls_alloc_tgt_oxid(struct fnic_iport_s *iport,
+									uint16_t base)
+{
+	int i;
+	int start, end;
+
+	start = base - FDLS_PLOGI_OXID_BASE;
+	end = start + FDLS_TGT_OXID_BLOCK_SZ;
+
+	for (i = start; i < end; i++) {
+		if (iport->tgt_oxid_pool[i] == 0) {
+			iport->tgt_oxid_pool[i] = 1;
+			return (i + FDLS_PLOGI_OXID_BASE);
+		}
+	}
+	return 0xFFFF;
+}
+
+static void fdls_free_tgt_oxid(struct fnic_iport_s *iport, uint16_t oxid)
+{
+	struct fnic *fnic = iport->fnic;
+
+	if (iport->tgt_oxid_pool[oxid - FDLS_PLOGI_OXID_BASE] != 1) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Freeing unused OXID: 0x%x", oxid);
+	}
+	iport->tgt_oxid_pool[oxid - FDLS_PLOGI_OXID_BASE] = 0;
+}
 
 static void
 fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
@@ -153,6 +208,63 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
 				 "fabric timer is %d ", timeout);
 }
 
+static void
+fdls_start_tport_timer(struct fnic_iport_s *iport,
+					   struct fnic_tport_s *tport, int timeout)
+{
+	u64 fabric_tov;
+	struct fnic *fnic = iport->fnic;
+
+	if (tport->timer_pending) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "tport fcid 0x%x: Canceling disc timer\n",
+					 tport->fcid);
+		fnic_del_tport_timer_sync();
+		tport->timer_pending = 0;
+	}
+
+	if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED))
+		tport->retry_counter++;
+
+	fabric_tov = jiffies + msecs_to_jiffies(timeout);
+	mod_timer(&tport->retry_timer, round_jiffies(fabric_tov));
+	tport->timer_pending = 1;
+}
+
+void
+fdls_send_tport_abts(struct fnic_iport_s *iport,
+					 struct fnic_tport_s *tport)
+{
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	struct fnic *fnic = iport->fnic;
+
+	struct fc_hdr_s fc_abts_s = {
+		.r_ctl = 0x81,			/* ABTS */
+		.cs_ctl = 0x00, .type = 0x00, .f_ctl = FNIC_REQ_ABTS_FCTL, .seq_id =
+			0x00, .df_ctl = 0x00, .seq_cnt = 0x0000, .rx_id = 0xFFFF,
+		.param = 0x00000000,	/* bit:0 = 0 Abort a exchange */
+	};
+
+	struct fc_hdr_s *pfc_abts = &fc_abts_s;
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+	FNIC_SET_S_ID(pfc_abts, s_id);
+	FNIC_SET_D_ID(pfc_abts, d_id);
+	tport->flags |= FNIC_FDLS_TGT_ABORT_ISSUED;
+
+	fc_abts_s.ox_id = tport->oxid_used;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS sending tport abts: tport->state: %d ",
+				 tport->state);
+
+	fnic_send_fcoe_frame(iport, &fc_abts_s, sizeof(struct fc_hdr_s));
+	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
+	fdls_start_tport_timer(iport, tport, 2 * iport->r_a_tov);
+}
+
 static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
 {
 	uint8_t fcid[3];
@@ -338,6 +450,169 @@ static void fdls_send_gpn_ft(struct fnic_iport_s *iport, int fdls_state)
 	fdls_set_state((&iport->fabric), fdls_state);
 }
 
+static void
+fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
+{
+	struct fc_els_adisc_s adisc;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+
+	memset(&adisc, 0, sizeof(struct fc_els_adisc_s));
+	adisc.fchdr.r_ctl = 0x22;
+	adisc.fchdr.type = 0x01;
+	adisc.fchdr.f_ctl = FNIC_ELS_REQ_FCTL;
+	adisc.fchdr.rx_id = 0xFFFF;
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+	FNIC_SET_S_ID((&adisc.fchdr), s_id);
+	FNIC_SET_D_ID((&adisc.fchdr), d_id);
+
+	oxid = htons(fdls_alloc_tgt_oxid(iport, FDLS_ADISC_OXID_BASE));
+	if (oxid == 0xFFFF) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Failed to allocate OXID to send ADISC %p", iport);
+		return;
+	}
+
+	tport->oxid_used = oxid;
+	tport->flags &= ~FNIC_FDLS_TGT_ABORT_ISSUED;
+
+	FNIC_SET_OX_ID((&adisc.fchdr), oxid);
+	FNIC_SET_NPORT_NAME(adisc, iport->wwpn);
+	FNIC_SET_NODE_NAME(adisc, iport->wwnn);
+
+	memcpy(adisc.fcid, s_id, 3);
+	adisc.command = FNIC_ELS_ADISC_REQ;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "sending ADISC to tgt fcid: 0x%x", tport->fcid);
+
+	fnic_send_fcoe_frame(iport, &adisc, sizeof(struct fc_els_adisc_s));
+	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
+	fdls_start_tport_timer(iport, tport, 2 * iport->e_d_tov);
+}
+
+void fdls_delete_tport(struct fnic_iport_s *iport,
+					   struct fnic_tport_s *tport)
+{
+	struct fnic_tport_event_s *tport_del_evt;
+	struct fnic *fnic = iport->fnic;
+
+	if ((tport->state == FDLS_TGT_STATE_OFFLINING)
+		|| (tport->state == FDLS_TGT_STATE_OFFLINE))
+		return;
+
+	fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINING);
+	/*
+	 * By setting this flag, the tport will not be seen in a look-up
+	 * in an RSCN. Even if we move to multithreaded model, this tport
+	 * will be destroyed and a new RSCN will have to create a new one
+	 */
+	tport->flags |= FNIC_FDLS_TPORT_TERMINATING;
+
+	if (tport->timer_pending) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "tport fcid 0x%x: Canceling disc timer\n",
+					 tport->fcid);
+		fnic_del_tport_timer_sync();
+		tport->timer_pending = 0;
+	}
+
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		fnic_rport_exch_reset(iport->fnic, tport->fcid);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+
+		if (tport->flags & FNIC_FDLS_SCSI_REGISTERED) {
+			tport_del_evt =
+				kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
+			if (!tport_del_evt) {
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Failed to allocate memory for tport fcid: 0x%0x\n",
+					 tport->fcid);
+				return;
+			}
+			tport_del_evt->event = TGT_EV_RPORT_DEL;
+			tport_del_evt->arg1 = (void *) tport;
+			list_add_tail(&tport_del_evt->links, &fnic->tport_event_list);
+			queue_work(fnic_event_queue, &fnic->tport_work);
+		} else {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "tport 0x%x not reg with scsi_transport. Freeing locally",
+				 tport->fcid);
+			list_del(&tport->links);
+			kfree(tport);
+		}
+	}
+}
+
+static void
+fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
+{
+	struct fc_els_s plogi;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+	uint32_t timeout;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Send tgt PLOGI to fcid: 0x%x", tport->fcid);
+
+	memcpy(&plogi, &fnic_plogi_req, sizeof(struct fc_els_s));
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+
+	FNIC_SET_S_ID((&plogi.fchdr), s_id);
+	FNIC_SET_D_ID((&plogi.fchdr), d_id);
+	FNIC_SET_RDF_SIZE(plogi.u.csp_plogi, iport->max_payload_size);
+
+	oxid = htons(fdls_alloc_tgt_oxid(iport, FDLS_PLOGI_OXID_BASE));
+	if (oxid == 0xFFFF) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: Failed to allocate oxid to send PLOGI to fcid: 0x%x",
+				 iport->fcid, tport->fcid);
+		return;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "send tgt PLOGI: tgt fcid: 0x%x oxid: 0x%x", tport->fcid,
+				 ntohs(oxid));
+	tport->oxid_used = oxid;
+	tport->flags &= ~FNIC_FDLS_TGT_ABORT_ISSUED;
+
+	FNIC_SET_OX_ID((&plogi.fchdr), oxid);
+	FNIC_SET_NPORT_NAME(plogi, iport->wwpn);
+	FNIC_SET_NODE_NAME(plogi, iport->wwnn);
+
+	timeout = max(2 * iport->e_d_tov, iport->plogi_timeout);
+
+	fnic_send_fcoe_frame(iport, &plogi, sizeof(struct fc_els_s));
+	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
+	fdls_start_tport_timer(iport, tport, timeout);
+}
+
+static uint16_t
+fnic_fc_plogi_rsp_rdf(struct fnic_iport_s *iport,
+					  struct fc_els_s *plogi_rsp)
+{
+	uint16_t b2b_rdf_size = ntohs(plogi_rsp->u.csp_plogi.b2b_rdf_size);
+	uint16_t spc3_rdf_size =
+		((uint16_t) (plogi_rsp->spc3[6] << 8 | plogi_rsp->spc3[7]) &
+		 FNIC_FC_C3_RDF);
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "MFS: b2b_rdf_size: 0x%x spc3_rdf_size: 0x%x",
+			 b2b_rdf_size, spc3_rdf_size);
+
+	return MIN(b2b_rdf_size, spc3_rdf_size);
+}
+
 static void fdls_send_register_fc4_types(struct fnic_iport_s *iport)
 {
 	struct fc_rft_id rft_id;
@@ -387,6 +662,47 @@ static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
 	fdls_start_fabric_timer(iport, 2 * iport->e_d_tov);
 }
 
+static void
+fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
+{
+	struct fc_els_prli_s prli;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+	uint32_t timeout;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS sending PRLI to tgt: 0x%x", tport->fcid);
+
+	oxid = htons(fdls_alloc_tgt_oxid(iport, FDLS_PRLI_OXID_BASE));
+	if (oxid == 0xFFFF) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Failed to allocate OXID to send PRLI %p", iport);
+		return;
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS sending PRLI to tgt: 0x%x OXID: 0x%x", tport->fcid,
+				 ntohs(oxid));
+
+	tport->oxid_used = oxid;
+	tport->flags &= ~FNIC_FDLS_TGT_ABORT_ISSUED;
+	memcpy(&prli, &fnic_prli_req, sizeof(struct fc_els_prli_s));
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+
+	FNIC_SET_S_ID((&prli.fchdr), s_id);
+	FNIC_SET_D_ID((&prli.fchdr), d_id);
+	FNIC_SET_OX_ID((&prli.fchdr), oxid);
+
+	timeout = max(2 * iport->e_d_tov, iport->plogi_timeout);
+
+	fnic_send_fcoe_frame(iport, &prli, sizeof(struct fc_els_prli_s));
+	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
+	fdls_start_tport_timer(iport, tport, timeout);
+}
+
 /***********************************************************************
  * fdls_send_fabric_logo
  *
@@ -434,6 +750,208 @@ void fdls_send_fabric_logo(struct fnic_iport_s *iport)
 	fnic_send_fcoe_frame(iport, &logo, sizeof(struct fc_logo_req_s));
 }
 
+/***********************************************************************
+ * fdls_tgt_logout
+ *
+ * \brief Send plogo to the remote port
+ *
+ * \param[in]  iport   Handle to fnic iport. remote port
+ *
+ * \retval void
+ *
+ * \note This function does not change or check the fabric/tport state.
+ *       It the caller responsibility to set the appropriate tport/fabric
+ *       state when this is called. Normall fdls_tgt_state_plogo.
+ *       fdls_set_tport_state(tport, fdls_tgt_state_plogo)
+ *
+ *\note This could be used to send plogo to nameserver process
+ *       also not just target processes
+ *
+ ***********************************************************************/
+void fdls_tgt_logout(struct fnic_iport_s *iport,
+					 struct fnic_tport_s *tport)
+{
+	struct fc_logo_req_s logo;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Sending logo to tport fcid: 0x%x", tport->fcid);
+	memcpy(&logo, &fnic_logo_req, sizeof(struct fc_logo_req_s));
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+
+	FNIC_SET_S_ID((&logo.fchdr), s_id);
+	FNIC_SET_D_ID((&logo.fchdr), d_id);
+	FNIC_SET_OX_ID((&logo.fchdr), FNIC_TLOGO_REQ_OXID);
+
+	memcpy(&logo.fcid, s_id, 3);
+	logo.wwpn = htonll(iport->wwpn);
+
+	fnic_send_fcoe_frame(iport, &logo, sizeof(struct fc_logo_req_s));
+}
+
+static void fdls_tgt_discovery_start(struct fnic_iport_s *iport)
+{
+	struct fnic_tport_s *tport, *next;
+	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: Starting FDLS target discovery", iport->fcid);
+
+	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+		if ((old_link_down_cnt != iport->fnic->link_down_cnt)
+			|| (iport->state != FNIC_IPORT_STATE_READY)) {
+			break;
+		}
+		/* if we marked the tport as deleted due to GPN_FT
+		 * We should not send ADISC anymore
+		 */
+		if ((tport->state == FDLS_TGT_STATE_OFFLINING) ||
+			(tport->state == FDLS_TGT_STATE_OFFLINE))
+			continue;
+
+		/* For tports which have received RSCN */
+		if (tport->flags & FNIC_FDLS_TPORT_SEND_ADISC) {
+			tport->retry_counter = 0;
+			fdls_set_tport_state(tport, FDLS_TGT_STATE_ADISC);
+			tport->flags &= ~FNIC_FDLS_TPORT_SEND_ADISC;
+			fdls_send_tgt_adisc(iport, tport);
+			continue;
+		}
+		if (fdls_get_tport_state(tport) != FDLS_TGT_STATE_INIT) {
+			/* Not a new port, skip  */
+			continue;
+		}
+		tport->retry_counter = 0;
+		fdls_set_tport_state(tport, FDLS_TGT_STATE_PLOGI);
+		fdls_send_tgt_plogi(iport, tport);
+	}
+	fdls_set_state((&iport->fabric), FDLS_STATE_TGT_DISCOVERY);
+}
+
+/*
+ * Function to restart the IT nexus if we received any out of
+ * sequence PLOGI/PRLI  response from the target.
+ * The memory for the new tport structure is allocated
+ * inside fdls_create_tport and added to the iport's tport list.
+ * This will get freed later during tport_offline/linkdown
+ * or module unload. The new_tport pointer will go out of scope
+ * safely since the memory it is
+ * pointing to it will be freed later
+ */
+static void fdls_target_restart_nexus(struct fnic_tport_s *tport)
+{
+	struct fnic_iport_s *iport = tport->iport;
+	struct fnic_tport_s *new_tport = NULL;
+	uint32_t fcid;
+	uint64_t wwpn;
+	int nexus_restart_count;
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "tport fcid: 0x%x state: %d restart_count: %d",
+				 tport->fcid, tport->state, tport->nexus_restart_count);
+
+	fcid = tport->fcid;
+	wwpn = tport->wwpn;
+	nexus_restart_count = tport->nexus_restart_count;
+
+	fdls_delete_tport(iport, tport);
+
+	if (nexus_restart_count >= FNIC_TPORT_MAX_NEXUS_RESTART) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Exceeded nexus restart retries tport: 0x%x", fcid);
+		return;
+	}
+
+	/*
+	 * Allocate memory for the new tport and add it to
+	 * iport's tport list.
+	 * This memory will be freed during tport_offline/linkdown
+	 * or module unload. The pointer new_tport is safe to go
+	 * out of scope when this function returns, since the memory
+	 * it is pointing to is guaranteed to be freed later
+	 * as mentioned above.
+	 */
+	new_tport = fdls_create_tport(iport, fcid, wwpn);
+	if (!new_tport) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Error creating new tport: 0x%x", fcid);
+		return;
+	}
+
+	new_tport->nexus_restart_count = nexus_restart_count + 1;
+	fdls_send_tgt_plogi(iport, new_tport);
+	fdls_set_tport_state(new_tport, FDLS_TGT_STATE_PLOGI);
+}
+
+struct fnic_tport_s *fnic_find_tport_by_fcid(struct fnic_iport_s *iport,
+									 uint32_t fcid)
+{
+	struct fnic_tport_s *tport, *next;
+
+	list_for_each_entry_safe(tport, next, &(iport->tport_list), links) {
+		if ((tport->fcid == fcid)
+			&& !(tport->flags & FNIC_FDLS_TPORT_TERMINATING))
+			return tport;
+	}
+	return NULL;
+}
+
+static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
+								  uint32_t fcid, uint64_t wwpn)
+{
+	struct fnic_tport_s *tport;
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "FDLS create tport: fcid: 0x%x wwpn: 0x%llx", fcid, wwpn);
+
+	tport = kzalloc(sizeof(struct fnic_tport_s), GFP_ATOMIC);
+	if (!tport) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Memory allocation failure while creating tport: 0x%x\n",
+			 fcid);
+		return NULL;
+	}
+
+	tport->max_payload_size = FNIC_FCOE_MAX_FRAME_SZ;
+	tport->r_a_tov = FNIC_R_A_TOV_DEF;
+	tport->e_d_tov = FNIC_E_D_TOV_DEF;
+	tport->fcid = fcid;
+	tport->wwpn = wwpn;
+	tport->iport = iport;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Need to setup tport timer callback");
+
+	timer_setup(&tport->retry_timer, fdls_tport_timer_callback, 0);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Added tport 0x%x", tport->fcid);
+	fdls_set_tport_state(tport, FDLS_TGT_STATE_INIT);
+	list_add_tail(&tport->links, &iport->tport_list);
+	atomic_set(&tport->in_flight, 0);
+	return tport;
+}
+
+struct fnic_tport_s *fnic_find_tport_by_wwpn(struct fnic_iport_s *iport,
+									 uint64_t wwpn)
+{
+	struct fnic_tport_s *tport, *next;
+
+	list_for_each_entry_safe(tport, next, &(iport->tport_list), links) {
+		if ((tport->wwpn == wwpn)
+			&& !(tport->flags & FNIC_FDLS_TPORT_TERMINATING))
+			return tport;
+	}
+	return NULL;
+}
+
 void fdls_fabric_timer_callback(struct timer_list *t)
 {
 	struct fnic_fdls_fabric_s *fabric = from_timer(fabric, t, retry_timer);
@@ -548,98 +1066,614 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 		else {
 			/* ABTS has timed out (2*ra_tov), we give up */
 			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-						 "ABTS timed out. Starting PLOGI: %p", iport);
-			fnic_fdls_start_plogi(iport);
+						 "ABTS timed out. Starting PLOGI: %p", iport);
+			fnic_fdls_start_plogi(iport);
+		}
+		break;
+	case FDLS_STATE_REGISTER_FC4_TYPES:
+		/* scr received a LS_RJT with busy we retry from here */
+		if ((iport->fabric.flags & FNIC_FDLS_RETRY_FRAME)
+			&& (iport->fabric.retry_counter < FDLS_RETRY_COUNT)) {
+			iport->fabric.flags &= ~FNIC_FDLS_RETRY_FRAME;
+			fdls_send_register_fc4_types(iport);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			return;
+		}
+		/* RFT_ID timed out send abts */
+		if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
+			fdls_send_fabric_abts(iport);
+		} else {
+			/* ABTS has timed out (2*ra_tov), we give up */
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "ABTS timed out. Starting PLOGI: %p", iport);
+			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
+		}
+		break;
+	case FDLS_STATE_REGISTER_FC4_FEATURES:
+		/* scr received a LS_RJT with busy we retry from here */
+		if ((iport->fabric.flags & FNIC_FDLS_RETRY_FRAME)
+			&& (iport->fabric.retry_counter < FDLS_RETRY_COUNT)) {
+			iport->fabric.flags &= ~FNIC_FDLS_RETRY_FRAME;
+			fdls_send_register_fc4_features(iport);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			return;
+		}
+		/* scr have timed out send abts */
+		if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED))
+			fdls_send_fabric_abts(iport);
+		else {
+			/* ABTS has timed out (2*ra_tov), we give up */
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "ABTS timed out. Starting PLOGI %p", iport);
+			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
+		}
+		break;
+	case FDLS_STATE_RSCN_GPN_FT:
+	case FDLS_STATE_SEND_GPNFT:
+	case FDLS_STATE_GPN_FT:
+		/* GPN_FT received a LS_RJT with busy we retry from here */
+		if ((iport->fabric.flags & FNIC_FDLS_RETRY_FRAME)
+			&& (iport->fabric.retry_counter < FDLS_RETRY_COUNT)) {
+			iport->fabric.flags &= ~FNIC_FDLS_RETRY_FRAME;
+			fdls_send_gpn_ft(iport, iport->fabric.state);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			return;
+		}
+		/* gpn_gt have timed out send abts */
+		if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
+			fdls_send_fabric_abts(iport);
+		} else {
+			/*
+			 * ABTS has timed out have waited (2*ra_tov) can
+			 * retry safely with same exchange id
+			 */
+			if (iport->fabric.retry_counter < FDLS_RETRY_COUNT) {
+				fdls_send_gpn_ft(iport, iport->fabric.state);
+			} else {
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "ABTS timeout for fabric GPN_FT. Check name server: %p",
+					 iport);
+			}
+		}
+		break;
+	default:
+		break;
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+}
+
+static void fdls_send_delete_tport_msg(struct fnic_tport_s *tport)
+{
+	struct fnic_iport_s *iport = (struct fnic_iport_s *) tport->iport;
+	struct fnic *fnic = iport->fnic;
+	struct fnic_tport_event_s *tport_del_evt;
+
+	if (!IS_FNIC_FCP_INITIATOR(fnic))
+		return;
+
+	tport_del_evt = kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
+	if (!tport_del_evt) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Failed to allocate memory for tport event fcid: 0x%x",
+			 tport->fcid);
+		return;
+	}
+	tport_del_evt->event = TGT_EV_TPORT_DELETE;
+	tport_del_evt->arg1 = (void *) tport;
+	list_add_tail(&tport_del_evt->links, &fnic->tport_event_list);
+	queue_work(fnic_event_queue, &fnic->tport_work);
+}
+
+static void fdls_tport_timer_callback(struct timer_list *t)
+{
+	struct fnic_tport_s *tport = from_timer(tport, t, retry_timer);
+	struct fnic_iport_s *iport = (struct fnic_iport_s *) tport->iport;
+	struct fnic *fnic = iport->fnic;
+	uint16_t oxid;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (!tport->timer_pending) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return;
+	}
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return;
+	}
+
+	if (tport->del_timer_inprogress) {
+		tport->del_timer_inprogress = 0;
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "tport_del_timer inprogress. Skip timer cb tport fcid: 0x%x\n",
+			 tport->fcid);
+		return;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		 "tport fcid: 0x%x timer pending: %d state: %d retry counter: %d",
+		 tport->fcid, tport->timer_pending, tport->state,
+		 tport->retry_counter);
+
+	tport->timer_pending = 0;
+	oxid = ntohs(tport->oxid_used);
+
+	/* We retry plogi/prli/adisc frames depending on the tport state */
+	switch (tport->state) {
+	case FDLS_TGT_STATE_PLOGI:
+		/* PLOGI frame received a LS_RJT with busy, we retry from here */
+		if ((tport->flags & FNIC_FDLS_RETRY_FRAME)
+			&& (tport->retry_counter < iport->max_plogi_retries)) {
+			fdls_free_tgt_oxid(iport, oxid);
+			tport->flags &= ~FNIC_FDLS_RETRY_FRAME;
+			fdls_send_tgt_plogi(iport, tport);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			return;
+		}
+		/* Plogi frame has timed out 2*ed_tov send abts */
+		if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
+			fdls_send_tport_abts(iport, tport);
+		} else if (tport->retry_counter < iport->max_plogi_retries) {
+			/*
+			 * ABTS has timed out have waited (2*ra_tov)
+			 * can retry safely
+			 * even if with same exchange id
+			 */
+			fdls_free_tgt_oxid(iport, oxid);
+			fdls_send_tgt_plogi(iport, tport);
+		} else {
+			/* exceeded plogi retry count */
+			fdls_free_tgt_oxid(iport, oxid);
+			fdls_send_delete_tport_msg(tport);
+		}
+		break;
+	case FDLS_TGT_STATE_PRLI:
+		/* PRLI received a LS_RJT with busy , hence we retry from here */
+		if ((tport->flags & FNIC_FDLS_RETRY_FRAME)
+			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
+			fdls_free_tgt_oxid(iport, oxid);
+			tport->flags &= ~FNIC_FDLS_RETRY_FRAME;
+			fdls_send_tgt_prli(iport, tport);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			return;
+		}
+		/* PRLI has time out 2*ed_tov send abts */
+		if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
+			fdls_send_tport_abts(iport, tport);
+		} else {
+			/* ABTS has timed out for prli, we go back to PLOGI */
+			fdls_free_tgt_oxid(iport, oxid);
+			fdls_send_tgt_plogi(iport, tport);
+			fdls_set_tport_state(tport, FDLS_TGT_STATE_PLOGI);
+		}
+		break;
+	case FDLS_TGT_STATE_ADISC:
+		/* ADISC timed out send a ABTS */
+		if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
+			fdls_send_tport_abts(iport, tport);
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			return;
+		} else if ((tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)
+				   && (tport->retry_counter < FDLS_RETRY_COUNT)) {
+			/*
+			 * ABTS has timed out have waited (2*ra_tov) can
+			 * retry safely even if with same exchange id
+			 */
+			fdls_free_tgt_oxid(iport, oxid);
+			fdls_send_tgt_adisc(iport, tport);
+
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			return;
+		}
+		/* exceeded retry count */
+		fdls_free_tgt_oxid(iport, oxid);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "ADISC not responding. Deleting target port: 0x%x",
+				 tport->fcid);
+		fdls_send_delete_tport_msg(tport);
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		return;
+	default:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Unknown tport state: 0x%x", tport->state);
+		break;
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+}
+
+static void fnic_fdls_start_flogi(struct fnic_iport_s *iport)
+{
+	iport->fabric.retry_counter = 0;
+	fdls_send_fabric_flogi(iport);
+	fdls_set_state((&iport->fabric), FDLS_STATE_FABRIC_FLOGI);
+	iport->fabric.flags = 0;
+}
+
+static void fnic_fdls_start_plogi(struct fnic_iport_s *iport)
+{
+	iport->fabric.retry_counter = 0;
+	fdls_send_fabric_plogi(iport);
+	fdls_set_state((&iport->fabric), FDLS_STATE_FABRIC_PLOGI);
+	iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
+}
+
+static void
+fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
+						   struct fc_hdr_s *fchdr)
+{
+	uint32_t tgt_fcid;
+	struct fnic_tport_s *tport;
+	uint8_t *fcid;
+	uint64_t frame_wwnn;
+	uint64_t frame_wwpn;
+	uint16_t oxid;
+	struct fc_els_adisc_ls_acc_s *adisc_rsp =
+		(struct fc_els_adisc_ls_acc_s *) fchdr;
+	struct fc_els_reject_s *els_rjt = (struct fc_els_reject_s *) fchdr;
+	struct fnic *fnic = iport->fnic;
+
+	fcid = FNIC_GET_S_ID(fchdr);
+	tgt_fcid = ntoh24(fcid);
+	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
+
+	if (!tport) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Tgt ADISC response tport not found: 0x%x", tgt_fcid);
+		return;
+	}
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		|| (tport->state != FDLS_TGT_STATE_ADISC)
+		|| (tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Dropping this ADISC response");
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "iport state: %d tport state: %d Is abort issued on PRLI? %d",
+			 iport->state, tport->state,
+			 (tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED));
+		return;
+	}
+	if (ntohs(fchdr->ox_id) != ntohs(tport->oxid_used)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Dropping frame from target: 0x%x",
+			 tgt_fcid);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Reason: Stale ADISC/Aborted ADISC/OOO frame delivery");
+		return;
+	}
+
+	switch (adisc_rsp->command) {
+	case FC_LS_ACC:
+		if (tport->timer_pending) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "tport 0x%p Canceling fabric disc timer\n",
+						 tport);
+			fnic_del_tport_timer_sync();
+		}
+		tport->timer_pending = 0;
+		tport->retry_counter = 0;
+		oxid = ntohs(fchdr->ox_id);
+		fdls_free_tgt_oxid(iport, oxid);
+		frame_wwnn = htonll(adisc_rsp->node_name);
+		frame_wwpn = htonll(adisc_rsp->nport_name);
+		if ((frame_wwnn == tport->wwnn) && (frame_wwpn == tport->wwpn)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "ADISC accepted from target: 0x%x. Target logged in",
+				 tgt_fcid);
+			fdls_set_tport_state(tport, FDLS_TGT_STATE_READY);
+		} else {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "Error mismatch frame: ADISC");
+		}
+		break;
+
+	case FC_LS_REJ:
+		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
+			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
+			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "ADISC ret FC_LS_REJ BUSY. Retry from timer routine: 0x%x",
+				 tgt_fcid);
+
+			/* Retry ADISC again from the timer routine. */
+			tport->flags |= FNIC_FDLS_RETRY_FRAME;
+		} else {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "ADISC returned FC_LS_REJ from target: 0x%x",
+						 tgt_fcid);
+			oxid = ntohs(fchdr->ox_id);
+			fdls_free_tgt_oxid(iport, oxid);
+			fdls_delete_tport(iport, tport);
+		}
+		break;
+	}
+}
+
+
+static void
+fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
+						   struct fc_hdr_s *fchdr)
+{
+	uint32_t tgt_fcid;
+	struct fnic_tport_s *tport;
+	uint8_t *fcid;
+	uint16_t oxid;
+	struct fc_els_s *plogi_rsp = (struct fc_els_s *) fchdr;
+	struct fc_els_reject_s *els_rjt = (struct fc_els_reject_s *) fchdr;
+	int max_payload_size;
+	struct fnic *fnic = iport->fnic;
+
+	fcid = FNIC_GET_S_ID(fchdr);
+	tgt_fcid = ntoh24(fcid);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS processing target PLOGI response: tgt_fcid: 0x%x",
+				 tgt_fcid);
+
+	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
+	if (!tport) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "tport not found: 0x%x", tgt_fcid);
+		return;
+	}
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		|| (tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Dropping frame! iport state: %d tport state: %d",
+					 iport->state, tport->state);
+		return;
+	}
+
+	if (tport->state != FDLS_TGT_STATE_PLOGI) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "PLOGI rsp recvd in wrong state. Restarting nexus");
+		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
+		fdls_free_tgt_oxid(iport, oxid);
+		fdls_target_restart_nexus(tport);
+		return;
+	}
+
+	if (ntohs(fchdr->ox_id) != ntohs(tport->oxid_used)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "PLOGI response from target: 0x%x. Dropping frame",
+			 tgt_fcid);
+		return;
+	}
+
+	switch (plogi_rsp->command) {
+	case FC_LS_ACC:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PLOGI accepted by target: 0x%x", tgt_fcid);
+		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
+		fdls_free_tgt_oxid(iport, oxid);
+		break;
+
+	case FC_LS_REJ:
+		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
+			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
+			&& (tport->retry_counter < iport->max_plogi_retries)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "PLOGI ret FC_LS_REJ BUSY. Retry from timer routine: 0x%x",
+				 tgt_fcid);
+			/* Retry plogi again from the timer routine. */
+			tport->flags |= FNIC_FDLS_RETRY_FRAME;
+			return;
+		}
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PLOGI returned FC_LS_REJ from target: 0x%x",
+					 tgt_fcid);
+		oxid = ntohs(fchdr->ox_id);
+		fdls_free_tgt_oxid(iport, oxid);
+		fdls_delete_tport(iport, tport);
+		return;
+
+	default:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PLOGI not accepted from target fcid: 0x%x",
+					 tgt_fcid);
+		return;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Found the PLOGI target: 0x%x and state: %d",
+				 (unsigned int) tgt_fcid, tport->state);
+
+	if (tport->timer_pending) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "tport fcid 0x%x: Canceling disc timer\n",
+					 tport->fcid);
+		fnic_del_tport_timer_sync();
+	}
+
+	tport->timer_pending = 0;
+	tport->wwpn = htonll(plogi_rsp->nport_name);
+	tport->wwnn = htonll(plogi_rsp->node_name);
+
+	/* Learn the Service Params */
+
+	/* Max frame size - choose the lowest */
+	max_payload_size = fnic_fc_plogi_rsp_rdf(iport, plogi_rsp);
+	tport->max_payload_size =
+		MIN(max_payload_size, iport->max_payload_size);
+
+	if (tport->max_payload_size < FNIC_MIN_DATA_FIELD_SIZE) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "MFS: tport max frame size below spec bounds: %d",
+			 tport->max_payload_size);
+		tport->max_payload_size = FNIC_MIN_DATA_FIELD_SIZE;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		 "MAX frame size: %d iport max_payload_size: %d tport mfs: %d",
+		 max_payload_size, iport->max_payload_size,
+		 tport->max_payload_size);
+
+	tport->max_concur_seqs = FNIC_FC_PLOGI_RSP_CONCUR_SEQ(plogi_rsp);
+
+	tport->retry_counter = 0;
+	fdls_set_tport_state(tport, FDLS_TGT_STATE_PRLI);
+	fdls_send_tgt_prli(iport, tport);
+}
+
+static void
+fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
+						  struct fc_hdr_s *fchdr)
+{
+	uint32_t tgt_fcid;
+	struct fnic_tport_s *tport;
+	uint8_t *fcid;
+	uint16_t oxid;
+	struct fc_els_prli_s *prli_rsp = (struct fc_els_prli_s *) fchdr;
+	struct fc_els_reject_s *els_rjt = (struct fc_els_reject_s *) fchdr;
+	struct fnic_tport_event_s *tport_add_evt;
+	struct fnic *fnic = iport->fnic;
+	bool mismatched_tgt = false;
+
+	fcid = FNIC_GET_S_ID(fchdr);
+	tgt_fcid = ntoh24(fcid);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS process tgt PRLI response: 0x%x", tgt_fcid);
+
+	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
+	if (!tport) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "tport not found: 0x%x", tgt_fcid);
+		/* Handle or just drop? */
+		return;
+	}
+
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		|| (tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Dropping frame! iport st: %d tport st: %d tport fcid: 0x%x",
+			 iport->state, tport->state, tport->fcid);
+		return;
+	}
+
+	if (tport->state != FDLS_TGT_STATE_PRLI) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PRLI rsp recvd in wrong state. Restarting nexus");
+		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
+		fdls_free_tgt_oxid(iport, oxid);
+		fdls_target_restart_nexus(tport);
+		return;
+	}
+
+	if (ntohs(fchdr->ox_id) != ntohs(tport->oxid_used)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Dropping PRLI response from target: 0x%x ",
+			 tgt_fcid);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Reason: Stale PRLI response/Aborted PDISC/OOO frame delivery");
+		return;
+	}
+
+	switch (prli_rsp->command) {
+	case FC_LS_ACC:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PRLI accepted from target: 0x%x", tgt_fcid);
+		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
+		fdls_free_tgt_oxid(iport, oxid);
+
+		if (prli_rsp->sp.type != FC_FC4_TYPE_SCSI) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "mismatched target zoned with FC SCSI initiator: 0x%x",
+				 tgt_fcid);
+			mismatched_tgt = true;
 		}
-		break;
-	case FDLS_STATE_REGISTER_FC4_TYPES:
-		/* scr received a LS_RJT with busy we retry from here */
-		if ((iport->fabric.flags & FNIC_FDLS_RETRY_FRAME)
-			&& (iport->fabric.retry_counter < FDLS_RETRY_COUNT)) {
-			iport->fabric.flags &= ~FNIC_FDLS_RETRY_FRAME;
-			fdls_send_register_fc4_types(iport);
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		if (mismatched_tgt) {
+			fdls_tgt_logout(iport, tport);
+			fdls_delete_tport(iport, tport);
 			return;
 		}
-		/* RFT_ID timed out send abts */
-		if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
-			fdls_send_fabric_abts(iport);
-		} else {
-			/* ABTS has timed out (2*ra_tov), we give up */
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-						 "ABTS timed out. Starting PLOGI: %p", iport);
-			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
-		}
 		break;
-	case FDLS_STATE_REGISTER_FC4_FEATURES:
-		/* scr received a LS_RJT with busy we retry from here */
-		if ((iport->fabric.flags & FNIC_FDLS_RETRY_FRAME)
-			&& (iport->fabric.retry_counter < FDLS_RETRY_COUNT)) {
-			iport->fabric.flags &= ~FNIC_FDLS_RETRY_FRAME;
-			fdls_send_register_fc4_features(iport);
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-			return;
-		}
-		/* scr have timed out send abts */
-		if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED))
-			fdls_send_fabric_abts(iport);
-		else {
-			/* ABTS has timed out (2*ra_tov), we give up */
+
+	case FC_LS_REJ:
+		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
+			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
+			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
+
 			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-						 "ABTS timed out. Starting PLOGI %p", iport);
-			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
-		}
-		break;
-	case FDLS_STATE_RSCN_GPN_FT:
-	case FDLS_STATE_SEND_GPNFT:
-	case FDLS_STATE_GPN_FT:
-		/* GPN_FT received a LS_RJT with busy we retry from here */
-		if ((iport->fabric.flags & FNIC_FDLS_RETRY_FRAME)
-			&& (iport->fabric.retry_counter < FDLS_RETRY_COUNT)) {
-			iport->fabric.flags &= ~FNIC_FDLS_RETRY_FRAME;
-			fdls_send_gpn_ft(iport, iport->fabric.state);
-			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+				 "PRLI ret FC_LS_REJ BUSY. Retry from timer routine: 0x%x",
+				 tgt_fcid);
+
+			/*Retry Plogi again from the timer routine. */
+			tport->flags |= FNIC_FDLS_RETRY_FRAME;
 			return;
-		}
-		/* gpn_gt have timed out send abts */
-		if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
-			fdls_send_fabric_abts(iport);
 		} else {
-			/*
-			 * ABTS has timed out have waited (2*ra_tov) can
-			 * retry safely with same exchange id
-			 */
-			if (iport->fabric.retry_counter < FDLS_RETRY_COUNT) {
-				fdls_send_gpn_ft(iport, iport->fabric.state);
-			} else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-					 "ABTS timeout for fabric GPN_FT. Check name server: %p",
-					 iport);
-			}
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "PRLI returned FC_LS_REJ from target: 0x%x",
+						 tgt_fcid);
+
+			oxid = ntohs(fchdr->ox_id);
+			fdls_free_tgt_oxid(iport, oxid);
+			fdls_tgt_logout(iport, tport);
+			fdls_delete_tport(iport, tport);
+			return;
 		}
 		break;
+
 	default:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PRLI not accepted from target: 0x%x", tgt_fcid);
+		return;
 		break;
 	}
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-}
 
-static void fnic_fdls_start_flogi(struct fnic_iport_s *iport)
-{
-	iport->fabric.retry_counter = 0;
-	fdls_send_fabric_flogi(iport);
-	fdls_set_state((&iport->fabric), FDLS_STATE_FABRIC_FLOGI);
-	iport->fabric.flags = 0;
-}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Found the PRLI target: 0x%x and state: %d",
+				 (unsigned int) tgt_fcid, tport->state);
 
-static void fnic_fdls_start_plogi(struct fnic_iport_s *iport)
-{
-	iport->fabric.retry_counter = 0;
-	fdls_send_fabric_plogi(iport);
-	fdls_set_state((&iport->fabric), FDLS_STATE_FABRIC_PLOGI);
-	iport->fabric.flags &= ~FNIC_FDLS_FABRIC_ABORT_ISSUED;
+	if (tport->timer_pending) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "tport fcid 0x%x: Canceling disc timer\n",
+					 tport->fcid);
+		fnic_del_tport_timer_sync();
+	}
+	tport->timer_pending = 0;
+
+	oxid = ntohs(FNIC_GET_OX_ID(fchdr));
+	fdls_free_tgt_oxid(iport, oxid);
+
+	/* Learn Service Params */
+	tport->fcp_csp = ntohl(prli_rsp->sp.csp);
+	tport->retry_counter = 0;
+
+	if (prli_rsp->sp.csp & FCP_SPPF_RETRY)
+		tport->tgt_flags |= FNIC_FC_RP_FLAGS_RETRY;
+
+	/* Check if the device plays Target Mode Function */
+	if (!(tport->fcp_csp & FCP_PRLI_FUNC_TARGET)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Remote port(0x%x): no target support. Deleting it\n",
+			 tgt_fcid);
+		fdls_tgt_logout(iport, tport);
+		fdls_delete_tport(iport, tport);
+		return;
+	}
+
+	fdls_set_tport_state(tport, FDLS_TGT_STATE_READY);
+
+	/* Inform the driver about new target added */
+	tport_add_evt = kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
+	if (!tport_add_evt) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "tport event memory allocation failure: 0x%0x\n",
+				 tport->fcid);
+		return;
+	}
+	tport_add_evt->event = TGT_EV_RPORT_ADD;
+	tport_add_evt->arg1 = (void *) tport;
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "iport fcid: 0x%x add tport event fcid: 0x%x\n",
+			 tport->fcid, iport->fcid);
+	list_add_tail(&tport_add_evt->links, &fnic->tport_event_list);
+	queue_work(fnic_event_queue, &fnic->tport_work);
 }
 
+
 static void
 fdls_process_rff_id_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 {
@@ -884,6 +1918,106 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	}
 }
 
+static void
+fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
+							 struct fc_hdr_s *fchdr, int len)
+{
+	struct fc_gpn_ft_rsp_iu_s *gpn_ft_tgt;
+	struct fc_gpn_ft_rsp_iu_s *gpn_ft_tgt_rem;
+	struct fnic_tport_s *tport, *next;
+	uint32_t fcid;
+	uint64_t wwpn;
+	int rem_len = len;
+	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
+	struct fnic *fnic = iport->fnic;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: FDLS process GPN_FT tgt list", iport->fcid);
+
+	gpn_ft_tgt =
+		(struct fc_gpn_ft_rsp_iu_s *) ((uint8_t *) fchdr +
+								   sizeof(struct fc_hdr_s)
+								   + sizeof(struct fc_ct_hdr_s));
+	gpn_ft_tgt_rem = gpn_ft_tgt;
+	len -= sizeof(struct fc_hdr_s) + sizeof(struct fc_ct_hdr_s);
+
+	while (rem_len > 0) {
+
+		fcid = ntoh24(gpn_ft_tgt->fcid);
+		wwpn = ntohll(gpn_ft_tgt->wwpn);
+
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "tport: 0x%x: ctrl:0x%x", fcid, gpn_ft_tgt->ctrl);
+
+		if (fcid == iport->fcid) {
+			if (gpn_ft_tgt->ctrl & FNIC_FC_GPN_LAST_ENTRY)
+				break;
+			gpn_ft_tgt++;
+			rem_len -= sizeof(struct fc_gpn_ft_rsp_iu_s);
+			continue;
+		}
+
+		tport = fnic_find_tport_by_wwpn(iport, wwpn);
+		if (!tport) {
+			/*
+			 * New port registered with the switch or first time query
+			 */
+			tport = fdls_create_tport(iport, fcid, wwpn);
+			if (!tport)
+				return;
+		}
+		/*
+		 * check if this was an existing tport with same fcid
+		 * but whose wwpn has changed now ,then remove it and
+		 * create a new one
+		 */
+		if (tport->fcid != fcid) {
+			fdls_delete_tport(iport, tport);
+			tport = fdls_create_tport(iport, fcid, wwpn);
+			if (!tport)
+				return;
+		}
+
+		/*
+		 * If this GPN_FT rsp is after RSCN then mark the tports which
+		 * matches with the new GPN_FT list, if some tport is not
+		 * found in GPN_FT we went to delete that tport later.
+		 */
+		if (fdls_get_state((&iport->fabric)) == FDLS_STATE_RSCN_GPN_FT)
+			tport->flags |= FNIC_FDLS_TPORT_IN_GPN_FT_LIST;
+
+		if (gpn_ft_tgt->ctrl & FNIC_FC_GPN_LAST_ENTRY)
+			break;
+
+		gpn_ft_tgt++;
+		rem_len -= sizeof(struct fc_gpn_ft_rsp_iu_s);
+	}
+	if (rem_len <= 0) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "GPN_FT response: malformed/corrupt frame rxlen: %d remlen: %d",
+			 len, rem_len);
+	}
+
+	/*remove those ports which was not listed in GPN_FT */
+	if (fdls_get_state((&iport->fabric)) == FDLS_STATE_RSCN_GPN_FT) {
+		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+
+			if (!(tport->flags & FNIC_FDLS_TPORT_IN_GPN_FT_LIST)) {
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Remove port: 0x%x not found in GPN_FT list",
+					 tport->fcid);
+				fdls_delete_tport(iport, tport);
+			} else {
+				tport->flags &= ~FNIC_FDLS_TPORT_IN_GPN_FT_LIST;
+			}
+			if ((old_link_down_cnt != iport->fnic->link_down_cnt)
+				|| (iport->state != FNIC_IPORT_STATE_READY)) {
+				return;
+			}
+		}
+	}
+}
+
 static void
 fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 						int len)
@@ -892,6 +2026,9 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 	struct fc_gpn_ft_s *gpn_ft_rsp = (struct fc_gpn_ft_s *) fchdr;
 	uint16_t rsp;
 	uint8_t reason_code;
+	int count = 0;
+	struct fnic_tport_s *tport, *next;
+	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
 	struct fnic *fnic = iport->fnic;
 
 	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
@@ -928,12 +2065,74 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 	case FC_CT_ACC:
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					 "0x%x: GPNFT_RSP accept", iport->fcid);
+		if (iport->fabric.timer_pending) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "0x%x: Canceling fabric disc timer\n",
+						 iport->fcid);
+			fnic_del_fabric_timer_sync();
+		}
+		iport->fabric.timer_pending = 0;
+		iport->fabric.retry_counter = 0;
+		fdls_process_gpn_ft_tgt_list(iport, fchdr, len);
+
+		/*
+		 * iport state can change only if link down event happened
+		 * We don't need to undo fdls_process_gpn_ft_tgt_list,
+		 * that will be taken care in next link up event
+		 */
+		if (iport->state != FNIC_IPORT_STATE_READY) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Halting target discovery: fab st: %d iport st: %d ",
+				 fdls_get_state(fdls), iport->state);
+			break;
+		}
+		fdls_tgt_discovery_start(iport);
 		break;
 
 	case FC_CT_REJ:
 		reason_code = gpn_ft_rsp->fc_ct_hdr.reason_code;
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					 "0x%x: GPNFT_RSP Reject", iport->fcid);
+
+		if (((reason_code == FC_CT_RJT_LOGICAL_BUSY)
+			 || (reason_code == FC_CT_RJT_BUSY))
+			&& (fdls->retry_counter < FDLS_RETRY_COUNT)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: GPNFT_RSP ret REJ/BSY. Retry from timer routine",
+				 iport->fcid);
+			/* Retry again from the timer routine */
+			fdls->flags |= FNIC_FDLS_RETRY_FRAME;
+		} else {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "0x%x: GPNFT_RSP reject", iport->fcid);
+			if (iport->fabric.timer_pending) {
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+							 "0x%x: Canceling fabric disc timer\n",
+							 iport->fcid);
+				fnic_del_fabric_timer_sync();
+			}
+			iport->fabric.timer_pending = 0;
+			iport->fabric.retry_counter = 0;
+			/*
+			 * If GPN_FT ls_rjt then we should delete
+			 * all existing tports
+			 */
+			count = 0;
+			list_for_each_entry_safe(tport, next, &iport->tport_list,
+									 links) {
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+							 "GPN_FT_REJECT: Remove port: 0x%x",
+							 tport->fcid);
+				fdls_delete_tport(iport, tport);
+				if ((old_link_down_cnt != iport->fnic->link_down_cnt)
+					|| (iport->state != FNIC_IPORT_STATE_READY)) {
+					return;
+				}
+				count++;
+			}
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "GPN_FT_REJECT: Removed (0x%x) ports", count);
+		}
 		break;
 
 	default:
@@ -1342,6 +2541,141 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 	}
 }
 
+static void
+fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
+						  struct fc_hdr_s *fchdr)
+{
+	uint32_t s_id;
+	struct fnic_tport_s *tport;
+	uint32_t tport_state;
+	struct fc_abts_ba_acc_s *ba_acc;
+	struct fc_abts_ba_rjt_s *ba_rjt;
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+
+	s_id = ntoh24(fchdr->sid);
+	ba_acc = (struct fc_abts_ba_acc_s *) fchdr;
+	ba_rjt = (struct fc_abts_ba_rjt_s *) fchdr;
+
+	tport = fnic_find_tport_by_fcid(iport, s_id);
+	if (!tport) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "Received tgt abts rsp with invalid SID: 0x%x", s_id);
+		return;
+	}
+
+	if (tport->timer_pending) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "tport 0x%p Canceling fabric disc timer\n", tport);
+		fnic_del_tport_timer_sync();
+	}
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "Received tgt abts rsp in iport state(%d). Dropping.",
+					 iport->state);
+		return;
+	}
+	tport->timer_pending = 0;
+	tport->flags &= ~FNIC_FDLS_TGT_ABORT_ISSUED;
+	tport_state = tport->state;
+	oxid = ntohs(fchdr->ox_id);
+
+	/*This abort rsp is for ADISC */
+	if ((oxid >= FDLS_ADISC_OXID_BASE) && (oxid < FDLS_TGT_OXID_POOL_END)) {
+		if (fchdr->r_ctl == FNIC_BA_ACC_RCTL) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+						 "Received tgt ADISC abts response BA_ACC for OX_ID: 0x%x tgt_fcid: 0x%x",
+						 ba_acc->ox_id, tport->fcid);
+		} else if (fchdr->r_ctl == FNIC_BA_RJT_RCTL) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				 "ADISC BA_RJT rcvd tport_fcid: 0x%x tport_state: %d ",
+				 tport->fcid, tport_state);
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				 "reason code: 0x%x reason code explanation:0x%x ",
+				 ba_rjt->reason_code, ba_rjt->reason_explanation);
+		}
+		if ((tport->retry_counter < FDLS_RETRY_COUNT)
+			&& (fchdr->r_ctl == FNIC_BA_ACC_RCTL)) {
+			fdls_free_tgt_oxid(iport, oxid);
+			fdls_send_tgt_adisc(iport, tport);
+			return;
+		}
+		fdls_free_tgt_oxid(iport, oxid);
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "ADISC not responding. Deleting target port: 0x%x",
+					 tport->fcid);
+		fdls_delete_tport(iport, tport);
+		if ((iport->state == FNIC_IPORT_STATE_READY)
+			&& (iport->fabric.state != FDLS_STATE_SEND_GPNFT)
+			&& (iport->fabric.state != FDLS_STATE_RSCN_GPN_FT)) {
+			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
+		}
+		/*Restart a discovery of targets */
+		return;
+	}
+
+	/*This abort rsp is for PLOGI */
+	if ((oxid >= FDLS_PLOGI_OXID_BASE) && (oxid < FDLS_PRLI_OXID_BASE)) {
+		if (fchdr->r_ctl == FNIC_BA_ACC_RCTL) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				 "Received tgt PLOGI abts response BA_ACC tgt_fcid: 0x%x",
+				 tport->fcid);
+		} else if (fchdr->r_ctl == FNIC_BA_RJT_RCTL) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "PLOGI BA_RJT received for tport_fcid: 0x%x OX_ID: 0x%x",
+				 tport->fcid, fchdr->ox_id);
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "reason code: 0x%x reason code explanation: 0x%x",
+				  ba_rjt->reason_code, ba_rjt->reason_explanation);
+		}
+		if ((tport->retry_counter < iport->max_plogi_retries)
+			&& (fchdr->r_ctl == FNIC_BA_ACC_RCTL)) {
+			fdls_free_tgt_oxid(iport, oxid);
+			fdls_send_tgt_plogi(iport, tport);
+			return;
+		}
+		fdls_free_tgt_oxid(iport, oxid);
+		fdls_delete_tport(iport, tport);
+		/*Restart a discovery of targets */
+		if ((iport->state == FNIC_IPORT_STATE_READY)
+			&& (iport->fabric.state != FDLS_STATE_SEND_GPNFT)
+			&& (iport->fabric.state != FDLS_STATE_RSCN_GPN_FT)) {
+			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
+		}
+		return;
+	}
+
+	/*This abort rsp is for PRLI */
+	if ((oxid >= FDLS_PRLI_OXID_BASE) && (oxid < FDLS_ADISC_OXID_BASE)) {
+		if (fchdr->r_ctl == FNIC_BA_ACC_RCTL) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: Received tgt PRLI abts response BA_ACC",
+				 tport->fcid);
+		} else if (fchdr->r_ctl == FNIC_BA_RJT_RCTL) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "PRLI BA_RJT received for tport_fcid: 0x%x OX_ID: 0x%x ",
+				 tport->fcid, fchdr->ox_id);
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "reason code: 0x%x reason code explanation: 0x%x",
+				 ba_rjt->reason_code,
+				 ba_rjt->reason_explanation);
+		}
+		if ((tport->retry_counter < FDLS_RETRY_COUNT)
+			&& (fchdr->r_ctl == FNIC_BA_ACC_RCTL)) {
+			fdls_free_tgt_oxid(iport, oxid);
+			fdls_send_tgt_prli(iport, tport);
+			return;
+		}
+		fdls_free_tgt_oxid(iport, oxid);
+		fdls_send_tgt_plogi(iport, tport);	/* go back to plogi */
+		fdls_set_tport_state(tport, FDLS_TGT_STATE_PLOGI);
+		return;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Received ABTS response for unknown frame %p", iport);
+}
+
 /*
  * Performs a validation for all FCOE frames and return the frame type
  */
@@ -1434,6 +2768,42 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		}
 	}
 
+	/* ELS response from a target */
+	if ((ntohs(oxid) >= FDLS_PLOGI_OXID_BASE)
+		&& (ntohs(oxid) < FDLS_PRLI_OXID_BASE)) {
+		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"Dropping Unknown frame in PLOGI exchange range type: 0x%x.",
+				fchdr->type);
+			return -1;
+		}
+		return FNIC_TPORT_PLOGI_RSP;
+	}
+	if ((ntohs(oxid) >= FDLS_PRLI_OXID_BASE)
+		&& (ntohs(oxid) < FDLS_ADISC_OXID_BASE)) {
+		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"Dropping Unknown frame in PRLI exchange range type: 0x%x.",
+				fchdr->type);
+			return -1;
+		}
+		return FNIC_TPORT_PRLI_RSP;
+	}
+
+	if ((ntohs(oxid) >= FDLS_ADISC_OXID_BASE)
+		&& (ntohs(oxid) < FDLS_TGT_OXID_POOL_END)) {
+		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"Dropping Unknown frame in ADISC exchange range type: 0x%x.",
+				fchdr->type);
+			return -1;
+		}
+		return FNIC_TPORT_ADISC_RSP;
+	}
+	if (ntohs(oxid) == FNIC_TLOGO_REQ_OXID) {
+		return FNIC_TPORT_LOGO_RSP;
+	}
+
 	/*response from fabric */
 	switch (oxid) {
 
@@ -1557,6 +2927,21 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	case FNIC_FABRIC_GPN_FT_RSP:
 		fdls_process_gpn_ft_rsp(iport, fchdr, len);
 		break;
+	case FNIC_TPORT_PLOGI_RSP:
+		fdls_process_tgt_plogi_rsp(iport, fchdr);
+		break;
+	case FNIC_TPORT_PRLI_RSP:
+		fdls_process_tgt_prli_rsp(iport, fchdr);
+		break;
+	case FNIC_TPORT_ADISC_RSP:
+		fdls_process_tgt_adisc_rsp(iport, fchdr);
+		break;
+	case FNIC_TPORT_LOGO_RSP:
+		/* Logo response from tgt which we have deleted */
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Logo response from tgt: 0x%x",
+					 ntoh24(fchdr->sid));
+		break;
 	case FNIC_FABRIC_LOGO_RSP:
 		fdls_process_fabric_logo_rsp(iport, fchdr);
 		break;
@@ -1566,7 +2951,8 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 		if ((iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)
 			&& (oxid >= FNIC_FLOGI_OXID && oxid <= FNIC_RFF_REQ_OXID)) {
 			fdls_process_fabric_abts_rsp(iport, fchdr);
-		}
+		} else
+			fdls_process_tgt_abts_rsp(iport, fchdr);
 		break;
 	default:
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 2d5f438f2cc4..92cd17efa40f 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -79,6 +79,9 @@
 
 #define IS_FNIC_FCP_INITIATOR(fnic) (fnic->role == FNIC_ROLE_FCP_INITIATOR)
 
+/* Retry supported by rport (returned by PRLI service parameters) */
+#define FNIC_FC_RP_FLAGS_RETRY            0x1
+
 /*
  * fnic private data per SCSI command.
  * These fields are locked by the hashed io_req_lock.
@@ -133,6 +136,7 @@ static inline u64 fnic_flags_and_state(struct scsi_cmnd *cmd)
 
 extern unsigned int fnic_log_level;
 extern unsigned int io_completions;
+extern struct workqueue_struct *fnic_event_queue;
 
 #define FNIC_MAIN_LOGGING 0x01
 #define FNIC_FCS_LOGGING 0x02
@@ -329,6 +333,8 @@ struct fnic {
 	struct work_struct flush_work;
 	struct sk_buff_head frame_queue;
 	struct list_head tx_queue;
+	struct work_struct tport_work;
+	struct list_head tport_event_list;
 
 	/*** FIP related data members  -- start ***/
 	void (*set_vlan)(struct fnic *, u16 vlan);
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
index 095275698716..9eb25ed9c19f 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -325,6 +325,10 @@ void fdls_send_fabric_logo(struct fnic_iport_s *iport);
 int fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 								  void *rx_frame, int len,
 								  int fchdr_offset);
+void fdls_send_tport_abts(struct fnic_iport_s *iport,
+						  struct fnic_tport_s *tport);
+void fdls_delete_tport(struct fnic_iport_s *iport,
+					   struct fnic_tport_s *tport);
 
 /* fnic_fcs.c */
 void fnic_fdls_init(struct fnic *fnic, int usefip);
-- 
2.31.1

