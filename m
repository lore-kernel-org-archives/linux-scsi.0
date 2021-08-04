Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9CDC432BE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 18:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3144260F94
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 18:21:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbhHDSVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 14:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbhHDSVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 14:21:54 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0903BC06179F;
        Wed,  4 Aug 2021 11:21:41 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n12so3263354wrr.2;
        Wed, 04 Aug 2021 11:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EOPlhYtr33hzE6rG/6rS7PK/XlL3T5iZcV6qTZqwXjw=;
        b=OxGHXpFpgxFvDxbfcfFzN07Btb8Rpq7xEIQJKo0JULaMaODbAeJQ8Ji+o0m/WKqwxR
         dv3ncuTXEjyHOQvpwAd0pCVAoqPr2gY7ArH7e6M5B3+Il1o3CGlwHjZHYBY+Sk2So2vt
         assUFRK9nfl66oEsD3o4gxoudYFZJUuN2RuenfKglIrwiU4yopaVi4cp8ReJuxlZNSz9
         6Wtt3VnRNvNjKvGVMjUAgxfzKyvjmqDqqvYUVJ3G2wRA+6mVn/xky9YbTvOU39uijSZr
         lPUMNaLUgWH5Qq96mog9kV1YDO4VS52HlzUbxSQ443pAhYX9ryciLh+n77XqUpd9oFmZ
         cMBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EOPlhYtr33hzE6rG/6rS7PK/XlL3T5iZcV6qTZqwXjw=;
        b=OcwGebwaUWThVemm0ZIOmmmZpjzwhGBBrdCXaYWdNtvzDmhOvBJIjMnxteLQZW9xql
         6f9oYSsg/HOxULjd7pqcI1bbwjIZGM0vrjDlkqMDvHVyEqleDgOt/cl+5YHemcluacSn
         /rr6VWZcKeXcpLpgO7Fw7Ad6VL/8USE7zKRmnfOhgdv2hJgcdDAhF+4y2ahN34zQZN2f
         wv5/zIde/gi2tqxRwJ1RFj9bAq96wn6emg/9DVUNLTEtOzDa0DpxAStnMfCw1A1pxw2R
         qSRdm/UH96dCcAVh8KYg/8AntyaCTEUnYdUQRE1HYKOVbUfbqdBYsMfVDwJK+5yiBtw2
         xZBg==
X-Gm-Message-State: AOAM532MyDofsx8qq7/u+MqnHs5OX/UkFc4/eXa2V7APu5/sBXLr0l2l
        Ua0gozDFQMGe2l5qzMkXPtE=
X-Google-Smtp-Source: ABdhPJwayXyL/xUPIOKLuSpUajUSYK+zKSnOhHrfzwSEPWAqNjBJkZFDKgBp0ENEBp/s9CkzVsNhZA==
X-Received: by 2002:adf:f602:: with SMTP id t2mr690777wrp.232.1628101299580;
        Wed, 04 Aug 2021 11:21:39 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.gmail.com with ESMTPSA id n5sm2914880wme.47.2021.08.04.11.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 11:21:39 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, cang@codeaurora.org,
        daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] scsi: ufs: Add lu_enable sysfs node
Date:   Wed,  4 Aug 2021 20:21:28 +0200
Message-Id: <20210804182128.458356-3-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804182128.458356-1-huobean@gmail.com>
References: <20210804182128.458356-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

We need to check HPB being enabled on which LU from the userspace tool,
so, add lu_enable sysfs node.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 08fe037069bc..5c405ff7b6ea 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -1163,6 +1163,7 @@ static DEVICE_ATTR_RO(_pname)
 #define UFS_UNIT_DESC_PARAM(_name, _uname, _size)			\
 	UFS_LUN_DESC_PARAM(_name, _uname, UNIT, _size)
 
+UFS_UNIT_DESC_PARAM(lu_enable, _LU_ENABLE, 1);
 UFS_UNIT_DESC_PARAM(boot_lun_id, _BOOT_LUN_ID, 1);
 UFS_UNIT_DESC_PARAM(lun_write_protect, _LU_WR_PROTECT, 1);
 UFS_UNIT_DESC_PARAM(lun_queue_depth, _LU_Q_DEPTH, 1);
@@ -1181,8 +1182,8 @@ UFS_UNIT_DESC_PARAM(hpb_pinned_region_start_offset, _HPB_PIN_RGN_START_OFF, 2);
 UFS_UNIT_DESC_PARAM(hpb_number_pinned_regions, _HPB_NUM_PIN_RGNS, 2);
 UFS_UNIT_DESC_PARAM(wb_buf_alloc_units, _WB_BUF_ALLOC_UNITS, 4);
 
-
 static struct attribute *ufs_sysfs_unit_descriptor[] = {
+	&dev_attr_lu_enable.attr,
 	&dev_attr_boot_lun_id.attr,
 	&dev_attr_lun_write_protect.attr,
 	&dev_attr_lun_queue_depth.attr,
-- 
2.25.1

