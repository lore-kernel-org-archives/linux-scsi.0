Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F0A5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49E8F6138F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347080AbhI2WI0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:08:26 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:39691 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347084AbhI2WIT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:08:19 -0400
Received: by mail-pg1-f171.google.com with SMTP id g184so4146629pgc.6
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TrhbdQNUsYsjq8pqmtYvHS1JNRkyvpEBXeOE3cno8L4=;
        b=Z14p4ktpixONh9/q+zccgeEnMQ2yoD8bYLi83IOupB0NUT6T3TCX1T3yvXF9Z0buLS
         DdqY207VOFzJc+9pym3P4KjUx0GNmVh+GzCwN21bcwPVpX+RuhVtPUewdipLl2zDWk7S
         2R52qgXYquWm3cRDXKWURgVHWAnf2E260cuqw5A3RVa4f5iV5BqsHnKPTWVbBzJo+yIk
         2lHUeRqyDNot2SBLtIDEofY/8Q+VvBwax50focQojOUnbxIFEX0GZydEEOK2YXCv+ab/
         0MzCagv/arQq6QJAboNNlHTgnjh/c12dElty2Zt98zZZydbZi0hzv8wHjImSTAS1mieY
         Yw2Q==
X-Gm-Message-State: AOAM532axxndWXmHhPzVy1iEiFm1FYCsg2zvjD7VR/0cRpq340pnpkgc
        v6Ypu+R7eImfrmS5MC4QkLg=
X-Google-Smtp-Source: ABdhPJzjtHFF6IgK+G+wyEqBmXdt9bHatYhqdFWK25UtvNnK6rVRpXKqkYoBAThvWRjkKGsAu/q2Eg==
X-Received: by 2002:a63:7010:: with SMTP id l16mr1947471pgc.32.1632953197699;
        Wed, 29 Sep 2021 15:06:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:06:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 15/84] aacraid: Introduce aac_scsi_done()
Date:   Wed, 29 Sep 2021 15:04:51 -0700
Message-Id: <20210929220600.3509089-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes the next patch in
this series easier to read.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aacraid/aachba.c | 39 ++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index c2d6f0a9e0b1..40b86acac17b 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -517,6 +517,11 @@ int aac_get_containers(struct aac_dev *dev)
 	return status;
 }
 
+static void aac_scsi_done(struct scsi_cmnd *scmd)
+{
+	scmd->scsi_done(scmd);
+}
+
 static void get_container_name_callback(void *context, struct fib * fibptr)
 {
 	struct aac_get_name_resp * get_name_reply;
@@ -558,7 +563,7 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 	scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 
 	aac_fib_complete(fibptr);
-	scsicmd->scsi_done(scsicmd);
+	aac_scsi_done(scsicmd);
 }
 
 /*
@@ -614,7 +619,7 @@ static int aac_probe_container_callback2(struct scsi_cmnd * scsicmd)
 		return aac_scsi_cmd(scsicmd);
 
 	scsicmd->result = DID_NO_CONNECT << 16;
-	scsicmd->scsi_done(scsicmd);
+	aac_scsi_done(scsicmd);
 	return 0;
 }
 
@@ -1094,7 +1099,7 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 	scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
 
 	aac_fib_complete(fibptr);
-	scsicmd->scsi_done(scsicmd);
+	aac_scsi_done(scsicmd);
 }
 
 /*
@@ -1197,7 +1202,7 @@ static int aac_bounds_32(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba)
 		memcpy(cmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
-		cmd->scsi_done(cmd);
+		aac_scsi_done(cmd);
 		return 1;
 	}
 	return 0;
@@ -2392,7 +2397,7 @@ static void io_callback(void *context, struct fib * fibptr)
 	}
 	aac_fib_complete(fibptr);
 
-	scsicmd->scsi_done(scsicmd);
+	aac_scsi_done(scsicmd);
 }
 
 static int aac_read(struct scsi_cmnd * scsicmd)
@@ -2463,7 +2468,7 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
-		scsicmd->scsi_done(scsicmd);
+		aac_scsi_done(scsicmd);
 		return 0;
 	}
 
@@ -2489,7 +2494,7 @@ static int aac_read(struct scsi_cmnd * scsicmd)
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
 	scsicmd->result = DID_OK << 16 | SAM_STAT_TASK_SET_FULL;
-	scsicmd->scsi_done(scsicmd);
+	aac_scsi_done(scsicmd);
 	aac_fib_complete(cmd_fibcontext);
 	aac_fib_free(cmd_fibcontext);
 	return 0;
@@ -2554,7 +2559,7 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
 		       min_t(size_t, sizeof(dev->fsa_dev[cid].sense_data),
 			     SCSI_SENSE_BUFFERSIZE));
-		scsicmd->scsi_done(scsicmd);
+		aac_scsi_done(scsicmd);
 		return 0;
 	}
 
@@ -2580,7 +2585,7 @@ static int aac_write(struct scsi_cmnd * scsicmd)
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
 	scsicmd->result = DID_OK << 16 | SAM_STAT_TASK_SET_FULL;
-	scsicmd->scsi_done(scsicmd);
+	aac_scsi_done(scsicmd);
 
 	aac_fib_complete(cmd_fibcontext);
 	aac_fib_free(cmd_fibcontext);
@@ -2621,7 +2626,7 @@ static void synchronize_callback(void *context, struct fib *fibptr)
 
 	aac_fib_complete(fibptr);
 	aac_fib_free(fibptr);
-	cmd->scsi_done(cmd);
+	aac_scsi_done(cmd);
 }
 
 static int aac_synchronize(struct scsi_cmnd *scsicmd)
@@ -2688,7 +2693,7 @@ static void aac_start_stop_callback(void *context, struct fib *fibptr)
 
 	aac_fib_complete(fibptr);
 	aac_fib_free(fibptr);
-	scsicmd->scsi_done(scsicmd);
+	aac_scsi_done(scsicmd);
 }
 
 static int aac_start_stop(struct scsi_cmnd *scsicmd)
@@ -2702,7 +2707,7 @@ static int aac_start_stop(struct scsi_cmnd *scsicmd)
 	if (!(aac->supplement_adapter_info.supported_options2 &
 	      AAC_OPTION_POWER_MANAGEMENT)) {
 		scsicmd->result = DID_OK << 16 | SAM_STAT_GOOD;
-		scsicmd->scsi_done(scsicmd);
+		aac_scsi_done(scsicmd);
 		return 0;
 	}
 
@@ -3237,7 +3242,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 
 scsi_done_ret:
 
-	scsicmd->scsi_done(scsicmd);
+	aac_scsi_done(scsicmd);
 	return 0;
 }
 
@@ -3546,7 +3551,7 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 	scsicmd->result |= le32_to_cpu(srbreply->scsi_status);
 
 	aac_fib_complete(fibptr);
-	scsicmd->scsi_done(scsicmd);
+	aac_scsi_done(scsicmd);
 }
 
 static void hba_resp_task_complete(struct aac_dev *dev,
@@ -3686,7 +3691,7 @@ void aac_hba_callback(void *context, struct fib *fibptr)
 	if (fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF)
 		scsicmd->SCp.sent_command = 1;
 	else
-		scsicmd->scsi_done(scsicmd);
+		aac_scsi_done(scsicmd);
 }
 
 /**
@@ -3706,7 +3711,7 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
 	if (scmd_id(scsicmd) >= dev->maximum_num_physicals ||
 			scsicmd->device->lun > 7) {
 		scsicmd->result = DID_NO_CONNECT << 16;
-		scsicmd->scsi_done(scsicmd);
+		aac_scsi_done(scsicmd);
 		return 0;
 	}
 
@@ -3747,7 +3752,7 @@ static int aac_send_hba_fib(struct scsi_cmnd *scsicmd)
 	if (scmd_id(scsicmd) >= dev->maximum_num_physicals ||
 			scsicmd->device->lun > AAC_MAX_LUN - 1) {
 		scsicmd->result = DID_NO_CONNECT << 16;
-		scsicmd->scsi_done(scsicmd);
+		aac_scsi_done(scsicmd);
 		return 0;
 	}
 
