Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736F6C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJRUbj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiJRUbe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:31:34 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5929662910
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:31:33 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id i6so14912940pli.12
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HJf187Qzs/bKzk1uyJjTINaj+R2z0jy4jyz+iZxiYFI=;
        b=SsyNiRQBbg4khaega+RfzDx9hoeroP2e/a0mhEUDqoIYeeaA+c3uhHI7aBP2UirzsO
         GcObdRgJwFT00wh/Uq+SlkXWycEl0LTjbNFRnyaH20HhxpJxzsF6HAKX6n82M880EoNh
         AbUforMCIy5Y0Ggs2PH11McYrCGUgAh9DPz2kCh8ffk9mPJ1rhG+DxdtWKowdzg7EWV3
         1KyVcrUKoTpLvOddmp5iKg0MZjM7kkyGdlsaQeC5KBIzwYaoh4O9UVGGSa+0kiE0Xkx3
         LEITsK5Tq1TEC9n36XCIoY+w2GRTZHDqYYfo78CA1B/kX2iiA79t6uu76ht/TlI8Y7cP
         PefQ==
X-Gm-Message-State: ACrzQf0qBWCvMsFLPuTWIu5Q9BJnXkKHTvlqTX43gyARBgRgtCLYDcRY
        6HGIYsxtCg+OLjBdKN9DJog=
X-Google-Smtp-Source: AMsMyM6+dnoeql6yXjojDbf3vRWLoybM73Ps+J8ML/5P47ohY2ppafQEJD7uo4UTSm+Fv5w+hCGq+A==
X-Received: by 2002:a17:902:c40a:b0:185:51a2:233f with SMTP id k10-20020a170902c40a00b0018551a2233fmr4770806plk.25.1666125092718;
        Tue, 18 Oct 2022 13:31:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:31:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v4 09/10] scsi: ufs: Introduce the function ufshcd_execute_start_stop()
Date:   Tue, 18 Oct 2022 13:29:57 -0700
Message-Id: <20221018202958.1902564-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Open-code scsi_execute() because a later patch will modify scmd->flags
and because scsi_execute() does not support setting scmd->flags. No
functionality is changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 39 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2a32bcc93d2e..c5ccc7ba583b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8729,6 +8729,39 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	}
 }
 
+static int ufshcd_execute_start_stop(struct scsi_device *sdev,
+				     enum ufs_dev_pwr_mode pwr_mode,
+				     struct scsi_sense_hdr *sshdr)
+{
+	unsigned char cdb[6] = { START_STOP, 0, 0, 0, pwr_mode << 4, 0 };
+	struct request *req;
+	struct scsi_cmnd *scmd;
+	int ret;
+
+	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
+				 BLK_MQ_REQ_PM);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	scmd = blk_mq_rq_to_pdu(req);
+	scmd->cmd_len = COMMAND_SIZE(cdb[0]);
+	memcpy(scmd->cmnd, cdb, scmd->cmd_len);
+	scmd->allowed = 0/*retries*/;
+	req->timeout = 1 * HZ;
+	req->rq_flags |= RQF_PM | RQF_QUIET;
+
+	blk_execute_rq(req, /*at_head=*/true);
+
+	if (sshdr)
+		scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
+				     sshdr);
+	ret = scmd->result;
+
+	blk_mq_free_request(req);
+
+	return ret;
+}
+
 /**
  * ufshcd_set_dev_pwr_mode - sends START STOP UNIT command to set device
  *			     power mode
@@ -8741,7 +8774,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				     enum ufs_dev_pwr_mode pwr_mode)
 {
-	unsigned char cmd[6] = { START_STOP };
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdp;
 	unsigned long flags;
@@ -8766,16 +8798,13 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 */
 	hba->host->eh_noresume = 1;
 
-	cmd[4] = pwr_mode << 4;
-
 	/*
 	 * Current function would be generally called from the power management
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
 	for (retries = 3; retries > 0; --retries) {
-		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
-				   HZ, 0, 0, RQF_PM, NULL);
+		ret = ufshcd_execute_start_stop(sdp, pwr_mode, &sshdr);
 		/*
 		 * scsi_execute() only returns a negative value if the request
 		 * queue is dying.
