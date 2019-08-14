Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF961C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F3342086C
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HCegBlnT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbfHNX5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:39 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35031 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729251AbfHNX5h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:37 -0400
Received: by mail-pl1-f195.google.com with SMTP id gn20so338100plb.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KurSwZP41v7HTlgL+yWHtoFUDLepJRRq4Jnhf0Ch11o=;
        b=HCegBlnTcs6PXJLKmlO8iYXbgaZWrNXSw/op0tpwsXUPy0u82Bku0C2gtJQ8kyb0jd
         aaevIXKM+TnONPfqHrBuWvll+ZO/DrLTYXO9psX/JssFeqYkHaHLv0m7Kjfu8EL/PlGD
         hB63AZXWpEaVh+UGwyAicJvfLIv56AXpC0FmfCav+x+Ji0IXApAj4pv4cOhk8KQxHaol
         mPjRMivmbYM/eKevipPjQUyVhc/7W618LTdu+/ynWnATLcc+0MYKY+rSn/WF7+hlQCS8
         zTqIfsQuUBiFTKldZXCliL28qPWd33/StSo1des1SYDsk1Q/UeK3oOurL3DKbvyYtQBq
         tzDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KurSwZP41v7HTlgL+yWHtoFUDLepJRRq4Jnhf0Ch11o=;
        b=JVtGFgRdDkJnS33wXbtac6YW3Ym+VvIaMeCHgN6F7K7z4YNndGl8wkw/V2zHuxeoMP
         4tWdBQbf+ZHNyDK5f38T4m+fg+zf89Raht8DOWyj7U7YJ9aRSuGgRM1VeLrojlynLRKI
         Y8YqsvGRuAqHoo5IuCq2iivMco7FLThEm9ZBxC3UpH5KmntokzxuxGIhfAXiqeoYTnFs
         9ZM50fTtp9QrCO54bSAq7kZoj9gjlwhjcdiqv0PPeNtge/bDIk3A+JSVifd6J+tBDa6t
         suh8Z/jnV001SYRH578cWTuCZ10wvCVCGmAHJVJEOJcLLX4fy7uUxhZCMoXefkvuI5m1
         DxsQ==
X-Gm-Message-State: APjAAAX/RVBhXrtWI16TJo14m2sjVSfNyFYenU+89IVFR22L5kh9I7IK
        2bSSSHK++FXDgGSbJZL4Xm61mJPr
X-Google-Smtp-Source: APXvYqwyf5HSmRx3tn6345xuO7XLo7L3G4jc5HqPZa3PUAHoULlHsQZzjWFRlYjden3FKNrGpEKhmQ==
X-Received: by 2002:a17:902:5a04:: with SMTP id q4mr1820267pli.280.1565827057177;
        Wed, 14 Aug 2019 16:57:37 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:36 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 19/42] lpfc: Fix sg_seg_cnt for HBAs that don't support NVME
Date:   Wed, 14 Aug 2019 16:56:49 -0700
Message-Id: <20190814235712.4487-20-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190814235712.4487-1-jsmart2021@gmail.com>
References: <20190814235712.4487-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On an SLi-3 adapter which does not support NVMe, but with the
driver global attribute to enable nvme on any adapter if it
does support NVMe (e.g. module parameter lpfc_enable_fc4_type=3),
the SGL and total SGE values are being munged by the protocol
enablement when it shouldn't be.

Correct by changing the location of where the NVME sgl information
is being applied, which will avoid any SLI-3-based adapter.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 10 ----------
 drivers/scsi/lpfc/lpfc_init.c |  9 +++++++++
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 90181afe0e28..7ac6508b7ed8 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -7196,16 +7196,6 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_ras_fwlog_level_init(phba, lpfc_ras_fwlog_level);
 	lpfc_ras_fwlog_func_init(phba, lpfc_ras_fwlog_func);
 
-
-	/* If the NVME FC4 type is enabled, scale the sg_seg_cnt to
-	 * accommodate 512K and 1M IOs in a single nvme buf and supply
-	 * enough NVME LS iocb buffers for larger connectivity counts.
-	 */
-	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
-		phba->cfg_sg_seg_cnt = LPFC_MAX_NVME_SEG_CNT;
-		phba->cfg_iocb_cnt = 5;
-	}
-
 	return;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index fcc1c45f2d35..84a77faed114 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11702,6 +11702,15 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		}
 	}
 
+	/* If the NVME FC4 type is enabled, scale the sg_seg_cnt to
+	 * accommodate 512K and 1M IOs in a single nvme buf and supply
+	 * enough NVME LS iocb buffers for larger connectivity counts.
+	 */
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		phba->cfg_sg_seg_cnt = LPFC_MAX_NVME_SEG_CNT;
+		phba->cfg_iocb_cnt = 5;
+	}
+
 	/* Only embed PBDE for if_type 6, PBDE support requires xib be set */
 	if ((bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
 	    LPFC_SLI_INTF_IF_TYPE_6) || (!bf_get(cfg_xib, mbx_sli4_parameters)))
-- 
2.13.7

