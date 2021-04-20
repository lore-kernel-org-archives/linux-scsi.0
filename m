Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7C6C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B956961363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhDTAKV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:21 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:42693 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbhDTAKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:04 -0400
Received: by mail-pl1-f176.google.com with SMTP id v13so5082332ple.9
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8VlAWm93j2qjH61U7fZQAvmeRW038m4/ro9Cv0tDe0o=;
        b=nVNIzRutr59q+X8yQ1qE0dWEwl/13rVeonuWc/Ivq3Bi0rPVKIaoXUTjytlxY/sp4O
         sGhVk2ZOOEUys4xmXTgD0vTCN8pbeDmv1nDNlUp3tcV6Fk0Om7K4BRKIPgv4mahckIlN
         leEc4C53X7pFJ+OL63jGx6thaCQ8EYiIWi76kV4f1giMUL1ht3/xY1WFfXsIyqmF47ES
         jQmvjj1nF111x4hB5oI0n/E+/JmOHU9nWqBCAASMLeqD2Iu11X0CHaSJXMY1BIPIpiU+
         3gxLWvcO7mAFEAIGabSK+7Rob1yKRNkJF/f3k7cfSBapjAeakWX/FIhJsDliKnUobtxi
         BU2Q==
X-Gm-Message-State: AOAM530EtOqPJN8avsNOQgf6clm0ewYRWDVrpR2kvq3Ultr3L7b7ve7D
        gK1dqSWGW381bLKe0NlEZ3yrepSL2YRXvA==
X-Google-Smtp-Source: ABdhPJzg1S0PBqx4gil/KHaLWS3o5HwscU6Htmjtggseqxng1BkC20bidVbHLLc5cFCp3ah/6eXMOA==
X-Received: by 2002:a17:90a:e00f:: with SMTP id u15mr1778563pjy.26.1618877374090;
        Mon, 19 Apr 2021 17:09:34 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 036/117] bnx2fc: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:24 -0700
Message-Id: <20210420000845.25873-37-bvanassche@acm.org>
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

Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Javed Hasan <jhasan@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 1a0dc18d6915..9ae826fd3294 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -198,10 +198,10 @@ static void bnx2fc_scsi_done(struct bnx2fc_cmd *io_req, int err_code)
 		return;
 	}
 
-	sc_cmd->result = err_code << 16;
+	sc_cmd->status.combined = err_code << 16;
 
 	BNX2FC_IO_DBG(io_req, "sc=%p, result=0x%x, retries=%d, allowed=%d\n",
-		sc_cmd, host_byte(sc_cmd->result), sc_cmd->retries,
+		sc_cmd, host_byte(sc_cmd->status), sc_cmd->retries,
 		sc_cmd->allowed);
 	scsi_set_resid(sc_cmd, scsi_bufflen(sc_cmd));
 	sc_cmd->SCp.ptr = NULL;
@@ -1579,10 +1579,10 @@ void bnx2fc_process_tm_compl(struct bnx2fc_cmd *io_req,
 	case FC_GOOD:
 		if (io_req->cdb_status == 0) {
 			/* Good IO completion */
-			sc_cmd->result = DID_OK << 16;
+			sc_cmd->status.combined = 0;
 		} else {
 			/* Transport status is good, SCSI status not good */
-			sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
+			sc_cmd->status.combined = io_req->cdb_status;
 		}
 		if (io_req->fcp_resid)
 			scsi_set_resid(sc_cmd, io_req->fcp_resid);
@@ -1851,7 +1851,7 @@ int bnx2fc_queuecommand(struct Scsi_Host *host,
 
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
-		sc_cmd->result = rval;
+		sc_cmd->status.combined = rval;
 		sc_cmd->scsi_done(sc_cmd);
 		return 0;
 	}
@@ -1974,13 +1974,13 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 	case FC_GOOD:
 		if (io_req->cdb_status == 0) {
 			/* Good IO completion */
-			sc_cmd->result = DID_OK << 16;
+			sc_cmd->status.combined = 0;
 		} else {
 			/* Transport status is good, SCSI status not good */
 			BNX2FC_IO_DBG(io_req, "scsi_cmpl: cdb_status = %d"
 				 " fcp_resid = 0x%x\n",
 				io_req->cdb_status, io_req->fcp_resid);
-			sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
+			sc_cmd->status.combined = io_req->cdb_status;
 
 			if (io_req->cdb_status == SAM_STAT_TASK_SET_FULL ||
 			    io_req->cdb_status == SAM_STAT_BUSY) {
