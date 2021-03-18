Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D2AC43332
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E5664F09
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231240AbhCRD3I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 23:29:08 -0400
Received: from mail-pj1-f44.google.com ([209.85.216.44]:54886 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhCRD2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 23:28:53 -0400
Received: by mail-pj1-f44.google.com with SMTP id w8so2175109pjf.4
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 20:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TbYHENiZ2NxNmIK42cPP4InnrTTNciDDGhfK/nYZBv4=;
        b=GiXJ5FxP1ZbLCmnzW/z8qTnqFsjqW3FYmCOniXAvzkv9L369vwr6WFOVAVj8fdk2U7
         2zyYuiX/LJG2iPakoxnFVI8dcuXjagNWoolTfAhcg417vy5JLzyoYKYw45WbOKDOPli6
         rvVcrKD/EsBVNo+E0bntD33MX0UozF5J4g2v7VEY4hMA2uFAdXyyerI4dBIhg2CCDy+/
         ZTY7saj3FtMccEnetOpNc76lpfuH4RjQ19cpSmNpjWsMkux/RhKZNW3gCBkeXZSmjx5z
         fYW/tCgeq2xFVZs4L6hvDF/0jiGpa8T6ZXtbLeali6erDaYx/U4H2znRUvS1yZGcWe0/
         zjlA==
X-Gm-Message-State: AOAM530x4Ss5S9THbW4mzK3fCXLjeFnNRXAJet78IXdFIktDRfIX+27t
        zU+Wqqin8iHqbghPlCwJSYI=
X-Google-Smtp-Source: ABdhPJxm9QeD45ZJckgEZCvy31CUqZUDp+Qm1P+0bidH8W1I78Fp9fxiRk09sLnTiIfDi9Ibj3S5dA==
X-Received: by 2002:a17:902:bf01:b029:e6:6b59:a48b with SMTP id bi1-20020a170902bf01b02900e66b59a48bmr7589959plb.55.1616038133348;
        Wed, 17 Mar 2021 20:28:53 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7fb2:1f41:ab33:bae6])
        by smtp.gmail.com with ESMTPSA id y68sm473687pgy.5.2021.03.17.20.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 20:28:52 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: [PATCH v2 4/6] qla2xxx: Suppress Coverity complaints about dseg_r*
Date:   Wed, 17 Mar 2021 20:28:38 -0700
Message-Id: <20210318032840.7611-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210318032840.7611-1-bvanassche@acm.org>
References: <20210318032840.7611-1-bvanassche@acm.org>
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
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_mr.c | 12 ++++++------
 drivers/scsi/qla2xxx/qla_mr.h |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index ca7306685325..61eaf6c4ac47 100644
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
index 73be8348402a..eefbae9d7547 100644
--- a/drivers/scsi/qla2xxx/qla_mr.h
+++ b/drivers/scsi/qla2xxx/qla_mr.h
@@ -176,8 +176,8 @@ struct fxdisc_entry_fx00 {
 	uint8_t flags;
 	uint8_t reserved_1;
 
-	struct dsd64 dseg_rq;
-	struct dsd64 dseg_rsp;
+	struct dsd64 dseg_rq[1];
+	struct dsd64 dseg_rsp[1];
 
 	__le32 dataword;
 	__le32 adapid;
