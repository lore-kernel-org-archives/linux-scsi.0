Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05833C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 09:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E17CA60E76
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 09:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhINJXt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 05:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhINJXs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 05:23:48 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB5FC061574
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 02:22:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w29so18285431wra.8
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 02:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cB3SFW2TbyjnhTTrE3Gw+3s8XVu1+IHGM7eNQeJ4Ffo=;
        b=yObLhpnSD42+GQIkt8UzLMbYH0wUIX/Qsa0sHlxnsX2a6lCRi2T3pjnP6ylSEK0yJ3
         9HEeafmyGngxXsz0OE/+/lfSL1TAvR9Oy7nTZ2VS7wnHbM3FqlnZgMAmqYrHuwa5AF6D
         gJ61PXj6JyqwEwgN3FHa2HW7n191IRrUNf8kgPM4zPuJCrpgtPVjML9EEzrM+Z1BFJBS
         mvCJ6xIRFSlxuMWvg1LBuZJFpxOvmRxU/ESOtoMEwq17wYPRI1P8EHlh09PNk02lb6ce
         D7wffZg7MrNeTUMMQQhpBzIyYZtIQzEW+fnuXJugHWvdZkX9yUA1Gn2Empvto1i9z80G
         f4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cB3SFW2TbyjnhTTrE3Gw+3s8XVu1+IHGM7eNQeJ4Ffo=;
        b=GJEn/kNeKvcO2jY89F5c9DpKogCKXBpAkIz5rVm2XirVSZMw8DA/eZxNbHApUUKb1F
         UDtn72+WzPfQn1uR++uvQYpUZle5HBxu9eZDj6jzoTJ/VnvpgOvR/EN8ga8L5LpYsizZ
         LL4ed2HwW/Vy1WPalvHRqP7vYdQIv26c2IyTYnZszp6TmvlR/m7yu9B1wRG79KgosBwX
         FtD2+j8rbZfQ6TzYdPuzMjEBQC1IgpEmyJNqJO9zz7pVietf9JPAhUUcAxP5SGMVO/LZ
         v5m5e/wsbr18WmHxUkxjmpMEhlhDJorZh7LUHhxiSeYw67uuRrYB24KAIFJ6pzSnjwjy
         9wIQ==
X-Gm-Message-State: AOAM530XVofueG/AUfufsJQsFodYKHysmWAep/YpmwV2iEG9/ZnviKoV
        a26D3EQY6EWSqNoPxAepNJCkPQ==
X-Google-Smtp-Source: ABdhPJwMPDMLf28adKZS5XckUAYfGJVT648BX9tymcGeqKckdlNi0lD28woO+vX6eLWMHhiiSvDVZQ==
X-Received: by 2002:adf:8b43:: with SMTP id v3mr18138405wra.248.1631611349959;
        Tue, 14 Sep 2021 02:22:29 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id p4sm544765wmg.16.2021.09.14.02.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 02:22:29 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     draviv@codeaurora.org, sthumma@codeaurora.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bjorn.andersson@linaro.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH] scsi: ufs: ufshcd-pltfrm: fix memory leak due to probe defer
Date:   Tue, 14 Sep 2021 10:22:14 +0100
Message-Id: <20210914092214.6468-1-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS drivers that probe defer will endup leaking memory allocated for
clk and regulator names via kstrdup because the structure that is
holding this memory is allocated via devm_* variants which will be
freed during probe defer but the names are never freed.

Use same devm_* variant of kstrdup to free the memory allocated to
name when driver probe defers.

Kmemleak found around 11 leaks on Qualcomm Dragon Board RB5:

unreferenced object 0xffff66f243fb2c00 (size 128):
  comm "kworker/u16:0", pid 7, jiffies 4294893319 (age 94.848s)
  hex dump (first 32 bytes):
    63 6f 72 65 5f 63 6c 6b 00 76 69 72 74 75 61 6c  core_clk.virtual
    2f 77 6f 72 6b 71 75 65 75 65 2f 73 63 73 69 5f  /workqueue/scsi_
  backtrace:
    [<000000006f788cd1>] slab_post_alloc_hook+0x88/0x410
    [<00000000cfd1372b>] __kmalloc_track_caller+0x138/0x230
    [<00000000a92ab17b>] kstrdup+0xb0/0x110
    [<0000000037263ab6>] ufshcd_pltfrm_init+0x1a8/0x500
    [<00000000a20a5caa>] ufs_qcom_probe+0x20/0x58
    [<00000000a5e43067>] platform_probe+0x6c/0x118
    [<00000000ef686e3f>] really_probe+0xc4/0x330
    [<000000005b18792c>] __driver_probe_device+0x88/0x118
    [<00000000a5d295e8>] driver_probe_device+0x44/0x158
    [<000000007e83f58d>] __device_attach_driver+0xb4/0x128
    [<000000004bfa4470>] bus_for_each_drv+0x68/0xd0
    [<00000000b89a83bc>] __device_attach+0xec/0x170
    [<00000000ada2beea>] device_initial_probe+0x14/0x20
    [<0000000079921612>] bus_probe_device+0x9c/0xa8
    [<00000000d268bf7c>] deferred_probe_work_func+0x90/0xd0
    [<000000009ef64bfa>] process_one_work+0x29c/0x788
unreferenced object 0xffff66f243fb2c80 (size 128):
  comm "kworker/u16:0", pid 7, jiffies 4294893319 (age 94.848s)
  hex dump (first 32 bytes):
    62 75 73 5f 61 67 67 72 5f 63 6c 6b 00 00 00 00  bus_aggr_clk....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

with this patch no memory leaks are reported.
Fixes: aa4976130934 ("ufs: Add regulator enable support")
Fixes: c6e79dacd86f ("ufs: Add clock initialization support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8859c13f4e09..eaeae83b999f 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -91,7 +91,7 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 
 		clki->min_freq = clkfreq[i];
 		clki->max_freq = clkfreq[i+1];
-		clki->name = kstrdup(name, GFP_KERNEL);
+		clki->name = devm_kstrdup(dev, name, GFP_KERNEL);
 		if (!strcmp(name, "ref_clk"))
 			clki->keep_link_active = true;
 		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
@@ -126,7 +126,7 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	if (!vreg)
 		return -ENOMEM;
 
-	vreg->name = kstrdup(name, GFP_KERNEL);
+	vreg->name = devm_kstrdup(dev, name, GFP_KERNEL);
 
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	if (of_property_read_u32(np, prop_name, &vreg->max_uA)) {
-- 
2.21.0

