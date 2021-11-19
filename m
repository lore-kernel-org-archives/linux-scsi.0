Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63ADDC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F1F7610A1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236373AbhKSUBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:50 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:36626 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbhKSUBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:44 -0500
Received: by mail-pl1-f182.google.com with SMTP id u11so8940209plf.3
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ervmrfr/PMXzdgfdkURGl3jdLQgRDpD/FMYszboOIRc=;
        b=UdBPUOOYWZY5UWIRSt1J0K/DZ1pMADqHUHvXDK9SOAYJ3G1jLQJdrz/R0f57pIx23V
         FHAu/lfdHLAor9gkke6IJyMlUgyG/y5APUZ60qmyyatKJSNn3m1nXlqn6uszDNZDKYw5
         vvTNzxgUue0eWssPzKB+HDFTbHOb5R6YuPF5bFQplKrMFdXiV+Qpcz5hitNbE6gDW17T
         +qKxLf53WpUHK77+diqR+la7gbxpegamfBhiNg/nMCRADAz1x9x8nHgOzkbYR0uApTWl
         megyyTy/QrDPU/ut/0aUd3m1/mHFHMkcxhtcZYZ9cyKtHpgRPPdWe5oCDPU8mNIyb9co
         elCw==
X-Gm-Message-State: AOAM532B8rg3z/KRzsyiFyGeYJ1wXGqI502uBuOmXnqxF6YiBNlfsi/c
        nPNLysYws/9mizRWZcPnQtA=
X-Google-Smtp-Source: ABdhPJwg/7M3Emd3pj9DSdZAQuhZVfe55O3fBXYn0mf55hEPgNcv7ZiZNN8gUUvgDHxFO18w993kAw==
X-Received: by 2002:a17:902:c7d5:b0:143:72b7:2ca5 with SMTP id r21-20020a170902c7d500b0014372b72ca5mr79904311pla.20.1637351921740;
        Fri, 19 Nov 2021 11:58:41 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:41 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 17/20] scsi: ufs: Stop using the clock scaling lock in the error handler
Date:   Fri, 19 Nov 2021 11:57:40 -0800
Message-Id: <20211119195743.2817-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of locking and unlocking the clock scaling lock, surround the
command queueing code with an RCU reader lock and call synchronize_rcu().
This patch prepares for removal of the clock scaling lock.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6a743da7d2db..a6d3f71c6b00 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2702,6 +2702,12 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (!down_read_trylock(&hba->clk_scaling_lock))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
+	/*
+	 * Allows the UFS error handler to wait for prior ufshcd_queuecommand()
+	 * calls.
+	 */
+	rcu_read_lock();
+
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 		break;
@@ -2780,7 +2786,10 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	}
 
 	ufshcd_send_command(hba, tag);
+
 out:
+	rcu_read_unlock();
+
 	up_read(&hba->clk_scaling_lock);
 
 	if (ufs_trigger_eh()) {
@@ -5986,8 +5995,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	}
 	ufshcd_scsi_block_requests(hba);
 	/* Drain ufshcd_queuecommand() */
-	down_write(&hba->clk_scaling_lock);
-	up_write(&hba->clk_scaling_lock);
+	synchronize_rcu();
 	cancel_work_sync(&hba->eeh_work);
 }
 
