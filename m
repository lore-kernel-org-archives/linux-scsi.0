Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697E4C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C74F61357
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:27:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhGIUag (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:30:36 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:40700 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhGIUag (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:30:36 -0400
Received: by mail-pg1-f173.google.com with SMTP id k20so4114098pgg.7
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:27:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ot3D477jhdNIkLRN4i6n3Uf1D3d0UzlnMTt/ftDfg64=;
        b=VIkpnFL1wkxkFkNFp7f2Nt//KqFeiu+bbKxGhnvNPGwIidPaXi5wtyxeSJB14VHFVg
         9z4/1O4Bu75GX8MUAE82hYMODvUDgO3meEvA9G7mBFGUwtXLCwIgXJYg0nqqi4M4+FgR
         u3tz2oP0OA46iyH4sXdxAyvi80vyQYSlDadYQptKhh12/1yhjmvqzAsuRWW62qt6Jmhk
         4d5xQunCLS/suEcNO9Q9vThiCem/rqhTjkXm62wiBIBAmhlGsTW54EP49xvrez1RT2/N
         9gBbOUJmSQLPMwrf0i8rzbT9qzraqhsyHEXE59pxU6rFxcqRlB5Vofe5/FNZjSs/CFEB
         bf/g==
X-Gm-Message-State: AOAM533nielaWjDwKf2l9A1ObeDqb8dAgHAmyOotg95XXvErLm2UrGdT
        Bt67ZAH1+koIPA+O/kD2ymA=
X-Google-Smtp-Source: ABdhPJxwP9BGEqMxwEKm4VZGY5Ern5CABNbvjwsAmO/knJejry7CJwZ6BT7eACecQbGUwpMd5d499w==
X-Received: by 2002:aa7:8509:0:b029:2e5:8cfe:bc17 with SMTP id v9-20020aa785090000b02902e58cfebc17mr39748734pfn.2.1625862472108;
        Fri, 09 Jul 2021 13:27:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:27:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 16/19] scsi: ufs: Request sense data asynchronously
Date:   Fri,  9 Jul 2021 13:26:35 -0700
Message-Id: <20210709202638.9480-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
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
index ea3c2d052123..ae04c7ed9766 100644
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
