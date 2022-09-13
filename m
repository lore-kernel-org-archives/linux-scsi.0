Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA6DECAAD8
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 19:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiIMT5e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Sep 2022 15:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiIMT5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2022 15:57:32 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B9172EF1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:57:31 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id u132so12753003pfc.6
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:57:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ylKZD8iGuK1Qfl5i65YCidupdDov7GWxNJ2GDKD/xGY=;
        b=eYhY0Ds648Jz5DJ/dQI+e5OvEznloAKQoRrPjRwDgcMFQc4jmem8BO9t1OZgaCSyXS
         3OmHudn2/m8DAhuN5d+32dqV8/3v1RgcsqSUGaDrxrQNLjPjsMk1nP/TQ+ksIfW9ifo+
         LsQzKtASYdcaFW41oNDZfGaLjNTRN47FlcpIPPNEjhHdErM8e9H8qh5A/HFacUgXYB7M
         p8WjKo6Ty0kn/JbfVaASONuGDIBtMG1VE7EyXPkJCcAFCfQ6mkhTeY8504LPr1TR5d04
         u9EgZM+kXadCS7pSqw79M0aQEri4nAKUtrUTaMNjQ5jAen8HqDYLmT1HxWZ/aq8mpvZi
         ZIZg==
X-Gm-Message-State: ACgBeo2YmuM16hx0ndksmxdrESGeXTPhVO8r/VDvDm1mAlLeVT87ryWF
        76/AIGpbQYba4npKICtJS6M=
X-Google-Smtp-Source: AA6agR6OpHZdcBm8UJz1BAIjwDb+PCKC1HvYCIBuNsZNTMusT3zSsIlOfSNUKEr9OHwxZnaPoh66kA==
X-Received: by 2002:a63:2c0b:0:b0:434:ebb6:7594 with SMTP id s11-20020a632c0b000000b00434ebb67594mr27184514pgs.245.1663099049792;
        Tue, 13 Sep 2022 12:57:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:515b:d33a:21be:45a])
        by smtp.gmail.com with ESMTPSA id p15-20020a1709027ecf00b0017825ab5320sm6739987plb.251.2022.09.13.12.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 12:57:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 4/4] scsi: core: Rework the code for dropping the LLD module reference
Date:   Tue, 13 Sep 2022 12:57:16 -0700
Message-Id: <20220913195716.3966875-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220913195716.3966875-1-bvanassche@acm.org>
References: <20220913195716.3966875-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of clearing the host template module pointer if the LLD kernel
module is being unloaded, set the 'drop_module_ref' SCSI device member.
This patch prepares for constifying the SCSI host template.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_sysfs.c  | 7 +++----
 include/scsi/scsi_device.h | 1 +
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5d61f58399dc..822ae60a64b9 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -454,7 +454,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
-	mod = sdev->host->hostt->module;
+	mod = sdev->drop_module_ref ? sdev->host->hostt->module : NULL;
 
 	scsi_dh_release_device(sdev);
 
@@ -525,9 +525,8 @@ static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
 
-	/* Set module pointer as NULL in case of module unloading */
-	if (!try_module_get(sdp->host->hostt->module))
-		sdp->host->hostt->module = NULL;
+	if (try_module_get(sdp->host->hostt->module))
+		sdp->drop_module_ref = true;
 
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2493bd65351a..b03176b69056 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -214,6 +214,7 @@ struct scsi_device {
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
 	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
+	unsigned drop_module_ref:1;
 
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
