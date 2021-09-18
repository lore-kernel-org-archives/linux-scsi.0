Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 395D0C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25A7E60F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243807AbhIRAIB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:08:01 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:33430 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244959AbhIRAIA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:08:00 -0400
Received: by mail-pf1-f182.google.com with SMTP id s16so2405419pfk.0
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:06:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TrhbdQNUsYsjq8pqmtYvHS1JNRkyvpEBXeOE3cno8L4=;
        b=RdZLQKjHH8eefdTVDQCUxPm7nU8fXS6cuSdZiOj/GlNcdf4siXwfpLhgCyxEj4Qel5
         dtuMXAaaEQ0myJDQWG+Ld6691Gdo2Znlf9Qw1kOq0cNshzAS1t2ng3enSNI1Ut1MQOKc
         04Yhwr2HLoXWx18H6STISlJaZ7qSYnYzWnUkboRE1tYjEBnouqIWOy4D4ejXXisy5MTf
         o3WCU39oCWvOhYrEysPUYn+B6RFJOJQRTzO2C++3K4e0b9eHE/MSwz7OmQ/+RcdZhAn5
         ZFs/2ajq/jzUVcswhprKm2mxNoRLY7lZKV2KIHkZhv+3dhKVmDcdpB13dFH19GBvaLef
         W69Q==
X-Gm-Message-State: AOAM530S7chVuJYjkTzwtxognNV36RT8rcMwJdr/jLI7YltwFNA1NoOL
        ov1+FZRqfurFBz1QLY748ek=
X-Google-Smtp-Source: ABdhPJzZQS/MJ6c5EgtpOJ35C9dElY6oXMY5pOYWMrLvG1lopzLUijR5IkzeA8b8/yH4rnlyW6J0Xw==
X-Received: by 2002:a63:da54:: with SMTP id l20mr12169484pgj.341.1631923597059;
        Fri, 17 Sep 2021 17:06:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:06:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 16/84] aacraid: Introduce aac_scsi_done()
Date:   Fri, 17 Sep 2021 17:04:59 -0700
Message-Id: <20210918000607.450448-17-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
 
