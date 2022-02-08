Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13C62C43217
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 17:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384333AbiBHR0b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 12:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384369AbiBHR0X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 12:26:23 -0500
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85154C03FEF8
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 09:26:18 -0800 (PST)
Received: by mail-pl1-f177.google.com with SMTP id x4so6820298plb.4
        for <linux-scsi@vger.kernel.org>; Tue, 08 Feb 2022 09:26:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A+44DMy94HOJfP4Bup7v0v6bbrKOue24BlG14X4wjYo=;
        b=P5ZgEbNi6WkP+srFkmBunj+5cz0TPHsPVNBwBnxvCKqgifl74luRMvOmkM5Whmux0Q
         hV93Rzsci463A9gBJTqjk4WkShUm9ohM83TDGHUKSOibJlHFylut/h6LwhpT+JnaYpak
         qtzI4WEYO01AhfI/KiNXDXZlxBoN4CRpc+Uuv/rLFgzhl3FrrL2qpHFOHp2/UIPT1t2z
         bKFCaF8yaOKlVIORPUV67q30/2bu9fel60PpIF5spW89Ue3w0rxQxl66ZYs2klH+CTax
         QHonaNX5oSsc0Z6gjQW2GaSMMEfna7bUCrRO3hT0G8OeprOkrD6jMbY6cAE3Q33lk3m/
         fLzQ==
X-Gm-Message-State: AOAM533tPEw3+m9eOr6K2M4QcFT8aoYpz8agemB8TAWkle2ZM56n6mzu
        pHdQpS8KR5lxzrviioOAR4s=
X-Google-Smtp-Source: ABdhPJwbRbK3m64PKlK9Dxh9AqKjcitDsY32sPrHUz2GtAjNmdbl3EswF9E9EELs65Yry5T9/BvnvA==
X-Received: by 2002:a17:902:7603:: with SMTP id k3mr5605093pll.166.1644341177717;
        Tue, 08 Feb 2022 09:26:17 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q1sm335116pfs.112.2022.02.08.09.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 09:26:17 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 20/44] hptiop: Stop using the SCSI pointer
Date:   Tue,  8 Feb 2022 09:24:50 -0800
Message-Id: <20220208172514.3481-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220208172514.3481-1-bvanassche@acm.org>
References: <20220208172514.3481-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set .cmd_size in the SCSI host template instead of using the SCSI pointer
from struct scsi_cmnd. This patch prepares for removal of the SCSI pointer
from struct scsi_cmnd.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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
