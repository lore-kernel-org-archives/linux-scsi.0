Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D487C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351312AbiA1WVN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:21:13 -0500
Received: from mail-pg1-f177.google.com ([209.85.215.177]:34407 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244957AbiA1WVG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:06 -0500
Received: by mail-pg1-f177.google.com with SMTP id v3so6477847pgc.1
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yWhIAxLpd1FQc4QdoW2drxAr9T+PigapldCUnOIRHHI=;
        b=1buMyFykEMgM49OkUMB2MVxfoK9i/NWn3O+5VT2D53isiU1oX5ZFksuDCASccQk8PY
         iAYOJwff74A2DKaXVyCb4A83lZqk1ViUgiA6iBRnmpC1ZfLkCe7jdR8k57V/pW1CVNGA
         Z183P8hdaHO2ETbZUssCQ28dVbSlShYIcRP62uWHiq9Bv9rUwpTilvZ5MS7uIbjj7vHh
         ZFQNldqS+M/gu+H5YSZwtwf4eVixOkM4KdzcA9JdrTwPJYkpgyGqod91w5OFKAjHhTsQ
         PueiapnFolAerfDLprSyCChANSiEm1btc6/Jy0DaDQKnf6l+H0YcChfEuKQiATKkvi94
         tg1w==
X-Gm-Message-State: AOAM531M40Yyzgc4/giQLFekdUwqbVQ4Ukb+wfklD8usAWjA2N+YGcTS
        SnrHWu9giQH0/87pNWv7ZAnidEDpTMsAxQ==
X-Google-Smtp-Source: ABdhPJxddMvZExUx467YRmaMc/thDfQcrxQdVz4HsZF14L7CzARW4RZ4Rj3mm/4pftr3eHqbjgSc7w==
X-Received: by 2002:a05:6a00:1693:: with SMTP id k19mr9861419pfc.71.1643408465872;
        Fri, 28 Jan 2022 14:21:05 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH 14/44] csio: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:18:39 -0800
Message-Id: <20220128221909.8141-15-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

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
