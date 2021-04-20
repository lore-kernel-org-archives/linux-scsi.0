Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B246C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50961613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhDTAKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:09 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:40632 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbhDTAJy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:54 -0400
Received: by mail-pf1-f182.google.com with SMTP id a12so24310466pfc.7
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SsLXhOzfHBDNZCZ7nQTSILMlUeGYRY2L9BeG/9n7EB0=;
        b=novhX6Uh9MoNBUPAXGS4zi84yvQZD4rd7NVLBUTjh6QMPzHA9pM3d51H1sF5wjkK6l
         vXX7aIep7hFpcFuUk/UGQkKGrAE5vAAUWHbJ3VnXYPbUtFBnQJgyiGJW4SbeSbrTuPsT
         eOgW1byI9tM+pQB/139i0aOZOSLeb9toS44ZJlNZNZqiEKO0W2piSSPKoQoRX0HpF/Qg
         63RFZIAp0cktQ1OQSPLC6X8j4ZaoRDQ4Da15qwibXmw+8a8djDMEPcU5g30ZT/0S6/KA
         uU1fk+BogFVvWYqoMVhz3ElTAjGx9Jao5CCprfn/7cerjpsD3sg52sH2qqCT7pAXs6+X
         fjyA==
X-Gm-Message-State: AOAM533yZhbDsR5xNzlXNBVIBhR5IfyQXs/CkESuQpqR5R+fjwizKMzC
        kSrcQHN13Sdlo3BJvPLy8kI=
X-Google-Smtp-Source: ABdhPJzflTSorFy+QVf49kfd1b7lJ7lx3nA0gLLTIb2CxbmFyzmYfaJUyHgnOv3qbREHmAh3KP8arQ==
X-Received: by 2002:a63:c806:: with SMTP id z6mr13877527pgg.240.1618877362376;
        Mon, 19 Apr 2021 17:09:22 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:21 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 026/117] acornscsi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:14 -0700
Message-Id: <20210420000845.25873-27-bvanassche@acm.org>
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
 drivers/scsi/arm/acornscsi.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 912828d1dcad..dd111ec4d7db 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -168,7 +168,7 @@ unsigned int sdtr_period = SDTR_PERIOD;
 unsigned int sdtr_size   = SDTR_SIZE;
 
 static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
-			   unsigned int result);
+			   enum host_status result);
 static int acornscsi_reconnect_finish(AS_Host *host);
 static void acornscsi_dma_cleanup(AS_Host *host);
 static void acornscsi_abortcmd(AS_Host *host, unsigned char tag);
@@ -773,14 +773,13 @@ intr_ret_t acornscsi_kick(AS_Host *host)
     return INTR_PROCESSING;
 }    
 
-/*
- * Function: void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp, unsigned int result)
- * Purpose : complete processing for command
- * Params  : host   - interface that completed
- *	     result - driver byte of result
+/**
+ * acornscsi_done - complete processing for command
+ * @host: interface that completed
+ * @result: host status byte (DID_...)
  */
 static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
-			   unsigned int result)
+			   enum host_status result)
 {
 	struct scsi_cmnd *SCpnt = *SCpntp;
 
@@ -794,7 +793,9 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 
 	acornscsi_dma_cleanup(host);
 
-	SCpnt->result = result << 16 | host->scsi.SCp.Message << 8 | host->scsi.SCp.Status;
+	SCpnt->status = (union scsi_status){
+		.b.host = result, .b.msg = host->scsi.SCp.Message,
+		.b.status = host->scsi.SCp.Status};
 
 	/*
 	 * In theory, this should not happen.  In practice, it seems to.
@@ -833,7 +834,7 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 			xfer_warn = 0;
 
 		if (xfer_warn) {
-		    switch (status_byte(SCpnt->result)) {
+		    switch (status_byte(SCpnt->status)) {
 		    case CHECK_CONDITION:
 		    case COMMAND_TERMINATED:
 		    case BUSY:
@@ -844,7 +845,7 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 		    default:
 			scmd_printk(KERN_ERR, SCpnt,
 				    "incomplete data transfer detected: "
-				    "result=%08X", SCpnt->result);
+				    "result=%08X", SCpnt->status.combined);
 			scsi_print_command(SCpnt);
 			acornscsi_dumpdma(host, "done");
 			acornscsi_dumplog(host, SCpnt->device->id);
@@ -2470,7 +2471,7 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
     if (acornscsi_cmdtype(SCpnt->cmnd[0]) == CMD_WRITE && (NO_WRITE & (1 << SCpnt->device->id))) {
 	printk(KERN_CRIT "scsi%d.%c: WRITE attempted with NO_WRITE flag set\n",
 	    host->host->host_no, '0' + SCpnt->device->id);
-	SCpnt->result = DID_NO_CONNECT << 16;
+	SCpnt->status.combined = DID_NO_CONNECT << 16;
 	done(SCpnt);
 	return 0;
     }
@@ -2478,7 +2479,7 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
 
     SCpnt->scsi_done = done;
     SCpnt->host_scribble = NULL;
-    SCpnt->result = 0;
+    SCpnt->status.combined = 0;
     SCpnt->tag = 0;
     SCpnt->SCp.phase = (int)acornscsi_datadirection(SCpnt->cmnd[0]);
     SCpnt->SCp.sent_command = 0;
@@ -2492,7 +2493,7 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
 	unsigned long flags;
 
 	if (!queue_add_cmd_ordered(&host->queues.issue, SCpnt)) {
-	    SCpnt->result = DID_ERROR << 16;
+	    SCpnt->status.combined = DID_ERROR << 16;
 	    done(SCpnt);
 	    return 0;
 	}
@@ -2523,7 +2524,7 @@ static inline void acornscsi_reportstatus(struct scsi_cmnd **SCpntp1,
     if (SCpnt) {
 	*SCpntp1 = NULL;
 
-	SCpnt->result = result;
+	SCpnt->status.combined = result;
 	SCpnt->scsi_done(SCpnt);
     }
 
