Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C20DFC38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:39:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1F48208CA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:39:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Cdl5o327"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgEHIjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHIjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:39:10 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C718C05BD43
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 01:39:10 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so876541wrx.4
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 01:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0vya7SWjO5MR/s1q4SIzFUX/OwI+bS7G5Dyr0Qzw240=;
        b=Cdl5o327B83K5/4QizbL3yUCxmx3kTqStVzXDRHye+ky8iThBvlz0T+SAJeIfay9o+
         Rwu4rhe5YfJnzbNo2n/J1Z0jVtbkx7UOik2KwWhG3EFASi3oeSwMTm5wXVEjfw/UBEFo
         3duhlh5pHNUWlN0t3uhUJjI1z9LfTYiXk/Pu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0vya7SWjO5MR/s1q4SIzFUX/OwI+bS7G5Dyr0Qzw240=;
        b=squco6CW2GGtzBg7V923DAe+Wajnhq1NsMWAthPxTs2mJF1vSsMu2ACkHSIPUBJY2L
         P9ISNus0423HS9LSWIc0ctRcuaoHTjW7YyfRC5yrNf9u02TEF99VJwRI6fF8f6MOHPuM
         qledq8g/m5MX+wUnjCxmJo0F3le37FhnYrPk4vKUEzdW4CoStKiNxsC2na+6VZozMbT6
         9i5flv1YA8OKqqGQK8Xs6FVKGA8qHyLZcMd7BcYP5JM0+3gSGDC/Dk0Qx9UxP6xOL/hl
         CB+8mkb2sry2lT0wpZ7zyVJLItlAVlBmLRnR5D4X/dkJOGccqLakWJVSs5VJgmTN/3UQ
         ADvg==
X-Gm-Message-State: AGi0Pua4foFxrlgKv5zkDSXL++/ukuhVvsBPN4yVc9dq9DzPP5toYBJy
        BhEftX4UCP009tIFqyApoJLgujd7bjnLxJzsK6OdBDlNEvx1rUYYZLzjKAe5Ywr90jvn9aX9VZV
        msjwrbS/e259bQHmYnda78uWiPmiKKvJEDth62zXtzUHOxZI91rIuKJp8R23aD5cQCwbWN7BLKp
        HcP7Hu6bXtu6Kb
X-Google-Smtp-Source: APiQypJaUY91HH2hjMyYOPnV4CxSkwjfp34DZXaz7vK/xOtMgfEghPjldTO6Af6sQjl5eRYylqHJtw==
X-Received: by 2002:a5d:50ce:: with SMTP id f14mr1699554wrt.251.1588927148860;
        Fri, 08 May 2020 01:39:08 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a8sm1810240wrg.85.2020.05.08.01.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:39:08 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 2/5] megaraid_sas: Remove IO buffer hole detection logic
Date:   Fri,  8 May 2020 14:08:35 +0530
Message-Id: <20200508083838.22778-3-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20200508083838.22778-1-chandrakanth.patil@broadcom.com>
References: <20200508083838.22778-1-chandrakanth.patil@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As blk_queue_virt_boundary() API in slave_configure ensures that no IOs
will come with holes/gaps. Hence, code logic to detect the holes/gaps in
IO buffer is not required.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 58 -----------------------------
 1 file changed, 58 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e0f923b..87f91a38 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2070,7 +2070,6 @@ static bool
 megasas_is_prp_possible(struct megasas_instance *instance,
 			struct scsi_cmnd *scmd, int sge_count)
 {
-	int i;
 	u32 data_length = 0;
 	struct scatterlist *sg_scmd;
 	bool build_prp = false;
@@ -2099,63 +2098,6 @@ megasas_is_prp_possible(struct megasas_instance *instance,
 			build_prp = true;
 	}
 
-/*
- * Below code detects gaps/holes in IO data buffers.
- * What does holes/gaps mean?
- * Any SGE except first one in a SGL starts at non NVME page size
- * aligned address OR Any SGE except last one in a SGL ends at
- * non NVME page size boundary.
- *
- * Driver has already informed block layer by setting boundary rules for
- * bio merging done at NVME page size boundary calling kernel API
- * blk_queue_virt_boundary inside slave_config.
- * Still there is possibility of IO coming with holes to driver because of
- * IO merging done by IO scheduler.
- *
- * With SCSI BLK MQ enabled, there will be no IO with holes as there is no
- * IO scheduling so no IO merging.
- *
- * With SCSI BLK MQ disabled, IO scheduler may attempt to merge IOs and
- * then sending IOs with holes.
- *
- * Though driver can request block layer to disable IO merging by calling-
- * blk_queue_flag_set(QUEUE_FLAG_NOMERGES, sdev->request_queue) but
- * user may tune sysfs parameter- nomerges again to 0 or 1.
- *
- * If in future IO scheduling is enabled with SCSI BLK MQ,
- * this algorithm to detect holes will be required in driver
- * for SCSI BLK MQ enabled case as well.
- *
- *
- */
-	scsi_for_each_sg(scmd, sg_scmd, sge_count, i) {
-		if ((i != 0) && (i != (sge_count - 1))) {
-			if (mega_mod64(sg_dma_len(sg_scmd), mr_nvme_pg_size) ||
-			    mega_mod64(sg_dma_address(sg_scmd),
-				       mr_nvme_pg_size)) {
-				build_prp = false;
-				break;
-			}
-		}
-
-		if ((sge_count > 1) && (i == 0)) {
-			if ((mega_mod64((sg_dma_address(sg_scmd) +
-					sg_dma_len(sg_scmd)),
-					mr_nvme_pg_size))) {
-				build_prp = false;
-				break;
-			}
-		}
-
-		if ((sge_count > 1) && (i == (sge_count - 1))) {
-			if (mega_mod64(sg_dma_address(sg_scmd),
-				       mr_nvme_pg_size)) {
-				build_prp = false;
-				break;
-			}
-		}
-	}
-
 	return build_prp;
 }
 
-- 
2.9.5

