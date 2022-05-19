Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8A3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 12:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbiESMbx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 08:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbiESMbY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 08:31:24 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB15B17E16
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 05:31:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m1so4666215plx.3
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 05:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b0hNzZPOxTsfjgIPh7rOEUHPqUb1JSCsu4Q6DMm9gQc=;
        b=ixnmZHHJkT8eVf8t+SBs/DYx8bdg/6X9mMlqd7OdtaB5hvVNfI8SjD6xMaSAauT6Ry
         29ChaaKY5cW1JJvKGe00brUBCAPNxsHpCNWjyZMgS4+/vXCUr2iWCUtpOh8d5q9fIwke
         MSdGuThkA5OPHQHOexw/M4kGPxbfcxzso+jIoP2Htqbg8o3+blWNcYy0mQPBudcFAlLB
         wlveQyaDaI9lCHdrmnU8yN9mDbtJcWaZdLcVxq4Ru/D7grDcSPaIAVPI3+5p/fkpgRNa
         PAbWh/dCB0VM1J/cw3+0aldg/Gd/nZbSpSfVLP+81WELskf/wzGZD9DmPrlA91b5hKFZ
         jqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b0hNzZPOxTsfjgIPh7rOEUHPqUb1JSCsu4Q6DMm9gQc=;
        b=ADgJgYWoX8pC7RjghsQYaMASnOAR7ymxKWtmCeLaZnUaAvA/7g13qyLewJ/04G8p/1
         d7qi3dHuaUwAiltZrgiPQz5kCEwNHUOOGUoYClvRLT7G8hIITppxxBeAirT9N1sAKoSd
         EbkF+Yb73DlGNBEs7SbJ/1YBS9+4C3NzRAf3JW3oVaUzxY1v48cs2MfD0KtJRpCGf0k8
         zyenLR6QGauRw6mTNMx8fmIk1OSt3EeWj1fEsJJvBDV5FmZy/RVI3n76zZwmyM+kFHPj
         Vmrhx6W1nwWbAh2iEJpKjaNdIkX9yfV3TjA4Sk56NDLdp5RYpBtcFf1Cecx4UynCVKeM
         tkGw==
X-Gm-Message-State: AOAM530JM/6AbtonGNrbDWj+DcbL+tVzIx71FeUBOYNzdRPqSb5pl5NV
        pdMB0KgB7pADe0E4a6JnurKDHW4VT74=
X-Google-Smtp-Source: ABdhPJzb3iMVPdjlEdvWD6RFuzmS4AT4KvxXZvowWWedsdEkQpQ4ehOfE2LxCcb2M6guGh6PGzWScA==
X-Received: by 2002:a17:90b:350d:b0:1dc:6680:6f1d with SMTP id ls13-20020a17090b350d00b001dc66806f1dmr5557572pjb.27.1652963481097;
        Thu, 19 May 2022 05:31:21 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z26-20020aa79e5a000000b005180f4733a8sm3581797pfq.106.2022.05.19.05.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 05:31:20 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 4/4] lpfc: Add support for vmid tagging of NVMe I/Os
Date:   Thu, 19 May 2022 05:31:10 -0700
Message-Id: <20220519123110.17361-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220519123110.17361-1-jsmart2021@gmail.com>
References: <20220519123110.17361-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Modify the nvme io path to look for vmid support and call the
transport to obtain the io's appid value.

Signed-off-by: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

