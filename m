Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7A11CB316
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412940; cv=none; b=kOMYa+7m7FpYs8ymg+bxI9dXfheELMMn7Mm78qRgY0WvOKkLaGdin7J1l7YXNK5IeHDbrElDzkz1hNkcSeXUKPVThAyXsOweE245RmMJ13LPnqB1DC8NqRS4Tr6y7G0aCiW5K9DCjaRXQFj3sFNesxeUEWC3/Oj4DLuewy9Oqck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412940; c=relaxed/simple;
	bh=1ZuHTf3kqiBN3hOlcwSTywnhn7tKsGFC3Cvh40sxIaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P9PD3NQJ52tqMmt3RJ6UIrOLyHaVfqZkRvA2JGzwqlegKhm2FKTbXGV/wWKGkuACKKzyD5oTkFsQc5oQ3RofjLabS7EaMNjqTh+Wdh5guTlfcEvcJz3XaUKzK74JjEPjfojps1JADKpWJe1QYcmBB3y86E8itmij+9UVAf1ZZzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gptGrChN; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gptGrChN"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e2a999b287so1200464a91.0
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412934; x=1731017734; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3nd/3JJZdLL7cGf9xdxqbLrOalULGknzu5k2mq/p8UM=;
        b=gptGrChNZhdidAFx9sN5TkzlBFcQGsJyQ9V2+5D7KyvTwB7z1I2PHMyVFAvcsWghd3
         gPouXXC/w/siR0bHRf6Hof5P2bnVbDyvD+AC2V9uUW2S8WNGxlWc15dTeNiM363bsQCb
         oSgi0Ji8/HF+EC81+HK8zZwvNmwnMHHHrE/2BZlzm1IGZX2tqEOQiMVLjRnX9zIRxCLH
         JNVfDxrn4BqznTOYl11yD1Cq6ZVy5LFzgwMsNrWYQtdOlqBraNkhjNHkNWEWjb86fJ19
         bPIZ8kyW8AAuSBE+2NuUG7gk8wLnTRQQfeJkHQE5sKdBGiylA+N9yiQcHE9YeAEv97SY
         Vedw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412934; x=1731017734;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3nd/3JJZdLL7cGf9xdxqbLrOalULGknzu5k2mq/p8UM=;
        b=YWlsO6mlHWrg8jMuk5kdccXqnAkifgl44EEOGjryhjeravoav+nYDwZ8XQrRn8VlEU
         6+XvCa87qLbiEf2Y/Ut2kVAFVMX7z4Zbhh3hI79pFk1v+0Kvx6jDPukjg5KoOKACzWx8
         KA5lqcVEGUpIMzGwIeyE1fmRo++HFANkIS4GYFuV3Q0jv07OmI4Yi6wBNolEI4Rp3KKe
         78VktdAVUkaV8QmYODkvTD1wpt9iMTwS8fV+LmwnB/Xxgu/S5PF0i0uXauOCZZGqmIL+
         fVJhpWuS1e7hb9seRqLtjmduHXU62oxjem5l+aQ+GI7DWsFQORrTWl7UBVOLzNPwyhNC
         cfTw==
X-Gm-Message-State: AOJu0Yy2s4c5NVBQ6TOdKIIO6+u7XngWf8bzX3otEnukjmFBC+OZdmEK
	FfHgBC1a9KBYGJKfxjjD/EYRbbkgiP+q3LcUwGldvC9jHyB16q3Sjr5Z/w==
X-Google-Smtp-Source: AGHT+IGxagEIZgOObxKQTN5sXeSb7MPMJ8vtBYHcHElkQC4GObjIa4Ibz7KXFBhDwhr3rnE52A4iig==
X-Received: by 2002:a17:90b:1805:b0:2e2:e743:7501 with SMTP id 98e67ed59e1d1-2e93c158ce6mr5887243a91.8.1730412934328;
        Thu, 31 Oct 2024 15:15:34 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:34 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 07/11] lpfc: Prevent ndlp reference count underflow in dev_loss_tmo callback
Date: Thu, 31 Oct 2024 15:32:15 -0700
Message-Id: <20241031223219.152342-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current dev_loss_tmo handling checks whether there has been a previous call
to unregister with SCSI transport.  If so, the ndlp kref count is
decremented a second time in dev_loss_tmo as the final kref release.
However, this can sometimes result in a reference count underflow if there
is also a race to unregister with NVME transport as well.  Add a check for
NVME transport registration before decrementing the final kref.  If NVME
transport is still registered, then the NVME transport unregistration is
designated as the final kref decrement.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 36 +++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index a434faec3c92..3c8cb6ecc0ac 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -161,6 +161,7 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	struct lpfc_hba   *phba;
 	struct lpfc_work_evt *evtp;
 	unsigned long iflags;
+	bool nvme_reg = false;
 
 	ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
 	if (!ndlp)
@@ -183,38 +184,49 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	/* Don't schedule a worker thread event if the vport is going down. */
 	if (test_bit(FC_UNLOADING, &vport->load_flag) ||
 	    !test_bit(HBA_SETUP, &phba->hba_flag)) {
+
 		spin_lock_irqsave(&ndlp->lock, iflags);
 		ndlp->rport = NULL;
 
+		if (ndlp->fc4_xpt_flags & NVME_XPT_REGD)
+			nvme_reg = true;
+
 		/* The scsi_transport is done with the rport so lpfc cannot
-		 * call to unregister. Remove the scsi transport reference
-		 * and clean up the SCSI transport node details.
+		 * call to unregister.
 		 */
-		if (ndlp->fc4_xpt_flags & (NLP_XPT_REGD | SCSI_XPT_REGD)) {
+		if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
 			ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
 
-			/* NVME transport-registered rports need the
-			 * NLP_XPT_REGD flag to complete an unregister.
+			/* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
+			 * unregister calls were made to the scsi and nvme
+			 * transports and refcnt was already decremented. Clear
+			 * the NLP_XPT_REGD flag only if the NVME Rport is
+			 * confirmed unregistered.
 			 */
-			if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD))
+			if (!nvme_reg && ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
 				ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
+				spin_unlock_irqrestore(&ndlp->lock, iflags);
+				lpfc_nlp_put(ndlp); /* may free ndlp */
+			} else {
+				spin_unlock_irqrestore(&ndlp->lock, iflags);
+			}
+		} else {
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
-			lpfc_nlp_put(ndlp);
-			spin_lock_irqsave(&ndlp->lock, iflags);
 		}
 
+		spin_lock_irqsave(&ndlp->lock, iflags);
+
 		/* Only 1 thread can drop the initial node reference.  If
 		 * another thread has set NLP_DROPPED, this thread is done.
 		 */
-		if (!(ndlp->fc4_xpt_flags & NVME_XPT_REGD) &&
-		    !(ndlp->nlp_flag & NLP_DROPPED)) {
-			ndlp->nlp_flag |= NLP_DROPPED;
+		if (nvme_reg || (ndlp->nlp_flag & NLP_DROPPED)) {
 			spin_unlock_irqrestore(&ndlp->lock, iflags);
-			lpfc_nlp_put(ndlp);
 			return;
 		}
 
+		ndlp->nlp_flag |= NLP_DROPPED;
 		spin_unlock_irqrestore(&ndlp->lock, iflags);
+		lpfc_nlp_put(ndlp);
 		return;
 	}
 
-- 
2.38.0

