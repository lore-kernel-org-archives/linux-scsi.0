Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AFCC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA3AB61181
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhKJAsO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:48:14 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:35405 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhKJAsO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:48:14 -0500
Received: by mail-pg1-f179.google.com with SMTP id p17so652198pgj.2
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:45:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cQqliRW2U5s6ay6ypy18/ZV7ufFIxagKVNHCjyhE7JY=;
        b=3Phhs6kNPAk+9jPaaA9jYXTV08ZoXGzqg68nwWEDc6+cFGy4rPB5wt6EtWG+ln4Dy7
         JhP5YeKKJH+elQHwMORIfv5lDyOwjBgOk8w/0m0sy+oFB8AXpR25+aZwoly5/oYSybQD
         NvTOQQmxhHtVEqObay4V859cYsZQLra+Eg05HVihE4ndWzvmGgwpLG7y0NMBI2bLjoYD
         +8D3P40YYLCcU/+wCgHorfxg2UBJiIJqdaraGK4TSWspHmRsC1o2Wey3o/2ccRaXZ5yW
         hBwZfZXsUXaFwf+9PVjZQ5Lcv37g19aDQYk1+Nf/DDUzD+qoaTVV8W2BZWfmGjVS/A24
         C6ag==
X-Gm-Message-State: AOAM531FHZ4BvrOyejEbXehkEpGUFiRij0mYbh+kLATD30D5SsVsc8ue
        ndpYRFRA09GY0U+Boa4dsLo=
X-Google-Smtp-Source: ABdhPJxIBX5KouKIsxdNuQHr+Qz7JRSez0tP7HJ81l+EH7Wfr9oeTGCEMPoddRyvSASz54SpdTMmZw==
X-Received: by 2002:a63:4610:: with SMTP id t16mr4082126pga.224.1636505127154;
        Tue, 09 Nov 2021 16:45:27 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:45:26 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 06/11] scsi: ufs: Rework ufshcd_change_queue_depth()
Date:   Tue,  9 Nov 2021 16:44:35 -0800
Message-Id: <20211110004440.3389311-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
In-Reply-To: <20211110004440.3389311-1-bvanassche@acm.org>
References: <20211110004440.3389311-1-bvanassche@acm.org>
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
index 312e8a5b7733..8400d8e9a6f7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4955,11 +4955,7 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
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
