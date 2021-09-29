Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD81C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F22036140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347084AbhI2WIo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:44 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:35680 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347097AbhI2WIm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:42 -0400
Received: by mail-pg1-f179.google.com with SMTP id e7so4164656pgk.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0xrYKlXXqZ43nTFeMXbGnx2HnZXNL43Vi79i7MYS3Ns=;
        b=xvbBVLOYywdDYHd4gWpk4+NKXGCToMXxrmWF+usCxLTopM+PrXEm681n/Qh99X08C7
         5y4yYeMoLFSxIjfQle3/vlyvqujIn5VXS7Kd3uG8PRzs/J7bj9WdrkCQyblMZz0JvIyT
         sxnmz59VQ3vfDlfInCetYWW+dSqpZqx3zDeFTOXXSVsHiQeEiluozH1NP5rHTYfwhckq
         EXfHhxuNtIjDW43/0DybfVbYvxDFhRE34Mkkx6cSeVUh+4tWvW1hFXOST/6rjyPh91zG
         pJwNTEArzoRma9vGc/Y+gKdNSGEfISESqMt4wKLJ+57H0bi0Yn1UbBdkKkw4XMJcfz8i
         pn/Q==
X-Gm-Message-State: AOAM532eAN6xboYFH+Ys3yY95vrvUrOMQeQtTPhlWMJyVkIHjUlfrnA3
        wQ4GLibOqih4/kfj/UWhwgzkSEQKB7I=
X-Google-Smtp-Source: ABdhPJwNCyFyIY0Ux48TZmXLQybJKfd7HUbklMZkVvhZBn1XZeS6SA75LQ5C0mGmGMJRLUH0VfeR1g==
X-Received: by 2002:a63:1665:: with SMTP id 37mr1187482pgw.261.1632953221063;
        Wed, 29 Sep 2021 15:07:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v2 26/84] csiostor: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:02 -0700
Message-Id: <20210929220600.3509089-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 3b2eb6ce1fcf..3978c3d7eed5 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1720,7 +1720,7 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	}
 
 	cmnd->result = (((host_status) << 16) | scsi_status);
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 
 	/* Wake up waiting threads */
 	csio_scsi_cmnd(req) = NULL;
@@ -1748,7 +1748,7 @@ csio_scsi_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 		}
 
 		cmnd->result = (((host_status) << 16) | scsi_status);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 		csio_scsi_cmnd(req) = NULL;
 		CSIO_INC_STATS(csio_hw_to_scsim(hw), n_tot_success);
 	} else {
@@ -1876,7 +1876,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 	return rv;
 
 err_done:
-	cmnd->scsi_done(cmnd);
+	scsi_done(cmnd);
 	return 0;
 }
 
@@ -1979,7 +1979,7 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		spin_unlock_irq(&hw->lock);
 
 		cmnd->result = (DID_ERROR << 16);
-		cmnd->scsi_done(cmnd);
+		scsi_done(cmnd);
 
 		return FAILED;
 	}
