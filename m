Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A14A3D4137
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 21:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789682258; cv=none; b=L6X7U/D6tFo2MD4sPNjT6uFHwyxGPhp6SdSB35gK5OMycBminYTVI1RPXhyT2DIUAgwAAyfEWkGLwS+0Ro3iSX+equBEH3Dh2lSPydMRwVZoOH+MEX1h1g/ElKvLijA+NT2b29fTrTH2PTlH0Ypjs3mHf5o3w6wkwpDpJhLwKjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789682258; c=relaxed/simple;
	bh=AcA6n7BtCrDZ/l2nF301ZVBWAjAtPnvb4wDrMmago4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jUr5iCTj8UH7rHvJEeehb5szSOPRlkNNFanqsKvKakoiP3Ygd1BxNf8jc9jIS4vcuVHg+RRQEOFwEnF7Gq09e2fwhUtmkN4ghBTS3ymzWZhVvMUDN4ytWkcwP4p+WhNTSYhdihtHKWwkDe+KS2X7fUSYebnGtoIorx2L4pPHvdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oH3llpMN; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oH3llpMN"
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-39b9184fa80so111323a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 14:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789682256; x=1790287056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vCllPmlhcV3zVx00pfDqLDeH41OTCO2dC4Ap6iksz20=;
        b=oH3llpMNi5E2kK+KKNHi043/AKJYVx/Rbi2RH80wYj14bNQa3Cv/WunMOytBG5t/OS
         a8DIxxS8v02+KExPSVMWDtn1JO2AhCrEdAN1d6bJqGvMNNREdbnh0D8YUdgWudvqL3ky
         gvg3i90vySHbNz+13qClG01WqFbPqQnxXcBH7bY6pT+Wm9GDNmSimlnLr/S2++AyeHYC
         CECW/lGZY1C0fikuHXbK2zB/bzOxsuKHNgG+FoQsnwYCYeMhZp74vbyqUP1MRqDb9bGI
         SbbmegUDiuUhM0htw10P+a7CFbI9OQp4QZ1aDYX/0pfNyku5GpjkzKAERP5op7tS5yVr
         2O6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789682256; x=1790287056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vCllPmlhcV3zVx00pfDqLDeH41OTCO2dC4Ap6iksz20=;
        b=gMwSWP2D2g7iYMJXGyVBbRzVhMVYcDNeZ4rEAdJNeFFWmLdn+FvWlvDpBkWOKBK+Nb
         SWB0vsAo432nfIC8Y5PaZv/vnOLnAkmqGmk34H0EGc0MKkvuZ8TeZ/Yz9qEnMwebWGYM
         tRnxwKzI3L4mf0Xq9UKzIqNbCUyIZYkqItWxd02fFlx7Uzqpm+Ljn5tHgn1yHjCpAaJP
         kMvTRcy3cXUG7CVWxS7T2pT+ZdYPI2mwY8gCRMio4L2KMsSO2uvdJ4dyl07/aGSJ/h7r
         N83yeOyocDBCkTSUg195zupq079tfZftgVfg5MemwXQJQhdvOWwHjiRULKaNXYckqCTH
         khaQ==
X-Gm-Message-State: AFuF++kKQFdNklxr+eJh66NOgoQPKc+2n0xSm0eRdiaxSNjB/2vf4vUj
	l4eLJsDGAe3e3hpXYEJAY4dL4nHFBvKxRvZ3BslwnI0RxQCDxVxCKryb58f1/EI8
X-Gm-Gg: AYBFou3uRWcz5OaIvXY03Xj+hYzmbjsrl1HonXou1eM1y7hDM4JbgdTSGZ6M+5Tr8Tp
	PCgRpls5RktibC6RrTb6efzMc1tonKVJtTa89c8aKWPd8/v9Qt/7eJoad9DgB7U0mdb0DQ2G59b
	k+FVn4ezAOry9EL+TzVsWoHZHOqZPeypAihm+jX+Mv3pNSlaZBobRhOVl/00zvmYpPaLoNqLmTb
	Jt8or4O/pRlFCt1MU6bdK+K6ZJFhIPqiJy/yD3Mi6aqcHJA3bGZBYyomB8VRKtFwdLEjLV48OND
	noE3mxvl6jf0yS6oGNB4/GV2R6LIeTQeE7qbr3ujf6ZFiBSVmrmwhH5pEi4h4esQPrAf1XeOCBJ
	gyfcWCW9rr2bHsC1Ayca3oS4IfLNXQPZDyC8C8E5WTJ1bOuo//8fpHc50Xa/VjB9ik1ppUk0n4n
	1BVX8jTooYUIptVAaffZACUGbq/Vobg0tXp/h372Qws7TZobM6OZxDj923PGkhUTT8VBjYQV3Mm
	aRXAz2261unQEXJkUXdLnyMpQSh4GyU8COQlfUMWnSZrKznnlPrtuFSU7o=
X-Received: by 2002:a17:90b:224c:b0:39d:f317:44cd with SMTP id 98e67ed59e1d1-39e54eab3dbmr1523085a91.14.1789682256335;
        Thu, 17 Sep 2026 14:57:36 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb19f8cesm24166254eec.2.2026.09.17.14.57.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2026 14:57:35 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v4 05/14] lpfc: Add handling for when PLOGI or PRLI is dropped during link failure
Date: Thu, 17 Sep 2026 15:20:06 -0700
Message-Id: <20260917222015.61053-6-nkirkland2304@gmail.com>
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

PLOGI and PRLI typically complete via the lpfc_cmpl_els_plogi and
lpfc_cmpl_els_prli handler respectively, but when the link drops they
complete via the lpfc_cmpl_els_link_down handler.  When this occurs, normal
cleanup completion actions are missed and we may fail to recover the login
session due to ndlp logistical mixups.  Fix by clearing the NLP_PLOGI_SND
or NLP_PRLI_SND flag and decrement the outstanding prli_sent counters in
the lpfc_cmpl_els_link_down handler.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 45aad4cd2dc8..cd431c7bd9f0 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1230,6 +1230,8 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	uint32_t *pcmd;
 	uint32_t cmd;
 	u32 ulp_status, ulp_word4;
+	struct lpfc_vport *vport = cmdiocb->vport;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 
 	pcmd = (uint32_t *)cmdiocb->cmd_dmabuf->virt;
 	cmd = *pcmd;
@@ -1237,17 +1239,40 @@ lpfc_cmpl_els_link_down(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	ulp_status = get_job_ulpstatus(phba, rspiocb);
 	ulp_word4 = get_job_word4(phba, rspiocb);
 
-	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"6445 ELS completes after LINK_DOWN: "
-			" Status %x/%x cmd x%x flg x%x iotag x%x\n",
-			ulp_status, ulp_word4, cmd,
-			cmdiocb->cmd_flag, cmdiocb->iotag);
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "6445 ELS completes after LINK_DOWN: "
+			 "Status %x/%x cmd x%x data: x%x x%x x%x x%px x%px\n",
+			 ulp_status, ulp_word4, cmd,
+			 cmdiocb->cmd_flag, cmdiocb->iotag,
+			 ndlp->nlp_state, vport, ndlp);
+
+	if (cmd == ELS_CMD_PLOGI) {
+		/* A PLOGI ELS IO needs to clear the PLOGI_SND flag to
+		 * acknowledge the ELS completion and allow recovery. Otherwise
+		 * a subsequent PLOGI gets rejected as a duplicate.
+		 */
+		clear_bit(NLP_PLOGI_SND, &ndlp->nlp_flag);
+	} else if (cmd == ELS_CMD_PRLI || cmd == ELS_CMD_NVMEPRLI) {
+		/* A PRLI ELS IO needs to decrement the fc4_prli_sent count
+		 * added by the lpfc_issue_els_prli function.  A nonzero count
+		 * stops transport registrations.
+		 */
+		clear_bit(NLP_PRLI_SND, &ndlp->nlp_flag);
+		spin_lock_irq(&ndlp->lock);
+		vport->fc_prli_sent--;
+		ndlp->fc4_prli_sent--;
+		spin_unlock_irq(&ndlp->lock);
+	}
 
 	if (cmdiocb->cmd_flag & LPFC_IO_FABRIC) {
 		cmdiocb->cmd_flag &= ~LPFC_IO_FABRIC;
 		atomic_dec(&phba->fabric_iocb_count);
 	}
+
 	lpfc_els_free_iocb(phba, cmdiocb);
+
+	/* lpfc took a reference in the issue.  Release it now. */
+	lpfc_nlp_put(ndlp);
 }
 
 /**
-- 
2.38.0

