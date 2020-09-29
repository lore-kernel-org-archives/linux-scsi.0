Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC2CC4727C
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 13:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18674207F7
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 13:09:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="VxHBV+r7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgI2NJc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:09:32 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:55230 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbgI2NJc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 09:09:32 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 09:09:30 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 5EE024130F;
        Tue, 29 Sep 2020 13:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1601384400; x=
        1603198801; bh=7xJTnSO91QLvsgqMIur4w57ZOU8fr4C60zZVB/8GBKg=; b=V
        xHBV+r7n5Fd8rjYZbMn5gi+PryP4ynVuQSF6e4I4bwRM9as78hSOycC38Dlekt7B
        DWardyc4/WVA5yQBylLxpwy6hjeSmrrAy9px0lxFeAZRJiF7tzQDkVIrcAKjpGz0
        +j53bAHq8BrTAbHu86/dP2yJcm4ndryKMjE+BgJh9M=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id j2wPOe6E6rYS; Tue, 29 Sep 2020 16:00:00 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 2CDB9412FD;
        Tue, 29 Sep 2020 16:00:00 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 29
 Sep 2020 16:00:00 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] scsi: target: core: Add CONTROL field for trace events
Date:   Tue, 29 Sep 2020 15:59:57 +0300
Message-ID: <20200929125957.83069-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

trace-cmd report doesn't show events from target subsystem because
scsi_command_size() leaks through event format string:

  [target:target_sequencer_start] function scsi_command_size not defined
  [target:target_cmd_complete] function scsi_command_size not defined

Addition of scsi_command_size() to plugin_scsi.c in trace-cmd doesn't
help because an expression is used inside TP_printk(). trace-cmd event
parser doesn't understand minus sign inside [ ]:

  Error: expected ']' but read '-'

Rather than duplicating kernel code in plugin_scsi.c, it's better to
provide a dedicated field for CONTROL byte.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 include/scsi/scsi_common.h    |  7 +++++++
 include/trace/events/target.h | 12 ++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 731ac09ed231..5b567b43e1b1 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -25,6 +25,13 @@ scsi_command_size(const unsigned char *cmnd)
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
 
+static inline unsigned char
+scsi_command_control(const unsigned char *cmnd)
+{
+	return (cmnd[0] == VARIABLE_LENGTH_CMD) ?
+		cmnd[1] : cmnd[COMMAND_SIZE(cmnd[0]) - 1];
+}
+
 /* Returns a human-readable name for the device */
 extern const char *scsi_device_type(unsigned type);
 
diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index 77408edd29d2..67fad2677ed5 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -141,6 +141,7 @@ TRACE_EVENT(target_sequencer_start,
 		__field( unsigned int,	opcode		)
 		__field( unsigned int,	data_length	)
 		__field( unsigned int,	task_attribute  )
+		__field( unsigned char,	control		)
 		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
 		__string( initiator,	cmd->se_sess->se_node_acl->initiatorname	)
 	),
@@ -151,6 +152,7 @@ TRACE_EVENT(target_sequencer_start,
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
+		__entry->control	= scsi_command_control(cmd->t_task_cdb);
 		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
 		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
 	),
@@ -160,9 +162,7 @@ TRACE_EVENT(target_sequencer_start,
 		  __entry->tag, show_opcode_name(__entry->opcode),
 		  __entry->data_length, __print_hex(__entry->cdb, 16),
 		  show_task_attribute_name(__entry->task_attribute),
-		  scsi_command_size(__entry->cdb) <= 16 ?
-			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
-			__entry->cdb[1]
+		  __entry->control
 	)
 );
 
@@ -178,6 +178,7 @@ TRACE_EVENT(target_cmd_complete,
 		__field( unsigned int,	opcode		)
 		__field( unsigned int,	data_length	)
 		__field( unsigned int,	task_attribute  )
+		__field( unsigned char,	control		)
 		__field( unsigned char,	scsi_status	)
 		__field( unsigned char,	sense_length	)
 		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
@@ -191,6 +192,7 @@ TRACE_EVENT(target_cmd_complete,
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
+		__entry->control	= scsi_command_control(cmd->t_task_cdb);
 		__entry->scsi_status	= cmd->scsi_status;
 		__entry->sense_length	= cmd->scsi_status == SAM_STAT_CHECK_CONDITION ?
 			min(18, ((u8 *) cmd->sense_buffer)[SPC_ADD_SENSE_LEN_OFFSET] + 8) : 0;
@@ -208,9 +210,7 @@ TRACE_EVENT(target_cmd_complete,
 		  show_opcode_name(__entry->opcode),
 		  __entry->data_length, __print_hex(__entry->cdb, 16),
 		  show_task_attribute_name(__entry->task_attribute),
-		  scsi_command_size(__entry->cdb) <= 16 ?
-			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
-			__entry->cdb[1]
+		  __entry->control
 	)
 );
 
-- 
2.28.0

