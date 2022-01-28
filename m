Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA69C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 22:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344189AbiA1WVb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:21:31 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:47085 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351385AbiA1WVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 17:21:16 -0500
Received: by mail-pf1-f170.google.com with SMTP id i17so7413783pfq.13
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 14:21:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ufpGEBX7rtVzYB5aaxAEIaVpWVppN/QLDu6iqUSiOZs=;
        b=l2t80GjLYqycExHXG4o690DC+vZ/NWUZG8JhEPT3vDB0+DfeUaFViVLejKF0BL2DT4
         SEkdw8jQH5WtVs4U3oS5gWRn3Xq+43SrLLGeSzcNAe2H8ncluP+6TkZNtqAxJRQLLTSd
         YeP0hkNz4r9lq5KFUpQHWmq9qk5EzOA7mWugpi/w3IoHWULqTGdKiI5K6pr3yxhYG8M9
         Zs4VU0rQHG6d7ZVoYQxE+fpo7m5B0KlAjJZOY7rLYvwHFSHXrUQaBJDa0qnZ4eRjSgX8
         RSKzpBi/+Bc4UeeqP6QrBt51a+Q2QcyxkmwClowbfd5LbAn9JfZbl1JwFZGqztSxES6C
         1BLA==
X-Gm-Message-State: AOAM532SG2JS1L6HomQzq/BjsGAB0qdfwaydogJK3W+8JLcYEssBpCLR
        bk6ndPnhzDFTA9wMA3k1/uQ=
X-Google-Smtp-Source: ABdhPJxqrLMRX8L0I4dCvNf7M7ybtoHXo73Gx2lB5Q1JNzuBTfd501PkO/DTJrSFHHzWI9w+ShDXgg==
X-Received: by 2002:a05:6a00:23ce:: with SMTP id g14mr10155815pfc.13.1643408476078;
        Fri, 28 Jan 2022 14:21:16 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id t2sm7787931pfg.207.2022.01.28.14.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:21:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 20/44] hptiop: Stop using the SCSI pointer
Date:   Fri, 28 Jan 2022 14:18:45 -0800
Message-Id: <20220128221909.8141-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128221909.8141-1-bvanassche@acm.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hptiop.c | 1 +
 drivers/scsi/hptiop.h | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index d04245e379d7..f18b770626e6 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1174,6 +1174,7 @@ static struct scsi_host_template driver_template = {
 	.slave_configure            = hptiop_slave_config,
 	.this_id                    = -1,
 	.change_queue_depth         = hptiop_adjust_disk_queue_depth,
+	.cmd_size		    = sizeof(struct hpt_cmd_priv),
 };
 
 static int hptiop_internal_memalloc_itl(struct hptiop_hba *hba)
diff --git a/drivers/scsi/hptiop.h b/drivers/scsi/hptiop.h
index 35184c2008af..363d5a16243f 100644
--- a/drivers/scsi/hptiop.h
+++ b/drivers/scsi/hptiop.h
@@ -251,13 +251,13 @@ struct hptiop_request {
 	int                   index;
 };
 
-struct hpt_scsi_pointer {
+struct hpt_cmd_priv {
 	int mapped;
 	int sgcnt;
 	dma_addr_t dma_handle;
 };
 
-#define HPT_SCP(scp) ((struct hpt_scsi_pointer *)&(scp)->SCp)
+#define HPT_SCP(scp) ((struct hpt_cmd_priv *)scsi_cmd_priv(scp))
 
 enum hptiop_family {
 	UNKNOWN_BASED_IOP,
