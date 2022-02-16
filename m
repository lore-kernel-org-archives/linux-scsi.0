Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351C5C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233634AbiBPVDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:03:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbiBPVDj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:03:39 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E79421FC58
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:24 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id qe15so3603652pjb.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/EJX+/vkV4EsrKmfGAOP1zH1m5L+rWp/rxO1zE55iJM=;
        b=rriL9oBzBA5PTyg66PbtmdM4NNVaR8UZnsMqVfuoAUFMkmhsq6PmOkeaTLvj+pthN/
         mlZujyhP3kCA62cDLRUk3zi1NWcJy6hq7C0j34dl7+n0Ec6QDJVmwcaphBTMOw3Vm1r2
         LNyqsGMbUcG9rD5uHIrmAPMJ+MYZoW1xadkBbwJGcMP5bUWjdlgGjg/SyxnPQd7ygi9U
         gTG1ZIArJRrOl2ZVIBim0VhtD5ttM1uLkZzfsWa35V6ER4s7zTu7sGvY15mKf5rob3Tg
         efElnZa3ibRQC86XaUR8jwdjcFJAk7nwq96U6w49KtgtE6HAWp08FOW1v4GG3y00jen+
         2jLw==
X-Gm-Message-State: AOAM533gl44E1P2sWkjBoxkcahGALfYgzp25qM/hEqOVGt3gBhPIf5VF
        zEGKUD3/8nRIKkEJa6QFGcc=
X-Google-Smtp-Source: ABdhPJzIVAe0RJQbvT6ZXM+KMPLSZwU/kfomzabCVyinNwsvtdbXazeM7RlKfKXD7qJyUGjDZzRrow==
X-Received: by 2002:a17:90a:d243:b0:1b9:cbac:a775 with SMTP id o3-20020a17090ad24300b001b9cbaca775mr3885668pjw.196.1645045403590;
        Wed, 16 Feb 2022 13:03:23 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:23 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH v4 18/50] scsi: csio: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:01 -0800
Message-Id: <20220216210233.28774-19-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
