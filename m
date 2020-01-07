Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23761C33CA2
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 19:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE8C620656
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 19:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbgAGTZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 14:25:44 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39047 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728307AbgAGTZo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2020 14:25:44 -0500
Received: by mail-pg1-f194.google.com with SMTP id b137so334077pga.6
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jan 2020 11:25:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WoXTVVYnvfT6RgNq746+XK12yM12CTO9PbAA2Cr1ecQ=;
        b=XaMqRg1Q3uEE3R6stcsxp7PLD4YepLPQhFZnEpYZwG2muZyrS7twiSBp3q2GPvUKIY
         C7cPOrdHg74nNNAQWNrk0fTFccnP8/6kXPhItZ9TIAQMV4E8cY6BzKOSRwp2DmChklm3
         BInMhXqDpfC5cY1FxMaIKDE112iKjav8zo+JM9Wz/2fUuteOsupOANrsODshQuy1jkcU
         uvaaMGTDA7UpWMMdSfxsap8vdZXEDPHpBJNpSnPDK1ydaxuDBSK7Onhnl4EyMVAWkTw1
         ROpwdz2fuPBMvEwZNMw3mBaZml6JytC5RxC9Qblk15MH4J1rcJZdfHE/CXkxX/ykx0Vw
         WYzA==
X-Gm-Message-State: APjAAAWrJ/P3v2O0acvCXKmRn0TcAAvyXmOeIAQ3xgA/ydY1tDf5rYh2
        OvHywFVSn+97Cc8svGms+Zc=
X-Google-Smtp-Source: APXvYqzjTfTrizxwR+FcWXv0mTeH4pRqXqglDldeFZlk+MKSn4zXqyuX5CxXi5slDrmJhvdjEzMzAg==
X-Received: by 2002:aa7:9145:: with SMTP id 5mr861278pfi.74.1578425143824;
        Tue, 07 Jan 2020 11:25:43 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c2sm329051pjq.27.2020.01.07.11.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 11:25:43 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 3/4] ufs: Simplify two tests
Date:   Tue,  7 Jan 2020 11:25:30 -0800
Message-Id: <20200107192531.73802-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
In-Reply-To: <20200107192531.73802-1-bvanassche@acm.org>
References: <20200107192531.73802-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lrbp->cmd is set only for SCSI commands. Use this knowledge to simplify
two boolean expressions.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6f55d72e7fdd..15e65248597d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2474,7 +2474,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	/* issue command to the controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
+	ufshcd_vops_setup_xfer_req(hba, tag, true);
 	ufshcd_send_command(hba, tag);
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -2661,7 +2661,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 	/* Make sure descriptors are ready before ringing the doorbell */
 	wmb();
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_vops_setup_xfer_req(hba, tag, (lrbp->cmd ? true : false));
+	ufshcd_vops_setup_xfer_req(hba, tag, false);
 	ufshcd_send_command(hba, tag);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
