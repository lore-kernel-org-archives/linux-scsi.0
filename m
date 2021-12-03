Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C63DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376744AbhLCXXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:23:45 -0500
Received: from mail-pg1-f175.google.com ([209.85.215.175]:40827 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376419AbhLCXXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:23:44 -0500
Received: by mail-pg1-f175.google.com with SMTP id l190so4511617pge.7
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:20:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NXzSK3wHuMFAb4DWjfo8uFdYnqOpelZuA0THarlc7LM=;
        b=SWh7uRxr3AYvd/WnT3AUw5rKKAfqmTUVURHg1UKquoDT+ajAWSNsTPotFP0/bLLN2V
         ya+O4/D6nfZhukfR7XFlAEeRUw257JSzPM1sqJFFqgnef5S751CTXNeBJGRfnl99ZVcj
         JO/YGcCCeDT9f4ZA2OAOM71R4z2KnUwCEBRdSHvokLfZMJ8gWLRIQAdH9pHEkxWy5Gso
         wdmtXEq4WxZhwrGVvrcDXPWvhzR3pyAyW5GbEIKHdp0KU8IK3HAFkYrMq/WYKNJO/ccM
         J2G/jtGLfyOJoEcgA+ouRkcBGwMSIamdYCudiilCzwP5cn6FYuX3U6PMV6XXUqnVc8UM
         Wqzg==
X-Gm-Message-State: AOAM530AcA6y5SaJodM77BoMW4K+gvV9W/reY308qQY1ZJq1dAYPSV19
        s/BAAKuYbTpxM+ukQF5Mw84=
X-Google-Smtp-Source: ABdhPJw03KOll3tGWsPzQFGC0BZtzeX9SvqC3RlngSGjuk/GuX8kMoea0ZWjv++huLi0+3osCc5UWg==
X-Received: by 2002:a05:6a00:1514:b0:49f:b5ef:affb with SMTP id q20-20020a056a00151400b0049fb5efaffbmr21687514pfu.7.1638573619809;
        Fri, 03 Dec 2021 15:20:19 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:20:19 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v4 03/17] scsi: ufs: Remove is_rpmb_wlun()
Date:   Fri,  3 Dec 2021 15:19:36 -0800
Message-Id: <20211203231950.193369-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit edc0596cc04b ("scsi: ufs: core: Stop clearing UNIT ATTENTIONS")
removed all callers of is_rpmb_wlun(). Hence also remove the function
itself.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 024f6d958341..4821ad9912bb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2650,11 +2650,6 @@ static inline u16 ufshcd_upiu_wlun_to_scsi_wlun(u8 upiu_wlun_id)
 	return (upiu_wlun_id & ~UFS_UPIU_WLUN_ID) | SCSI_W_LUN_BASE;
 }
 
-static inline bool is_rpmb_wlun(struct scsi_device *sdev)
-{
-	return sdev->lun == ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN);
-}
-
 static inline bool is_device_wlun(struct scsi_device *sdev)
 {
 	return sdev->lun ==
