Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7A43EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 23:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjHAXWa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 19:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjHAXW2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 19:22:28 -0400
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9268D212C
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 16:22:13 -0700 (PDT)
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6bc9d16c317so2298032a34.1
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 16:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690932133; x=1691536933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sKD5E0WKT8Fa9UzYeiuQNLCw4uuKBUi+gJi5gBgnVVg=;
        b=JK0pzauRlsp1aYvlNANG1hzU/hIfJ0ny6N+T1oQrlhX1tV09bkMNNYZcjP9RGjb2w5
         68LQJQhHXRNvIJydqwg08ikOFxQ5v0yL/GfMWNWeGOnTIPM23/D8/B6YTDXrot4cH2Nb
         aYL6km7h0YZ/OBfgeA/j0AkXWGPwNOI46qkYbvkMGf4Na0x2MQwnuPMP7VD8b4micECE
         r4moWm7hB1bNqhFO9EsUh7+3JTgtdhXqRZ9xLwXB/vGGK8Yr4D5TS1mna34utI9J5I+W
         wRufSWGvR6yWzm3s6k3Lybi0TC71a09d09ZN9QoXvD/OKjaBDu69YtJqtEOowe+XrnEp
         +CZQ==
X-Gm-Message-State: ABy/qLa1dk8Zdvg3ijP03iSZToUAqaHfTSRnsSoVinopwz+cqXQBpEjl
        Lw6MKMH9eslMdWcCOQnE1Ks=
X-Google-Smtp-Source: APBJJlFIo+khq5wM9n95ekpGUIR7W7kJSuY4kiz8/yK4fGCWrnaoUf8PyPcnopOJYlIX82WBHZH9WQ==
X-Received: by 2002:a05:6870:c086:b0:1bb:739c:9e2b with SMTP id c6-20020a056870c08600b001bb739c9e2bmr16129295oad.57.1690932132684;
        Tue, 01 Aug 2023 16:22:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3b5d:5926:23cf:5139])
        by smtp.gmail.com with ESMTPSA id j11-20020a17090a840b00b00262d662c9adsm46210pjn.53.2023.08.01.16.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 16:22:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Can Guo <quic_cang@quicinc.com>
Subject: [PATCH v2] scsi: ufs: Fix the build for gcc 9 and before
Date:   Tue,  1 Aug 2023 16:21:50 -0700
Message-ID: <20230801232204.1481902-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

gcc compilers before version 10 cannot do constant-folding for sub-byte
bitfields. This makes the compiler layout tests fail. Hence skip the
layout checks for gcc 9 and before.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 23335aaa6a66..4f5174735a4c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10564,6 +10564,14 @@ static const struct dev_pm_ops ufshcd_wl_pm_ops = {
 
 static void ufshcd_check_header_layout(void)
 {
+	/*
+	 * gcc compilers before version 10 cannot do constant-folding for
+	 * sub-byte bitfields. Hence skip the layout checks for gcc 9 and
+	 * before.
+	 */
+	if (IS_ENABLED(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 100000)
+		return;
+
 	BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
 				.cci = 3})[0] != 3);
 
