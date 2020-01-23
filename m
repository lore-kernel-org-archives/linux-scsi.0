Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D274DC33CAA
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B38F624125
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 04:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgAWEYC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 23:24:02 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36437 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgAWEYC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 23:24:02 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so704631pgc.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 20:24:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gHUpc4aIhYZMfKp3dMo0ZA46Tg26g1TgLcTwggGP2GE=;
        b=CEpZ5b3nWG9RmSmAW1TKPAcXlvarxSkR4yFpBy07fwethxzfnM8OFHuZgKUvZMQ8gx
         VgMRHxPYrR8KL6urmcO/8R1lYoehVW2mDbnxzDirWEoIHOaUO0eThXw0RU7Rs8kfijfY
         fqziNn7aOiVShv+RSQqQmcOQ/G65N/PqZyDYoBtnDp1YgbQl+meaPhhj7a87HvUxLVEG
         G3TtP2cOwcyCxRH5Vj6WhjykZwiYPDE8ym9iemKeMwt2c9esXgfi8otaWybAi22GdSTr
         YpaUfWIh9gxhxoyFLzYut5289uNkK1E2nboL3Gzo381ajbs+7vFoMBW7DY/jE56pyJyS
         8lTg==
X-Gm-Message-State: APjAAAU6O8QziSBz6Tod2MmlKtgIQUcQAji5ZZerl9drWJqN/SPWV09I
        FM8YZF8Juav9mzr2BGT4pVU=
X-Google-Smtp-Source: APXvYqzaXZjLUt1h6bFULom9d/aEBhE3LqvutIhWfJuWfRASzsmv7H2qxIygNV3OG0JHlteSkbj9sw==
X-Received: by 2002:aa7:8115:: with SMTP id b21mr5864604pfi.80.1579753441431;
        Wed, 22 Jan 2020 20:24:01 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id p16sm492879pfq.184.2020.01.22.20.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 20:24:00 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH v2 6/6] qla2xxx: Fix the endianness annotations for the port attribute max_frame_size member
Date:   Wed, 22 Jan 2020 20:23:45 -0800
Message-Id: <20200123042345.23886-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200123042345.23886-1-bvanassche@acm.org>
References: <20200123042345.23886-1-bvanassche@acm.org>
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

Cc: Quinn Tran <qutran@marvell.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Daniel Wagner <dwagner@suse.de>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h |  4 ++--
 drivers/scsi/qla2xxx/qla_gs.c  | 14 ++++++--------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 968f19995063..5c6bae116b58 100644
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
