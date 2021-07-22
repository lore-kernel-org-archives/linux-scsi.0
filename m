Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E349C07E9D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2F1F60FF4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhGVCzW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:55:22 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:54936 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhGVCzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:55:21 -0400
Received: by mail-pj1-f42.google.com with SMTP id j1so2550185pjj.4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tRzuh0w47yQoCM3k02xB3WQ2QEgPkeHzrmD4Ibxw350=;
        b=j+s+Ji/9h7Ehjr4GQ/ac0AorEsoCUx6Pbju75kAJLKlkuogcHdojGkcNbSsFzP94ox
         JaBecXH2+TVzd1LhKKRH6vQS3D3wWdQ152PVr9I7Zm3S2tBhHCdCaa/FvASAuXuUHUiP
         G520Qb75YJMgtdD4LBdCL/IIMdFnwyEq1yzHUU8YuP8wUZOgs8PAo0644MxYxTzE7JtB
         TZ0epBkQxDD9hK8J2upFxwaCrgSQakkd9Dp8Ab+MZVY35fY0b+LZeHZjPKgIVwaemmNM
         GWPZgh6stu8seC45yFuRKRDDv/aQBa9yup+Mm39B5JXNsDxW+8Dxrs6aFTPizXU0L6C6
         ND+g==
X-Gm-Message-State: AOAM533sBbUBO2julkHDeK+4eT2xpuqFPilAwlCrONh4CS5RgTtJJZ1v
        DYB622CpLKYiow5g/iP5z4U=
X-Google-Smtp-Source: ABdhPJwYhE15aKNZhURc9XUgx+U2lwsK878FdL9NAVhd488TvCV0KBI8JM1u7FcNyPvzdwSspyjZYw==
X-Received: by 2002:a65:690f:: with SMTP id s15mr27735409pgq.21.1626924955007;
        Wed, 21 Jul 2021 20:35:55 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:54 -0700 (PDT)
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
Subject: [PATCH v3 15/18] scsi: ufs: Request sense data asynchronously
Date:   Wed, 21 Jul 2021 20:34:36 -0700
Message-Id: <20210722033439.26550-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
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
index c35e101c5834..75730a43fcca 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7820,8 +7820,39 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
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
+	req = blk_get_request(sdev->request_queue, REQ_OP_DRV_IN, /*flags=*/0);
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
@@ -7849,7 +7880,7 @@ static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
 	if (ret)
 		goto out_err;
 
-	ret = ufshcd_send_request_sense(hba, sdp);
+	ret = ufshcd_request_sense_async(hba, sdp);
 	scsi_device_put(sdp);
 out_err:
 	if (ret)
@@ -8444,35 +8475,6 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
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
