Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 317A1C28E88
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B36B64FDA
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbhCLJsv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbhCLJsU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:20 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C433C061764
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:19 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id l19so3399945wmh.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgdjb93mQlErKIT9nxRZ2QkPnfSG57zjDQqjLAihewI=;
        b=htdxj4D+i1pw2qvU4uRp6Ix/OepCm6Qymczhgkv2cJLrN+tRfxGdlhW01XgsiTq2t6
         aakoqfM7c9lm133dBr9xTBGvZ863g7/Ex9/PM6dvT1AjxfG/hdyCzk8Uhmv8HKxDEJo/
         oCb0cvqZ/i+QlUcZPtdnUlKQapl0WIxICNpSfqZ0XR0t6RevmstZG0vuZDLVogwq2u9f
         RQbmuY08n6DyEXUtmVrZU4u5LKhSywmQwb+Z/u25ZKLl4R0ujczWxyzigzsjOZlkH3T4
         eWy+A9nTzRbeLfgNh/wGg1n0b29G+F1RimBLKwwFnDZKyewQJvYKPWrHSHVSROZ5auT7
         tmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgdjb93mQlErKIT9nxRZ2QkPnfSG57zjDQqjLAihewI=;
        b=m1Z+kWpsJlFNMbWrLtAcMOvW72p39SRhqsuta8lXH+WkswzIe+ELRe2nh8a8K3Dd25
         r7mhchU0+lP/vdpb+k2BExzRJtht/JumnwskT9H/TI+7BCitFeSJwdCKzCoyERdZn5qN
         wd/+g5oOxwzjYu9Jldv94/OYnutroS5/FzIWsqmbwX9qmWb4etQS3jOTX1sc6be3pwb/
         eEevZbGvKesRD7KgPjKc3rWwYJkkG0yuOQRCuKda7O+JvOTGjTFwdj9X0yFHTGPWPilw
         sqeF7s8WbPpv9jRqfGHgPeQVqGUc9wpPEi8wc41hLAQ+nhpO14Vi2x9qzpRCy2hYhZkg
         zVQQ==
X-Gm-Message-State: AOAM530nhfaSUbHnhe5sgQm567zENJZe2DGeUPAgIUj8uRPZXmy6HZVv
        IlJyjqgAJhRmrLicQQxaMAC5qg==
X-Google-Smtp-Source: ABdhPJxr1v3sYYoAKHmR7zf0N1dCaTQYzxbyGs1FWnrsPnQsJtaiRFFSxSOW6iKGvfU1tC/PXtmQiw==
X-Received: by 2002:a1c:5416:: with SMTP id i22mr12229086wmb.146.1615542498280;
        Fri, 12 Mar 2021 01:48:18 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:17 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 30/30] scsi: 3w-sas: Remove unused variables 'sglist' and 'tw_dev'
Date:   Fri, 12 Mar 2021 09:47:38 +0000
Message-Id: <20210312094738.2207817-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/3w-sas.c: In function ‘twl_scsiop_execute_scsi’:
 drivers/scsi/3w-sas.c:298:22: warning: variable ‘sglist’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/3w-sas.c: In function ‘twl_scsi_biosparam’:
 drivers/scsi/3w-sas.c:1411:23: warning: variable ‘tw_dev’ set but not used [-Wunused-but-set-variable]

Cc: Adam Radford <aradford@gmail.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/3w-sas.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 3db0e42e9aa75..383f6f204c24b 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -295,14 +295,11 @@ static int twl_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 	TW_Command_Apache *command_packet;
 	int i, sg_count;
 	struct scsi_cmnd *srb = NULL;
-	struct scatterlist *sglist = NULL, *sg;
+	struct scatterlist *sg;
 	int retval = 1;
 
-	if (tw_dev->srb[request_id]) {
+	if (tw_dev->srb[request_id])
 		srb = tw_dev->srb[request_id];
-		if (scsi_sglist(srb))
-			sglist = scsi_sglist(srb);
-	}
 
 	/* Initialize command packet */
 	full_command_packet = tw_dev->command_packet_virt[request_id];
@@ -1408,9 +1405,6 @@ static int twl_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_res
 static int twl_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev, sector_t capacity, int geom[])
 {
 	int heads, sectors;
-	TW_Device_Extension *tw_dev;
-
-	tw_dev = (TW_Device_Extension *)sdev->host->hostdata;
 
 	if (capacity >= 0x200000) {
 		heads = 255;
-- 
2.27.0

