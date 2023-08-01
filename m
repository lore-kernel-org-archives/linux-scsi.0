Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DFBC00528
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Aug 2023 20:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjHAUOO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Aug 2023 16:14:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbjHAUN6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2023 16:13:58 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DF12D79
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 13:13:44 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1bbd03cb7c1so38571425ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2023 13:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690920823; x=1691525623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HELS0oepZc4nTniai12aTa4zKy75i2iH+bhamqE+z+I=;
        b=Pk22NmIPFOB2KdMeaBJb4V3AQy1fEMn5ruCtFQJToCgEjZVXiprFlprcmC50gmw7fs
         fqLe0wWtUQv11F2sYUTtYQbQ88qYRzmxm+2EYv7gIjTYgVVTM5Ii9MSELrR7CD6gciN2
         O84GXeMDr4K8iGjkwySuc4OuQMGpWo82ww89omWWK/gu1+65NqCEII6JnR7PZP1CiWMs
         eZrpVJCar2F29bJK9o8M+koEzLQ0y496am7Dh8hxOEN1FXi6fmsCO3NTn2d4y69cf5ri
         dRej7E7lv/b2gIKGH6t7jmW4Z9fjWSfEe6cQTqmdruS7g0hhCD9xd/AtuCglz0fBv7ld
         UjHg==
X-Gm-Message-State: ABy/qLZdjHiaNl3OY3Al5rUEfn5/3GMPZMK5D/1+gT6ekRzVG4z3AQJK
        uxTYshjbzCoBnLhl7yIH8/I=
X-Google-Smtp-Source: APBJJlGbn8296TYqXrIYF9YMZy17NE1KoP/0F1UqM+NQJATytwEbyXrCJeSOAULupkBbE5fAMn6cBQ==
X-Received: by 2002:a17:902:cec6:b0:1bb:df69:5e44 with SMTP id d6-20020a170902cec600b001bbdf695e44mr14510159plg.56.1690920822759;
        Tue, 01 Aug 2023 13:13:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9346:70e3:158a:281c])
        by smtp.gmail.com with ESMTPSA id g6-20020a170902740600b001b9ff5aa2e7sm10838077pll.239.2023.08.01.13.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Aug 2023 13:13:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Can Guo <quic_cang@quicinc.com>
Subject: [PATCH] scsi: ufs: Fix the build for gcc 9 and before
Date:   Tue,  1 Aug 2023 13:13:23 -0700
Message-ID: <20230801201337.1007617-1-bvanassche@acm.org>
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
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 23335aaa6a66..875c860bcc05 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10564,6 +10564,15 @@ static const struct dev_pm_ops ufshcd_wl_pm_ops = {
 
 static void ufshcd_check_header_layout(void)
 {
+#if defined(__GNUC__) && __GNUC__ -0 < 10
+	/*
+	 * gcc compilers before version 10 cannot do constant-folding for
+	 * sub-byte bitfields. Hence skip the layout checks for gcc 9 and
+	 * before.
+	 */
+	return;
+#endif
+
 	BUILD_BUG_ON(((u8 *)&(struct request_desc_header){
 				.cci = 3})[0] != 3);
 
