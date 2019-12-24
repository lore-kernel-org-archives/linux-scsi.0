Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8EBC2D0D0
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:03:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF192206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 22:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfLXWDC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Dec 2019 17:03:02 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37125 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfLXWDC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Dec 2019 17:03:02 -0500
Received: by mail-pg1-f195.google.com with SMTP id q127so10921998pga.4
        for <linux-scsi@vger.kernel.org>; Tue, 24 Dec 2019 14:03:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cj+h1uS+nmOTmVjq4TwHsOoZ8bEBlowVURz3TXhPeSU=;
        b=CvdfA/0J3HQ7BMbamczs/TnTBVBTOMQFa7wdpWzdoNHo/LBjYtbcD6h8UAmRHtpnU9
         kkoj38H6t95HFRSXEBK1HKt8Z3Vp5RuvGOX8d+hnElBY8D1soHtbuW91mBw+E5KMxoLp
         UnWIm8gQXV4ZUhNr5dI5P2m9h9umlaV7VRUT3nmxBUsGaOda5PJ6DMEUs3W++KHLHNux
         8bHjLQJhKFJYCC6xWPTyz+Xz2M+EUHmMdeB7mkv+nqC8M40Y179poGXj93173RIj1fsN
         dVsgXNqjPRsOxzXwecR5rSJvj7TaYL1zh703DyZwx9b1WofOSlw5W6Of4YTGigLYpQ8F
         Oxpw==
X-Gm-Message-State: APjAAAWFE1V4yfVAigRabLfcZWcvUouhoTQG7X/KX7mxxkZg4HwdlEoB
        PCBN4wjk+OPdvwPvnRKd73k=
X-Google-Smtp-Source: APXvYqytKDkmWDAGIiE9nrgqfVsEWD6Cc3/o8ZYUq1oOvWOK+kTvkXrwo6ZYJpgxcgzHNqMT80ZIrg==
X-Received: by 2002:a65:420d:: with SMTP id c13mr40435411pgq.101.1577224981703;
        Tue, 24 Dec 2019 14:03:01 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:1206:80fd:a97:a7d:f0c8])
        by smtp.gmail.com with ESMTPSA id m15sm26839779pgi.91.2019.12.24.14.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 14:03:00 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/6] ufs: Fix a race condition in the tracing code
Date:   Tue, 24 Dec 2019 14:02:46 -0800
Message-Id: <20191224220248.30138-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191224220248.30138-1-bvanassche@acm.org>
References: <20191224220248.30138-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Starting execution of a command before tracing a command may cause the
completion handler to free data while it is being traced. Fix this race
by tracing a command before it is submitted.

Cc: Bean Huo <beanhuo@micron.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 80b028ba39e9..4d9bb1932b39 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1875,12 +1875,12 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
 	hba->lrb[task_tag].issue_time_stamp = ktime_get();
 	hba->lrb[task_tag].compl_time_stamp = ktime_set(0, 0);
+	ufshcd_add_command_trace(hba, task_tag, "send");
 	ufshcd_clk_scaling_start_busy(hba);
 	__set_bit(task_tag, &hba->outstanding_reqs);
 	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
-	ufshcd_add_command_trace(hba, task_tag, "send");
 }
 
 /**
