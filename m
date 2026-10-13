Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE153D8100
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 23:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791849199; cv=none; b=b99qqwkG9itxK0JvgoNLH3atgoF0C66B283tHA4Zyb2syZG5gEFCcctj9U+uA7xVoYbtzaXLN7Cglhe1vzzFUMqgfqCVxFVhhYFI2yoQXThCV51+N3DRhVgbDGIcQbUJ1JcmfpSVzgBLE/9OSEBjDNIVwVwt49RY8ed20u/5Vow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791849199; c=relaxed/simple;
	bh=Kh6EktoGRFf13wL2MO6Ns5YO6JZUkL/jGoRIi+k+L1U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iq15IUlrNAR81ItpMA0X4p0ZjcynMGovbL7tu7nK7P9ca4313LcbGf/4BTZCOzFBak5i6bgTDB0n4reXRTve0BfYx6U2AaRxcGipxQrNPdaMi1kPKrsdjeUJK+i+SiGO/v3EKgYZGrCPvDg2oziuV+aenrakZI9uHr6oQjkLyyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H2qoIFwe; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2qoIFwe"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-33c2520ad38so5486374eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 16:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791849193; x=1792453993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AkI7rKfZIgwcd/ndhMv0sWZfVOK59x+L/XmbtBFq4pQ=;
        b=H2qoIFwe1q0WdsFrr5WrDacxX4NbFKuFzflpbRKeXSb4zOW3cuc79H3UeE/GnNtVsu
         kNTP403cZZkcJoQ/SeZdXTg+1jSQeOMNk0FT5irTXoYII7HH16cDdZB5T3nRccfIecob
         qxbFm64ApVoJ3hHY+2GVvSP/jV//C7P0Xhni/3pBX8d7ra5M7Eqcd5fwV1TUambiixHg
         1A9WIfzZOuQsLfg2r7oAM8ZsL8Mczzlu+FCbrdiyMwNu8taxaUmVcKV0mrSEs8ERBrjR
         eDz0It8ODNQhUKjhCsQkekMoTX5slkCvUKvJTl7n2hjvV8iT+2JsD18A6Yq+B28WhlLm
         hGYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791849193; x=1792453993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AkI7rKfZIgwcd/ndhMv0sWZfVOK59x+L/XmbtBFq4pQ=;
        b=WY3B+tHofdKjIwiZobTm2STcPBieRzfpfjfwn+ZLAyGKm4+R2y25vCg5/Ul7gWPvd2
         pZ0FMngaHyKtNKUVeJvk7MX3HhbGo7OyTy0127wVTjTXBigs11QmylAnpZT5/+vl+wYh
         ta1Hbc6lbHxN2DTcwEilkQx20Rdg5XJN/z9mMwWUS4AmnMUAA6iAo67z9AW4DYQxeH7j
         mBNC1WPo4JZC7CZJX63YxQ4JPQIBFbNcn+aOmf8EFqmXHKuE/qjIW5jVBlb250xGPpq0
         jlHOYdbrMNldWxJplra7BNiqM0G1DG0RZ007JciMHttAjQ4HPAliXjGfL+eWO/0jBcVm
         qPLQ==
X-Gm-Message-State: AFq9FYITqu8eFRSdSTChAEhGrLY4RVn6cTduFfzqNpCD0ZxwUXNf4KwX
	8hGHGGpJptMVfAFDT6YQRWDw4WHRIvI0rgYgPMw8nokUqbs+UzURgBEX7QbKJ60I
X-Gm-Gg: AYBFou1O+J0ZxCHSIUvF/pq62cry2mdzqpM4I/GSIpeTeWDFfsSN7HfPKBtQa/KSJQU
	39JctER1Qohy91nvHMpQbNWh6+0lhQG2RJiL9oOdx1rZTW28ODMiw8VXugPBhY7SNUZNlgCQXFR
	Y2Zl3TsRnUkDfAr+CtNRHEtVGVs2K8MioyL1haOh5co3B846TsRylR7rjUC+uYYsu74SMCyF0ef
	rsR5fAE0YKnCt6KgnhX/R/1LPeFJrSAG/3gNVWbWeM6+IqjGpIYxOCFr/pJP/OUa1vj09jKef9q
	DqonSavR+xBE3vM5QQNfXhSVwWHq3S0RCyfeTJAqZKcFm+cxT45q6fyKZxqnUr5Bu8NUvJjhXe5
	j0I4L48A8SoYYdoBPdnVCO9Ef4zKuqypA0LASlADGZFFsZmldHhuL5a4kMA6oRcW8imNaFRT4tx
	zGUTVLoKL7JvcNQFF91a3rxX6Loq4GMvE2Qu+gkdncktZQmlNPIbUoJDYb/aTxOrpE7kDMDZpKD
	Vo/Mq+Pyxm0/nBu/byAYK0qJgpzUC2m8DsGto9qzAiuhZ/0y7VrM2i5mg==
X-Received: by 2002:a05:693c:2a08:b0:35a:3b98:b440 with SMTP id 5a478bee46e88-35a3b98bb79mr6497452eec.3.1791849193336;
        Mon, 12 Oct 2026 16:53:13 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b29c2f861sm15137264eec.11.2026.10.12.16.53.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Oct 2026 16:53:12 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: jsmart833426@gmail.com,
	paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v6 7/8] lpfc: Update correct ndlp refcnt when rejecting an unsolicited PLOGI
Date: Mon, 12 Oct 2026 17:16:47 -0700
Message-Id: <20261013001648.62289-8-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20261013001648.62289-1-nkirkland2304@gmail.com>
References: <20261013001648.62289-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The domain controller FC_ID can change whenever a fabric switch with
an ISL link is replaced or the admin reconfigures the fabric switch
with active links. In such situations, reference count updates should
be applied to the correct nodelist structure.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>

---
 drivers/scsi/lpfc/lpfc_els.c       | 37 ++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  7 ++++++
 drivers/scsi/lpfc/lpfc_nportdisc.c | 14 +++++++++++
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 5691af515b43..0e5038feec9a 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5952,11 +5952,12 @@ lpfc_els_rsp_reject(struct lpfc_vport *vport, uint32_t rejectError,
 	/* Xmit ELS RJT <err> response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0129 Xmit ELS RJT x%x response tag x%x "
-			 "xri x%x, did x%x, nlp_flag x%lx, nlp_state x%x, "
-			 "rpi x%x\n",
+			 "xri x%x, ndlp x%px, did x%x, nlp_flag x%lx, "
+			 "nlp_state x%x, rpi x%x ref_cnt %d\n",
 			 rejectError, elsiocb->iotag,
-			 get_job_ulpcontext(phba, elsiocb), ndlp->nlp_DID,
-			 ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
+			 get_job_ulpcontext(phba, elsiocb), ndlp,
+			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
+			 ndlp->nlp_rpi, kref_read(&ndlp->kref));
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
 		"Issue LS_RJT:    did:x%x flg:x%lx err:x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, rejectError);
@@ -10457,6 +10458,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		      struct lpfc_vport *vport, struct lpfc_iocbq *elsiocb)
 {
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *alloc_ndlp = NULL;
 	struct ls_rjt stat;
 	u32 *payload, payload_len;
 	u32 cmd = 0, did = 0, newnode, status = 0;
@@ -10555,7 +10557,9 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			did, vport->port_state, ndlp->nlp_flag);
 
 		phba->fc_stat.elsRcvPLOGI++;
+		alloc_ndlp = ndlp;
 		ndlp = lpfc_plogi_confirm_nport(phba, payload, ndlp);
+
 		if (phba->sli_rev == LPFC_SLI_REV4 &&
 		    test_bit(FC_PT2PT, &phba->pport->fc_flag)) {
 			vport->fc_prevDID = vport->fc_myDID;
@@ -10871,13 +10875,28 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		stat.un.b.lsRjtRsnCodeExp = rjt_exp;
 		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, elsiocb, ndlp,
 				    NULL);
-		/* Remove the reference from above for new nodes. */
-		if (newnode)
-			lpfc_disc_state_machine(vport, ndlp, NULL,
-					NLP_EVT_DEVICE_RM);
+
+		/* Remove the safety reference from routine start. */
+		if (newnode) {
+			/* alloc_ndlp is assigned for an unsolicited PLOGI from
+			 * the ndlp allocated by this routine. The routine
+			 * lpfc_plogi_confirm_nport may have swapped the initial
+			 * ndlp to an existing ndlp. In that case, alloc_ndlp
+			 * is the pre-swap ndlp that needs a DEVICE_RM because
+			 * it is the newnode. For all other paths to lsrjt
+			 * (non-PLOGI ELS) that were rejected by the early
+			 * port_state check, alloc_ndlp is NULL and ndlp is
+			 * still the originally allocated node.
+			 */
+			lpfc_disc_state_machine(vport,
+						alloc_ndlp ? alloc_ndlp : ndlp,
+						NULL, NLP_EVT_DEVICE_RM);
+		}
 	}
 
-	/* Release the reference on this elsiocb, not the ndlp. */
+	/* This elsiocb is not the IOCB issued for a response. Remove
+	 * the safety reference allocated earlier.
+	 */
 	lpfc_nlp_put(elsiocb->ndlp);
 	elsiocb->ndlp = NULL;
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4c673dffa671..57cdd669928c 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4951,6 +4951,13 @@ lpfc_drop_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	 */
 	if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
 		return;
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE | LOG_ELS | LOG_DISCOVERY,
+			"3421 Mark ndlp x%px Dropped. DID x%06x, nflags x%lx "
+			"xflags x%x ref_cnt %d\n",
+			 ndlp, ndlp->nlp_DID, ndlp->nlp_flag,
+			 ndlp->fc4_xpt_flags, kref_read(&ndlp->kref));
+
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNUSED_NODE);
 	if (vport->phba->sli_rev == LPFC_SLI_REV4) {
 		lpfc_cleanup_vports_rrqs(vport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index f917a5bcfd02..ffec352c8ab2 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -2878,6 +2878,20 @@ lpfc_device_rm_npr_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		set_bit(NLP_NODEV_REMOVE, &ndlp->nlp_flag);
 		return ndlp->nlp_state;
 	}
+
+	/* It is an error to drop a node while either of its transport
+	 * registrations have not completed.
+	 */
+	if (ndlp->fc4_xpt_flags & (SCSI_XPT_REGD | NVME_XPT_REGD)) {
+		lpfc_printf_vlog(vport, KERN_WARNING,
+				 LOG_ELS | LOG_NODE | LOG_DISCOVERY,
+				 "3423 Not dropping ndlp x%px, DID x%x xflags x%x "
+				 "with dev_loss pending. ref_cnt %d\n",
+				 ndlp, ndlp->nlp_DID, ndlp->fc4_xpt_flags,
+				 kref_read(&ndlp->kref));
+		return ndlp->nlp_state;
+	}
+
 	lpfc_drop_node(vport, ndlp);
 	return NLP_STE_FREED_NODE;
 }
-- 
2.38.0

