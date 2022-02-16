Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77420C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 21:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiBPVEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 16:04:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbiBPVEA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 16:04:00 -0500
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF8D2AFEA3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:35 -0800 (PST)
Received: by mail-pg1-f179.google.com with SMTP id v22so2501783pgb.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 13:03:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cq307zyqkGB81Y1HPwnROoKgGyu5K7bZpTYHOrkG/uA=;
        b=vpgKcwHF3qWZNctx5oDgdYNTGxQzBZludZb0J1qoL+0wr3jPDxglXIs4o4aXrxcdkN
         N70c+6e0JpKkXR/nDYei44lOBXL+CS5p/aWiuRRE8D5zXN/kM1dgZWKV74KIE2zKLG45
         DN9gEasflgTYEZFg1TynBryIZ47V5Z70qwAgeM2HkfzDIkgeLHu01knKEc0/of60CmPU
         FMMyz5EILmQKYS2hgW7Q2bjb2GepVsj0Wiw6JilA8uFjUAegwXVrbzqJjptyWVEHLEm/
         daIbuhXQ1H3atOFwBLEHRwuWSnq8DKh8NLceuTxFrfOS9xSXi+1Q1OuE61xCUfp/cR11
         ZGHQ==
X-Gm-Message-State: AOAM531DosKkMBDOw2KBv9qL51iiHR5ZVslcR/OPc/WUL3Camp9xI2o2
        rWxRZWIveDANQ/TWnhI2Xwc=
X-Google-Smtp-Source: ABdhPJzTMfzRmq5F6fYzUytqlNjDSM3nm6Fr4J2NE0UnybGo7FjuDt3S4qf3CZFtI/Ax8uBkDH3jcg==
X-Received: by 2002:a05:6a00:26c1:b0:4e1:3135:97a9 with SMTP id p1-20020a056a0026c100b004e1313597a9mr5237994pfw.13.1645045414536;
        Wed, 16 Feb 2022 13:03:34 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c8sm46591222pfv.57.2022.02.16.13.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 13:03:33 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v4 24/50] scsi: hptiop: Stop using the SCSI pointer
Date:   Wed, 16 Feb 2022 13:02:07 -0800
Message-Id: <20220216210233.28774-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220216210233.28774-1-bvanassche@acm.org>
References: <20220216210233.28774-1-bvanassche@acm.org>
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
