Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F16C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C004216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404992AbfHIDDP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:15 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36558 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404934AbfHIDDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:15 -0400
Received: by mail-pf1-f196.google.com with SMTP id r7so45225243pfl.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4f/QZR+SZvQprZ1/NSrg51UrtG3sdEHcIsdSVbkAn9Q=;
        b=R4j7w+kVGO5eywCHEGgrWO/2Y2VYwsSEq0v3/ywm0uNDse5KbzJrQNaUUG+eaqs2GE
         3CNIE5p2ZqPARUDHmXvSZLv1VtySGn/toCFlICiJo74AoZ/siMKTcU2qS2bQ1YU2UXnY
         2rGad0PY/lMkQBlpSVx0xbvPwxHINL64Y67pkuQeY6nH/5yNc7VNDZ+YSfoCugSLaPqO
         MVHYl/igmLqbDBv8yAgiYp+YCjTu331y7cdjGK3tmtj2h31c7P0ihTwZVxPCZx367BXQ
         16aH3EBqzScxXQ8GLFouYfF2SHbXqczoiFrUnXgeKs4Wiwqu1LzrtUW9uiTFfRnq+/VD
         4gRA==
X-Gm-Message-State: APjAAAVClczpCi6nWyJMc+XHvyn3IKOdQVrliMvE6YDbHQ/QYoMZdSue
        E8YrJFiMSH4gRSjq/+g9ery9/SDp
X-Google-Smtp-Source: APXvYqwR9Vo4FiRs2WzI4nHWtaoQqbjEC9GiOe80BeoYlIQLnHzXro75h0GJNkyZcLimDCjFMKQOOw==
X-Received: by 2002:a17:90b:f0e:: with SMTP id br14mr7169908pjb.117.1565319794964;
        Thu, 08 Aug 2019 20:03:14 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:14 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 29/58] qla2xxx: Suppress a Coveritiy complaint about integer overflow
Date:   Thu,  8 Aug 2019 20:01:50 -0700
Message-Id: <20190809030219.11296-30-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes the following Coverity complaint:

Unintentional integer overflow (OVERFLOW_BEFORE_WIDEN)
overflow_before_widen: Potentially overflowing expression dma_eng_num *
65536U with type unsigned int (32 bits, unsigned) is evaluated using 32-bit
arithmetic, and then used in a context that expects an expression of type
uint64_t (64 bits, unsigned).

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_nx2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 369ac04d0454..c056f466f1f4 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -2810,7 +2810,7 @@ qla8044_minidump_process_pollrdmwr(struct scsi_qla_host *vha,
 
 #define ISP8044_PEX_DMA_ENGINE_INDEX		8
 #define ISP8044_PEX_DMA_BASE_ADDRESS		0x77320000
-#define ISP8044_PEX_DMA_NUM_OFFSET		0x10000
+#define ISP8044_PEX_DMA_NUM_OFFSET		0x10000UL
 #define ISP8044_PEX_DMA_CMD_ADDR_LOW		0x0
 #define ISP8044_PEX_DMA_CMD_ADDR_HIGH		0x04
 #define ISP8044_PEX_DMA_CMD_STS_AND_CNTRL	0x08
-- 
2.22.0

