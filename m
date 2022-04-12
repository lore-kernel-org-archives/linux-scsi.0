Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4B1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiDLXhL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiDLXcv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:51 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF978CD95
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:22 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id z16so297252pfh.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DN6hkdthWvF2+/ZmmR3lFexnZLzQXTTa5f2m+5PyPS4=;
        b=dZvvvmiG35ZIwzOsBNbm8YzdoD8DJiQGHHP0nNcjwvej3EmIwW59j81SRPnokIXsNI
         0gEM0qi45pAarTIvL+UzAppirRsXgxj/N1f303Mj3u0sm8itHC2V7xWMHGRIrLfkqokq
         VVupp0Ofe1yFZUHSpK/CstDxlyXbfyLeL5XEjJ4G1koDW+kBJEzwcWR80LOpHHvVTnFj
         gQuCRfSV50MKjJUhktk6FLCQuZ339vcM4sroYZYzCaZeJctsxn78OlN12i/ZP3HAwUNE
         XCAgg0U+ehFdYLT6bRlx89fp6rnymwBChtpOH9WVgv8lGZmcMBEQo54jwxjrAAb+123s
         qtfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DN6hkdthWvF2+/ZmmR3lFexnZLzQXTTa5f2m+5PyPS4=;
        b=5Z+0Tf4LPZsgjscLOFg44cXfRGv4TIcLHDUB6gmtaofEKaZi/Q6m9kVS/D9delF/Ag
         O0vXqBTUZ06H4l3JDYyFXRgY1QvMEvpQSZjbt8oleD/33EZczIY1kCjUe0yzasXfb50A
         7/xRTIqfKP7yzzGi4H+ndud48GX/NpyHQlTXMOESidZ+6bl7yZwMhb9mZvj6sRrCxIjK
         BbrBw71o7/npjjD1NME/74l4AhnBHVZYV3ck+Z3tawX8tMXVPkN7GTMd404vwhj9CE43
         yxZawSyGwF0hbkpssAf3GVOheIGSVFYogc+Oa0Q1+WDn5rtgVUc8c1dKfxz2l1ue8mV5
         ZXVA==
X-Gm-Message-State: AOAM533Q+nrnD1WeVkpAo17qsa32z6o+rGsYF0OKU/J19DuvGWVLZnp7
        Xc/gm5S728YbYlJq9uuRVziMlWkm4lw=
X-Google-Smtp-Source: ABdhPJwN4RSSIiTfOtc62KAuWewH5xuoGJVz8vHqe4mgyaWd5jeevVj6TrZt7AFW8i1OnI+WzpRFIw==
X-Received: by 2002:a65:6956:0:b0:399:1f0e:6172 with SMTP id w22-20020a656956000000b003991f0e6172mr31981728pgq.286.1649802022061;
        Tue, 12 Apr 2022 15:20:22 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:21 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 09/26] lpfc: Protect memory leak for NPIV ports sending PLOGI_RJT
Date:   Tue, 12 Apr 2022 15:19:51 -0700
Message-Id: <20220412222008.126521-10-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a potential memory leak in lpfc_ignore_els_cmpl and
lpfc_els_rsp_reject that was allocated from NPIV PLOGI_RJT
(lpfc_rcv_plogi's login_mbox).

Check if cmdiocb->context_un.mbox was allocated in lpfc_ignore_els_cmpl,
and then free it back to phba->mbox_mem_pool along with mbox->ctx_buf for
service parameters.

For lpfc_els_rsp_reject failure, free both the ctx_buf for service
parameters and the login_mbox.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 10 ++++++++--
 drivers/scsi/lpfc/lpfc_sli.c       | 17 +++++++++++++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 3d0ba046c902..e7b1174a057f 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -614,9 +614,15 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		stat.un.b.lsRjtRsnCode = LSRJT_INVALID_CMD;
 		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 		rc = lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb,
-			ndlp, login_mbox);
-		if (rc)
+					 ndlp, login_mbox);
+		if (rc) {
+			mp = (struct lpfc_dmabuf *)login_mbox->ctx_buf;
+			if (mp) {
+				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+			}
 			mempool_free(login_mbox, phba->mbox_mem_pool);
+		}
 		return 1;
 	}
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 28d8ded9e7e1..ca7766940b4e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12069,6 +12069,8 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 {
 	struct lpfc_nodelist *ndlp = NULL;
 	IOCB_t *irsp;
+	LPFC_MBOXQ_t *mbox;
+	struct lpfc_dmabuf *mp;
 	u32 ulp_command, ulp_status, ulp_word4, iotag;
 
 	ulp_command = get_job_cmnd(phba, cmdiocb);
@@ -12080,6 +12082,21 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	} else {
 		irsp = &rspiocb->iocb;
 		iotag = irsp->ulpIoTag;
+
+		/* It is possible a PLOGI_RJT for NPIV ports to get aborted.
+		 * The MBX_REG_LOGIN64 mbox command is freed back to the
+		 * mbox_mem_pool here.
+		 */
+		if (cmdiocb->context_un.mbox) {
+			mbox = cmdiocb->context_un.mbox;
+			mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
+			if (mp) {
+				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+			}
+			mempool_free(mbox, phba->mbox_mem_pool);
+			cmdiocb->context_un.mbox = NULL;
+		}
 	}
 
 	/* ELS cmd tag <ulpIoTag> completes */
-- 
2.26.2

