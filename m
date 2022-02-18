Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB66C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiBRTwe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238479AbiBRTw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:26 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD232291FA5
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:05 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id w1so7968789plb.6
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/EJX+/vkV4EsrKmfGAOP1zH1m5L+rWp/rxO1zE55iJM=;
        b=PykwPgGjFpPnLT3fryeOpc7SCm1f4DSGSGc0ZD/vAvbJmSrXIYqdPP7NoeVBDUtABM
         vkdMcy4UbLhd9EPfNo5ZoifS4dbciI+dBDcjvYc6b6l1hnMDew7LC1AuEK/hLv0KcG0d
         s+UlBzQOJRZvfqV6hINRkMQZQrfetyWQ2i9GxEUErfLPraxiQaZ28wHnnxaHMV6iGbaT
         5SqWTjYOlJaheJoc84mhoblg32T3F/+KIL1fzO1VL/t0tVdXE0JolEgusuE92AF2MAGp
         PLL6E4R/pNeEoDNeM48bJ6fU9PJ9fo6JZY+90PRfwMMf8sBSbZfx5TaF4aGSHoj3oQN/
         3oFw==
X-Gm-Message-State: AOAM530UNxF6NgWzzWw6w35aSF5Btceftouj7cRQMrUJIYHZfAlS2bT/
        Ao5+mZI2jqKcuVfolyjN+CY=
X-Google-Smtp-Source: ABdhPJxOdlQr+oWyq+KWVwn9QgQX1usqTX5fx5+MN2YjlFE7HsKzYX8pErhwNhy/RtO/E5+KkZR+wg==
X-Received: by 2002:a17:90b:1894:b0:1b9:c2dc:6315 with SMTP id mn20-20020a17090b189400b001b9c2dc6315mr10004961pjb.138.1645213925080;
        Fri, 18 Feb 2022 11:52:05 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v5 17/49] scsi: csio: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:50:45 -0800
Message-Id: <20220218195117.25689-18-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 20 +++++++++++---------
 drivers/scsi/csiostor/csio_scsi.h | 10 ++++++++++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 55db02521221..9aafe0002ab1 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -166,7 +166,7 @@ csio_scsi_fcp_cmnd(struct csio_ioreq *req, void *addr)
 	struct scsi_cmnd *scmnd = csio_scsi_cmnd(req);
 
 	/* Check for Task Management */
-	if (likely(scmnd->SCp.Message == 0)) {
+	if (likely(csio_priv(scmnd)->fc_tm_flags == 0)) {
 		int_to_scsilun(scmnd->device->lun, &fcp_cmnd->fc_lun);
 		fcp_cmnd->fc_tm_flags = 0;
 		fcp_cmnd->fc_cmdref = 0;
@@ -185,7 +185,7 @@ csio_scsi_fcp_cmnd(struct csio_ioreq *req, void *addr)
 	} else {
 		memset(fcp_cmnd, 0, sizeof(*fcp_cmnd));
 		int_to_scsilun(scmnd->device->lun, &fcp_cmnd->fc_lun);
-		fcp_cmnd->fc_tm_flags = (uint8_t)scmnd->SCp.Message;
+		fcp_cmnd->fc_tm_flags = csio_priv(scmnd)->fc_tm_flags;
 	}
 }
 
@@ -1855,7 +1855,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 
 	/* Needed during abort */
 	cmnd->host_scribble = (unsigned char *)ioreq;
-	cmnd->SCp.Message = 0;
+	csio_priv(cmnd)->fc_tm_flags = 0;
 
 	/* Kick off SCSI IO SM on the ioreq */
 	spin_lock_irqsave(&hw->lock, flags);
@@ -2026,7 +2026,7 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 		      req, req->wr_status);
 
 	/* Cache FW return status */
-	cmnd->SCp.Status = req->wr_status;
+	csio_priv(cmnd)->wr_status = req->wr_status;
 
 	/* Special handling based on FCP response */
 
@@ -2049,7 +2049,7 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 		/* Modify return status if flags indicate success */
 		if (flags & FCP_RSP_LEN_VAL)
 			if (rsp_info->rsp_code == FCP_TMF_CMPL)
-				cmnd->SCp.Status = FW_SUCCESS;
+				csio_priv(cmnd)->wr_status = FW_SUCCESS;
 
 		csio_dbg(hw, "TM FCP rsp code: %d\n", rsp_info->rsp_code);
 	}
@@ -2125,9 +2125,9 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 
 	csio_scsi_cmnd(ioreq)	= cmnd;
 	cmnd->host_scribble	= (unsigned char *)ioreq;
-	cmnd->SCp.Status	= 0;
+	csio_priv(cmnd)->wr_status = 0;
 
-	cmnd->SCp.Message	= FCP_TMF_LUN_RESET;
+	csio_priv(cmnd)->fc_tm_flags = FCP_TMF_LUN_RESET;
 	ioreq->tmo		= CSIO_SCSI_LUNRST_TMO_MS / 1000;
 
 	/*
@@ -2178,9 +2178,10 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	}
 
 	/* LUN reset returned, check cached status */
-	if (cmnd->SCp.Status != FW_SUCCESS) {
+	if (csio_priv(cmnd)->wr_status != FW_SUCCESS) {
 		csio_err(hw, "LUN reset failed (%d:%llu), status: %d\n",
-			 cmnd->device->id, cmnd->device->lun, cmnd->SCp.Status);
+			 cmnd->device->id, cmnd->device->lun,
+			 csio_priv(cmnd)->wr_status);
 		goto fail;
 	}
 
@@ -2271,6 +2272,7 @@ struct scsi_host_template csio_fcoe_shost_template = {
 	.name			= CSIO_DRV_DESC,
 	.proc_name		= KBUILD_MODNAME,
 	.queuecommand		= csio_queuecommand,
+	.cmd_size		= sizeof(struct csio_cmd_priv),
 	.eh_timed_out		= fc_eh_timed_out,
 	.eh_abort_handler	= csio_eh_abort_handler,
 	.eh_device_reset_handler = csio_eh_lun_reset_handler,
diff --git a/drivers/scsi/csiostor/csio_scsi.h b/drivers/scsi/csiostor/csio_scsi.h
index 2257c3dcf724..39dda3c88f0d 100644
--- a/drivers/scsi/csiostor/csio_scsi.h
+++ b/drivers/scsi/csiostor/csio_scsi.h
@@ -188,6 +188,16 @@ struct csio_scsi_level_data {
 	uint64_t		oslun;
 };
 
+struct csio_cmd_priv {
+	uint8_t fc_tm_flags;	/* task management flags */
+	uint16_t wr_status;
+};
+
+static inline struct csio_cmd_priv *csio_priv(struct scsi_cmnd *cmd)
+{
+	return scsi_cmd_priv(cmd);
+}
+
 static inline struct csio_ioreq *
 csio_get_scsi_ioreq(struct csio_scsim *scm)
 {
