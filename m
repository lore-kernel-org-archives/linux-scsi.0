Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5707BC47082
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 386046115C
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 03:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhEXDLu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 23:11:50 -0400
Received: from mail-pf1-f176.google.com ([209.85.210.176]:42940 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbhEXDLo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 23:11:44 -0400
Received: by mail-pf1-f176.google.com with SMTP id x18so15375190pfi.9
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 20:10:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sp4ChfNEiSRF8tBgNXrRZhDtMX1chUozxV3cgDD8AUY=;
        b=bCsvlQU55iWZ8hyrWbz4GV91ZkaUVUA3qbXPggQO+1C1/+IOnaGc/py9h6u5jjmna2
         1WoBvMdVSjie1vkgPFZv8MJYuR9C82urISwhS8RgIX19g5/V0Luo6ejuat0YKj1Jxtvs
         Hz0UYA1BIiVFZOPQTlmL4+9sAbI1xn7DluW5BdSQDJEMdgvL4bHcbG+Ko9U3O5weuTxy
         5wNwFtttuRq4ZtxcRrr1raRm3JRpW1M5qnZ90eTkX4pu8+XWtnUEINoPU1qd+OBpZIhA
         mOGfXHij088mt/Em8e3xHTnA52QXivlnGUNOU3d2ks5rbH//2avOsoGPnpWGaHthyCJD
         eJNg==
X-Gm-Message-State: AOAM532geWws3JTGQUqcL5vC2xK5n/HNiBflLHYnlrR0qou3xBIH7EJS
        wVcBULBeO5SnDpCCksewpSQ=
X-Google-Smtp-Source: ABdhPJzByoTPDOLg5uJ2T5uCIiUR4PAFJqUKw9Kh1oRGVNz5LoZPTzycXW3bze7MqS0Qv7uEcMLOkg==
X-Received: by 2002:a63:6f01:: with SMTP id k1mr11378250pgc.59.1621825816419;
        Sun, 23 May 2021 20:10:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id v9sm11131863pjd.26.2021.05.23.20.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 20:10:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 43/51] stex: Use scsi_cmd_to_rq() instead of scsi_cmnd.request
Date:   Sun, 23 May 2021 20:08:48 -0700
Message-Id: <20210524030856.2824-44-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524030856.2824-1-bvanassche@acm.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removal of the request pointer by using scsi_cmd_to_rq()
instead. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/stex.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 12471208c7a8..b6eec2e51048 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -543,7 +543,7 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 	msg_h = (struct st_msg_header *)req - 1;
 	if (likely(cmd)) {
 		msg_h->channel = (u8)cmd->device->channel;
-		msg_h->timeout = cpu_to_le16(cmd->request->timeout/HZ);
+		msg_h->timeout = cpu_to_le16(scsi_cmd_to_rq(cmd)->timeout / HZ);
 	}
 	addr = hba->dma_handle + hba->req_head * hba->rq_size;
 	addr += (hba->ccb[tag].sg_count+4)/11;
@@ -693,7 +693,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	cmd->scsi_done = done;
 
-	tag = cmd->request->tag;
+	tag = scsi_cmd_to_rq(cmd)->tag;
 
 	if (unlikely(tag >= host->can_queue))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -1249,7 +1249,7 @@ static int stex_abort(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct st_hba *hba = (struct st_hba *)host->hostdata;
-	u16 tag = cmd->request->tag;
+	u16 tag = scsi_cmd_to_rq(cmd)->tag;
 	void __iomem *base;
 	u32 data;
 	int result = SUCCESS;
