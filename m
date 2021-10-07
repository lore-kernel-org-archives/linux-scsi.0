Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7462FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 504716103B
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhJGUfM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:35:12 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:54797 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242655AbhJGUdO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:33:14 -0400
Received: by mail-pj1-f53.google.com with SMTP id np13so5794242pjb.4
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:31:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=btA8sPcTcQz7vlvxHeXFnK/OlZyN5Komai/m/9bbg4o=;
        b=DYBtG/hFbItaI6xDjiAzsqBu4TdJ7Z5hya6zcgyz5qp2tTWIKKz2ZPjcSjxQYL1Pc1
         hpZ2PPVwk4YLmqxnb7/W3vc1fi5FvOTxhUxHXmm0kQoxGLg2hAwhPyjoFbN5TKRLoa5c
         eDxLJDzGYllPcbvekJed8dENl75qGoy6HTeUYTrJLz4omqIlg5z3nAHRIldnqSp0JbrW
         1ce5SMH+HwIdQm1szLvovgGuiYtajIhB374AcZ2J0VgRQPLxgKsywOi/VmC8CLNxl+LH
         35qcCj7/wbpyv5KxfXIUfdCG89ogpoRGhhXR72/MQLE3fdwUzui1aGJS8vVKHzOKksKh
         XhfQ==
X-Gm-Message-State: AOAM532jEzlOGvtYcrburzjYPBTdHmGeBCENrQtAWwd7gJe3AQvR02pG
        xWHR74tuzT515uognNi1fCQ=
X-Google-Smtp-Source: ABdhPJwasyO6eOHXTbDcUxA5Z7QOkP8EcBp9mEB86YIOx1JXkR/cOeQIlvhs5Ryd7BoerTphiwVGbg==
X-Received: by 2002:a17:90b:1102:: with SMTP id gi2mr7107962pjb.43.1633638680630;
        Thu, 07 Oct 2021 13:31:20 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id x35sm303499pfh.52.2021.10.07.13.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:31:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 63/88] qedf: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:28:58 -0700
Message-Id: <20211007202923.2174984-64-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qedf/qedf_io.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 3404782988d5..14aa544b0bc3 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -947,7 +947,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
 			 "Number of SG elements %d exceeds what hardware limitation of %d.\n",
 			 num_sgs, QEDF_MAX_BDS_PER_CMD);
 		sc_cmd->result = DID_ERROR;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -957,7 +957,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
 			  "Returning DNC as unloading or stop io, flags 0x%lx.\n",
 			  qedf->flags);
 		sc_cmd->result = DID_NO_CONNECT << 16;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -966,7 +966,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
 		    "Completing sc_cmd=%p DID_NO_CONNECT as MSI-X is not enabled.\n",
 		    sc_cmd);
 		sc_cmd->result = DID_NO_CONNECT << 16;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -976,7 +976,7 @@ qedf_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc_cmd)
 			  "fc_remote_port_chkready failed=0x%x for port_id=0x%06x.\n",
 			  rval, rport->port_id);
 		sc_cmd->result = rval;
-		sc_cmd->scsi_done(sc_cmd);
+		scsi_done(sc_cmd);
 		return 0;
 	}
 
@@ -1313,7 +1313,7 @@ void qedf_scsi_completion(struct qedf_ctx *qedf, struct fcoe_cqe *cqe,
 
 	io_req->sc_cmd = NULL;
 	sc_cmd->SCp.ptr =  NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, qedf_release_cmd);
 }
 
@@ -1386,13 +1386,6 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 		goto bad_scsi_ptr;
 	}
 
-	if (!sc_cmd->scsi_done) {
-		QEDF_ERR(&qedf->dbg_ctx,
-			 "sc_cmd->scsi_done for sc_cmd %p is NULL.\n",
-			 sc_cmd);
-		goto bad_scsi_ptr;
-	}
-
 	qedf_unmap_sg_list(qedf, io_req);
 
 	sc_cmd->result = result << 16;
@@ -1417,7 +1410,7 @@ void qedf_scsi_done(struct qedf_ctx *qedf, struct qedf_ioreq *io_req,
 
 	io_req->sc_cmd = NULL;
 	sc_cmd->SCp.ptr = NULL;
-	sc_cmd->scsi_done(sc_cmd);
+	scsi_done(sc_cmd);
 	kref_put(&io_req->refcount, qedf_release_cmd);
 	return;
 
