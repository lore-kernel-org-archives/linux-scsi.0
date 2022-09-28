Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB003C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 23:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiI1XPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 19:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiI1XPv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 19:15:51 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1648F491EC
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 16:15:49 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id 129so12109212pgc.5
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 16:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4ean5uOk0nvD/P2BUrYUqGt05jQTnVDHyMeQ2SyuQ14=;
        b=sb7NpgX7+Tr+YqCEdan/J8pQewngLsJhF+ZE5OFbsmPkOXdyiFKQ4OvLkoPXZfiG1Y
         Qlo66UjP7aqpFubFPrDjNfI1wnshjLILTLYNXkmtMyK6+XKv33r/6lq1wp4RnUB3CyGb
         bDu+K6ZMXtNolujke6TSKkaANnje8GeQjSsNPpdPYzUPTZj2VjWbZY7/gpBWsZGAah8K
         VL1V6AofxqEo1jqSvtU+cReHfdlK1Mo33sRFfpQcVlL2qIGT3pt8i68gGvEWwySpOxJE
         DKsUxPYxDUBqzJircYy1hrin5q1ADpUQXXDmzI8/OwN40R2MwG/6SRBBF+kiP85nJJhT
         PTqg==
X-Gm-Message-State: ACrzQf1QQwpZS1bAvxNxMONy2gqISpwvkMb8BpLm/d/AGSy+DoM1LFV4
        at0YQ7vdSRHwf5qarogGwTA=
X-Google-Smtp-Source: AMsMyM6nuX/ZttmPj+ny+oSkg80cvdHxE1lOuSR0y3gh9B8OkA0cZamWCZ9+O/UHrpBIt+7Bb3GMZw==
X-Received: by 2002:a63:4752:0:b0:439:5dcc:fd78 with SMTP id w18-20020a634752000000b004395dccfd78mr204632pgk.104.1664406948450;
        Wed, 28 Sep 2022 16:15:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:2e63:ed10:2841:950e? ([2620:15c:211:201:2e63:ed10:2841:950e])
        by smtp.gmail.com with ESMTPSA id w3-20020a170902ca0300b0016f85feae65sm4263281pld.87.2022.09.28.16.15.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 16:15:47 -0700 (PDT)
Message-ID: <a5a7d6d4-ab9b-c69b-ace7-f6c41855e219@acm.org>
Date:   Wed, 28 Sep 2022 16:15:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 8/8] scsi: ufs: Fix a deadlock between PM and the SCSI
 error handler
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20220927184309.2223322-1-bvanassche@acm.org>
 <20220927184309.2223322-9-bvanassche@acm.org>
 <9272d8ad-75b5-e521-c77c-24c72112e832@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9272d8ad-75b5-e521-c77c-24c72112e832@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 09:47, Adrian Hunter wrote:
> On 27/09/22 21:43, Bart Van Assche wrote:
>> +	ufshcd_complete_requests(hba);
>> +	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
>> +		 __func__, hba->outstanding_tasks);
> 
> Would it be possible to reuse the existing error handler rather
> than creating a mini version?

Hi Adrian,

How about replacing this patch with the two patches below?

Thanks,

Bart.

-------------------------------------------------------------------------

Subject: [PATCH] scsi: ufs: Introduce ufshcd_abort_all()

Move the code for aborting all SCSI commands and TMFs into a new
function. The next patch in this series will introduce a new caller for
that function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
  drivers/ufs/core/ufshcd.c | 62 +++++++++++++++++++++------------------
  1 file changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5507d93a4bba..fa1022926ab7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6201,6 +6201,38 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
  	return false;
  }

+static bool ufshcd_abort_all(struct ufs_hba *hba)
+{
+	bool needs_reset = false;
+	unsigned int tag, ret;
+
+	/* Clear pending transfer requests */
+	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
+		ret = ufshcd_try_to_abort_task(hba, tag);
+		dev_err(hba->dev, "Aborting tag %d / CDB %#02x %s\n", tag,
+			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1,
+			ret ? "failed" : "succeeded");
+		if (ret) {
+			needs_reset = true;
+			goto out;
+		}
+	}
+
+	/* Clear pending task management requests */
+	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
+		if (ufshcd_clear_tm_cmd(hba, tag)) {
+			needs_reset = true;
+			goto out;
+		}
+	}
+
+out:
+	/* Complete the requests that are cleared by s/w */
+	ufshcd_complete_requests(hba);
+
+	return needs_reset;
+}
+
  /**
   * ufshcd_err_handler - handle UFS errors that require s/w attention
   * @work: pointer to work structure
@@ -6212,10 +6244,7 @@ static void ufshcd_err_handler(struct work_struct *work)
  	unsigned long flags;
  	bool needs_restore;
  	bool needs_reset;
-	bool err_xfer;
-	bool err_tm;
  	int pmc_err;
-	int tag;

  	hba = container_of(work, struct ufs_hba, eh_work);

@@ -6244,8 +6273,6 @@ static void ufshcd_err_handler(struct work_struct *work)
  again:
  	needs_restore = false;
  	needs_reset = false;
-	err_xfer = false;
-	err_tm = false;

  	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
  		hba->ufshcd_state = UFSHCD_STATE_RESET;
@@ -6314,34 +6341,13 @@ static void ufshcd_err_handler(struct work_struct *work)
  	hba->silence_err_logs = true;
  	/* release lock as clear command might sleep */
  	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	/* Clear pending transfer requests */
-	for_each_set_bit(tag, &hba->outstanding_reqs, hba->nutrs) {
-		if (ufshcd_try_to_abort_task(hba, tag)) {
-			err_xfer = true;
-			goto lock_skip_pending_xfer_clear;
-		}
-		dev_err(hba->dev, "Aborted tag %d / CDB %#02x\n", tag,
-			hba->lrb[tag].cmd ? hba->lrb[tag].cmd->cmnd[0] : -1);
-	}

-	/* Clear pending task management requests */
-	for_each_set_bit(tag, &hba->outstanding_tasks, hba->nutmrs) {
-		if (ufshcd_clear_tm_cmd(hba, tag)) {
-			err_tm = true;
-			goto lock_skip_pending_xfer_clear;
-		}
-	}
-
-lock_skip_pending_xfer_clear:
-	/* Complete the requests that are cleared by s/w */
-	ufshcd_complete_requests(hba);
+	needs_reset = ufshcd_abort_all(hba);

  	spin_lock_irqsave(hba->host->host_lock, flags);
  	hba->silence_err_logs = false;
-	if (err_xfer || err_tm) {
-		needs_reset = true;
+	if (needs_reset)
  		goto do_reset;
-	}

  	/*
  	 * After all reqs and tasks are cleared from doorbell,

-------------------------------------------------------------------------

Subject: [PATCH] scsi: ufs: Fix a deadlock between PM and the SCSI error
  handler

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
  drivers/ufs/core/ufshcd.c | 26 +++++++++++++++++++++++++-
  1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fa1022926ab7..2b6c1efea447 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8301,6 +8301,29 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
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
+	if (ufshcd_abort_all(hba)) {
+		dev_info(hba->dev, "Resetting controller\n");
+		ufshcd_reset_and_restore(hba);
+	}
+	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
+		 __func__, hba->outstanding_tasks);
+
+	return hba->outstanding_tasks ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+}
+
  static const struct attribute_group *ufshcd_driver_groups[] = {
  	&ufs_sysfs_unit_descriptor_group,
  	&ufs_sysfs_lun_attributes_group,
@@ -8335,6 +8358,7 @@ static struct scsi_host_template ufshcd_driver_template = {
  	.eh_abort_handler	= ufshcd_abort,
  	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
  	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
+	.eh_timed_out		= ufshcd_eh_timed_out,
  	.this_id		= -1,
  	.sg_tablesize		= SG_ALL,
  	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
@@ -8789,7 +8813,7 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
  	 */
  	for (retries = 3; retries > 0; --retries) {
  		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
+				   1 * HZ, 0, REQ_FAILFAST_DEV, RQF_PM, NULL);
  		if (ret < 0)
  			break;
  		if (host_byte(ret) == 0 && scsi_status_is_good(ret))
