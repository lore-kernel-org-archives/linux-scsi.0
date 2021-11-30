Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFEEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhK3XhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:37:13 -0500
Received: from mail-pj1-f46.google.com ([209.85.216.46]:56192 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236283AbhK3XhG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:06 -0500
Received: by mail-pj1-f46.google.com with SMTP id v23so16500403pjr.5
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:33:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RBVvpH8dg3y7bfs6Vgy2geJPP0x7Fiiw2uEdgKD9aAM=;
        b=wN0w3Vq+L9XpVAQTq4sUJ/1Tjb/gPLG1liEqn/wQ0hRuIUOviEbh9YkBZNpiWfMgP/
         pDq6HqIMiSN4In4P+3bFDz+zPMMGdVDkQwzvxyTS2HTHdI6yD/BjCRjRi7bzetE83fSy
         3voTt2emI7xjOHUsMBFZZTKdnTuLLzmrI2Ck/qOtPwZTaL2CAXj79hRH2aT5E6gRPMwE
         3dWSKk5hNwA+tYGpqfTFqgPmezxQNQxE7wIqRmgNH2yEkZytj/zpG2/+4JFsol71TfQC
         Tosx83EBaD//A0dH/3lLcBNSwTYIYuSb8SJtUQUeDYnrWs+yrpeUc5LB9KIf+KW2/IEz
         kO9g==
X-Gm-Message-State: AOAM533LpBXvo8SqGZa7oOC+Usnla1tkJvitvN10ZwBxwzDxDFDd4ICU
        oiSe4mbT0R2L/4kGEmic2EY=
X-Google-Smtp-Source: ABdhPJzELzrgnfZ9zVytqfvGpUOBD00KqQZUtcelmjH0D+52lDHu040NBoYDcO8DdCfTnJpATPbl7Q==
X-Received: by 2002:a17:90b:380a:: with SMTP id mq10mr2679500pjb.61.1638315226622;
        Tue, 30 Nov 2021 15:33:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:33:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v3 04/17] scsi: ufs: Remove is_rpmb_wlun()
Date:   Tue, 30 Nov 2021 15:33:11 -0800
Message-Id: <20211130233324.1402448-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
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
