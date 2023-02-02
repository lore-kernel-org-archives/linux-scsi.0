Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4260C05027
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 22:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbjBBWCO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbjBBWCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 17:02:04 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0DB611CB
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 14:01:47 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so3140154pjb.5
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 14:01:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cCsV+jzP+JpaM0BBwBo6UedbfdU5AJgR3rGPkgCzMEo=;
        b=g97qzu0XiYLgbKy2GxtdcPPZU7jWZLFxfNxAdPJP6xjUMpxmdT813J+zkFOa82BCMT
         prgf/9nrnwJNem3e3t6BO6x2IbnL5rs7I9cdKLkGIGLPRKa7RBr8Rov0uPSiFkENIv81
         3klWUOyaSPlt4W0oahMJ4Phqq7cwjm6ipRLGus3wnBT032yg+ECw3OtJ92Rn0QqzT5Zo
         7ZHwEVu3LAZpfLjrETT04ZhPmMLjpFUPdweh9IjX7TWNgq/ufdK4jvZEyM3Dwok2t4I4
         OwguW41h2tmyDpSj3najvPUc+HjGBDA8+cCjukAoTr3I1Nia+ytNf9QJgXk4WHAH8l4L
         Maqg==
X-Gm-Message-State: AO0yUKVDjhHteMHFUBevOSyCuquulQT9IlmRR3cT8SMS+kfBhCVpi0AS
        PerlSAaQejMAZS8bkLqdOTE=
X-Google-Smtp-Source: AK7set81XjZcBxVfU4HH7l4kTSHLWOqRA+3mVvLG+u/ysSs67AhANhHF9sxO3TKAI465k+ktN39e0Q==
X-Received: by 2002:a05:6a20:4b21:b0:bf:2a24:ba02 with SMTP id fp33-20020a056a204b2100b000bf2a24ba02mr2510063pzb.33.1675375250361;
        Thu, 02 Feb 2023 14:00:50 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id t8-20020a63b708000000b004f1e87530cesm232951pgf.91.2023.02.02.14.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 14:00:49 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 1/2] scsi: core: Introduce the BLIST_BROKEN_FUA flag
Date:   Thu,  2 Feb 2023 14:00:40 -0800
Message-Id: <20230202220041.560919-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
In-Reply-To: <20230202220041.560919-1-bvanassche@acm.org>
References: <20230202220041.560919-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UFS devices perform better when using SYNCHRONIZE CACHE command instead of
the FUA flag. Introduce the BLIST_BROKEN_FUA flag for using SYNCHRONIZE
CACHE instead of FUA.

The BLIST_BROKEN_FUA flag can be set by using one of the following
approaches:
* From user space, by writing into /proc/scsi/device_info.
* From the kernel, by setting sdev_bflags from the slave_alloc callback.

For a prior version of this patch, see also
https://lore.kernel.org/lkml/YpecaXfIxZBHIcfj@google.com/T/

Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Asutosh Das <quic_asutoshd@quicinc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c    | 3 +++
 include/scsi/scsi_devinfo.h | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a62925355c2c..c1eb6bfe7ed2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1020,6 +1020,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_NO_RSOC)
 		sdev->no_report_opcodes = 1;
 
+	if (*bflags & BLIST_BROKEN_FUA)
+		sdev->broken_fua = 1;
+
 	/* set the device running here so that slave configure
 	 * may do I/O */
 	mutex_lock(&sdev->state_mutex);
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 5d14adae21c7..783451dfa46e 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -68,8 +68,10 @@
 #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
 /* Always retry ABORTED_COMMAND with ASC 0xc1 */
 #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
+/* Use SYNCHRONIZE CACHE instead of FUA */
+#define BLIST_BROKEN_FUA	((__force blist_flags_t)(1ULL << 34))
 
-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
+#define __BLIST_LAST_USED BLIST_BROKEN_FUA
 
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
