Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8500FC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66E1061363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhDTAKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:37 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:43808 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbhDTAK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:26 -0400
Received: by mail-pg1-f175.google.com with SMTP id p12so25395938pgj.10
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=94eMY003wY3A0g3MwwFOZTHfArdSd2dO2jkb4ShnpWI=;
        b=EYsGWOVUpxkBbwadHb2TgNWGYbaW9QWbOkAm8HjCd/Q2q7O4WJr2RmehARAf+n3N7a
         hz1EWGjHyWcrjb3FJqYE1X/CqaQfdVoSlzIIuecbxsabOi62PayRfK7ka3dhsJe87sZ6
         14w9+K8u8c3jih3IZRqv4b1oT5uqDhumwPYS1IFxs86Rt045XEdD9410xTN9XFixUAyT
         t0ix4GRH3f42MhmQKTSifNYl2cx9ub4iwVxli5xs5BdTd+Ff0QonvWd4W+RJpFduImhl
         6n/OWLkfJGkLuNRjaFLuvDiciEgmWm08vymSOtabBGYC6T8vcocckeQ8C7dGDd5Vo2IW
         HSZA==
X-Gm-Message-State: AOAM531iv7BM6gyvkCrnSvldiCE9ZHsn5TCmenAx3p3JgkxVQ+WtQybH
        O5SOKVh8JkZaOZWaWouJml8=
X-Google-Smtp-Source: ABdhPJyeW1sUFgnLn/WtpK7vANiU7oKa8G0LLQu5TCxnOn4r7wsSsj+OrWoAE8OyOMM4MXSXt54BCQ==
X-Received: by 2002:aa7:8e0d:0:b029:214:a511:d88b with SMTP id c13-20020aa78e0d0000b0290214a511d88bmr22115004pfr.2.1618877395601;
        Mon, 19 Apr 2021 17:09:55 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 055/117] ibmvfc: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:43 -0700
Message-Id: <20210420000845.25873-56-bvanassche@acm.org>
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

Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 1d4bff0f561d..460568d77a21 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1070,7 +1070,7 @@ static void ibmvfc_complete_purge(struct list_head *purge_list)
 static void ibmvfc_fail_request(struct ibmvfc_event *evt, int error_code)
 {
 	if (evt->cmnd) {
-		evt->cmnd->result = (error_code << 16);
+		evt->cmnd->status.combined = (error_code << 16);
 		evt->done = ibmvfc_scsi_eh_done;
 	} else
 		evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_DRIVER_FAILED);
@@ -1713,7 +1713,7 @@ static int ibmvfc_send_event(struct ibmvfc_event *evt,
 
 		dev_err(vhost->dev, "Send error (rc=%d)\n", rc);
 		if (evt->cmnd) {
-			evt->cmnd->result = DID_ERROR << 16;
+			evt->cmnd->status.combined = DID_ERROR << 16;
 			evt->done = ibmvfc_scsi_eh_done;
 		} else
 			evt->xfer_iu->mad_common.status = cpu_to_be16(IBMVFC_MAD_CRQ_ERROR);
@@ -1807,7 +1807,7 @@ static void ibmvfc_scsi_done(struct ibmvfc_event *evt)
 			scsi_set_resid(cmnd, 0);
 
 		if (vfc_cmd->status) {
-			cmnd->result = ibmvfc_get_err_result(evt->vhost, vfc_cmd);
+			cmnd->status.combined = ibmvfc_get_err_result(evt->vhost, vfc_cmd);
 
 			if (rsp->flags & FCP_RSP_LEN_VALID)
 				rsp_len = be32_to_cpu(rsp->fcp_rsp_len);
@@ -1819,15 +1819,15 @@ static void ibmvfc_scsi_done(struct ibmvfc_event *evt)
 			    (be16_to_cpu(vfc_cmd->error) == IBMVFC_PLOGI_REQUIRED))
 				ibmvfc_relogin(cmnd->device);
 
-			if (!cmnd->result && (!scsi_get_resid(cmnd) || (rsp->flags & FCP_RESID_OVER)))
-				cmnd->result = (DID_ERROR << 16);
+			if (!cmnd->status.combined && (!scsi_get_resid(cmnd) || (rsp->flags & FCP_RESID_OVER)))
+				cmnd->status.combined = (DID_ERROR << 16);
 
 			ibmvfc_log_error(evt);
 		}
 
-		if (!cmnd->result &&
+		if (!cmnd->status.combined &&
 		    (scsi_bufflen(cmnd) - scsi_get_resid(cmnd) < cmnd->underflow))
-			cmnd->result = (DID_ERROR << 16);
+			cmnd->status.combined = (DID_ERROR << 16);
 
 		scsi_dma_unmap(cmnd);
 		cmnd->scsi_done(cmnd);
@@ -1915,12 +1915,12 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 
 	if (unlikely((rc = fc_remote_port_chkready(rport))) ||
 	    unlikely((rc = ibmvfc_host_chkready(vhost)))) {
-		cmnd->result = rc;
+		cmnd->status.combined = rc;
 		cmnd->scsi_done(cmnd);
 		return 0;
 	}
 
-	cmnd->result = (DID_OK << 16);
+	cmnd->status.combined = (DID_OK << 16);
 	if (vhost->using_channels) {
 		scsi_channel = hwq % vhost->scsi_scrqs.active_queues;
 		evt = ibmvfc_get_event(&vhost->scsi_scrqs.scrqs[scsi_channel]);
@@ -1955,7 +1955,7 @@ static int ibmvfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 		scmd_printk(KERN_ERR, cmnd,
 			    "Failed to map DMA buffer for command. rc=%d\n", rc);
 
-	cmnd->result = DID_ERROR << 16;
+	cmnd->status.combined = DID_ERROR << 16;
 	cmnd->scsi_done(cmnd);
 	return 0;
 }
@@ -2235,8 +2235,8 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	ibmvfc_free_event(evt);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-	bsg_reply->result = rc;
-	bsg_job_done(job, bsg_reply->result,
+	bsg_reply->status.combined = rc;
+	bsg_job_done(job, bsg_reply->status.combined,
 		       bsg_reply->reply_payload_rcv_len);
 	rc = 0;
 out:
