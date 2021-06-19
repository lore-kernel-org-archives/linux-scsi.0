Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D41C48BDF
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E11E861284
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Jun 2021 00:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbhFSAzG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Jun 2021 20:55:06 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:43721 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhFSAzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Jun 2021 20:55:06 -0400
Received: by mail-pf1-f169.google.com with SMTP id a127so8990849pfa.10
        for <linux-scsi@vger.kernel.org>; Fri, 18 Jun 2021 17:52:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/0BidHuUcMFdRN9t7em7vqAl/Ml1liO5hahNmbsy0r8=;
        b=dq44CnWB5eqvyMXShwHxXYbwBwKYRVk4akGH4uqM8hi9IG+u6+DBqSytHz2pmSfWXk
         3Lhey58073ZvLcupwiQ/uTt6uCWtUTQs7+U9iQATEoLHzVyrdVGUzgQY1tIH6nJa9OJD
         h+fIEgJPm/B6ozEkqVs/02qKONQafGnka8h76LpoJ7+oDm8hJyynOeMz+N5w456mUTyg
         G/qMW6WOK2DPVglsnW7m7Y3ygomsuUxeZYkLNS9T0rRAovhYV7j2KjiA9iLIqw4Fh47L
         JbwqhCZI/NwIHzpZbw6Q9L+I+fnntaDJ4PBYDYGavu8hQoQTf1CnLRFpYeme6mNcasvS
         mk4A==
X-Gm-Message-State: AOAM531iyJMFHG5uzTFqQ+e4S9JBpHV3HW8JWTc+6dpAhYRDhxCQz0W8
        wTlGTnHWk83hafCjXJ2LF8oKiMbkDKo=
X-Google-Smtp-Source: ABdhPJwsFMTjo+GgH+CaL2Zrgn2rU0CM20hvG2b3/4VqOqbkK1DavrLMj/RZXc9SaJMQKezYQc8YWA==
X-Received: by 2002:a65:4985:: with SMTP id r5mr12324646pgs.122.1624063974873;
        Fri, 18 Jun 2021 17:52:54 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p6sm9934460pjh.24.2021.06.18.17.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 17:52:54 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH RFC 4/4] ufs: Make host controller state change handling more systematic
Date:   Fri, 18 Jun 2021 17:52:28 -0700
Message-Id: <20210619005228.28569-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619005228.28569-1-bvanassche@acm.org>
References: <20210619005228.28569-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce a function that reports whether or not a controller state change
is allowed instead of duplicating these checks in every context that
changes the host controller state. This patch includes a behavior change:
ufshcd_link_recovery() no longer can change the host controller state from
UFSHCD_STATE_ERROR into UFSHCD_STATE_RESET.

Cc: Can Guo <cang@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 59 ++++++++++++++++++++++++---------------
 1 file changed, 36 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c213daec20f7..a10c8ec28468 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4070,16 +4070,32 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
 	return ret;
 }
 
+static bool ufshcd_set_state(struct ufs_hba *hba, enum ufshcd_state new_state)
+{
+	lockdep_assert_held(hba->host->host_lock);
+
+	if (old_state != UFSHCD_STATE_ERROR || new_state == UFSHCD_STATE_ERROR)
+		hba->ufshcd_state = new_state;
+		return true;
+	}
+	return false;
+}
+
 int ufshcd_link_recovery(struct ufs_hba *hba)
 {
 	int ret;
 	unsigned long flags;
+	bool proceed;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
-	ufshcd_set_eh_in_progress(hba);
+	proceed = ufshcd_set_state(hba, UFSHCD_STATE_RESET);
+	if (proceed)
+		ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	if (!proceed)
+		return -EPERM;
+
 	/* Reset the attached device */
 	ufshcd_device_reset(hba);
 
@@ -4087,7 +4103,7 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ret)
-		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		ufshcd_set_state(hba, UFSHCD_STATE_ERROR);
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
@@ -5856,15 +5872,17 @@ static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
 /* host lock must be held before calling this func */
 static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 {
-	/* handle fatal errors only when link is not in error state */
-	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
-		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
-		    ufshcd_is_saved_err_fatal(hba))
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
-		else
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
+	bool proceed;
+
+	if (hba->force_reset || ufshcd_is_link_broken(hba) ||
+	    ufshcd_is_saved_err_fatal(hba))
+		proceed = ufshcd_set_state(hba,
+					   UFSHCD_STATE_EH_SCHEDULED_FATAL);
+	else
+		proceed = ufshcd_set_state(hba,
+					   UFSHCD_STATE_EH_SCHEDULED_NON_FATAL);
+	if (proceed)
 		queue_work(hba->eh_wq, &hba->eh_work);
-	}
 }
 
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
@@ -6017,8 +6035,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (ufshcd_err_handling_should_stop(hba)) {
-		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
-			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+		ufshcd_set_state(hba, UFSHCD_STATE_OPERATIONAL);
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		up(&hba->host_sem);
 		return;
@@ -6029,8 +6046,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
-		hba->ufshcd_state = UFSHCD_STATE_RESET;
+	ufshcd_set_state(hba, UFSHCD_STATE_RESET);
 	/*
 	 * A full reset and restore might have happened after preparation
 	 * is finished, double check whether we should stop.
@@ -6163,8 +6179,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 skip_err_handling:
 	if (!needs_reset) {
-		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+		ufshcd_set_state(hba, UFSHCD_STATE_OPERATIONAL);
 		if (hba->saved_err || hba->saved_uic_err)
 			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x saved_uic_err 0x%x",
 			    __func__, hba->saved_err, hba->saved_uic_err);
@@ -7135,7 +7150,7 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 	 */
 	scsi_report_bus_reset(hba->host, 0);
 	if (err) {
-		hba->ufshcd_state = UFSHCD_STATE_ERROR;
+		ufshcd_set_state(hba, UFSHCD_STATE_ERROR);
 		hba->saved_err |= saved_err;
 		hba->saved_uic_err |= saved_uic_err;
 	}
@@ -7951,7 +7966,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 	unsigned long flags;
 	ktime_t start = ktime_get();
 
-	hba->ufshcd_state = UFSHCD_STATE_RESET;
+	ufshcd_set_state(hba, UFSHCD_STATE_RESET);
 
 	ret = ufshcd_link_startup(hba);
 	if (ret)
@@ -8024,10 +8039,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params)
 
 out:
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (ret)
-		hba->ufshcd_state = UFSHCD_STATE_ERROR;
-	else if (hba->ufshcd_state == UFSHCD_STATE_RESET)
-		hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+	ufshcd_set_state(hba, ret ? UFSHCD_STATE_ERROR :
+			 UFSHCD_STATE_OPERATIONAL);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	trace_ufshcd_init(dev_name(hba->dev), ret,
