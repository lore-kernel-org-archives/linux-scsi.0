Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4592C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 20:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344067AbiFTU0k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 16:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244958AbiFTU0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 16:26:39 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32D61705E
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2022 13:26:27 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 11-20020aa7914b000000b00524db3e97e5so3300995pfi.10
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jun 2022 13:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5iQ5VRceLe2ANQLnXWJx9ZD5zDnLXszAF4Y85650zgU=;
        b=Y8+6+muCIJn6owuUt+U4Z/CX+GXRq6IdcSs0gbHJ3ZEhVaT6gDuPs+MqBOTn3fsyt+
         bpi9TKegvezlcg7qNoGd72E/HfHLW1p27Jfd7tQ8n5tP8/J3mL+3H4heUMa5ITlkPD2q
         ZYV4dUmfsS9z2zFTz+gEvX/lZvtTcB9TdCz0LbrAtxNBd+rRcT8dWMJNggemMhZyvTbh
         6CDq76eLwSi/yR+borqUflKULlr680JDYF0jnGVmn+/pcGLfr6fl1zJJxoM8qal7irnt
         WfgnTCsvCSrp4l4u8f7a47iapf+EzmHfxHNVVrxC6cwhr6E+s3aDZ/KPLhwHFoUyg47T
         bzkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5iQ5VRceLe2ANQLnXWJx9ZD5zDnLXszAF4Y85650zgU=;
        b=vK2avszQPwtOU+baX+vii5R1K8KUd9f0FgDrr9PmYoTXQtGfS9seSNwPX8vojSUFYK
         P0OxvuxsGegzG0Xpc4imOBaCdIs4GQ2igJOz9Sd4847OfKHJpfVKbcQYuZBnLH78CJGO
         bhzi5UB4p7dvVq/ha/7ktr/5doCeG+sRQIqjBI0ziKDgxQrVrbJWPavXMk5o11Vj1YUf
         drdr/hh+1Rucr7vWskW7bWJROCAKL4d9UbO/Y+0n/MhY0/2mAI+v/QNhmSuK46zPjdJe
         2Tj9y/tU0GneUuWe7iXa8blPViRAQk/7yaQ8sAxQeu+eRAQGjDc5ToOrYERI8zguucHQ
         qQgg==
X-Gm-Message-State: AJIora+A6I+376B3ZsM1+636i1P1QVPYwztm46XWyB5IHLFwvI19DGFr
        QXZznRwzNu80X76jMaMO1nnXcl9Q1Q8TVbXX
X-Google-Smtp-Source: AGRyM1uZtNofEgefbou6U5chFdJvzCJNQ6HDBAkS0CMXSxl1yJoJWmnbP9Z6Krt+s1rLzw4VYng1SslcdIUbSb72
X-Received: from changyuanl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c46])
 (user=changyuanl job=sendgmr) by 2002:a17:90a:738d:b0:1ea:c598:20b3 with SMTP
 id j13-20020a17090a738d00b001eac59820b3mr38391618pjg.88.1655756787096; Mon,
 20 Jun 2022 13:26:27 -0700 (PDT)
Date:   Mon, 20 Jun 2022 20:26:02 +0000
Message-Id: <20220620202602.2805912-1-changyuanl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH] trace: events: scsi: Print driver_tag and scheduler_tag in
 SCSI trace
From:   Changyuan Lyu <changyuanl@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        Rajat Jain <rajatja@google.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Changyuan Lyu <changyuanl@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Traces like scsi_dispatch_cmd_start and scsi_dispatch_cmd_done are
useful for tracking a command thoughout its lifetime. But for some ATA
passthrough commands, the information printed in current logs are not
enough to identify and match them. For example, if two threads send
SMART cmd to the same disk at the same time, their trace logs may
look the same, which makes it hard to match scsi_dispatch_cmd_done and
scsi_dispatch_cmd_start. Printing tags can help us solve the problem.
Further, if a command failed for some reason and then retried, its
driver_tag will change. So scheduler_tag is also included such that we
can track the retries of a command.

Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Reviewed-by: Jolly Shah <jollys@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
---
 include/trace/events/scsi.h | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index 370ade0d4093..a2c7befd451a 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -166,6 +166,8 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		__field( unsigned int,	lun	)
 		__field( unsigned int,	opcode	)
 		__field( unsigned int,	cmd_len )
+		__field( int,	driver_tag)
+		__field( int,	scheduler_tag)
 		__field( unsigned int,	data_sglen )
 		__field( unsigned int,	prot_sglen )
 		__field( unsigned char,	prot_op )
@@ -179,6 +181,8 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 		__entry->lun		= cmd->device->lun;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
+		__entry->driver_tag	= scsi_cmd_to_rq(cmd)->tag;
+		__entry->scheduler_tag	= scsi_cmd_to_rq(cmd)->internal_tag;
 		__entry->data_sglen	= scsi_sg_count(cmd);
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		__entry->prot_op	= scsi_get_prot_op(cmd);
@@ -186,11 +190,11 @@ TRACE_EVENT(scsi_dispatch_cmd_start,
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
-		  " prot_op=%s cmnd=(%s %s raw=%s)",
+		  " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
-		  show_prot_op_name(__entry->prot_op),
-		  show_opcode_name(__entry->opcode),
+		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
+		  __entry->scheduler_tag, show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len))
 );
@@ -209,6 +213,8 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		__field( int,		rtn	)
 		__field( unsigned int,	opcode	)
 		__field( unsigned int,	cmd_len )
+		__field( int,	driver_tag)
+		__field( int,	scheduler_tag)
 		__field( unsigned int,	data_sglen )
 		__field( unsigned int,	prot_sglen )
 		__field( unsigned char,	prot_op )
@@ -223,6 +229,8 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 		__entry->rtn		= rtn;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
+		__entry->driver_tag	= scsi_cmd_to_rq(cmd)->tag;
+		__entry->scheduler_tag	= scsi_cmd_to_rq(cmd)->internal_tag;
 		__entry->data_sglen	= scsi_sg_count(cmd);
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		__entry->prot_op	= scsi_get_prot_op(cmd);
@@ -230,11 +238,12 @@ TRACE_EVENT(scsi_dispatch_cmd_error,
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u" \
-		  " prot_op=%s cmnd=(%s %s raw=%s) rtn=%d",
+		  " prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s)" \
+		  " rtn=%d",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
-		  show_prot_op_name(__entry->prot_op),
-		  show_opcode_name(__entry->opcode),
+		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
+		  __entry->scheduler_tag, show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __entry->rtn)
@@ -254,6 +263,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__field( int,		result	)
 		__field( unsigned int,	opcode	)
 		__field( unsigned int,	cmd_len )
+		__field( int,	driver_tag)
+		__field( int,	scheduler_tag)
 		__field( unsigned int,	data_sglen )
 		__field( unsigned int,	prot_sglen )
 		__field( unsigned char,	prot_op )
@@ -268,19 +279,21 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__entry->result		= cmd->result;
 		__entry->opcode		= cmd->cmnd[0];
 		__entry->cmd_len	= cmd->cmd_len;
+		__entry->driver_tag	= scsi_cmd_to_rq(cmd)->tag;
+		__entry->scheduler_tag	= scsi_cmd_to_rq(cmd)->internal_tag;
 		__entry->data_sglen	= scsi_sg_count(cmd);
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		__entry->prot_op	= scsi_get_prot_op(cmd);
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
 	),
 
-	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u " \
-		  "prot_sgl=%u prot_op=%s cmnd=(%s %s raw=%s) result=(driver=" \
-		  "%s host=%s message=%s status=%s)",
+	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
+		  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
+		  "result=(driver=%s host=%s message=%s status=%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
-		  show_prot_op_name(__entry->prot_op),
-		  show_opcode_name(__entry->opcode),
+		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
+		  __entry->scheduler_tag, show_opcode_name(__entry->opcode),
 		  __parse_cdb(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  __print_hex(__get_dynamic_array(cmnd), __entry->cmd_len),
 		  "DRIVER_OK",
-- 
2.37.0.rc0.104.g0611611a94-goog

