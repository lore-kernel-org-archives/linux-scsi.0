Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF132C1B087
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55132336E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgLFQn0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 11:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgLFQn0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 11:43:26 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26957C0613D2;
        Sun,  6 Dec 2020 08:42:45 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id n26so16001875eju.6;
        Sun, 06 Dec 2020 08:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=q3yNP+sFnB3A5+UyZ6nIR07gloyNzZH21j8nTX4SFvo=;
        b=EZIyyKm+fEhUMIH2fZq3L+gMqH9O+1TbeM7rU6DXZdppU2LV5YIp7wBLMlPdsWfiH1
         xiL4irCJQi6K97+K4z66FCjLpd9LtaK0WpIy5C0/0inlfd4EeDIHS1UIH8bM5o9NB1B3
         uQxT+3+S93aGgng7lRx72WS9zPNnaj0UjXjOIJNp3G47kJWbIqN/V5z+vbiM+ThGG9B3
         y/lxxpWc4vF8FpwOi1kHyQMrJgmC/R57wA/CsvNusfsGlwFa0K0UaocPxwOYr1QbAoPA
         bPjuxg5Vy+G1q+wq1amBGnPHtSiU742Tc5r0Cz4y0y6kPZF8mr6dim3lh91jVC1AANxn
         xKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=q3yNP+sFnB3A5+UyZ6nIR07gloyNzZH21j8nTX4SFvo=;
        b=IRhCBO9aF66ztDNhFt53RZe2ulnDkXG5LVUO0tDD4+Laj9T5HMD7OaVHClVyzLxf4r
         9aB/dsuyFxY3kqXOaHydk12gIJ4FC6Xx+gjkkw9t+nwvx6w9y2uEbH16KuvQR54E0o11
         xB7O8kDMvOLPGqgsfTx6Nvv3CrBatFMzTMBATimbB207cOYZ7tCc0dy0E28xnCjAgkNn
         Rrn0R3eVbUhXDxkdSF/dtQWHOBR6RFjN7v2k0u7dYtjAZXP5QGGoz4R4ZWwiI8p/PSWn
         vZeERQNIuR768NJINYlN4bXYWM8g2KQAhczqLIi8vWJqHwUYcZp6Yopbb7msYLTsxJaL
         UZ5Q==
X-Gm-Message-State: AOAM533+M/VHGxNOmOHgIqp0cBrXLlhW5iBcwkD10rEyMzBDATDDw1Jx
        BWWVxryEQYYDyDnOoC0Osgs=
X-Google-Smtp-Source: ABdhPJxbPMwGkTUBIBcRKmEMKyHT74JWhDkkSrfU5nv5JqXVBNM1Gq73C+Ux2hf335QUa1Q5PtAf0g==
X-Received: by 2002:a17:906:3a84:: with SMTP id y4mr15741502ejd.425.1607272963923;
        Sun, 06 Dec 2020 08:42:43 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e19sm9157524edr.61.2020.12.06.08.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 08:42:43 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: [PATCH v1 2/3] scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM UPIU trace
Date:   Sun,  6 Dec 2020 17:42:25 +0100
Message-Id: <20201206164226.6595-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201206164226.6595-1-huobean@gmail.com>
References: <20201206164226.6595-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Distinguish between TM request UPIU and response UPIU in TM UPIU trace,
for the TM response, let TM UPIU trace print its TM response UPIU.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e10de94adb3f..29d7240a61bf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -338,8 +338,12 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 	int off = (int)tag - hba->nutrs;
 	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[off];
 
-	trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->req_header,
-			&descp->input_param1);
+	if (!strcmp("tm_send", str))
+		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->req_header,
+				  &descp->input_param1);
+	else
+		trace_ufshcd_upiu(dev_name(hba->dev), str, &descp->rsp_header,
+				  &descp->output_param1);
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
-- 
2.17.1

