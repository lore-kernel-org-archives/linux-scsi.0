Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D63C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B46956193B
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhCTXYR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 19:24:17 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:37676 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbhCTXYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 19:24:13 -0400
Received: by mail-pl1-f177.google.com with SMTP id h20so4670973plr.4
        for <linux-scsi@vger.kernel.org>; Sat, 20 Mar 2021 16:24:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ee5/Hwk/CNy9tnnYkU7iuKSqoOTwFuRXxBxJ32zQfKg=;
        b=oAM53hThA4xjCNHSHgv4zks9sibzglRe87l/FKEawPVjeZhKrwXDj34h7vVYvAkXYh
         XtZwCCuLH8ovxp0JSQlY4ocbrXMoteQq4s/hl+W1QrrxnJFLpUVmMFM1s4DVa4QNKonK
         71/mG/ZFyIZHQ6i6FtJnZvQkjVWiMAm6M1A2YOriIsXmyP+qnwL1Hwoz86wr3ieKzgXT
         +f4GvhNzczyWNDlDszHdhaIo8uycLzR1kupmCHUbDmGtD+b1vFTv96myIIB9nX2eQi0a
         7RWUpacHc5UEw+d4nx5eHhc1m7ZXPnGxwVNldjhjCl7FVUZzZ8wB7YSjNDUz6lTYI0Oa
         P3cQ==
X-Gm-Message-State: AOAM5332bYCci4+vOCzSKwihFzvuQwRM49Dz+13N3Tl7EC75VDTZLCd6
        Y+EOK+A2kK4zfcS/d5RA9BgmbhV0T5Q=
X-Google-Smtp-Source: ABdhPJwqUlIRGWoxi1I37ZEXrKnnGcnc1Q1AiKdQ7hx9OHNqf3LIHZ/RINE3t3TwCFrWTb8mn+X+LA==
X-Received: by 2002:a17:902:c1d5:b029:e6:52e0:6bdd with SMTP id c21-20020a170902c1d5b02900e652e06bddmr20459483plc.49.1616282653013;
        Sat, 20 Mar 2021 16:24:13 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:9252:a76b:2952:3189])
        by smtp.gmail.com with ESMTPSA id u7sm8869159pfh.150.2021.03.20.16.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 16:24:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH v3 4/7] qla2xxx: Suppress Coverity complaints about dseg_r*
Date:   Sat, 20 Mar 2021 16:23:56 -0700
Message-Id: <20210320232359.941-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210320232359.941-1-bvanassche@acm.org>
References: <20210320232359.941-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change dseq_rq and dseg_rsp from scalar structure members into
single-element arrays such that Coverity does not complain about the
(*cur_dsd)++ statement in append_dsd64().

Cc: Quinn Tran <qutran@marvell.com>
Cc: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_mr.c | 12 ++++++------
 drivers/scsi/qla2xxx/qla_mr.h |  8 ++++++--
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index d488ae95e149..6e920da64863 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -3266,8 +3266,8 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
 			fx_iocb.req_xfrcnt =
 			    cpu_to_le16(fxio->u.fxiocb.req_len);
 			put_unaligned_le64(fxio->u.fxiocb.req_dma_handle,
-					   &fx_iocb.dseg_rq.address);
-			fx_iocb.dseg_rq.length =
+					   &fx_iocb.dseg_rq[0].address);
+			fx_iocb.dseg_rq[0].length =
 			    cpu_to_le32(fxio->u.fxiocb.req_len);
 		}
 
@@ -3276,8 +3276,8 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
 			fx_iocb.rsp_xfrcnt =
 			    cpu_to_le16(fxio->u.fxiocb.rsp_len);
 			put_unaligned_le64(fxio->u.fxiocb.rsp_dma_handle,
-					   &fx_iocb.dseg_rsp.address);
-			fx_iocb.dseg_rsp.length =
+					   &fx_iocb.dseg_rsp[0].address);
+			fx_iocb.dseg_rsp[0].length =
 			    cpu_to_le32(fxio->u.fxiocb.rsp_len);
 		}
 
@@ -3314,7 +3314,7 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
 			    cpu_to_le16(bsg_job->request_payload.sg_cnt);
 			tot_dsds =
 			    bsg_job->request_payload.sg_cnt;
-			cur_dsd = &fx_iocb.dseg_rq;
+			cur_dsd = &fx_iocb.dseg_rq[0];
 			avail_dsds = 1;
 			for_each_sg(bsg_job->request_payload.sg_list, sg,
 			    tot_dsds, index) {
@@ -3369,7 +3369,7 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
 			fx_iocb.rsp_dsdcnt =
 			   cpu_to_le16(bsg_job->reply_payload.sg_cnt);
 			tot_dsds = bsg_job->reply_payload.sg_cnt;
-			cur_dsd = &fx_iocb.dseg_rsp;
+			cur_dsd = &fx_iocb.dseg_rsp[0];
 			avail_dsds = 1;
 
 			for_each_sg(bsg_job->reply_payload.sg_list, sg,
diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
index 73be8348402a..4f63aff333db 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -176,8 +176,12 @@ struct fxdisc_entry_fx00 {
 	uint8_t flags;
 	uint8_t reserved_1;
 
-	struct dsd64 dseg_rq;
-	struct dsd64 dseg_rsp;
+	/*
+	 * Use array size 1 below to prevent that Coverity complains about
+	 * the append_dsd64() calls for the two arrays below.
+	 */
+	struct dsd64 dseg_rq[1];
+	struct dsd64 dseg_rsp[1];
 
 	__le32 dataword;
 	__le32 adapid;
