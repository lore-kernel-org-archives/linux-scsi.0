Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B26C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA96161423
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347183AbhI2WJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:09:40 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:44809 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347172AbhI2WJi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:38 -0400
Received: by mail-pl1-f170.google.com with SMTP id t11so2515637plq.11
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:07:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=btA8sPcTcQz7vlvxHeXFnK/OlZyN5Komai/m/9bbg4o=;
        b=Mfs9sZpE7YrZ+JXi+1RqYDPrsZ8QfJMjR2onQu0zr5B9TphRDh52sJ/jnyX81iJTiQ
         AzNj5XShTDHTK3d3EtYyak27A3Z+squivVXZuoW8JogGnUeiriZkqXESc5e4BcLvZfBy
         g1vzME9iFRL6gN4FLZ1SDVVzKpCHHaZzWkp8Fpp5vyWkuAqrJfvSdnY4Cu/GiG+lSfwr
         tDvGhq5kHVXNQmxnS+0k/lacNWHyJRvM2DpIP4EXfHuqfDcAJJyumKDw6nJygiQZ0QDt
         9VXxM4S9F5Pr/ZZAY5VXbZqrEf7+p7QAITzF3Myx5rkD0hHye1vF43HCIXRC8NN81unf
         K5Mw==
X-Gm-Message-State: AOAM533tQHXKPOIbD3YR75PDIFScPRJx6MArZKGlFHsgtgua0rXoM9qB
        7Sgat41h0P/LEnZ1vjKi4Q/wDrHfhR0=
X-Google-Smtp-Source: ABdhPJyhceb7c0YMFpX+udBYy7Btr7snjzr+rfD6xhqM2ybS5UeLlT/FRA6F1OpaeXDBriAIOy5KmA==
X-Received: by 2002:a17:903:2c2:b029:101:9c88:d928 with SMTP id s2-20020a17090302c2b02901019c88d928mr783926plk.62.1632953276248;
        Wed, 29 Sep 2021 15:07:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:07:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 62/84] qedf: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:38 -0700
Message-Id: <20210929220600.3509089-63-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
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
 
