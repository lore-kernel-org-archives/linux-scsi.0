Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8C01E3CCC;
	Fri,  4 Oct 2024 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066041; cv=none; b=SHdr7ya0cDQPdPRGyOwqGKbN8tFVRxjVpc0/PDm6PNYs2MgoAyimurUh6Phs4v1dYJ+6qh4FDJrvJssjt/vKkRPDSp6kEQY6/QOaj3IS3rmBnWMXX54PLpT+seJIh5De6buO+hIHf+V9Oy95tfkDUUApQTnG5OmkSAJ+b7t893s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066041; c=relaxed/simple;
	bh=xW/xUk4IfEG4SRb4oKF9EycnRt/6Xr+cwThRHWdSMUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMRD9/EuTVBdu+RMSzWkYTto72NvciUe1cRBQj0vJS4+Vn3WPuXdRGuowZ+fjGaWHuhUP9e+4TjvfqBdGXWbAZJmcVcmddEFu6J4d8yn4L/EgO/44MPtlOmhiHCAl8uyX97cuY87WkNWxQdm8OfcNUfhFfJxX6TXnaws8SHuSJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T2VrGZB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T2VrGZB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3056EC4CEC6;
	Fri,  4 Oct 2024 18:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066041;
	bh=xW/xUk4IfEG4SRb4oKF9EycnRt/6Xr+cwThRHWdSMUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2VrGZB7lppPaFO/TV7UMnax3F4ICDuCrEzmUjDWJ4T3Kav43+2IO0NKuXMMGKSR8
	 4X6FwMX/Ik7cK0G2DZJ/HYc03LxwlIJCX5m2op5YFb2smdM6M75anGxbOQZELDbnni
	 D++V+SVJu2lpzl70ZT7RsLfhNxFaSAZ1K93totc6cmrbPJaD7LVrEQZCMYvBho/NWz
	 RXS7RtvY+UvGL7Ety3bsfZ0YB1z+Nva8A5UoN+hLy2pJSYi4Pp5V0kGc7TfH8tiS3s
	 ypqFbOuzzU/9u8sIbvhI0HR6I3aKTnEjTnsr2pfuNlxIx6MVMLSbidKs2Ii9hAzSa6
	 8fFI+602DHqiA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 70/76] scsi: lpfc: Revise TRACE_EVENT log flag severities from KERN_ERR to KERN_WARNING
Date: Fri,  4 Oct 2024 14:17:27 -0400
Message-ID: <20241004181828.3669209-70-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004181828.3669209-1-sashal@kernel.org>
References: <20241004181828.3669209-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.2
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 1af9af1f8ab38f1285b27581a5e6920ec58296ba ]

Revise certain log messages marked as KERN_ERR LOG_TRACE_EVENT to
KERN_WARNING and use the lpfc_vlog_msg() macro to still log the event.  The
benefit is that events of interest are still logged and the entire trace
buffer is not dumped with extraneous logging information when using default
lpfc_log_verbose driver parameter settings.

Also, delete the keyword "fail" from such log messages as they aren't
really causes for concern.  The log messages are more for warnings to a SAN
admin about SAN activity.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240912232447.45607-7-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c  |  10 +--
 drivers/scsi/lpfc/lpfc_els.c | 125 +++++++++++++++++------------------
 2 files changed, 64 insertions(+), 71 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 1e5db489a00c5..134bc96dd1340 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1572,8 +1572,8 @@ lpfc_cmpl_ct_cmd_gft_id(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 		}
 	} else
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "3065 GFT_ID failed x%08x\n", ulp_status);
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_DISCOVERY,
+			      "3065 GFT_ID status x%08x\n", ulp_status);
 
 out:
 	lpfc_ct_free_iocb(phba, cmdiocb);
@@ -2258,7 +2258,7 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		}
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "0229 FDMI cmd %04x failed, latt = %d "
+				 "0229 FDMI cmd %04x latt = %d "
 				 "ulp_status: x%x, rid x%x\n",
 				 be16_to_cpu(fdmi_cmd), latt, ulp_status,
 				 ulp_word4);
@@ -2275,9 +2275,9 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	/* Check for a CT LS_RJT response */
 	cmd =  be16_to_cpu(fdmi_cmd);
 	if (be16_to_cpu(fdmi_rsp) == SLI_CT_RESPONSE_FS_RJT) {
-		/* FDMI rsp failed */
+		/* Log FDMI reject */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY | LOG_ELS,
-				 "0220 FDMI cmd failed FS_RJT Data: x%x", cmd);
+				 "0220 FDMI cmd FS_RJT Data: x%x", cmd);
 
 		/* Should we fallback to FDMI-2 / FDMI-1 ? */
 		switch (cmd) {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c06234ff8064b..8c1505e5394fd 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -979,7 +979,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				phba->fcoe_cvl_eventtag_attn =
 					phba->fcoe_cvl_eventtag;
 			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP | LOG_ELS,
-					"2611 FLOGI failed on FCF (x%x), "
+					"2611 FLOGI FCF (x%x), "
 					"status:x%x/x%x, tmo:x%x, perform "
 					"roundrobin FCF failover\n",
 					phba->fcf.current_rec.fcf_indx,
@@ -997,11 +997,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
 		      ((ulp_word4 & IOERR_PARAM_MASK) ==
 					IOERR_LOOP_OPEN_FAILURE)))
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "2858 FLOGI failure Status:x%x/x%x TMO"
-					 ":x%x Data x%lx x%x\n",
-					 ulp_status, ulp_word4, tmo,
-					 phba->hba_flag, phba->fcf.fcf_flag);
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "2858 FLOGI Status:x%x/x%x TMO"
+				      ":x%x Data x%lx x%x\n",
+				      ulp_status, ulp_word4, tmo,
+				      phba->hba_flag, phba->fcf.fcf_flag);
 
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb)) {
@@ -1023,7 +1023,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			lpfc_nlp_put(ndlp);
 
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
-				 "0150 FLOGI failure Status:x%x/x%x "
+				 "0150 FLOGI Status:x%x/x%x "
 				 "xri x%x TMO:x%x refcnt %d\n",
 				 ulp_status, ulp_word4, cmdiocb->sli4_xritag,
 				 tmo, kref_read(&ndlp->kref));
@@ -1032,11 +1032,11 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		if (!(ulp_status == IOSTAT_LOCAL_REJECT &&
 		      ((ulp_word4 & IOERR_PARAM_MASK) ==
 					IOERR_LOOP_OPEN_FAILURE))) {
-			/* FLOGI failure */
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "0100 FLOGI failure Status:x%x/x%x "
-					 "TMO:x%x\n",
-					 ulp_status, ulp_word4, tmo);
+			/* Warn FLOGI status */
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "0100 FLOGI Status:x%x/x%x "
+				      "TMO:x%x\n",
+				      ulp_status, ulp_word4, tmo);
 			goto flogifail;
 		}
 
@@ -1958,16 +1958,16 @@ lpfc_cmpl_els_rrq(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (ulp_status) {
 		/* Check for retry */
-		/* RRQ failed Don't print the vport to vport rjts */
+		/* Warn RRQ status Don't print the vport to vport rjts */
 		if (ulp_status != IOSTAT_LS_RJT ||
 		    (((ulp_word4) >> 16 != LSRJT_INVALID_CMD) &&
 		     ((ulp_word4) >> 16 != LSRJT_UNABLE_TPC)) ||
 		    (phba)->pport->cfg_log_verbose & LOG_ELS)
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "2881 RRQ failure DID:%06X Status:"
-					 "x%x/x%x\n",
-					 ndlp->nlp_DID, ulp_status,
-					 ulp_word4);
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "2881 RRQ DID:%06X Status:"
+				      "x%x/x%x\n",
+				      ndlp->nlp_DID, ulp_status,
+				      ulp_word4);
 	}
 
 	lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
@@ -2071,16 +2071,16 @@ lpfc_cmpl_els_plogi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			goto out;
 		}
-		/* PLOGI failed Don't print the vport to vport rjts */
+		/* Warn PLOGI status Don't print the vport to vport rjts */
 		if (ulp_status != IOSTAT_LS_RJT ||
 		    (((ulp_word4) >> 16 != LSRJT_INVALID_CMD) &&
 		     ((ulp_word4) >> 16 != LSRJT_UNABLE_TPC)) ||
 		    (phba)->pport->cfg_log_verbose & LOG_ELS)
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-					 "2753 PLOGI failure DID:%06X "
-					 "Status:x%x/x%x\n",
-					 ndlp->nlp_DID, ulp_status,
-					 ulp_word4);
+			lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+				      "2753 PLOGI DID:%06X "
+				      "Status:x%x/x%x\n",
+				      ndlp->nlp_DID, ulp_status,
+				      ulp_word4);
 
 		/* Do not call DSM for lpfc_els_abort'ed ELS cmds */
 		if (!lpfc_error_lost_link(vport, ulp_status, ulp_word4))
@@ -2317,7 +2317,6 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_nodelist *ndlp;
 	char *mode;
-	u32 loglevel;
 	u32 ulp_status;
 	u32 ulp_word4;
 	bool release_node = false;
@@ -2366,17 +2365,14 @@ lpfc_cmpl_els_prli(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		 * could be expected.
 		 */
 		if (test_bit(FC_FABRIC, &vport->fc_flag) ||
-		    vport->cfg_enable_fc4_type != LPFC_ENABLE_BOTH) {
-			mode = KERN_ERR;
-			loglevel =  LOG_TRACE_EVENT;
-		} else {
+		    vport->cfg_enable_fc4_type != LPFC_ENABLE_BOTH)
+			mode = KERN_WARNING;
+		else
 			mode = KERN_INFO;
-			loglevel =  LOG_ELS;
-		}
 
-		/* PRLI failed */
-		lpfc_printf_vlog(vport, mode, loglevel,
-				 "2754 PRLI failure DID:%06X Status:x%x/x%x, "
+		/* Warn PRLI status */
+		lpfc_printf_vlog(vport, mode, LOG_ELS,
+				 "2754 PRLI DID:%06X Status:x%x/x%x, "
 				 "data: x%x x%x x%x\n",
 				 ndlp->nlp_DID, ulp_status,
 				 ulp_word4, ndlp->nlp_state,
@@ -2848,11 +2844,11 @@ lpfc_cmpl_els_adisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			goto out;
 		}
-		/* ADISC failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2755 ADISC failure DID:%06X Status:x%x/x%x\n",
-				 ndlp->nlp_DID, ulp_status,
-				 ulp_word4);
+		/* Warn ADISC status */
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "2755 ADISC DID:%06X Status:x%x/x%x\n",
+			      ndlp->nlp_DID, ulp_status,
+			      ulp_word4);
 		lpfc_disc_state_machine(vport, ndlp, cmdiocb,
 					NLP_EVT_CMPL_ADISC);
 
@@ -3039,12 +3035,12 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * discovery.  The PLOGI will retry.
 	 */
 	if (ulp_status) {
-		/* LOGO failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "2756 LOGO failure, No Retry DID:%06X "
-				 "Status:x%x/x%x\n",
-				 ndlp->nlp_DID, ulp_status,
-				 ulp_word4);
+		/* Warn LOGO status */
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "2756 LOGO, No Retry DID:%06X "
+			      "Status:x%x/x%x\n",
+			      ndlp->nlp_DID, ulp_status,
+			      ulp_word4);
 
 		if (lpfc_error_lost_link(vport, ulp_status, ulp_word4))
 			skip_recovery = 1;
@@ -4831,11 +4827,10 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			if ((phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) &&
 			  (cmd == ELS_CMD_FDISC) &&
 			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_OUT_OF_RESOURCE)){
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
-						 "0125 FDISC Failed (x%x). "
-						 "Fabric out of resources\n",
-						 stat.un.lsRjtError);
+				lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+					      "0125 FDISC (x%x). "
+					      "Fabric out of resources\n",
+					      stat.un.lsRjtError);
 				lpfc_vport_set_state(vport,
 						     FC_VPORT_NO_FABRIC_RSCS);
 			}
@@ -4871,11 +4866,10 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 						LSEXP_NOTHING_MORE) {
 				vport->fc_sparam.cmn.bbRcvSizeMsb &= 0xf;
 				retry = 1;
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
-						 "0820 FLOGI Failed (x%x). "
-						 "BBCredit Not Supported\n",
-						 stat.un.lsRjtError);
+				lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+					      "0820 FLOGI (x%x). "
+					      "BBCredit Not Supported\n",
+					      stat.un.lsRjtError);
 			}
 			break;
 
@@ -4885,11 +4879,10 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			  ((stat.un.b.lsRjtRsnCodeExp == LSEXP_INVALID_PNAME) ||
 			  (stat.un.b.lsRjtRsnCodeExp == LSEXP_INVALID_NPORT_ID))
 			  ) {
-				lpfc_printf_vlog(vport, KERN_ERR,
-						 LOG_TRACE_EVENT,
-						 "0122 FDISC Failed (x%x). "
-						 "Fabric Detected Bad WWN\n",
-						 stat.un.lsRjtError);
+				lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+					      "0122 FDISC (x%x). "
+					      "Fabric Detected Bad WWN\n",
+					      stat.un.lsRjtError);
 				lpfc_vport_set_state(vport,
 						     FC_VPORT_FABRIC_REJ_WWN);
 			}
@@ -5344,8 +5337,8 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	u32 ulp_status, ulp_word4, tmo, did, iotag;
 
 	if (!vport) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"3177 ELS response failed\n");
+		lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
+				"3177 null vport in ELS rsp\n");
 		goto out;
 	}
 	if (cmdiocb->context_un.mbox)
@@ -11311,10 +11304,10 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Check for retry */
 		if (lpfc_els_retry(phba, cmdiocb, rspiocb))
 			goto out;
-		/* FDISC failed */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-				 "0126 FDISC failed. (x%x/x%x)\n",
-				 ulp_status, ulp_word4);
+		/* Warn FDISC status */
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
+			      "0126 FDISC cmpl status: x%x/x%x)\n",
+			      ulp_status, ulp_word4);
 		goto fdisc_failed;
 	}
 
-- 
2.43.0

