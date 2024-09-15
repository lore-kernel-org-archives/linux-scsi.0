Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9EA1C57AA;
	Sun, 15 Sep 2024 12:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726405012; cv=none; b=P444VFlVtiJqd4sqoSrWigKb/iQH8SZ79dSsbPWHMB7qWcoeQXsvfTPLmpcxnFJ2p+REC7fsTRqEDerWqAG/D8LrJgySJ1JnhFar1XvOYipSVBs5xS9m3VUTp67HiUKcZPmzOGPK2YhG784eGCr8FubDK4AWJ11XQn0J37ir/nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726405012; c=relaxed/simple;
	bh=3n1IVgmxGMQkViHP5PCXZyubveKoIWkHxuRN3qubPYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyWL8KBNMxeCxj6lNx9upmUaIDFJ0VXj270cLmXcW040pGSXycw7VmY3AWrbX45xRDzncvDvl90AC9OJnsPEWmHt8fAl+QGGZPHrbARcDR/sxhdBauSB2Qm9kQ8F35OvEQbRe2txONAo2YOQSq1Is+TBWluWr6BO5zIsUjC2/JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=aPpwK6WS; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="aPpwK6WS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=OtC65taCBTGyOUicH7IEu9spCIW7iGdBJR8h6TIx1v8=; b=aPpwK6WSnnC6CLhF
	aoPIMIr/j0X/vTG1vl+2dpM9D6oE8bwYoh3X8GuWXoKR+APMxxPe+oA0PJrNEOVvLvqJkhWcnOfxW
	ZaVI9gl7gRmHR11cm7AEXjH9szUwp9ZPwMvu71kwnHzucEf7jWJNpeMPmdi5sQY432AhPY7HtDEZx
	JXhnFETcIe82DAefzEcG0GpvtdzJGc8D72L22/FybElIW4x0NoLPqfQMH8c1q/Gg51uuvWgxYRxTN
	O4ugf3AcYtSl1mKNPL+GjdWkdYHW9OtKAJ7D3qlLtTGq0fSKkWd5GbuF8YvjV5Z8A1RqWzsiuyEdt
	/76QwuAYQUHUiIvLDQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1spoo2-005pGt-14;
	Sun, 15 Sep 2024 12:56:46 +0000
From: linux@treblig.org
To: anil.gurumurthy@qlogic.com,
	sudarsana.kalluru@qlogic.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 4/5] scsi: bfa: Remove unused bfa_fcs code
Date: Sun, 15 Sep 2024 13:56:32 +0100
Message-ID: <20240915125633.25036-5-linux@treblig.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240915125633.25036-1-linux@treblig.org>
References: <20240915125633.25036-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

These functions aren't called anywhere, remove them.

Build tested only.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/bfa/bfa_defs_fcs.h  |  22 -----
 drivers/scsi/bfa/bfa_fcs.h       |  12 ---
 drivers/scsi/bfa/bfa_fcs_lport.c | 142 -------------------------------
 drivers/scsi/bfa/bfa_fcs_rport.c |  36 --------
 4 files changed, 212 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_defs_fcs.h b/drivers/scsi/bfa/bfa_defs_fcs.h
index 5e36620425ac..760606062c66 100644
--- a/drivers/scsi/bfa/bfa_defs_fcs.h
+++ b/drivers/scsi/bfa/bfa_defs_fcs.h
@@ -124,28 +124,6 @@ enum bfa_lport_offline_reason {
 	BFA_LPORT_OFFLINE_FAB_LOGOUT,
 };
 
-/*
- * FCS lport info.
- */
-struct bfa_lport_info_s {
-	u8	 port_type;	/* bfa_lport_type_t : physical or
-	 * virtual */
-	u8	 port_state;	/* one of bfa_lport_state values */
-	u8	 offline_reason;	/* one of bfa_lport_offline_reason_t
-	 * values */
-	wwn_t	   port_wwn;
-	wwn_t	   node_wwn;
-
-	/*
-	 * following 4 feilds are valid for Physical Ports only
-	 */
-	u32	max_vports_supp;	/* Max supported vports */
-	u32	num_vports_inuse;	/* Num of in use vports */
-	u32	max_rports_supp;	/* Max supported rports */
-	u32	num_rports_inuse;	/* Num of doscovered rports */
-
-};
-
 /*
  * FCS port statistics
  */
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 9788354b90da..19903539a08d 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -373,15 +373,11 @@ bfa_boolean_t   bfa_fcs_lport_is_online(struct bfa_fcs_lport_s *port);
 struct bfa_fcs_lport_s *bfa_fcs_get_base_port(struct bfa_fcs_s *fcs);
 void bfa_fcs_lport_get_rport_quals(struct bfa_fcs_lport_s *port,
 			struct bfa_rport_qualifier_s rport[], int *nrports);
-wwn_t bfa_fcs_lport_get_rport(struct bfa_fcs_lport_s *port, wwn_t wwn,
-			      int index, int nrports, bfa_boolean_t bwwn);
 
 struct bfa_fcs_lport_s *bfa_fcs_lookup_port(struct bfa_fcs_s *fcs,
 					    u16 vf_id, wwn_t lpwwn);
 
 void bfa_fcs_lport_set_symname(struct bfa_fcs_lport_s *port, char *symname);
-void bfa_fcs_lport_get_info(struct bfa_fcs_lport_s *port,
-			    struct bfa_lport_info_s *port_info);
 void bfa_fcs_lport_get_attr(struct bfa_fcs_lport_s *port,
 			    struct bfa_lport_attr_s *port_attr);
 void bfa_fcs_lport_get_stats(struct bfa_fcs_lport_s *fcs_port,
@@ -416,8 +412,6 @@ struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_old_pid(
 		struct bfa_fcs_lport_s *port, u32 pid);
 struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_pwwn(
 		struct bfa_fcs_lport_s *port, wwn_t pwwn);
-struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_nwwn(
-		struct bfa_fcs_lport_s *port, wwn_t nwwn);
 struct bfa_fcs_rport_s *bfa_fcs_lport_get_rport_by_qualifier(
 		struct bfa_fcs_lport_s *port, wwn_t pwwn, u32 pid);
 void            bfa_fcs_lport_add_rport(struct bfa_fcs_lport_s *port,
@@ -486,7 +480,6 @@ bfa_status_t bfa_fcs_pbc_vport_create(struct bfa_fcs_vport_s *vport,
 				      struct bfa_fcs_s *fcs, u16 vf_id,
 				      struct bfa_lport_cfg_s *port_cfg,
 				      struct bfad_vport_s *vport_drv);
-bfa_boolean_t bfa_fcs_is_pbc_vport(struct bfa_fcs_vport_s *vport);
 bfa_status_t bfa_fcs_vport_delete(struct bfa_fcs_vport_s *vport);
 bfa_status_t bfa_fcs_vport_start(struct bfa_fcs_vport_s *vport);
 bfa_status_t bfa_fcs_vport_stop(struct bfa_fcs_vport_s *vport);
@@ -494,7 +487,6 @@ void bfa_fcs_vport_get_attr(struct bfa_fcs_vport_s *vport,
 			    struct bfa_vport_attr_s *vport_attr);
 struct bfa_fcs_vport_s *bfa_fcs_vport_lookup(struct bfa_fcs_s *fcs,
 					     u16 vf_id, wwn_t vpwwn);
-void bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_online(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport);
 void bfa_fcs_vport_delete_comp(struct bfa_fcs_vport_s *vport);
@@ -623,8 +615,6 @@ void bfa_fcs_rport_get_attr(struct bfa_fcs_rport_s *rport,
 			struct bfa_rport_attr_s *attr);
 struct bfa_fcs_rport_s *bfa_fcs_rport_lookup(struct bfa_fcs_lport_s *port,
 					     wwn_t rpwwn);
-struct bfa_fcs_rport_s *bfa_fcs_rport_lookup_by_nwwn(
-	struct bfa_fcs_lport_s *port, wwn_t rnwwn);
 void bfa_fcs_rport_set_del_timeout(u8 rport_tmo);
 void bfa_fcs_rport_set_max_logins(u32 max_logins);
 void bfa_fcs_rport_uf_recv(struct bfa_fcs_rport_s *rport,
@@ -633,8 +623,6 @@ void bfa_fcs_rport_scn(struct bfa_fcs_rport_s *rport);
 
 struct bfa_fcs_rport_s *bfa_fcs_rport_create(struct bfa_fcs_lport_s *port,
 	 u32 pid);
-void bfa_fcs_rport_start(struct bfa_fcs_lport_s *port, struct fchs_s *rx_fchs,
-			 struct fc_logi_s *plogi_rsp);
 void bfa_fcs_rport_plogi_create(struct bfa_fcs_lport_s *port,
 				struct fchs_s *rx_fchs,
 				struct fc_logi_s *plogi);
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 966bf6cc6dd9..9a85f417018f 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -937,25 +937,6 @@ bfa_fcs_lport_get_rport_by_pwwn(struct bfa_fcs_lport_s *port, wwn_t pwwn)
 	return NULL;
 }
 
-/*
- *   NWWN based Lookup for a R-Port in the Port R-Port Queue
- */
-struct bfa_fcs_rport_s *
-bfa_fcs_lport_get_rport_by_nwwn(struct bfa_fcs_lport_s *port, wwn_t nwwn)
-{
-	struct bfa_fcs_rport_s *rport;
-	struct list_head	*qe;
-
-	list_for_each(qe, &port->rport_q) {
-		rport = (struct bfa_fcs_rport_s *) qe;
-		if (wwn_is_equal(rport->nwwn, nwwn))
-			return rport;
-	}
-
-	bfa_trc(port->fcs, nwwn);
-	return NULL;
-}
-
 /*
  * PWWN & PID based Lookup for a R-Port in the Port R-Port Queue
  */
@@ -5645,54 +5626,6 @@ bfa_fcs_get_base_port(struct bfa_fcs_s *fcs)
 	return &fcs->fabric.bport;
 }
 
-wwn_t
-bfa_fcs_lport_get_rport(struct bfa_fcs_lport_s *port, wwn_t wwn, int index,
-		int nrports, bfa_boolean_t bwwn)
-{
-	struct list_head	*qh, *qe;
-	struct bfa_fcs_rport_s *rport = NULL;
-	int	i;
-	struct bfa_fcs_s	*fcs;
-
-	if (port == NULL || nrports == 0)
-		return (wwn_t) 0;
-
-	fcs = port->fcs;
-	bfa_trc(fcs, (u32) nrports);
-
-	i = 0;
-	qh = &port->rport_q;
-	qe = bfa_q_first(qh);
-
-	while ((qe != qh) && (i < nrports)) {
-		rport = (struct bfa_fcs_rport_s *) qe;
-		if (bfa_ntoh3b(rport->pid) > 0xFFF000) {
-			qe = bfa_q_next(qe);
-			bfa_trc(fcs, (u32) rport->pwwn);
-			bfa_trc(fcs, rport->pid);
-			bfa_trc(fcs, i);
-			continue;
-		}
-
-		if (bwwn) {
-			if (!memcmp(&wwn, &rport->pwwn, 8))
-				break;
-		} else {
-			if (i == index)
-				break;
-		}
-
-		i++;
-		qe = bfa_q_next(qe);
-	}
-
-	bfa_trc(fcs, i);
-	if (rport)
-		return rport->pwwn;
-	else
-		return (wwn_t) 0;
-}
-
 void
 bfa_fcs_lport_get_rport_quals(struct bfa_fcs_lport_s *port,
 		struct bfa_rport_qualifier_s rports[], int *nrports)
@@ -5823,54 +5756,6 @@ bfa_fcs_lookup_port(struct bfa_fcs_s *fcs, u16 vf_id, wwn_t lpwwn)
 	return NULL;
 }
 
-/*
- *  API corresponding to NPIV_VPORT_GETINFO.
- */
-void
-bfa_fcs_lport_get_info(struct bfa_fcs_lport_s *port,
-	 struct bfa_lport_info_s *port_info)
-{
-
-	bfa_trc(port->fcs, port->fabric->fabric_name);
-
-	if (port->vport == NULL) {
-		/*
-		 * This is a Physical port
-		 */
-		port_info->port_type = BFA_LPORT_TYPE_PHYSICAL;
-
-		/*
-		 * @todo : need to fix the state & reason
-		 */
-		port_info->port_state = 0;
-		port_info->offline_reason = 0;
-
-		port_info->port_wwn = bfa_fcs_lport_get_pwwn(port);
-		port_info->node_wwn = bfa_fcs_lport_get_nwwn(port);
-
-		port_info->max_vports_supp =
-			bfa_lps_get_max_vport(port->fcs->bfa);
-		port_info->num_vports_inuse =
-			port->fabric->num_vports;
-		port_info->max_rports_supp = BFA_FCS_MAX_RPORTS_SUPP;
-		port_info->num_rports_inuse = port->num_rports;
-	} else {
-		/*
-		 * This is a virtual port
-		 */
-		port_info->port_type = BFA_LPORT_TYPE_VIRTUAL;
-
-		/*
-		 * @todo : need to fix the state & reason
-		 */
-		port_info->port_state = 0;
-		port_info->offline_reason = 0;
-
-		port_info->port_wwn = bfa_fcs_lport_get_pwwn(port);
-		port_info->node_wwn = bfa_fcs_lport_get_nwwn(port);
-	}
-}
-
 void
 bfa_fcs_lport_get_stats(struct bfa_fcs_lport_s *fcs_port,
 	 struct bfa_lport_stats_s *port_stats)
@@ -6567,15 +6452,6 @@ bfa_fcs_vport_offline(struct bfa_fcs_vport_s *vport)
 	bfa_sm_send_event(vport, BFA_FCS_VPORT_SM_OFFLINE);
 }
 
-/*
- * Cleanup notification from fabric SM on link timer expiry.
- */
-void
-bfa_fcs_vport_cleanup(struct bfa_fcs_vport_s *vport)
-{
-	vport->vport_stats.fab_cleanup++;
-}
-
 /*
  * Stop notification from fabric SM. To be invoked from within FCS.
  */
@@ -6698,24 +6574,6 @@ bfa_fcs_pbc_vport_create(struct bfa_fcs_vport_s *vport, struct bfa_fcs_s *fcs,
 	return rc;
 }
 
-/*
- *	Use this function to findout if this is a pbc vport or not.
- *
- * @param[in] vport - pointer to bfa_fcs_vport_t.
- *
- * @returns None
- */
-bfa_boolean_t
-bfa_fcs_is_pbc_vport(struct bfa_fcs_vport_s *vport)
-{
-
-	if (vport && (vport->lport.port_cfg.preboot_vp == BFA_TRUE))
-		return BFA_TRUE;
-	else
-		return BFA_FALSE;
-
-}
-
 /*
  * Use this function initialize the vport.
  *
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index ce52a9c88ae6..d4bde9bbe75b 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2646,27 +2646,6 @@ bfa_fcs_rport_create_by_wwn(struct bfa_fcs_lport_s *port, wwn_t rpwwn)
 	bfa_sm_send_event(rport, RPSM_EVENT_ADDRESS_DISC);
 	return rport;
 }
-/*
- * Called by bport in private loop topology to indicate that a
- * rport has been discovered and plogi has been completed.
- *
- * @param[in] port	- base port or vport
- * @param[in] rpid	- remote port ID
- */
-void
-bfa_fcs_rport_start(struct bfa_fcs_lport_s *port, struct fchs_s *fchs,
-	 struct fc_logi_s *plogi)
-{
-	struct bfa_fcs_rport_s *rport;
-
-	rport = bfa_fcs_rport_alloc(port, WWN_NULL, fchs->s_id);
-	if (!rport)
-		return;
-
-	bfa_fcs_rport_update(rport, plogi);
-
-	bfa_sm_send_event(rport, RPSM_EVENT_PLOGI_COMP);
-}
 
 /*
  *	Called by bport/vport to handle PLOGI received from a new remote port.
@@ -3089,21 +3068,6 @@ bfa_fcs_rport_lookup(struct bfa_fcs_lport_s *port, wwn_t rpwwn)
 	return rport;
 }
 
-struct bfa_fcs_rport_s *
-bfa_fcs_rport_lookup_by_nwwn(struct bfa_fcs_lport_s *port, wwn_t rnwwn)
-{
-	struct bfa_fcs_rport_s *rport;
-
-	rport = bfa_fcs_lport_get_rport_by_nwwn(port, rnwwn);
-	if (rport == NULL) {
-		/*
-		 * TBD Error handling
-		 */
-	}
-
-	return rport;
-}
-
 /*
  * Remote port features (RPF) implementation.
  */
-- 
2.46.0

