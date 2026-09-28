Received: from mail-dy2-f12.google.com (mail-dy2-f12.google.com [74.125.229.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65244DD3D1
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618103; cv=none; b=QrlBmoI9AOaMQoAEid2WcAPp4L6fPpjdHmUXUCtlO98qUyRcMTE4iMu90Ok5qKkvv5C7wLYisgM58WCAErKx0wuURYp+NhyFedLSTOA8kF85qlpyz8OtRKAIvFXwRTv8CHFUzi+xcsMw8wg8lLI8cHIqZwKK40fx68IRQk3aOG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618103; c=relaxed/simple;
	bh=AcA6n7BtCrDZ/l2nF301ZVBWAjAtPnvb4wDrMmago4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JQy4abkr4hrLAKiBrXSeBoEJJWaqr5Q0UU/JT37cdEeA85RvheX8ZA5L4HBKn5pdk8p7KG3D+4r7EZbs8pNjMgFTuOoTI6enSdKCDa1FfY2Jbew0/KVDl+wBO6/nI1XI5FDPzkQ9rLzIwCtPhg+wb9RyhvdBieZomaeQsgHwLwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxNq8WAA; arc=none smtp.client-ip=74.125.229.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxNq8WAA"
Received: by mail-dy2-f12.google.com with SMTP id 5a478bee46e88-328664b7528so3172821eec.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618101; x=1791222901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vCllPmlhcV3zVx00pfDqLDeH41OTCO2dC4Ap6iksz20=;
        b=hxNq8WAACEQCl2BA2tIcxZ3AMr2gd+UV+ZFyxh5HlZsgQRjlsCRe0MdHPhf756Ihe8
         iI4PDAsp+uLWZjbVO5ySkPqjt6Qn7WwxScpKG2nytI5CkFpTdSjRYCp4yAddfjjWa1Nh
         I1IAHhj0j283Fpe+ua5DdOsZ4rWVn0jNGb97kr1JbcPLimH1VLvu7/A9rfkS62oNoVqy
         yjQAtr0shCbDBeK1iRf57hMa4j5xMABbpd22FL+KhT5ZljVKoz2AH5pCmymiaxZCSBoi
         f6x9c2ZX1oVHeE01xvLKwHohN97mNmNa7PA3WrRvHHn46/HKB0/eE6b91nrKAzBYUaup
         6YMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618101; x=1791222901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vCllPmlhcV3zVx00pfDqLDeH41OTCO2dC4Ap6iksz20=;
        b=Nhy7GvbTyCfNWaE5W1dhykcyHVRQyWe5g51bF/oINQcXOmRIHOgQJRUY7+k7zirVIz
         T2ezlAtBosLlAPCX4Gq/5+QswMrCn2ZP+9XGtBEK5NaO7H8RdLAQFIQRLMpayIpALRmu
         ep5T/MW4YjIlTmzFpGc/5uNlKFGK+BusbXXCTjNlMfViEpf+9tsIqFp0B0ljIf55/p8N
         aSH5wsvXIiRa7CoPAJxOBR1VlO/QZB2dOnFpJqlFtKMHTF93pluV2X5A0e3cHJBVRmS2
         reegZ3RSdXDihFMB8J/W//nnC0qXbBa+CoUfmK7w7AxdScZEhnb/alKZUw9MVTYLSINg
         Nvtg==
X-Gm-Message-State: AFq9FYJTUXOTEIWVps8tx5NIGfIfMHW6lJm68b0sUAw4XBs9QQV6EemJ
	jqiXNhq0SJIBmrqzVR3f2owMcufeBoE0ItDI/tb7Glx9j+j12DH1Yyw7A6tEpgXj
X-Gm-Gg: AYBFou04HsTSP115naSZ8jxEP5prxu3O6Csjp+zjsk9YmIMB+h5DpCGM3/svRd3RsbW
	Z33NQfOS8HJCDf8I68tqVN75htbaTql/dlpXQ4KBetsoiNgyD0OyQxCX2Vktf+xHHUdWySnuvqP
	8gHay9ik/PobyQLsCugLTsCp2iBCLCg6gTgjUuxx3gt2YI4X4DrNaXXwodaibatFusvi0/Zw1NJ
	g1cmf34zq1fZfPy1VSI1Ry3w0Imcgx37bYoW1PXabeZsJaacKsIi2S1G4j5LAwo/opaWDdJpfnv
	dDco0w43G/qDFQBEZDenGCD5Dfe3BF9LqoBwumZr48s32gWyMYpGGsKpJmvayV4F2SXcfdJx2m/
	y6TkPNKvbTDsLQYKHOjjypd921NtCZ+Dw48OWhQ2e9G8+uTzvD/namywqH3FrLgHm732N6c4FqQ
	BYZ2F9WVdKa3WgtECLQ221Bh6Mh+5q9Xx4wl05bs7i6jeW91ZkQssV1EtONEDptjgNDeAOxojaP
	g9L/APn8wZW/1dlsmthFCZLNA7yBRGOMMpQNtIcSIE1Dhvfk4t7qLz5cXc=
X-Received: by 2002:a05:7300:51db:b0:348:c627:d1fc with SMTP id 5a478bee46e88-348c627d2a1mr4258483eec.22.1790618099870;
        Mon, 28 Sep 2026 10:54:59 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.54.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:54:59 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 05/10] lpfc: Add handling for when PLOGI or PRLI is dropped during link failure
Date: Mon, 28 Sep 2026 11:17:52 -0700
Message-Id: <20260928181757.21959-6-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
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

