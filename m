Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F5D23B1
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726265; cv=none; b=MdcQO2emozIow7hkvn4GYdJ/bFkuxmpU5XqF4EDpiWZ9kLx5tt6fGI+mpoyUDGJo3y0FO79wHYUI1WwmM5dgMoeUmOcMUMiHTbqPUxO93O8MP7vusJS98DkJRmV1BQQDGMpYMqkt7e/Y0jqVZm194TiPXf2t6zhvX8crxBaNk3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726265; c=relaxed/simple;
	bh=KLvUGO/OLtT/1e4B+JyjLKZbqhkdfitIzH2iq+iqhKM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DAsfh31lqgDQ0vSWqAxCre0tIIx8JWSskRUajVcM8Enkw8aGjkpW5IvafpAHt4NZkEAsVXcMH3yt1MamSGEMF2K/L4R9dcVIDm/0oPTSu7CdWiUlsC3x/zQ05Dxed89vU+MzEvQIv7AJbw76jZpen4TzwqmIbYz2jOUTW7hJRF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aWunC9GS; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aWunC9GS"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-783cdbecfe2so3300285a.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726262; x=1707331062; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GHBE4j9OJW7ACHTyD2S0iFAVBBBT0rwoc72BcpaiA3w=;
        b=aWunC9GSBX6ifPxMY74dEzvyPQvW55I5N1iA0G8SvzPDJUcl8v4fU5PAewJUyLYsxh
         K7Isd1ayuLeS+mVe5qIn6f7ppCSFU3gjj7/ClnddcJCmsDdjdiAuxqrEd1PpjsmoqEub
         9hpXVr17m3GpDv/q2kcyTyob3rn1e4ziLh2QWXQxz/LmDWNET6dhITR9YTgD0iTYihAr
         AUVrVPHs0UqAVLYzl9UhqP9eFrYm+qOKGTpMs3iUpKAUSLTHSNyXOymRK4TNTgFR31fZ
         qpOv9VoyiP6xb1FTSZ3C+tbh/3+QYXy63tmRNVqtUEI/CJ+9SsBnmMtjEjLReEKDPZGq
         RwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726262; x=1707331062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GHBE4j9OJW7ACHTyD2S0iFAVBBBT0rwoc72BcpaiA3w=;
        b=t7uT7IXXzqX9UPN1iJthskulKnyfUJH/OxX7GnkF7entAWXIF2obAfsKIrmSGEyDnC
         mo5k2KPxwwEFR/NLNGg6TGeaFgmhfrAWSTd6QYhawisIKGM+JnLuFvUu4w8AcvE5qmh3
         M0C68wzfcGnXwr7cspmxe3hu7h8GR6XRpcuQj3izzpPacjECHRFm0wr0ELnhXYl6ajmq
         qEDtUZAveJ4ylcilZUSbi/Drdu9x8dLpIBqaQnp/1ReWEBUsEWGeab/WfAb6VWdrFfj3
         GHoBO7ZKT6bjLZQTjf5X9GirlemcdzMj0QXVewrb+0Eue3ATQbxYMmJbASx8KNur0Vwl
         ZRrw==
X-Gm-Message-State: AOJu0YyiFp55zxHJ5/uvpcLzh2OvBW3o3NcFvcYU7wew3fBe3sUnALID
	FteZ5+FDyHge3D7iDwaRo7bg5ufM5Cl3L8zb1+LftX4LPb4+cKvFrUZjbSLs
X-Google-Smtp-Source: AGHT+IEYSrwarrkWdlltkJnYQWPcIljcxM05Q2XThEi3xFgq3wn5DFDwH2mb8QA3/kHaem4cUdIFWA==
X-Received: by 2002:ad4:4e32:0:b0:686:9faf:6f10 with SMTP id dm18-20020ad44e32000000b006869faf6f10mr297590qvb.0.1706726261390;
        Wed, 31 Jan 2024 10:37:41 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:41 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 15/17] lpfc: Change lpfc_vport load_flag member into a bitmask
Date: Wed, 31 Jan 2024 10:51:10 -0800
Message-Id: <20240131185112.149731-16-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In attempt to reduce the amount of unnecessary shost_lock acquisitions in
the lpfc driver, change load_flag into an unsigned long bitmask and use
clear_bit/test_bit bitwise atomic APIs instead of reliance on shost_lock
for synchronization.

Also, correct the test for FC_UNLOADING in lpfc_ct_handle_mibreq, which
incorrectly tests vport->fc_flag rather than vport->load_flag.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h           | 15 ++++---
 drivers/scsi/lpfc/lpfc_ct.c        | 11 ++---
 drivers/scsi/lpfc/lpfc_els.c       | 22 +++++-----
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 26 ++++++------
 drivers/scsi/lpfc/lpfc_init.c      | 64 +++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_nportdisc.c | 13 +++---
 drivers/scsi/lpfc/lpfc_nvme.c      | 18 ++++-----
 drivers/scsi/lpfc/lpfc_nvmet.c     | 12 +++---
 drivers/scsi/lpfc/lpfc_sli.c       | 24 +++++------
 drivers/scsi/lpfc/lpfc_vport.c     | 23 +++++------
 10 files changed, 108 insertions(+), 120 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 18c0adceaa6f..b863f87ff9e7 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -565,6 +565,14 @@ enum lpfc_fc_flag {
 	FC_DISC_DELAYED,		/* Delay NPort discovery */
 };
 
+enum lpfc_load_flag {
+	FC_LOADING,			/* HBA in process of loading drvr */
+	FC_UNLOADING,			/* HBA in process of unloading drvr */
+	FC_ALLOW_FDMI,			/* port is ready for FDMI requests */
+	FC_ALLOW_VMID,			/* Allow VMID I/Os */
+	FC_DEREGISTER_ALL_APP_ID	/* Deregister all VMIDs */
+};
+
 struct lpfc_vport {
 	struct lpfc_hba *phba;
 	struct list_head listentry;
@@ -647,12 +655,7 @@ struct lpfc_vport {
 	struct timer_list els_tmofunc;
 	struct timer_list delayed_disc_tmo;
 
-	uint8_t load_flag;
-#define FC_LOADING		0x1	/* HBA in process of loading drvr */
-#define FC_UNLOADING		0x2	/* HBA in process of unloading drvr */
-#define FC_ALLOW_FDMI		0x4	/* port is ready for FDMI requests */
-#define FC_ALLOW_VMID		0x8	/* Allow VMID I/Os */
-#define FC_DEREGISTER_ALL_APP_ID	0x10	/* Deregister all VMIDs */
+	unsigned long load_flag;
 	/* Vport Config Parameters */
 	uint32_t cfg_scan_down;
 	uint32_t cfg_lun_queue_depth;
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 20520c7f58f6..2a0c6a4df090 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -298,7 +298,7 @@ lpfc_ct_handle_mibreq(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocbq)
 	}
 
 	/* Ignore traffic received during vport shutdown */
-	if (test_bit(FC_UNLOADING, &vport->fc_flag))
+	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		return;
 
 	ndlp = lpfc_findnode_did(vport, did);
@@ -943,7 +943,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 
 	/* Skip processing response on pport if unloading */
-	if (vport == phba->pport && vport->load_flag & FC_UNLOADING) {
+	if (vport == phba->pport && test_bit(FC_UNLOADING, &vport->load_flag)) {
 		if (test_bit(FC_RSCN_MODE, &vport->fc_flag))
 			lpfc_els_flush_rscn(vport);
 		goto out;
@@ -1159,7 +1159,7 @@ lpfc_cmpl_ct_cmd_gid_pt(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 
 	/* Skip processing response on pport if unloading */
-	if (vport == phba->pport && vport->load_flag & FC_UNLOADING) {
+	if (vport == phba->pport && test_bit(FC_UNLOADING, &vport->load_flag)) {
 		if (test_bit(FC_RSCN_MODE, &vport->fc_flag))
 			lpfc_els_flush_rscn(vport);
 		goto out;
@@ -3583,7 +3583,8 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		    (ctrsp->Explanation != SLI_CT_APP_ID_NOT_AVAILABLE)) {
 			/* If DALLAPP_ID failed retry later */
 			if (cmd == SLI_CTAS_DALLAPP_ID)
-				vport->load_flag |= FC_DEREGISTER_ALL_APP_ID;
+				set_bit(FC_DEREGISTER_ALL_APP_ID,
+					&vport->load_flag);
 			goto free_res;
 		}
 	}
@@ -3639,7 +3640,7 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (!hash_empty(vport->hash_table))
 			hash_for_each(vport->hash_table, bucket, cur, hnode)
 				hash_del(&cur->hnode);
-		vport->load_flag |= FC_ALLOW_VMID;
+		set_bit(FC_ALLOW_VMID, &vport->load_flag);
 		break;
 	default:
 		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4c2666494e49..143f32b63249 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4964,7 +4964,7 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		retry = 0;
 	}
 
-	if ((vport->load_flag & FC_UNLOADING) != 0)
+	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		retry = 0;
 
 out_retry:
@@ -8232,7 +8232,7 @@ lpfc_els_handle_rscn(struct lpfc_vport *vport)
 	struct lpfc_hba  *phba = vport->phba;
 
 	/* Ignore RSCN if the port is being torn down. */
-	if (vport->load_flag & FC_UNLOADING) {
+	if (test_bit(FC_UNLOADING, &vport->load_flag)) {
 		lpfc_els_flush_rscn(vport);
 		return 0;
 	}
@@ -9449,11 +9449,11 @@ lpfc_els_timeout(struct timer_list *t)
 
 	spin_lock_irqsave(&vport->work_port_lock, iflag);
 	tmo_posted = vport->work_port_events & WORKER_ELS_TMO;
-	if ((!tmo_posted) && (!(vport->load_flag & FC_UNLOADING)))
+	if (!tmo_posted && !test_bit(FC_UNLOADING, &vport->load_flag))
 		vport->work_port_events |= WORKER_ELS_TMO;
 	spin_unlock_irqrestore(&vport->work_port_lock, iflag);
 
-	if ((!tmo_posted) && (!(vport->load_flag & FC_UNLOADING)))
+	if (!tmo_posted && !test_bit(FC_UNLOADING, &vport->load_flag))
 		lpfc_worker_wake_up(phba);
 	return;
 }
@@ -9489,7 +9489,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 	if (unlikely(!pring))
 		return;
 
-	if (phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		return;
 
 	spin_lock_irq(&phba->hbalock);
@@ -9565,7 +9565,7 @@ lpfc_els_timeout_handler(struct lpfc_vport *vport)
 	lpfc_issue_hb_tmo(phba);
 
 	if (!list_empty(&pring->txcmplq))
-		if (!(phba->pport->load_flag & FC_UNLOADING))
+		if (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 			mod_timer(&vport->els_tmofunc,
 				  jiffies + msecs_to_jiffies(1000 * timeout));
 }
@@ -10364,7 +10364,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		goto dropit;
 
 	/* Ignore traffic received during vport shutdown. */
-	if (vport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		goto dropit;
 
 	/* If NPort discovery is delayed drop incoming ELS */
@@ -10785,7 +10785,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	return;
 
 dropit:
-	if (vport && !(vport->load_flag & FC_UNLOADING))
+	if (vport && !test_bit(FC_UNLOADING, &vport->load_flag))
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			"0111 Dropping received ELS cmd "
 			"Data: x%x x%x x%x x%x\n",
@@ -10981,8 +10981,8 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 	}
 
 	if ((phba->cfg_enable_SmartSAN ||
-	     (phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT)) &&
-	     (vport->load_flag & FC_ALLOW_FDMI))
+	     phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT) &&
+	    test_bit(FC_ALLOW_FDMI, &vport->load_flag))
 		lpfc_start_fdmi(vport);
 }
 
@@ -12014,7 +12014,7 @@ lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *vport)
 			 * node and the vport is unloading, the xri aborted wcqe
 			 * likely isn't coming back.  Just release the sgl.
 			 */
-			if ((vport->load_flag & FC_UNLOADING) &&
+			if (test_bit(FC_UNLOADING, &vport->load_flag) &&
 			    ndlp->nlp_DID == Fabric_DID) {
 				list_del(&sglq_entry->list);
 				sglq_entry->state = SGL_FREED;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 42695159f697..f97817ac463d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -169,13 +169,13 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
 			 "3181 dev_loss_callbk x%06x, rport x%px flg x%x "
-			 "load_flag x%x refcnt %u state %d xpt x%x\n",
+			 "load_flag x%lx refcnt %u state %d xpt x%x\n",
 			 ndlp->nlp_DID, ndlp->rport, ndlp->nlp_flag,
 			 vport->load_flag, kref_read(&ndlp->kref),
 			 ndlp->nlp_state, ndlp->fc4_xpt_flags);
 
 	/* Don't schedule a worker thread event if the vport is going down. */
-	if (vport->load_flag & FC_UNLOADING) {
+	if (test_bit(FC_UNLOADING, &vport->load_flag)) {
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
 
@@ -263,7 +263,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	} else {
 		lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
 				 "3188 worker thread is stopped %s x%06x, "
-				 " rport x%px flg x%x load_flag x%x refcnt "
+				 " rport x%px flg x%x load_flag x%lx refcnt "
 				 "%d\n", __func__, ndlp->nlp_DID,
 				 ndlp->rport, ndlp->nlp_flag,
 				 vport->load_flag, kref_read(&ndlp->kref));
@@ -911,7 +911,7 @@ lpfc_work_list_done(struct lpfc_hba *phba)
 			free_evt = 0;
 			break;
 		case LPFC_EVT_RESET_HBA:
-			if (!(phba->pport->load_flag & FC_UNLOADING))
+			if (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 				lpfc_reset_hba(phba);
 			break;
 		}
@@ -1358,7 +1358,7 @@ lpfc_linkup_port(struct lpfc_vport *vport)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 
-	if ((vport->load_flag & FC_UNLOADING) != 0)
+	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		return;
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
@@ -3924,7 +3924,7 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 			"2798 Unreg_vpi failed vpi 0x%x, mb status = 0x%x\n",
 			vport->vpi, mb->mbxStatus);
-		if (!(phba->pport->load_flag & FC_UNLOADING))
+		if (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 			lpfc_workq_post_event(phba, NULL, NULL,
 				LPFC_EVT_RESET_HBA);
 	}
@@ -3939,7 +3939,7 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	 * This shost reference might have been taken at the beginning of
 	 * lpfc_vport_delete()
 	 */
-	if ((vport->load_flag & FC_UNLOADING) && (vport != phba->pport))
+	if (test_bit(FC_UNLOADING, &vport->load_flag) && vport != phba->pport)
 		scsi_host_put(shost);
 }
 
@@ -4490,7 +4490,7 @@ lpfc_register_remote_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			      ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
 	/* Don't add the remote port if unloading. */
-	if (vport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		return;
 
 	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
@@ -5235,13 +5235,13 @@ lpfc_set_unreg_login_mbx_cmpl(struct lpfc_hba *phba, struct lpfc_vport *vport,
 		mbox->mbox_cmpl = lpfc_nlp_logo_unreg;
 
 	} else if (phba->sli_rev == LPFC_SLI_REV4 &&
-		   (!(vport->load_flag & FC_UNLOADING)) &&
+		   !test_bit(FC_UNLOADING, &vport->load_flag) &&
 		    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) >=
 				      LPFC_SLI_INTF_IF_TYPE_2) &&
 		    (kref_read(&ndlp->kref) > 0)) {
 		mbox->mbox_cmpl = lpfc_sli4_unreg_rpi_cmpl_clr;
 	} else {
-		if (vport->load_flag & FC_UNLOADING) {
+		if (test_bit(FC_UNLOADING, &vport->load_flag)) {
 			if (phba->sli_rev == LPFC_SLI_REV4) {
 				spin_lock_irqsave(&ndlp->lock, iflags);
 				ndlp->nlp_flag |= NLP_RELEASE_RPI;
@@ -5349,7 +5349,7 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			 * will issue a LOGO here and keep the rpi alive if
 			 * not unloading.
 			 */
-			if (!(vport->load_flag & FC_UNLOADING)) {
+			if (!test_bit(FC_UNLOADING, &vport->load_flag)) {
 				ndlp->nlp_flag &= ~NLP_UNREG_INP;
 				lpfc_issue_els_logo(vport, ndlp, 0);
 				ndlp->nlp_prev_state = ndlp->nlp_state;
@@ -6925,8 +6925,8 @@ lpfc_unregister_fcf_rescan(struct lpfc_hba *phba)
 	 * If driver is not unloading, check if there is any other
 	 * FCF record that can be used for discovery.
 	 */
-	if ((phba->pport->load_flag & FC_UNLOADING) ||
-	    (phba->link_state < LPFC_LINK_UP))
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag) ||
+	    phba->link_state < LPFC_LINK_UP)
 		return;
 
 	/* This is considered as the initial FCF discovery scan */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a71171669972..345a7d5784d8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -892,7 +892,7 @@ lpfc_hba_down_prep(struct lpfc_hba *phba)
 		readl(phba->HCregaddr); /* flush */
 	}
 
-	if (phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		lpfc_cleanup_discovery_resources(phba->pport);
 	else {
 		vports = lpfc_create_vport_work_array(phba);
@@ -1232,13 +1232,13 @@ lpfc_rrq_timeout(struct timer_list *t)
 
 	phba = from_timer(phba, t, rrq_tmr);
 	spin_lock_irqsave(&phba->pport->work_port_lock, iflag);
-	if (!(phba->pport->load_flag & FC_UNLOADING))
+	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		phba->hba_flag |= HBA_RRQ_ACTIVE;
 	else
 		phba->hba_flag &= ~HBA_RRQ_ACTIVE;
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflag);
 
-	if (!(phba->pport->load_flag & FC_UNLOADING))
+	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		lpfc_worker_wake_up(phba);
 }
 
@@ -1271,7 +1271,7 @@ lpfc_hb_mbox_cmpl(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq)
 	mempool_free(pmboxq, phba->mbox_mem_pool);
 	if (!test_bit(FC_OFFLINE_MODE, &phba->pport->fc_flag) &&
 	    !(phba->link_state == LPFC_HBA_ERROR) &&
-	    !(phba->pport->load_flag & FC_UNLOADING))
+	    !test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		mod_timer(&phba->hb_tmofunc,
 			  jiffies +
 			  msecs_to_jiffies(1000 * LPFC_HB_MBOX_INTERVAL));
@@ -1298,7 +1298,7 @@ lpfc_idle_stat_delay_work(struct work_struct *work)
 	u32 i, idle_percent;
 	u64 wall, wall_idle, diff_wall, diff_idle, busy_time;
 
-	if (phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		return;
 
 	if (phba->link_state == LPFC_HBA_ERROR ||
@@ -1359,7 +1359,8 @@ lpfc_hb_eq_delay_work(struct work_struct *work)
 	uint32_t usdelay;
 	int i;
 
-	if (!phba->cfg_auto_imax || phba->pport->load_flag & FC_UNLOADING)
+	if (!phba->cfg_auto_imax ||
+	    test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		return;
 
 	if (phba->link_state == LPFC_HBA_ERROR ||
@@ -1534,9 +1535,9 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
-	if ((phba->link_state == LPFC_HBA_ERROR) ||
-		(phba->pport->load_flag & FC_UNLOADING) ||
-		test_bit(FC_OFFLINE_MODE, &phba->pport->fc_flag))
+	if (phba->link_state == LPFC_HBA_ERROR ||
+	    test_bit(FC_UNLOADING, &phba->pport->load_flag) ||
+	    test_bit(FC_OFFLINE_MODE, &phba->pport->fc_flag))
 		return;
 
 	if (phba->elsbuf_cnt &&
@@ -1737,7 +1738,7 @@ lpfc_handle_deferred_eratt(struct lpfc_hba *phba)
 			break;
 		}
 		/* If driver is unloading let the worker thread continue */
-		if (phba->pport->load_flag & FC_UNLOADING) {
+		if (test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
 			phba->work_hs = 0;
 			break;
 		}
@@ -1748,7 +1749,7 @@ lpfc_handle_deferred_eratt(struct lpfc_hba *phba)
 	 * first write to the host attention register clear the
 	 * host status register.
 	 */
-	if ((!phba->work_hs) && (!(phba->pport->load_flag & FC_UNLOADING)))
+	if (!phba->work_hs && !test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		phba->work_hs = old_host_status & ~HS_FFER1;
 
 	spin_lock_irq(&phba->hbalock);
@@ -3086,7 +3087,7 @@ lpfc_cleanup(struct lpfc_vport *vport)
 	 * The flush here is only when the pci slot
 	 * is offline.
 	 */
-	if (vport->load_flag & FC_UNLOADING &&
+	if (test_bit(FC_UNLOADING, &vport->load_flag) &&
 	    pci_channel_offline(phba->pcidev))
 		lpfc_sli_flush_io_rings(vport->phba);
 
@@ -3412,7 +3413,7 @@ lpfc_sli4_node_prep(struct lpfc_hba *phba)
 		return;
 
 	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
-		if (vports[i]->load_flag & FC_UNLOADING)
+		if (test_bit(FC_UNLOADING, &vports[i]->load_flag))
 			continue;
 
 		list_for_each_entry_safe(ndlp, next_ndlp,
@@ -3612,7 +3613,7 @@ static void lpfc_destroy_multixri_pools(struct lpfc_hba *phba)
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
 		lpfc_destroy_expedite_pool(phba);
 
-	if (!(phba->pport->load_flag & FC_UNLOADING))
+	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		lpfc_sli_flush_io_rings(phba);
 
 	hwq_count = phba->cfg_hdw_queue;
@@ -3818,7 +3819,7 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL) {
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
-			if (vports[i]->load_flag & FC_UNLOADING)
+			if (test_bit(FC_UNLOADING, &vports[i]->load_flag))
 				continue;
 			shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irq(shost->host_lock);
@@ -4764,7 +4765,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 
 	vport = (struct lpfc_vport *) shost->hostdata;
 	vport->phba = phba;
-	vport->load_flag |= FC_LOADING;
+	set_bit(FC_LOADING, &vport->load_flag);
 	set_bit(FC_VPORT_NEEDS_REG_VPI, &vport->fc_flag);
 	vport->fc_rscn_flush = 0;
 	atomic_set(&vport->fc_plogi_cnt, 0);
@@ -4928,7 +4929,7 @@ int lpfc_scan_finished(struct Scsi_Host *shost, unsigned long time)
 
 	spin_lock_irq(shost->host_lock);
 
-	if (vport->load_flag & FC_UNLOADING) {
+	if (test_bit(FC_UNLOADING, &vport->load_flag)) {
 		stat = 1;
 		goto finished;
 	}
@@ -5042,9 +5043,7 @@ void lpfc_host_attrib_init(struct Scsi_Host *shost)
 	fc_host_active_fc4s(shost)[7] = 1;
 
 	fc_host_max_npiv_vports(shost) = phba->max_vpi;
-	spin_lock_irq(shost->host_lock);
-	vport->load_flag &= ~FC_LOADING;
-	spin_unlock_irq(shost->host_lock);
+	clear_bit(FC_LOADING, &vport->load_flag);
 }
 
 /**
@@ -5180,7 +5179,7 @@ lpfc_vmid_poll(struct timer_list *t)
 
 	/* Is the vmid inactivity timer enabled */
 	if (phba->pport->vmid_inactivity_timeout ||
-	    phba->pport->load_flag & FC_DEREGISTER_ALL_APP_ID) {
+	    test_bit(FC_DEREGISTER_ALL_APP_ID, &phba->pport->load_flag)) {
 		wake_up = 1;
 		phba->pport->work_port_events |= WORKER_CHECK_INACTIVE_VMID;
 	}
@@ -6914,8 +6913,8 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
 		 * If we are here first then vport_delete is going to wait
 		 * for discovery to complete.
 		 */
-		if (!(vport->load_flag & FC_UNLOADING) &&
-					active_vlink_present) {
+		if (!test_bit(FC_UNLOADING, &vport->load_flag) &&
+		    active_vlink_present) {
 			/*
 			 * If there are other active VLinks present,
 			 * re-instantiate the Vlink using FDISC.
@@ -9093,7 +9092,7 @@ lpfc_setup_fdmi_mask(struct lpfc_vport *vport)
 {
 	struct lpfc_hba *phba = vport->phba;
 
-	vport->load_flag |= FC_ALLOW_FDMI;
+	set_bit(FC_ALLOW_FDMI, &vport->load_flag);
 	if (phba->cfg_enable_SmartSAN ||
 	    phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT) {
 		/* Setup appropriate attribute masks */
@@ -12805,7 +12804,7 @@ static void lpfc_cpuhp_add(struct lpfc_hba *phba)
 
 static int __lpfc_cpuhp_checks(struct lpfc_hba *phba, int *retval)
 {
-	if (phba->pport->load_flag & FC_UNLOADING) {
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
 		*retval = -EAGAIN;
 		return true;
 	}
@@ -13325,12 +13324,7 @@ lpfc_sli4_disable_intr(struct lpfc_hba *phba)
 static void
 lpfc_unset_hba(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport = phba->pport;
-	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
-
-	spin_lock_irq(shost->host_lock);
-	vport->load_flag |= FC_UNLOADING;
-	spin_unlock_irq(shost->host_lock);
+	set_bit(FC_UNLOADING, &phba->pport->load_flag);
 
 	kfree(phba->vpi_bmask);
 	kfree(phba->vpi_ids);
@@ -14122,9 +14116,7 @@ lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 	struct lpfc_hba   *phba = vport->phba;
 	int i;
 
-	spin_lock_irq(&phba->hbalock);
-	vport->load_flag |= FC_UNLOADING;
-	spin_unlock_irq(&phba->hbalock);
+	set_bit(FC_UNLOADING, &vport->load_flag);
 
 	lpfc_free_sysfs_attr(vport);
 
@@ -14967,9 +14959,7 @@ lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 	int i;
 
 	/* Mark the device unloading flag */
-	spin_lock_irq(&phba->hbalock);
-	vport->load_flag |= FC_UNLOADING;
-	spin_unlock_irq(&phba->hbalock);
+	set_bit(FC_UNLOADING, &vport->load_flag);
 	if (phba->cgn_i)
 		lpfc_unreg_congestion_buf(phba);
 
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index ab9b3585492c..24f171045abe 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -859,8 +859,8 @@ lpfc_rcv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 * If we are here first then vport_delete is going to wait
 		 * for discovery to complete.
 		 */
-		if (!(vport->load_flag & FC_UNLOADING) &&
-					active_vlink_present) {
+		if (!test_bit(FC_UNLOADING, &vport->load_flag) &&
+		    active_vlink_present) {
 			/*
 			 * If there are other active VLinks present,
 			 * re-instantiate the Vlink using FDISC.
@@ -1145,9 +1145,8 @@ lpfc_disc_illegal(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	phba = vport->phba;
 	/* Release the RPI if reglogin completing */
-	if (!(phba->pport->load_flag & FC_UNLOADING) &&
-		(evt == NLP_EVT_CMPL_REG_LOGIN) &&
-		(!pmb->u.mb.mbxStatus)) {
+	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag) &&
+	    evt == NLP_EVT_CMPL_REG_LOGIN && !pmb->u.mb.mbxStatus) {
 		rpi = pmb->u.mb.un.varWords[0];
 		lpfc_release_rpi(phba, vport, ndlp, rpi);
 	}
@@ -1571,8 +1570,8 @@ lpfc_cmpl_reglogin_plogi_issue(struct lpfc_vport *vport,
 
 	phba = vport->phba;
 	/* Release the RPI */
-	if (!(phba->pport->load_flag & FC_UNLOADING) &&
-		!mb->mbxStatus) {
+	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag) &&
+	    !mb->mbxStatus) {
 		rpi = pmb->u.mb.un.varWords[0];
 		lpfc_release_rpi(phba, vport, ndlp, rpi);
 	}
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 128fc1bab586..c3daf158bc2a 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -94,7 +94,7 @@ lpfc_nvme_create_queue(struct nvme_fc_local_port *pnvme_lport,
 	lport = (struct lpfc_nvme_lport *)pnvme_lport->private;
 	vport = lport->vport;
 
-	if (!vport || vport->load_flag & FC_UNLOADING ||
+	if (!vport || test_bit(FC_UNLOADING, &vport->load_flag) ||
 	    vport->phba->hba_flag & HBA_IOQ_FLUSH)
 		return -ENODEV;
 
@@ -674,7 +674,7 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 		return -EINVAL;
 
 	vport = lport->vport;
-	if (vport->load_flag & FC_UNLOADING ||
+	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
 	    vport->phba->hba_flag & HBA_IOQ_FLUSH)
 		return -ENODEV;
 
@@ -765,7 +765,7 @@ lpfc_nvme_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 	struct lpfc_nvme_lport *lport;
 	int rc;
 
-	if (axchg->phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &axchg->phba->pport->load_flag))
 		return -ENODEV;
 
 	lport = (struct lpfc_nvme_lport *)localport->private;
@@ -810,7 +810,7 @@ lpfc_nvme_ls_abort(struct nvme_fc_local_port *pnvme_lport,
 		return;
 	vport = lport->vport;
 
-	if (vport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		return;
 
 	ndlp = lpfc_findnode_did(vport, pnvme_rport->port_id);
@@ -1567,7 +1567,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 
 	phba = vport->phba;
 
-	if ((unlikely(vport->load_flag & FC_UNLOADING)) ||
+	if ((unlikely(test_bit(FC_UNLOADING, &vport->load_flag))) ||
 	    phba->hba_flag & HBA_IOQ_FLUSH) {
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_IOERR,
 				 "6124 Fail IO, Driver unload\n");
@@ -1886,7 +1886,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 
 	if (unlikely(!freqpriv))
 		return;
-	if (vport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		return;
 
 	/* Announce entry to new IO submit field. */
@@ -2263,7 +2263,7 @@ lpfc_nvme_lport_unreg_wait(struct lpfc_vport *vport,
 			if (!vport->localport ||
 			    test_bit(HBA_PCI_ERR, &vport->phba->bit_flags) ||
 			    phba->link_state == LPFC_HBA_ERROR ||
-			    vport->load_flag & FC_UNLOADING)
+			    test_bit(FC_UNLOADING, &vport->load_flag))
 				return;
 
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
@@ -2625,7 +2625,7 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 		 * return values is ignored.  The upcall is a courtesy to the
 		 * transport.
 		 */
-		if (vport->load_flag & FC_UNLOADING ||
+		if (test_bit(FC_UNLOADING, &vport->load_flag) ||
 		    unlikely(vport->phba->link_state == LPFC_HBA_ERROR))
 			(void)nvme_fc_set_remoteport_devloss(remoteport, 0);
 
@@ -2644,7 +2644,7 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 					 "port_state x%x\n",
 					 ret, remoteport->port_state);
 
-			if (vport->load_flag & FC_UNLOADING) {
+			if (test_bit(FC_UNLOADING, &vport->load_flag)) {
 				/* Only 1 thread can drop the initial node
 				 * reference. Check if another thread has set
 				 * NLP_DROPPED.
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 425328d9c2d8..255189eda388 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -872,7 +872,7 @@ __lpfc_nvme_xmt_ls_rsp(struct lpfc_async_xchg_ctx *axchg,
 	struct ulp_bde64 bpl;
 	int rc;
 
-	if (phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		return -ENODEV;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_DISC,
@@ -984,7 +984,7 @@ lpfc_nvmet_xmt_ls_rsp(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_nvmet_tgtport *nvmep = tgtport->private;
 	int rc;
 
-	if (axchg->phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &axchg->phba->pport->load_flag))
 		return -ENODEV;
 
 	rc = __lpfc_nvme_xmt_ls_rsp(axchg, ls_rsp, lpfc_nvmet_xmt_ls_rsp_cmp);
@@ -1022,7 +1022,7 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 	int id;
 #endif
 
-	if (phba->pport->load_flag & FC_UNLOADING) {
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
 		rc = -ENODEV;
 		goto aerr;
 	}
@@ -1145,7 +1145,7 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_queue *wq;
 	unsigned long flags;
 
-	if (phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		return;
 
 	if (!ctxp->hdwq)
@@ -1317,7 +1317,7 @@ lpfc_nvmet_ls_req(struct nvmet_fc_target_port *targetport,
 		return -EINVAL;
 
 	phba = lpfc_nvmet->phba;
-	if (phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		return -EINVAL;
 
 	hstate = atomic_read(&lpfc_nvmet->state);
@@ -1353,7 +1353,7 @@ lpfc_nvmet_ls_abort(struct nvmet_fc_target_port *targetport,
 	int ret;
 
 	phba = lpfc_nvmet->phba;
-	if (phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		return;
 
 	ndlp = (struct lpfc_nodelist *)hosthandle;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4b21c4d33533..1aad39015ee0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1036,7 +1036,7 @@ lpfc_handle_rrq_active(struct lpfc_hba *phba)
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if ((!list_empty(&phba->active_rrq_list)) &&
-	    (!(phba->pport->load_flag & FC_UNLOADING)))
+	    (!test_bit(FC_UNLOADING, &phba->pport->load_flag)))
 		mod_timer(&phba->rrq_tmr, next_time);
 	list_for_each_entry_safe(rrq, nextrrq, &send_rrq, list) {
 		list_del(&rrq->list);
@@ -1180,12 +1180,12 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 		return -EINVAL;
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
-	if (phba->pport->load_flag & FC_UNLOADING) {
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
 		phba->hba_flag &= ~HBA_RRQ_ACTIVE;
 		goto out;
 	}
 
-	if (ndlp->vport && (ndlp->vport->load_flag & FC_UNLOADING))
+	if (ndlp->vport && test_bit(FC_UNLOADING, &ndlp->vport->load_flag))
 		goto out;
 
 	if (!ndlp->active_rrqs_xri_bitmap)
@@ -1732,7 +1732,7 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	   (ulp_command != CMD_ABORT_XRI_CN) &&
 	   (ulp_command != CMD_CLOSE_XRI_CN)) {
 		BUG_ON(!piocb->vport);
-		if (!(piocb->vport->load_flag & FC_UNLOADING))
+		if (!test_bit(FC_UNLOADING, &piocb->vport->load_flag))
 			mod_timer(&piocb->vport->els_tmofunc,
 				  jiffies +
 				  msecs_to_jiffies(1000 * (phba->fc_ratov << 1)));
@@ -2882,7 +2882,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	 * If a REG_LOGIN succeeded  after node is destroyed or node
 	 * is in re-discovery driver need to cleanup the RPI.
 	 */
-	if (!(phba->pport->load_flag & FC_UNLOADING) &&
+	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag) &&
 	    pmb->u.mb.mbxCommand == MBX_REG_LOGIN64 &&
 	    !pmb->u.mb.mbxStatus) {
 		mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
@@ -2904,7 +2904,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	if ((pmb->u.mb.mbxCommand == MBX_REG_VPI) &&
-		!(phba->pport->load_flag & FC_UNLOADING) &&
+		!test_bit(FC_UNLOADING, &phba->pport->load_flag) &&
 		!pmb->u.mb.mbxStatus) {
 		shost = lpfc_shost_from_vport(vport);
 		spin_lock_irq(shost->host_lock);
@@ -2927,7 +2927,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				vport,
 				KERN_INFO, LOG_MBOX | LOG_DISCOVERY,
 				"1438 UNREG cmpl deferred mbox x%x "
-				"on NPort x%x Data: x%x x%x x%px x%x x%x\n",
+				"on NPort x%x Data: x%x x%x x%px x%lx x%x\n",
 				ndlp->nlp_rpi, ndlp->nlp_DID,
 				ndlp->nlp_flag, ndlp->nlp_defer_did,
 				ndlp, vport->load_flag, kref_read(&ndlp->kref));
@@ -3235,7 +3235,7 @@ lpfc_nvme_unsol_ls_handler(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 	lpfc_nvmeio_data(phba, "NVME LS    RCV: xri x%x sz %d from %06x\n",
 			 oxid, size, sid);
 
-	if (phba->pport->load_flag & FC_UNLOADING) {
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
 		failwhy = "Driver Unloading";
 	} else if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)) {
 		failwhy = "NVME FC4 Disabled";
@@ -3940,7 +3940,7 @@ void lpfc_poll_eratt(struct timer_list *t)
 	if (!(phba->hba_flag & HBA_SETUP))
 		return;
 
-	if (phba->pport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		return;
 
 	/* Here we will also keep track of interrupts per sec of the hba */
@@ -12428,7 +12428,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	 * If we're unloading, don't abort iocb on the ELS ring, but change
 	 * the callback so that nothing happens when it finishes.
 	 */
-	if ((vport->load_flag & FC_UNLOADING) &&
+	if (test_bit(FC_UNLOADING, &vport->load_flag) &&
 	    pring->ringno == LPFC_ELS_RING) {
 		if (cmdiocb->cmd_flag & LPFC_IO_FABRIC)
 			cmdiocb->fabric_cmd_cmpl = lpfc_ignore_els_cmpl;
@@ -14658,7 +14658,7 @@ lpfc_sli4_sp_handle_rcqe(struct lpfc_hba *phba, struct lpfc_rcqe *rcqe)
 		    fc_hdr->fh_r_ctl == FC_RCTL_DD_UNSOL_DATA) {
 			spin_unlock_irqrestore(&phba->hbalock, iflags);
 			/* Handle MDS Loopback frames */
-			if  (!(phba->pport->load_flag & FC_UNLOADING))
+			if  (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 				lpfc_sli4_handle_mds_loopback(phba->pport,
 							      dma_buf);
 			else
@@ -19457,7 +19457,7 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 	    fc_hdr->fh_r_ctl == FC_RCTL_DD_UNSOL_DATA) {
 		vport = phba->pport;
 		/* Handle MDS Loopback frames */
-		if  (!(phba->pport->load_flag & FC_UNLOADING))
+		if  (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 			lpfc_sli4_handle_mds_loopback(vport, dmabuf);
 		else
 			lpfc_in_buf_free(phba, &dmabuf->dbuf);
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index e2e0518e8387..35dc6b74cb01 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -408,7 +408,7 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 	vport->fc_vport = fc_vport;
 
 	/* At this point we are fully registered with SCSI Layer.  */
-	vport->load_flag |= FC_ALLOW_FDMI;
+	set_bit(FC_ALLOW_FDMI, &vport->load_flag);
 	if (phba->cfg_enable_SmartSAN ||
 	    (phba->cfg_fdmi_on == LPFC_FDMI_SUPPORT)) {
 		/* Setup appropriate attribute masks */
@@ -538,7 +538,7 @@ disable_vport(struct fc_vport *fc_vport)
 	struct lpfc_nodelist *ndlp = NULL;
 
 	/* Can't disable during an outstanding delete. */
-	if (vport->load_flag & FC_UNLOADING)
+	if (test_bit(FC_UNLOADING, &vport->load_flag))
 		return 0;
 
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
@@ -571,7 +571,6 @@ enable_vport(struct fc_vport *fc_vport)
 	struct lpfc_vport *vport = *(struct lpfc_vport **)fc_vport->dd_data;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp = NULL;
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	if ((phba->link_state < LPFC_LINK_UP) ||
 	    (phba->fc_topology == LPFC_TOPOLOGY_LOOP)) {
@@ -579,9 +578,7 @@ enable_vport(struct fc_vport *fc_vport)
 		return VPORT_OK;
 	}
 
-	spin_lock_irq(shost->host_lock);
-	vport->load_flag |= FC_LOADING;
-	spin_unlock_irq(shost->host_lock);
+	set_bit(FC_LOADING, &vport->load_flag);
 	if (test_bit(FC_VPORT_NEEDS_INIT_VPI, &vport->fc_flag)) {
 		lpfc_issue_init_vpi(vport);
 		goto out;
@@ -639,22 +636,20 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 
 	/* If the vport is a static vport fail the deletion. */
 	if ((vport->vport_flag & STATIC_VPORT) &&
-		!(phba->pport->load_flag & FC_UNLOADING)) {
+		!test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "1837 vport_delete failed: Cannot delete "
 				 "static vport.\n");
 		return VPORT_ERROR;
 	}
 
-	spin_lock_irq(&phba->hbalock);
-	vport->load_flag |= FC_UNLOADING;
-	spin_unlock_irq(&phba->hbalock);
+	set_bit(FC_UNLOADING, &vport->load_flag);
 
 	/*
 	 * If we are not unloading the driver then prevent the vport_delete
 	 * from happening until after this vport's discovery is finished.
 	 */
-	if (!(phba->pport->load_flag & FC_UNLOADING)) {
+	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
 		int check_count = 0;
 		while (check_count < ((phba->fc_ratov * 3) + 3) &&
 		       vport->port_state > LPFC_VPORT_FAILED &&
@@ -721,7 +716,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 			goto skip_logo;
 	}
 
-	if (!(phba->pport->load_flag & FC_UNLOADING))
+	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag))
 		lpfc_discovery_wait(vport);
 
 skip_logo:
@@ -732,7 +727,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	lpfc_sli_host_down(vport);
 	lpfc_stop_vport_timers(vport);
 
-	if (!(phba->pport->load_flag & FC_UNLOADING)) {
+	if (!test_bit(FC_UNLOADING, &phba->pport->load_flag)) {
 		lpfc_unreg_all_rpis(vport);
 		lpfc_unreg_default_rpis(vport);
 		/*
@@ -769,7 +764,7 @@ lpfc_create_vport_work_array(struct lpfc_hba *phba)
 		return NULL;
 	spin_lock_irq(&phba->port_list_lock);
 	list_for_each_entry(port_iterator, &phba->port_list, listentry) {
-		if (port_iterator->load_flag & FC_UNLOADING)
+		if (test_bit(FC_UNLOADING, &port_iterator->load_flag))
 			continue;
 		if (!scsi_host_get(lpfc_shost_from_vport(port_iterator))) {
 			lpfc_printf_vlog(port_iterator, KERN_ERR,
-- 
2.38.0

