Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141A6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 10:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E67EC6112D
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 10:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhKJKy2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 05:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhKJKy1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 05:54:27 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C70AC061764;
        Wed, 10 Nov 2021 02:51:40 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x131so2283641pfc.12;
        Wed, 10 Nov 2021 02:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+dzXYDr4i+8E1rpU2w4lIdJbKk6ZeJdjzAy1gZDTXjo=;
        b=iIwVK3BZa4OjsgzCh7y2ME1f8c/dppxSc8gobbBP1kvkAH5lbWH+RSLXi2YSdI21lG
         qoRpQi4ZYgq0NYJYChWMWE3GuiC0ehi9DMlgySL6OFRL8igyEglWGENgGjo8yB7rBwhw
         BiUXeBRl9qMrKdBd+5PIzoX+/BYlj+icjlFlXzKxtjdNnNkpTAuPLXJNAncKtru5Ut+X
         PGMLr6p6787Ess7MUvPxOOuaC0UQaJqB1GRrf8mhfzo40hzjIQSlGw233zzgrq1Vw9J8
         sxNI+wPF9TE3GbYQPYA9HTWAS+czqNf23+LrZ0oX5oMts+MKD0z7eFXWh1EvmnRl6XhX
         Wuvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+dzXYDr4i+8E1rpU2w4lIdJbKk6ZeJdjzAy1gZDTXjo=;
        b=y/BO2PmL5qEiHkDYo1Q46IuDxsrcL5FHG2bghgwlqg/+Yfppbu5nBvu5G5y2EPqKve
         1oNikz/qYBWijZMQahry+ifwjDPfkfF94XCuBPwGiJM9KhwL5ttq+jZ3ke8vzWsT0yEm
         gKc6+SyTHZyzo403yRq8EgAtcw+zVS1wIh7iGkKIo6Syh14Yko4c6wK7spV8Ft2Sc6Xr
         IXdU61L9wBO6lf56PESDviS7v7w7Vv6yxSVtR42tfxrBZtEIi+UYHB2NziFh8Une+CaT
         EJeL2vw2KSBbv7hka97xnuV7KUYSHe6NYfSazTWMdi5TuaxFKjAubncHTMOGn4AlsTJj
         M1Lg==
X-Gm-Message-State: AOAM532rvqPVXktP3p4ZtG0FFC9M9YprxNqSaQF78iJL4b2ktE7fBaYR
        wqstT9G9JLjkviuBqZSMQmU=
X-Google-Smtp-Source: ABdhPJwMPdRMzl4AmzcgyZZhbVTwDWb6Obrc6Y5hq7A8Y0uO83r6bdhuU6WCgPatiKQw7X4Roev4wA==
X-Received: by 2002:a05:6a00:1903:b0:47c:34c1:c6b6 with SMTP id y3-20020a056a00190300b0047c34c1c6b6mr14883980pfi.17.1636541499684;
        Wed, 10 Nov 2021 02:51:39 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h4sm5516552pjm.14.2021.11.10.02.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 02:51:39 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.guojin@zte.com.cn
To:     stanley.chu@mediatek.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ye Guojin <ye.guojin@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: ufs: ufs-mediatek: add put_device() after of_find_device_by_node()
Date:   Wed, 10 Nov 2021 10:51:33 +0000
Message-Id: <20211110105133.150171-1-ye.guojin@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ye Guojin <ye.guojin@zte.com.cn>

This was found by coccicheck:
./drivers/scsi/ufs/ufs-mediatek.c, 211, 1-7, ERROR missing put_device;
call of_find_device_by_node on line 1185, but without a corresponding
object release within this function.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Ye Guojin <ye.guojin@zte.com.cn>
---
 drivers/scsi/ufs/ufs-mediatek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index fc5b214347b3..5393b5c9dd9c 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -1189,6 +1189,7 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 	}
 	link = device_link_add(dev, &reset_pdev->dev,
 		DL_FLAG_AUTOPROBE_CONSUMER);
+	put_device(&reset_pdev->dev);
 	if (!link) {
 		dev_notice(dev, "add reset device_link fail\n");
 		goto skip_reset;
-- 
2.25.1

