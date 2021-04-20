Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8FEBC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A997E61363
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 00:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbhDTALY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 20:11:24 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:42937 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbhDTAK5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 20:10:57 -0400
Received: by mail-pj1-f41.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so19465391pjv.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 17:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UtlmJJI5MORHp23o76O3idYuBPuvZL4faGy6iwNmgrk=;
        b=JPGJ9OAERYoBG8numyU4ENcSlLlkRjXGJWOgAV6K0KfVanyxGWpblIPhBCLNhPxCZ0
         pq1VWLmcV9w/Dg5mvBhM74I4+9tyr2EXe60spzP+j4gtRUJ1dBCwj3woFIlQuGpA1Yyv
         Gp0D5dtjve7esLbTQcYygwjmAqSHYh5F+7+FTsjy1fBI80yp2Iu08pG2spqAIqKy4kM9
         H0rmPyBQDXKDl9Q7reiwJez0coGbsx/AP4wP6O9avEC0PYVeb5Z2zyceK7K/VEs8SULd
         O+XiFPnjms2jiFxpsycTpAN2u6uB0+pUZIn2AptJnx9w6/ZGzIEsd5K8WRoTLCxQCbcV
         In8g==
X-Gm-Message-State: AOAM530igUA9k6qpwzaXLt7Ghjqp4xo+DhQFiRYTwM14jZU5dEI/hS6h
        bwANc2xGILaez98Qy47trWY=
X-Google-Smtp-Source: ABdhPJwbIeR3t6dCMYr9gwE4b2MPFDwf6NtZeD/vxGAO7LXDirYl5zo0rwNU5OUsNVfvpz2HJ2PVJA==
X-Received: by 2002:a17:90a:df10:: with SMTP id gp16mr1740740pjb.209.1618877426407;
        Mon, 19 Apr 2021 17:10:26 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:3e77:56a4:910b:42a9])
        by smtp.gmail.com with ESMTPSA id 33sm14006787pgq.21.2021.04.19.17.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 17:10:25 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: [PATCH 082/117] qedf: Convert to the scsi_status union
Date:   Mon, 19 Apr 2021 17:08:10 -0700
Message-Id: <20210420000845.25873-83-bvanassche@acm.org>
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
 drivers/scsi/qedf/qedf_io.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 4869ef813dc4..8312a75fdd2e 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -825,7 +825,7 @@ static void qedf_trace_io(struct qedf_rport *fcport, struct qedf_ioreq *io_req,
 	io_log->lba[3] = sc_cmd->cmnd[5];
 	io_log->bufflen = scsi_bufflen(sc_cmd);
 	io_log->sg_count = scsi_sg_count(sc_cmd);
-	io_log->result = sc_cmd->result;
+	io_log->result = sc_cmd->status.combined;
 	io_log->jiffies = jiffies;
 	io_log->refcount = kref_read(&io_req->refcount);
 
@@ -951,7 +951,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
 		QEDF_ERR(&qedf->dbg_ctx,
 			 "Number of SG elements %d exceeds what hardware limitation of %d.\n",
 			 num_sgs, QEDF_MAX_BDS_PER_CMD);
-		sc_cmd->result = DID_ERROR;
+		sc_cmd->status.combined = DID_ERROR;
 		sc_cmd->scsi_done(sc_cmd);
 		return 0;
 	}
@@ -961,7 +961,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
 			  "Returning DNC as unloading or stop io, flags 0x%lx.\n",
 			  qedf->flags);
-		sc_cmd->result = DID_NO_CONNECT << 16;
+		sc_cmd->status.combined = DID_NO_CONNECT << 16;
 		sc_cmd->scsi_done(sc_cmd);
 		return 0;
 	}
@@ -970,7 +970,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
 		    "Completing sc_cmd=%p DID_NO_CONNECT as MSI-X is not enabled.\n",
 		    sc_cmd);
-		sc_cmd->result = DID_NO_CONNECT << 16;
+		sc_cmd->status.combined = DID_NO_CONNECT << 16;
 		sc_cmd->scsi_done(sc_cmd);
 		return 0;
 	}
@@ -980,7 +980,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_IO,
 			  "fc_remote_port_chkready failed=0x%x for port_id=0x%06x.\n",
 			  rval, rport->port_id);
-		sc_cmd->result = rval;
+		sc_cmd->status.combined = rval;
 		sc_cmd->scsi_done(sc_cmd);
 		return 0;
 	}
@@ -1204,7 +1204,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 		    "FCP I/O protocol failure xid=0x%x fcp_rsp_len=%d "
 		    "fcp_rsp_code=%d.\n", io_req->xid, io_req->fcp_rsp_len,
 		    io_req->fcp_rsp_code);
-		sc_cmd->result = DID_BUS_BUSY << 16;
+		sc_cmd->status.combined = DID_BUS_BUSY << 16;
 		goto out;
 	}
 
@@ -1219,9 +1219,9 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 			 sc_cmd->cmnd[3], sc_cmd->cmnd[4], sc_cmd->cmnd[5]);
 
 		if (io_req->cdb_status == 0)
-			sc_cmd->result = (DID_ERROR << 16) | io_req->cdb_status;
+			sc_cmd->status.combined = (DID_ERROR << 16) | io_req->cdb_status;
 		else
-			sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
+			sc_cmd->status.combined = (DID_OK << 16) | io_req->cdb_status;
 
 		/*
 		 * Set resid to the whole buffer length so we won't try to resue
@@ -1235,7 +1235,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 	case FC_GOOD:
 		if (io_req->cdb_status == 0) {
 			/* Good I/O completion */
-			sc_cmd->result = DID_OK << 16;
+			sc_cmd->status.combined = DID_OK << 16;
 		} else {
 			refcount = kref_read(&io_req->refcount);
 			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO,
@@ -1248,7 +1248,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 			    sc_cmd->cmnd[4], sc_cmd->cmnd[5],
 			    io_req->cdb_status, io_req->fcp_resid,
 			    refcount);
-			sc_cmd->result = (DID_OK << 16) | io_req->cdb_status;
+			sc_cmd->status.combined = (DID_OK << 16) | io_req->cdb_status;
 
 			if (io_req->cdb_status == SAM_STAT_TASK_SET_FULL ||
 			    io_req->cdb_status == SAM_STAT_BUSY) {
@@ -1406,13 +1406,13 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 
 	qedf_unmap_sg_list(qedf, io_req);
 
-	sc_cmd->result = result << 16;
+	sc_cmd->status.combined = result << 16;
 	refcount = kref_read(&io_req->refcount);
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_IO, "%d:0:%d:%lld: Completing "
 	    "sc_cmd=%p result=0x%08x op=0x%02x lba=0x%02x%02x%02x%02x, "
 	    "allowed=%d retries=%d refcount=%d.\n",
 	    qedf->lport->host->host_no, sc_cmd->device->id,
-	    sc_cmd->device->lun, sc_cmd, sc_cmd->result, sc_cmd->cmnd[0],
+	    sc_cmd->device->lun, sc_cmd, sc_cmd->status.combined, sc_cmd->cmnd[0],
 	    sc_cmd->cmnd[2], sc_cmd->cmnd[3], sc_cmd->cmnd[4],
 	    sc_cmd->cmnd[5], sc_cmd->allowed, sc_cmd->retries,
 	    refcount);
