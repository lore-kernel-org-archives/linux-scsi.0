Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704B719C54B
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 23:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726182608; cv=none; b=OvduhHE+kL/bEZRTEH2KEDioMu2OBlCVAlEyqlHFmnfJj6hrGtmmoRViwX1NVxZPueyaHQwbvoF8FcwXlStaki0kotzhHdoig5srgt0OwE8YDPA+HOEEeO85G6vil2D5wI9LfzNNNAGU9wbrjWZcWLIPCMFd4y2zTGjtQ3S9g9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726182608; c=relaxed/simple;
	bh=wrT9R21RbqGOWfhQJjIvM79ODjldw7ZoGgoGXBc6cKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kMpnI1/BHLFtxLckfY1l4aK20f7DIPD6Xe47mTRhRN8mc96X/fCbaJwDPRiYNn6ilr4vljJiSdYWV7nsRH3BdjW09ra5oxiDEAOqoKL3EPLCb4mz4gJ/wgbNQTQrVTMpBIttZCGlf4q2aVDm0U5jDttatKquvnb1t3eFjVNzAMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DtlZQt+n; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DtlZQt+n"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7a99eee4a5bso119496085a.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 16:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726182605; x=1726787405; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oEm3wL9fq4CaN2luBUiZEIPyqyW+nUso8gsao198O7E=;
        b=DtlZQt+nJh8BAMK+Er6x02bfL5UVvqvYshzzQQ5E76zcz3e/w/LXMa1L9qFcvpLcXl
         rYBexXQWiuC0QZUIRnDA9p5HhdykqSKi/xP0S1hb6qN7Ge8pNeYFd6MT6cTwVy/zVMS1
         pw2xgLEJY6f1po11nD7RMBjrhTw8ClHIHJqk393pMB77hnNsuF1U26XY/QERXj5VvEh2
         pGuxWn1+sIGMuC+rjN+cqtrWFLDHfaW0zy/6hDU9UCAjJBAgl2m5YLMWSeAAX+qV+f5U
         GbCVhMueVvFeCwvvtNFjF5OiQ4TnTLVrjpNv611YkpM2AKOHruvw4aq2tFlj76orm42t
         KqRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726182605; x=1726787405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oEm3wL9fq4CaN2luBUiZEIPyqyW+nUso8gsao198O7E=;
        b=BZCUCm27oXeHqqOCK/oC1OXZqcu3b/1BSqmsRmq26dpib3FvaW3XbVQayouGpF31GB
         DNsPT3AG51kbQKhkcTTdkK8DQ9m2eKmyy+8bGKdVTpEPYIfhj9mGjRSpSSX4ULyq5dWi
         5gXwzIR1UWgi5IaomFLe0r52UiYTC+Tma8/X9Kw94Fd4pz4qsY8XqX1CVOHn/XtdaldZ
         8byrAC+lkY5oik5OLVPTZ18YOHzsGS8qk4ozxnRG6mmMy9p++dOBlxY8w351CpwPaeTa
         WTQC7qnHG2wr13eDGK2i8ekiX8WAMjNL+9/iGfI37fKxhf4Zl1rTL3Q1l618ZYiRVdAn
         RnQw==
X-Gm-Message-State: AOJu0YyVozdSEulrO1EvECQ5FlrKmfmJ7Dx+n24KcjjHmGzsXsJFt8Vp
	k6Y1Ej7SRMmANiZF2kkO9tbl8KI7REM87fpptEy9z1+eWRppQ7CBt0XnWQ==
X-Google-Smtp-Source: AGHT+IEiHL8o/qPecGsePx2+Gl4pdTSsCNKo7hIw5erKdOru29XBK3BXpqe/SXSHYMTJC3qYPrXfww==
X-Received: by 2002:a05:6214:5347:b0:6c5:60bd:2c8b with SMTP id 6a1803df08f44-6c5735a1681mr63729936d6.49.1726182605005;
        Thu, 12 Sep 2024 16:10:05 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c534339a88sm59363136d6.50.2024.09.12.16.10.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Sep 2024 16:10:04 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 5/8] lpfc: Ensure DA_ID handling completion before deleting an NPIV instance
Date: Thu, 12 Sep 2024 16:24:44 -0700
Message-Id: <20240912232447.45607-6-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240912232447.45607-1-justintee8345@gmail.com>
References: <20240912232447.45607-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Deleting an NPIV instance requires all fabric ndlps to be released before
an NPIV's resources can be torn down.  Failure to release fabric ndlps
beforehand opens kref imbalance race conditions.  Fix by forcing the DA_ID
to complete synchronously with usage of wait_queue.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c    | 12 ++++++++++
 drivers/scsi/lpfc/lpfc_disc.h  |  7 ++++++
 drivers/scsi/lpfc/lpfc_vport.c | 43 ++++++++++++++++++++++++++++------
 3 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 2dedd1493e5b..1e5db489a00c 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1647,6 +1647,18 @@ lpfc_cmpl_ct(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	}
 
 out:
+	/* If the caller wanted a synchronous DA_ID completion, signal the
+	 * wait obj and clear flag to reset the vport.
+	 */
+	if (ndlp->save_flags & NLP_WAIT_FOR_DA_ID) {
+		if (ndlp->da_id_waitq)
+			wake_up(ndlp->da_id_waitq);
+	}
+
+	spin_lock_irq(&ndlp->lock);
+	ndlp->save_flags &= ~NLP_WAIT_FOR_DA_ID;
+	spin_unlock_irq(&ndlp->lock);
+
 	lpfc_ct_free_iocb(phba, cmdiocb);
 	lpfc_nlp_put(ndlp);
 	return;
diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index f82615d87c4b..f5ae8cc15820 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -90,6 +90,8 @@ enum lpfc_nlp_save_flags {
 	NLP_IN_RECOV_POST_DEV_LOSS	= 0x1,
 	/* wait for outstanding LOGO to cmpl */
 	NLP_WAIT_FOR_LOGO		= 0x2,
+	/* wait for outstanding DA_ID to finish */
+	NLP_WAIT_FOR_DA_ID              = 0x4
 };
 
 struct lpfc_nodelist {
@@ -159,7 +161,12 @@ struct lpfc_nodelist {
 	uint32_t nvme_fb_size; /* NVME target's supported byte cnt */
 #define NVME_FB_BIT_SHIFT 9    /* PRLI Rsp first burst in 512B units. */
 	uint32_t nlp_defer_did;
+
+	/* These wait objects are NPIV specific.  These IOs must complete
+	 * synchronously.
+	 */
 	wait_queue_head_t *logo_waitq;
+	wait_queue_head_t *da_id_waitq;
 };
 
 struct lpfc_node_rrq {
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 4439167a5188..7a4d4d8e2ad5 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -626,6 +626,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
 	int rc;
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
@@ -679,21 +680,49 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	if (!ndlp)
 		goto skip_logo;
 
+	/* Send the DA_ID and Fabric LOGO to cleanup the NPIV fabric entries. */
 	if (ndlp && ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
 	    phba->link_state >= LPFC_LINK_UP &&
 	    phba->fc_topology != LPFC_TOPOLOGY_LOOP) {
 		if (vport->cfg_enable_da_id) {
-			/* Send DA_ID and wait for a completion. */
+			/* Send DA_ID and wait for a completion.  This is best
+			 * effort.  If the DA_ID fails, likely the fabric will
+			 * "leak" NportIDs but at least the driver issued the
+			 * command.
+			 */
+			ndlp = lpfc_findnode_did(vport, NameServer_DID);
+			if (!ndlp)
+				goto issue_logo;
+
+			spin_lock_irq(&ndlp->lock);
+			ndlp->da_id_waitq = &waitq;
+			ndlp->save_flags |= NLP_WAIT_FOR_DA_ID;
+			spin_unlock_irq(&ndlp->lock);
+
 			rc = lpfc_ns_cmd(vport, SLI_CTNS_DA_ID, 0, 0);
-			if (rc) {
-				lpfc_printf_log(vport->phba, KERN_WARNING,
-						LOG_VPORT,
-						"1829 CT command failed to "
-						"delete objects on fabric, "
-						"rc %d\n", rc);
+			if (!rc) {
+				wait_event_timeout(waitq,
+				   !(ndlp->save_flags & NLP_WAIT_FOR_DA_ID),
+				   msecs_to_jiffies(phba->fc_ratov * 2000));
 			}
+
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_VPORT | LOG_ELS,
+					 "1829 DA_ID issue status %d. "
+					 "SFlag x%x NState x%x, NFlag x%x "
+					 "Rpi x%x\n",
+					 rc, ndlp->save_flags, ndlp->nlp_state,
+					 ndlp->nlp_flag, ndlp->nlp_rpi);
+
+			/* Remove the waitq and save_flags.  It no
+			 * longer matters if the wake happened.
+			 */
+			spin_lock_irq(&ndlp->lock);
+			ndlp->da_id_waitq = NULL;
+			ndlp->save_flags &= ~NLP_WAIT_FOR_DA_ID;
+			spin_unlock_irq(&ndlp->lock);
 		}
 
+issue_logo:
 		/*
 		 * If the vpi is not registered, then a valid FDISC doesn't
 		 * exist and there is no need for a ELS LOGO.  Just cleanup
-- 
2.38.0

