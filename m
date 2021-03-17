Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746BBC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CEF364F26
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhCQI5t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhCQI5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:16 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC79C061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:15 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so4963218wmq.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jXzZsgME51o5a4S3G/qD/qZyWpfOm8qpjFIuUNjewrU=;
        b=QGHZI5JZVjfZ5Tep79BLQwCQgui+6efCtb3xulzDRViNdHHCrKeA9iGbsam5qHCR4F
         gY5m3K642uohesxcMXHKjHWXIWZ47/XuEx2konxYR6T+rcJd70So+lDNa7l6dqB1HjlH
         Jb59p8pF15hJ14Vux6S8wVGLkwhYSy2KvTBaV3rvFufg7+1RDRd4co7Cg3XPXYe3nTK1
         TMB/DOouGq0U9JhIPkGRGwF6AmwqLuBp89OlYBgvpyicBDXIyuvim0IoehV1s/5ITCHD
         6l6h3aLIG/Ij/daPoiMZAWU2YtkvkbhnmbTV0/MvamzGBwm0tmlo5hZOq0zVpgCzSMvs
         IWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jXzZsgME51o5a4S3G/qD/qZyWpfOm8qpjFIuUNjewrU=;
        b=Djco/4uN/304YSBG9tOH39vtHV65vbudr+oPXi81zlpVREnhvPzXM0DO0lBrGzKTVT
         HX45oECdc1G0ZPCxlSGkv3r6egnEZCFoI/J4KUeMdrAWBihenRZwsNR3qWqA00+fbV7G
         QEx1DeTFGIHLJ+gCge2QrAeVdUszi8zRCOkjmjdeSgyqgxPp/du8UXzCSSKdxHf85k+H
         s0+YiyZ8CMVpNBOB+k1gFpg7noUcxcaSRazbEZGcushP2wEu/3Md4/DI56lh9ba3Y3Tx
         76AfvM5njXMvJGePexzJbFeS4KU4BS0C21/Num2aoV+14nAUOexXkgkqUGXczW2aRBwB
         g42g==
X-Gm-Message-State: AOAM531c/TlijxFNnD9E5EImNCCrrr22a3YV/vXOX8oHX0irLtI+SM7U
        FzMcsXeAdPG6Af3MGU8PPiLATQ==
X-Google-Smtp-Source: ABdhPJwKpTHxLaetDBDHclcEHKeMcsLIkvwLk9lByiEkCRoyiM00PiF+OHH8mHkrLiqBPZVObm6hhw==
X-Received: by 2002:a1c:67d6:: with SMTP id b205mr2684189wmc.118.1615971434702;
        Wed, 17 Mar 2021 01:57:14 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:14 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux GmbH <hare@suse.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 09/18] scsi: myrs: Remove a couple of unused 'status' variables
Date:   Wed, 17 Mar 2021 08:56:52 +0000
Message-Id: <20210317085701.2891231-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/myrs.c: In function ‘consistency_check_show’:
 drivers/scsi/myrs.c:1193:16: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/myrs.c: In function ‘myrs_get_resync’:
 drivers/scsi/myrs.c:1984:5: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]

Cc: Hannes Reinecke <hare@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Linux GmbH <hare@suse.com>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/myrs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 4adf9ded296aa..48e399f057d5c 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1190,7 +1190,6 @@ static ssize_t consistency_check_show(struct device *dev,
 	struct myrs_hba *cs = shost_priv(sdev->host);
 	struct myrs_ldev_info *ldev_info;
 	unsigned short ldev_num;
-	unsigned char status;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
 		return snprintf(buf, 32, "physical device - not checking\n");
@@ -1199,7 +1198,7 @@ static ssize_t consistency_check_show(struct device *dev,
 	if (!ldev_info)
 		return -ENXIO;
 	ldev_num = ldev_info->ldev_num;
-	status = myrs_get_ldev_info(cs, ldev_num, ldev_info);
+	myrs_get_ldev_info(cs, ldev_num, ldev_info);
 	if (ldev_info->cc_active)
 		return snprintf(buf, 32, "checking block %zu of %zu\n",
 				(size_t)ldev_info->cc_lba,
@@ -1981,14 +1980,13 @@ myrs_get_resync(struct device *dev)
 	struct myrs_hba *cs = shost_priv(sdev->host);
 	struct myrs_ldev_info *ldev_info = sdev->hostdata;
 	u64 percent_complete = 0;
-	u8 status;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present || !ldev_info)
 		return;
 	if (ldev_info->rbld_active) {
 		unsigned short ldev_num = ldev_info->ldev_num;
 
-		status = myrs_get_ldev_info(cs, ldev_num, ldev_info);
+		myrs_get_ldev_info(cs, ldev_num, ldev_info);
 		percent_complete = ldev_info->rbld_lba * 100;
 		do_div(percent_complete, ldev_info->cfg_devsize);
 	}
-- 
2.27.0

