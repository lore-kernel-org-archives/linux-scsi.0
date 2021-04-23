Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57B82C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23C9A61139
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242301AbhDWLkr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:40:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:46938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236905AbhDWLkd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 319B9B113;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/39] scsi: introduce scsi_status_is_check_condition()
Date:   Fri, 23 Apr 2021 13:39:12 +0200
Message-Id: <20210423113944.42672-8-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423113944.42672-1-hare@suse.de>
References: <20210423113944.42672-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a helper function scsi_status_is_check_condtion() to
encapsulate the frequent checks for SAM_STAT_CHECK_CONDITION.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |  2 +-
 drivers/scsi/scsi.c              |  2 +-
 drivers/scsi/scsi_error.c        |  4 ++--
 drivers/scsi/scsi_lib.c          |  2 +-
 include/scsi/scsi.h              | 14 ++++++++++++++
 5 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index f33f56680c59..9e229a1a4965 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1005,7 +1005,7 @@ static void handle_cmd_rsp(struct srp_event_struct *evt_struct)
 	
 	if (cmnd) {
 		cmnd->result |= rsp->status;
-		if (((cmnd->result >> 1) & 0x1f) == CHECK_CONDITION)
+		if (scsi_status_is_check_condition(cmnd->result))
 			memcpy(cmnd->sense_buffer,
 			       rsp->data,
 			       be32_to_cpu(rsp->sense_data_len));
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 99dc6ec0b6e5..1ce46e6e6483 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -144,7 +144,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 		    (level > 1)) {
 			scsi_print_result(cmd, "Done", disposition);
 			scsi_print_command(cmd);
-			if (status_byte(cmd->result) == CHECK_CONDITION)
+			if (scsi_status_is_check_condition(cmd->result))
 				scsi_print_sense(cmd);
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d8fafe77dbbe..0967021cc06e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1258,7 +1258,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 					     current->comm));
 			break;
 		}
-		if (status_byte(scmd->result) != CHECK_CONDITION)
+		if (!scsi_status_is_check_condition(scmd->result))
 			/*
 			 * don't request sense if there's no check condition
 			 * status because the error we're processing isn't one
@@ -1774,7 +1774,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
 	}
 
-	if (status_byte(scmd->result) != CHECK_CONDITION)
+	if (!scsi_status_is_check_condition(scmd->result))
 		return 0;
 
 check_type:
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d72f15f6c225..488bc49afa76 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2232,7 +2232,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
 		}
 		data->header_length = header_length;
 		result = 0;
-	} else if ((status_byte(result) == CHECK_CONDITION) &&
+	} else if (scsi_status_is_check_condition(result) &&
 		   scsi_sense_valid(sshdr) &&
 		   sshdr->sense_key == UNIT_ATTENTION && retry_count) {
 		retry_count--;
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index d0a24e55ad63..4ff4b45c19f3 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -58,6 +58,20 @@ static inline int scsi_status_is_good(int status)
 		(status == SAM_STAT_COMMAND_TERMINATED));
 }
 
+/** scsi_status_is_check_condition - check the status return.
+ *
+ * @status: the status passed up from the driver (including host and
+ *          driver components)
+ *
+ * This returns true if the status code is SAM_STAT_CHECK_CONDITION.
+ */
+static inline int scsi_status_is_check_condition(int status)
+{
+	if (status < 0)
+		return false;
+	status &= 0xfe;
+	return (status == SAM_STAT_CHECK_CONDITION);
+}
 
 /*
  * standard mode-select header prepended to all mode-select commands
-- 
2.29.2

