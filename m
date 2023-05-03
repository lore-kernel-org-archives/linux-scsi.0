Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11963C7EE22
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 23:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjECXHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 19:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjECXHL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 19:07:11 -0400
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3485FD9
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 16:07:09 -0700 (PDT)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6434440970fso1227145b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 May 2023 16:07:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683155229; x=1685747229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lS45RwGzpfQScxIsuwNK9a/5ru5hJsJ1h3N/+B0Yxs=;
        b=ge+4bconW8gWVC8FI4fxEUnA33PUYeGw7F0zzn2p196i1AYUIaXNgPqtNgOCTDqrVa
         btGhhK2EPHoMtQMuSrgeBMXWZBiRxo8wPqSt5ThwlC9n/x7xqk9uEDmpKNaUoScPpi4p
         RyKRx/cScM5QZ90JIrMm4MBhuodV2J/n6WKsYpfmMhfQDYYLqYEguE2FLkm9iHdYCEYj
         8PO9DBYe3R61eh347xox6XeoNG9q15a2GHEqEpqV6AHQ6p13xlV8ZLZB59IYNfq2PcpO
         /XcjSR3UHUD08QYgPoY9l8DFjVRsYDDfkLyUUIhfcozJnpnWY+8e5kvQrr7atxg587Lx
         z1cA==
X-Gm-Message-State: AC+VfDw80x7Dkgy+2muJpQC/pHVLOxUt2ieQKGZKsayQq0IBh7vCJgf0
        MGBcSWvdO3sTJsoHT5rw1mo=
X-Google-Smtp-Source: ACHHUZ42osZK7qUWgtXxU1e5D2yr9VPzMA6tsD2dXGbIIhKDeKv5A++IdT+hcnMf6c3FSmIAK/BBHA==
X-Received: by 2002:a05:6a00:21ce:b0:641:3fa1:bf7f with SMTP id t14-20020a056a0021ce00b006413fa1bf7fmr228194pfj.20.1683155229286;
        Wed, 03 May 2023 16:07:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2c3b:81e:ce21:2437])
        by smtp.gmail.com with ESMTPSA id u3-20020a056a00158300b0063f3aac78b9sm19531603pfk.79.2023.05.03.16.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 16:07:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Changyuan Lyu <changyuanl@google.com>,
        Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>
Subject: [PATCH v2 3/5] scsi: core: Trace SCSI sense data
Date:   Wed,  3 May 2023 16:06:52 -0700
Message-ID: <20230503230654.2441121-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
In-Reply-To: <20230503230654.2441121-1-bvanassche@acm.org>
References: <20230503230654.2441121-1-bvanassche@acm.org>
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
index a2c7befd451a..6c4be1ebe268 100644
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
+		  "sense_key=%u asc=%#x ascq=%#x))",
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
