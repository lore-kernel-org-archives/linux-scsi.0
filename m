Return-Path: <SRS0=jquQ=DZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA7CC43457
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A1D2207DE
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050398;
	bh=1Y3Ovy7HhS/9an9kESEToXaRzV6Qxm8CLErPUU+lu/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LlITuffr2TPrOyf8ZiKUQPDPZFQLONp7WduigIUCWjtQFy6O7uyEZu3k2S/7avl2G
	 lhi6cG+cyn1CIi4HoV/QF7tNsaCgX9u15gMyxDQ+LCVQl2DaZlaOzXD+2JfVGlAI1S
	 1yJLHxKFNkC++kuICfQ2680hHYWCELraosxd+r9A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbgJRTXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730206AbgJRTXQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 015A0207DE;
        Sun, 18 Oct 2020 19:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048995;
        bh=1Y3Ovy7HhS/9an9kESEToXaRzV6Qxm8CLErPUU+lu/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EI6Mg0LTlAp7NDP65NegVpZBXp5Anlrx8eDjAfrpDDQwcP4+uo8A5NKdZBAw/MgP9
         gt8TMoZjq1TtdoBn7N4zHoVf/93VlY+GT+XouW51x9U6Fx0+jd0FBBSVWii9rda8pL
         zm2P47sWYT2GbpIRZt2wHp3TGRDCwnAkGg0QC0I4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 33/80] scsi: target: core: Add CONTROL field for trace events
Date:   Sun, 18 Oct 2020 15:21:44 -0400
Message-Id: <20201018192231.4054535-33-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Roman Bolshakov <r.bolshakov@yadro.com>

[ Upstream commit 7010645ba7256992818b518163f46bd4cdf8002a ]

trace-cmd report doesn't show events from target subsystem because
scsi_command_size() leaks through event format string:

  [target:target_sequencer_start] function scsi_command_size not defined
  [target:target_cmd_complete] function scsi_command_size not defined

Addition of scsi_command_size() to plugin_scsi.c in trace-cmd doesn't
help because an expression is used inside TP_printk(). trace-cmd event
parser doesn't understand minus sign inside [ ]:

  Error: expected ']' but read '-'

Rather than duplicating kernel code in plugin_scsi.c, provide a dedicated
field for CONTROL byte.

Link: https://lore.kernel.org/r/20200929125957.83069-1-r.bolshakov@yadro.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/scsi_common.h    |  7 +++++++
 include/trace/events/target.h | 12 ++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 731ac09ed2313..5b567b43e1b16 100644
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
index 914a872dd3435..e87a3716b0ac9 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -140,6 +140,7 @@ TRACE_EVENT(target_sequencer_start,
 		__field( unsigned int,	opcode		)
 		__field( unsigned int,	data_length	)
 		__field( unsigned int,	task_attribute  )
+		__field( unsigned char,	control		)
 		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
 		__string( initiator,	cmd->se_sess->se_node_acl->initiatorname	)
 	),
@@ -149,6 +150,7 @@ TRACE_EVENT(target_sequencer_start,
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
+		__entry->control	= scsi_command_control(cmd->t_task_cdb);
 		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
 		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
 	),
@@ -158,9 +160,7 @@ TRACE_EVENT(target_sequencer_start,
 		  show_opcode_name(__entry->opcode),
 		  __entry->data_length, __print_hex(__entry->cdb, 16),
 		  show_task_attribute_name(__entry->task_attribute),
-		  scsi_command_size(__entry->cdb) <= 16 ?
-			__entry->cdb[scsi_command_size(__entry->cdb) - 1] :
-			__entry->cdb[1]
+		  __entry->control
 	)
 );
 
@@ -175,6 +175,7 @@ TRACE_EVENT(target_cmd_complete,
 		__field( unsigned int,	opcode		)
 		__field( unsigned int,	data_length	)
 		__field( unsigned int,	task_attribute  )
+		__field( unsigned char,	control		)
 		__field( unsigned char,	scsi_status	)
 		__field( unsigned char,	sense_length	)
 		__array( unsigned char,	cdb, TCM_MAX_COMMAND_SIZE	)
@@ -187,6 +188,7 @@ TRACE_EVENT(target_cmd_complete,
 		__entry->opcode		= cmd->t_task_cdb[0];
 		__entry->data_length	= cmd->data_length;
 		__entry->task_attribute	= cmd->sam_task_attr;
+		__entry->control	= scsi_command_control(cmd->t_task_cdb);
 		__entry->scsi_status	= cmd->scsi_status;
 		__entry->sense_length	= cmd->scsi_status == SAM_STAT_CHECK_CONDITION ?
 			min(18, ((u8 *) cmd->sense_buffer)[SPC_ADD_SENSE_LEN_OFFSET] + 8) : 0;
@@ -203,9 +205,7 @@ TRACE_EVENT(target_cmd_complete,
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
2.25.1

