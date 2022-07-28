Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC352C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 22:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiG1WTa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 18:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiG1WTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 18:19:12 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737887969C
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:08 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id d65-20020a17090a6f4700b001f303a97b14so3547203pjk.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PK7GhXluDeO7vB7OgT+f4kVleUWpGV4FgrTIBb4orbk=;
        b=M8EiWhNvRjoSy50/4sZtukSWyjnldfsIl1Pm9foTdFyAyiivI9Syr3Z2yTzmiSxOCj
         C13cO7ALWMbaykzkNDI0drE5VFde0L4PSSLlW0fFqcHhOn+8d/YCOD4hlJyy6yDqSwxC
         dQWD8APH6c9KZxv+EEQfpCYjWmV5TO6XCFgSuWmLHV5sVgGKkN/R+IP2ZF4c8FLotmh/
         teDzDSvjq6sB6dsUhzoJmasyiASyM0BLWS1DpB6l23aTeITKvDYSYrFiAK7yfQ6Rvgmx
         ti4k+NWC84JOWQt1GrMMzdLeN5PI+usLt/S9Q8+ZY6icFBF2+J3KqpF69NWjLNVbJXMP
         IIlg==
X-Gm-Message-State: ACgBeo2M6rCEurZC/+DZZgN17LkESBkJdwDxEUL7tsBnVmVArXuFrwgx
        i+x6KAbaqQEhKqvQqUvQmPo=
X-Google-Smtp-Source: AA6agR58mpL41mCLsbAQnLzAhqaKW+kMOnUE0nd2Rrnf9jCoTK+YrEv14D2+ezHdmMtCd9/4X6or9A==
X-Received: by 2002:a17:902:8f92:b0:16c:e485:7cd2 with SMTP id z18-20020a1709028f9200b0016ce4857cd2mr930299plo.50.1659046747894;
        Thu, 28 Jul 2022 15:19:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9520:2952:8318:8e3e])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902c40b00b0016dc8932725sm1556709plk.285.2022.07.28.15.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:19:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 3/4] scsi: core: Simplify LLD module reference counting
Date:   Thu, 28 Jul 2022 15:18:50 -0700
Message-Id: <20220728221851.1822295-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
In-Reply-To: <20220728221851.1822295-1-bvanassche@acm.org>
References: <20220728221851.1822295-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

Swap two statements in scsi_device_put() now that it is guaranteed that
SCSI hosts outlive SCSI devices. Remove the reference counting code from
scsi_sysfs.c that became superfluous because SCSI hosts now outlive SCSI
devices.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
[ bvanassche: Extracted this patch from a larger patch ]
---
 drivers/scsi/scsi.c       | 9 ++++++---
 drivers/scsi/scsi_sysfs.c | 9 ---------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..086ec5b5862d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -586,10 +586,13 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	struct module *mod = sdev->host->hostt->module;
-
+	/*
+	 * Decreasing the module reference count before the device reference
+	 * count is safe since scsi_remove_host() only returns after all
+	 * devices have been removed.
+	 */
+	module_put(sdev->host->hostt->module);
 	put_device(&sdev->sdev_gendev);
-	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1bc9c26fe1d4..213ebc88f76a 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -452,9 +452,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
 	struct scsi_vpd *vpd_pgb0 = NULL, *vpd_pgb1 = NULL, *vpd_pgb2 = NULL;
 	unsigned long flags;
-	struct module *mod;
-
-	mod = sdev->host->hostt->module;
 
 	scsi_dh_release_device(sdev);
 
@@ -521,17 +518,11 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
-	module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-
-	/* Set module pointer as NULL in case of module unloading */
-	if (!try_module_get(sdp->host->hostt->module))
-		sdp->host->hostt->module = NULL;
-
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }
