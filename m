Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BE1C0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF248216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405001AbfHIDCt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:47029 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404954AbfHIDCt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:49 -0400
Received: by mail-pg1-f194.google.com with SMTP id w3so7891629pgt.13
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S9wNt+UCeEZPDiQ/mBnDZlKn9KvuNIZNqlgyMpGEygE=;
        b=EUQAK5abI0wHWgwztm0rN937i9wFWxbB/BQY0piqQiVZNQskAJrAzVHcxQWfS2p5c8
         F9B0YBVueOi7+0FTdu7VTiuToWbGbZriU80SdYcJy/jlFBj5qLq7JMI/BF0eprQ8r+6N
         VxGnnTpjVI/PQD3I/M0FPA+zdacVfzbg/Fuk777bh9nRj+tEga7kO0SoHbkP9zlEqBGm
         Zp2EG4ObHzUoHCCrTmGJzxsRLm2sZD5kPMxeGyID31Pv4FxVfvzFiJHoofgZPjpgSy28
         4lqoVgtOBtkzB4xBVFgY+Qm0HSh4ZgECkNhmWamzEw8yrFqOl7LbcgZBSoUbMyWBLBmh
         H7EA==
X-Gm-Message-State: APjAAAXX09agr+tu/mqllEJoJW4DL4ydIqrBOzG0nOK0OzppNFjpzkOI
        y6IkkqCzVj/yjM5xaCSrH9k=
X-Google-Smtp-Source: APXvYqxkfWjVKIYJBI6y8fAfIMmemVTkSzFuqWjKNzK1O0umKh2bK4YdvKEcgv88GM7mr+BI8rRlYw==
X-Received: by 2002:a62:e308:: with SMTP id g8mr19815697pfh.162.1565319768381;
        Thu, 08 Aug 2019 20:02:48 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 09/58] qla2xxx: Change the return type of qla2x00_update_ms_fdmi_iocb() into void
Date:   Thu,  8 Aug 2019 20:01:30 -0700
Message-Id: <20190809030219.11296-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The value returned by this function is not used. Hence change the
return type of this function into 'void' and remove the return
statement.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_gs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 7dc9eeb0c401..5ec3c2b96f3f 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1479,7 +1479,7 @@ qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size,
 	return ct_pkt;
 }
 
-static inline ms_iocb_entry_t *
+static void
 qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size)
 {
 	struct qla_hw_data *ha = vha->hw;
@@ -1493,8 +1493,6 @@ qla2x00_update_ms_fdmi_iocb(scsi_qla_host_t *vha, uint32_t req_size)
 		ms_pkt->req_bytecount = cpu_to_le32(req_size);
 		ms_pkt->req_dsd.length = ms_pkt->req_bytecount;
 	}
-
-	return ms_pkt;
 }
 
 /**
-- 
2.22.0

