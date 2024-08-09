Received: from alln-iport-7.cisco.com (alln-iport-7.cisco.com [173.37.142.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD859200A9;
	Fri,  9 Aug 2024 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723222234; cv=none; b=YLgPfEBROPUGpKY2ZBXC8KjPbQmtHhXzNeBUMzjVzXC3+CBid/B6y7fE3dykOLXgAMgrUIEYV6oLNcQTbE8jFYNX9pUV8MhN8HrFPB4t56gxCXhi6dhIrF2vx941wKWWGIt/Kw5fU8JCDM3LFeGw28VRozcaGW8FGJ/jNGGobbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723222234; c=relaxed/simple;
	bh=lEUN9SDifvKO7dplb35YEIFkPlfR0pQ+yIntb1BuRAg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qoE/M9f0lmBVXXuolqzfnxUfUtTGUxJJs1n3zxSzJURJoVJ1n/6ykJDX9zesoQoRYwDCRXgl+wDlndrB7MqHNjWDrfcB34P3+INNSwPeYWhO86rZ7oM/FYSSbxa0qRjDi+6xMRvZ+75LUhA+Y4ow6fiS1XzDtJ6nFPRgxh6sqo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=lgV10Z6a; arc=none smtp.client-ip=173.37.142.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="lgV10Z6a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=23802; q=dns/txt;
  s=iport; t=1723222232; x=1724431832;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T2B1fL4kFF6V5vS29/blPUokdF5uo1mlerA2E5CsS/Q=;
  b=lgV10Z6aOS/z0VomVWGmfNGJtU5cDMh8gSAiQciY7TaLzyysPr4ULizM
   J9+bme/S/hnJ7GzUBv3nJrGNisPKMUS5/IHl6utOLXvmTNSwrGVkbJ51m
   bLqG00FsrX4GPBooT/Om0LBlUXgf+5ZVnXXsbqtTlW36CwdOzQhXUKzLS
   Y=;
X-CSE-ConnectionGUID: OZarkf2DTDGRd3xdTk0pgw==
X-CSE-MsgGUID: j06Y0tFcSCqkSnmqXqu9ZQ==
X-IronPort-AV: E=Sophos;i="6.09,276,1716249600"; 
   d="scan'208";a="329538252"
Received: from rcdn-core-5.cisco.com ([173.37.93.156])
  by alln-iport-7.cisco.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 16:50:30 +0000
Received: from localhost.cisco.com ([10.193.101.253])
	(authenticated bits=0)
	by rcdn-core-5.cisco.com (8.15.2/8.15.2) with ESMTPSA id 479Ggo2g031305
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 9 Aug 2024 16:50:30 GMT
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 11/14] scsi: fnic: Add stats and related functionality
Date: Fri,  9 Aug 2024 09:42:37 -0700
Message-Id: <20240809164240.47561-12-kartilak@cisco.com>
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

Add statistics and related functionality for FDLS.
Add supporting functions to display stats.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c  | 28 ++++++++++++
 drivers/scsi/fnic/fnic.h       |  2 +
 drivers/scsi/fnic/fnic_fdls.h  |  6 ++-
 drivers/scsi/fnic/fnic_main.c  | 37 +++++++++++++++-
 drivers/scsi/fnic/fnic_scsi.c  | 15 +++++++
 drivers/scsi/fnic/fnic_stats.h | 46 ++++++++++++++++++-
 drivers/scsi/fnic/fnic_trace.c | 81 +++++++++++++++++++++++++++++-----
 7 files changed, 198 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index a9da58e06065..6b27d23625b5 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -516,6 +516,7 @@ static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
 
 	fnic_send_fcoe_frame(iport, &flogi, sizeof(struct fc_els_s));
 	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
+	atomic64_inc(&iport->iport_stats.fabric_flogi_sent);
 	fdls_start_fabric_timer(iport, 2 * iport->e_d_tov);
 }
 
@@ -538,6 +539,7 @@ static void fdls_send_fabric_plogi(struct fnic_iport_s *iport)
 	FNIC_SET_NODE_NAME(plogi, iport->wwnn);
 	FNIC_SET_RDF_SIZE(plogi.u.csp_plogi, iport->max_payload_size);
 
+	atomic64_inc(&iport->iport_stats.fabric_plogi_sent);
 	fnic_send_fcoe_frame(iport, &plogi, sizeof(struct fc_els_s));
 	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
 	fdls_start_fabric_timer(iport, 2 * iport->e_d_tov);
@@ -609,6 +611,7 @@ static void fdls_send_scr(struct fnic_iport_s *iport)
 	hton24(fcid, iport->fcid);
 	FNIC_SET_S_ID((&scr_req.fchdr), fcid);
 
+	atomic64_inc(&iport->iport_stats.fabric_scr_sent);
 	fnic_send_fcoe_frame(iport, &scr_req, sizeof(struct fc_scr_s));
 	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
 	fdls_start_fabric_timer(iport, 2 * iport->e_d_tov);
@@ -673,6 +676,7 @@ fdls_send_tgt_adisc(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 				 "sending ADISC to tgt fcid: 0x%x", tport->fcid);
 
+	atomic64_inc(&iport->iport_stats.tport_adisc_sent);
 	fnic_send_fcoe_frame(iport, &adisc, sizeof(struct fc_els_adisc_s));
 	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
 	fdls_start_tport_timer(iport, tport, 2 * iport->e_d_tov);
@@ -774,6 +778,7 @@ fdls_send_tgt_plogi(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 
 	timeout = max(2 * iport->e_d_tov, iport->plogi_timeout);
 
+	atomic64_inc(&iport->iport_stats.tport_plogi_sent);
 	fnic_send_fcoe_frame(iport, &plogi, sizeof(struct fc_els_s));
 	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
 	fdls_start_tport_timer(iport, tport, timeout);
@@ -881,6 +886,7 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 
 	timeout = max(2 * iport->e_d_tov, iport->plogi_timeout);
 
+	atomic64_inc(&iport->iport_stats.tport_prli_sent);
 	fnic_send_fcoe_frame(iport, &prli, sizeof(struct fc_els_prli_s));
 	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
 	fdls_start_tport_timer(iport, tport, timeout);
@@ -955,6 +961,7 @@ void fdls_tgt_logout(struct fnic_iport_s *iport,
 	memcpy(&logo.fcid, s_id, 3);
 	logo.wwpn = get_unaligned_be64(&iport->wwpn);
 
+	atomic64_inc(&iport->iport_stats.tport_logo_sent);
 	fnic_send_fcoe_frame(iport, &logo, sizeof(struct fc_logo_req_s));
 }
 
@@ -1593,6 +1600,7 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 
 	switch (adisc_rsp->command) {
 	case ELS_LS_ACC:
+		atomic64_inc(&iport->iport_stats.tport_adisc_ls_accepts);
 		if (tport->timer_pending) {
 			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 						 "tport 0x%p Canceling fabric disc timer\n",
@@ -1617,6 +1625,7 @@ fdls_process_tgt_adisc_rsp(struct fnic_iport_s *iport,
 		break;
 
 	case ELS_LS_RJT:
+		atomic64_inc(&iport->iport_stats.tport_adisc_ls_rejects);
 		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
 			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
@@ -1691,6 +1700,7 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 
 	switch (plogi_rsp->command) {
 	case ELS_LS_ACC:
+		atomic64_inc(&iport->iport_stats.tport_plogi_ls_accepts);
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					 "PLOGI accepted by target: 0x%x", tgt_fcid);
 		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
@@ -1698,6 +1708,7 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 		break;
 
 	case ELS_LS_RJT:
+		atomic64_inc(&iport->iport_stats.tport_plogi_ls_rejects);
 		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
 			&& (tport->retry_counter < iport->max_plogi_retries)) {
@@ -1717,6 +1728,7 @@ fdls_process_tgt_plogi_rsp(struct fnic_iport_s *iport,
 		return;
 
 	default:
+		atomic64_inc(&iport->iport_stats.tport_plogi_misc_rejects);
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					 "PLOGI not accepted from target fcid: 0x%x",
 					 tgt_fcid);
@@ -1820,6 +1832,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 
 	switch (prli_rsp->command) {
 	case ELS_LS_ACC:
+		atomic64_inc(&iport->iport_stats.tport_prli_ls_accepts);
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					 "PRLI accepted from target: 0x%x", tgt_fcid);
 		oxid = ntohs(FNIC_GET_OX_ID(fchdr));
@@ -1839,6 +1852,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 		break;
 
 	case ELS_LS_RJT:
+		atomic64_inc(&iport->iport_stats.tport_prli_ls_rejects);
 		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
 			&& (tport->retry_counter < FDLS_RETRY_COUNT)) {
@@ -1864,6 +1878,7 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 		break;
 
 	default:
+		atomic64_inc(&iport->iport_stats.tport_prli_misc_rejects);
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					 "PRLI not accepted from target: 0x%x", tgt_fcid);
 		return;
@@ -2128,6 +2143,7 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 
 	switch (scr_rsp->command) {
 	case ELS_LS_ACC:
+		atomic64_inc(&iport->iport_stats.fabric_scr_ls_accepts);
 		if (iport->fabric.timer_pending) {
 			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 						 "Canceling fabric disc timer %p\n", iport);
@@ -2139,6 +2155,7 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 		break;
 
 	case ELS_LS_RJT:
+		atomic64_inc(&iport->iport_stats.fabric_scr_ls_rejects);
 		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
 			&& (fdls->retry_counter < FDLS_RETRY_COUNT)) {
@@ -2162,6 +2179,7 @@ fdls_process_scr_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 		break;
 
 	default:
+		atomic64_inc(&iport->iport_stats.fabric_scr_misc_rejects);
 		break;
 	}
 }
@@ -2461,6 +2479,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 
 	switch (flogi_rsp->command) {
 	case ELS_LS_ACC:
+		atomic64_inc(&iport->iport_stats.fabric_flogi_ls_accepts);
 		if (iport->fabric.timer_pending) {
 			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 						 "iport fcid: 0x%x Canceling fabric disc timer\n",
@@ -2534,6 +2553,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 		break;
 
 	case ELS_LS_RJT:
+		atomic64_inc(&iport->iport_stats.fabric_flogi_ls_rejects);
 		els_rjt = (struct fc_els_reject_s *) fchdr;
 		if (fabric->retry_counter < iport->max_flogi_retries) {
 			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
@@ -2561,6 +2581,7 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr,
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					 "FLOGI response not accepted: 0x%x",
 					 flogi_rsp->command);
+		atomic64_inc(&iport->iport_stats.fabric_flogi_misc_rejects);
 		break;
 	}
 }
@@ -2582,6 +2603,7 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 
 	switch (plogi_rsp->command) {
 	case ELS_LS_ACC:
+		atomic64_inc(&iport->iport_stats.fabric_plogi_ls_accepts);
 		if (iport->fabric.timer_pending) {
 			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 				 "iport fcid: 0x%x fabric PLOGI response: Accepted\n",
@@ -2594,6 +2616,7 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 		fdls_send_rpn_id(iport);
 		break;
 	case ELS_LS_RJT:
+		atomic64_inc(&iport->iport_stats.fabric_plogi_ls_rejects);
 		if (((els_rjt->reason_code == FC_ELS_RJT_LOGICAL_BUSY)
 			 || (els_rjt->reason_code == FC_ELS_RJT_BUSY))
 			&& (iport->fabric.retry_counter < iport->max_plogi_retries)) {
@@ -2619,6 +2642,7 @@ fdls_process_fabric_plogi_rsp(struct fnic_iport_s *iport,
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					 "PLOGI response not accepted: 0x%x",
 					 plogi_rsp->command);
+		atomic64_inc(&iport->iport_stats.fabric_plogi_misc_rejects);
 		break;
 	}
 }
@@ -2899,6 +2923,7 @@ fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 			 "Dropping unsupported ELS with illegal frame bits 0x%x\n",
 			 d_id);
+		atomic64_inc(&iport->iport_stats.unsupported_frames_dropped);
 		return;
 	}
 
@@ -2907,6 +2932,7 @@ fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 			 "Dropping unsupported ELS request in iport state: %d",
 			 iport->state);
+		atomic64_inc(&iport->iport_stats.unsupported_frames_dropped);
 		return;
 	}
 
@@ -3300,6 +3326,8 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_hdr_s *fchdr)
 	struct fnic_fdls_fabric_s *fdls = &iport->fabric;
 	struct fnic *fnic = iport->fnic;
 
+	atomic64_inc(&iport->iport_stats.num_rscns);
+
 	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 				 "FDLS process RSCN %p", iport);
 
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 0ae5530cb7c0..9f712e552064 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -531,5 +531,7 @@ unsigned int fnic_count_lun_ioreqs_wq(struct fnic *fnic, u32 hwq,
 unsigned int fnic_count_lun_ioreqs(struct fnic *fnic,
 					   struct scsi_device *device);
 void fnic_scsi_unload(struct fnic *fnic);
+int fnic_get_debug_info(struct stats_debug_info *info,
+					struct fnic *fnic);
 
 #endif /* _FNIC_H_ */
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
index 42fea3d69a83..80179f74ddc0 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -242,10 +242,12 @@ struct fnic_iport_s {
 	uint16_t max_payload_size;
 	spinlock_t deleted_tport_lst_lock;
 	struct completion *flogi_reg_done;
+	struct fnic_iport_stats iport_stats;
 	char str_wwpn[20];
 	char str_wwnn[20];
-	};
-	struct rport_dd_data_s {
+};
+
+struct rport_dd_data_s {
 	struct fnic_tport_s *tport;
 	struct fnic_iport_s *iport;
 };
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 644bdf7e7c76..5f9c33fa3a1d 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -162,7 +162,7 @@ static struct fc_function_template fnic_fc_functions = {
 	.show_rport_dev_loss_tmo = 1,
 	.set_rport_dev_loss_tmo = fnic_set_rport_dev_loss_tmo,
 	.issue_fc_host_lip = fnic_issue_fc_host_lip,
-	.get_fc_host_stats = NULL,
+	.get_fc_host_stats = fnic_get_stats,
 	.reset_fc_host_stats = fnic_reset_host_stats,
 	.dd_fcrport_size = sizeof(struct rport_dd_data_s),
 	.terminate_rport_io = fnic_terminate_rport_io,
@@ -173,9 +173,11 @@ static void fnic_get_host_speed(struct Scsi_Host *shost)
 {
 	struct fnic *fnic = *((struct fnic **) shost_priv(shost));
 	u32 port_speed = vnic_dev_port_speed(fnic->vdev);
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	FNIC_MAIN_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 				  "port_speed: %d Mbps", port_speed);
+	atomic64_set(&fnic_stats->misc_stats.port_speed_in_mbps, port_speed);
 
 	/* Add in other values as they get defined in fw */
 	switch (port_speed) {
@@ -233,7 +235,38 @@ static void fnic_get_host_speed(struct Scsi_Host *shost)
 /* Placeholder function */
 static struct fc_host_statistics *fnic_get_stats(struct Scsi_Host *host)
 {
-	struct fc_host_statistics *stats;
+	int ret;
+	struct fnic *fnic = *((struct fnic **) shost_priv(host));
+	struct fc_host_statistics *stats = &fnic->fnic_stats.host_stats;
+	struct vnic_stats *vs;
+	unsigned long flags;
+
+	if (time_before
+		(jiffies, fnic->stats_time + HZ / FNIC_STATS_RATE_LIMIT))
+		return stats;
+	fnic->stats_time = jiffies;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	ret = vnic_dev_stats_dump(fnic->vdev, &fnic->stats);
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	if (ret) {
+		FNIC_MAIN_DBG(KERN_DEBUG, fnic->lport->host, fnic->fnic_num,
+					  "fnic: Get vnic stats failed: 0x%x", ret);
+		return stats;
+	}
+	vs = fnic->stats;
+	stats->tx_frames = vs->tx.tx_unicast_frames_ok;
+	stats->tx_words = vs->tx.tx_unicast_bytes_ok / 4;
+	stats->rx_frames = vs->rx.rx_unicast_frames_ok;
+	stats->rx_words = vs->rx.rx_unicast_bytes_ok / 4;
+	stats->error_frames = vs->tx.tx_errors + vs->rx.rx_errors;
+	stats->dumped_frames = vs->tx.tx_drops + vs->rx.rx_drop;
+	stats->invalid_crc_count = vs->rx.rx_crc_errors;
+	stats->seconds_since_last_reset =
+		(jiffies - fnic->stats_reset_time) / HZ;
+	stats->fcp_input_megabytes = div_u64(fnic->fcp_input_bytes, 1000000);
+	stats->fcp_output_megabytes = div_u64(fnic->fcp_output_bytes, 1000000);
 	return stats;
 }
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 020da21dbc35..67b6105701e4 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -503,6 +503,7 @@ int fnic_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	if (ret) {
 		FNIC_SCSI_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
 				"rport is not ready\n");
+		atomic64_inc(&fnic_stats->misc_stats.tport_not_ready);
 		sc->result = ret;
 		done(sc);
 		return 0;
@@ -1138,6 +1139,15 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
 		  jiffies_to_msecs(jiffies - start_time)),
 		  desc, cmd_trace, fnic_flags_and_state(sc));
 
+	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
+		fnic_stats->host_stats.fcp_input_requests++;
+		fnic->fcp_input_bytes += xfer_len;
+	} else if (sc->sc_data_direction == DMA_TO_DEVICE) {
+		fnic_stats->host_stats.fcp_output_requests++;
+		fnic->fcp_output_bytes += xfer_len;
+	} else
+		fnic_stats->host_stats.fcp_control_requests++;
+
 	/* Call SCSI completion function to complete the IO */
 	scsi_done(sc);
 
@@ -2061,6 +2071,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 				  fnic_priv(sc)->flags);
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
+		atomic64_inc(&fnic_stats->misc_stats.iport_not_ready);
 		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					  "iport NOT in READY state");
 		ret = FAILED;
@@ -2144,6 +2155,7 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 	if (fc_remote_port_chkready(rport) == 0)
 		task_req = FCPIO_ITMF_ABT_TASK;
 	else {
+		atomic64_inc(&fnic_stats->misc_stats.tport_not_ready);
 		task_req = FCPIO_ITMF_ABT_TASK_TERM;
 	}
 
@@ -2581,6 +2593,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	}
 
 	if (iport->state != FNIC_IPORT_STATE_READY) {
+		atomic64_inc(&fnic_stats->misc_stats.iport_not_ready);
 		FNIC_SCSI_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 					  "iport NOT in READY state");
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -2598,6 +2611,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	/* Check if remote port up */
 	if (fc_remote_port_chkready(rport)) {
+		atomic64_inc(&fnic_stats->misc_stats.tport_not_ready);
 		goto fnic_device_reset_end;
 	}
 
@@ -3075,6 +3089,7 @@ void fnic_scsi_fcpio_reset(struct fnic *fnic)
 				  "FW reset completion timed out after %d ms)\n",
 				  FNIC_FW_RESET_TIMEOUT);
 		}
+		atomic64_inc(&fnic->fnic_stats.reset_stats.fw_reset_timeouts);
 	}
 	fnic->fw_reset_done = NULL;
 }
diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.h
index 1f1a1ec90a23..ef7cdc909940 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -63,6 +63,7 @@ struct reset_stats {
 	atomic64_t fw_resets;
 	atomic64_t fw_reset_completions;
 	atomic64_t fw_reset_failures;
+	atomic64_t fw_reset_timeouts;
 	atomic64_t fnic_resets;
 	atomic64_t fnic_reset_completions;
 	atomic64_t fnic_reset_failures;
@@ -102,10 +103,51 @@ struct misc_stats {
 	atomic64_t no_icmnd_itmf_cmpls;
 	atomic64_t check_condition;
 	atomic64_t queue_fulls;
-	atomic64_t rport_not_ready;
+	atomic64_t tport_not_ready;
+	atomic64_t iport_not_ready;
 	atomic64_t frame_errors;
 	atomic64_t current_port_speed;
 	atomic64_t intx_dummy;
+	atomic64_t port_speed_in_mbps;
+};
+
+struct fnic_iport_stats {
+	atomic64_t num_linkdn;
+	atomic64_t num_linkup;
+	atomic64_t link_failure_count;
+	atomic64_t num_rscns;
+	atomic64_t rscn_redisc;
+	atomic64_t rscn_not_redisc;
+	atomic64_t frame_err;
+	atomic64_t num_rnid;
+	atomic64_t fabric_flogi_sent;
+	atomic64_t fabric_flogi_ls_accepts;
+	atomic64_t fabric_flogi_ls_rejects;
+	atomic64_t fabric_flogi_misc_rejects;
+	atomic64_t fabric_plogi_sent;
+	atomic64_t fabric_plogi_ls_accepts;
+	atomic64_t fabric_plogi_ls_rejects;
+	atomic64_t fabric_plogi_misc_rejects;
+	atomic64_t fabric_scr_sent;
+	atomic64_t fabric_scr_ls_accepts;
+	atomic64_t fabric_scr_ls_rejects;
+	atomic64_t fabric_scr_misc_rejects;
+	atomic64_t fabric_logo_sent;
+	atomic64_t tport_alive;
+	atomic64_t tport_plogi_sent;
+	atomic64_t tport_plogi_ls_accepts;
+	atomic64_t tport_plogi_ls_rejects;
+	atomic64_t tport_plogi_misc_rejects;
+	atomic64_t tport_prli_sent;
+	atomic64_t tport_prli_ls_accepts;
+	atomic64_t tport_prli_ls_rejects;
+	atomic64_t tport_prli_misc_rejects;
+	atomic64_t tport_adisc_sent;
+	atomic64_t tport_adisc_ls_accepts;
+	atomic64_t tport_adisc_ls_rejects;
+	atomic64_t tport_logo_sent;
+	atomic64_t unsupported_frames_ls_rejects;
+	atomic64_t unsupported_frames_dropped;
 };
 
 struct fnic_stats {
@@ -116,6 +158,7 @@ struct fnic_stats {
 	struct reset_stats reset_stats;
 	struct fw_stats fw_stats;
 	struct vlan_stats vlan_stats;
+	struct fc_host_statistics host_stats;
 	struct misc_stats misc_stats;
 };
 
@@ -127,4 +170,5 @@ struct stats_debug_info {
 };
 
 int fnic_get_stats_data(struct stats_debug_info *, struct fnic_stats *);
+const char *fnic_role_to_str(unsigned int role);
 #endif /* _FNIC_STATS_H_ */
diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index d717886808df..6729b988c541 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -8,6 +8,7 @@
 #include <linux/kallsyms.h>
 #include <linux/time.h>
 #include <linux/vmalloc.h>
+#include <scsi/scsi_transport_fc.h>
 #include "fnic_io.h"
 #include "fnic.h"
 
@@ -29,6 +30,17 @@ int fnic_fc_tracing_enabled = 1;
 int fnic_fc_trace_cleared = 1;
 static DEFINE_SPINLOCK(fnic_fc_trace_lock);
 
+const char *fnic_role_str[] = {
+	[FNIC_ROLE_FCP_INITIATOR] = "FCP_Initiator",
+};
+
+const char *fnic_role_to_str(unsigned int role)
+{
+	if (role >= ARRAY_SIZE(fnic_role_str) || !fnic_role_str[role])
+		return "Unknown";
+
+	return fnic_role_str[role];
+}
 
 /*
  * fnic_trace_get_buf - Give buffer pointer to user to fill up trace information
@@ -423,7 +435,8 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  "Number of Check Conditions encountered: %lld\n"
 		  "Number of QUEUE Fulls: %lld\n"
 		  "Number of rport not ready: %lld\n"
-		  "Number of receive frame errors: %lld\n",
+		 "Number of receive frame errors: %lld\n"
+		 "Port speed (in Mbps): %lld\n",
 		  (u64)stats->misc_stats.last_isr_time,
 		  (s64)val1.tv_sec, val1.tv_nsec,
 		  (u64)stats->misc_stats.last_ack_time,
@@ -446,13 +459,9 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 		  (u64)atomic64_read(&stats->misc_stats.no_icmnd_itmf_cmpls),
 		  (u64)atomic64_read(&stats->misc_stats.check_condition),
 		  (u64)atomic64_read(&stats->misc_stats.queue_fulls),
-		  (u64)atomic64_read(&stats->misc_stats.rport_not_ready),
-		  (u64)atomic64_read(&stats->misc_stats.frame_errors));
-
-	len += scnprintf(debug->debug_buffer + len, buf_size - len,
-			"Firmware reported port speed: %llu\n",
-			(u64)atomic64_read(
-				&stats->misc_stats.current_port_speed));
+		  (u64)atomic64_read(&stats->misc_stats.tport_not_ready),
+		  (u64)atomic64_read(&stats->misc_stats.frame_errors),
+		  (u64)atomic64_read(&stats->misc_stats.port_speed_in_mbps));
 
 	return len;
 
@@ -460,8 +469,56 @@ int fnic_get_stats_data(struct stats_debug_info *debug,
 
 int fnic_get_debug_info(struct stats_debug_info *info, struct fnic *fnic)
 {
-	/* Placeholder function */
-	return 0;
+	struct fnic_iport_s *iport = &fnic->iport;
+	int buf_size = info->buf_size;
+	int len = info->buffer_len;
+	struct fnic_tport_s *tport, *next;
+	unsigned long flags;
+
+	len += snprintf(info->debug_buffer + len, buf_size - len,
+					"------------------------------------------\n"
+					"\t\t Debug Info\n"
+					"------------------------------------------\n");
+	len += snprintf(info->debug_buffer + len, buf_size - len,
+					"fnic Name:%s number:%d Role:%s State:%s\n",
+					fnic->name, fnic->fnic_num,
+					fnic_role_to_str(fnic->role),
+					fnic_state_to_str(fnic->state));
+	len +=
+		snprintf(info->debug_buffer + len, buf_size - len,
+			 "iport State:%d Flags:0x%x vlan_id:%d fcid:0x%x\n",
+			 iport->state, iport->flags, iport->vlan_id, iport->fcid);
+	len +=
+		snprintf(info->debug_buffer + len, buf_size - len,
+			 "usefip:%d fip_state:%d fip_flogi_retry:%d\n",
+			 iport->usefip, iport->fip.state, iport->fip.flogi_retry);
+	len +=
+		snprintf(info->debug_buffer + len, buf_size - len,
+				 "fpma %02x:%02x:%02x:%02x:%02x:%02x",
+				 iport->fpma[5], iport->fpma[4], iport->fpma[3],
+				 iport->fpma[2], iport->fpma[1], iport->fpma[0]);
+	len +=
+		snprintf(info->debug_buffer + len, buf_size - len,
+				"fcfmac %02x:%02x:%02x:%02x:%02x:%02x\n",
+				iport->fcfmac[5], iport->fcfmac[4], iport->fcfmac[3],
+				iport->fcfmac[2], iport->fcfmac[1], iport->fcfmac[0]);
+	len +=
+		snprintf(info->debug_buffer + len, buf_size - len,
+		 "fabric state:%d flags:0x%x retry_counter:%d e_d_tov:%d r_a_tov:%d\n",
+		 iport->fabric.state, iport->fabric.flags,
+		 iport->fabric.retry_counter, iport->e_d_tov,
+		 iport->r_a_tov);
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+		len += snprintf(info->debug_buffer + len, buf_size - len,
+		"tport fcid:0x%x state:%d flags:0x%x inflight:%d retry_counter:%d\n",
+		tport->fcid, tport->state, tport->flags,
+		atomic_read(&tport->in_flight),
+		tport->retry_counter);
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+	return len;
 }
 
 /*
@@ -694,7 +751,7 @@ int fnic_fc_trace_set_data(u32 host_no, u8 frame_type,
 	 */
 	if (frame_type == FNIC_FC_RECV) {
 		eth_fcoe_hdr_len = sizeof(struct ethhdr) +
-					sizeof(struct fcoe_hdr);
+							sizeof(struct fnic_fcoe_hdr_s);
 		memset((char *)fc_trace, 0xff, eth_fcoe_hdr_len);
 		/* Copy the rest of data frame */
 		memcpy((char *)(fc_trace + eth_fcoe_hdr_len), (void *)frame,
@@ -800,7 +857,7 @@ void copy_and_format_trace_data(struct fc_trace_hdr *tdata,
 {
 	int j, i = 1, len;
 	int ethhdr_len = sizeof(struct ethhdr) - 1;
-	int fcoehdr_len = sizeof(struct fcoe_hdr);
+	int fcoehdr_len = sizeof(struct fnic_fcoe_hdr_s);
 	int fchdr_len = sizeof(struct fc_frame_header);
 	int max_size = fnic_fc_trace_max_pages * PAGE_SIZE * 3;
 	char *fc_trace;
-- 
2.31.1

