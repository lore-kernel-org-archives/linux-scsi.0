Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13F5AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Nov 2021 23:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbhK3Xhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 18:37:42 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:52978 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232973AbhK3Xhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 18:37:41 -0500
Received: by mail-pj1-f44.google.com with SMTP id h24so16541343pjq.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 15:34:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FBFqasEVEbZC/f3NjejIS6eAMihsN/cQol/s0a+pFy0=;
        b=DA7tzpVGJOZOXii5x22SpYWU74AFaU5s9h89+btZDvzBNfOOOiXy4WCeh9uH4AaBuL
         mIqIfgWNJu8YG0romizbwnR/1/qAjxHC3YRkxrj74gvuz9oljioQVCMaZcYMT5FKUvk+
         zc+LjM8WDrJ7uC8eUcDhm9kqXPwmydScAV+jFZKW1Oubp5ArPFHcJO1AXvJugGbK1LIZ
         s+hOnzG7meuRfBjYYgDnCx0YZxZ1lMsOqRvWeQvyleq2W980rjXuHO7pNAmWAkoOXx4G
         kZly9TIaOHOTTcdzJZ5Hq2yJeXob1oT2z0PQg3mLmYH00fbmyJdo8pFGgjklQh12G5yP
         Aw5w==
X-Gm-Message-State: AOAM531xJ+FkZkTzkAPCfJcHMrFoTznBNrE5ddT4x2L3rpSHCA+LyWbI
        Aml6/i4gSxPnxuKdNs/WgtU=
X-Google-Smtp-Source: ABdhPJwAhv7gjI1UeuhTW8NEDaVIhjgjlfOvl5I+HZx4Li/z/BvS3ERnsorwW7TBHZoOJUg1zTFr2A==
X-Received: by 2002:a17:90b:1bc4:: with SMTP id oa4mr2687369pjb.179.1638315261306;
        Tue, 30 Nov 2021 15:34:21 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ef1f:f086:d1ba:8190])
        by smtp.gmail.com with ESMTPSA id mu4sm4127187pjb.8.2021.11.30.15.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 15:34:20 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v3 09/17] scsi: ufs: Rework ufshcd_change_queue_depth()
Date:   Tue, 30 Nov 2021 15:33:16 -0800
Message-Id: <20211130233324.1402448-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211130233324.1402448-1-bvanassche@acm.org>
References: <20211130233324.1402448-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for making sdev->host->can_queue less than hba->nutrs. This patch
does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 974bf47e733c..2d0f59424b00 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4936,11 +4936,7 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
  */
 static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 {
-	struct ufs_hba *hba = shost_priv(sdev->host);
-
-	if (depth > hba->nutrs)
-		depth = hba->nutrs;
-	return scsi_change_queue_depth(sdev, depth);
+	return scsi_change_queue_depth(sdev, min(depth, sdev->host->can_queue));
 }
 
 static void ufshcd_hpb_destroy(struct ufs_hba *hba, struct scsi_device *sdev)
