Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AE0400DF0
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682267; cv=none; b=LEFoE9EuiPcGXICFseAtm0MH6fFH5fIOaMCQD/+U2HNfztmn5Zs9qmu9bJfupBvVco+2HGyiZMkhGa9y9mYLis74rBSo1fA6rrw0MGL4LRuZAYkXa2mp/x4joO3nEMk5puOR3WBWzO89y08ditn32z1+2n6gLlJDHKpS3SvmyAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682267; c=relaxed/simple;
	bh=WIScuujzddTrgHT0EnZoiLwICh5hkzO/b7ZYbAqsXI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sa9mwKrAb1AkS6Z9JFVVGzEeUvPBWG0Zn6PypgnBZf/xbysUxO6zGC/2kLzYcfU0ddDSaRG70Irv/M4ILEyxpzSs3jhzRWZg1mT4jb5z8WUWW8OegnS0pzcplRpIb6E7o5KzDtO2FA4dEcEqMzbERyCMAw8BVzO7Ib+KaAJp9XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LU2CjmHE; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LU2CjmHE"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea50dc1so8612a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682264; x=1790287064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z9yd+itfIBrDbk16/o9tJgIzv+kMHF9M3fZ5dvTCTnA=;
        b=LU2CjmHERuuEavDZmhk56cn8HFosFEkqsF6Le8ZVJmtCovQT/CbWpFHReD1Zr2vem+
         /A4l7Q0X2ODcxaLziwPGE1dl/gxNUEESRNVTgxlLqMQ6zcBxOUyxNSfjwle5h8mllYeM
         YvWTqz5u61S43yR/06Xwy8bFHbgVlDaHcAhcIyFe3/4NcIpYpAPTijBu7ezSO/0HJv1x
         ETbhmhPloSKOXjEO4KMR820LHbbVgNqkwzZOsDNiGvhugYgMEGQawMDg2OH7nZA15nPl
         XeRb7XcXvXfS3HQ4VKneqEx/ND7d5xooAQPnQPBH7UNVp7KUIyydlXXZZ/S0XWWgCE2y
         osYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682264; x=1790287064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z9yd+itfIBrDbk16/o9tJgIzv+kMHF9M3fZ5dvTCTnA=;
        b=zj4x0xV7hzVCGDGB6IYeXFDrjD2jSlVzNbUZkzqOYhvFNP86wTMzki0bd/YWgOMUP8
         V2m8RFQv28K8depRCbViK79lHFPqCfNxcW2hqMBZUy4hMWHbQvnjyb2WBaOKOjjNRDuU
         WKtGcudgVvii1SfDGYJ9fmJ1wNaBhQj37aqHaoqMDlAGHl5u8pQGkWApzH/hCQDi50aP
         vqH/r7l+UbW4zS7n/DzSRYQX+L4elA1lmcdzyKMSFjF6jsGqmw8nyUSxIOz2cm9cqA/s
         C76xd6Sq94hSlG1XDcuwh7S94WMyKFrmiaEQKHYukY6DT/malnq5F5+e5RtYR3rw8Ug2
         rjgg==
X-Gm-Message-State: AFuF++lQeAFLPOC59LDIjz9lVvyWLUaFwxgUfNRJ6z64tuLtzwvIxcQ5
	IQ7V0M3i5u2rQsVHX6oC91hPUEnBfdnDg7H7LVMzZyA1bJzwD6JNxsWvKgG7anhg
X-Gm-Gg: AYBFou3cO3WDv93xZdlLUjhkPtOxMxQ6sttesUhC5V8BjDHboRqxA2hba7p+uYyHnzR
	yhJH4ML8d845y5DEn2xRD4fzE2XN86BDK41N8RH/Qa+eBQDHeY0tCeDTyYkyimhzm5tE1oIdxEv
	nkNe1kDkxP3fhHCSTh9xQYwi0olcDDm9tb0tKw+TSTi9SZOXp4K3LCKWspAIChdKF10mh6G8sUk
	XGmDCs49+vX3Uwszgg/6o8DWDfHhuW3P6wYeYbT9qW4xJL48oEQGj45qvgUC4zwR/8sekrDHtLp
	rnIncv9TMi0TsHjEvUGONMu13QHMLpOoBojWd4ztbN/LF3TOB49ekUKlQN8b76+oZOfdRSIGMyE
	kvwPgtoFA0i+qVQ6m4yOBx+GSw489qw8T6SH2tJQOUkutToAkR7nmWL5+NwuK3oZqpBC7ZLueUj
	T1olDrqHrTxxDqbyhYYHbkk+CgtSGOig9/LstqtDf6LU/segMF+rxUnR6ueoWUPQm0XXs7+w9iT
	/UVYyOkZJV9zDH68dg9QAM8S0YXvpHdpq90TwCg2oKZtbQqIjaFrSXdNc4=
X-Received: by 2002:a05:6a20:c989:b0:3d1:c99f:efbf with SMTP id adf61e73a8af0-3dd8c43822fmr695622637.14.1789682263596;
        Thu, 17 Sep 2026 14:57:43 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:43 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 11/14] lpfc: Put iocbq on phba->txq when ELS WQ is full or ELS SGL unavailable
Date: Thu, 17 Sep 2026 15:20:12 -0700
Message-Id: <20260917222015.61053-12-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260917222015.61053-1-nkirkland2304@gmail.com>
References: <20260917222015.61053-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When ELS/CT commands can't be sent due to ELS WQ full, queue the iocbq on
the phba->txq tail for retrying submission later in lpfc_drain_txq.

lpfc_drain_txq is flagged to be called by the worker thread when an ELS CQE
completes lpfc_sli4_sp_handle_els_wcqe through the HBA_SP_QUEUE_EVT flag.

lpfc_drain_txq is also updated to queue an iocbq back on to the head of
phba->txq when lpfc_drain_txq itself still observes ELS WQ full or SGL
unavailable events.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c       |   2 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   7 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  21 ++++-
 drivers/scsi/lpfc/lpfc_els.c       | 110 +++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_init.c      |   5 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |   9 ++-
 drivers/scsi/lpfc/lpfc_sli.c       | 121 ++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_sli.h       |  18 +++++
 8 files changed, 227 insertions(+), 66 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 63b6839230df..7919d3bf2cce 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -2968,7 +2968,7 @@ static int lpfcdiag_sli3_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
 
 		iocb_stat = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq,
 						0);
-		if (iocb_stat == IOCB_ERROR) {
+		if (lpfc_iocb_failed(iocb_stat)) {
 			diag_cmd_data_free(phba,
 				(struct lpfc_dmabufext *)mp[0]);
 			if (mp[1])
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 2ca5f0229ca1..47a593fe5e69 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -536,8 +536,11 @@ int lpfc_bsg_timeout(struct bsg_job *);
 int lpfc_bsg_ct_unsol_event(struct lpfc_hba *, struct lpfc_sli_ring *,
 			     struct lpfc_iocbq *);
 int lpfc_bsg_ct_unsol_abort(struct lpfc_hba *, struct hbq_dmabuf *);
-void __lpfc_sli_ringtx_put(struct lpfc_hba *, struct lpfc_sli_ring *,
-	struct lpfc_iocbq *);
+void lpfc_sli4_queue_io_for_retry(struct lpfc_hba *phba,
+				  struct lpfc_iocbq *iocb,
+				  bool head);
+void __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *ring,
+			   struct lpfc_iocbq *iocb, bool head);
 struct lpfc_iocbq *lpfc_sli_ringtx_get(struct lpfc_hba *,
 	struct lpfc_sli_ring *);
 int __lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index f709e5087577..372fa5718f3a 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -246,7 +246,7 @@ lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
 		goto ct_no_ndlp;
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq, 0);
-	if (rc) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_nlp_put(ndlp);
 		goto ct_no_ndlp;
 	}
@@ -639,11 +639,24 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 		goto out;
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, geniocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
+		lpfc_vlog_msg(vport, KERN_NOTICE,
+			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+			      "0156 %ps WQE Put returned %d\n",
+			      cmpl, rc);
+
+		/* Under heavy vpi counts, the driver's host_index can catch up
+		 * to the hba_index causing a put error. Catch this case and
+		 * put the IO on phba->txq.
+		 */
+		if (rc == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			lpfc_sli4_queue_io_for_retry(phba, geniocb, false);
+			return 0;
+		}
+
 		lpfc_nlp_put(ndlp);
 		goto out;
 	}
-
 	return 0;
 out:
 	lpfc_sli_release_iocbq(phba, geniocb);
@@ -2258,7 +2271,7 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				/* Retry the same FDMI command */
 				err = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING,
 							  cmdiocb, 0);
-				if (err == IOCB_ERROR)
+				if (lpfc_iocb_failed(err))
 					break;
 				return;
 			default:
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 7309fb948bea..bf71b5a3e55e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1431,7 +1431,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	set_bit(HBA_FLOGI_OUTSTANDING, &phba->hba_flag);
 
 	rc = lpfc_issue_fabric_iocb(phba, elsiocb);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		clear_bit(HBA_FLOGI_ISSUED, &phba->hba_flag);
 		clear_bit(HBA_FLOGI_OUTSTANDING, &phba->hba_flag);
 		lpfc_nlp_put(ndlp);
@@ -2439,7 +2439,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 	}
 
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (ret) {
+	if (lpfc_iocb_failed(ret)) {
 		lpfc_vlog_msg(vport, KERN_NOTICE,
 			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
 			      "0157 PLOGI WQE Put returned %d\n",
@@ -2450,8 +2450,15 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 		 * put the IO on phba->txq.
 		 */
 		if (ret == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			/* The iocb will always successfully get queued
+			 * for a retry
+			 */
 			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
-			return 0;
+
+			/* Goto the out label to mark the nlp_flag correctly.
+			 * The IO will eventually go out.
+			 */
+			goto out;
 		}
 
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -2459,6 +2466,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *vport, uint32_t did, uint8_t retry)
 		return 1;
 	}
 
+out:
 	set_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);
 	return 0;
 }
@@ -2780,7 +2788,7 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_vlog_msg(vport, KERN_NOTICE,
 			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
 			      "0155 PRLI WQE Put returned %d\n",
@@ -2791,8 +2799,15 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		 * put the IO on phba->txq.
 		 */
 		if (rc == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			/* The iocb will always successfully get queued for a
+			 * retry
+			 */
 			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
-			return 0;
+
+			/* Jump to out_next because the prli counters and an NVME
+			 * PRLI need to be exercised.
+			 */
+			goto out_next;
 		}
 
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -2800,6 +2815,7 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		return 1;
 	}
 
+out_next:
 	/* The vport counters are used for lpfc_scan_finished, but
 	 * the ndlp is used to track outstanding PRLIs for different
 	 * FC4 types.
@@ -3121,7 +3137,7 @@ lpfc_issue_els_adisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		goto err;
@@ -3331,7 +3347,7 @@ lpfc_issue_els_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		goto err;
@@ -3701,7 +3717,7 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint8_t retry)
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR)
+	if (lpfc_iocb_failed(rc))
 		goto out_iocb_error;
 
 	return 0;
@@ -3804,7 +3820,7 @@ lpfc_issue_els_rscn(struct lpfc_vport *vport, uint8_t retry)
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -3899,7 +3915,7 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32_t nportid, uint8_t retry)
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		/* The additional lpfc_nlp_put will cause the following
 		 * lpfc_els_free_iocb routine to trigger the release of
 		 * the node.
@@ -4000,7 +4016,7 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		err = -EIO;
 		goto out_iocb_error;
 	}
@@ -4529,7 +4545,7 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
 			      "Issue EDC:     did:x%x refcnt %d",
 			      ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		/* The additional lpfc_nlp_put will cause the following
 		 * lpfc_els_free_iocb routine to trigger the release of
 		 * the node.
@@ -6010,7 +6026,21 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
+		lpfc_vlog_msg(vport, KERN_NOTICE,
+			      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+			      "0154 LS_ACC WQE Put returned %d\n",
+			      rc);
+
+		/* Under heavy vpi counts, the driver's host_index can catch up
+		 * to the hba_index causing a put error. Catch this case and
+		 * put the IO on phba->txq.
+		 */
+		if (rc == IOCB_FAILED_PUT && phba->sli_rev == LPFC_SLI_REV4) {
+			lpfc_sli4_queue_io_for_retry(phba, elsiocb, false);
+			return 0;
+		}
+
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -6112,7 +6142,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -6204,7 +6234,7 @@ lpfc_issue_els_edc_rsp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -6310,7 +6340,7 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -6502,7 +6532,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport *vport, struct lpfc_iocbq *oldiocb,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -6616,7 +6646,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport *vport, uint8_t format,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -6750,7 +6780,7 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -7418,7 +7448,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 	}
@@ -7461,7 +7491,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 	}
@@ -7824,7 +7854,7 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 	}
@@ -7870,7 +7900,7 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 	}
@@ -8972,7 +9002,7 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 	}
@@ -9136,7 +9166,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 	}
@@ -9211,7 +9241,7 @@ lpfc_issue_els_rrq(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		goto io_err;
 
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (ret == IOCB_ERROR) {
+	if (lpfc_iocb_failed(ret)) {
 		lpfc_nlp_put(ndlp);
 		goto io_err;
 	}
@@ -9332,7 +9362,7 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *vport, uint16_t cmdsize,
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return 1;
@@ -10611,6 +10641,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	uint8_t rjt_exp, rjt_err = 0, init_link = 0;
 	struct lpfc_wcqe_complete *wcqe_cmpl = NULL;
 	LPFC_MBOXQ_t *mbox;
+	u16 rcv_oxid;
 
 	if (!vport || !elsiocb->cmd_dmabuf)
 		goto dropit;
@@ -10680,11 +10711,18 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	if ((cmd & ELS_CMD_MASK) == ELS_CMD_RSCN) {
 		cmd &= ELS_CMD_MASK;
 	}
+
+	/* Fetch the incoming ox_id for SLI4 only - SLI3 can't do this. */
+	rcv_oxid = 0xffff;
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		rcv_oxid = get_job_rcvoxid(phba, elsiocb);
+
 	/* ELS command <elsCmd> received from NPORT <did> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0112 ELS command x%x received from NPORT x%x "
-			 "refcnt %d Data: x%x x%lx x%x x%x\n",
-			 cmd, did, kref_read(&ndlp->kref), vport->port_state,
+			 "refcnt %d rcvoxid x%x Data: x%x x%lx x%x x%x\n",
+			 cmd, did, kref_read(&ndlp->kref),
+			 rcv_oxid, vport->port_state,
 			 vport->fc_flag, vport->fc_myDID, vport->fc_prevDID);
 
 	/* reject till our FLOGI completes or PLOGI assigned DID via PT2PT */
@@ -11773,7 +11811,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		goto err_out;
 
 	rc = lpfc_issue_fabric_iocb(phba, elsiocb);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_nlp_put(ndlp);
 		goto err_out;
 	}
@@ -11911,7 +11949,7 @@ lpfc_issue_els_npiv_logo(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		goto err;
@@ -11992,8 +12030,7 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba *phba)
 				      iocb->vport->port_state, 0, 0);
 
 		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
-
-		if (ret == IOCB_ERROR) {
+		if (lpfc_iocb_failed(ret)) {
 			iocb->cmd_cmpl = iocb->fabric_cmd_cmpl;
 			iocb->fabric_cmd_cmpl = NULL;
 			iocb->cmd_flag &= ~LPFC_IO_FABRIC;
@@ -12157,8 +12194,7 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 				      iocb->vport->port_state, 0, 0);
 
 		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
-
-		if (ret == IOCB_ERROR) {
+		if (lpfc_iocb_failed(ret)) {
 			iocb->cmd_cmpl = iocb->fabric_cmd_cmpl;
 			iocb->fabric_cmd_cmpl = NULL;
 			iocb->cmd_flag &= ~LPFC_IO_FABRIC;
@@ -12580,7 +12616,7 @@ int lpfc_issue_els_qfpa(struct lpfc_vport *vport)
 	}
 
 	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 2);
-	if (ret != IOCB_SUCCESS) {
+	if (lpfc_iocb_failed(ret)) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		return -EIO;
@@ -12664,7 +12700,7 @@ lpfc_vmid_uvem(struct lpfc_vport *vport,
 	}
 
 	ret = lpfc_sli_issue_iocb(vport->phba, LPFC_ELS_RING, elsiocb, 0);
-	if (ret != IOCB_SUCCESS) {
+	if (lpfc_iocb_failed(ret)) {
 		lpfc_els_free_iocb(vport->phba, elsiocb);
 		lpfc_nlp_put(ndlp);
 		goto out;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7352cb6e584b..a423bde283c9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2813,6 +2813,7 @@ lpfc_sli3_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cn
 	IOCB_t *icmd;
 	struct lpfc_iocbq *iocb;
 	struct lpfc_dmabuf *mp1, *mp2;
+	int rc;
 
 	cnt += pring->missbufcnt;
 
@@ -2875,8 +2876,8 @@ lpfc_sli3_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cn
 		icmd->ulpCommand = CMD_QUE_RING_BUF64_CN;
 		icmd->ulpLe = 1;
 
-		if (lpfc_sli_issue_iocb(phba, pring->ringno, iocb, 0) ==
-		    IOCB_ERROR) {
+		rc = lpfc_sli_issue_iocb(phba, pring->ringno, iocb, 0);
+		if (lpfc_iocb_failed(rc)) {
 			lpfc_mbuf_free(phba, mp1->virt, mp1->phys);
 			kfree(mp1);
 			cnt++;
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 27a891f7fcf4..49653ff35c56 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -1998,6 +1998,7 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 	LPFC_MBOXQ_t *pmb = (LPFC_MBOXQ_t *) arg;
 	MAILBOX_t *mb = &pmb->u.mb;
 	uint32_t did  = mb->un.varWords[1];
+	int rc;
 
 	if (mb->mbxStatus) {
 		/* RegLogin failed */
@@ -2076,7 +2077,13 @@ lpfc_cmpl_reglogin_reglogin_issue(struct lpfc_vport *vport,
 
 		ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_PRLI_ISSUE);
-		if (lpfc_issue_els_prli(vport, ndlp, 0)) {
+		rc = lpfc_issue_els_prli(vport, ndlp, 0);
+		if (rc) {
+			lpfc_vlog_msg(vport, KERN_NOTICE,
+				      LOG_ELS | LOG_DISCOVERY | LOG_NODE,
+				      "3015 PRLI Issue returning %d to DID "
+				      "x%06x, Send LOGO\n",
+				      rc, ndlp->nlp_DID);
 			lpfc_issue_els_logo(vport, ndlp, 0);
 			ndlp->nlp_prev_state = NLP_STE_REG_LOGIN_ISSUE;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 06dc01c9539e..bc46b14eca41 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -244,6 +244,38 @@ lpfc_sli4_pcimem_bcopy(void *srcp, void *destp, uint32_t cnt)
 #define lpfc_sli4_pcimem_bcopy(a, b, c) lpfc_sli_pcimem_bcopy(a, b, c)
 #endif
 
+/**
+ * lpfc_sli4_queue_io_for_retry - Put an ELS/CT IO request on the txq.
+ * @phba - pointer to the hba instance.
+ * @iocb - the IO request to put on the txq.
+ * @head  - A boolean to request a put to the head (true) or tail
+ *         (false) of the txq.
+ *
+ * This routine is for SLI4 interfaces only.
+ * When ELS/CT commands can't be sent because of ELS WQ full put status,
+ * queue the iocbq on the phba->txq, at the head or tail as requested by
+ * the caller, for a retry later in lpfc_drain_txq. The lpfc_drain_txq
+ * routine is called per ELS CQE completion.
+ */
+void lpfc_sli4_queue_io_for_retry(struct lpfc_hba *phba,
+				  struct lpfc_iocbq *iocb,
+				  bool head)
+{
+	unsigned long iflags;
+	struct lpfc_sli_ring *pring;
+
+	/* Mark the IO as in RETRY to stop a full reprep of the SGL/XRI. */
+	iocb->cmd_flag |= LPFC_IO_IN_RETRY;
+	pring = phba->sli4_hba.els_wq->pring;
+
+	/* Insert to the head or tail of the txq ring as indicated
+	 * by the caller's head argument.
+	 */
+	spin_lock_irqsave(&pring->ring_lock, iflags);
+	__lpfc_sli_ringtx_put(phba, pring, iocb, head);
+	spin_unlock_irqrestore(&pring->ring_lock, iflags);
+}
+
 /**
  * lpfc_sli4_wq_put - Put a Work Queue Entry on an Work Queue
  * @q: The Work Queue to operate on.
@@ -276,6 +308,10 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe128 *wqe)
 	/* If the host has not yet processed the next entry then we are done */
 	idx = ((q->host_index + 1) % q->entry_count);
 	if (idx == q->hba_index) {
+		lpfc_printf_log(q->phba, KERN_WARNING, LOG_SLI,
+				"9998 No available WQ Slots on "
+				"q_id x%x, host x%x, hba x%x\n",
+				q->queue_id, idx, q->hba_index);
 		q->WQ_overflow++;
 		return -EBUSY;
 	}
@@ -10445,6 +10481,7 @@ lpfc_mbox_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to address of newly added command iocb.
+ * @head: put at head (true) or tail (false)
  *
  * This function is called with hbalock held for SLI3 ports or
  * the ring lock held for SLI4 ports to add a command
@@ -10453,14 +10490,20 @@ lpfc_mbox_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
  **/
 void
 __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
-		    struct lpfc_iocbq *piocb)
+		      struct lpfc_iocbq *piocb, bool head)
 {
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		lockdep_assert_held(&pring->ring_lock);
 	else
 		lockdep_assert_held(&phba->hbalock);
-	/* Insert the caller's iocb in the txq tail for later processing. */
-	list_add_tail(&piocb->list, &pring->txq);
+
+	/* Insert the caller's iocb in the txq head or tail for later
+	 * processing.
+	 */
+	if (head)
+		list_add(&piocb->list, &pring->txq);
+	else
+		list_add_tail(&piocb->list, &pring->txq);
 }
 
 /**
@@ -10468,6 +10511,7 @@ __lpfc_sli_ringtx_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to address of newly added command iocb.
+ * @head: put at head (true) or tail (false)
  *
  * This function is called with hbalock held before a new
  * iocb is submitted to the firmware. This function checks
@@ -10613,7 +10657,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
  out_busy:
 
 	if (!(flag & SLI_IOCB_RET_IOCB)) {
-		__lpfc_sli_ringtx_put(phba, pring, piocb);
+		__lpfc_sli_ringtx_put(phba, pring, piocb, false);
 		return IOCB_SUCCESS;
 	}
 
@@ -10751,6 +10795,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	struct lpfc_queue *wq;
 	struct lpfc_sli_ring *pring;
 	u32 ulp_command = get_job_cmnd(phba, piocb);
+	int rc = IOCB_SUCCESS;
 
 	/* Get the WQ */
 	if ((piocb->cmd_flag & LPFC_IO_FCP) ||
@@ -10766,9 +10811,11 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	/*
 	 * The WQE can be either 64 or 128 bytes,
 	 */
-
 	lockdep_assert_held(&pring->ring_lock);
 	wqe = &piocb->wqe;
+	if (piocb->cmd_flag & LPFC_IO_IN_RETRY)
+		goto retry_io;
+
 	if (piocb->sli4_xritag == NO_XRI) {
 		if (ulp_command == CMD_ABORT_XRI_CX)
 			sglq = NULL;
@@ -10778,7 +10825,7 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 				if (!(flag & SLI_IOCB_RET_IOCB)) {
 					__lpfc_sli_ringtx_put(phba,
 							pring,
-							piocb);
+							piocb, false);
 					return IOCB_SUCCESS;
 				} else {
 					return IOCB_BUSY;
@@ -10819,12 +10866,19 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 			return IOCB_ERROR;
 	}
 
-	if (lpfc_sli4_wq_put(wq, wqe))
-		return IOCB_ERROR;
-
-	lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
+ retry_io:
+	piocb->cmd_flag &= ~LPFC_IO_IN_RETRY;
 
-	return 0;
+	/* Push the wqe to the wq and if successful, push to the txcmplq.
+	 * A return of -EBUSY the WQ is currently full and a retry possible.
+	 * Otherwise the put failed for another, nonretryable reason.
+	 */
+	rc = lpfc_sli4_wq_put(wq, wqe);
+	if (!rc)
+		lpfc_sli_ringtxcmpl_put(phba, pring, piocb);
+	else if (rc == -EBUSY)
+		return IOCB_FAILED_PUT;
+	return rc;
 }
 
 /*
@@ -12608,7 +12662,7 @@ lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			 ulp_context, (phba->sli_rev == LPFC_SLI_REV4) ?
 			 cmdiocb->iotag : iotag, iotag, cmdiocb, abtsiocbp,
 			 retval, ia, abtsiocbp->cmd_cmpl);
-	if (retval) {
+	if (lpfc_iocb_failed(retval)) {
 		cmdiocb->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 		__lpfc_sli_release_iocbq(phba, abtsiocbp);
 	}
@@ -13060,7 +13114,7 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 
 		spin_unlock(&lpfc_cmd->buf_lock);
 
-		if (ret_val == IOCB_ERROR)
+		if (lpfc_iocb_failed(ret_val))
 			__lpfc_sli_release_iocbq(phba, abtsiocbq);
 		else
 			sum++;
@@ -19200,7 +19254,7 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 			 ctiocb->abort_rctl, oxid, phba->link_state);
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, ctiocb, 0);
-	if (rc == IOCB_ERROR) {
+	if (lpfc_iocb_failed(rc)) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "2925 Failed to issue CT ABTS RSP x%x on "
 				 "xri x%x, Data x%x\n",
@@ -19581,7 +19635,7 @@ lpfc_sli4_handle_mds_loopback(struct lpfc_vport *vport,
 	iocbq->cmd_cmpl = lpfc_sli4_mds_loopback_cmpl;
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocbq, 0);
-	if (rc == IOCB_ERROR)
+	if (lpfc_iocb_failed(rc))
 		goto exit;
 
 	lpfc_in_buf_free(phba, &dmabuf->dbuf);
@@ -21301,12 +21355,15 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 		}
 		txq_cnt--;
 
+		/* Capture the return values that indicate an error during IO
+		 * submit and cannot be retried. Prefix message 2822.
+		 */
 		ret = __lpfc_sli_issue_iocb(phba, pring->ringno, piocbq, 0);
-
-		if (ret && ret != IOCB_BUSY) {
+		if (ret && ret != IOCB_BUSY && ret != IOCB_FAILED_PUT) {
 			fail_msg = " - Cannot send IO ";
 			piocbq->cmd_flag &= ~LPFC_DRIVER_ABORTED;
 		}
+
 		if (fail_msg) {
 			piocbq->cmd_flag |= LPFC_DRIVER_ABORTED;
 			/* Failed means we can't issue and need to cancel */
@@ -21319,9 +21376,35 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 			list_add_tail(&piocbq->list, &completions);
 			fail_msg = NULL;
 		}
-		spin_unlock_irqrestore(&pring->ring_lock, iflags);
-		if (txq_cnt == 0 || ret == IOCB_BUSY)
+
+		if (txq_cnt == 0 || ret == IOCB_BUSY ||
+		    ret == IOCB_FAILED_PUT) {
+			/* IOCB_FAILED_PUT is unique to SLI4 and means SGL/XRI
+			 * resources are allocated.  For this case, set the
+			 * in retry flag.  For SLI3 and 4, push the IO to the
+			 * txq for retry.
+			 */
+			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+					"2820 IOCB iotag x%x xri x%x ret %d "
+					"cmd_flg x%x txq_cnt x%x\n",
+					piocbq->iotag, piocbq->sli4_xritag, ret,
+					piocbq->cmd_flag, txq_cnt);
+			switch (ret) {
+			case IOCB_FAILED_PUT:
+				piocbq->cmd_flag |= LPFC_IO_IN_RETRY;
+				__lpfc_sli_ringtx_put(phba, pring, piocbq,
+						      true);
+				break;
+			case IOCB_BUSY:
+				__lpfc_sli_ringtx_put(phba, pring, piocbq,
+						      true);
+				break;
+			}
+			spin_unlock_irqrestore(&pring->ring_lock, iflags);
 			break;
+		}
+
+		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	}
 	/* Cancel all the IOCBs that cannot be issued */
 	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index cf7c42ec0306..37559efd0032 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -123,6 +123,7 @@ struct lpfc_iocbq {
 #define LPFC_IO_NVMET		0x800000 /* NVMET command */
 #define LPFC_IO_VMID            0x1000000 /* VMID tagged IO */
 #define LPFC_IO_CMF		0x4000000 /* CMF command */
+#define LPFC_IO_IN_RETRY	0x8000000 /* Caller is retrying IO. */
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
 	struct lpfc_vport *vport;/* virtual port pointer */
@@ -160,6 +161,23 @@ struct lpfc_iocbq {
 #define IOCB_ABORTED        4
 #define IOCB_ABORTING	    5
 #define IOCB_NORESOURCE	    6
+#define IOCB_FAILED_PUT     7
+
+/**
+ * lpfc_iocb_failed - test an IOCB issue return status for failure
+ * @rc: return status from an IOCB issue routine (e.g. lpfc_sli_issue_iocb).
+ *
+ * IOCB_SUCCESS is the only non-failure return value. Callers must test
+ * rc != IOCB_SUCCESS rather than rc == IOCB_ERROR, since that misses
+ * IOCB_FAILED_PUT (SLI-4 WQ full) and treats it as success.
+ *
+ * Return: true if the IOCB issue did not succeed.
+ */
+static inline bool
+lpfc_iocb_failed(int rc)
+{
+	return rc != IOCB_SUCCESS;
+}
 
 #define SLI_WQE_RET_WQE    1    /* Return WQE if cmd ring full */
 
-- 
2.38.0

