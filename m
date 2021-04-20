Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE31C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE03613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhDTAKj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:39 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:43537 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbhDTAK1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:27 -0400
Received: by mail-pl1-f172.google.com with SMTP id u15so10124472plf.10
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z+aNdpW2uze4xifO4gQZ24CQ8UBJ6cuN2qqQyw6LISg=;
        b=fYrLNnNQbXhHwmQ+TwYPUYim781Z6FzobDBKObb1V5ck9m07J4zFwRFNU7NOOnl9i2
         UHI8/3ar1eHOJf8YDh4cYc+B5QoTF8+052ww7HDrva/lIkXB9UWrfzqURCEjAH+AhopX
         xu3wKiTf9oSdnu6IEl5lJ6bFxRGM959YhLEzVlosvVDylPMH+MGkHe0L1OluGk9Sska9
         VO4RU02/+7et/5Iw5A34/uiWhfWH4QZv3/zOPdaW27+hvbWA3xehortsrJIVhgEEQzLz
         RLzdn1xyss07Hm2zOMVUfXovemg9T14w2vS1aQCCtDaa2LzsK4QaH6+r6MGTfNQZZUH4
         aOqw==
X-Gm-Message-State: AOAM530GPt8Lt0+mIMhKuykX3PPedrzSfLauLvF0w7omq/aQDo/x+hQR
        peA01dp5hl0JDa+ZIxBHbTw=
X-Google-Smtp-Source: ABdhPJwzoYqEWhEqOeMgK3aQ1S2mCrJrh/usBJTQZpd6/dVWzv3nnn1JTxp52lVNi8eb0tygrT7L9A==
X-Received: by 2002:a17:90a:150e:: with SMTP id l14mr1828484pja.208.1618877396689;
        Mon, 19 Apr 2021 17:09:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 056/117] ibmvscsi: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:44 -0700
Message-Id: <20210420000845.25873-57-bvanassche@acm.org>
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
 drivers/scsi/ibmvscsi/ibmvscsi.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index f33f56680c59..1a02dc411f0d 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -793,7 +793,7 @@ static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 
 		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 		if (evt->cmnd) {
-			evt->cmnd->result = (error_code << 16);
+			evt->cmnd->status.combined = (error_code << 16);
 			unmap_cmd_data(&evt->iu.srp.cmd, evt,
 				       evt->hostdata->dev);
 			if (evt->cmnd_done)
@@ -976,7 +976,7 @@ static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
 	unmap_cmd_data(&evt_struct->iu.srp.cmd, evt_struct, hostdata->dev);
 
 	if (evt_struct->cmnd != NULL) {
-		evt_struct->cmnd->result = DID_ERROR << 16;
+		evt_struct->cmnd->status.combined = DID_ERROR << 16;
 		evt_struct->cmnd_done(evt_struct->cmnd);
 	} else if (evt_struct->done)
 		evt_struct->done(evt_struct);
@@ -1004,8 +1004,8 @@ static void handle_cmd_rsp(struct srp_event_struct *evt_struct)
 	}
 	
 	if (cmnd) {
-		cmnd->result |= rsp->status;
-		if (((cmnd->result >> 1) & 0x1f) == CHECK_CONDITION)
+		cmnd->status.combined |= rsp->status;
+		if (((cmnd->status.combined >> 1) & 0x1f) == CHECK_CONDITION)
 			memcpy(cmnd->sense_buffer,
 			       rsp->data,
 			       be32_to_cpu(rsp->sense_data_len));
@@ -1049,7 +1049,7 @@ static int ibmvscsi_queuecommand_lck(struct scsi_cmnd *cmnd,
 	u16 lun = lun_from_dev(cmnd->device);
 	u8 out_fmt, in_fmt;
 
-	cmnd->result = (DID_OK << 16);
+	cmnd->status.combined = (DID_OK << 16);
 	evt_struct = get_event_struct(&hostdata->pool);
 	if (!evt_struct)
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1608,7 +1608,7 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
 	sdev_printk(KERN_INFO, cmd->device, "successfully aborted task tag 0x%llx\n",
 		    tsk_mgmt->task_tag);
 
-	cmd->result = (DID_ABORT << 16);
+	cmd->status.combined = (DID_ABORT << 16);
 	list_del(&found_evt->list);
 	unmap_cmd_data(&found_evt->iu.srp.cmd, found_evt,
 		       found_evt->hostdata->dev);
@@ -1713,7 +1713,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
 		if ((tmp_evt->cmnd) && (tmp_evt->cmnd->device == cmd->device)) {
 			if (tmp_evt->cmnd)
-				tmp_evt->cmnd->result = (DID_RESET << 16);
+				tmp_evt->cmnd->status.combined = (DID_RESET << 16);
 			list_del(&tmp_evt->list);
 			unmap_cmd_data(&tmp_evt->iu.srp.cmd, tmp_evt,
 				       tmp_evt->hostdata->dev);
@@ -1842,7 +1842,7 @@ static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
 	del_timer(&evt_struct->timer);
 
 	if ((crq->status != VIOSRP_OK && crq->status != VIOSRP_OK2) && evt_struct->cmnd)
-		evt_struct->cmnd->result = DID_ERROR << 16;
+		evt_struct->cmnd->status.combined = DID_ERROR << 16;
 	if (evt_struct->done)
 		evt_struct->done(evt_struct);
 	else
