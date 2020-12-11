Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F152C2BBCA
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51D5323ED2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404672AbgLKOBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395190AbgLKOBo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 09:01:44 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB210C0617A6;
        Fri, 11 Dec 2020 06:00:53 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id k4so9463748edl.0;
        Fri, 11 Dec 2020 06:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ij2jWlbd33lTLBTZXg3PtNV3E0laB8helhKjcL0SZ3o=;
        b=bAegCaHUyMEMbburi06cxlaYRl+cCbKZXTdSpYVVHcHT/OxBDo6R/sFTMRcAdoVlhL
         6HPD85In1uAFXHEY4Zl0djrMj1tSXp0KH7/EToVkJPXhxw+NsS8Hr424Qky6bxo9gYQd
         +cwckb2vOtr3H5Cg7sdrZVIbPMQcyg/ku1NrNLFSVbZZcf9cdrSo1r2gXoLTN+8DJB8n
         PCV2pdfBp4CFRk4e9TLKGhODmb3IzXnvmcFp+6NeeVqbssc4v8XEn4yj5EjJBtqfjSDN
         NPMlyT5Jo3XAkce6VvT/iv4+l75N2MA6fkoAyuRKnhV98jVX/T8N/B/TsL1WxB7GNZMo
         dsgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ij2jWlbd33lTLBTZXg3PtNV3E0laB8helhKjcL0SZ3o=;
        b=rLBkHrZ2ZFs+2g/kBCpYq6g0XFtBYUi5UeGoELjiVgA6Z3iwX04okWvFRJN906Cb4y
         +RWPZmsPKr0aNc/C/MZ5DV/gZ67rLzuhhpjbVWhmWMUbEALPPZo4KEBGXNueR1r7gHjz
         ZZb1X+wuq2HDrVTBAAGy9u5JKZBHuEPPR2nZ6cMhP3Xa1mPbrJdMQKe/ARq1/rkm7xO2
         F3pki5Jn4XWERm6SI7ONbtVZrsNR9su7cX1AXiQueHzsiIeVbL56vbfhp9YswAxaF5D2
         nu4VQyz2mqfVmnZ69s2j3NBzIg/MSn96GwDTfublr9WRB8ngzSkWq3n27y4udXLR/b6x
         fXNA==
X-Gm-Message-State: AOAM531SeVmW0RZUkacOGSqPr9iZLU2RqWyXa6I0IfBiwqOLYAs5/5oQ
        AE9ZuJnNmeov3EBbD2KRR+U=
X-Google-Smtp-Source: ABdhPJxfaCzxyjLMHwXKmrK8kG1Rg+8c4pw1EQAV083eMMyDo4K3yi3oWctIdT615ZyG27vZ6lF0Uw==
X-Received: by 2002:a50:a684:: with SMTP id e4mr11777089edc.148.1607695252668;
        Fri, 11 Dec 2020 06:00:52 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id z24sm7797818edr.9.2020.12.11.06.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:00:52 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/6] scsi: ufs: Remove d_wb_alloc_units from struct ufs_dev_info
Date:   Fri, 11 Dec 2020 15:00:33 +0100
Message-Id: <20201211140035.20016-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201211140035.20016-1-huobean@gmail.com>
References: <20201211140035.20016-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

d_wb_alloc_units only be used while WB probe, just used to confirm the
condition that "if bWriteBoosterBufferType is set to 01h but
dNumSharedWriteBoosterBufferAllocUnits is set to zero, the WriteBooster
feature is disabled". So, don't need to keep it in runtime.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    | 1 -
 drivers/scsi/ufs/ufshcd.c | 6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 45bebca29fdd..8ed342e43883 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -544,7 +544,6 @@ struct ufs_dev_info {
 	bool	wb_buf_flush_enabled;
 	u8	wb_dedicated_lu;
 	u8	b_wb_buffer_type;
-	u32	d_wb_alloc_units;
 
 	bool	b_rpm_dev_flush_capable;
 	u8	b_presrv_uspc_en;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 528c257df48c..0998e6103cd7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7243,10 +7243,8 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
 
 	if (dev_info->b_wb_buffer_type == WB_BUF_MODE_SHARED) {
-		dev_info->d_wb_alloc_units =
-		get_unaligned_be32(desc_buf +
-				   DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS);
-		if (!dev_info->d_wb_alloc_units)
+		if (!get_unaligned_be32(desc_buf +
+				   DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS))
 			goto wb_disabled;
 	} else {
 		for (lun = 0; lun < UFS_UPIU_MAX_WB_LUN_ID; lun++) {
-- 
2.17.1

