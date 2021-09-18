Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F94C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A9660F48
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 00:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345141AbhIRAJu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Sep 2021 20:09:50 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:40451 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345044AbhIRAJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2021 20:09:22 -0400
Received: by mail-pg1-f171.google.com with SMTP id h3so11113712pgb.7
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2021 17:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=btA8sPcTcQz7vlvxHeXFnK/OlZyN5Komai/m/9bbg4o=;
        b=dLrczaAyG/Gb5WrKTt6FbXwuaNcU9bPr4Q0KtNPmrTnQPxK2uoIWfkWwP4Wr0S8q1Y
         qPpc/YaqXd9Ew8Rp180OZHDLbEsV2kOH3oDjDaAh+PtyT9238QtU3OJF8GNv5bxKsh9A
         iFXZT0DXVMH/cM5bW4CHmRjoBSK2GqEfKlsshkh5fZV4mCglw14f8nxtZb/UcZW2qqhP
         YQiSuVT62X7SuOeRSFCTHYuiFftn3Gic7GuXutJDzt/kZ1s61DJ2pz6TWRQijcya37sq
         Y+bboQBJoCaU5btojaUm6UKCxytiih3CQHCqI9eTyP6VaGXtvOLxGraht9SlyCuTHwsT
         hkkw==
X-Gm-Message-State: AOAM530QUMdpvSrcOZwHAgKml9c0VTuQfzgKaf7pmPNhl+jMn+2TenDd
        iJexR5xSquC0EZlgbdjlWLo=
X-Google-Smtp-Source: ABdhPJwY4kgJhDN2j1jMA5EOFV/QhtkJIOaghTFFupixtwfdvVORTIOjyJd6R2P1mOlqJ067IGbiZQ==
X-Received: by 2002:a63:740e:: with SMTP id p14mr12124697pgc.329.1631923679387;
        Fri, 17 Sep 2021 17:07:59 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4c45:d635:d2d2:93])
        by smtp.gmail.com with ESMTPSA id bv16sm6403129pjb.12.2021.09.17.17.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 17:07:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 62/84] qedf: Call scsi_done() directly
Date:   Fri, 17 Sep 2021 17:05:45 -0700
Message-Id: <20210918000607.450448-63-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
In-Reply-To: <20210918000607.450448-1-bvanassche@acm.org>
References: <20210918000607.450448-1-bvanassche@acm.org>
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
 
