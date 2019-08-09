Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F372CC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2094216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405067AbfHIDDo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:44 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45279 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:44 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so45214616pfq.12
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f4Lhu+hAuvX2gloI/VCxmjNRRTviR9LFWyE1U2X8UrQ=;
        b=Jgtw/iszaD4YwDpAKi/kiE3wRZPLiILcyLOeO+79uzc4XA7MYBKLroXwBN8lMaPq25
         8ht9kcl+nbzpYL3dM5QdVTb0nXLgqUiVz6DNZ7l38Ox78U8Rjf3l5M9BqVhEZt+L1LXf
         yMd0sEDDfR0BQ1cUm2LcO0Rj0d9gvOv3txgmZL5Ky+dP09Q2aWA3kJU3l/7FU7MbrbFo
         nHFNJgqqkZZ/rHpoT6w65M4jRP8KBMFYBERsJWHtz1w2X9ToPWD4qZLSG/bxab6eYnsw
         367xUu/zRRrQhn5np2UAXftxkkjJQPWKGKZbMo6Plt8MYPePRNoKUkAdRBVaZIb1dyki
         rX1w==
X-Gm-Message-State: APjAAAWzjXVrc2P1EKjH5u0KL5/mEQLc1tFyTDamr+Y6OeDiOS427HX3
        XJU2g/KuGyfeYUKyZedT3OU=
X-Google-Smtp-Source: APXvYqwRofiZAvDkQcIu1TmeTZ3pUbME9jNfu/goa2rsaWD2jgxtsTKfKTuUyDK77VMNY/ycLh+LUA==
X-Received: by 2002:a63:b74e:: with SMTP id w14mr15793248pgt.264.1565319823407;
        Thu, 08 Aug 2019 20:03:43 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:42 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 50/58] qla2xxx: Complain if sp->done() is not called from the completion path
Date:   Thu,  8 Aug 2019 20:02:11 -0700
Message-Id: <20190809030219.11296-51-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Not calling sp->done() from the command completion path is a severe bug.
Hence complain loudly if that happens.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++++
 drivers/scsi/qla2xxx/qla_isr.c  | 4 ++++
 drivers/scsi/qla2xxx/qla_mr.c   | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3fa8ca63429c..64c84e53011e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -243,6 +243,10 @@ qla2x00_async_iocb_timeout(void *data)
 			sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		}
 		break;
+	default:
+		WARN_ON_ONCE(true);
+		sp->done(sp, QLA_FUNCTION_TIMEOUT);
+		break;
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 55eb51539cb0..7533e420e571 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2786,6 +2786,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	if (rsp->status_srb == NULL)
 		sp->done(sp, res);
+	else
+		WARN_ON_ONCE(true);
 }
 
 /**
@@ -2843,6 +2845,8 @@ qla2x00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
 		sp->done(sp, cp->result);
+	} else {
+		WARN_ON_ONCE(true);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 06985b2d48eb..605b59c76c90 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -2539,6 +2539,8 @@ qlafx00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 	if (rsp->status_srb == NULL)
 		sp->done(sp, res);
+	else
+		WARN_ON_ONCE(true);
 }
 
 /**
@@ -2616,6 +2618,8 @@ qlafx00_status_cont_entry(struct rsp_que *rsp, sts_cont_entry_t *pkt)
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
 		sp->done(sp, cp->result);
+	} else {
+		WARN_ON_ONCE(true);
 	}
 }
 
-- 
2.22.0

