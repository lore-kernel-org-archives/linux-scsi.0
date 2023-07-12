Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018D4EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjGLKzP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbjGLKzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:55:13 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8381A10C7
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:55:11 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b8b4748fe4so34854425ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159311; x=1691751311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Da5r3Jfw26dVyORzvrEm8qPAG9eUA105lcs0ZwlGe4=;
        b=UPN+fIvjRmpp/BQsrpmteE0y3Ndyok7vzlGt65IBy9NM3QO6fyfsXRGRTCiXm7APxb
         7JyOLOoxDPI+iWdGPVR+YoTNbWqsG8oWlUNa8PMMlkVjkk6yQR8YoOyZ4FxZ/rWQRdwJ
         6JCVz/abUgEWOT1WTW1SARHnl2p7vTIeBxjd7cY+yurin+unUgaAhtKLmKX9NeRETPwB
         7yKl1yRoXTm0dUzqOmTeemROe0W3uH6JkD6127P5/QrvqVUutYP+Bh8J2oKB3gH2af5N
         +h/xkGxlv5XVCrg6Bv+NsKUlMpzaUBILOD1GsKFzrJTYV8aXT5XhitXvo2na9e5wypT1
         sXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159311; x=1691751311;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Da5r3Jfw26dVyORzvrEm8qPAG9eUA105lcs0ZwlGe4=;
        b=EFEvhUCrjNeKLxkrneDtUMdkpn9+0DzFAg4E+lgHjCuj1MvN+TqUj2A1hpZi4HN+WO
         uxQX27Mz71l1ov9l/T3xDNNAV1wojYJyzxuCjGAqz8ravK5yAbtDG8NTY7e/E31yB5/J
         Kjy/3t2BWHXYtokeDZhcjzaBDjTEkHPiozMTCqeNaRmSE1IG+FNY9krfoLBTbjk7czDW
         uaY4KJcGU7YyL8eGmweULVsaxGY43ya1GRKnJui5T71++eGxD1pGUBlyTN8APRWXgqtV
         b80046BvzeTbBKRwytamdgtU282/zOi9tdRBAIcX/Tj5vMwCkuOSQxkdXRMYXUoE3TxL
         rqkA==
X-Gm-Message-State: ABy/qLZ0SupK4F87E/QDdQcLk+MdQJDNPtQR1p2/j1Lm2udYxWe0nJKF
        Ie7Vjx5yn6gD9xsiIO+mLvnm
X-Google-Smtp-Source: APBJJlH4EREFTN7R9bkqsID+S4IdCpMRzwt02bg6KHEVamyx/JfBF24BBusSu28BB0FSifIbK5Bw8g==
X-Received: by 2002:a17:903:455:b0:1b8:95a2:d87e with SMTP id iw21-20020a170903045500b001b895a2d87emr13233989plb.2.1689159310961;
        Wed, 12 Jul 2023 03:55:10 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id a2-20020a1709027d8200b001b8622c1ad2sm3656895plm.130.2023.07.12.03.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:55:10 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:34:03 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     vireshk@kernel.org, nm@ti.com, sboyd@kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, andersson@kernel.org,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        quic_asutoshd@quicinc.com, quic_cang@quicinc.com,
        quic_nitirawa@quicinc.com, quic_narepall@quicinc.com,
        quic_bhaskarv@quicinc.com, quic_richardp@quicinc.com,
        quic_nguyenb@quicinc.com, quic_ziqichen@quicinc.com,
        bmasney@redhat.com, krzysztof.kozlowski@linaro.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 07/14] OPP: Introduce dev_pm_opp_find_freq_{ceil/floor}_indexed() APIs
Date:   Wed, 12 Jul 2023 16:02:02 +0530
Message-Id: <20230712103213.101770-8-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
References: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: HFX/P/BM8+rx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the case of devices with multiple clocks, drivers need to specify the
clock index for the OPP framework to find the OPP corresponding to the
floor/ceil of the supplied frequency. So let's introduce the two new APIs
accepting the clock index as an argument.

These APIs use the exising _find_key_ceil() helper by supplying the clock
index to it.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/opp/core.c     | 54 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/pm_opp.h | 18 ++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 3f46e499d615..a6d0b6b18e0e 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -658,6 +658,33 @@ struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_ceil);
 
+/**
+ * dev_pm_opp_find_freq_ceil_indexed() - Search for a rounded ceil freq for the
+ *					 clock corresponding to the index
+ * @dev:	Device for which we do this operation
+ * @freq:	Start frequency
+ * @index:	Clock index
+ *
+ * Search for the matching ceil *available* OPP for the clock corresponding to
+ * the specified index from a starting freq for a device.
+ *
+ * Return: matching *opp and refreshes *freq accordingly, else returns
+ * ERR_PTR in case of error and should be handled using IS_ERR. Error return
+ * values can be:
+ * EINVAL:	for bad pointer
+ * ERANGE:	no match found for search
+ * ENODEV:	if device not found in list of registered devices
+ *
+ * The callers are required to call dev_pm_opp_put() for the returned OPP after
+ * use.
+ */
+struct dev_pm_opp *dev_pm_opp_find_freq_ceil_indexed(struct device *dev,
+					     unsigned long *freq, u32 index)
+{
+	return _find_key_ceil(dev, freq, index, true, _read_freq, NULL);
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_ceil_indexed);
+
 /**
  * dev_pm_opp_find_freq_floor() - Search for a rounded floor freq
  * @dev:	device for which we do this operation
@@ -683,6 +710,33 @@ struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
 
+/**
+ * dev_pm_opp_find_freq_floor_indexed() - Search for a rounded floor freq for the
+ *					  clock corresponding to the index
+ * @dev:	Device for which we do this operation
+ * @freq:	Start frequency
+ * @index:	Clock index
+ *
+ * Search for the matching floor *available* OPP for the clock corresponding to
+ * the specified index from a starting freq for a device.
+ *
+ * Return: matching *opp and refreshes *freq accordingly, else returns
+ * ERR_PTR in case of error and should be handled using IS_ERR. Error return
+ * values can be:
+ * EINVAL:	for bad pointer
+ * ERANGE:	no match found for search
+ * ENODEV:	if device not found in list of registered devices
+ *
+ * The callers are required to call dev_pm_opp_put() for the returned OPP after
+ * use.
+ */
+struct dev_pm_opp *dev_pm_opp_find_freq_floor_indexed(struct device *dev,
+					      unsigned long *freq, u32 index)
+{
+	return _find_key_floor(dev, freq, index, true, _read_freq, NULL);
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor_indexed);
+
 /**
  * dev_pm_opp_find_level_exact() - search for an exact level
  * @dev:		device for which we do this operation
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index dc1fb5890792..991f54da79b5 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -124,6 +124,9 @@ struct dev_pm_opp *dev_pm_opp_find_freq_exact(struct device *dev,
 struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 					      unsigned long *freq);
 
+struct dev_pm_opp *dev_pm_opp_find_freq_floor_indexed(struct device *dev,
+					      unsigned long *freq, u32 index);
+
 struct dev_pm_opp *dev_pm_opp_find_level_exact(struct device *dev,
 					       unsigned int level);
 struct dev_pm_opp *dev_pm_opp_find_level_ceil(struct device *dev,
@@ -132,6 +135,9 @@ struct dev_pm_opp *dev_pm_opp_find_level_ceil(struct device *dev,
 struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 					     unsigned long *freq);
 
+struct dev_pm_opp *dev_pm_opp_find_freq_ceil_indexed(struct device *dev,
+					     unsigned long *freq, u32 index);
+
 struct dev_pm_opp *dev_pm_opp_find_bw_ceil(struct device *dev,
 					   unsigned int *bw, int index);
 
@@ -271,12 +277,24 @@ static inline struct dev_pm_opp *dev_pm_opp_find_freq_floor(struct device *dev,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct dev_pm_opp *dev_pm_opp_find_freq_floor_indexed(struct device *dev,
+					unsigned long *freq, u32 index)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct dev_pm_opp *dev_pm_opp_find_freq_ceil(struct device *dev,
 					unsigned long *freq)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline struct dev_pm_opp *dev_pm_opp_find_freq_ceil_indexed(struct device *dev,
+					unsigned long *freq, u32 index)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static inline struct dev_pm_opp *dev_pm_opp_find_bw_ceil(struct device *dev,
 					unsigned int *bw, int index)
 {
-- 
2.25.1

