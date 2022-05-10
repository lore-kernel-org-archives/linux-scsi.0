Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA156C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 20:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbiEJUAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 16:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbiEJUAn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 16:00:43 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E678650063
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 13:00:40 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c14so103064pfn.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 13:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T+kXOv6/wWEcgyg9QhuqsaSGFRe97BZqyoi7R+lGhmE=;
        b=p1/i/ZV0pT8615LNv6Zf1IruIYAo+ekvFsP91nL2zPdEk0R3sDnU3f86AqATCrR4Vx
         HBJDJeih5I+TJcJdhuxZ/XIr5O6lcFDDJ2CTudfS2xptJdsSlxN6ZRCnWQ008tg02AP1
         2PPaIFNGuIHImYqgiEwj7fU/0Ya3hB7idu4fhDm9HOtEGFnMrnKIduPElooDRxTe1LKI
         zH2EgmNvusYgqDEgUWGGi17arsyNuphHMj+8M+q2igy6uD48Q0pmilq49OxM0b2Z4V58
         /xDFe0Jk9c34H0jVmKekGT5YTp6CMnQZOg3Na+jw9XRjSNknsXK+1Zys4/yQ1vF7sGmF
         9dAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T+kXOv6/wWEcgyg9QhuqsaSGFRe97BZqyoi7R+lGhmE=;
        b=w40k12mA/BwQSXKgpBFuv7rteduwm4ugMUHQznleYkSQupGSRusGv7yo9VR8K3hwQf
         OMLPNMj4fBKMY92CCgwdO8nhZHXIUqNKA9l+N7UTUJQxpiEWO9BptojDktFkXPxYG2sP
         4kztl7v1QLACOiQjFbyazB+J//5rmjRezbdTD/ycvdGKVBNft7jh9xoh1MfwCG5sbUx3
         yuCPWW2d0NNVoVN4xX04lVYgX+X9uUb5Sz7Tpx5bZW0Zf8T9JqZCItY15TVjik1gDVWk
         uKtmBXCzc0Twrt61K1HjYPV6K9b0bbtZmzybthx2bOtBmwLxtX5OgsokV1CNi5bkUqrg
         Z6kg==
X-Gm-Message-State: AOAM532Jrzo0gUzSnbLP3eNoouOIXeWc3y3FVrcFlEDffKu7lahQ8wcF
        yVuQlvOBarLIoGs1Mmc8JEnX5aKUYRE=
X-Google-Smtp-Source: ABdhPJzCDevBRV78CphoEtrU7yHW9B1gsklwQx63JtnF6GoSWnE6yMq0IFiVgMLZW9dnqbUNqD+M9A==
X-Received: by 2002:a62:a50c:0:b0:510:6b52:cd87 with SMTP id v12-20020a62a50c000000b005106b52cd87mr22047230pfm.30.1652212840295;
        Tue, 10 May 2022 13:00:40 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2d2sm2422679plb.284.2022.05.10.13.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 13:00:40 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     linux-nvme@lists.infradead.org, James Smart <jsmart2021@gmail.com>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Subject: [PATCH 4/4] lpfc: Add support for vmid tagging of NVMe I/Os
Date:   Tue, 10 May 2022 13:00:28 -0700
Message-Id: <20220510200028.37399-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220510200028.37399-1-jsmart2021@gmail.com>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Modify the nvme io path to look for vmid support and call the
transport to obtain the io's appid value.

Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 45 +++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 5385f4de5523..335e90633933 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1279,6 +1279,19 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 
 	/* Words 13 14 15 are for PBDE support */
 
+	/* add the VMID tags as per switch response */
+	if (unlikely(lpfc_ncmd->cur_iocbq.cmd_flag & LPFC_IO_VMID)) {
+		if (phba->pport->vmid_priority_tagging) {
+			bf_set(wqe_ccpe, &wqe->fcp_iwrite.wqe_com, 1);
+			bf_set(wqe_ccp, &wqe->fcp_iwrite.wqe_com,
+			       lpfc_ncmd->cur_iocbq.vmid_tag.cs_ctl_vmid);
+		} else {
+			bf_set(wqe_appid, &wqe->fcp_iwrite.wqe_com, 1);
+			bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
+			wqe->words[31] = lpfc_ncmd->cur_iocbq.vmid_tag.app_id;
+		}
+	}
+
 	pwqeq->vport = vport;
 	return 0;
 }
@@ -1504,6 +1517,11 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_nvme_fcpreq_priv *freqpriv;
 	struct nvme_common_command *sqe;
 	uint64_t start = 0;
+#if (IS_ENABLED(CONFIG_NVME_FC))
+	u8 *uuid = NULL;
+	int err;
+	enum dma_data_direction iodir;
+#endif
 
 	/* Validate pointers. LLDD fault handling with transport does
 	 * have timing races.
@@ -1662,6 +1680,33 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	lpfc_ncmd->ndlp = ndlp;
 	lpfc_ncmd->qidx = lpfc_queue_info->qidx;
 
+#if (IS_ENABLED(CONFIG_NVME_FC))
+	/* check the necessary and sufficient condition to support VMID */
+	if (lpfc_is_vmid_enabled(phba) &&
+	    (ndlp->vmid_support ||
+	     phba->pport->vmid_priority_tagging ==
+	     LPFC_VMID_PRIO_TAG_ALL_TARGETS)) {
+		/* is the I/O generated by a VM, get the associated virtual */
+		/* entity id */
+		uuid = nvme_fc_io_getuuid(pnvme_fcreq);
+
+		if (uuid) {
+			if (pnvme_fcreq->io_dir == NVMEFC_FCP_WRITE)
+				iodir = DMA_TO_DEVICE;
+			else if (pnvme_fcreq->io_dir == NVMEFC_FCP_READ)
+				iodir = DMA_FROM_DEVICE;
+			else
+				iodir = DMA_NONE;
+
+			err = lpfc_vmid_get_appid(vport, uuid, iodir,
+					(union lpfc_vmid_io_tag *)
+						&lpfc_ncmd->cur_iocbq.vmid_tag);
+			if (!err)
+				lpfc_ncmd->cur_iocbq.cmd_flag |= LPFC_IO_VMID;
+		}
+	}
+#endif
+
 	/*
 	 * Issue the IO on the WQ indicated by index in the hw_queue_handle.
 	 * This identfier was create in our hardware queue create callback
-- 
2.26.2

