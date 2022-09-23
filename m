Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8039C04A95
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 20:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiIWUNM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiIWUNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 16:13:11 -0400
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5E41231D5
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:13:09 -0700 (PDT)
Received: by mail-pl1-f173.google.com with SMTP id f23so1138339plr.6
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:13:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=GgUKP3izHtHyEqj3vDDDrexbU6/XWurhT0kSFKGCtZw=;
        b=dmO62MzlOxqkNk5fSpZxo0pzHQ3WAGIdO6OxQ9fwAWPuOfKCSw9C9lKinGVex07Npt
         CvIAJKSzmIluONd9/1+9iYEqmvsjBpdmDHWLxhlDu4UuVuQdisuVnbSZtSIAO9rINWCK
         pQjZsEKJS4j3ENom437Zj/ACKGoLr7eOJarAVW0rAu5NdA/YMJI3JGxJr4GuF071Wdbp
         Ci7bpRLqBxuQrGeAr8o8751Ci/mLTwUV+y5+79Wim3CTa4gWGeyJTphMwGVHGFaWXyzW
         gq2NBjRBKb9vysWKomowcrf5TcsyWJ7l0vbulvzKEvQpbICotPps8l50GSSoVXPK6NLc
         FFfg==
X-Gm-Message-State: ACrzQf1wQuOoY6pTfxT8ZGaxnYuAj57XJRCnxJW23a2BWGWwp6Uz4q2Y
        2FJNzdmf2JHqQYQhdBOYjO8=
X-Google-Smtp-Source: AMsMyM5Usf0PSS7C8xVHl4URtPMzGPqti54+aAr98zgxpew5TuhkgMnFh0e9O3v5gf9BLb0+edIpig==
X-Received: by 2002:a17:902:bc44:b0:176:909f:f636 with SMTP id t4-20020a170902bc4400b00176909ff636mr10150871plz.21.1663963989224;
        Fri, 23 Sep 2022 13:13:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa13:bc38:2a63:318e])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001754fa42065sm6388435plk.143.2022.09.23.13.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:13:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH 8/8] scsi: ufs: Fix deadlock between power management and error handler
Date:   Fri, 23 Sep 2022 13:11:38 -0700
Message-Id: <20220923201138.2113123-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220923201138.2113123-1-bvanassche@acm.org>
References: <20220923201138.2113123-1-bvanassche@acm.org>
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

Fix this deadlock by calling the UFS error handler directly during system
suspend instead of relying on the error handling mechanism in the SCSI
core.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 43 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index abeb120b12eb..996641fc1176 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6405,9 +6405,19 @@ static void ufshcd_err_handler(struct work_struct *work)
 {
 	struct ufs_hba *hba = container_of(work, struct ufs_hba, eh_work);
 
-	down(&hba->host_sem);
-	ufshcd_recover_link(hba);
-	up(&hba->host_sem);
+	/*
+	 * Serialize suspend/resume and error handling because a deadlock
+	 * occurs if the error handler runs concurrently with
+	 * ufshcd_set_dev_pwr_mode().
+	 */
+	if (mutex_trylock(&system_transition_mutex)) {
+		down(&hba->host_sem);
+		ufshcd_recover_link(hba);
+		up(&hba->host_sem);
+		mutex_unlock(&system_transition_mutex);
+	} else {
+		pr_info("%s: suspend or resume is ongoing\n", __func__);
+	}
 }
 
 /**
@@ -8298,6 +8308,25 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	}
 }
 
+static enum scsi_timeout_action ufshcd_eh_timed_out(struct scsi_cmnd *scmd)
+{
+	struct ufs_hba *hba = shost_priv(scmd->device->host);
+
+	if (!hba->system_suspending) {
+		/* Apply the SCSI core error handling strategy. */
+		return SCSI_EH_NOT_HANDLED;
+	}
+
+	/*
+	 * Fail START STOP UNIT commands without activating the SCSI error
+	 * handler to prevent a deadlock between ufshcd_set_dev_pwr_mode() and
+	 * ufshcd_err_handler().
+	 */
+	set_host_byte(scmd, DID_TIME_OUT);
+	scsi_done(scmd);
+	return SCSI_EH_DONE;
+}
+
 static const struct attribute_group *ufshcd_driver_groups[] = {
 	&ufs_sysfs_unit_descriptor_group,
 	&ufs_sysfs_lun_attributes_group,
@@ -8332,6 +8361,7 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.eh_abort_handler	= ufshcd_abort,
 	.eh_device_reset_handler = ufshcd_eh_device_reset_handler,
 	.eh_host_reset_handler   = ufshcd_eh_host_reset_handler,
+	.eh_timed_out		= ufshcd_eh_timed_out,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
@@ -8791,6 +8821,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 			break;
 		if (host_byte(ret) == 0 && scsi_status_is_good(ret))
 			break;
+		/*
+		 * Calling the error handler directly when suspending or
+		 * resuming the system since the callers of this function hold
+		 * hba->host_sem in that case.
+		 */
+		if (host_byte(ret) != 0 && hba->system_suspending)
+			ufshcd_recover_link(hba);
 	}
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
