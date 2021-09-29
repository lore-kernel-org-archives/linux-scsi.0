Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D27C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 20:06:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD23617E2
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 20:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346403AbhI2UIi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 16:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343734AbhI2UIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 16:08:35 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62119C061764;
        Wed, 29 Sep 2021 13:06:54 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r11-20020a1c440b000000b0030cf0f01fbaso444400wma.1;
        Wed, 29 Sep 2021 13:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FwkJdXsI7IzjoquXlpaui4J2QaNI2ndlY8EwvfeAJrM=;
        b=BmTHcwuazyF6LMZt19VRsHrls7PX09o0uAA81CBBPAGvzOQVKfgmq2y5miJcL8b6JG
         LynWi59kn3Xd0nYHmZCjK+QSg5Qi5aIhPg+BqRgDVO1GeVxRlxxgJJqn47yQwlH4j0la
         CAN6cuLuqvjWKsbggOkgq6gBp2zvp/dzDUeTkLWyEDi1GuUhmAEoHQRRjVuZAoiNMWsk
         N8sWxYH+bItswJplqIv1wVRAYOF59D0BlbIlMv8C2K2+U6gg3uPPET2UY+tTBAEI7aX+
         BGxdK8oYDnWOSXTS0qJdaLmykdImVjGo05tFpB0ETWLKHn+SsESUxNetsebbzWUgKS6V
         B68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FwkJdXsI7IzjoquXlpaui4J2QaNI2ndlY8EwvfeAJrM=;
        b=kvnrXEndB4vMJE3yK1VNhkYcwb+SR7bZDMSVGe8OeJ7f2g6EhIF340uXVxbk3/Ln1+
         QYan2gZS5I2pA7srHvKMF+YKuThh+uqZdqUlECguS6LvBkaywNbgjS++kAnUuIUc5CDC
         ljnZrIkSarSAVAmEkKP/DUHgb/7/8TG1NlykEa+zA2UyIK+COZy/uuG7DETlIXRsffIO
         gDsfmK/aC/q0fE07XrBwPQjLuSGt+SvNrm5n1CmR+xGiVfrKWIQC3opBEHL6MIRl30p1
         oAgsQgbAXPTUxNfLeNDBMWezyLrw6wUnv/DP6qeEwfeHg+pGP1tKwl5XaQvAsNVzSmri
         ZsXw==
X-Gm-Message-State: AOAM532dXLzBo0/EHBx+PUAS8o5BFXugPUGto7qOFUN4iAQrZN4NPKXg
        bfrn4G7vaT1KIHbc3qRA9pk=
X-Google-Smtp-Source: ABdhPJxj8ZzLJLOOm8XxXteieqMFU35eNpbQf2yI9uVErzSGQKBHyaRTL1Iq829t9eBVGA1jq4tJNQ==
X-Received: by 2002:a1c:2289:: with SMTP id i131mr12225500wmi.34.1632946013071;
        Wed, 29 Sep 2021 13:06:53 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94717cf3fe089f40c55d147be.dip0.t-ipconnect.de. [2003:e9:4717:cf3f:e089:f40c:55d1:47be])
        by smtp.gmail.com with ESMTPSA id l17sm910405wrx.24.2021.09.29.13.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 13:06:52 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] scsi: ufs: core: fix ufshcd_probe_hba() prototype to match the definition
Date:   Wed, 29 Sep 2021 22:06:39 +0200
Message-Id: <20210929200640.828611-3-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210929200640.828611-1-huobean@gmail.com>
References: <20210929200640.828611-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Since commit 568dd9959611 ("scsi: ufs: Rename the second
ufshcd_probe_hba() argument"), the second ufshcd_probe_hba()
argument has been changed to init_dev_params.

Fixes: 568dd9959611 ("scsi: ufs: Rename the second ufshcd_probe_hba() argument")
Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index debef631c89a..081092418e2d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -225,7 +225,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_clear_ua_wluns(struct ufs_hba *hba);
-static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
+static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
-- 
2.25.1

