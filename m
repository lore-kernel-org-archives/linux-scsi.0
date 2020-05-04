Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB9EC47258
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BEBC2075B
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAGGQNsw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgEDOUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728943AbgEDOUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:20:52 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6004CC061A0E;
        Mon,  4 May 2020 07:20:51 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id h4so8668563wmb.4;
        Mon, 04 May 2020 07:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZV8q7Yt6HpElSZoCMxiPcUAG2BqF2GevrGqBMwvpwfk=;
        b=UAGGQNswXNA4GJwrBnnAp4kdG+6/9zzePE2oEt3inKai/agU4OE1E+2BaAm8Cqn73y
         EDHtR+rl5hJi5FVgto1fsnFlYRLj01k19HLxa3QINkK/O5DdK5YE5fA+Li/+vhVmeB0c
         8EJe8j+V/rsy02mXjaVWZerdUFALNIe+JGDP5PKrpd8jDVXgQ3Ob4HBAQrfSkyM8wsUW
         L8fETolFCcCso9QufqsVbzFJLCH3bBtbGkRe66pWB+o9eiDgIwhY6oMBx151H0Na8QfM
         AJBArcIEOQ5q6WGj+ZcEnvxkO/ThLU+22kXnwMYo8Xo/tTeDdWXr7xk6mymoA8KFJuRK
         FABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZV8q7Yt6HpElSZoCMxiPcUAG2BqF2GevrGqBMwvpwfk=;
        b=jpV9gzIpsiHm5qYd/7KAX2hdx9awj+ouVOeC/0nPon1Y3v7k7t1bdM5lEaJ2YaTImE
         qsvcxlFvC1dt9/QW2FtxJ2oYN5MISUPA2m5CdaktRxXegoZN074PdfI0jLuvM32NQNWH
         D84DBL6VRwb+NYMIOYvpuldkqZ69YbDgREyms9TEAKu4UrEfyQ5hT3lnM4UWBPtYixd+
         uCfQ9kxJkQIYSxZ7ZlxxD2yZyzylEG2+liBrjf0B/3jutkKd4KJMRyDyl9UEN2k7Pw1Q
         ghKqw+ZDMIbjWnIKDxid7vSyUQaUXkfFAwZ4nZ76iycKcZdBLvCbV0F66iWChVj/Fns5
         rSXQ==
X-Gm-Message-State: AGi0PuYamogYzYAD47td8AAari7Z+5PLua/RhXmpGnBFJXUBMybK7ZCs
        tesIqz9blDHBPuJAlsjv2jc=
X-Google-Smtp-Source: APiQypI9+MwJBVd3iFCbvVR/Se7vYJZeKcQZCwkMzg1RxelVTKCdkZCz0+K4F9NSnTnF3/kA1hUN0w==
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr14498836wmu.94.1588602050107;
        Mon, 04 May 2020 07:20:50 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id p7sm19196140wrf.31.2020.05.04.07.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:20:49 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [RESENT PATCH RFC v3 2/5] scsi: ufs: make ufshcd_read_unit_desc_param() non-static func
Date:   Mon,  4 May 2020 16:20:29 +0200
Message-Id: <20200504142032.16619-3-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504142032.16619-1-beanhuo@micron.com>
References: <20200504142032.16619-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

HPB driver needs to read unit descriptors through ufshcd_read_unit_desc_param(),
make it an extern Function.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 +++-----
 drivers/scsi/ufs/ufshcd.h | 5 ++++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index de13d2333f1f..83ed2879d930 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3326,11 +3326,9 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, u8 desc_index,
  *
  * Return 0 in case of success, non-zero otherwise
  */
-static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
-					      int lun,
-					      enum unit_desc_param param_offset,
-					      u8 *param_read_buf,
-					      u32 param_size)
+int ufshcd_read_unit_desc_param(struct ufs_hba *hba, int lun,
+				enum unit_desc_param param_offset,
+				u8 *param_read_buf, u32 param_size)
 {
 	/*
 	 * Unit descriptors are only available for general purpose LUs (LUN id
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6ffc08ad85f6..7ce9cc2f10fe 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -856,7 +856,10 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
 extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-			struct ufs_pa_layer_attr *desired_pwr_mode);
+				  struct ufs_pa_layer_attr *desired_pwr_mode);
+extern int ufshcd_read_unit_desc_param(struct ufs_hba *hba, int lun,
+				       enum unit_desc_param param_offset,
+				       u8 *param_read_buf, u32 param_size);
 
 /* UIC command interfaces for DME primitives */
 #define DME_LOCAL	0
-- 
2.17.1

