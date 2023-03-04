Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A229AC61DA3
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCDAfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjCDAef (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:34:35 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732366A435
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:06 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so7926803pjh.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mt+SALTZpgtMKMj3j2WTDo1ienCuaV/TBXYIRZ/PdNk=;
        b=nf7ktUNcM7Gi+ma6ZZuNEBtzdMGPewPW8Hi0Sl/ge/RZ+Gdt8fFDO30nZIQeG18pml
         GbcmKipGM3+XXDbsrXXUzZf4KlAWMDW52kkSVSxqWAolnQQYFgHsm3cDBNbFBmO9PYWT
         TmBlEyLA0p4x6XGpm1X5TPSx1Gc/JWoCaAjJKCre1QcbsK/0uziXZrJZJEeyVjOO8F36
         Hw4dGUHTMFs2BcFll5oLX+soPza1wuR+k034IJp9nAhlW46dlOBiLVA1m9wqzaiipRGn
         KsHGRlSvmkNpGyCRMuBx1wmJsrWtJT6zVvwVszhzNmHLyU99m1eR7voGOvSywVMqaAWo
         iKMw==
X-Gm-Message-State: AO0yUKVpOck3azlAxH3YtxM1yZHz9ZY13sBg5Wp0tp5XxfnLarOzM9O0
        vBkR2RVIXvgkNgj44Q1QZYw=
X-Google-Smtp-Source: AK7set9mAlcWv1Ri25QAbQC2vHoyl9Y3CQL5w77sO9gHOWMZf/Fb6/ej0WbvJgSmB+TogtHYpuP2nw==
X-Received: by 2002:a17:902:d492:b0:19c:a866:6a76 with SMTP id c18-20020a170902d49200b0019ca8666a76mr4411119plg.42.1677890038874;
        Fri, 03 Mar 2023 16:33:58 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:33:57 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 57/81] scsi: mvumi: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:39 -0800
Message-Id: <20230304003103.2572793-58-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvumi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 60c65586f30e..73aa7059b556 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2168,7 +2168,7 @@ mvumi_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 	return 0;
 }
 
-static struct scsi_host_template mvumi_template = {
+static const struct scsi_host_template mvumi_template = {
 
 	.module = THIS_MODULE,
 	.name = "Marvell Storage Controller",
