Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AC69C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67F8E216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405045AbfHIDCy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35922 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404954AbfHIDCx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:53 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so44384105plt.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AVOSMkwyj9JK2yCJxSF54qItMXHF3IjzdZGiXCGdU6M=;
        b=feIf2ZJ99fjANOWy32IVNsMeu6CPy4xcP4uHWsJ5zCpBXEGpKbhBMpRtS9X2GYFXnK
         uRJmjPtsp1322cjYR93xLhJYiCP9lq9pqep+Y+ywyUViBRTilX/4b4K0xeimhRUkiGt8
         9RXjA5VVOA+BB9oI0OyLlKLRu+scOKCxVgDYJf2P1St1Tu4KpAgKAnqBz19RZWMCy/o/
         B8I3UpqN96ldY6OabUa9ShysTqhWfvDMd/8UYcVbE9IdnHSDSMTFICDaMFDZpxZbiJGP
         kZKksbKQivgLlNNnilIEA4hRuBIWBLQcx13onXGTd6XZUHE89BNRbF20ddg2FUilvwyx
         737g==
X-Gm-Message-State: APjAAAUGjb8SKGu8nZprsI2ajF5gYxUH29HE5g5/ANKIqIifAqlCeqH5
        s+LSQbNFk7/aQjMUyi1Ss2Q=
X-Google-Smtp-Source: APXvYqzNtDQ0akQnGCptmrwo3yp/hps/82YemT+cZQMg6TnRFDxHGYqLa42jPqvuLz78//HnjqvM2g==
X-Received: by 2002:a17:902:2f:: with SMTP id 44mr17168331pla.5.1565319772459;
        Thu, 08 Aug 2019 20:02:52 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 12/58] qla2xxx: Change data_dsd into an array
Date:   Thu,  8 Aug 2019 20:01:33 -0700
Message-Id: <20190809030219.11296-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but fixes a Coverity
complaint about using a scalar as an array.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h    | 4 ++--
 drivers/scsi/qla2xxx/qla_iocb.c   | 4 ++--
 drivers/scsi/qla2xxx/qla_target.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a94b0d440f0f..1c6811bd5625 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1852,7 +1852,7 @@ struct crc_context {
 			uint16_t	reserved_2;
 			uint16_t	reserved_3;
 			uint32_t	reserved_4;
-			struct dsd64	data_dsd;
+			struct dsd64	data_dsd[1];
 			uint32_t	reserved_5[2];
 			uint32_t	reserved_6;
 		} nobundling;
@@ -1862,7 +1862,7 @@ struct crc_context {
 			uint16_t	reserved_1;
 			__le16	dseg_count;	/* Data segment count */
 			uint32_t	reserved_2;
-			struct dsd64	data_dsd;
+			struct dsd64	data_dsd[1];
 			struct dsd64	dif_dsd;
 		} bundling;
 	} u;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b514ab4d243e..6b120254f414 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1516,7 +1516,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	}
 
 	if (!bundling) {
-		cur_dsd = &crc_ctx_pkt->u.nobundling.data_dsd;
+		cur_dsd = &crc_ctx_pkt->u.nobundling.data_dsd[0];
 	} else {
 		/*
 		 * Configure Bundling if we need to fetch interlaving
@@ -1526,7 +1526,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 		crc_ctx_pkt->u.bundling.dif_byte_count = cpu_to_le32(dif_bytes);
 		crc_ctx_pkt->u.bundling.dseg_count = cpu_to_le16(tot_dsds -
 							tot_prot_dsds);
-		cur_dsd = &crc_ctx_pkt->u.bundling.data_dsd;
+		cur_dsd = &crc_ctx_pkt->u.bundling.data_dsd[0];
 	}
 
 	/* Finish the common fields of CRC pkt */
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 4c5f9c02c379..b8241d7b1f8a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3163,7 +3163,7 @@ qlt_build_ctio_crc2_pkt(struct qla_qpair *qpair, struct qla_tgt_prm *prm)
 	pkt->crc_context_len = CRC_CONTEXT_LEN_FW;
 
 	if (!bundling) {
-		cur_dsd = &crc_ctx_pkt->u.nobundling.data_dsd;
+		cur_dsd = &crc_ctx_pkt->u.nobundling.data_dsd[0];
 	} else {
 		/*
 		 * Configure Bundling if we need to fetch interlaving
@@ -3173,7 +3173,7 @@ qlt_build_ctio_crc2_pkt(struct qla_qpair *qpair, struct qla_tgt_prm *prm)
 		crc_ctx_pkt->u.bundling.dif_byte_count = cpu_to_le32(dif_bytes);
 		crc_ctx_pkt->u.bundling.dseg_count =
 			cpu_to_le16(prm->tot_dsds - prm->prot_seg_cnt);
-		cur_dsd = &crc_ctx_pkt->u.bundling.data_dsd;
+		cur_dsd = &crc_ctx_pkt->u.bundling.data_dsd[0];
 	}
 
 	/* Finish the common fields of CRC pkt */
-- 
2.22.0

