Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03A9CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E169461181
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhKJAry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:47:54 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:37576 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhKJArx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:47:53 -0500
Received: by mail-pf1-f174.google.com with SMTP id y5so1047160pfb.4
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wR7KU/viebny4nR2Y59jGd7p6vnccW0oeSt9hsxVM+I=;
        b=cPPWtr6++7XFnpmB5ILGt19UZ+Kg+n1URYGJRPns7H+hPd9XHpztwth91NOu/iX3X3
         FYz1TaCmdqLMBprcyztdQPVGQH9iM+M6K2WJ1IS4JZQYflhditCcjEpq/TB1DAdOGL34
         NXzQ5OQGi4pJIWVSN0bhbRwNopzMgwjHy8+O8u9Iwg7Fh7M+FSufzdg1DP4B4wZDk5S4
         lWIXwUFzwR4dUzIRpoC+gcvhdI/HTB6Aj1UkvMIVO+pzRnqyXYeDUvzrfYziz09wxhQy
         RfP2Eakl/88g9CNQGF9pG8LmVjW/trFp+Mf89Iac06Pi9OYy+nhJOryGCA7BFS8QuL4G
         qcNg==
X-Gm-Message-State: AOAM531lNfXjJHGLwFM2/XVmQrlu4B8Ta9a7V+6O28V0g+uGu+Ar2SHS
        coWFReSptHmIoD+E9eV4+qE=
X-Google-Smtp-Source: ABdhPJxyugkn8DUWE+KCwE68ZOdsTZTP8tVL5VauFsCOXxNWQnmMX1z3LJZP7N1JCJ3c8ifI5geAkA==
X-Received: by 2002:a63:874a:: with SMTP id i71mr9227320pge.81.1636505106278;
        Tue, 09 Nov 2021 16:45:06 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:05 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 02/11] scsi: ufs: Remove is_rpmb_wlun()
Date:   Tue,  9 Nov 2021 16:44:31 -0800
Message-Id: <20211110004440.3389311-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit edc0596cc04b ("scsi: ufs: core: Stop clearing UNIT ATTENTIONS")
removed all callers of is_rpmb_wlun(). Hence also remove the function
itself.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dac8fbf221f7..d18685d080d7 100644
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
