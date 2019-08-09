Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D264C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77851216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405171AbfHIDDN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39954 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:13 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so45218362pfp.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SkPiSpXtq7+JKypo5L/igxM+iOqqA7NQjbXp1mRuSL0=;
        b=OLBznLQybYRzU6lTuBYuqafIiung459fH2MR2BW9vsb+xA4NlWsZQcjXtjpsZ1j0qB
         SySntmO+2iBlWfQMYAmvPne6zLTEMXJ6RwkeS/P1nOLLLgZ7jgx1i/lCHZnW+5kB6ggR
         0aYmIl2RQUajaOY/Vs/UfWa8zkZWaDu6Cm8LuGWUME2ySe2BH/Yj5zQNVQqfPZO+fOAb
         9XuyUmZUrKdJ6P845nykBLeNCyjMEwATxn1smPRraL+sboCCP+eAJlOb+TY1gKyXbtQ7
         lEjAUwh9DskX50BtcDYdTw1AlfwWN6aKzHnDDqHg7hN5aTVn7C6g4bI4Oikrvg/EBYij
         fReg==
X-Gm-Message-State: APjAAAUxX2y+wDXmVOCPEA7xr8uw9G6/xkE6/3x/hLjxilBeK85W6PT/
        tzAFovb+Zv5RBZIDPva6u2YbkT0r
X-Google-Smtp-Source: APXvYqykiyRiXyiGrDU7QApnBIb9t8i2FsOD1c3rJkq5bWQ8W6muxD6AqRIn9RtgiZLlnF6uOmi39g==
X-Received: by 2002:a62:1807:: with SMTP id 7mr18561683pfy.149.1565319792174;
        Thu, 08 Aug 2019 20:03:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 27/58] qla2xxx: Fix qla24xx_process_bidir_cmd()
Date:   Thu,  8 Aug 2019 20:01:48 -0700
Message-Id: <20190809030219.11296-28-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set the r??_data_len variables before using these instead of after.

This patch fixes the following Coverity complaint:

const: At condition req_data_len != rsp_data_len, the value of req_data_len
must be equal to 0.
const: At condition req_data_len != rsp_data_len, the value of rsp_data_len
must be equal to 0.
dead_error_condition: The condition req_data_len != rsp_data_len cannot be
true.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Fixes: a9b6f722f62d ("[SCSI] qla2xxx: Implementation of bidirectional.") # v3.7.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 11e420f8c493..240b07b0098a 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1782,8 +1782,8 @@ qla24xx_process_bidir_cmd(struct bsg_job *bsg_job)
 	uint16_t nextlid = 0;
 	uint32_t tot_dsds;
 	srb_t *sp = NULL;
-	uint32_t req_data_len = 0;
-	uint32_t rsp_data_len = 0;
+	uint32_t req_data_len;
+	uint32_t rsp_data_len;
 
 	/* Check the type of the adapter */
 	if (!IS_BIDI_CAPABLE(ha)) {
@@ -1888,6 +1888,9 @@ qla24xx_process_bidir_cmd(struct bsg_job *bsg_job)
 		goto done_unmap_sg;
 	}
 
+	req_data_len = bsg_job->request_payload.payload_len;
+	rsp_data_len = bsg_job->reply_payload.payload_len;
+
 	if (req_data_len != rsp_data_len) {
 		rval = EXT_STATUS_BUSY;
 		ql_log(ql_log_warn, vha, 0x70aa,
@@ -1895,10 +1898,6 @@ qla24xx_process_bidir_cmd(struct bsg_job *bsg_job)
 		goto done_unmap_sg;
 	}
 
-	req_data_len = bsg_job->request_payload.payload_len;
-	rsp_data_len = bsg_job->reply_payload.payload_len;
-
-
 	/* Alloc SRB structure */
 	sp = qla2x00_get_sp(vha, &(vha->bidir_fcport), GFP_KERNEL);
 	if (!sp) {
-- 
2.22.0

