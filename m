Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89FCC43219
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Nov 2022 00:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbiKSAYV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 19:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235353AbiKSAXk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 19:23:40 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E423B6D945
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 15:38:01 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id b185so6285202pfb.9
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 15:38:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BQEohHyALVpyEwD6PhgfRwALPDSkTpHuqT1fGavn2xU=;
        b=sD2ZfTwdwlpx0Nq6RLxIrq0UAWtnMUHXym281pYeShmJQE/T3aIHpBMnPYXW21B848
         tmUQqdYTJOCk3N6rUAGcw6yWfdiOycCs1nuhPE617Pk85qhKd2LArKwGOqHk952Ks4Bx
         v4smeB+6u+sNOB6b42152mhQPmY82DD7syYk9pAPIRBeRCyDz5+YvJq8Y8RIdvc39vzQ
         tNZI2z4+u+5MfwvZ/PFIGPmjCbEvDV3NaMnR6Scv9ksqCxI+H2qYUnjEV4CnWhNn71Ct
         qzyukFPJ2drZQSyohRsoEEfFOxYhMBLEmxVaTp0tg/hcqoIMgvX+HegnipE8NjHQzDev
         +EGA==
X-Gm-Message-State: ANoB5pnQRe0un9Gre+CBC+I9jvGrtdhwr/4xvDQ4mvBB6oXaSze28cdZ
        meeal6H8c/Zu2pUQy9Jq+fM=
X-Google-Smtp-Source: AA0mqf4Hao2OHimEMs29K78u9L+knLx2BQTNpGNMaqWYpHxKNWXTLPbfKK0X+V2UtridFsH1hm+JmA==
X-Received: by 2002:a63:1659:0:b0:46e:f23a:e9aa with SMTP id 25-20020a631659000000b0046ef23ae9aamr8400651pgw.428.1668814644296;
        Fri, 18 Nov 2022 15:37:24 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5392:f94c:13ff:af1a])
        by smtp.gmail.com with ESMTPSA id f4-20020aa79684000000b00561b3ee73f6sm3829934pfk.144.2022.11.18.15.37.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 15:37:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2] scsi: ufs: Fix the polling implementation
Date:   Fri, 18 Nov 2022 15:37:03 -0800
Message-Id: <20221118233717.441298-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following issues in ufshcd_poll():
- If polling succeeds, return a positive value.
- Do not complete polling requests from interrupt context because the
  block layer expects these requests to be completed from thread
  context. From block/bio.c:

    If REQ_ALLOC_CACHE is set, the final put of the bio MUST be done
    from process context, not hard/soft IRQ.

Fixes: eaab9b573054 ("scsi: ufs: Implement polling support")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1:
- Made sure that polled requests are not completed from interrupt context.

 drivers/ufs/core/ufshcd.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 768cb49d269c..b4bf3c3bef0c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5344,6 +5344,26 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	}
 }
 
+/* Any value that is not an existing queue number is fine for this constant. */
+enum {
+	UFSHCD_POLL_FROM_INTERRUPT_CONTEXT = -1
+};
+
+static void ufshcd_clear_polled(struct ufs_hba *hba,
+				unsigned long *completed_reqs)
+{
+	int tag;
+
+	for_each_set_bit(tag, completed_reqs, hba->nutrs) {
+		struct scsi_cmnd *cmd = hba->lrb[tag].cmd;
+
+		if (!cmd)
+			continue;
+		if (scsi_cmd_to_rq(cmd)->cmd_flags & REQ_POLLED)
+			__clear_bit(tag, completed_reqs);
+	}
+}
+
 /*
  * Returns > 0 if one or more commands have been completed or 0 if no
  * requests have been completed.
@@ -5360,13 +5380,17 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
 		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
 		  hba->outstanding_reqs);
+	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
+		/* Do not complete polled requests from interrupt context. */
+		ufshcd_clear_polled(hba, &completed_reqs);
+	}
 	hba->outstanding_reqs &= ~completed_reqs;
 	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
 
 	if (completed_reqs)
 		__ufshcd_transfer_req_compl(hba, completed_reqs);
 
-	return completed_reqs;
+	return completed_reqs != 0;
 }
 
 /**
@@ -5397,7 +5421,7 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * Ignore the ufshcd_poll() return value and return IRQ_HANDLED since we
 	 * do not want polling to trigger spurious interrupt complaints.
 	 */
-	ufshcd_poll(hba->host, 0);
+	ufshcd_poll(hba->host, UFSHCD_POLL_FROM_INTERRUPT_CONTEXT);
 
 	return IRQ_HANDLED;
 }
