Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07019C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4969216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405260AbfHIDDb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:31 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45992 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:31 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so45082453pgp.12
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l88yOM7cXltR/foMYhxySygY1ea0s2CxhneY5TuTu6E=;
        b=l63x2GPeHvW0PWuIcot7pOtzcrP2rDQHRYLb1o1iltBMaiu+aqtFssd7aasCGRSMMr
         O6hSjhrgQSjm84sCkhAyGd48Mt7MFzeLKWZbhJUauizbgh+QM59ZSZtLmtWMnXCmsbCu
         aoiMifZaHmrbHFissO6L0wJvOZu4qG00ljLk9kPj7o+j9EGMaAz0CDWhNQMM88dTSZs0
         XP9LBuGiwXqycE6Jo0dZqiBQwe5YSwEKIWOBX3q647sWOHMSyPIyFuA9iTUhMS6b91XG
         N5UwrZeUhgHY9hvSnt5ii+0LZFt5RJCJpThlyk2M8XdktS1iMTDHaKzSxM2Xh0Q7RIBv
         cNHA==
X-Gm-Message-State: APjAAAV2AybDpw+IEVFVnSFQ/Ou8rq3dsxUaodYA2bWoQMR6WUUTDNaU
        JOFrbMuM+AoSwCmJUq22pvw=
X-Google-Smtp-Source: APXvYqzJrLzeDtiNsrDPx2HIMgYIRm5I45KtWS079LNwS4X06LlKR/QHssWE7GJLluANqlfcbhi1CQ==
X-Received: by 2002:a17:90a:cb15:: with SMTP id z21mr7286372pjt.87.1565319810733;
        Thu, 08 Aug 2019 20:03:30 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:30 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 41/58] qla2xxx: Set the responder mode if appropriate for ELS pass-through IOCBs
Date:   Thu,  8 Aug 2019 20:02:02 -0700
Message-Id: <20190809030219.11296-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

According to the firmware documentation responder mode must be set for
ELS pass-through IOCBs if a response is expected.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c7b91827c1e7..2da7c92e320b 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2700,9 +2700,9 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 	els_iocb->s_id[0] = vha->d_id.b.al_pa;
 	els_iocb->s_id[1] = vha->d_id.b.area;
 	els_iocb->s_id[2] = vha->d_id.b.domain;
-	els_iocb->control_flags = 0;
 
 	if (elsio->u.els_logo.els_cmd == ELS_DCMD_PLOGI) {
+		els_iocb->control_flags = 0;
 		els_iocb->tx_byte_count = els_iocb->tx_len =
 			cpu_to_le32(sizeof(struct els_plogi_payload));
 		put_unaligned_le64(elsio->u.els_plogi.els_plogi_pyld_dma,
@@ -2718,6 +2718,7 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		ql_dump_buffer(ql_log_info, vha, 0x0109,
 		    (uint8_t *)els_iocb, 0x70);
 	} else {
+		els_iocb->control_flags = 1 << 13;
 		els_iocb->tx_byte_count =
 			cpu_to_le32(sizeof(struct els_logo_payload));
 		put_unaligned_le64(elsio->u.els_logo.els_logo_pyld_dma,
-- 
2.22.0

