Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A85C77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 23:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjDQXHH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 19:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDQXHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 19:07:05 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D77F1BDB
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:04 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1a677dffb37so11293815ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681772824; x=1684364824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQnC9C9a7QaVe82r8VvNHn+NI4rrvtzRM18208eTsdM=;
        b=Ooa+wyF7ajeZfmg4p3VpJc5HHsQOoFbZWH48rGtm1hBEByj0O7V8pD299TiU31ow+0
         xgh0WOvm+IdRXENMef2g8x55K3+SC+yClTR8xepBN1xrK68xkwhuQWM+vbvSwN7ngAn3
         zxVMDRtdxnKeMX+5M85GBKZowrhyHIAH3xjaffoisjAn1TfKfXpmq5bC2y67SF10NMIi
         9RjbOCKF2tsg8LnwQzx0vrG+RYye3aqI3gU7ub7olasDxyZLPJI1k1F/Yn9uOE0mIMl8
         y49Yq8s5LNvsvCFbRyDxhgPoGOGy7+orzrxOyt8lYl5dbPrJvoevYrv7soy1V7bgJ93J
         H2+Q==
X-Gm-Message-State: AAQBX9cc64hU2XP4FgeYKuowCCrXrJN7kwWGCHEWtr9KYthU15aNiYtf
        KDPEa06pyaCYPDCPA1T2gZ4=
X-Google-Smtp-Source: AKy350YTqbMuVEL4oc8R5dzQFwXdysFHN870uitwcZXWnuDWGyZ79DRBAuoEZFKUB+7BkeAUPsUKCQ==
X-Received: by 2002:a17:902:ec88:b0:1a6:ef75:3c53 with SMTP id x8-20020a170902ec8800b001a6ef753c53mr194077plg.11.1681772824051;
        Mon, 17 Apr 2023 16:07:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2cdd:e77:b589:1518])
        by smtp.gmail.com with ESMTPSA id t4-20020a17090ad14400b002478d21de2bsm2539576pjw.36.2023.04.17.16.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 16:07:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 1/4] scsi: sd: Let sd_shutdown() fail future I/O
Date:   Mon, 17 Apr 2023 16:06:53 -0700
Message-ID: <20230417230656.523826-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230417230656.523826-1-bvanassche@acm.org>
References: <20230417230656.523826-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

System shutdown happens as follows (see e.g. the systemd source file
src/shutdown/shutdown.c):
* sync() is called.
* reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
* If the reboot() system call returns, log an error message.

The reboot() system call causes the kernel to call kernel_restart(),
kernel_halt() or kernel_power_off(). Each of these functions calls
device_shutdown(). device_shutdown() calls sd_shutdown(). After
sd_shutdown() has been called the .shutdown() callback of the LLD
will be called. Hence, I/O submitted after sd_shutdown() will hang or
may even cause a kernel crash.

Let sd_shutdown() fail future I/O such that LLD .shutdown() callbacks
can be simplified.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4bb87043e6db..4017b5412ba4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3699,12 +3699,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct request_queue *q;
 
 	if (!sdkp)
 		return;         /* this can happen */
 
 	if (pm_runtime_suspended(dev))
-		return;
+		goto fail_future_io;
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
@@ -3715,6 +3716,14 @@ static void sd_shutdown(struct device *dev)
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
+
+fail_future_io:
+	q = sdkp->disk->queue;
+	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
+	if (!scsi_host_busy(sdkp->device->host))
+		return;
+	blk_mq_freeze_queue(q);
+	blk_mq_unfreeze_queue(q);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
