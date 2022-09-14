Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 845EDC6FA82
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 22:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiINW5I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiINW5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 18:57:01 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A69832E6
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:57:00 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id b21so16578326plz.7
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:57:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vUM2HolRGWQC4/RRb/dHgvk9K9vdj30UGyVRRJl+YPo=;
        b=wjHQIj02cDKMDyZKLub1WR6VQ+b3M3cofkUODcaukw03nc/7Ar2CVn+feLnvsf3g25
         W+lhSmhlkZSsxB0NykSeNlli3E3xrkVsD9RF88QoIIF61u9FkIACMfIueQwRwU4W4t0T
         teF1JUWeWHUI93Wrq+onKIGKqlMV8XharWHLttpZDQ8GdPwRb6ZCWa7O4leK71UZskc6
         qOsQ6n74vGJxk2cDvhWx2zckZdX1nHRhBG9HTnirUMT3R1Uw9Ctl6zWv90GsBVazeyUw
         J5Rb+LR3XR5gTLpjoBVL+Tzi/pXaQwVKbNy1d92BBcp5XlS8ykO+1qMp9ECOZ1nTyG8c
         Nh/w==
X-Gm-Message-State: ACrzQf2DRI3mEyJLwE4bgKDJBkuLnFbBVHcyM9g50T2Ptpzd1l+HCDOh
        tiIows3N+OX2KDrwdx2OGdP5Cdk6aGY=
X-Google-Smtp-Source: AMsMyM7x6fZkDQi7WnRLkODg9HiXyItdWEXdojYBIU4rYArM6WNJcI/+7hwJYwcupS6RDJowTR343A==
X-Received: by 2002:a17:90b:4a4f:b0:202:5bbb:b76f with SMTP id lb15-20020a17090b4a4f00b002025bbbb76fmr7412193pjb.230.1663196220236;
        Wed, 14 Sep 2022 15:57:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9147:e0c1:9227:cf53])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902d70900b0016d1b70872asm2606926ply.134.2022.09.14.15.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 15:56:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 7/7] scsi: core: Improve SCSI device removal
Date:   Wed, 14 Sep 2022 15:56:21 -0700
Message-Id: <20220914225621.415631-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220914225621.415631-1-bvanassche@acm.org>
References: <20220914225621.415631-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of clearing the host template module pointer if the LLD kernel
module is being unloaded, call __module_get() unconditionally. This
patch is a bug fix because it prevents that a SCSI LLD is unloaded after
scsi_device_dev_release() returns and before
scsi_device_dev_release_usercontext() is called.

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_sysfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a3aaafdeac1d..661c2bdd4588 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -523,9 +523,7 @@ static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
 
-	/* Set module pointer as NULL in case of module unloading */
-	if (!try_module_get(sdp->host->hostt->module))
-		sdp->host->hostt->module = NULL;
+	__module_get(sdp->host->hostt->module);
 
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
