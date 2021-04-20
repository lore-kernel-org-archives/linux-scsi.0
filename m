Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4865C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B0F561363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhDTAJ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:09:58 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:34611 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbhDTAJs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:09:48 -0400
Received: by mail-pg1-f178.google.com with SMTP id z16so25383215pga.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I96TpSFi3/3/SDUwLYXwWuBb7tuzLr71QX4afzR/l2A=;
        b=N2Q9B+7VLqjo0TswILxVI91ZlMRDnbEEbC+81nFoKWYJyp1xFfyTGVW6PflvyKOusb
         lrIw4VvaVpgkLkolFK3Ou9jIyiwud8l/58IUTRz66w+jp/ZAc0EyZN7z3edgMx9z8gs2
         TqJGX1YW2VReARjJ1xgB+h5hNegOV2Z/zOS53aFNHAdKjHQTkWew1COwSxp/0lov7VCQ
         ArqlN5Y3n4aVATNllZjv+Zbj++kxq2kTXJjhtUqJSl4125klNnu6sF5/bfbnCIjtlIck
         o3wlkuZba5EHAB3S//g7xAFaRqvyGDBIUfUH1rzLh/hghdV3ryhkK7E6Bj44dW3uREl6
         ml7g==
X-Gm-Message-State: AOAM533JoiBgDWRa1oaUsQgs33hMW3xiIER3fAHRTgDHsshyBk47MnuG
        XzTZhy7fOZe6F6kumA8xOHs=
X-Google-Smtp-Source: ABdhPJwJ0J3tR+FpyeDVDgiLRwRXaYtEK42mQ1uCImLdad4YeNrgyC8ExDfhpFk+6Edx6iyX49gXfw==
X-Received: by 2002:a63:f258:: with SMTP id d24mr14115693pgk.174.1618877356771;
        Mon, 19 Apr 2021 17:09:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Khalid Aziz <khalid@gonehiking.org>
Subject: [PATCH 021/117] BusLogic: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:09 -0700
Message-Id: <20210420000845.25873-22-bvanassche@acm.org>
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

Cc: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 0ac3f713fc21..00a4beb53f49 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2615,11 +2615,11 @@ static void blogic_qcompleted_ccb(struct blogic_ccb *ccb)
   the Host Adapter Status and Target Device Status.
 */
 
-static int blogic_resultcode(struct blogic_adapter *adapter,
+static union scsi_status blogic_resultcode(struct blogic_adapter *adapter,
 		enum blogic_adapter_status adapter_status,
 		enum blogic_tgt_status tgt_status)
 {
-	int hoststatus;
+	enum host_status hoststatus;
 
 	switch (adapter_status) {
 	case BLOGIC_CMD_CMPLT_NORMAL:
@@ -2664,7 +2664,8 @@ static int blogic_resultcode(struct blogic_adapter *adapter,
 		hoststatus = DID_ERROR;
 		break;
 	}
-	return (hoststatus << 16) | tgt_status;
+	return (union scsi_status){
+		.b.host = hoststatus, .b.status = (enum sam_status)tgt_status};
 }
 
 
@@ -2775,7 +2776,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 				struct scsi_cmnd *nxt_cmd =
 					command->reset_chain;
 				command->reset_chain = NULL;
-				command->result = DID_RESET << 16;
+				command->status.combined = DID_RESET << 16;
 				command->scsi_done(command);
 				command = nxt_cmd;
 			}
@@ -2792,7 +2793,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					command = ccb->command;
 					blogic_dealloc_ccb(ccb, 1);
 					adapter->active_cmds[tgt_id]--;
-					command->result = DID_RESET << 16;
+					command->status.combined = DID_RESET << 16;
 					command->scsi_done(command);
 				}
 			adapter->bdr_pend[tgt_id] = NULL;
@@ -2813,16 +2814,16 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 				    .cmds_complete++;
 				adapter->tgt_flags[ccb->tgt_id]
 				    .cmd_good = true;
-				command->result = DID_OK << 16;
+				command->status.combined = DID_OK << 16;
 				break;
 			case BLOGIC_CMD_ABORT_BY_HOST:
 				blogic_warn("CCB #%ld to Target %d Aborted\n",
 					adapter, ccb->serial, ccb->tgt_id);
 				blogic_inc_count(&adapter->tgt_stats[ccb->tgt_id].aborts_done);
-				command->result = DID_ABORT << 16;
+				command->status.combined = DID_ABORT << 16;
 				break;
 			case BLOGIC_CMD_COMPLETE_ERROR:
-				command->result = blogic_resultcode(adapter,
+				command->status = blogic_resultcode(adapter,
 					ccb->adapter_status, ccb->tgt_status);
 				if (ccb->adapter_status != BLOGIC_SELECT_TIMEOUT) {
 					adapter->tgt_stats[ccb->tgt_id]
@@ -2830,7 +2831,7 @@ static void blogic_process_ccbs(struct blogic_adapter *adapter)
 					if (blogic_global_options.trace_err) {
 						int i;
 						blogic_notice("CCB #%ld Target %d: Result %X Host "
-								"Adapter Status %02X Target Status %02X\n", adapter, ccb->serial, ccb->tgt_id, command->result, ccb->adapter_status, ccb->tgt_status);
+								"Adapter Status %02X Target Status %02X\n", adapter, ccb->serial, ccb->tgt_id, command->status.combined, ccb->adapter_status, ccb->tgt_status);
 						blogic_notice("CDB   ", adapter);
 						for (i = 0; i < ccb->cdblen; i++)
 							blogic_notice(" %02X", adapter, ccb->cdb[i]);
@@ -3042,7 +3043,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 	   occurred.
 	 */
 	if (cdb[0] == REQUEST_SENSE && command->sense_buffer[0] != 0) {
-		command->result = DID_OK << 16;
+		command->status.combined = DID_OK << 16;
 		comp_cb(command);
 		return 0;
 	}
@@ -3060,7 +3061,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 		spin_lock_irq(adapter->scsi_host->host_lock);
 		ccb = blogic_alloc_ccb(adapter);
 		if (ccb == NULL) {
-			command->result = DID_ERROR << 16;
+			command->status.combined = DID_ERROR << 16;
 			comp_cb(command);
 			return 0;
 		}
@@ -3211,7 +3212,7 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
 						ccb)) {
 				blogic_warn("Still unable to write Outgoing Mailbox - Host Adapter Dead?\n", adapter);
 				blogic_dealloc_ccb(ccb, 1);
-				command->result = DID_ERROR << 16;
+				command->status.combined = DID_ERROR << 16;
 				command->scsi_done(command);
 			}
 		}
