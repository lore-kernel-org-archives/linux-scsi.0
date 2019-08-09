Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDAFC0650F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E927216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405066AbfHIDC5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:02:57 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44206 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405037AbfHIDC5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:02:57 -0400
Received: by mail-pg1-f195.google.com with SMTP id i18so45102967pgl.11
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:02:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6UM6XSKVz1SUyMd/W8Jpn0+UzVsvBO0gBX0loFbYfhU=;
        b=WayQV5n4jxqJxcqhRFiu7SQRbwsI6N8WI1RRUgEFwmS/rkklzQqlvPKNT1S64seIpm
         Uc5C3sVB+BRe9JsziFYcEtbFN+Nk+VJLiMp/16/600Wg28mumf80DkuiOfLGMkjmTn5S
         0tuuld2NLFVLJFvYJ8kHqUYMbpBAIlbkbB3FNnYs+aBtyhflGL7Dx/1CLNsdVd5VXgnO
         OYkRGLT7FcCscyjfS1isFWtJd5+bucFm4whvNsumE5Qu4Hn429Xpsmw/nLClU1qYv+TI
         D3lmr/AyvQeliTEfJGRTGtybHJlh3MDM3LOs3Vn9x1H7f9KlN7fN6oraDQy1vqbMOQIo
         ViKw==
X-Gm-Message-State: APjAAAUZZsQ7RXoyzRMRWz0SM/s31udZPzxVOPJhVX12WV29uhfcwJ+d
        SlF5+5x5Qz811Uv6Bb0I9eM=
X-Google-Smtp-Source: APXvYqyck6FNZU4azrxWJAiRs1yBDGHpdO1r0pWuwEi9R/26OJVVpq+A5IAIcodHYzNzkkGwlrWjWA==
X-Received: by 2002:a63:1b66:: with SMTP id b38mr15618126pgm.54.1565319776166;
        Thu, 08 Aug 2019 20:02:56 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.02.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:02:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 15/58] qla2xxx: Simplify qlt_lport_dump()
Date:   Thu,  8 Aug 2019 20:01:36 -0700
Message-Id: <20190809030219.11296-16-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify the implementation of this function by using the %phC format
specifier instead of using explicit for-loops.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 3a25536c2492..221912da67c6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6497,22 +6497,10 @@ void qlt_remove_target_resources(struct qla_hw_data *ha)
 static void qlt_lport_dump(struct scsi_qla_host *vha, u64 wwpn,
 	unsigned char *b)
 {
-	int i;
-
-	pr_debug("qla2xxx HW vha->node_name: ");
-	for (i = 0; i < WWN_SIZE; i++)
-		pr_debug("%02x ", vha->node_name[i]);
-	pr_debug("\n");
-	pr_debug("qla2xxx HW vha->port_name: ");
-	for (i = 0; i < WWN_SIZE; i++)
-		pr_debug("%02x ", vha->port_name[i]);
-	pr_debug("\n");
-
-	pr_debug("qla2xxx passed configfs WWPN: ");
+	pr_debug("qla2xxx HW vha->node_name: %8phC\n", vha->node_name);
+	pr_debug("qla2xxx HW vha->port_name: %8phC\n", vha->port_name);
 	put_unaligned_be64(wwpn, b);
-	for (i = 0; i < WWN_SIZE; i++)
-		pr_debug("%02x ", b[i]);
-	pr_debug("\n");
+	pr_debug("qla2xxx passed configfs WWPN: %8phC\n", b);
 }
 
 /**
-- 
2.22.0

