Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2563AC77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236478AbjDYXgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbjDYXgQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:36:16 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126D013C2B
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:14 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso4662819b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:36:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465773; x=1685057773;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=92uW4VettcBxSczQVNS605VokDV2BXIWG/ibDraA1Ck=;
        b=VR/Dp3JHOjjHc7yyLNYrSjH/zcO31Sk6PNFQ4oprM1LgI/qCRiWyH9kU2oyx3g5A+n
         N24MrUFho+94/H6cqCxPMG2j6rMBXuVzDFpr5gMPXmYf9jTiWxl45ePKdUTcPjG0z+ij
         4c4Qjz6LgJBv6XpFKPXH8IQt50eobK89cHXTljMDrPrLx4SOSRZUuc2m/30bmwv5ZdKR
         KKWXZ7bHjhaPMqFdb9xwdD8vFNiSPcQMGarIKp2IksyfXvPSws1tc6yonEisqKFlnLFT
         jpspX+0ptt0AK5toA0Qkq/N7t2VM2TELDGDWrxcy1fFgbChZhhNcovD5L/9YkytoQntL
         EpOA==
X-Gm-Message-State: AAQBX9d27h7/a1jlZvutz+lngWYCIRdlqGMBu8CFPUtFPJDbcJKZNay6
        QEjdqKfwPzOzn21sJSa6s3k=
X-Google-Smtp-Source: AKy350YpiMnTEv1BKbuA2dYbLBVhNmZ8yyUybRKQ0JTOAXofEq0vZ8rIPI1eIZNFE21Br61XXw8pPA==
X-Received: by 2002:a05:6a00:2e0e:b0:63f:1037:cc24 with SMTP id fc14-20020a056a002e0e00b0063f1037cc24mr25003774pfb.32.1682465773409;
        Tue, 25 Apr 2023 16:36:13 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5099:ad7c:6c1:9570])
        by smtp.gmail.com with ESMTPSA id j12-20020a056a00174c00b00634b91326a9sm10146984pfc.143.2023.04.25.16.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:36:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>,
        Changyuan Lyu <changyuanl@google.com>
Subject: [PATCH 4/4] scsi: Trace SCSI sense data
Date:   Tue, 25 Apr 2023 16:34:46 -0700
Message-ID: <20230425233446.1231000-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230425233446.1231000-1-bvanassche@acm.org>
References: <20230425233446.1231000-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a command fails, SCSI sense data is essential to determine why it
failed. Hence make the SCSI sense data available in the ftrace output.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/trace/events/scsi.h | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index a2c7befd451a..bb5f31504fbb 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -269,6 +269,7 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__field( unsigned int,	prot_sglen )
 		__field( unsigned char,	prot_op )
 		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
+		__array(unsigned char,  sense_data, SCSI_SENSE_BUFFERSIZE)
 	),
 
 	TP_fast_assign(
@@ -285,11 +286,13 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		__entry->prot_op	= scsi_get_prot_op(cmd);
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
+		memcpy(__entry->sense_data, cmd->sense_buffer,
+		       SCSI_SENSE_BUFFERSIZE);
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
 		  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
-		  "result=(driver=%s host=%s message=%s status=%s)",
+		  "result=(driver=%s host=%s message=%s status=%s%s%s)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
 		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
@@ -299,7 +302,17 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		  "DRIVER_OK",
 		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
 		  "COMMAND_COMPLETE",
-		  show_statusbyte_name(__entry->result & 0xff))
+		  show_statusbyte_name(__entry->result & 0xff),
+		  __entry->result & 0xff ? " sense_data=" : "",
+		  __entry->result & 0xff ?
+		  ({
+			  unsigned int len = SCSI_SENSE_BUFFERSIZE;
+
+			  while (len && __entry->sense_data[len - 1] == 0)
+				  len--;
+			  __print_hex(__entry->sense_data, len);
+		  })
+		  : "")
 );
 
 DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
