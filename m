Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB282EB8FAF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Sep 2023 11:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239893AbjIFLdn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Sep 2023 07:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbjIFLdk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Sep 2023 07:33:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80D619BF
        for <linux-scsi@vger.kernel.org>; Wed,  6 Sep 2023 04:33:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-51e28cac164so1748427a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Sep 2023 04:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693999989; x=1694604789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=F4ZnpdubhyYmtydqMWzP1BxA67KulQROyAS5/n5ddvg=;
        b=cSNOCLP9rwHzQU30rS/LlTgMX0K/0YCEfgOb2EtqDmDbQPtm+7tJiiSArqVd5LyEBE
         uiwqq/bcyVlyDAhf9m2rYXERaR2Vb2AKyS7rc81lYQ+LsPRMpGdw8+n8+dqLcM0tc92E
         30Pm+CS1qjg2+cxEWO9Ip49hTYQbewoG9Lr+25s/zLDVwumd4UdTibePp0Ya78tj0SDk
         tWLUNc1VHttW1NFRqeHwa33cwG0QTjz0rFjxWJk/HW2Afdy6NESXcuLVgw9zAXBbgSKd
         dJeAuNOJ6Js9sI0gdTAFbKNP/fbEduMuDgwDdxeQrPymxrMkZve9Mm1gHqNovZcO6cE/
         jdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693999989; x=1694604789;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F4ZnpdubhyYmtydqMWzP1BxA67KulQROyAS5/n5ddvg=;
        b=MhNvk4J16h2Ic2pAQUo55aIhiJttk7iafDNm+E1+fjr3tZpsuOKHbUf3907uZMxCvm
         Eo6wIQsJjXi6bxi6SOCbu5nLXvjevvsPv0yyTkEFBYr4BOnffWdHKzte4LalRprDrZ2Z
         1h7Zc250oODNNG3CRg81n17huCb5IDKQuCIZ4SEba2Tk0Dbshxjoskzvzx4QklF+V0xK
         koedKM0lQaT4TuZWCcaHUxLzdoh3aO/r6zfdMzH1B6hcmPR3ghLmZzqcxHo3cj4lzXkH
         WamuDuszSRdyBB62oBw979w9yw3+26Da8S+xCesKYAh2S1VJPtc6fp0Yx3PR8sQf0CVu
         wUbA==
X-Gm-Message-State: AOJu0YzpJCvri4JnQ7kN3xv1a/NIftaMQTBOcx3dEi4Zf7vL47UbbkxR
        apVRZU7/ZJgij+3B7dZEYhIMcw==
X-Google-Smtp-Source: AGHT+IHendEcILigzm+13T6wKgoeOTOCi5Gg0KhlfTRaErItptfzN10sryNjfJSw8Ig2bTdARTW8Fg==
X-Received: by 2002:aa7:d351:0:b0:523:c36e:ec8b with SMTP id m17-20020aa7d351000000b00523c36eec8bmr2531498edr.9.1693999988721;
        Wed, 06 Sep 2023 04:33:08 -0700 (PDT)
Received: from krzk-bin.. (77-252-46-238.static.ip.netia.com.pl. [77.252.46.238])
        by smtp.gmail.com with ESMTPSA id m6-20020a056402050600b0052a404e5929sm8157907edv.66.2023.09.06.04.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 04:33:08 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH] scsi: ufs: do not look for unsupported vdd-hba-max-microamp
Date:   Wed,  6 Sep 2023 13:33:02 +0200
Message-Id: <20230906113302.201888-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bindings do not allow vdd-hba-max-microamp property and the driver does
not use it (does not control load of vdd-hba supply).  Skip looking for
this property to avoid misleading dmesg messages:

  ufshcd-qcom 1d84000.ufs: ufshcd_populate_vreg: unable to find vdd-hba-max-microamp

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/ufs/host/ufs-mediatek.c  |  2 +-
 drivers/ufs/host/ufshcd-pltfrm.c | 15 ++++++++++-----
 drivers/ufs/host/ufshcd-pltfrm.h |  2 +-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 2383ecd88f1c..941f58744d08 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -806,7 +806,7 @@ static int ufs_mtk_vreg_fix_vcc(struct ufs_hba *hba)
 		return 0;
 	}
 
-	err = ufshcd_populate_vreg(dev, vcc_name, &info->vcc);
+	err = ufshcd_populate_vreg(dev, vcc_name, &info->vcc, false);
 	if (err)
 		return err;
 
diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index 797a4dfe45d9..61cf8b957da4 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -121,7 +121,7 @@ static bool phandle_exists(const struct device_node *np,
 
 #define MAX_PROP_SIZE 32
 int ufshcd_populate_vreg(struct device *dev, const char *name,
-			 struct ufs_vreg **out_vreg)
+			 struct ufs_vreg **out_vreg, bool skip_current)
 {
 	char prop_name[MAX_PROP_SIZE];
 	struct ufs_vreg *vreg = NULL;
@@ -147,6 +147,11 @@ int ufshcd_populate_vreg(struct device *dev, const char *name,
 	if (!vreg->name)
 		return -ENOMEM;
 
+	if (skip_current) {
+		vreg->max_uA = 0;
+		goto out;
+	}
+
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
 		dev_info(dev, "%s: unable to find %s\n", __func__, prop_name);
@@ -175,19 +180,19 @@ static int ufshcd_parse_regulator_info(struct ufs_hba *hba)
 	struct device *dev = hba->dev;
 	struct ufs_vreg_info *info = &hba->vreg_info;
 
-	err = ufshcd_populate_vreg(dev, "vdd-hba", &info->vdd_hba);
+	err = ufshcd_populate_vreg(dev, "vdd-hba", &info->vdd_hba, true);
 	if (err)
 		goto out;
 
-	err = ufshcd_populate_vreg(dev, "vcc", &info->vcc);
+	err = ufshcd_populate_vreg(dev, "vcc", &info->vcc, false);
 	if (err)
 		goto out;
 
-	err = ufshcd_populate_vreg(dev, "vccq", &info->vccq);
+	err = ufshcd_populate_vreg(dev, "vccq", &info->vccq, false);
 	if (err)
 		goto out;
 
-	err = ufshcd_populate_vreg(dev, "vccq2", &info->vccq2);
+	err = ufshcd_populate_vreg(dev, "vccq2", &info->vccq2, false);
 out:
 	return err;
 }
diff --git a/drivers/ufs/host/ufshcd-pltfrm.h b/drivers/ufs/host/ufshcd-pltfrm.h
index 2df108f4ac13..a86a3ada4bef 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.h
+++ b/drivers/ufs/host/ufshcd-pltfrm.h
@@ -32,6 +32,6 @@ void ufshcd_init_pwr_dev_param(struct ufs_dev_params *dev_param);
 int ufshcd_pltfrm_init(struct platform_device *pdev,
 		       const struct ufs_hba_variant_ops *vops);
 int ufshcd_populate_vreg(struct device *dev, const char *name,
-			 struct ufs_vreg **out_vreg);
+			 struct ufs_vreg **out_vreg, bool skip_current);
 
 #endif /* UFSHCD_PLTFRM_H_ */
-- 
2.34.1

