Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C94C77B7A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 23:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjEQXKq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 19:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjEQXJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 19:09:50 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211A944A8
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:36 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6439d505274so996152b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684364975; x=1686956975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YH0YhUusr/UFgVmOgEoNP7zvykLbCuFM8H/nENdgsEQ=;
        b=jdiVuvJI/1EFZOnQHYG6y8rBgoi0HFMPyYn3Xb7Nj8fkQ80f3PMFJYnsEz3Ug4BFGc
         uAXIwrLtWm3yW1P+kZOZz+wHCvNTAAOT7IcFxgHQm1QavYqC/tqDnFaovlhQK5hKm8SL
         DJk6ZMQPXQ2RZmrrHXq2qvrAy8w5nimK3kdCUJMRApUUiqviwLNtQHm2aCq6wz5XPlka
         5yvyQcBOGd8ws/vN+hCzg8ghqhllVEfEXaUEwgbLWMN+EBnNoyTR8+EaLQJm9eAi3X5O
         q4QxGktg01HxM46mLp8Ya/PdN230GDOTCpzYDzfaGaec4gif0yIfGewZmHmksSBYss0l
         MbYw==
X-Gm-Message-State: AC+VfDy0cB0Ldn+WtP/pqAJWqwz8FQ4zmfCGBswbTtQHvwyG6jgPIxdG
        i4k0sDuziu/gg5nCIRVRCLI=
X-Google-Smtp-Source: ACHHUZ6Aqsv26aWT2AEzdgkv58smoWaLIea8/rgsnSjwxdoEsnhK0Zizv3Mh+WcG5CXN/NzBQia9/w==
X-Received: by 2002:a05:6a21:78a9:b0:102:a593:a158 with SMTP id bf41-20020a056a2178a900b00102a593a158mr35846303pzc.47.1684364975446;
        Wed, 17 May 2023 16:09:35 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e9-20020a656789000000b005286ea6190esm15080694pgr.20.2023.05.17.16.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 16:09:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 2/4] scsi: core: Trace SCSI sense data
Date:   Wed, 17 May 2023 16:09:25 -0700
Message-ID: <20230517230927.1091124-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517230927.1091124-1-bvanassche@acm.org>
References: <20230517230927.1091124-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a command fails, SCSI sense data is essential to determine why it
failed. Hence make the sense key, ASC and ASCQ codes available in the
ftrace output.

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/trace/events/scsi.h | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index a2c7befd451a..512792317577 100644
--- a/include/trace/events/scsi.h
+++ b/include/trace/events/scsi.h
@@ -269,9 +269,14 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__field( unsigned int,	prot_sglen )
 		__field( unsigned char,	prot_op )
 		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
+		__field( u8, sense_key )
+		__field( u8, asc )
+		__field( u8, ascq )
 	),
 
 	TP_fast_assign(
+		struct scsi_sense_hdr sshdr;
+
 		__entry->host_no	= cmd->device->host->host_no;
 		__entry->channel	= cmd->device->channel;
 		__entry->id		= cmd->device->id;
@@ -285,11 +290,22 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
 		__entry->prot_op	= scsi_get_prot_op(cmd);
 		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
+		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
+		    scsi_command_normalize_sense(cmd, &sshdr)) {
+			__entry->sense_key = sshdr.sense_key;
+			__entry->asc = sshdr.asc;
+			__entry->ascq = sshdr.ascq;
+		} else {
+			__entry->sense_key = 0;
+			__entry->asc = 0;
+			__entry->ascq = 0;
+		}
 	),
 
 	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
 		  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
-		  "result=(driver=%s host=%s message=%s status=%s)",
+		  "result=(driver=%s host=%s message=%s status=%s "
+		  "sense_key=%#x asc=%#x ascq=%#x)",
 		  __entry->host_no, __entry->channel, __entry->id,
 		  __entry->lun, __entry->data_sglen, __entry->prot_sglen,
 		  show_prot_op_name(__entry->prot_op), __entry->driver_tag,
@@ -299,7 +315,8 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
 		  "DRIVER_OK",
 		  show_hostbyte_name(((__entry->result) >> 16) & 0xff),
 		  "COMMAND_COMPLETE",
-		  show_statusbyte_name(__entry->result & 0xff))
+		  show_statusbyte_name(__entry->result & 0xff),
+		  __entry->sense_key, __entry->asc, __entry->ascq)
 );
 
 DEFINE_EVENT(scsi_cmd_done_timeout_template, scsi_dispatch_cmd_done,
