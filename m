Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E3DC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jun 2022 18:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346495AbiFUSMj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 14:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbiFUSMg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 14:12:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0EC1A3B3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 11:12:33 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u6-20020a63d346000000b00407d7652203so7941426pgi.18
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 11:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FqQrBQnwBWiyEfWcAHR/gdLl+1RDZ3QpB8RKYixKnwo=;
        b=afegifJ6B86Z1T9RvMi2apC5KcQutcyEAPlDpR0Xo4jcjRp1XSY5WVJxDb7Ww8cMbA
         Vtn1oB8j3hA/y8wlP++pVyy6y9ntY2pAr09AZ6YbfVNkCtP4xzwLyQFRj7h68137o1gv
         QhZUvN+8kRs4c2XMMGkYCLeRqBVkUbq7v/m5djh1kFfg9U96cIuNwHwh+rp7KzLpsgKE
         YTeu5et9tmVGJeO6kqCSKv/nnNBhc9ZMBt8m6GIMbBI8HFe4SPLvxempIZni1L6HlPeY
         qK5e3lUEQZ54ojYSbUTKmstgxUD55fw5yNBLmEXWDotQPUw6x2ic5Dh0VYk6r2ZlcNzi
         H4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FqQrBQnwBWiyEfWcAHR/gdLl+1RDZ3QpB8RKYixKnwo=;
        b=WGsGwbicMKonyYqLRCZF/U0sL/zll0C/sBY0S3YX4Ix4hmKiaVjo4irkVupiQDCH9M
         KQOl1FLKv00p9Dwbyk9Xl1Wg0L+XcGoepNIn//mKeU5fTFeULUsBbZowFLBsASs7uJc+
         7VnoqLCHqho06sGkwL/DkV+RKukLZDAn3BIoi9XFEaBLXKecjmGs8UXFpaoJPq/jlLHR
         p6yJ3PEVPMAd/SCDuF+5MQCh7pyzBr+x5OHzjNaJ4Y0Mjr5I/kzMMrpc6T36q1+htynf
         uy12JX6JxMm3sAjWXOhr6I0YPw70genvAWzqG43XDYZ748AR7kwgaZRwMxYWgV/+J0lY
         Wbgw==
X-Gm-Message-State: AJIora9TK+DmjNp4ULNZLxyobOERGriIB2W8StaY+CcNorkY4nnsk4IV
        W8YWdV9dkR3fxHRmj9mUXDdVRlDjyRnGvEhx
X-Google-Smtp-Source: AGRyM1vnLDqototThwuSka7QlKuznyT3JSG5iQ4tfrOrphJy/DP6gE+BMbYwzXydYcnaOCpPAXoy1WubhSbN3zPZ
X-Received: from changyuanl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c46])
 (user=changyuanl job=sendgmr) by 2002:a05:6a00:2af:b0:525:13b0:4099 with SMTP
 id q15-20020a056a0002af00b0052513b04099mr17811301pfs.71.1655835153109; Tue,
 21 Jun 2022 11:12:33 -0700 (PDT)
Date:   Tue, 21 Jun 2022 18:11:25 +0000
In-Reply-To: <f21b7a51-ccb0-b8dc-a48e-94a7a0f7e125@acm.org>
Message-Id: <20220621181125.3211399-1-changyuanl@google.com>
Mime-Version: 1.0
References: <f21b7a51-ccb0-b8dc-a48e-94a7a0f7e125@acm.org>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH v2] trace: events: scsi: Print driver_tag and scheduler_tag in
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

Trace events like scsi_dispatch_cmd_start and scsi_dispatch_cmd_done
are useful for tracking a command throughout its lifetime. But for
some ATA passthrough commands, the information printed in current logs
is not enough to identify and match them. For example, if two threads
send SMART cmd to the same disk at the same time, their trace logs may
look the same, which makes it hard to match scsi_dispatch_cmd_done and
scsi_dispatch_cmd_start. Printing tags can help us solve the problem.
Further, if a command failed for some reason and then is retried, its
driver_tag will change. So scheduler_tag is also included such that we
can track the retries of a command.

Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Reviewed-by: Jolly Shah <jollys@google.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>

---
v2: fixed typos and misuse of terminology in the commit message.
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

