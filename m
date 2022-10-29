Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A920EFA3740
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Oct 2022 14:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJ2OR2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Oct 2022 10:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJ2ORT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Oct 2022 10:17:19 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4C45EDEF
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:00 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s196so7165152pgs.3
        for <linux-scsi@vger.kernel.org>; Sat, 29 Oct 2022 07:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5WmRC0L+hw4S3UXcDpcUjp52H52L0HyHYoqC6TP1dPI=;
        b=rBHuvUSi0O1Am4sK52D4c+AXlzJs7HJbVpFPBP5W1Ic8IY0RhC6D6fzMR6nszKETvB
         73sBiQa5MOegQz1wUrhZpDGJq/Cz4PerQVYOyIBfwkFaoJ55PuSjzROeyRFYqGht224r
         ikvQO+vdEwQzJ5Sa6GB7vqCUsDeXwvNWLpWQGS50+zBvqPeYRGpHGrYkUzdSJz2rqliB
         K1KhHvUH0qHBYs69VBnIw/jBR6D6Nr6RQ27ZpNNYDZR+yHqwet8BL+IP6+5QR75QuEjZ
         birC80j327cFP46UYMJ0cRAMmhpr4zKw5ScYAeSzVHc8VTaCUmwaBU4UdvDE7zOEiPgQ
         R6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5WmRC0L+hw4S3UXcDpcUjp52H52L0HyHYoqC6TP1dPI=;
        b=1ggAAWtyR6HJEVSQwDb2ywJDFkNcg1mnDcqvSpRccxnkV6KxeG1J+seswdqZN5FMFM
         p9+aPuOLKmR2EsOFZkaUqRy9wpG/fqk4kljWCaT8Wn5e3tdl6B5TWXo1bdzAM/ru4MLG
         J1P9oVf1gfOmAdzzH/Pc7lrdN9HD46On+VXZw8o/7LkujCE4ISgksvFQv+tlWDZInGAu
         AtmB/pBfakPHX8zLUFKol3Az2Ts8nQmeDJlujKQdVqdtczUNisKDIu3hjLdNv2SP3v2Q
         lIBxRQfRfGB2OK9RKw8mIQ/UW9CfOsmZg7JxZlBCOj+yfv6wXIbO7kA/o3mDIaIoWkak
         L9Kg==
X-Gm-Message-State: ACrzQf1Jscg7ubXPQJdmYoW77S9Plx/CNLBKdZIuD+8963VBLOtmApX2
        +xaKf6R4r5XqqsMP0d/ZW11f
X-Google-Smtp-Source: AMsMyM5ha5AnMbk0SxjDC6+WYDDz5cKfoA673Y2oly3miKoOPe5k61mw7QN2Z5TIxwS1QmxQilf/HQ==
X-Received: by 2002:aa7:88c9:0:b0:56b:e851:5b65 with SMTP id k9-20020aa788c9000000b0056be8515b65mr4852227pff.74.1667053020222;
        Sat, 29 Oct 2022 07:17:00 -0700 (PDT)
Received: from localhost.localdomain ([117.193.208.18])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b001866049ddb1sm1370157plf.161.2022.10.29.07.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Oct 2022 07:16:59 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        andersson@kernel.org, vkoul@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     konrad.dybcio@somainline.org, robh+dt@kernel.org,
        quic_cang@quicinc.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 03/15] phy: qcom-qmp-ufs: Add support for configuring PHY in HS G4 mode
Date:   Sat, 29 Oct 2022 19:46:21 +0530
Message-Id: <20221029141633.295650-4-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
References: <20221029141633.295650-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add separate tables_hs_g4 instance to allow the PHY driver to configure the
PHY in HS G4 mode. The individual SoC configs need to supply the Rx, Tx and
PCS register setting in tables_hs_g4 and the UFS driver can request the
Hs G4 mode by calling phy_set_mode_ext() with submode set to UFS_HS_G4.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
index 4c6a2b5afc9a..5f2a012707b7 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -553,6 +553,8 @@ struct qmp_phy_cfg {
 	const struct qmp_phy_cfg_tables tables;
 	/* Additional sequence for HS Series B */
 	const struct qmp_phy_cfg_tables tables_hs_b;
+	/* Additional sequence for HS G4 */
+	const struct qmp_phy_cfg_tables tables_hs_g4;
 
 	/* clock ids to be requested */
 	const char * const *clk_list;
@@ -587,6 +589,7 @@ struct qmp_phy_cfg {
  * @pcs_misc: iomapped memory space for lane's pcs_misc
  * @qmp: QMP phy to which this lane belongs
  * @mode: PHY mode configured by the UFS driver
+ * @submode: PHY submode configured by the UFS driver
  */
 struct qmp_phy {
 	struct phy *phy;
@@ -600,6 +603,7 @@ struct qmp_phy {
 	void __iomem *pcs_misc;
 	struct qcom_qmp *qmp;
 	u32 mode;
+	u32 submode;
 };
 
 /**
@@ -993,8 +997,12 @@ static int qmp_ufs_power_on(struct phy *phy)
 		qmp_ufs_serdes_init(qphy, &cfg->tables_hs_b);
 
 	qmp_ufs_lanes_init(qphy, &cfg->tables);
+	if (qphy->submode == UFS_HS_G4)
+		qmp_ufs_lanes_init(qphy, &cfg->tables_hs_g4);
 
 	qmp_ufs_pcs_init(qphy, &cfg->tables);
+	if (qphy->submode == UFS_HS_G4)
+		qmp_ufs_pcs_init(qphy, &cfg->tables_hs_g4);
 
 	ret = reset_control_deassert(qmp->ufs_reset);
 	if (ret)
@@ -1083,6 +1091,7 @@ static int qmp_ufs_set_mode(struct phy *phy, enum phy_mode mode, int submode)
 	struct qmp_phy *qphy = phy_get_drvdata(phy);
 
 	qphy->mode = mode;
+	qphy->submode = submode;
 
 	return 0;
 }
-- 
2.25.1

