Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33524C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 02:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236799AbiBYCYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 21:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbiBYCYB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 21:24:01 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC7B1DCCDC
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:26 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id l9so3117069pls.6
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 18:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cWFowDhIDw2ImOUU3BbDTh0GaKUWVvcUbWTV4Tuxe0M=;
        b=UTu6eHnNBILDwfn8LmOChMGzKDN3FAmQr8LbxSojipax1KnK0snlymXvnr2VdObPX4
         pn0Kg+SH6B0x7WInH4yjSJ2t6EsoxIgeYmwDwPeYdRdaBh8uiqrU6p9iU07jxGKkUzjs
         yCW8GGJEX5BxBbG0ErpJPvYcrZrr7wpuJVohNpT44yetxMHTBIItfszYNfryH3TlJLY4
         46Dyx9bCniJSvtud4Els4wLKWwb75eSX5gMELFi4+/xK3jDOezJHiTU/hXYDXqJjQH4x
         wDd5g3TvHD5QlvoDm1iNFqDIP7vF3UlPwWmOdBXW8cNSYv8OLS+r3Yx0HvKQdYiwDBKd
         OBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cWFowDhIDw2ImOUU3BbDTh0GaKUWVvcUbWTV4Tuxe0M=;
        b=Er2PK6iqiRYCFxrWEDQIE64JZTUb1JqfLDlXxHEQeAzzpc9+bzE7eK1u/R/CNI/95i
         ZbLSnRNw2y/ZfiQHEiCatzjE9TgtfCECdBJmJNkXwXbEsqJg48DbviLTqi/YVNSHZZhA
         /VykdkY0Jx/sf5NPLJq51fh22f5c+FFW+KlQp+x2g84K7Rc1figRcHAfgbWX/OcWyTFN
         ky1Jn3EpKb7Py9phKaBmgcmRw017M3ABkiiCkNnB/6EGLNdXiYQzAp6y0xRLDw0zTv2u
         PeEn8sEyFD9lQXydszp/ik5T2EUq9VNdDYBrghbPdPHHI66yobkOQovwobIMuBSS5kIU
         NtIA==
X-Gm-Message-State: AOAM531OuWYCGrI0ehzB59rDAAwwjvgQ66gHOuDoq+SXdBhErR/bI+3K
        9Z19YT8xVbzh4z1Y58S8dcoHoYbfI1k=
X-Google-Smtp-Source: ABdhPJzwVwBm2uChs5cKDrbRhZuuPqduXlL+n3Q5vQ3Nlu7gSpo9RFYOcsY1Q+4caNwu5ZC53sqAqg==
X-Received: by 2002:a17:90a:f308:b0:1bc:4ffa:79b1 with SMTP id ca8-20020a17090af30800b001bc4ffa79b1mr960008pjb.245.1645755805959;
        Thu, 24 Feb 2022 18:23:25 -0800 (PST)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id p28-20020a056a000a1c00b004f3b355dcb1sm845596pfh.58.2022.02.24.18.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 18:23:25 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 10/17] lpfc: SLI path split: refactor VMID paths
Date:   Thu, 24 Feb 2022 18:23:01 -0800
Message-Id: <20220225022308.16486-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220225022308.16486-1-jsmart2021@gmail.com>
References: <20220225022308.16486-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch refactors the VMID paths to use SLI-4 as the primary
interface.

Changes include:
- conversion away from using sli-3 iocb structures to set/access fields
  in common routines. Use the new generic get/set routines that were added.
  This move changes code from indirect structure references to using
  local variables with the generic routines.
- refactor routines when setting non-generic fields, to have both
  both sli3 and sli4 specific sections. This replaces the set-as-sli3
  then translate to sli4 behavior of the past.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c  |  2 +-
 drivers/scsi/lpfc/lpfc_els.c | 14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 95e7651163da..b78823a305cc 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3814,7 +3814,7 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (cmd == SLI_CTAS_DALLAPP_ID)
 		lpfc_ct_free_iocb(phba, cmdiocb);
 
-	if (lpfc_els_chk_latt(vport) || rspiocb->iocb.ulpStatus) {
+	if (lpfc_els_chk_latt(vport) || get_job_ulpstatus(phba, rspiocb)) {
 		if (cmd != SLI_CTAS_DALLAPP_ID)
 			return;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 0d8e674c72f0..789259fadf6c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11938,7 +11938,8 @@ lpfc_cmpl_els_qfpa(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_vmid_priority_range *vmid_range = NULL;
 	u32 *data;
 	struct lpfc_dmabuf *dmabuf = cmdiocb->context2;
-	IOCB_t *irsp = &rspiocb->iocb;
+	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
+	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 	u8 *pcmd, max_desc;
 	u32 len, i;
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
@@ -11955,10 +11956,10 @@ lpfc_cmpl_els_qfpa(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 data[0], data[1]);
 		goto out;
 	}
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_SLI,
 				 "6529 QFPA failed with status x%x  x%x\n",
-				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+				 ulp_status, ulp_word4);
 		goto out;
 	}
 
@@ -12157,7 +12158,8 @@ lpfc_cmpl_els_uvem(struct lpfc_hba *phba, struct lpfc_iocbq *icmdiocb,
 	struct lpfc_nodelist *ndlp = icmdiocb->context1;
 	u8 *pcmd;
 	u32 *data;
-	IOCB_t *irsp = &rspiocb->iocb;
+	u32 ulp_status = get_job_ulpstatus(phba, rspiocb);
+	u32 ulp_word4 = get_job_word4(phba, rspiocb);
 	struct lpfc_dmabuf *dmabuf = icmdiocb->context2;
 	struct lpfc_vmid *vmid;
 
@@ -12175,10 +12177,10 @@ lpfc_cmpl_els_uvem(struct lpfc_hba *phba, struct lpfc_iocbq *icmdiocb,
 				 "4532 UVEM LS_RJT %x %x\n", data[0], data[1]);
 		goto out;
 	}
-	if (irsp->ulpStatus) {
+	if (ulp_status) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_SLI,
 				 "4533 UVEM error status %x: %x\n",
-				 irsp->ulpStatus, irsp->un.ulpWord[4]);
+				 ulp_status, ulp_word4);
 		goto out;
 	}
 	spin_lock(&phba->hbalock);
-- 
2.26.2

