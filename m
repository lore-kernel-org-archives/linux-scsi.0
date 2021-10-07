Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFA9C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3F2B60FDC
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241394AbhJGUtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:49:00 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:33423 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240950AbhJGUs7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:59 -0400
Received: by mail-pg1-f178.google.com with SMTP id a73so1009712pge.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:47:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NW89UCsruiaT0nRzaMzqCEJ4JJbwzibSuaRwlO8fl7s=;
        b=3+T5xfN1cuZHI3jOI1byPEyFEQ1WGYe7Yznat3Kr3l5d7RglTeobEf9zdhHxk3JrOk
         x4YzI4ACKYLEKDpqHV+aEB0Um34qLB8plIfr1YIeolbgsygyEUmJn2WPbk64Ql+CCvlU
         OVMsIoDybHFfFUpWx9NpbT9I+n8NuQp5qAD3SVy2fTaaL7gfIDQ4/+9XI6cQn0g9jVp3
         QS2rUC9oPvHH86bEt3GB9JnCi4wQa9ASGSXhRi3b3EEw4a3IVHgQ/bcq5eLaSZ8Ld6pL
         XlrbQnyX5aItar/DSos2sKtFy/O1jfZ6gGkyaZIgQXBiX3F1Wb3SPa4TtNk02UxAKKer
         Xl0Q==
X-Gm-Message-State: AOAM530Ua+zCf0VNHTxDsrUzVFbUriHYbsePUcepg9rs0QBYW0PCW8CP
        RzTJ8Wz8C5bfaljyoel9yBM=
X-Google-Smtp-Source: ABdhPJwS7fXv4pTigtzmD4jNxdDDhO9oyqDt58guBW0etcYSOdd/8XqEWlf7T3QtaUdvIxncQOzA/Q==
X-Received: by 2002:aa7:843b:0:b0:44c:53b8:54bd with SMTP id q27-20020aa7843b000000b0044c53b854bdmr6225976pfn.22.1633639624825;
        Thu, 07 Oct 2021 13:47:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:47:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v3 87/88] fas216: Introduce the function fas216_queue_command_internal()
Date:   Thu,  7 Oct 2021 13:46:13 -0700
Message-Id: <20211007204618.2196847-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but prepares for removal of
the second argument of the fas216_queue_command_lck() function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/fas216.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 9926383f79ea..285980b9257d 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2186,7 +2186,7 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 }
 
 /**
- * fas216_queue_command - queue a command for adapter to process.
+ * fas216_queue_command_internal - queue a command for the adapter to process
  * @SCpnt: Command to queue
  * @done: done function to call once command is complete
  *
@@ -2194,8 +2194,8 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
  * Returns: 0 on success, else error.
  * Notes: io_request_lock is held, interrupts are disabled.
  */
-static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
-			 void (*done)(struct scsi_cmnd *))
+static int fas216_queue_command_internal(struct scsi_cmnd *SCpnt,
+					 void (*done)(struct scsi_cmnd *))
 {
 	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
 	int result;
@@ -2235,6 +2235,12 @@ static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
 	return result;
 }
 
+static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
+				    void (*done)(struct scsi_cmnd *))
+{
+	return fas216_queue_command_internal(SCpnt, done);
+}
+
 DEF_SCSI_QCMD(fas216_queue_command)
 
 /**
@@ -2274,7 +2280,7 @@ static int fas216_noqueue_command_lck(struct scsi_cmnd *SCpnt,
 	BUG_ON(info->scsi.irq);
 
 	info->internal_done = 0;
-	fas216_queue_command_lck(SCpnt, fas216_internal_done);
+	fas216_queue_command_internal(SCpnt, fas216_internal_done);
 
 	/*
 	 * This wastes time, since we can't return until the command is
