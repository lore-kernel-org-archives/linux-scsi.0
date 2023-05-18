Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F819C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 19:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjERTcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 15:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjERTcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 15:32:08 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDADE5E
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:32:07 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-64384274895so1777476b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:32:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684438326; x=1687030326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xAVBJxxiddqpj3OThYrLZRemgGSYW1XJjXqIMtpmojc=;
        b=Wi91UpMYyQHr9dxS0BDYgSJruWIoefSRp1XptBsO42FyHClbHQkT/v7OR2WXSk+x94
         pGXdggHS/lA20Z5UK4PEH2jN1IwyH4JGmVyfgrQfEyGhAFdrxkobhhVl3SYxD2PN/hQn
         Am6Iyf4Q7Qn5V+ZFLHJdMZN/DWJRM6iJIJjh8YHMu1zKx+8vxmwSXpen21IkbEbWNdF4
         ks0w4ygebYFnhqUbnK37sA+wrtUE8coKJpYA23YIE/1qoY3HXEiSUBp0TMD2JSfX2/d0
         2RS1L37bfrGGkewpEmDhzi6YaToykco+f6IKoDsKCRhjr+2nyARP4rkTodMO0MDutY/0
         GsZg==
X-Gm-Message-State: AC+VfDxznGuIjocZsvl+fSZEOsy2aZBUWIXLuCHgbik+/99RZqnXeV83
        oFjyKHsuR9Ojx18XioZyuJw=
X-Google-Smtp-Source: ACHHUZ4rY0Bcw87/WMp1tyqEmO/VpgtmZnXHG2H5df1zwzYW0Pzcw9xthYmNOkm0i03uKd7tQNe9gA==
X-Received: by 2002:a05:6a21:918b:b0:106:1f7b:27bf with SMTP id tp11-20020a056a21918b00b001061f7b27bfmr1045649pzb.18.1684438326471;
        Thu, 18 May 2023 12:32:06 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 11-20020a63050b000000b0051afa49e07asm1619047pgf.50.2023.05.18.12.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 12:32:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v4 2/3] scsi: core: Trace SCSI sense data
Date:   Thu, 18 May 2023 12:31:58 -0700
Message-ID: <20230518193159.1166304-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230518193159.1166304-1-bvanassche@acm.org>
References: <20230518193159.1166304-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a command fails, SCSI sense data is essential to determine why it
failed. Hence make the sense key, ASC and ASCQ codes available in the
ftrace output.

Cc: Niklas Cassel <niklas.cassel@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/trace/events/scsi.h | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
index a2c7befd451a..8e2d9b1b0e77 100644
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
+		  "result=(driver=%s host=%s message=%s status=%s) "
+		  "sense=(key=%#x asc=%#x ascq=%#x)",
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
