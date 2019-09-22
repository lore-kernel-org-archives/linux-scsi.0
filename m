Return-Path: <SRS0=kJCz=XR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD21C3A5A2
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AF4220820
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Sep 2019 03:59:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kluOaUPZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfIVD7T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Sep 2019 23:59:19 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45254 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfIVD7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Sep 2019 23:59:19 -0400
Received: by mail-ot1-f66.google.com with SMTP id 41so9363874oti.12
        for <linux-scsi@vger.kernel.org>; Sat, 21 Sep 2019 20:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ccV9R+hIxBMQB75eTPPzyT8GcdLB1MG1kODyo9DRWm4=;
        b=kluOaUPZtMf6wzWpMvWrGPKPvaLVwdavJ6tgCKO3mABEThRiRIqXDHS1afocl040jv
         cQovR4dX/zWsTdpE4ri7FSoYPUPfBgEFtqGIyuVYL/SaGy7sKLRatwwRpTQFl3UXCFrW
         OjCsDWcZJxPjUPb8blmEw8VM3YCa1P3KcStjIVgjLXlUkMbQR17b1J+4Dw21PuI3ET2B
         493f13K8QKeht1PBrGyq2cEOooXR//VfUM6Ez8QmYHOV2G7xSXu82tf/XDKJCMKEJRGm
         PIHycifo568DYMxoiUmxQJvZdR6H8DZUTRCK5uqvPw/ILNm26EbP5TcT4VEjBQ7mnWKC
         8MhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ccV9R+hIxBMQB75eTPPzyT8GcdLB1MG1kODyo9DRWm4=;
        b=NryaP9x0asO2kNLVU2+EHhZcgkw/3R5zOgQivGE1cULDLsaI+WLteyVU/Yt9cwuBS2
         z2wPwEirv/n1tS21F3uZiXHettweUagv74WO0UCOLeijBsaMVeZ5slusG4EchkyNQIqD
         xgN7eounoDB+i+G7Ir1xBIe9fQ6D1GbPF7KbdYHxkpK2JWj2YTc866Sc9+KRCtnP3Htf
         1toKROaImI7Q6zdGtGFJSzI91Ex5Tk0Fwgtnslc5ckLCBto9IT068cIXXOJ7WJXqZB6R
         jq2VJ6h/DflZKcmv00uLIQolcYRQOmHLCBxAiVFpX5s1fIEV1dbkne47I4HEAHr0oJcM
         2rtg==
X-Gm-Message-State: APjAAAVtHCzjPAtTdt/QW2or8pxXo5P2//QYKbziGZSUpEgFAdUflW+I
        1z3NOj+nDSQ0zQ+ztM4j3pdWd951
X-Google-Smtp-Source: APXvYqxu20lw0vsPzYgZIvy+yXZzyL+qZZcd31j9r/pC1n8ZLDqd0nCZwTQTaI4yjfymRXrtdlyhsQ==
X-Received: by 2002:a9d:4615:: with SMTP id y21mr3432207ote.97.1569124758759;
        Sat, 21 Sep 2019 20:59:18 -0700 (PDT)
Received: from os42.localdomain (ip68-5-145-143.oc.oc.cox.net. [68.5.145.143])
        by smtp.gmail.com with ESMTPSA id a9sm2395889otc.75.2019.09.21.20.59.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 21 Sep 2019 20:59:18 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 04/20] lpfc: Fix NVME io abort failures causing hangs
Date:   Sat, 21 Sep 2019 20:58:50 -0700
Message-Id: <20190922035906.10977-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190922035906.10977-1-jsmart2021@gmail.com>
References: <20190922035906.10977-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The nvme-fc transport may call to abort an io on controller
reset. If the driver is out of resources to issue an abort
command, it just gives up and does nothing. The transport
expects the lldd to always be able to terminate an io it
has issued.  At that point, the controller hangs waiting for
aborted ios to be returned.  Note: flaged by "6136" and
"6176" error messages.

Root issue was the adapter mis-allocated the number resources
it allocated for command entries for the adapter.

Convert the driver to allocate command resources based on the
number of xris supported by the FC port - 1 resource for the
original command and 1 resource for the abort request.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 -
 drivers/scsi/lpfc/lpfc_attr.c |  5 -----
 drivers/scsi/lpfc/lpfc_init.c |  9 +++------
 drivers/scsi/lpfc/lpfc_sli.c  | 17 +++++++++++------
 4 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 691acbdcc46d..291335e16806 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -872,7 +872,6 @@ struct lpfc_hba {
 	uint32_t cfg_aer_support;
 	uint32_t cfg_sriov_nr_virtfn;
 	uint32_t cfg_request_firmware_upgrade;
-	uint32_t cfg_iocb_cnt;
 	uint32_t cfg_suppress_link_up;
 	uint32_t cfg_rrq_xri_bitmap_sz;
 	uint32_t cfg_delay_discovery;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 41cc91d3c77e..79a192479755 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3582,9 +3582,6 @@ lpfc_txcmplq_hw_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(txcmplq_hw, S_IRUGO,
 			 lpfc_txcmplq_hw_show, NULL);
 
-LPFC_ATTR_R(iocb_cnt, 2, 1, 5,
-	"Number of IOCBs alloc for ELS, CT, and ABTS: 1k to 5k IOCBs");
-
 /*
 # lpfc_nodev_tmo: If set, it will hold all I/O errors on devices that disappear
 # until the timer expires. Value range is [0,255]. Default value is 30.
@@ -6073,7 +6070,6 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_sriov_nr_virtfn,
 	&dev_attr_lpfc_req_fw_upgrade,
 	&dev_attr_lpfc_suppress_link_up,
-	&dev_attr_lpfc_iocb_cnt,
 	&dev_attr_iocb_hw,
 	&dev_attr_txq_hw,
 	&dev_attr_txcmplq_hw,
@@ -7212,7 +7208,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_sriov_nr_virtfn_init(phba, lpfc_sriov_nr_virtfn);
 	lpfc_request_firmware_upgrade_init(phba, lpfc_req_fw_upgrade);
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
-	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
 	lpfc_delay_discovery_init(phba, lpfc_delay_discovery);
 	lpfc_sli_mode_init(phba, lpfc_sli_mode);
 	phba->cfg_enable_dss = 1;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e91377a4cafe..bb84d2a20e76 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7126,7 +7126,7 @@ lpfc_init_iocb_list(struct lpfc_hba *phba, int iocb_count)
 		if (iocbq_entry == NULL) {
 			printk(KERN_ERR "%s: only allocated %d iocbs of "
 				"expected %d count. Unloading driver.\n",
-				__func__, i, LPFC_IOCB_LIST_CNT);
+				__func__, i, iocb_count);
 			goto out_free_iocbq;
 		}
 
@@ -11591,13 +11591,10 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	}
 
 	/* If the NVME FC4 type is enabled, scale the sg_seg_cnt to
-	 * accommodate 512K and 1M IOs in a single nvme buf and supply
-	 * enough NVME LS iocb buffers for larger connectivity counts.
+	 * accommodate 512K and 1M IOs in a single nvme buf.
 	 */
-	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
 		phba->cfg_sg_seg_cnt = LPFC_MAX_NVME_SEG_CNT;
-		phba->cfg_iocb_cnt = 5;
-	}
 
 	/* Only embed PBDE for if_type 6, PBDE support requires xib be set */
 	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3b3ae2182e59..827406f58b1e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7523,9 +7523,11 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 		}
 		phba->sli4_hba.nvmet_xri_cnt = rc;
 
-		cnt = phba->cfg_iocb_cnt * 1024;
-		/* We need 1 iocbq for every SGL, for IO processing */
-		cnt += phba->sli4_hba.nvmet_xri_cnt;
+		/* We allocate an iocbq for every receive context SGL.
+		 * The additional allocation is for abort and ls handling.
+		 */
+		cnt = phba->sli4_hba.nvmet_xri_cnt +
+			phba->sli4_hba.max_cfg_param.max_xri;
 	} else {
 		/* update host common xri-sgl sizes and mappings */
 		rc = lpfc_sli4_io_sgl_update(phba);
@@ -7547,14 +7549,17 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 			rc = -ENODEV;
 			goto out_destroy_queue;
 		}
-		cnt = phba->cfg_iocb_cnt * 1024;
+		/* Each lpfc_io_buf job structure has an iocbq element.
+		 * This cnt provides for abort, els, ct and ls requests.
+		 */
+		cnt = phba->sli4_hba.max_cfg_param.max_xri;
 	}
 
 	if (!phba->sli.iocbq_lookup) {
 		/* Initialize and populate the iocb list per host */
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-				"2821 initialize iocb list %d total %d\n",
-				phba->cfg_iocb_cnt, cnt);
+				"2821 initialize iocb list with %d entries\n",
+				cnt);
 		rc = lpfc_init_iocb_list(phba, cnt);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-- 
2.13.7

