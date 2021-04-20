Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F37AC43603
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24F626109E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhDTAK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:27 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:35791 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbhDTAKP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:15 -0400
Received: by mail-pj1-f51.google.com with SMTP id j21-20020a17090ae615b02901505b998b45so6028472pjy.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kPO8cztLzNZArvuaWUEWmi7eEIQSF001uSkhS/0DFVA=;
        b=hWdmtQQmVp7IZhsu/RNedIB2hULl1VjjO8U/DnU6U5YnTEQtj0DnbrhiclI1rAZ7RQ
         y0XHLcGdB1VIOMG7+T/8fvRJSPVPZXSfJAD1W6V6oLEMe7+mSYdc27sc6aPtqAAa3BDU
         V0KNdJjrskBKT7bHcUU2ugMnY8BMFmHEY2O9K8lAJzfADOvAAauHVXVQNIsqZVVfhdhs
         1XnVDNDTSeuiflT/t6HjKQb6P1WJBtEVAK+k6U9v+mzG5ZRJDpw+CKDsdajgJQJEAecN
         /mcQV1uzdkxmfzXVV9Ks7Z2NyEc0JJdmjBClz2C/C0YhSkY0wufm8VtE/pGtP2AS7lB0
         XLZA==
X-Gm-Message-State: AOAM531Xy+Mp+QODsE6SNMQS93bbp1FLwVpMgtxs5xvORJx0KBAiaH9Y
        Dun8LmYL6SAMaOVxdwMHZC4=
X-Google-Smtp-Source: ABdhPJxTkj8RVmO2UX+2neIPxz/1uLiAD3xA8QCEMgf0nXr8pyciv4HzUq7c3m1GOJeBBXXbtND9zw==
X-Received: by 2002:a17:902:b947:b029:ec:b04d:c8a2 with SMTP id h7-20020a170902b947b02900ecb04dc8a2mr3947676pls.2.1618877385259;
        Mon, 19 Apr 2021 17:09:45 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:44 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 046/117] fas216: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:34 -0700
Message-Id: <20210420000845.25873-47-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210420000845.25873-1-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An explanation of the purpose of this patch is available in the patch
"scsi: Introduce the scsi_status union".

Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/fas216.c | 40 ++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index b9ca25c77075..86fa59587a3b 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -399,7 +399,7 @@ static void print_debug_list(void)
 	printk("\n");
 }
 
-static void fas216_done(FAS216_Info *info, unsigned int result);
+static void fas216_done(FAS216_Info *info, enum host_status result);
 
 /**
  * fas216_get_last_msg - retrive last message from the list
@@ -1986,7 +1986,7 @@ static void fas216_kick(FAS216_Info *info)
  * Clean up from issuing a BUS DEVICE RESET message to a device.
  */
 static void fas216_devicereset_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
-				    unsigned int result)
+				    enum host_status result)
 {
 	fas216_log(info, LOG_ERROR, "fas216 device reset complete");
 
@@ -2004,7 +2004,7 @@ static void fas216_devicereset_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
  * Finish processing automatic request sense command
  */
 static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
-			       unsigned int result)
+			       enum host_status result)
 {
 	fas216_log_target(info, LOG_CONNECT, SCpnt->device->id,
 		   "request sense complete, result=0x%04x%02x%02x",
@@ -2020,7 +2020,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 //printk("scsi%d.%c: sense buffer: ", info->host->host_no, '0' + SCpnt->device->id);
 //{ int i; for (i = 0; i < 32; i++) printk("%02x ", SCpnt->sense_buffer[i]); printk("\n"); }
 	/*
-	 * Note that we don't set SCpnt->result, since that should
+	 * Note that we don't set SCpnt->status since that should
 	 * reflect the status of the command that we were asked by
 	 * the upper layers to process.  This would have been set
 	 * correctly by fas216_std_done.
@@ -2038,36 +2038,38 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
  * Finish processing of standard command
  */
 static void
-fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
+fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
+		enum host_status result)
 {
 	info->stats.fins += 1;
 
-	SCpnt->result = result << 16 | info->scsi.SCp.Message << 8 |
-			info->scsi.SCp.Status;
+	SCpnt->status = (union scsi_status){.b.host = result,
+		.b.msg = info->scsi.SCp.Message,
+		.b.status = info->scsi.SCp.Status};
 
 	fas216_log_command(info, LOG_CONNECT, SCpnt,
-		"command complete, result=0x%08x", SCpnt->result);
+		"command complete, result=0x%08x", SCpnt->status.combined);
 
 	/*
 	 * If the driver detected an error, we're all done.
 	 */
-	if (host_byte(SCpnt->result) != DID_OK ||
-	    msg_byte(SCpnt->result) != COMMAND_COMPLETE)
+	if (host_byte(SCpnt->status) != DID_OK ||
+	    msg_byte(SCpnt->status) != COMMAND_COMPLETE)
 		goto done;
 
 	/*
 	 * If the command returned CHECK_CONDITION or COMMAND_TERMINATED
 	 * status, request the sense information.
 	 */
-	if (status_byte(SCpnt->result) == CHECK_CONDITION ||
-	    status_byte(SCpnt->result) == COMMAND_TERMINATED)
+	if (status_byte(SCpnt->status) == CHECK_CONDITION ||
+	    status_byte(SCpnt->status) == COMMAND_TERMINATED)
 		goto request_sense;
 
 	/*
 	 * If the command did not complete with GOOD status,
 	 * we are all done here.
 	 */
-	if (status_byte(SCpnt->result) != GOOD)
+	if (status_byte(SCpnt->status) != GOOD)
 		goto done;
 
 	/*
@@ -2087,7 +2089,7 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 		default:
 			scmd_printk(KERN_ERR, SCpnt,
 				    "incomplete data transfer detected: res=%08X ptr=%p len=%X\n",
-				    SCpnt->result, info->scsi.SCp.ptr,
+				    SCpnt->status.combined, info->scsi.SCp.ptr,
 				    info->scsi.SCp.this_residual);
 			scsi_print_command(SCpnt);
 			set_host_byte(SCpnt, DID_ERROR);
@@ -2132,13 +2134,13 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 /**
  * fas216_done - complete processing for current command
  * @info: interface that completed
- * @result: driver byte of result
+ * @result: host byte of result
  *
  * Complete processing for current command
  */
-static void fas216_done(FAS216_Info *info, unsigned int result)
+static void fas216_done(FAS216_Info *info, enum host_status result)
 {
-	void (*fn)(FAS216_Info *, struct scsi_cmnd *, unsigned int);
+	void (*fn)(FAS216_Info *, struct scsi_cmnd *, enum host_status);
 	struct scsi_cmnd *SCpnt;
 	unsigned long flags;
 
@@ -2178,7 +2180,7 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	clear_bit(SCpnt->device->id * 8 +
 		  (u8)(SCpnt->device->lun & 0x7), info->busyluns);
 
-	fn = (void (*)(FAS216_Info *, struct scsi_cmnd *, unsigned int))SCpnt->host_scribble;
+	fn = (void *)SCpnt->host_scribble;
 	fn(info, SCpnt, result);
 
 	if (info->scsi.irq) {
@@ -2216,7 +2218,7 @@ static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
 
 	SCpnt->scsi_done = done;
 	SCpnt->host_scribble = (void *)fas216_std_done;
-	SCpnt->result = 0;
+	SCpnt->status.combined = 0;
 
 	init_SCp(SCpnt);
 
