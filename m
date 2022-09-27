Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05201C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 18:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiI0SpS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiI0Soy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 14:44:54 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D18A1A63
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:44:52 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id y136so10477397pfb.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=HO69Xov4sQbqY106Mp0WEBTfd9dfYIxR7z2R9LIIKGc=;
        b=cDKdV0mf/2Hp1Rvoq53yYD44D0cUhzTRwcL6QiC+XNZ+Oyx87XibV/HIUAO6dt6mMb
         tFApwxL7aFEqdQqTfpDGnAEp4xgH6dJI1dC5RQ4z2HYhdGLIfnWm6Gw5D3YVg6xY8kPA
         +G98ZcqdVGaGVLLMlX31zo6pHSnZxnvShyFAXHIIGujq6GKfsR8ABdrw3GhV+TEpkIhC
         yO0ChCUL9p2ALg5dxO5IzvC/XSMBczRiVIM5wKjteW/RMD7ZUxlMjMk+EjRLmAk+Rfev
         aWqejrrQOQZdBAHSNOOrBNZX78+pD2H16mUoW1MuP38QmoxhVRj4hs+CsLomBaNTG/4q
         YDqQ==
X-Gm-Message-State: ACrzQf3en7hXAyE8zqnNRrR07YtNLAQdzM1e72lyHF4P084+ctqBmJ/+
        Vltlz4ICB0w9Et0TyU1IvcU=
X-Google-Smtp-Source: AMsMyM4eFiFH22ayHxaMCoiHc0+b40/0zNJlQrVHX2kL8vJSNW/FXay4jwjPH1nhlSv1fP4E/5nb4g==
X-Received: by 2002:a63:5d4e:0:b0:41d:2966:74e7 with SMTP id o14-20020a635d4e000000b0041d296674e7mr25132581pgm.526.1664304291118;
        Tue, 27 Sep 2022 11:44:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7956f000000b0052e987c64efsm2184083pfq.174.2022.09.27.11.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:44:50 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI error handler
Date:   Tue, 27 Sep 2022 11:43:09 -0700
Message-Id: <20220927184309.2223322-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220927184309.2223322-1-bvanassche@acm.org>
References: <20220927184309.2223322-1-bvanassche@acm.org>
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
 drivers/ufs/core/ufshcd.c | 51 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5507d93a4bba..010a5d1b984b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8295,6 +8295,54 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	}
 }
 
+static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
+{
+	struct ufs_hba *hba = shost_priv(scmd->device->host);
+	bool reset_controller = false;
+	int tag, ret;
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
+	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
+		ret = ufshcd_try_to_abort_task(hba, tag);
+		dev_info(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
+			 hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
+			 ret == 0 ? "succeeded" : "failed");
+		if (ret != 0) {
+			reset_controller = true;
+			break;
+		}
+	}
+	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
+		ret = ufshcd_clear_tm_cmd(hba, tag);
+		dev_info(hba->dev, "Aborting TMF %d %s\n", tag,
+			 ret == 0 ? "succeeded" : "failed");
+		if (ret != 0) {
+			reset_controller = true;
+			break;
+		}
+	}
+	if (reset_controller) {
+		dev_info(hba->dev, "Resetting controller\n");
+		ufshcd_reset_and_restore(hba);
+		if (ufshcd_clear_cmds(hba, 0xffffffff))
+			dev_err(hba->dev,
+				"Clearing outstanding commands failed\n");
+	}
+	ufshcd_complete_requests(hba);
+	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
+		 __func__, hba->outstanding_tasks);
+
+	return hba->outstanding_tasks ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+}
+
 static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_unit_descriptor_group,
 	&ufs_sysfs_lun_attributes_group,
@@ -8329,6 +8377,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
+	.eh_timed_out		= ufshcd_eh_timed_out,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
@@ -8783,7 +8832,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 */
 	for (retries = 3; retries > 0; --retries) {
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+				   1 * HZ, 0, REQ_FAILFAST_DEV, RQF_PM, NULL);
 		if (ret < 0)
 			break;
 		if (host_byte(ret) == 0 && scsi_status_is_good(ret))
