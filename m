Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C0CC3404C
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1838824670
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 04:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgBTEe4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:34:56 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36885 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbgBTEe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2020 23:34:56 -0500
Received: by mail-pf1-f196.google.com with SMTP id p14so1264628pfn.4
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2020 20:34:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hwN8ZRq8wBXyha+OvuNmWwSRq7YmiVd1AXWng+qxW1Y=;
        b=KUH5yZdeNq/o3zWf7oHZrGvmZ2TmWoHmq5ouBv21ax8v1yteR5SfRrLR2wvGOmRr3y
         fSYGMOkN52jTrXu3GG9qP8EclJfE7MqkP7gYSDe7f2duCczSFdpu0lMe97oCvhj5Rm0A
         PGePEW6ZWdhmmI3jQYzOsa8bPPUD44USXHZ3aPBwY0Dq4OHJSliSkUvS9Xp0dYk+3Yxo
         hrYDH00qTlFh9dKYYCTXIN+ZBL9J6lKeBfWJqY/cIIStAXkdC3IRuRuMVwXPeniI1tDZ
         MqrFXLe1AWaN47pTyXrln/cKJqu7cJ8rBUzkoBATrK907OBfmgXFg/3HOXce+UqyA/iU
         XAaQ==
X-Gm-Message-State: APjAAAUM61+B8q40DjM/V2uup8jLEClWDezXUB1JfJPuEn6I/Y0XXRud
        VWBhrvPGFFqjaMOcQ2iWC+8=
X-Google-Smtp-Source: APXvYqw4sgCZv5fbCAaWD9ZDodpUQRQIw3Zda76Qwaqk8wUNAQFaD7JflLOIE7pqlwFdqS3/YIRMcw==
X-Received: by 2002:a62:e411:: with SMTP id r17mr28691356pfh.119.1582173295361;
        Wed, 19 Feb 2020 20:34:55 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:29a7:b1bb:5b40:3d61])
        by smtp.gmail.com with ESMTPSA id b5sm1236263pfb.179.2020.02.19.20.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 20:34:54 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Daniel Wagner <dwagner@suse.de>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v3 5/5] qla2xxx: Fix the endianness annotations for the port attribute max_frame_size member
Date:   Wed, 19 Feb 2020 20:34:41 -0800
Message-Id: <20200220043441.20504-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220043441.20504-1-bvanassche@acm.org>
References: <20200220043441.20504-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure that sparse doesn't complain about the statements that load or
store the port attribute max_frame_size member. The port attribute data
structures represent FC protocol data and hence use big endian format.
This patch only changes the meaning of two ql_dbg() statements.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  4 ++--
 drivers/scsi/qla2xxx/qla_gs.c  | 14 ++++++--------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cec0b5082927..c5c3a532f299 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2741,7 +2741,7 @@ struct ct_fdmiv2_port_attr {
 		uint8_t fc4_types[32];
 		uint32_t sup_speed;
 		uint32_t cur_speed;
-		uint32_t max_frame_size;
+		__be32	max_frame_size;
 		uint8_t os_dev_name[32];
 		uint8_t host_name[256];
 		uint8_t node_name[WWN_SIZE];
@@ -2772,7 +2772,7 @@ struct ct_fdmi_port_attr {
 		uint8_t fc4_types[32];
 		uint32_t sup_speed;
 		uint32_t cur_speed;
-		uint32_t max_frame_size;
+		__be32	max_frame_size;
 		uint8_t os_dev_name[32];
 		uint8_t host_name[256];
 	} a;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index aaa4a5bbf2ff..594b366db0ef 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1848,14 +1848,13 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
 	eiter->len = cpu_to_be16(4 + 4);
-	eiter->a.max_frame_size = IS_FWI2_CAPABLE(ha) ?
+	eiter->a.max_frame_size = cpu_to_be32(IS_FWI2_CAPABLE(ha) ?
 	    le16_to_cpu(icb24->frame_payload_size) :
-	    le16_to_cpu(ha->init_cb->frame_payload_size);
-	eiter->a.max_frame_size = cpu_to_be32(eiter->a.max_frame_size);
+	    le16_to_cpu(ha->init_cb->frame_payload_size));
 	size += 4 + 4;
 
 	ql_dbg(ql_dbg_disc, vha, 0x203c,
-	    "Max_Frame_Size=%x.\n", eiter->a.max_frame_size);
+	       "Max_Frame_Size=%x.\n", be32_to_cpu(eiter->a.max_frame_size));
 
 	/* OS device name. */
 	eiter = entries + size;
@@ -2419,14 +2418,13 @@ qla2x00_fdmiv2_rpa(scsi_qla_host_t *vha)
 	eiter = entries + size;
 	eiter->type = cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
 	eiter->len = cpu_to_be16(4 + 4);
-	eiter->a.max_frame_size = IS_FWI2_CAPABLE(ha) ?
+	eiter->a.max_frame_size = cpu_to_be32(IS_FWI2_CAPABLE(ha) ?
 	    le16_to_cpu(icb24->frame_payload_size) :
-	    le16_to_cpu(ha->init_cb->frame_payload_size);
-	eiter->a.max_frame_size = cpu_to_be32(eiter->a.max_frame_size);
+	    le16_to_cpu(ha->init_cb->frame_payload_size));
 	size += 4 + 4;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20bc,
-	    "Max_Frame_Size = %x.\n", eiter->a.max_frame_size);
+	       "Max_Frame_Size = %x.\n", be32_to_cpu(eiter->a.max_frame_size));
 
 	/* OS device name. */
 	eiter = entries + size;
