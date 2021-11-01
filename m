Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4771C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 02:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B03E660F45
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 02:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhKACWc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Oct 2021 22:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhKACWb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Oct 2021 22:22:31 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B71C061714;
        Sun, 31 Oct 2021 19:19:59 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id br39so2126861qkb.8;
        Sun, 31 Oct 2021 19:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=apo1O/u7x4ygIzIjs1+32Zs5mIdmvskQIGsrlrv3jIM=;
        b=MvgA2rL3j+obJa0oiLSETqU9HjLHkgDSJ4mfgmVxnBwOAKZ7hzkHdWQjB5U5MwO+pM
         oAWp1Zldu9vfVt3LgePYZArY+GwTOz3orPKafLENJqPeU5IT1e8ru9AYripseK9gCfh7
         imElCpwoP7NmWur3/jDTKs/qCNh/bQW6xGb5mWwTRkE7tMIPSKH3ulWvkLN9jnXa9n2J
         c3fsW0gCVaHuUGJ3KfPkuYfo425LXgBgH6mEbmsQXVR1NkeoOKnQ4JolFcZUPVz1g/R+
         wux29HDM2dWp95S8970xOqaP2zcZ+XWXR1kJ9EQ2BwOa9kjMeynp1IL2A1l+k0I7dvbf
         +7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=apo1O/u7x4ygIzIjs1+32Zs5mIdmvskQIGsrlrv3jIM=;
        b=77rWt7lie0tKy+pS+pTeFAA/I8/UrU7Vx+64G/0KQwjw18Ded2teiZ9EuuugaIzIps
         wqEmbALd4cfpMShnwn3IsfZmM8Q43oUSp2zhVdu16/MJciPapwfAS1Xo72qAzZT1a2bL
         daQh+bT3EXiEdkqpX92rGspFPcJCthXOB2XHBcQ+XwdnRoup9u0nzvLMdgDbU1O7RMv0
         YkF1QcLIvkRmtfvRwBJC653xergkO1l6hkiMWzhNKWM4DvABedmqtXgKwKczlxXIS8Gt
         opoua9PDR7bGBOscIMjTV/100TY+OCXXc3PJuGw4Bxm+I/WL0gxNuj7kY96mun2JhOzJ
         EXKQ==
X-Gm-Message-State: AOAM531VSH1DehV3VC8jfvaALe65UUfvRR6asLxaLkNLvyOgZEPrdR+B
        NZnO710PN0d6LVlAuki/5jU=
X-Google-Smtp-Source: ABdhPJynPAPcFb/y63CzxPiJ/4rzD4iznUAB7ay6xOQniYLEJwEpfwx5w6zO1igWqZUnXVCQ+EDtjQ==
X-Received: by 2002:a37:88c2:: with SMTP id k185mr20983364qkd.227.1635733197396;
        Sun, 31 Oct 2021 19:19:57 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a3sm10149002qta.58.2021.10.31.19.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Oct 2021 19:19:56 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi minghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: fixup coccinelle warnings
Date:   Mon,  1 Nov 2021 02:19:05 +0000
Message-Id: <20211101021905.34659-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: chi minghao <chi.minghao@zte.com.cn>

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: chi minghao <chi.minghao@zte.com.cn>
---
 drivers/scsi/ncr53c8xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index fc8abe05fa8f..135a0a112dbb 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8031,7 +8031,7 @@ static ssize_t show_ncr53c8xx_revision(struct device *dev,
 	struct Scsi_Host *host = class_to_shost(dev);
 	struct host_data *host_data = (struct host_data *)host->hostdata;
 
-	return snprintf(buf, 20, "0x%x\n", host_data->ncb->revision_id);
+	return sysfs_emit(buf, "0x%x\n", host_data->ncb->revision_id);
 }
 
 static struct device_attribute ncr53c8xx_revision_attr = {
-- 
2.25.1

