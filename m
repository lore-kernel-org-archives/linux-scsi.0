Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 241ECC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:01:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiI2WBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiI2WBp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:01:45 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2814912A49B
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:01:43 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id u92so2564131pjh.3
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:01:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=tR5B6qNgo6J9UN3XV4mh0dDqK1zg8zmNI8bPzpp6WNo=;
        b=RMNr3LHHKIZd9kxIJdU3lV2WR4zKvfNPRLZ/B2LG1wtasR9qtia3wwbcXwd4/qFWCY
         lN7Bn4pKbRmmMTD/xaWZAvDb95+YcDvhB1xinYls5Aj/ijU6lik9oSwYnujfWBUByAVy
         DZGKto3QwcYEia+dEZjCv4+UJ6XBFBcJhMGCWs2HMdVJWM4OHXFj3nZ6X3A6QxLkww14
         jSkXK1hRIKS2Y6ujstXMdELgtXNJ0tEVh2oWzJEeRfA1ftr2EwfQdj5H11m2cnsdbMrV
         AAdz5lwRsa/EYcNPlUxhYqlIMD6n3bPFK4WTPHfDMM47GG+4QHA0hBQlYen5skIkMUqq
         YJ7g==
X-Gm-Message-State: ACrzQf0XK3E/gGHOx5KyVogzODoz5+lGcbeApqQiVqDcurCGlwp17oIB
        Pjgv2PE/59xc2D8cUzpFLMU=
X-Google-Smtp-Source: AMsMyM7tQ7RXINzRW7BLxbIDZYPnmZf4A1GfhlyaYZCcU+VRewKOfSHofji+e7jKBrH4MS+pRwR7vw==
X-Received: by 2002:a17:902:ea11:b0:176:b283:9596 with SMTP id s17-20020a170902ea1100b00176b2839596mr5332225plg.69.1664488903189;
        Thu, 29 Sep 2022 15:01:43 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001782f94f8ebsm407787plh.3.2022.09.29.15.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:01:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v3 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI error handler
Date:   Thu, 29 Sep 2022 15:00:21 -0700
Message-Id: <20220929220021.247097-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929220021.247097-1-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following deadlock has been observed on multiple test setups:
* ufshcd_wl_suspend() is waiting for blk_execute_rq() to complete while it
  holds host_sem.
* ufshcd_eh_host_reset_handler() invokes ufshcd_err_handler() and the
  latter function tries to obtain host_sem.
This is a deadlock because blk_execute_rq() can't execute SCSI commands
while the host is in the SHOST_RECOVERY state and because the error
handler cannot make progress either.

Fix this deadlock as follows:
* Fail attempts to suspend the system while the SCSI error handler is in
  progress.
* If the system is suspending and a START STOP UNIT command times out,
  handle the SCSI command timeout from inside the context of the SCSI
  timeout handler instead of activating the SCSI error handler.
* Reduce the START STOP UNIT command timeout to one second since on
  Android devices a kernel panic is triggered if an attempt to suspend
  the system takes more than 20 seconds. One second should be enough for
  the START STOP UNIT command since this command completes in less than
  a millisecond for the UFS devices I have access to.

The runtime power management code is not affected by this deadlock since
hba->host_sem is not touched by the runtime power management functions
in the UFS driver.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5507d93a4bba..0294b51e776a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8295,6 +8295,26 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	}
 }
 
+static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
+{
+	struct ufs_hba *hba = shost_priv(scmd->device->host);
+
+	if (!hba->system_suspending) {
+		/* Activate the error handler in the SCSI core. */
+		return SCSI_EH_NOT_HANDLED;
+	}
+
+	/*
+	 * Handle errors directly to prevent a deadlock between
+	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
+	 */
+	ufshcd_link_recovery(hba);
+	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
+		 __func__, hba->outstanding_tasks);
+
+	return hba->outstanding_tasks ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+}
+
 static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_unit_descriptor_group,
 	&ufs_sysfs_lun_attributes_group,
@@ -8329,6 +8349,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
+	.eh_timed_out		= ufshcd_eh_timed_out,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
@@ -8783,7 +8804,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 */
 	for (retries = 3; retries > 0; --retries) {
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+				   1 * HZ, 0, REQ_FAILFAST_DEV, RQF_PM, NULL);
 		if (ret < 0)
 			break;
 		if (host_byte(ret) == 0 && scsi_status_is_good(ret))
