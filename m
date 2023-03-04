Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940DDC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:32:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCDAcI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCDAcE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:32:04 -0500
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6687B6A1C5
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:31:57 -0800 (PST)
Received: by mail-pj1-f45.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so7923761pjh.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:31:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677889917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlyhrjS/HEDGCdAm7rlCI5/1sqj4pYqwf5Yq1hTnrno=;
        b=jxXuBocjs/BZUxfIDdeMR/J8qhm1QKOINsEAKmKfAqEzbkAzV2so5m5gYx07QABy4+
         +zguFqPoekPxsZivyGoneia3Qy2gep7lVIm4sf2NPP4LNim6ZXKivWQEaWPCMWK3Dxp1
         qIa+1EN/l9misydIXRLlN5pu25Dn5E7F9vmBAO/lkWceoiHtOqppvwpg7DgvhOrKdvWJ
         Y7/kJ0axlFhm4D0oFjiaCy+ycgNMbxYpVMMo9N5O/lVpeE7mlYKjYrc4jIJytuJUpBtO
         n1rAE1oK7JCnKpVUMSOBsuEXuDQ8RzzldUwrNzx7VcWakl0NdqWABvjEOUYeGPzRhHnU
         Mo6w==
X-Gm-Message-State: AO0yUKWTA7nb71D0XRmcnuYyt+/jdPipHglgO0EXiMGBsoxHQXGEmTxD
        iHj8qMoiiSxqlC9hCWEejwn2NuvE6hF3UQ==
X-Google-Smtp-Source: AK7set/Qccdump87KGudlzK3jd99fj0xpA67gJwiT/UKFz9+ZD72Ytdn0zLtUquUfHasER+JfygeEw==
X-Received: by 2002:a17:902:c40d:b0:19e:61c8:e374 with SMTP id k13-20020a170902c40d00b0019e61c8e374mr4864651plk.29.1677889916806;
        Fri, 03 Mar 2023 16:31:56 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:31:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 10/81] scsi: 3w-sas: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:29:52 -0800
Message-Id: <20230304003103.2572793-11-bvanassche@acm.org>
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
 drivers/scsi/3w-sas.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index f41c93454f0c..55989eaa2d9f 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1530,8 +1530,7 @@ static int twl_slave_configure(struct scsi_device *sdev)
 	return 0;
 } /* End twl_slave_configure() */
 
-/* scsi_host_template initializer */
-static struct scsi_host_template driver_template = {
+static const struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3w-sas",
 	.queuecommand		= twl_scsi_queue,
