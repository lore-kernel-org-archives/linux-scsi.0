Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0806DC6FA82
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 23:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiIHXhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 19:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiIHXh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 19:37:27 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9849440BC6
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 16:36:14 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id n65-20020a17090a5ac700b001fbb4fad865so4055714pji.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 16:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ylKZD8iGuK1Qfl5i65YCidupdDov7GWxNJ2GDKD/xGY=;
        b=RRAASI+icmuxeK0CiHtyRSe4SKIWyKRRr6YYZTydmV83zCm/MDakpy7H4xWD/8+iDZ
         Tc8bfV6bFiemEFbehYsmD3j7p4rmtpH0pMxa3DYC1+FR6LyHUNEgAaaZVn3T4mxny6TG
         gpUeEAk5ZwM5LcwZt7u5lsw2i5caT/o9h5yLNRzuCFUy3enMYrYL7RV+6SEyij0agW8J
         ufZ04WmE5vRNUXwaM5LDnHeJ6Lu0IsMnTUcBlyceqLMhNIMjdp2VAoK+T7pcvOf6voK0
         DKTH2TVGnFDyBz3+7M+VmetGeeXk9T8i4i1w8/F3XSsNUncd0roIeuKCVq5NrvOl3dRw
         0Ahg==
X-Gm-Message-State: ACgBeo2T1455ld4gJ5c4AkMVGAjlbbDMseNCoyqGWUllhQd7L1K2BtZt
        4b21sB0HMNZ+5LA47txj+qE=
X-Google-Smtp-Source: AA6agR4E2VnFvdDUwdubYhuoZK+rkrutOEGSbTcll4VCDo9vBydd03xvtKTGqq/yXDqKbOvBnEx/+A==
X-Received: by 2002:a17:903:2410:b0:171:4bbc:2526 with SMTP id e16-20020a170903241000b001714bbc2526mr11176738plo.62.1662680173322;
        Thu, 08 Sep 2022 16:36:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c18a:7410:112c:aa7c])
        by smtp.gmail.com with ESMTPSA id w16-20020a170902e89000b0016c574aa0fdsm84259plg.76.2022.09.08.16.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 16:36:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 3/3] scsi: core: Rework the code for dropping the LLD module reference
Date:   Thu,  8 Sep 2022 16:36:00 -0700
Message-Id: <20220908233600.3043271-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220908233600.3043271-1-bvanassche@acm.org>
References: <20220908233600.3043271-1-bvanassche@acm.org>
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
