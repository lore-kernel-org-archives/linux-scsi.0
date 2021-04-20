Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7001C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB62D613AC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhDTAKY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:10:24 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:45860 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbhDTAKG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:06 -0400
Received: by mail-pf1-f177.google.com with SMTP id i190so24304666pfc.12
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:09:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z1Ncj+1EIryFfyhLjR4di3b3vLJriXmefghLxNtAJXc=;
        b=WnQTfoqJU8GJlDvRk/DivQiw4OqCDvBasg17Qnopr21OUNNUhPJQsPlGOgG5pVKwsl
         N+/Q7pPsG6PA5xPjY3lromIJk9ZMljEpnpl/gRNzrdICvtpCcW7/KcRAolXQiSJPl+xK
         cQmeRVlyPfXxHVjOpWAdsJE4nrPJEQFAGEBBkYkJ+S8plzpmLCOWANxuo5kvtTy3cav2
         cioge+mnEbZT2ATKKAA4ERYDWZ5GL/6tFc4u4wtA/epImHRQDp7qdmHZa3HZfeC61tW1
         1Gl6iD7T2eeZMbOTUAjDbFl4BpzivMOiW4xn8S70sUuE6q5mvkvvBnR9faE+nzWTdjfW
         uBpw==
X-Gm-Message-State: AOAM533K1oR3TDTvDtR75W/vdD760snQVdkCDxYlPl1opmE8MEEI+tAD
        Bs9wp2vU9Juu/wozAnxJd3Y=
X-Google-Smtp-Source: ABdhPJx+z6lfdDgj8230DDrDH6Hd+k8BT5NpB8Ty0DRKdnwCCJg4PeMLdk3wBBxuuSHRuLXqRV//xg==
X-Received: by 2002:a63:d04b:: with SMTP id s11mr12627457pgi.92.1618877376274;
        Mon, 19 Apr 2021 17:09:36 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:09:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Karen Xie <kxie@chelsio.com>
Subject: [PATCH 038/117] csiostor: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:07:26 -0700
Message-Id: <20210420000845.25873-39-bvanassche@acm.org>
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

Cc: Karen Xie <kxie@chelsio.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/csiostor/csio_scsi.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 56b9ad0a1ca0..9ff02420cedc 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1562,8 +1562,9 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	struct fcp_resp_with_ext *fcp_resp;
 	struct fcp_resp_rsp_info *rsp_info;
 	struct csio_dma_buf *dma_buf;
-	uint8_t flags, scsi_status = 0;
-	uint32_t host_status = DID_OK;
+	uint8_t flags;
+	enum sam_status scsi_status = SAM_STAT_GOOD;
+	enum host_status host_status = DID_OK;
 	uint32_t rsp_len = 0, sns_len = 0;
 	struct csio_rnode *rn = (struct csio_rnode *)(cmnd->device->hostdata);
 
@@ -1719,7 +1720,8 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 			host_status = csio_scsi_copy_to_sgl(hw, req);
 	}
 
-	cmnd->result = (((host_status) << 16) | scsi_status);
+	cmnd->status = (union scsi_status){.b.host = host_status,
+		.b.status = scsi_status};
 	cmnd->scsi_done(cmnd);
 
 	/* Wake up waiting threads */
@@ -1747,7 +1749,7 @@ csio_scsi_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 				host_status = csio_scsi_copy_to_sgl(hw, req);
 		}
 
-		cmnd->result = (((host_status) << 16) | scsi_status);
+		cmnd->status.combined = (((host_status) << 16) | scsi_status);
 		cmnd->scsi_done(cmnd);
 		csio_scsi_cmnd(req) = NULL;
 		CSIO_INC_STATS(csio_hw_to_scsim(hw), n_tot_success);
@@ -1790,13 +1792,13 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 
 	nr = fc_remote_port_chkready(rport);
 	if (nr) {
-		cmnd->result = nr;
+		cmnd->status.combined = nr;
 		CSIO_INC_STATS(scsim, n_rn_nr_error);
 		goto err_done;
 	}
 
 	if (unlikely(!csio_is_hw_ready(hw))) {
-		cmnd->result = (DID_REQUEUE << 16);
+		cmnd->status.combined = (DID_REQUEUE << 16);
 		CSIO_INC_STATS(scsim, n_hw_nr_error);
 		goto err_done;
 	}
@@ -1978,14 +1980,14 @@ csio_eh_abort_handler(struct scsi_cmnd *cmnd)
 		csio_scsi_cmnd(ioreq) = NULL;
 		spin_unlock_irq(&hw->lock);
 
-		cmnd->result = (DID_ERROR << 16);
+		cmnd->status.combined = (DID_ERROR << 16);
 		cmnd->scsi_done(cmnd);
 
 		return FAILED;
 	}
 
 	/* FW successfully aborted the request */
-	if (host_byte(cmnd->result) == DID_REQUEUE) {
+	if (host_byte(cmnd->status) == DID_REQUEUE) {
 		csio_info(hw,
 			"Aborted SCSI command to (%d:%llu) tag %u\n",
 			cmnd->device->id, cmnd->device->lun,
