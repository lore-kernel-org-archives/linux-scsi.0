Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA06C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Feb 2022 15:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233084AbiBVPAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 10:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiBVPAj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 10:00:39 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D194710DA64
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:55 -0800 (PST)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A79473FCA4
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 14:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1645541994;
        bh=Yp6ZDVV8RuEvdp6hHMI16oZzyQVBXO+fcxhml4rBHaw=;
        h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=o5MumoPmVx9eifQXg9bgd4trY37BCmk2Et/4nt4biXGfl2vYeiQ920u+3O9POqs5q
         DwcG5mCi0gD/1S29WAb7ygn0Rfdzyp+3b3Qe9U+qxPU3DKBFhF5wp0wE4/yvYNq6nM
         jA4VGbbQuuA/WI0s+RZukm/csCoGcq7sBgVLSFKAov7zDtsEvNl7rm6NZkAh36xbrQ
         aRcTYFlg5OGXI7J6UisaI1Rl6+acHPzWdc/wzm0BxUq2fwKmiJDx6vwUMn5xO8oGTu
         ufWq9LvHigi8aShOoWIQ0Tz33ios0LwetV/zcz87klEGYg+fHoGdnHsyvp+Q0cNLYx
         VPC+4etmU9RJg==
Received: by mail-ej1-f70.google.com with SMTP id mp5-20020a1709071b0500b0069f2ba47b20so5803260ejc.19
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 06:59:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yp6ZDVV8RuEvdp6hHMI16oZzyQVBXO+fcxhml4rBHaw=;
        b=b/4LZlUhNvKaMrdRwi5y5EnK14jkg+0DYD78qpJpJQn4N2h6oMDeESkxGFFCCWiqKP
         C0xWvmu7ifQqhEl3Jzt8rxBSbTUd2UKFCDTo7/RLQLg/EgY6L8ZVHbhZut/LKaiW7JIC
         MtgFRAgeBOKbZ9/11zcnktCCevskGuYNtOFFXDiWQPRhFRsvu588qaq8c/2soXm8Bb/D
         BN0yMlpbFcD48ebFMqt+mF1swMMRgNKVgjKY4notN/zD5/rtL/5+atYMLG2Z5ztwBVrQ
         qm9lduzzhnVc6Hh4cPTgAiJcX/+szZmRO+de510ZzNXx5jwW+ZGeDo9xHnnVZv3JApd5
         7UYA==
X-Gm-Message-State: AOAM533XL0jty8CBxXQBoZsxCbcVB6NhwHjllwNc7Oz0dPRuKWlb/CqG
        QXx0Er3Kq6H2iZQ/kwVA5AtfEAXi/5l38kEEXosDq7oLAAwmKDo6J8RlSFRYDTtHTiYh1fbgoOV
        piUjMRPS2EqzuYu4xIM6bmbfs4us/8sqjFpbNWK0=
X-Received: by 2002:a17:906:8299:b0:6cf:3847:284b with SMTP id h25-20020a170906829900b006cf3847284bmr19368272ejx.682.1645541994351;
        Tue, 22 Feb 2022 06:59:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx+ToxX03cNeq8vGzKfuUoRQ0zvi1K010zfig8ivZ8cYm8EVedSW9bVloWqWHnEbvwuSlDU2A==
X-Received: by 2002:a17:906:8299:b0:6cf:3847:284b with SMTP id h25-20020a170906829900b006cf3847284bmr19368246ejx.682.1645541994125;
        Tue, 22 Feb 2022 06:59:54 -0800 (PST)
Received: from localhost.localdomain (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id m2sm2467960ejb.20.2022.02.22.06.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 06:59:53 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Wei Xu <xuwei5@hisilicon.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jan Kotas <jank@cadence.com>, Li Wei <liwei213@huawei.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 09/15] scsi: ufs: deprecate 'freq-table-hz' property
Date:   Tue, 22 Feb 2022 15:58:48 +0100
Message-Id: <20220222145854.358646-10-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
References: <20220222145854.358646-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 'freq-table-hz' is not correct in DT schema, because '-hz' suffix
defines uint32 type, not an array.  Therefore deprecate 'freq-table-hz'
and use 'freq-table' instead.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 87975d1a21c8..2b192477d158 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -47,8 +47,9 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	if (cnt <= 0)
 		goto out;
 
-	if (!of_get_property(np, "freq-table-hz", &len)) {
-		dev_info(dev, "freq-table-hz property not specified\n");
+	if (!of_get_property(np, "freq-table", &len) ||
+	    !of_get_property(np, "freq-table-hz", &len)) {
+		dev_info(dev, "freq-table property not specified\n");
 		goto out;
 	}
 
@@ -57,7 +58,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 
 	sz = len / sizeof(*clkfreq);
 	if (sz != 2 * cnt) {
-		dev_err(dev, "%s len mismatch\n", "freq-table-hz");
+		dev_err(dev, "%s len mismatch\n", "freq-table");
 		ret = -EINVAL;
 		goto out;
 	}
@@ -69,12 +70,16 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 		goto out;
 	}
 
-	ret = of_property_read_u32_array(np, "freq-table-hz",
+	ret = of_property_read_u32_array(np, "freq-table",
 			clkfreq, sz);
 	if (ret && (ret != -EINVAL)) {
-		dev_err(dev, "%s: error reading array %d\n",
-				"freq-table-hz", ret);
-		return ret;
+		ret = of_property_read_u32_array(np, "freq-table-hz",
+						 clkfreq, sz);
+		if (ret && (ret != -EINVAL)) {
+			dev_err(dev, "%s: error reading array %d\n",
+				"freq-table", ret);
+			return ret;
+		}
 	}
 
 	for (i = 0; i < sz; i += 2) {
@@ -99,7 +104,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 
 		if (!strcmp(name, "ref_clk"))
 			clki->keep_link_active = true;
-		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
+		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table",
 				clki->min_freq, clki->max_freq, clki->name);
 		list_add_tail(&clki->list, &hba->clk_list_head);
 	}
-- 
2.32.0

