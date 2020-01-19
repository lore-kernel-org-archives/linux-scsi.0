Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217F3C33CB7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E646D2467C
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fb/I1AUO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgASAOP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 19:14:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51410 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgASAOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 19:14:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id d73so10892868wmd.1;
        Sat, 18 Jan 2020 16:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ugnjhMRTmnK+PtKom+FYsDk92nymRWFHwav/7Qa5gLg=;
        b=fb/I1AUO9WZ+sdrn1r9HSCuC3R4I3ezam0h3JleUYJACLuGWZ1tdZfA5gAfKviiP0Z
         HS8qM1r6zT+B/jWR5VJYIPCSi493opNtjZRuGDg4hwxi5fcuMLYJnXyHYOFTE5ViFK0Q
         QHybKJJc45aVFTdfBhE+yAtK8I9mKrl2hLeDif+Ae5nhKiBMSfZE+SwdjaeA5+eoIXja
         K4UxFp4ULvpgy+4bHNElNTZ70lQdDdfsNEHASiuLdTRXBid1awWV0DVYIXl3F41mlH2L
         NQQOsRl2623Udvzc2iAXa7hkI+IlLxG+t2pFLAaQzwaKBifseUBUiIT2BmOVkJ9PmlN5
         JzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ugnjhMRTmnK+PtKom+FYsDk92nymRWFHwav/7Qa5gLg=;
        b=laJH/2SHm6GE2GmArH948iXWn28kBe26ghRIPR5nyA9VfU0wlBHloWmYdey/tqp2Ly
         ENRAlL5p3r2yG5SWQjXeTL3D6RGMZPjAWeifayJMALtBHJI2zA4ODCmeZalofCHE0GFi
         Y+ApOEGWenElEAt4GhN/SmSyPfAWEVTkXwbSlvdGqL6D2jez3hj6HpWyqrNMb22ApTGe
         VZWEdow8Q/5ufuGzJuVe00wRLcLnCCF9YeCBzLPr1PfY0iOdmzxaxQvm2S6XGV6q1VGF
         AhESTfgvgBSlhklTlgWbgo5djEcVYzfmbFWmtFF8ytyOImHJfzpAprDUNQSRAhG/uq+Z
         X5og==
X-Gm-Message-State: APjAAAVSp+8IMDPhH2WpXGPFGvz1yzimSEq2FyxTuCsismStPIwH4sfj
        +IPtxEQuB+pfJ9qL+RtmH8o=
X-Google-Smtp-Source: APXvYqxUpkePkh24N2/Hepls/OnjrInhFI2HLhcjkT7bkk7t+M+FK7ghnFSMXJwvThrcwbOtpCntIA==
X-Received: by 2002:a1c:3187:: with SMTP id x129mr12358687wmx.91.1579392852886;
        Sat, 18 Jan 2020 16:14:12 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id i8sm42177432wro.47.2020.01.18.16.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 16:14:12 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/8] scsi: ufs: Delete is_init_prefetch from struct ufs_hba
Date:   Sun, 19 Jan 2020 01:13:25 +0100
Message-Id: <20200119001327.29155-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200119001327.29155-1-huobean@gmail.com>
References: <20200119001327.29155-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Without variable is_init_prefetch, the current logic can guarantee
ufshcd_init_icc_levels() will execute only once, delete it now.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +----
 drivers/scsi/ufs/ufshcd.h | 2 --
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5f3b0ad5135a..4f8fcbb5f92e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6967,8 +6967,7 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 {
 	int ret;
 
-	if (!hba->is_init_prefetch)
-		ufshcd_init_icc_levels(hba);
+	ufshcd_init_icc_levels(hba);
 
 	/* Add required well known logical units to scsi mid layer */
 	ret = ufshcd_scsi_add_wlus(hba);
@@ -6994,8 +6993,6 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
 	scsi_scan_host(hba->host);
 	pm_runtime_put_sync(hba->dev);
 
-	if (!hba->is_init_prefetch)
-		hba->is_init_prefetch = true;
 out:
 	return ret;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 32b6714f25a5..5c65d9fdeb14 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -501,7 +501,6 @@ struct ufs_stats {
  * @intr_mask: Interrupt Mask Bits
  * @ee_ctrl_mask: Exception event control mask
  * @is_powered: flag to check if HBA is powered
- * @is_init_prefetch: flag to check if data was pre-fetched in initialization
  * @init_prefetch_data: data pre-fetched during initialization
  * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
@@ -652,7 +651,6 @@ struct ufs_hba {
 	u32 intr_mask;
 	u16 ee_ctrl_mask;
 	bool is_powered;
-	bool is_init_prefetch;
 	struct ufs_init_prefetch init_prefetch_data;
 
 	/* Work Queues */
-- 
2.17.1

