Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7BBC4332B
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FE31650D6
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:57:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbhCPD5W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:57:22 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:40264 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbhCPD5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:57:09 -0400
Received: by mail-pf1-f178.google.com with SMTP id x7so7916532pfi.7
        for <linux-scsi@vger.kernel.org>; Mon, 15 Mar 2021 20:57:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sv6Of24ONRKWaT0mpomdGbT1PFh1mtbQymJBI5MJtlA=;
        b=QT8V2dZk4QliLVZelvNSie+my4oZVuF8HO/++ZbGejRouwfgGL1m6EMGSlvEVBWCUa
         jUWT+nBNNX+iU6rRST/ThcfHBXRm61Tt+u8hHR14VtJEhOk+oHvn9pBpp8y79Oh/m2sn
         U8AQ7Y/EFByL0VnFQ6X8+VEW+UNrBbWWcWlsHfDchC6l/fCk361fub3QZhq6pExsP8sM
         zgF8vwkf4ZcvGcV5eddAEFiN947RpRxDlcFmAMoqRqRb/25buEz33osBB3gFED0+NZq+
         L/8zYZAsPZ9tQ6hci7mRx029yccYgAQX8KYcV7xkbQ016oAmmboukOi2ZX5JuliSoNVZ
         3hdA==
X-Gm-Message-State: AOAM531rChZ6AvCI32/jhkklWKQs0MClvjpoDBul90ROlI6NIVaoOSQE
        YFLdin7uDLH3+4tovJPRPUzENZelRso=
X-Google-Smtp-Source: ABdhPJxgH0LsLZIuRa1ytwMkBEC8nZZOWkN07j/z67T7q61OSZ5QQfWn5jPj6s+EW1iwCGMq3rFsNQ==
X-Received: by 2002:a05:6a00:ac8:b029:1ed:f8dc:cb3b with SMTP id c8-20020a056a000ac8b02901edf8dccb3bmr12961038pfl.60.1615867028591;
        Mon, 15 Mar 2021 20:57:08 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:8641:766a:ce30:8278])
        by smtp.gmail.com with ESMTPSA id fs9sm1031673pjb.40.2021.03.15.20.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 20:57:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH 5/7] qla2xxx: Suppress Coverity complaints about dseg_r*
Date:   Mon, 15 Mar 2021 20:56:53 -0700
Message-Id: <20210316035655.2835-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316035655.2835-1-bvanassche@acm.org>
References: <20210316035655.2835-1-bvanassche@acm.org>
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
Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
Cc: Daniel Wagner <dwagner@suse.de>
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
