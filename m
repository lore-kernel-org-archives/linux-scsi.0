Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC86C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiJRUbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJRUbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:31:44 -0400
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBCA6111C
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:31:43 -0700 (PDT)
Received: by mail-pg1-f174.google.com with SMTP id q1so14293609pgl.11
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VnJsyMU6eNG/W1fi3wKRYyF4bK44zMNJE5n5vUN+Oqo=;
        b=GHv17csvHLabwuvgnE09m+XEc2NG/JigxLD3xBRcF5aKoiFMhB61tk9VfNBEVB/fK2
         QLRoA4AU8q3AQJVyCUZvY5LzrIKdTIkP5bHZEOE1ZVMmeWkeCttHto3GqBT3CWYsg5+N
         7SzbT5mSjjRxkL5Y5LA5Ud3P2MHbuPFAo0JSpx/+Zmvlz8JxikNiAJDsGmueR3GLliax
         P1mJc7Vp4ezgTUj7XG/qB3hSGku+RxpBMfTvtygZC1/uLVsT1IU13cthEqQEx7gyvaBp
         nvyf23kFzJUkoEJU03z7cp+B1Jyk4GGPXSah/jzWtuVU7kubLlcqYaPLLXgXGHhyDQnK
         T9wg==
X-Gm-Message-State: ACrzQf0gYGJ8msjsiSz2Jg2CpRVOXFIWlguwmb3ID+5URkTh2ucNmPWl
        D/W1nYLM2UCwVeTmnZHU568=
X-Google-Smtp-Source: AMsMyM5YctsX67k9Vg/HQxTZQ27LLEyZQJwu7PbI29m9w17OZBb+cRiAmpDUCH/UQpH24bhodiZbiQ==
X-Received: by 2002:a63:470b:0:b0:442:24d7:578 with SMTP id u11-20020a63470b000000b0044224d70578mr4184289pga.198.1666125102791;
        Tue, 18 Oct 2022 13:31:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:31:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v4 10/10] scsi: ufs: Fix a deadlock between PM and the SCSI error handler
Date:   Tue, 18 Oct 2022 13:29:58 -0700
Message-Id: <20221018202958.1902564-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following deadlock has been observed on multiple test setups:
* ufshcd_wl_suspend() is waiting for blk_execute_rq(START STOP UNIT) to
  complete while ufshcd_wl_suspend() holds host_sem.
* The SCSI error handler is activated, changes the host state to
  SHOST_RECOVERY, ufshcd_eh_host_reset_handler() and ufshcd_err_handler()
  are called and the latter function tries to obtain host_sem.

This is a deadlock because blk_execute_rq() can't execute SCSI commands
while the host is in the SHOST_RECOVERY state and because the error
handler cannot make progress because host_sem is held by another thread.

Fix this deadlock as follows:
* Fail attempts to suspend the system while the SCSI error handler is in
  progress by setting the SCMD_FAIL_IF_RECOVERING flag for START STOP
  UNIT commands.
* If the system is suspending and a START STOP UNIT command times out,
  handle the SCSI command timeout from inside the context of the SCSI
  timeout handler instead of activating the SCSI error handler.

The runtime power management code is not affected by this deadlock since
hba->host_sem is not touched by the runtime power management functions
in the UFS driver.

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c5ccc7ba583b..b2203dd79e8c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8292,6 +8292,28 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
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
+	 * If we get here we know that no TMFs are outstanding and also that
+	 * the only pending command is a START STOP UNIT command. Handle the
+	 * timeout of that command directly to prevent a deadlock between
+	 * ufshcd_set_dev_pwr_mode() and ufshcd_err_handler().
+	 */
+	ufshcd_link_recovery(hba);
+	dev_info(hba->dev, "%s() finished; outstanding_tasks = %#lx.\n",
+		 __func__, hba->outstanding_tasks);
+
+	return hba->outstanding_reqs ? SCSI_EH_RESET_TIMER : SCSI_EH_DONE;
+}
+
 static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_unit_descriptor_group,
 	&ufs_sysfs_lun_attributes_group,
@@ -8326,6 +8348,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
+	.eh_timed_out		= ufshcd_eh_timed_out,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
@@ -8747,6 +8770,7 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	scmd->cmd_len = COMMAND_SIZE(cdb[0]);
 	memcpy(scmd->cmnd, cdb, scmd->cmd_len);
 	scmd->allowed = 0/*retries*/;
+	scmd->flags |= SCMD_FAIL_IF_RECOVERING;
 	req->timeout = 1 * HZ;
 	req->rq_flags |= RQF_PM | RQF_QUIET;
 
