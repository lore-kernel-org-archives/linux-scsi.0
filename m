Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B472AC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 14:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbiLVOLI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Dec 2022 09:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbiLVOKr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2022 09:10:47 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12A11154
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:10:45 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id 4so2133005plj.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Dec 2022 06:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJtmctAn+JbZO04zA2NymL/wNMdvFkipKZ36ajZk2HE=;
        b=LCHG59LxknVI6ftLVZAgsbjGQERawPN5kaQfdYLk5gx6j1xmSgrXT0llnfQeddfjYQ
         BxLdIqaffhBEQgVtmTJ7hiOmnCDf5Fy7cruF9UDCpg5SJlkwzSizc9qVf4A+O6c6QdbB
         T26R/zObGbvuC0SzdUMmrcsVtDcvJ/gtRtw8xOB1NkBoouAaHpNdStXHHQBViiY9PhOz
         KBc9dsmdJbq4tAGLIKOTh2V4KimVCeQliSp8V1L98FmlAAxaMLW+PM22U8aBScaNk/o7
         JZpygPeurIuplNzO37DOr37Ayg/IoPs53eb0IMHr5iowSqyLFtwVVeopbqRcNL3Rjs9G
         /f1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJtmctAn+JbZO04zA2NymL/wNMdvFkipKZ36ajZk2HE=;
        b=pEf9g6HkMjk7pxOyEnlJkH9o7SnglxXl9zhUF1EYvYIZGzAQTpIYlsUj/ECDOhAHxM
         iXh8SfGlFIuiQQQEnNNmyiAO6/EVcRyNVz40cKodqKVQhLRHOJReRBBbrfC3uvCw7T3E
         cKyYwB5sFZEgCBaTxCbtEGF3G/CG0s/8OcBc1FgVI5ZCWB064hFAibiQLjZqwN6KnKQj
         LxMs01NFG7SmLDeJCCvegBVyD/7mMIED3p6i0QPv6dG5uY5KLc3ofvDikRalM80gESX1
         rH4oiN2r1M1aQSid3CTuc2nnngWXsN5WuMwlUWeHb8jWYpm+FSa7+uBist0MOPiYQgrJ
         6ZlQ==
X-Gm-Message-State: AFqh2koZBQY4lx8u4EbcG+id+PJsRa74IMVFCDjj3ljo59JEYpq5lMGI
        VJtgFvOQSwoSHf2q/1TwRass
X-Google-Smtp-Source: AMrXdXuODHAKlzm+kUYY5r+nIkAqGSYXk5eu4+HN913mBLF3tfyN+JUHInK99T2mRCH3MoW7a1jVtQ==
X-Received: by 2002:a17:90a:c717:b0:219:1338:ab14 with SMTP id o23-20020a17090ac71700b002191338ab14mr6710953pjt.22.1671718245249;
        Thu, 22 Dec 2022 06:10:45 -0800 (PST)
Received: from localhost.localdomain ([117.217.177.177])
        by smtp.gmail.com with ESMTPSA id f8-20020a655908000000b0047829d1b8eesm832031pgu.31.2022.12.22.06.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Dec 2022 06:10:44 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org
Cc:     quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        dmitry.baryshkov@linaro.org, ahalaney@redhat.com,
        abel.vesa@linaro.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v5 05/23] phy: qcom-qmp-ufs: Add support for configuring PHY in HS G4 mode
Date:   Thu, 22 Dec 2022 19:39:43 +0530
Message-Id: <20221222141001.54849-6-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
References: <20221222141001.54849-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add separate tables_hs_g4 instance to allow the PHY driver to configure the
PHY in HS G4 mode. The individual SoC configs need to supply the Rx, Tx and
PCS register setting in tables_hs_g4 and the UFS driver can request the
Hs G4 mode by calling phy_set_mode_ext() with submode set to UFS_HS_G4.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Andrew Halaney <ahalaney@redhat.com> # Qdrive3/sa8540p-ride
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index 2d5dd336aeb2..82be9b754e8e 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -20,6 +20,7 @@
 #include <linux/reset.h>
 #include <linux/slab.h>
 
+#include <ufs/unipro.h>
 #include "phy-qcom-qmp.h"
 
 /* QPHY_SW_RESET bit */
@@ -549,6 +550,8 @@ struct qmp_phy_cfg {
 	const struct qmp_phy_cfg_tbls tbls;
 	/* Additional sequence for HS Series B */
 	const struct qmp_phy_cfg_tbls tbls_hs_b;
+	/* Additional sequence for HS G4 */
+	const struct qmp_phy_cfg_tbls tbls_hs_g4;
 
 	/* clock ids to be requested */
 	const char * const *clk_list;
@@ -583,6 +586,7 @@ struct qmp_ufs {
 
 	struct phy *phy;
 	u32 mode;
+	u32 submode;
 };
 
 static inline void qphy_setbits(void __iomem *base, u32 offset, u32 val)
@@ -847,7 +851,11 @@ static void qmp_ufs_init_registers(struct qmp_ufs *qmp, const struct qmp_phy_cfg
 	if (qmp->mode == PHY_MODE_UFS_HS_B)
 		qmp_ufs_serdes_init(qmp, &cfg->tbls_hs_b);
 	qmp_ufs_lanes_init(qmp, &cfg->tbls);
+	if (qmp->submode == UFS_HS_G4)
+		qmp_ufs_lanes_init(qmp, &cfg->tbls_hs_g4);
 	qmp_ufs_pcs_init(qmp, &cfg->tbls);
+	if (qmp->submode == UFS_HS_G4)
+		qmp_ufs_pcs_init(qmp, &cfg->tbls_hs_g4);
 }
 
 static int qmp_ufs_com_init(struct qmp_ufs *qmp)
@@ -1021,6 +1029,7 @@ static int qmp_ufs_set_mode(struct phy *phy, enum phy_mode mode, int submode)
 	struct qmp_ufs *qmp = phy_get_drvdata(phy);
 
 	qmp->mode = mode;
+	qmp->submode = submode;
 
 	return 0;
 }
-- 
2.25.1

