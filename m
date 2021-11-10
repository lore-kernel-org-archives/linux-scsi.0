Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C6EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1379611CA
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhKJAsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:48:25 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:46796 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbhKJAsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:48:24 -0500
Received: by mail-pj1-f52.google.com with SMTP id f20-20020a17090a639400b001a772f524d1so127348pjj.5
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gPm9jvo2dQ97h1ECFHAf5oFx5mwjgZ3vxFaLaNSKiNY=;
        b=t1ImWJfcs8x2JY9OYuHEkoS3pgIQm/OsIh2xSNJ5hQplunlnuCYbLLEGS2IOml38IF
         4CGKSxyWhF9NBY0wWWyYAjxkO+2Gw+FcelvylqxcsRiaiwd7KSYqB7+Gu3dnEu8AbnrP
         2H0P1Zw+m3pt1bBnAM13PW9t8ka2Bv9pxQZBhKYl6u2SUsFP+snHv+5VIaQDyGg0RUR+
         kPmnjO4hixtNG04+TkvmqLit+rt3J7ZrnXzPpxFO9nLnRvQgX/dZOGkEPKqjxs0cveaE
         6VpXQlT6sjN7UAXFZSEewUzy7Df+zlA3E9tYJumv7+YiOGHAPuTK/4LFt4IGAlTRDvfl
         D0jw==
X-Gm-Message-State: AOAM531lc3DSp1Q2V8lMHlYxGoyJcyrp4XAjrAi2TFc5ppurWWJZFlQs
        HjGff0A0UpDB8DLenZJ4/Mc=
X-Google-Smtp-Source: ABdhPJxNHq3fhlpXdRt7S/MGSFFnRgbHgDFou5jiHt9dE3OV2KSLmFm8cf7KL3MEGOklGDxQS/qehQ==
X-Received: by 2002:a17:90b:4a50:: with SMTP id lb16mr12208949pjb.147.1636505138007;
        Tue, 09 Nov 2021 16:45:38 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:37 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Santosh Yaraganavi <santoshsy@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Vishak G <vishak.g@samsung.com>
Subject: [PATCH 08/11] scsi: ufs: Improve SCSI abort handling further
Date:   Tue,  9 Nov 2021 16:44:37 -0800
Message-Id: <20211110004440.3389311-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure that aborted commands are completed once by clearing the
corresponding tag bit from hba->outstanding_reqs. This patch is a
follow-up for commit cd892096c940 ("scsi: ufs: core: Improve SCSI
abort handling").

Fixes: 7a3e97b0dc4b ("[SCSI] ufshcd: UFS Host controller driver")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8f5640647054..1e15ed1f639f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7090,6 +7090,15 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto release;
 	}
 
+	/*
+	 * ufshcd_try_to_abort_task() cleared the 'tag' bit in the doorbell
+	 * register. Clear the corresponding bit from outstanding_reqs to
+	 * prevent early completion.
+	 */
+	spin_lock_irqsave(&hba->outstanding_lock, flags);
+	__clear_bit(tag, &hba->outstanding_reqs);
+	spin_unlock_irqrestore(&hba->outstanding_lock, flags);
+
 	lrbp->cmd = NULL;
 	err = SUCCESS;
 
