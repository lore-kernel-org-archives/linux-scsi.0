Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DFA7C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353915AbiBKWeG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:34:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354128AbiBKWeA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:34:00 -0500
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B5CD55
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:58 -0800 (PST)
Received: by mail-pj1-f51.google.com with SMTP id om7so9278906pjb.5
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:33:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cq307zyqkGB81Y1HPwnROoKgGyu5K7bZpTYHOrkG/uA=;
        b=4WG0yDoHRXNRngbGLeuVC6aHYn8vXE0XRfySUXEcyXqIIisA+fV6PwLss0QjahGNEt
         49Owll9hxfkPhcnPJCR+D8g4jE4IQm8am0tmVgXcuiiqCCmTFp3yIThQwZiOF7ZddqcM
         s9dkmKPjivOtDg/3lj85jkvTINh01i99EysC2yIcJ98R87ZnTUcEo1CGJS2ku/YO9KVr
         nsDuYePCANPZNP+36Z0cmiSE04QBAR5ZGJBpV6na6NmHxuv+FrujsPrjIEJbsv9QGtkH
         2PNtVuTCJ+tdSc4DPsYzUgau/AkQ7jiTeJbM6M9XLxUwRRq9VjC1Uz6yBHPrVAFmKqli
         cllQ==
X-Gm-Message-State: AOAM532ydH+DegWVxI5WAOU8K+QDXhWb79q7bf7hrxZe4G2sEmioNXzf
        XX7ZkwGjPIGF0IjWBeKe70g=
X-Google-Smtp-Source: ABdhPJyEzQOiHN5ksgWB3oMrIjAy8b1KwFQq7epo6J96m/RnhPH+5wQhFt4zvdhs2ROheM0qc/ZDcQ==
X-Received: by 2002:a17:90b:2509:: with SMTP id ns9mr2525575pjb.185.1644618838082;
        Fri, 11 Feb 2022 14:33:58 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n13sm6296733pjq.13.2022.02.11.14.33.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 14:33:57 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 24/48] scsi: hptiop: Stop using the SCSI pointer
Date:   Fri, 11 Feb 2022 14:32:23 -0800
Message-Id: <20220211223247.14369-25-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220211223247.14369-1-bvanassche@acm.org>
References: <20220211223247.14369-1-bvanassche@acm.org>
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
