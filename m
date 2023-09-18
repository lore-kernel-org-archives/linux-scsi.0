Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B53C46CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 16:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjIRQ16 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 12:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjIRQ1g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 12:27:36 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA206216C5
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:21:47 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1bf55a81eeaso33933745ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 09:21:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695054076; x=1695658876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HC1c+srrjijA9jfgQkIRw/emAtgfwjLgM9wA0nVlBAo=;
        b=L3lB9l46EJQWPyU9uCyAZ4VhJ0GEgJZHPP89G13sZ7si5oym5GhYs/KrUyWedK5wM/
         mghcUxxnjVn6D+fhjR+nxGOYM2pHo7bJAXzcLd7Nuu6UiKo63BWDXv1i+okr/qPkq/MC
         zWx6iax2iEIDCvJonmMfrr19Z5lePcfsZyspsf4iIaH90NkWH4r5Im1Hrfx2+yAANJHj
         OecMKesPufUj5C3xZRyWjDkFm1zjlxe7nXyjqOEoEmlFpwfvZkQNoLr1YnEFTS8tzkyx
         TXKuoRdIL4DA3i2NkHpQcxVjz1M19qaOQID3GK6POISCHAkDhdHiK2clC323qcKmKUTV
         6mpg==
X-Gm-Message-State: AOJu0YwUogZo1JnLoruD+/lnfozdH5oKy2OQvRuc5fWMI3wKU2qgRKV7
        owf4iTiyIOUVXdpR3a8FJ0M=
X-Google-Smtp-Source: AGHT+IHA4U1qTUfeeVMynnYgVNGhp6pYTwN2F3wjv9PwEjhWCy2SlrTYqMgjYwy3fTN5t5cXArw5Ig==
X-Received: by 2002:a17:902:f689:b0:1c3:e5bf:a9ec with SMTP id l9-20020a170902f68900b001c3e5bfa9ecmr9061164plg.51.1695054075831;
        Mon, 18 Sep 2023 09:21:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id z14-20020a170902d54e00b001bd28b9c3ddsm8489414plf.299.2023.09.18.09.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:21:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH 1/4] scsi: ufs: Return in case of an invalid tag
Date:   Mon, 18 Sep 2023 09:20:12 -0700
Message-ID: <20230918162058.1562033-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
In-Reply-To: <20230918162058.1562033-1-bvanassche@acm.org>
References: <20230918162058.1562033-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a tag is invalid, instead of only issuing a kernel warning, also
return. This patch suppresses Coverity warnings about left shifts with a
negative right hand operand.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dc1285351336..5fccec3c1091 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2822,7 +2822,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	int err = 0;
 	struct ufs_hw_queue *hwq = NULL;
 
-	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
+	if (WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag))
+		return 0;
 
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
@@ -6923,8 +6924,11 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_lock_irqsave(host->host_lock, flags);
 
 	task_tag = req->tag;
-	WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs, "Invalid tag %d\n",
-		  task_tag);
+	if (WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs,
+		      "Invalid tag %d\n", task_tag)) {
+		err = -EINVAL;
+		goto unlock;
+	}
 	hba->tmf_rqs[req->tag] = req;
 	treq->upiu_req.req_header.task_tag = task_tag;
 
@@ -6963,6 +6967,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->tmf_rqs[req->tag] = NULL;
 	__clear_bit(task_tag, &hba->outstanding_tasks);
+unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	ufshcd_release(hba);
@@ -7485,7 +7490,7 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag)
  * ufshcd_abort - scsi host template eh_abort_handler callback
  * @cmd: SCSI command pointer
  *
- * Return: SUCCESS or FAILED.
+ * Return: SUCCESS, FAILED or FAST_IO_FAIL.
  */
 static int ufshcd_abort(struct scsi_cmnd *cmd)
 {
@@ -7498,7 +7503,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	bool outstanding;
 	u32 reg;
 
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
+	if (WARN_ONCE(tag < 0, "Invalid tag %d\n", tag))
+		return FAST_IO_FAIL;
 
 	ufshcd_hold(hba);
 
