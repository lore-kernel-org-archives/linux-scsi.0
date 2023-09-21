Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A5EE7D0A2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 19:25:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjIUTZL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjIUTZK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 15:25:10 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A35103F09
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:25:03 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-690ce3c55f1so1072243b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:25:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695324303; x=1695929103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jr69ZzE96rrJ03FGKMd1mbdFXRauUkQbOQIy+kCgn0I=;
        b=Qn3cC2PFSQOOSY+ogdoPtOUFCKpZovTVQjmOvPkaF9XQgENfuA1s0ACUknKsfeq1d6
         qNhy4uFG9yzjD+tczE4dwN6CRrkzmcW4D7Fv/cv6WXPoddf6qhfCnrEIIwgc5sksOlJW
         i5EZ0lkwXXi9dRNzv64G7DFRv9QSz03vr6fNDGHDPye7gpFuUUbAEx5SiAgKmiyOukag
         rbDuIjuRjxefgbHciTe5iNxf5DiQ9TB5cHJG+6whB9+h6nV0AwnthWnHFPdxPEzOyLA3
         cgvjDhHiebSJumQGxk3e7vY5PCDUl1HReyAG/8T3r9zAth+1rHByk/+5uLQoE3ZbruuA
         lTZw==
X-Gm-Message-State: AOJu0YxPzyvIMWwmpE84bMk6hvYC4ISbcvSZ79Kz13s/7U7IYnTVdl9A
        rTLx0Ag1PgoRKGK9u2yTtu0=
X-Google-Smtp-Source: AGHT+IFCBT2nR7262Fxfz7EZHTu8U1C0KhLj6sztvsXdoICiXL8fjSVrEF7QD4DPl3Uf0AWX5QPYBA==
X-Received: by 2002:a05:6a00:88a:b0:68e:41e9:10be with SMTP id q10-20020a056a00088a00b0068e41e910bemr7603934pfj.20.1695324303200;
        Thu, 21 Sep 2023 12:25:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6903:9a1f:51f3:593e])
        by smtp.gmail.com with ESMTPSA id fm1-20020a056a002f8100b00679a4b56e41sm1760061pfb.43.2023.09.21.12.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 12:25:02 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        daejun7.park@samsung.com, John Garry <john.g.garry@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v2 1/4] scsi: ufs: Remove request tag range checks
Date:   Thu, 21 Sep 2023 12:22:46 -0700
Message-ID: <20230921192335.676924-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
In-Reply-To: <20230921192335.676924-1-bvanassche@acm.org>
References: <20230921192335.676924-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The block layer core guarantees that tag numbers are in the expected
range. Hence remove the statements that check this. This patch suppresses
Coverity warnings about left shifts with a negative right hand operand.
The following commit originally introduced request tag range checks:
14497328b6a6 ("scsi: ufs: verify command tag validity").

Cc: daejun7.park@samsung.com
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dc1285351336..f48a65fa3bf7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2822,8 +2822,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	int err = 0;
 	struct ufs_hw_queue *hwq = NULL;
 
-	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
-
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
 		break;
@@ -6923,8 +6921,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	spin_lock_irqsave(host->host_lock, flags);
 
 	task_tag = req->tag;
-	WARN_ONCE(task_tag < 0 || task_tag >= hba->nutmrs, "Invalid tag %d\n",
-		  task_tag);
 	hba->tmf_rqs[req->tag] = req;
 	treq->upiu_req.req_header.task_tag = task_tag;
 
@@ -7498,8 +7494,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	bool outstanding;
 	u32 reg;
 
-	WARN_ONCE(tag < 0, "Invalid tag %d\n", tag);
-
 	ufshcd_hold(hba);
 
 	if (!is_mcq_enabled(hba)) {
