Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB12C77B6E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 20:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjDLUlk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjDLUlg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 16:41:36 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E477955A6
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:41:34 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1a661032878so2443725ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:41:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681332094; x=1683924094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MEEcR42CCThkOQQn6/7gtQrk4W4CinNrHZLfB9vLVrE=;
        b=FkMMOY0BpH9XFbyc5ZTcsOqGzmrFPMn5feuneCtYUnU2wis4nKwMHeNzfe2c5IqgWa
         yH//PzQD2zSB/FPIq0zDrp27sDjHAyytBWYCe+1V8IbdW7qjwOBAMXkbrgw+ZdUf3aP9
         hWIycSIPkghZrf4Wg2CgWt2GhIppt2KoVxAP+zpdwjQrI+NzAWg9+t8qes7MIxLtoIlj
         90TlbneYvE9sPfsacDJZfJe3qMtw5BREjhyYjwkSlGYmBPvcieK0Ne5IsOcCclmt+Cn1
         3ZHyo8c/tTY9Sj46s9t1pVw2TzaKTZN/LlGhBkfoOWMwUiHLReU9u0A6ZVrBUrcuanAs
         GWZg==
X-Gm-Message-State: AAQBX9fLME5Yj+G1VrB2xoFKmGMW86J5PDDa10THG8sinxa1D6o2GqIZ
        w4n29JtG/dFptpgD51ZLu8I=
X-Google-Smtp-Source: AKy350bbHOrtYsxrXlzvaamQc8cwbQepwdqBlH4kx+8vAbo11slEdh8W8hHKTlP5T2WlseCiyVjAGQ==
X-Received: by 2002:a05:6a00:188c:b0:63a:ea04:4966 with SMTP id x12-20020a056a00188c00b0063aea044966mr238205pfh.8.1681332094272;
        Wed, 12 Apr 2023 13:41:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d89d:35dd:5938:1993])
        by smtp.gmail.com with ESMTPSA id l19-20020a62be13000000b006249928aba2sm12123364pff.59.2023.04.12.13.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 13:41:33 -0700 (PDT)
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
Subject: [PATCH 1/3] scsi: sd: Let sd_shutdown() fail future I/O
Date:   Wed, 12 Apr 2023 13:41:23 -0700
Message-Id: <20230412204125.3222615-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
In-Reply-To: <20230412204125.3222615-1-bvanassche@acm.org>
References: <20230412204125.3222615-1-bvanassche@acm.org>
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
device_shutdown(). device_shutdown() calls sd_shutdown().

After sd_shutdown() has been called the .shutdown() callback of the LLD
will be called. This makes it unsafe to submit I/O after sd_shutdown()
has finished. Let sd_shutdown() fail future I/O such that LLD .shutdown()
callbacks can be simplified.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4bb87043e6db..629f5889caf2 100644
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
@@ -3715,6 +3716,12 @@ static void sd_shutdown(struct device *dev)
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
+
+fail_future_io:
+	q = sdkp->disk->queue;
+	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
+	blk_mq_freeze_queue(q);
+	blk_mq_unfreeze_queue(q);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
