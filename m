Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D7A0EE49A6
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 12:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbjHUMLg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 08:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbjHUMLc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 08:11:32 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3517EB
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 05:11:28 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-31c479ede21so863426f8f.2
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 05:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692619887; x=1693224687;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2gnJCWf/bRcO/fsb+MoLh5VvozMVWd5lNcZa1VfleQA=;
        b=zivIEfz4ArFYxpmPCe2Ayh47Iez8SIzDYAvrScs7VxKat8WRxo4Xphg7x45xBBnIh7
         zG9UQ2tU6LCi9rL6h6E5BcGO9h3HKS2uukCeoUJINc14sGJdmddJbHPAtelFD5A5fwcN
         QQHvskEsgZthSsiGOOkCPEhuHCZY7Cr1xFj4kQekRTE0V51A8vnmd886exvfiYkuz1/H
         4bBQb5OtG5yrnWJDBKWKAuOvHxjUs6xWoRMApDdFwq6weIU72GasUKYtRPenf1pv8p3i
         ezYJPAfrprCmzbjN0udqRY9f5LXLD7S5noO4J+aHdztZoKyfiVTd0wg1kmJWZDijsZa6
         DjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692619887; x=1693224687;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2gnJCWf/bRcO/fsb+MoLh5VvozMVWd5lNcZa1VfleQA=;
        b=Y7AbcJQZrwHKZUJiXpR+yBx3ZhY7WrOlo8kqzXKJnalUzWXjIeidoHDOIYUKYkjBsL
         B0WvvgASVilLBzMrGkjG3ABVKKGY/6yhYBfHk1EVqjNxtIA4cKNPXhKll1we6x+/+QyK
         0gu81btKTFQp6L644HExeKDtSoNLLhkt2yAD5+WuFWS96Xnd7sYTiM8oFb7qpEThLrqA
         PrLCv1kZVvoNaw3TAI47Y9TRctVd+dL/pEdzoT7N28PEwwBuPM46DUwZHIgMaLiKP3uP
         YhbkocdMYbbCMfEiF23niyI1uz6GNrrrWZVuVj2zFpB1BUxBz0eaYA7qNpUcdAWdgX5G
         AsYw==
X-Gm-Message-State: AOJu0YxqsfEos8ZZaSOa+aENOosUdkdG2YSn/pjXlcOn6xdEgmtet29d
        5Ulk9N0IoGf79+2gNUJ+RuGKn/8zMk/GXOCcyY1wJA==
X-Google-Smtp-Source: AGHT+IEKc+phXZOlYo7ZHIrJvhZ/u0ttOsD7g9xqqrnpo3w8enOn1Txm9Gz3hAt/khYmMBpRx4iLWw==
X-Received: by 2002:adf:dd90:0:b0:315:9e1b:4ea6 with SMTP id x16-20020adfdd90000000b003159e1b4ea6mr4540162wrl.58.1692619887298;
        Mon, 21 Aug 2023 05:11:27 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id u4-20020a5d5144000000b003176053506fsm12223822wrt.99.2023.08.21.05.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 05:11:26 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Mon, 21 Aug 2023 14:11:21 +0200
Subject: [PATCH v2] scsi: ufs: ufs-qcom: clear qunipro_g4_sel for HW major
 version > 5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230821-topic-sm8x50-upstream-ufs-major-5-plus-v2-1-f42a4b712e58@linaro.org>
X-B4-Tracking: v=1; b=H4sIAGhU42QC/5XNQQ6CMBCF4auQrh3TFojoynsYFk0ZYAzQZgYIh
 nB3Kzdw+b/F+3YlyISiHtmuGFcSClMKe8mU793UIVCTWlltc11ZA3OI5EHGais1LFFmRjfC0gq
 M7h0YSojDIlCgc03e5k1V3lQ6i4wtbSf0qlP3JHPgz+mu5rf+TawGDHhTeI9W31trngNNjsM1c
 Kfq4zi+OL7vtd0AAAA=
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1449;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=L44jkzTqqSuRGogpCGvOFb+mcJf5dVzd0N97KsYF8pU=;
 b=owEBbAKT/ZANAwAKAXfc29rIyEnRAcsmYgBk41RtU29eL0lfv4wIVtTmWmcnEUHPz88ffWNkYiEZ
 PNIdNZmJAjIEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZONUbQAKCRB33NvayMhJ0bGqD/
 Y4Vj61b+Kie1XMLl4dWf0uOCaTawTXTkGZF0/o325XmN+UwLAuXenKbnbQNFJmd/0XFejgMecbvapJ
 n4+ck6CvaBoTJci6cNEyICva9T1q9qGCusSMTYzssRYYp7r9HWOHcYe9VeVfZs/ZGe6PoxXHlN0E2A
 X9xlrMYTIVJlup2X9Yj7wWfTuhccLp4DwjOtckpNwMbEL6IPe9Vlf/Ph1MoHGGgiGmzUaXCYRwRH6d
 5X7UJCF2i15ivfXwcVJJCqLQPWu1i9tDP6HNz3rT42vWaHi5IrnIQmwl0a4vY4rJSFWL5Th1ayLyY/
 246njY+ki1hXnVbfzZZc/97X4JMWvZ3uKbpx4y/xX3nVRo00T8LtGVQbBQkHbG4STGRvglc5f1IsMl
 WEQAlg33DJ8xJ7mpW8Apo798AdLYa8Qu28p+9aiZwLiI9MMSjf8nSOVu+t3o+B6l9hm0btooKKPJJ4
 Y3A8Mnb/e3CNZh9KcmXqtEE9D8/GoF0c43yzvnuq/D3fU9MQcGot5c4WVQWoLt4iucspRGx7aUsMMk
 l2Ki8p/Nfknz/R9UBb3XAsPOCvqAcDEC/hdqmbcL/Jk8gTiBaH3TQsP++QsFj/BjTwM70tscjjfkcr
 EhyrWiMLf5QroFrwrHaHp8FY1lxQsvle+HQVVx0TQyfd0Zj86F2720wpxn
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The qunipro_g4_sel clear is also needed for new platforms with
major version > 5, fix the version check to take this in account.

Fixes: 9c02aa24bf40 ("scsi: ufs: ufs-qcom: Clear qunipro_g4_sel for HW version major 5")
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
Changes in v2:
- Added Fixes tag as suggested by Mani
- Added Acked-by and Reviewed-by tags
- Link to v1: https://lore.kernel.org/r/20230821-topic-sm8x50-upstream-ufs-major-5-plus-v1-1-c14cce209f21@linaro.org
---
 drivers/ufs/host/ufs-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index f88febb23123..d1149b1c3ed5 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -365,7 +365,7 @@ static void ufs_qcom_select_unipro_mode(struct ufs_qcom_host *host)
 		   ufs_qcom_cap_qunipro(host) ? QUNIPRO_SEL : 0,
 		   REG_UFS_CFG1);
 
-	if (host->hw_ver.major == 0x05)
+	if (host->hw_ver.major >= 0x05)
 		ufshcd_rmwl(host->hba, QUNIPRO_G4_SEL, 0, REG_UFS_CFG0);
 
 	/* make sure above configuration is applied before we return */

---
base-commit: 47d9bb711707d15b19fad18c8e2b4b027a264a3a
change-id: 20230821-topic-sm8x50-upstream-ufs-major-5-plus-4eaad3f3d857

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>

