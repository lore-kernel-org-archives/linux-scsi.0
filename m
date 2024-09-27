Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ED1171E76;
	Fri, 27 Sep 2024 18:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727462972; cv=none; b=S6dp5W5amOV93CzqxdIuwlB4amil+Hv8XRtL/bqBI6cU5YRHd6xEFRWCVPiPabHd9LKFFY9dn2rFcuNUeMoFlItzk5pUz9T4Bd149doDqCisSM1vZjTkoBbVWJ++rPVVJGJBodiG590uUkmm3UFKurBx9c4+EEUn9wPPJaY5iJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727462972; c=relaxed/simple;
	bh=qieGd5q2+W+n5VOxFBhGNGE4B3bb8D4maTfLcz7dY6U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JeT6YUDWQ17+R5G2x7qwvQr6e4HbuEnYkXhakqO58JkKwHxWiTF07zklm2oMxuTVWLXHUek1u0CKvI1EzCzsMys4IDinus2RHwSOT+rTEOat7lyFit2pAjEH57uTZrdGVcLSh9+ykPQryuLzIHlmT+bdLN6OK6zPtbDjiL4KSxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=cRbHPy3y; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="cRbHPy3y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=61258; q=dns/txt;
  s=iport; t=1727462968; x=1728672568;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/ecmX85UIjIAA0HknGX+hBrQl+X5E9XBfAbMuGrSreE=;
  b=cRbHPy3yZUHfTvBwfljZm4ifjBUHvaoV6lW/SezQQqRIEbaVir14JXdH
   JBQrO7aD/wSSKrVgwkdks/scS4Pnl5QaVnn/tJ+fYeKJv4CTlour71vhZ
   fnhMFjDXw/WczkWxeGXr2o42Om6AaoM9TSL1JMZnAuhLfVs5BRzHG1CAD
   M=;
X-CSE-ConnectionGUID: yovB9Q0wRPS37iQzZtq1UA==
X-CSE-MsgGUID: 6Q3akn9kQyKyHsCCAirXRA==
X-IronPort-AV: E=Sophos;i="6.11,159,1725321600"; 
   d="scan'208";a="266928692"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2024 18:49:21 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 48RIkQal022754
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 27 Sep 2024 18:49:20 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v3 04/14] scsi: fnic: Add support for target based solicited requests and responses
Date: Fri, 27 Sep 2024 11:46:03 -0700
Message-Id: <20240927184613.52172-5-kartilak@cisco.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240927184613.52172-1-kartilak@cisco.com>
References: <20240927184613.52172-1-kartilak@cisco.com>
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

Add support for target based solicited requests and responses.
Add support for tport definitions and processing.
Add support for restarting the IT nexus.

Reported-by: kernel test robot <lkp@intel.com>
Closes:
https://lore.kernel.org/oe-kbuild-all/202406120146.xchlZbqX-lkp@
intel.com/

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Signed-off-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v2 and v3:
    Fix issue found by kernel test robot.
    Remove fnic_std_ba_acc definition to fix compilation
    warning.
    Incorporate review comments from Hannes:
	Replace redundant definitions with standard definitions.
	Replace static OXIDs with pool-based OXIDs for targets.

Changes between v1 and v2:
    Incorporate review comments from Hannes:
	Use the correct kernel-doc format.
	Replace htonll() with get_unaligned_be64().
	Replace fnic_del_fabric_timer_sync macro calls to function
	calls.
	Replace fnic_del_tport_timer_sync macro calls to function
	calls.
	Rename fc_abts_s to fc_tport_abts_s.
	Modify fc_tport_abts_s to be a global frame.
	Rename variable pfc_abts to tport_abts.
	Replace definitions with standard definitions from
	fc_els.h.
	Modify functions with returns in the middle to if else
	clauses.
    Replace simultaneous use of fc_tport_abts_s and tport_abts with
    just tport_abts.
---
 drivers/scsi/fnic/fdls_disc.c | 1567 +++++++++++++++++++++++++++++++--
 drivers/scsi/fnic/fnic.h      |    6 +
 drivers/scsi/fnic/fnic_fdls.h |    2 +-
 3 files changed, 1501 insertions(+), 74 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index d203398b2743..0757b9ab1a28 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -11,6 +11,10 @@
 #include <scsi/fc/fc_fcp.h>
 #include <linux/utsname.h>
 
+#define FC_FC4_TYPE_SCSI 0x08
+
+static void fdls_send_rpn_id(struct fnic_iport_s *iport);
+
 /* Frame initialization */
 /*
  * Variables:
@@ -66,6 +70,20 @@ struct fc_std_rpn_id fnic_std_rpn_id_req = {
 		      .ct_cmd = cpu_to_be16(FC_NS_RPN_ID)}
 };
 
+/*
+ * Variables:
+ * did, sid, oxid
+ */
+struct fc_std_els_prli fnic_std_prli_req = {
+	.fchdr = {.fh_r_ctl = FC_RCTL_ELS_REQ, .fh_type = FC_TYPE_ELS,
+		  .fh_f_ctl = {FNIC_ELS_REQ_FCTL, 0, 0}, .fh_rx_id = 0xFFFF},
+	.els_prli = {.prli_cmd = ELS_PRLI,
+		     .prli_spp_len = 16,
+		     .prli_len = cpu_to_be16(0x14)},
+	.sp = {.spp_type = 0x08, .spp_flags = 0x0020,
+	       .spp_params = cpu_to_be32(0xA2)}
+};
+
 /*
  * Variables:
  * fh_s_id, port_id, port_name
@@ -143,9 +161,19 @@ struct fc_frame_header fc_std_fabric_abts = {
 	.fh_parm_offset = 0x00000000,	/* bit:0 = 0 Abort a exchange */
 };
 
+struct fc_frame_header fc_std_tport_abts = {
+	.fh_r_ctl = FC_RCTL_BA_ABTS,	/* ABTS */
+	.fh_cs_ctl = 0x00, .fh_type = FC_TYPE_BLS,
+	.fh_f_ctl = {FNIC_REQ_ABTS_FCTL, 0, 0}, .fh_seq_id = 0x00,
+	.fh_df_ctl = 0x00, .fh_seq_cnt = 0x0000, .fh_rx_id = 0xFFFF,
+	.fh_parm_offset = 0x00000000,	/* bit:0 = 0 Abort a exchange */
+};
+
 #define RETRIES_EXHAUSTED(iport)      \
 	(iport->fabric.retry_counter == FABRIC_LOGO_MAX_RETRY)
 
+#define FNIC_TPORT_MAX_NEXUS_RESTART (8)
+
 /*
  * For fabric requests and fdmi, once OXIDs are allocated from the pool
  * (and a range) they are encoded with expected rsp type as
@@ -166,6 +194,14 @@ static void fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 				   struct fc_frame_header *fchdr,
 				   void *rx_frame);
 static void fnic_fdls_start_plogi(struct fnic_iport_s *iport);
+static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
+									  uint32_t fcid,
+									  uint64_t wwpn);
+static void fdls_target_restart_nexus(struct fnic_tport_s *tport);
+static void fdls_start_tport_timer(struct fnic_iport_s *iport,
+					struct fnic_tport_s *tport, int timeout);
+static void fdls_tport_timer_callback(struct timer_list *t);
+
 static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
 			int timeout);
 static void
@@ -181,6 +217,8 @@ void fdls_init_oxid_pool(struct fnic_iport_s *iport)
 	fdls_init_fabric_oxid_pool(&iport->fdmi_oxid_pool,
 			FDLS_FDMI_OXID_POOL_BASE,
 			FDLS_FDMI_OXID_POOL_SZ);
+
+	fdls_init_tgt_oxid_pool(iport);
 }
 
 uint16_t fdls_alloc_oxid(struct fnic_iport_s *iport,
@@ -312,6 +350,13 @@ static inline void fdls_schedule_fabric_oxid_free(struct fnic_iport_s
 			    iport->fabric_oxid_pool.active_oxid_fabric_req);
 }
 
+static inline void fdls_schedule_tgt_oxid_free(struct fnic_iport_s *iport,
+					       struct fnic_tgt_oxid_pool_s
+					       *oxid_pool, uint16_t oxid)
+{
+	fdls_schedule_oxid_free(&oxid_pool->meta, oxid);
+}
+
 int fnic_fdls_expected_rsp(struct fnic_iport_s *iport, uint16_t oxid)
 {
 	struct fnic *fnic = iport->fnic;
@@ -339,6 +384,62 @@ static int fdls_is_oxid_in_fabric_range(uint16_t oxid)
 			(oxid_unmasked <= FDLS_FABRIC_OXID_POOL_END));
 }
 
+void fdls_init_tgt_oxid_pool(struct fnic_iport_s *iport)
+{
+	memset(&iport->plogi_oxid_pool, 0, sizeof(iport->plogi_oxid_pool));
+	iport->plogi_oxid_pool.meta.oxid_base = FDLS_PLOGI_OXID_BASE;
+	iport->plogi_oxid_pool.meta.sz = FDLS_TGT_OXID_BLOCK_SZ;
+	INIT_LIST_HEAD(&iport->plogi_oxid_pool.meta.reclaim_list);
+
+	memset(&iport->prli_oxid_pool, 0, sizeof(iport->prli_oxid_pool));
+	iport->prli_oxid_pool.meta.oxid_base = FDLS_PRLI_OXID_BASE;
+	iport->prli_oxid_pool.meta.sz = FDLS_TGT_OXID_BLOCK_SZ;
+	INIT_LIST_HEAD(&iport->prli_oxid_pool.meta.reclaim_list);
+
+	memset(&iport->adisc_oxid_pool, 0, sizeof(iport->adisc_oxid_pool));
+	iport->adisc_oxid_pool.meta.oxid_base = FDLS_ADISC_OXID_BASE;
+	iport->adisc_oxid_pool.meta.sz = FDLS_TGT_OXID_BLOCK_SZ;
+	INIT_LIST_HEAD(&iport->adisc_oxid_pool.meta.reclaim_list);
+}
+
+inline uint16_t fdls_alloc_tgt_oxid(struct fnic_iport_s *iport,
+				    struct fnic_tgt_oxid_pool_s *oxid_pool)
+{
+	uint16_t oxid;
+
+	oxid = fdls_alloc_oxid(iport, &oxid_pool->meta, oxid_pool->bitmap);
+	return oxid;
+}
+
+inline void fdls_free_tgt_oxid(struct fnic_iport_s *iport,
+			       struct fnic_tgt_oxid_pool_s *oxid_pool,
+			       uint16_t oxid)
+{
+	fdls_free_oxid(iport, &oxid_pool->meta, oxid_pool->bitmap, oxid);
+}
+
+static struct fnic_tgt_oxid_pool_s *fdls_get_tgt_oxid_pool(struct fnic_tport_s
+							   *tport)
+{
+	struct fnic_iport_s *iport = (struct fnic_iport_s *)tport->iport;
+	struct fnic_tgt_oxid_pool_s *oxid_pool = NULL;
+
+	switch (tport->state) {
+	case FDLS_TGT_STATE_PLOGI:
+		oxid_pool = &iport->plogi_oxid_pool;
+		break;
+	case FDLS_TGT_STATE_PRLI:
+		oxid_pool = &iport->prli_oxid_pool;
+		break;
+	case FDLS_TGT_STATE_ADISC:
+		oxid_pool = &iport->adisc_oxid_pool;
+		break;
+	default:
+		break;
+	}
+	return oxid_pool;
+}
+
 inline void fnic_del_fabric_timer_sync(struct fnic *fnic)
 {
 	fnic->iport.fabric.del_timer_inprogress = 1;
@@ -382,6 +483,56 @@ fdls_start_fabric_timer(struct fnic_iport_s *iport, int timeout)
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
+		fnic_del_tport_timer_sync(fnic, tport);
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
+	struct fc_frame_header tport_abort = fc_std_tport_abts;
+	struct fc_frame_header *tport_abts = &tport_abort;
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+	FNIC_STD_SET_S_ID(tport_abts, s_id);
+	FNIC_STD_SET_D_ID(tport_abts, d_id);
+	tport->flags |= FNIC_FDLS_TGT_ABORT_ISSUED;
+
+	tport_abts->fh_ox_id = tport->oxid_used;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS sending tport abts: tport->state: %d ",
+				 tport->state);
+
+	fnic_send_fcoe_frame(iport, tport_abts, sizeof(struct fc_frame_header));
+	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
+	fdls_start_tport_timer(iport, tport, 2 * iport->e_d_tov);
+}
+
 static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
 {
 	uint8_t fcid[3];
@@ -613,6 +764,176 @@ static void fdls_send_gpn_ft(struct fnic_iport_s *iport, int fdls_state)
 	fdls_set_state((&iport->fabric), fdls_state);
 }
 
+static void
+fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
+{
+	struct fc_std_els_adisc adisc;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+
+	memset(&adisc, 0, sizeof(struct fc_std_els_adisc));
+	FNIC_STD_SET_R_CTL(&adisc.fchdr, 0x22);
+	FNIC_STD_SET_TYPE(&adisc.fchdr, 0x01);
+	FNIC_STD_SET_F_CTL(&adisc.fchdr, FNIC_ELS_REQ_FCTL << 16);
+	FNIC_STD_SET_RX_ID(&adisc.fchdr, cpu_to_be16(0xFFFF));
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+	FNIC_STD_SET_S_ID(&adisc.fchdr, s_id);
+	FNIC_STD_SET_D_ID(&adisc.fchdr, d_id);
+
+	oxid = htons(fdls_alloc_tgt_oxid(iport, &iport->adisc_oxid_pool));
+	if (oxid == 0xFFFF) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Failed to allocate OXID to send ADISC %p", iport);
+		return;
+	}
+
+	tport->oxid_used = oxid;
+	tport->flags &= ~FNIC_FDLS_TGT_ABORT_ISSUED;
+
+	FNIC_STD_SET_OX_ID((&adisc.fchdr), oxid);
+	FNIC_STD_SET_NPORT_NAME(&adisc.els.adisc_wwpn,
+				le64_to_cpu(iport->wwpn));
+	FNIC_STD_SET_NODE_NAME(&adisc.els.adisc_wwnn, le64_to_cpu(iport->wwnn));
+
+	memcpy(adisc.els.adisc_port_id, s_id, 3);
+	adisc.els.adisc_cmd = ELS_ADISC;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "sending ADISC to tgt fcid: 0x%x", tport->fcid);
+
+
+	fnic_send_fcoe_frame(iport, &adisc, sizeof(struct fc_std_els_adisc));
+	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
+	fdls_start_tport_timer(iport, tport, 2 * iport->e_d_tov);
+}
+
+bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
+{
+	struct fnic_tport_event_s *tport_del_evt;
+	struct fnic *fnic = iport->fnic;
+
+	if ((tport->state == FDLS_TGT_STATE_OFFLINING)
+	    || (tport->state == FDLS_TGT_STATE_OFFLINE)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "tport fcid 0x%x: tport state is offlining/offline\n",
+			     tport->fcid);
+		return false;
+	}
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
+		fnic_del_tport_timer_sync(fnic, tport);
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
+				return false;
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
+	return true;
+}
+
+static void
+fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
+{
+	struct fc_std_flogi plogi;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+	uint32_t timeout;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Send tgt PLOGI to fcid: 0x%x", tport->fcid);
+
+	memcpy(&plogi, &fnic_std_plogi_req, sizeof(struct fc_std_flogi));
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+
+	FNIC_STD_SET_S_ID(&plogi.fchdr, s_id);
+	FNIC_STD_SET_D_ID(&plogi.fchdr, d_id);
+	FNIC_LOGI_SET_RDF_SIZE(&plogi.els, iport->max_payload_size);
+
+	oxid = htons(fdls_alloc_tgt_oxid(iport, &iport->plogi_oxid_pool));
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
+	FNIC_STD_SET_OX_ID((&plogi.fchdr), oxid);
+	FNIC_LOGI_SET_NPORT_NAME(&plogi.els, iport->wwpn);
+	FNIC_LOGI_SET_NODE_NAME(&plogi.els, iport->wwnn);
+
+	timeout = max(2 * iport->e_d_tov, iport->plogi_timeout);
+
+
+	fnic_send_fcoe_frame(iport, &plogi, sizeof(struct fc_std_flogi));
+	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
+	fdls_start_tport_timer(iport, tport, timeout);
+}
+
+static uint16_t
+fnic_fc_plogi_rsp_rdf(struct fnic_iport_s *iport,
+		      struct fc_std_flogi *plogi_rsp)
+{
+	uint16_t b2b_rdf_size =
+	    be16_to_cpu(FNIC_LOGI_RDF_SIZE(&plogi_rsp->els));
+	uint16_t spc3_rdf_size =
+	    be16_to_cpu(plogi_rsp->els.fl_cssp[2].cp_rdfs) & FNIC_FC_C3_RDF;
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
 	struct fc_std_rft_id rft_id;
@@ -689,6 +1010,48 @@ static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
 	fdls_start_fabric_timer(iport, 2 * iport->e_d_tov);
 }
 
+static void
+fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
+{
+	struct fc_std_els_prli prli;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+	uint32_t timeout;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS sending PRLI to tgt: 0x%x", tport->fcid);
+
+	oxid = htons(fdls_alloc_tgt_oxid(iport, &iport->prli_oxid_pool));
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
+	memcpy(&prli, &fnic_std_prli_req, sizeof(struct fc_std_els_prli));
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+
+	FNIC_STD_SET_S_ID((&prli.fchdr), s_id);
+	FNIC_STD_SET_D_ID((&prli.fchdr), d_id);
+	FNIC_STD_SET_OX_ID((&prli.fchdr), oxid);
+
+	timeout = max(2 * iport->e_d_tov, iport->plogi_timeout);
+
+
+	fnic_send_fcoe_frame(iport, &prli, sizeof(struct fc_std_els_prli));
+	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
+	fdls_start_tport_timer(iport, tport, timeout);
+}
+
 /**
  * fdls_send_fabric_logo - Send flogo to the fcf
  * @iport: Handle to fnic iport
@@ -741,6 +1104,212 @@ void fdls_send_fabric_logo(struct fnic_iport_s *iport)
 	fnic_send_fcoe_frame(iport, &logo, sizeof(struct fc_std_logo));
 }
 
+/**
+ * fdls_tgt_logout - Send plogo to the remote port
+ * @iport: Handle to fnic iport
+ * @tport: Handle to remote port
+ *
+ * This function does not change or check the fabric/tport state.
+ * It the caller's responsibility to set the appropriate tport/fabric
+ * state when this is called. Normally that is fdls_tgt_state_plogo.
+ * This could be used to send plogo to nameserver process
+ * also not just target processes
+ */
+void fdls_tgt_logout(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
+{
+	struct fc_std_logo logo;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	struct fnic *fnic = iport->fnic;
+	uint16_t oxid;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Sending logo to tport fcid: 0x%x", tport->fcid);
+	memcpy(&logo, &fnic_std_logo_req, sizeof(struct fc_std_logo));
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+
+	FNIC_STD_SET_S_ID((&logo.fchdr), s_id);
+	FNIC_STD_SET_D_ID((&logo.fchdr), d_id);
+
+	oxid = htons(fdls_alloc_tgt_oxid(iport, &iport->plogi_oxid_pool));
+	FNIC_STD_SET_OX_ID((&logo.fchdr), oxid);
+
+	memcpy(&logo.els.fl_n_port_id, s_id, 3);
+	FNIC_STD_SET_NPORT_NAME(&logo.els.fl_n_port_wwn,
+				le64_to_cpu(iport->wwpn));
+
+
+	fnic_send_fcoe_frame(iport, &logo, sizeof(struct fc_std_logo));
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
+	bool retval = true;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "tport fcid: 0x%x state: %d restart_count: %d",
+				 tport->fcid, tport->state, tport->nexus_restart_count);
+
+	fcid = tport->fcid;
+	wwpn = tport->wwpn;
+	nexus_restart_count = tport->nexus_restart_count;
+
+	retval = fdls_delete_tport(iport, tport);
+	if (retval != true) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			     "Error deleting tport: 0x%x", fcid);
+		return;
+	}
+
+	if (nexus_restart_count >= FNIC_TPORT_MAX_NEXUS_RESTART) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			     "Exceeded nexus restart retries tport: 0x%x",
+			     fcid);
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
@@ -846,89 +1415,587 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 			/* ABTS has timed out */
 			fdls_schedule_fabric_oxid_free(iport);
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
+		} else if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
+			/* RFT_ID timed out send abts */
+			fdls_send_fabric_abts(iport);
+		} else {
+			/* ABTS has timed out */
+			fdls_schedule_fabric_oxid_free(iport);
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"ABTS timed out. Starting PLOGI: %p", iport);
+			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
+		}
+		break;
+	case FDLS_STATE_REGISTER_FC4_FEATURES:
+		/* scr received a LS_RJT with busy we retry from here */
+		if ((iport->fabric.flags & FNIC_FDLS_RETRY_FRAME)
+			&& (iport->fabric.retry_counter < FDLS_RETRY_COUNT)) {
+			iport->fabric.flags &= ~FNIC_FDLS_RETRY_FRAME;
+			fdls_send_register_fc4_features(iport);
+		} else if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED))
+			/* SCR has timed out. Send abts */
+			fdls_send_fabric_abts(iport);
+		else {
+			/* ABTS has timed out */
+			fdls_schedule_fabric_oxid_free(iport);
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"ABTS timed out. Starting PLOGI %p", iport);
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
+		} else if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
+			/* gpn_ft has timed out. Send abts */
+			fdls_send_fabric_abts(iport);
+		} else {
+			/* ABTS has timed out */
+			fdls_schedule_fabric_oxid_free(iport);
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
+			tport->flags &= ~FNIC_FDLS_RETRY_FRAME;
+			fdls_send_tgt_plogi(iport, tport);
+		} else if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
+			/* Plogi frame has timed out, send abts */
+			fdls_send_tport_abts(iport, tport);
+		} else if (tport->retry_counter < iport->max_plogi_retries) {
+			/*
+			 * ABTS has timed out
+			 */
+			fdls_schedule_tgt_oxid_free(iport,
+						    &iport->plogi_oxid_pool,
+						    oxid);
+			fdls_send_tgt_plogi(iport, tport);
+		} else {
+			/* exceeded plogi retry count */
+			fdls_schedule_tgt_oxid_free(iport,
+						    &iport->plogi_oxid_pool,
+						    oxid);
+			fdls_send_delete_tport_msg(tport);
+		}
+		break;
+	case FDLS_TGT_STATE_PRLI:
+		/* PRLI received a LS_RJT with busy , hence we retry from here */
+		if ((tport->flags & FNIC_FDLS_RETRY_FRAME)
+			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
+			tport->flags &= ~FNIC_FDLS_RETRY_FRAME;
+			fdls_send_tgt_prli(iport, tport);
+		} else if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
+			/* PRLI has time out, send abts */
+			fdls_send_tport_abts(iport, tport);
+		} else {
+			/* ABTS has timed out for prli, we go back to PLOGI */
+			fdls_schedule_tgt_oxid_free(iport,
+						    &iport->prli_oxid_pool,
+						    oxid);
+			fdls_send_tgt_plogi(iport, tport);
+			fdls_set_tport_state(tport, FDLS_TGT_STATE_PLOGI);
+		}
+		break;
+	case FDLS_TGT_STATE_ADISC:
+		/* ADISC timed out send an ABTS */
+		if (!(tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)) {
+			fdls_send_tport_abts(iport, tport);
+		} else if ((tport->flags & FNIC_FDLS_TGT_ABORT_ISSUED)
+				   && (tport->retry_counter < FDLS_RETRY_COUNT)) {
+			/*
+			 * ABTS has timed out
+			 */
+			fdls_schedule_tgt_oxid_free(iport,
+						    &iport->adisc_oxid_pool,
+						    oxid);
+			fdls_send_tgt_adisc(iport, tport);
+		} else {
+			/* exceeded retry count */
+			fdls_schedule_tgt_oxid_free(iport,
+						    &iport->adisc_oxid_pool,
+						    oxid);
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "ADISC not responding. Deleting target port: 0x%x",
+					 tport->fcid);
+			fdls_send_delete_tport_msg(tport);
+		}
+		break;
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
+			   struct fc_frame_header *fchdr)
+{
+	uint32_t tgt_fcid;
+	struct fnic_tport_s *tport;
+	uint8_t *fcid;
+	uint64_t frame_wwnn;
+	uint64_t frame_wwpn;
+	uint16_t oxid;
+	struct fc_std_els_adisc *adisc_rsp = (struct fc_std_els_adisc *)fchdr;
+	struct fc_std_els_rsp *els_rjt = (struct fc_std_els_rsp *)fchdr;
+	struct fnic *fnic = iport->fnic;
+
+	fcid = FNIC_STD_GET_S_ID(fchdr);
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
+	if (ntohs(fchdr->fh_ox_id) != ntohs(tport->oxid_used)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Dropping frame from target: 0x%x",
+			 tgt_fcid);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Reason: Stale ADISC/Aborted ADISC/OOO frame delivery");
+		return;
+	}
+
+	oxid = ntohs(FNIC_STD_GET_OX_ID(fchdr));
+	fdls_free_tgt_oxid(iport, &iport->adisc_oxid_pool, oxid);
+
+	switch (adisc_rsp->els.adisc_cmd) {
+	case ELS_LS_ACC:
+		if (tport->timer_pending) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "tport 0x%p Canceling fabric disc timer\n",
+						 tport);
+			fnic_del_tport_timer_sync(fnic, tport);
+		}
+		tport->timer_pending = 0;
+		tport->retry_counter = 0;
+		frame_wwnn = get_unaligned_be64(&adisc_rsp->els.adisc_wwnn);
+		frame_wwpn = get_unaligned_be64(&adisc_rsp->els.adisc_wwpn);
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
+	case ELS_LS_RJT:
+		if (((els_rjt->u.rej.er_reason == ELS_RJT_BUSY)
+		     || (els_rjt->u.rej.er_reason == ELS_RJT_UNAB))
+			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "ADISC ret ELS_LS_RJT BUSY. Retry from timer routine: 0x%x",
+				 tgt_fcid);
+
+			/* Retry ADISC again from the timer routine. */
+			tport->flags |= FNIC_FDLS_RETRY_FRAME;
+		} else {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "ADISC returned ELS_LS_RJT from target: 0x%x",
+						 tgt_fcid);
+			fdls_delete_tport(iport, tport);
+		}
+		break;
+	}
+}
+
+
+static void
+fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
+			   struct fc_frame_header *fchdr)
+{
+	uint32_t tgt_fcid;
+	struct fnic_tport_s *tport;
+	uint8_t *fcid;
+	uint16_t oxid;
+	struct fc_std_flogi *plogi_rsp = (struct fc_std_flogi *)fchdr;
+	struct fc_std_els_rsp *els_rjt = (struct fc_std_els_rsp *)fchdr;
+	int max_payload_size;
+	struct fnic *fnic = iport->fnic;
+
+	fcid = FNIC_STD_GET_S_ID(fchdr);
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
+			     "PLOGI rsp recvd in wrong state. Drop the frame and restart nexus");
+		fdls_target_restart_nexus(tport);
+		return;
+	}
+
+	if (fchdr->fh_ox_id != tport->oxid_used) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "PLOGI response from target: 0x%x. Dropping frame",
+			 tgt_fcid);
+		return;
+	}
+
+	oxid = ntohs(FNIC_STD_GET_OX_ID(fchdr));
+	fdls_free_tgt_oxid(iport, &iport->plogi_oxid_pool, oxid);
+
+	switch (plogi_rsp->els.fl_cmd) {
+	case ELS_LS_ACC:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PLOGI accepted by target: 0x%x", tgt_fcid);
+		break;
+
+	case ELS_LS_RJT:
+		if (((els_rjt->u.rej.er_reason == ELS_RJT_BUSY)
+		     || (els_rjt->u.rej.er_reason == ELS_RJT_UNAB))
+			&& (tport->retry_counter < iport->max_plogi_retries)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "PLOGI ret ELS_LS_RJT BUSY. Retry from timer routine: 0x%x",
+				 tgt_fcid);
+			/* Retry plogi again from the timer routine. */
+			tport->flags |= FNIC_FDLS_RETRY_FRAME;
+			return;
+		}
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PLOGI returned ELS_LS_RJT from target: 0x%x",
+					 tgt_fcid);
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
+		fnic_del_tport_timer_sync(fnic, tport);
+	}
+
+	tport->timer_pending = 0;
+	tport->wwpn = get_unaligned_be64(&FNIC_LOGI_PORT_NAME(&plogi_rsp->els));
+	tport->wwnn = get_unaligned_be64(&FNIC_LOGI_NODE_NAME(&plogi_rsp->els));
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
+			  struct fc_frame_header *fchdr)
+{
+	uint32_t tgt_fcid;
+	struct fnic_tport_s *tport;
+	uint8_t *fcid;
+	uint16_t oxid;
+	struct fc_std_els_prli *prli_rsp = (struct fc_std_els_prli *)fchdr;
+	struct fc_std_els_rsp *els_rjt = (struct fc_std_els_rsp *)fchdr;
+	struct fnic_tport_event_s *tport_add_evt;
+	struct fnic *fnic = iport->fnic;
+	bool mismatched_tgt = false;
+
+	fcid = FNIC_STD_GET_S_ID(fchdr);
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
+			     "PRLI rsp recvd in wrong state. Drop frame. Restarting nexus");
+		fdls_target_restart_nexus(tport);
+		return;
+	}
+
+	if (fchdr->fh_ox_id != tport->oxid_used) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Dropping PRLI response from target: 0x%x ",
+			 tgt_fcid);
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Reason: Stale PRLI response/Aborted PDISC/OOO frame delivery");
+		return;
+	}
+
+	oxid = ntohs(FNIC_STD_GET_OX_ID(fchdr));
+	fdls_free_tgt_oxid(iport, &iport->prli_oxid_pool, oxid);
+
+	switch (prli_rsp->els_prli.prli_cmd) {
+	case ELS_LS_ACC:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "PRLI accepted from target: 0x%x", tgt_fcid);
+
+		if (prli_rsp->sp.spp_type != FC_FC4_TYPE_SCSI) {
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
-		} else if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
-			/* RFT_ID timed out send abts */
-			fdls_send_fabric_abts(iport);
-		} else {
-			/* ABTS has timed out */
-			fdls_schedule_fabric_oxid_free(iport);
-			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-						 "ABTS timed out. Starting PLOGI: %p", iport);
-			fnic_fdls_start_plogi(iport);	/* go back to fabric Plogi */
+		if (mismatched_tgt) {
+			fdls_tgt_logout(iport, tport);
+			fdls_delete_tport(iport, tport);
+			return;
 		}
 		break;
-	case FDLS_STATE_REGISTER_FC4_FEATURES:
-		/* scr received a LS_RJT with busy we retry from here */
-		if ((iport->fabric.flags & FNIC_FDLS_RETRY_FRAME)
-			&& (iport->fabric.retry_counter < FDLS_RETRY_COUNT)) {
-			iport->fabric.flags &= ~FNIC_FDLS_RETRY_FRAME;
-			fdls_send_register_fc4_features(iport);
-		} else if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED))
-			/* SCR has timed out. Send abts */
-			fdls_send_fabric_abts(iport);
-		else {
-			/* ABTS has timed out */
-			fdls_schedule_fabric_oxid_free(iport);
+	case ELS_LS_RJT:
+		if (((els_rjt->u.rej.er_reason == ELS_RJT_BUSY)
+		     || (els_rjt->u.rej.er_reason == ELS_RJT_UNAB))
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
-		} else if (!(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
-			/* gpn_ft has timed out. Send abts */
-			fdls_send_fabric_abts(iport);
+				 "PRLI ret ELS_LS_RJT BUSY. Retry from timer routine: 0x%x",
+				 tgt_fcid);
+
+			/*Retry Plogi again from the timer routine. */
+			tport->flags |= FNIC_FDLS_RETRY_FRAME;
+			return;
 		} else {
-			/* ABTS has timed out */
-			fdls_schedule_fabric_oxid_free(iport);
-			if (iport->fabric.retry_counter < FDLS_RETRY_COUNT) {
-				fdls_send_gpn_ft(iport, iport->fabric.state);
-			} else {
-				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-					 "ABTS timeout for fabric GPN_FT. Check name server: %p",
-					 iport);
-			}
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "PRLI returned ELS_LS_RJT from target: 0x%x",
+						 tgt_fcid);
+
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
+		fnic_del_tport_timer_sync(fnic, tport);
+	}
+	tport->timer_pending = 0;
+
+	/* Learn Service Params */
+	tport->fcp_csp = be32_to_cpu(prli_rsp->sp.spp_params);
+	tport->retry_counter = 0;
+
+	if (prli_rsp->sp.spp_params & FCP_SPPF_RETRY)
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
 fdls_process_rff_id_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr)
@@ -1177,7 +2244,8 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport,
 						 iport);
 			if (iport->fabric.timer_pending) {
 				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-							 "Canceling fabric disc timer %p\n", iport);
+					     "Canceling fabric disc timer %p\n",
+					     iport);
 				fnic_del_fabric_timer_sync(fnic);
 			}
 			fdls->timer_pending = 0;
@@ -1190,6 +2258,104 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport,
 	}
 }
 
+static void
+fdls_process_gpn_ft_tgt_list(struct fnic_iport_s *iport,
+			     struct fc_frame_header *fchdr, int len)
+{
+	struct fc_gpn_ft_rsp_iu *gpn_ft_tgt;
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
+	    (struct fc_gpn_ft_rsp_iu *)((uint8_t *) fchdr +
+					sizeof(struct fc_frame_header)
+					+ sizeof(struct fc_ct_hdr));
+	len -= sizeof(struct fc_frame_header) + sizeof(struct fc_ct_hdr);
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
+			rem_len -= sizeof(struct fc_gpn_ft_rsp_iu);
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
+		rem_len -= sizeof(struct fc_gpn_ft_rsp_iu);
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
 fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 			struct fc_frame_header *fchdr, int len)
@@ -1198,6 +2364,9 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 	struct fc_std_gpn_ft *gpn_ft_rsp = (struct fc_std_gpn_ft *) fchdr;
 	uint16_t rsp;
 	uint8_t reason_code;
+	int count = 0;
+	struct fnic_tport_s *tport, *next;
+	u32 old_link_down_cnt = iport->fnic->link_down_cnt;
 	struct fnic *fnic = iport->fnic;
 
 	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
@@ -1237,12 +2406,74 @@ fdls_process_gpn_ft_rsp(struct fnic_iport_s *iport,
 	case FC_FS_ACC:
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					 "0x%x: GPNFT_RSP accept", iport->fcid);
+		if (iport->fabric.timer_pending) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+						 "0x%x: Canceling fabric disc timer\n",
+						 iport->fcid);
+			fnic_del_fabric_timer_sync(fnic);
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
 
 	case FC_FS_RJT:
 		reason_code = gpn_ft_rsp->fc_std_ct_hdr.ct_reason;
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 			 "0x%x: GPNFT_RSP Reject reason: %d", iport->fcid, reason_code);
+
+		if (((reason_code == FC_FS_RJT_BSY)
+		     || (reason_code == FC_FS_RJT_UNABL))
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
+				fnic_del_fabric_timer_sync(fnic);
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
@@ -1492,8 +2723,7 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 			     struct fc_frame_header *fchdr)
 {
 	uint32_t s_id;
-	struct fc_std_abts_ba_acc *ba_acc =
-	(struct fc_std_abts_ba_acc *) fchdr;
+	struct fc_std_abts_ba_acc *ba_acc = (struct fc_std_abts_ba_acc *)fchdr;
 	struct fc_std_abts_ba_rjt *ba_rjt;
 	uint32_t fabric_state = iport->fabric.state;
 	struct fnic *fnic = iport->fnic;
@@ -1658,6 +2888,148 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 	}
 }
 
+static void
+fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
+			  struct fc_frame_header *fchdr)
+{
+	uint32_t s_id;
+	struct fnic_tport_s *tport;
+	uint32_t tport_state;
+	struct fc_std_abts_ba_acc *ba_acc;
+	struct fc_std_abts_ba_rjt *ba_rjt;
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+
+	s_id = ntoh24(fchdr->fh_s_id);
+	ba_acc = (struct fc_std_abts_ba_acc *)fchdr;
+	ba_rjt = (struct fc_std_abts_ba_rjt *)fchdr;
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
+		fnic_del_tport_timer_sync(fnic, tport);
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
+	oxid = ntohs(fchdr->fh_ox_id);
+
+	/*This abort rsp is for ADISC */
+	if ((oxid >= FDLS_ADISC_OXID_BASE) && (oxid < FDLS_TGT_OXID_POOL_END)) {
+		if (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				     "OX_ID: 0x%x tgt_fcid: 0x%x rcvd tgt adisc abts resp BA_ACC",
+				     be16_to_cpu(ba_acc->acc.ba_ox_id),
+				     tport->fcid);
+		} else if (fchdr->fh_r_ctl == FNIC_BA_RJT_RCTL) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				 "ADISC BA_RJT rcvd tport_fcid: 0x%x tport_state: %d ",
+				 tport->fcid, tport_state);
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				 "reason code: 0x%x reason code explanation:0x%x ",
+				     ba_rjt->rjt.br_reason,
+				     ba_rjt->rjt.br_explan);
+		}
+		if ((tport->retry_counter < FDLS_RETRY_COUNT)
+		    && (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL)) {
+			fdls_free_tgt_oxid(iport, &iport->adisc_oxid_pool,
+					   oxid);
+			fdls_send_tgt_adisc(iport, tport);
+			return;
+		}
+
+		fdls_free_tgt_oxid(iport, &iport->adisc_oxid_pool, oxid);
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
+		if (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				 "Received tgt PLOGI abts response BA_ACC tgt_fcid: 0x%x",
+				 tport->fcid);
+		} else if (fchdr->fh_r_ctl == FNIC_BA_RJT_RCTL) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "PLOGI BA_RJT received for tport_fcid: 0x%x OX_ID: 0x%x",
+				     tport->fcid, fchdr->fh_ox_id);
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "reason code: 0x%x reason code explanation: 0x%x",
+				     ba_rjt->rjt.br_reason,
+				     ba_rjt->rjt.br_explan);
+		}
+		if ((tport->retry_counter < iport->max_plogi_retries)
+		    && (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL)) {
+			fdls_free_tgt_oxid(iport, &iport->plogi_oxid_pool,
+					   oxid);
+			fdls_send_tgt_plogi(iport, tport);
+			return;
+		}
+
+		fdls_free_tgt_oxid(iport, &iport->plogi_oxid_pool, oxid);
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
+		if (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: Received tgt PRLI abts response BA_ACC",
+				 tport->fcid);
+		} else if (fchdr->fh_r_ctl == FNIC_BA_RJT_RCTL) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "PRLI BA_RJT received for tport_fcid: 0x%x OX_ID: 0x%x ",
+				     tport->fcid, fchdr->fh_ox_id);
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "reason code: 0x%x reason code explanation: 0x%x",
+				     ba_rjt->rjt.br_reason,
+				     ba_rjt->rjt.br_explan);
+		}
+		if ((tport->retry_counter < FDLS_RETRY_COUNT)
+		    && (fchdr->fh_r_ctl == FNIC_BA_ACC_RCTL)) {
+			fdls_free_tgt_oxid(iport, &iport->prli_oxid_pool, oxid);
+			fdls_send_tgt_prli(iport, tport);
+			return;
+		}
+		fdls_free_tgt_oxid(iport, &iport->prli_oxid_pool, oxid);
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
@@ -1755,6 +3127,39 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 		}
 	}
 
+	/* ELS response from a target */
+	if ((ntohs(oxid) >= FDLS_PLOGI_OXID_BASE)
+		&& (ntohs(oxid) < FDLS_PRLI_OXID_BASE)) {
+		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"Dropping Unknown frame in PLOGI exchange range type: 0x%x.",
+				     fchdr->fh_type);
+			return -1;
+		}
+		return FNIC_TPORT_PLOGI_RSP;
+	}
+	if ((ntohs(oxid) >= FDLS_PRLI_OXID_BASE)
+		&& (ntohs(oxid) < FDLS_ADISC_OXID_BASE)) {
+		if (!FNIC_FC_FRAME_TYPE_ELS(fchdr)) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				"Dropping Unknown frame in PRLI exchange range type: 0x%x.",
+				     fchdr->fh_type);
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
+				     fchdr->fh_type);
+			return -1;
+		}
+		return FNIC_TPORT_ADISC_RSP;
+	}
+
 	/*response from fabric */
 	rsp_type = fnic_fdls_expected_rsp(iport, ntohs(oxid));
 
@@ -1883,6 +3288,21 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
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
+			     ntoh24(fchdr->fh_s_id));
+		break;
 	case FNIC_FABRIC_LOGO_RSP:
 		fdls_process_fabric_logo_rsp(iport, fchdr);
 		break;
@@ -1892,7 +3312,8 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 		if (fdls_is_oxid_in_fabric_range(oxid) &&
 			(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
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
index f53c1d8dbe7e..108452f6852d 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -385,7 +385,7 @@ int fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 								  void *rx_frame, int len,
 								  int fchdr_offset);
 void fdls_send_tport_abts(struct fnic_iport_s *iport,
-			  struct fnic_tport_s *tport);
+						struct fnic_tport_s *tport);
 bool fdls_delete_tport(struct fnic_iport_s *iport,
 		       struct fnic_tport_s *tport);
 void fdls_fdmi_timer_callback(struct timer_list *t);
-- 
2.31.1

