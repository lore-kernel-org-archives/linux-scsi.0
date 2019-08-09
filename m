Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D7AC433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B586A216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405339AbfHIDDr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40498 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so45100230pgj.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=do03IiiTlt9S0nbJ8I+i/UdM93cHkEijHJqDixACcak=;
        b=AgVBWgML209gkT15OjvBuzab3SlHlzYm3kIqDVz75kciVpEFmWqHLfOGowpWiCTdrV
         aoXz3oN5H5S/ld2X28arkKKxMWrjVHhUVZ/mwDn98UQj3+JdByaLTqDgN2qlnbMI+vnS
         4CgRsgXRN5sLURD3jeerr5QzT+IiyFHYfiPLstaCOn8s55NNrIhKJ2zxlah80uh48nOW
         FU/Es5vuM8ccTM2GWtL/28uB7CjTL4LCvZ/Fq7T3T6rMJNCKgBLNybn4BryOYorHX4LF
         NZ2C2ru1DQ+BX5pWhORf6yDMBQUuAkyTHMQ64CiNhkDURbNmg01ZkHzMAR7tvTXVJEEz
         nClw==
X-Gm-Message-State: APjAAAWN5fALIJDOD3nZ0R31OOdaTbQcUSJ8CoJLN6bKDTpI+CA9mqEy
        QBgRqfcNckBN9KoevO+e4xc=
X-Google-Smtp-Source: APXvYqw9NdHq62utjG0YxAoHI+vI5KR8q6IkFlGZanrHOMN/eyvdSo9/ZJ2znfartYuSWG0+aqajWg==
X-Received: by 2002:a63:2744:: with SMTP id n65mr15324394pgn.277.1565319826326;
        Thu, 08 Aug 2019 20:03:46 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 52/58] qla2xxx: Remove superfluous sts_entry_* casts
Date:   Thu,  8 Aug 2019 20:02:13 -0700
Message-Id: <20190809030219.11296-53-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The C language supports implicit casting of void pointers to non-void
pointers. Remove explicit sts_entry_* casts that are not necessary.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7533e420e571..5c65f2e67448 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1513,7 +1513,7 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		    if (comp_status == CS_DATA_UNDERRUN) {
 			    res = DID_OK << 16;
 			    bsg_reply->reply_payload_rcv_len =
-				le16_to_cpu(((sts_entry_t *)pkt)->rsp_info_len);
+				le16_to_cpu(pkt->rsp_info_len);
 
 			    ql_log(ql_log_warn, vha, 0x5048,
 				"CT pass-through-%s error comp_status=0x%x total_byte=0x%x.\n",
@@ -2256,11 +2256,8 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	struct bsg_job *bsg_job = NULL;
 	struct fc_bsg_request *bsg_request;
 	struct fc_bsg_reply *bsg_reply;
-	sts_entry_t *sts;
-	struct sts_entry_24xx *sts24;
-
-	sts = (sts_entry_t *) pkt;
-	sts24 = (struct sts_entry_24xx *) pkt;
+	sts_entry_t *sts = pkt;
+	struct sts_entry_24xx *sts24 = pkt;
 
 	/* Validate handle. */
 	if (index >= req->num_outstanding_cmds) {
@@ -2406,8 +2403,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	srb_t		*sp;
 	fc_port_t	*fcport;
 	struct scsi_cmnd *cp;
-	sts_entry_t *sts;
-	struct sts_entry_24xx *sts24;
+	sts_entry_t *sts = pkt;
+	struct sts_entry_24xx *sts24 = pkt;
 	uint16_t	comp_status;
 	uint16_t	scsi_status;
 	uint16_t	ox_id;
@@ -2425,8 +2422,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	uint16_t state_flags = 0;
 	uint16_t retry_delay = 0;
 
-	sts = (sts_entry_t *) pkt;
-	sts24 = (struct sts_entry_24xx *) pkt;
 	if (IS_FWI2_CAPABLE(ha)) {
 		comp_status = le16_to_cpu(sts24->comp_status);
 		scsi_status = le16_to_cpu(sts24->scsi_status) & SS_MASK;
-- 
2.22.0

