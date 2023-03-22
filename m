Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4D8C6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 19:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjCVT4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 15:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCVT4n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 15:56:43 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763CB5ADF4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:32 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id o2so12884226plg.4
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679514992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlyhrjS/HEDGCdAm7rlCI5/1sqj4pYqwf5Yq1hTnrno=;
        b=4WQl2rd9fqYY6rQiAsPEyK3YSTagiimP/xOa0Kmb3RErvnfFsK7c2403dOqfs+IMxZ
         aXcYnTZ/e3flALU34SQ3jdpjdi2vMCO7mC+vcucpIbcvLBUTjSofRlF2gZCCLqgxNmyU
         r0A+Sznasf9lJzcY7O6PP5f/RwEQ3CRF0TbVplovrgezZYx+qHgtRRiiu+ZFU3ue23dT
         4nwF3xH9sUbCWHbDcOHJCoon/JGuy0KKmqPDFw+R6Qf0PR0Rot+MZO6l214dffzy8giI
         gtXwFjXrMlgsegjgQkFUVWjXTyy6zLW6+/Qjamr8hJ7FghCQzDGyHkPUnQtQ2wuDaO0q
         uSGQ==
X-Gm-Message-State: AO0yUKX8VhNY8tPhp48Zr/fIZmJDxToGtLkhta+Id/NvKHZrwe5xncdc
        iWVMcDCJcHl7M06bjlggvkVzPIEAgHI=
X-Google-Smtp-Source: AK7set8jShp4aZ69rpZlLyVg4jeW4inWmOlLsL8c/lzGbN/YDCYUnCXyA1s7jb8w7/tm2TsHkFMJhQ==
X-Received: by 2002:a17:90b:4c04:b0:23f:5ab0:68a2 with SMTP id na4-20020a17090b4c0400b0023f5ab068a2mr4764936pjb.40.1679514991884;
        Wed, 22 Mar 2023 12:56:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:56:31 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 10/80] scsi: 3w-sas: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:54:05 -0700
Message-Id: <20230322195515.1267197-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
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
