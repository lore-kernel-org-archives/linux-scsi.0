Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B75EB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 10:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjGLKzj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 06:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbjGLKzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 06:55:33 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE20210C7
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:55:32 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1b8b318c5cfso49910805ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 03:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1689159332; x=1691751332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:from:to:cc:subject:date:message-id:reply-to;
        bh=JVAw7udukL38zwKtT4457ZqK6it2VdBXoqf1V9p3kc4=;
        b=q7AD0y1cbuFrN+kNxvk/NxkUvKc1lGs2bZsBXCcYts3CqYof45sI7X7YK73U3ouibK
         Rquk7XYWij3AzlyM20tpvt72gH9JZ7BKKxk2CtIqOFNf2FgTfoEawvlm5nqBenORQ6to
         VVo3d+aPbOxbVvSsGXiEMB7S6atC6+1E1D317sBxwhM932qnN0xBgjWNucjGiSvAowHu
         uz+kMyI8KPMZ8Zsukfl5XY0cBwMeplTkN0h3cTTXKlc6gvbUpLIV+HMcKSTkzGVHamDt
         i0KXn7AroEHDjWq/hrFjDmvRAE+DPQPC77QxJzMAV7UXayaWeaVNcypCQ7FD199vjCpb
         eURQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689159332; x=1691751332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:resent-to:resent-message-id
         :resent-date:resent-from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JVAw7udukL38zwKtT4457ZqK6it2VdBXoqf1V9p3kc4=;
        b=Q3f0aQznugSrd04rZjdmTuX0TliUeuNWyJdQlag4H2kOy0VPhTkwdQMBIUDXOwTkja
         XAHzPsx/uxLEkm7LjagwPwJwhParTE+GwEgUPtALjwVYDhvn7t9OqafVgyc8U+yWlCzF
         +Hr5kSy1Wbaa5q8MwHO/t6SG9QzCJ5MaOxB9NZk10fzXycWuShdBP112enQp1RLqnB/t
         I3CjaxeTSiBM1kER3NgVoCEiITEKnPFwjfztdNxyIwq08eWOXy3mOyqDWl5lSrjz5ZsZ
         I5pSpxkrbtC3xV3um+QKT8X50/E0e4lsCwodzXGUpO6bpAGYqzizwFr+2w1i8/Lp312N
         8f/w==
X-Gm-Message-State: ABy/qLYRk2NtXYo4hbElW0NCczoRWnJPPZvnYOSSRmlgxY9U391IyoSx
        ieTIba2Z1JggWrLYD23enhfz
X-Google-Smtp-Source: APBJJlFGacXmWisJV8ogf98hYuhsEPoXNee/ZrWYS19sCjzJeKxv+iQFGEXqqcWQag+D1nCj0fnkVA==
X-Received: by 2002:a17:902:bb89:b0:1a9:b8c3:c2c2 with SMTP id m9-20020a170902bb8900b001a9b8c3c2c2mr18918331pls.37.1689159332236;
        Wed, 12 Jul 2023 03:55:32 -0700 (PDT)
Received: from thinkpad ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id ji19-20020a170903325300b001b869410ed2sm3679385plb.72.2023.07.12.03.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:55:32 -0700 (PDT)
Received: from localhost.localdomain ([117.207.27.131])
        by smtp.gmail.com with ESMTPSA id k15-20020aa790cf000000b00666b3706be6sm3247860pfk.107.2023.07.12.03.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jul 2023 03:34:16 -0700 (PDT)
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
Subject: [PATCH 08/14] OPP: Introduce dev_pm_opp_get_freq_indexed() API
Date:   Wed, 12 Jul 2023 16:02:03 +0530
Message-Id: <20230712103213.101770-9-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
References: <20230712103213.101770-1-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TUID: xHH4T8plG4y9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the case of devices with multiple clocks, drivers need to specify the
frequency index for the OPP framework to get the specific frequency within
the required OPP. So let's introduce the dev_pm_opp_get_freq_indexed() API
accepting the frequency index as an argument.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/opp/core.c     | 22 ++++++++++++++++++++++
 include/linux/pm_opp.h |  8 ++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index a6d0b6b18e0e..66dc0d0cfaed 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -197,6 +197,28 @@ unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq);
 
+/**
+ * dev_pm_opp_get_freq_indexed() - Gets the frequency corresponding to an
+ *				   available opp with specified index
+ * @opp: opp for which frequency has to be returned for
+ * @index: index of the frequency within the required opp
+ *
+ * Return: frequency in hertz corresponding to the opp with specified index,
+ * else return 0
+ */
+unsigned long dev_pm_opp_get_freq_indexed(struct dev_pm_opp *opp, u32 index)
+{
+	struct opp_table *opp_table = opp->opp_table;
+
+	if (IS_ERR_OR_NULL(opp) || index >= opp_table->clk_count) {
+		pr_err("%s: Invalid parameters\n", __func__);
+		return 0;
+	}
+
+	return opp->rates[index];
+}
+EXPORT_SYMBOL_GPL(dev_pm_opp_get_freq_indexed);
+
 /**
  * dev_pm_opp_get_level() - Gets the level corresponding to an available opp
  * @opp:	opp for which level value has to be returned for
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index 991f54da79b5..97eb6159fb93 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -105,6 +105,8 @@ unsigned long dev_pm_opp_get_power(struct dev_pm_opp *opp);
 
 unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp);
 
+unsigned long dev_pm_opp_get_freq_indexed(struct dev_pm_opp *opp, u32 index);
+
 unsigned int dev_pm_opp_get_level(struct dev_pm_opp *opp);
 
 unsigned int dev_pm_opp_get_required_pstate(struct dev_pm_opp *opp,
@@ -211,6 +213,12 @@ static inline unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
 	return 0;
 }
 
+static inline unsigned long dev_pm_opp_get_freq_indexed(struct dev_pm_opp *opp,
+						      u32 index)
+{
+	return 0;
+}
+
 static inline unsigned int dev_pm_opp_get_level(struct dev_pm_opp *opp)
 {
 	return 0;
-- 
2.25.1

