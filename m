Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB33DC11F69
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC34F61406
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Jul 2021 21:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbhGAVQY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Jul 2021 17:16:24 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33533 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbhGAVQX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2021 17:16:23 -0400
Received: by mail-pf1-f169.google.com with SMTP id s14so7165384pfg.0
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jul 2021 14:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7NuK3lXUUdOrrf3Gm6bqMHeVFsXO1cnz9iNndZgcgy4=;
        b=Tul1DLwMw9fYbCzJwS4w7Cws5cWY/cpJ6sOeXlD93aUPY80FHD8ld3D8GVslG0pLGM
         LfsqL+tb56fNeJ+7Ry7aeGhsIbZ9KVr7R30QccgFpbYdeIWp8qf501BHw4eZp12KHzrQ
         RH2gXTP41vth0BOlSwDdcky0dvJ+yXMG61sUvZetCBnqYHxGlbaFVMY861x5WQRVUkbg
         wrkhKguu+eru4PlFdNt4SEesyMWW1b9CuTT++XVFXzYOJS0KI6NvD5AiRQkyYya6W68f
         FHDzcKYqV8eWCxdfnkAv3yLdEojYeIzBPcwFmgHWL9Uo3leP2WiWfeGXNY5euj1u0uvg
         3Q8A==
X-Gm-Message-State: AOAM530mMsu1T9LL8qI5s8Cj835LyuMMnpXaoy8f76hi+skks6/fyEM3
        8e44XRa7alUD9zBf9eHKnyY=
X-Google-Smtp-Source: ABdhPJzJX6inktHSgpaNd5YffrTr5zeniRZU5UkwgjUVp26GJd6Q2UrpWvph3JH8kJSo5cs1iMgcgQ==
X-Received: by 2002:a63:e253:: with SMTP id y19mr1490557pgj.137.1625174032541;
        Thu, 01 Jul 2021 14:13:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:6a75:b07:a0d:8bd5])
        by smtp.gmail.com with ESMTPSA id k25sm900832pfa.213.2021.07.01.14.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 14:13:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH 19/21] ufs: Request sense data asynchronously
Date:   Thu,  1 Jul 2021 14:12:22 -0700
Message-Id: <20210701211224.17070-20-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701211224.17070-1-bvanassche@acm.org>
References: <20210701211224.17070-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Clearing a unit attention synchronously from inside the UFS error handler
may trigger the following deadlock:
- ufshcd_err_handler() calls ufshcd_err_handling_unprepare() and the latter
  function calls ufshcd_clear_ua_wluns().
- ufshcd_clear_ua_wluns() submits a REQUEST SENSE command and that command
  activates the SCSI error handler.
- The SCSI error handler calls ufshcd_host_reset_and_restore().
- ufshcd_host_reset_and_restore() executes the following code:
  ufshcd_schedule_eh_work(hba);
  flush_work(&hba->eh_work);

This sequence results in a deadlock (circular wait). Fix this by requesting
sense data asynchronously.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 64 ++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 250d46ab3584..a74862813140 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7815,8 +7815,39 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	return ret;
 }
 
+static void ufshcd_request_sense_done(struct request *rq, blk_status_t error)
+{
+	if (error != BLK_STS_OK)
+		pr_err("%s: REQUEST SENSE failed (%d)", __func__, error);
+	blk_put_request(rq);
+}
+
 static int
-ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp);
+ufshcd_request_sense_async(struct ufs_hba *hba, struct scsi_device *sdev)
+{
+	/*
+	 * From SPC-6: the REQUEST SENSE command with any allocation length
+	 * clears the sense data.
+	 */
+	static const u8 cmd[6] = {REQUEST_SENSE, 0, 0, 0, 0, 0};
+	struct scsi_request *rq;
+	struct request *req;
+
+	req = blk_get_request(sdev->request_queue, REQ_OP_SCSI_IN, /*flags=*/0);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	rq = scsi_req(req);
+	rq->cmd_len = ARRAY_SIZE(cmd);
+	memcpy(rq->cmd, cmd, rq->cmd_len);
+	rq->retries = 3;
+	req->timeout = 1 * HZ;
+	req->rq_flags |= RQF_PM | RQF_QUIET;
+
+	blk_execute_rq_nowait(/*bd_disk=*/NULL, req, /*at_head=*/true,
+			      ufshcd_request_sense_done);
+	return 0;
+}
 
 static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
 {
@@ -7844,7 +7875,7 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
 	if (ret)
 		goto out_err;
 
-	ret = ufshcd_send_request_sense(hba, sdp);
+	ret = ufshcd_request_sense_async(hba, sdp);
 	scsi_device_put(sdp);
 out_err:
 	if (ret)
@@ -8439,35 +8470,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	}
 }
 
-static int
-ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
-{
-	unsigned char cmd[6] = {REQUEST_SENSE,
-				0,
-				0,
-				0,
-				UFS_SENSE_SIZE,
-				0};
-	char *buffer;
-	int ret;
-
-	buffer = kzalloc(UFS_SENSE_SIZE, GFP_KERNEL);
-	if (!buffer) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = scsi_execute(sdp, cmd, DMA_FROM_DEVICE, buffer,
-			UFS_SENSE_SIZE, NULL, NULL,
-			msecs_to_jiffies(1000), 3, 0, RQF_PM, NULL);
-	if (ret)
-		pr_err("%s: failed with err %d\n", __func__, ret);
-
-	kfree(buffer);
-out:
-	return ret;
-}
-
 /**
  * ufshcd_set_dev_pwr_mode - sends START STOP UNIT command to set device
  *			     power mode
