Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0C4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6688B61B30
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 19:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhKSUBL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 15:01:11 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:39530 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234128AbhKSUBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 15:01:09 -0500
Received: by mail-pl1-f173.google.com with SMTP id z6so7739242plk.6
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2021 11:58:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NZUO3LOxhFcyFhieX01niRtnpri/VHzXjqDWXyWDs7M=;
        b=qDcCREhzRHB305Wvec1qcOmUeCzKlmb0YF8O4jbJ1mwVMYUI7AcPICxx0YeHzL3U7h
         JO9GSXuF26RzBAcjs0wbspmEUnUN3ECSzH5WyReFan1M5niikmP8LucMzLmQfp194Xa6
         GLyrcHtpTzgH0zwbD1spWTgd2Q4gD0/4Tu9aM4Ne1waqeW+XtaMp45FCoPICjJ5XnMPD
         rUr6LVZ1adbhKHYZfuePnucPvH7QRlXKbW0/N3a573Kpw9nSOIDWaa+QkicYRXImK3Wx
         fup1qNKAt/iOHjGMGfRtZYxb46G4TqZQ9tRuccHRd4VreJf2ka0O0VVaSiH7pXYJBobP
         iSeA==
X-Gm-Message-State: AOAM530mZ5XdyjRIZ3Hifb/7tMd2tbgXoSs97r2Vq+XXNh2qfbSxJAPt
        +F9iCp5vtU5O9wqNjoTVk/E=
X-Google-Smtp-Source: ABdhPJwAEDae+vPYA0ORq/2ZBvZd7GV+Y7h6IQGKEqnKxx5Bwc+7fyFzi7VwCATIhYyRBwmuj4XmOw==
X-Received: by 2002:a17:90a:fa18:: with SMTP id cm24mr2751690pjb.241.1637351887254;
        Fri, 19 Nov 2021 11:58:07 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id g11sm379010pgn.41.2021.11.19.11.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:58:06 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>
Subject: [PATCH v2 08/20] scsi: ufs: Remove is_rpmb_wlun()
Date:   Fri, 19 Nov 2021 11:57:31 -0800
Message-Id: <20211119195743.2817-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211119195743.2817-1-bvanassche@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
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
index afd38142b1c0..a3ca9ada0adc 100644
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
