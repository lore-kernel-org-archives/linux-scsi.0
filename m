Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 005FAC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D15BE20814
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 16:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HoIxLHf8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgE2QlV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 12:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgE2QlU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 12:41:20 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D99FC03E969;
        Fri, 29 May 2020 09:41:20 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x6so4341979wrm.13;
        Fri, 29 May 2020 09:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ToxnDwTC+zLUDCpLe2beVSUXwkocz2pi9wyRrspW0/8=;
        b=HoIxLHf8O/A/gsDWC0yRHWJkfeXO7e3wAh6JFzOM0mLP3PeIEF0juZRcMh77tgI+Gw
         +NR4CKYfTOlUOW3xGka7NZ2DaZPlQTsISWdOvcqu1qxQhSqywRf4jUbyeecrByVKvK61
         SdcfJmJF4QGrWsyH+gMYNBo3E1wv5ezS3gylavLvohyLrNr++vja6l5bOOUt/2sQY8VV
         0yguOxnG5FKON04rglh8odqc76DKiBJlKCbINDZBHQ6dHcsJUVRxz8y/gOdgwUjew7yA
         O/YxP/rDm7QmIZtnQ3IsfCZXWF86gsP9CQwy4CPLGKXAEQccS2ohktqJWFsGyUNFnZE2
         6Ziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ToxnDwTC+zLUDCpLe2beVSUXwkocz2pi9wyRrspW0/8=;
        b=Oz5w2b07ryjZGb4mxX08sSl3EVol77d/7ZCVGlHjMCcSRXrOzNs3UEOrsPzGFTKrU6
         M3fgOAwAYO946jHUrWYcSzyHi8u1t3G9JiDO89hGKi28qiLTRN9+XNL04gVgsxGn68lf
         QyXozmxjn7MEf451+jFJC10pym3eXno6qS2El5bSDFx3F+dCZq0hVITiZLo1Fwh4QEr/
         xQpnBNHa7VYlcVqlUcVd3MzynZ38oifNJAc28DFZxH7S4HBEd2vXLHaCf2FX68vV0qOt
         d7Qt8LjYeGvdh6ly1LjCDQN3/0isdcXQqwMwAvB8ZJu/2R6KkIbgXItFWw90EVfrvPat
         fSTg==
X-Gm-Message-State: AOAM5305xo9ayQdX0HeOxZ/VGYD45iTjZGOOkAX6Oz2uS2Un9tuP/jhB
        ThuO1sapq1QTiWZNuQ/zQoM=
X-Google-Smtp-Source: ABdhPJznNCRcCL8HaTUB0QPQV3vTRZB8EEeOG6FjEYgYWLxOTgppWSsAKKdu2h9d4fOfPrUhRF9ytw==
X-Received: by 2002:adf:f446:: with SMTP id f6mr9449779wrp.59.1590770479254;
        Fri, 29 May 2020 09:41:19 -0700 (PDT)
Received: from ubuntu-laptop.micron.com ([165.225.203.62])
        by smtp.gmail.com with ESMTPSA id z25sm17344wmf.10.2020.05.29.09.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 09:41:18 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/4] scsi: ufs: remove max_t in ufs_get_device_desc
Date:   Fri, 29 May 2020 18:40:51 +0200
Message-Id: <20200529164054.27552-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200529164054.27552-1-huobean@gmail.com>
References: <20200529164054.27552-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

For the UFS device, the maximum descriptor size is 255, max_t called
in ufs_get_device_desc() is useless.

Signed-off-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index aca50ed39844..f57acfbf9d60 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6876,14 +6876,11 @@ static void ufs_fixup_device_setup(struct ufs_hba *hba)
 static int ufs_get_device_desc(struct ufs_hba *hba)
 {
 	int err;
-	size_t buff_len;
 	u8 model_index;
 	u8 *desc_buf;
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 
-	buff_len = max_t(size_t, hba->desc_size.dev_desc,
-			 QUERY_DESC_MAX_SIZE + 1);
-	desc_buf = kmalloc(buff_len, GFP_KERNEL);
+	desc_buf = kmalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
 	if (!desc_buf) {
 		err = -ENOMEM;
 		goto out;
-- 
2.17.1

