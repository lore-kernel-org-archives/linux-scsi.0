Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C4C5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 19:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238504AbiBRTwp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 14:52:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbiBRTwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 14:52:41 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452B92905BA
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:18 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id y11so3130778pfa.6
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 11:52:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cq307zyqkGB81Y1HPwnROoKgGyu5K7bZpTYHOrkG/uA=;
        b=3A91GWeQWf60oGN4mqxXjamobME7vNsP9WhKT3y196Cld2MEnjVIIAye5AECbFgkwM
         pv0lAqiAV2Zu63qo8Y2RYszvKBxiMA6o29jLKM+ml8W494dRjOlcgtln+iiI7aE3f5GJ
         wZ6sRPzgWGGX7X4LTxpz3dfvLSVikWI2yl91uNJCDXwU6Np5X9f8Vg8HJqB0P6b8EYmE
         A6FUnmf/CwXhlxIUK27bgIMg9lww1YEUIAMZ3mlTCm6ms0oUezeJa9vy64j1M7N+iS4U
         fq1INBx9MqhLxR7cwOIq/ECULXni0v2VVxPwZzv3OCucIJ/36Y4cTBFEfLQh1f1v5QcU
         78eQ==
X-Gm-Message-State: AOAM530iTXb9xy2KOJOnnB1aYt0IBXDMGczPGRt3ivjDazq5pUV55F7M
        GsXGYZ1xVUCfylAax5uUWCI=
X-Google-Smtp-Source: ABdhPJw0EfX4QNUB/ZXJBCwxReadkzHwo+cQUajkEegZmsI25ZXkqSWa7Ib8DvrDnhdbaKQLlzCzkg==
X-Received: by 2002:a63:ec0f:0:b0:373:a3e9:10a7 with SMTP id j15-20020a63ec0f000000b00373a3e910a7mr7412140pgh.149.1645213937708;
        Fri, 18 Feb 2022 11:52:17 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id e15sm3930523pfv.104.2022.02.18.11.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 11:52:16 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v5 23/49] scsi: hptiop: Stop using the SCSI pointer
Date:   Fri, 18 Feb 2022 11:50:51 -0800
Message-Id: <20220218195117.25689-24-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218195117.25689-1-bvanassche@acm.org>
References: <20220218195117.25689-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Rename hpt_scsi_pointer into hpt_cmd_priv because that data structure is
not related to struct scsi_pointer.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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
