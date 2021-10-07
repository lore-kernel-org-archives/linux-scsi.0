Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D30CC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1011E60FDC
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbhJGUs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:29 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:44686 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241391AbhJGUs2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:28 -0400
Received: by mail-pf1-f170.google.com with SMTP id 145so6314190pfz.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZLjrkUrDGjiUH0yp0QEebobu1TDlTcuEBk039zm4Bj8=;
        b=Ck8ztLEfeD1S4Ty0lKRvjw9K+oQUdj5ir9MQBFCV1OuYRktnmm6RnEFopNUgjm0qEM
         b/MKgULEWZGZ+knMSb9siDlZL7fbjCWNWggTliLInhspZY82fKjinHcbnH4674+IkKkn
         kl+qZaXuwo4Nv7JoQiIdCHlVS83rua1sHlQH5J3Y/c2OBeqWSAAHzS3qJ2gV3iyLlBmZ
         nsDLyhmczBLPdgEF0FZ1blQj3cJEG7BqjqZhHX91MRvfcPNznYKIM3dBUEpACg5PrZqw
         +0fKAuTuxKLP9QVz0UxYJKaOP78ZAKpFOENGHIUj0u1D7SiXY9AY4nOTODiBP5xc7hRF
         iIHQ==
X-Gm-Message-State: AOAM533yk0Ix1ZnXZZrAZQCYKU36dErceoW6wYefRSD6yWvlAnVQI7Cp
        /FytkdBax0nK0ohx/4e/zqE=
X-Google-Smtp-Source: ABdhPJxGwY3CZbEpAQ3Nbp/LCUgXjAl1K6pBWYsZPwiKFd1xAQIhG2fKsZu9mIwwM67hOnYAtLj5iQ==
X-Received: by 2002:a62:2984:0:b0:44b:b8fe:9454 with SMTP id p126-20020a622984000000b0044bb8fe9454mr6230817pfp.36.1633639594081;
        Thu, 07 Oct 2021 13:46:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v3 79/88] wd719x: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:05 -0700
Message-Id: <20211007204618.2196847-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/wd719x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 6f10a43510fb..1a7947554581 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -200,7 +200,7 @@ static void wd719x_finish_cmd(struct wd719x_scb *scb, int result)
 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 
 	cmd->result = result << 16;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 }
 
 /* Build a SCB and send it to the card */
@@ -295,7 +295,7 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 			 DMA_BIDIRECTIONAL);
 out_error:
 	cmd->result = DID_ERROR << 16;
-	cmd->scsi_done(cmd);
+	scsi_done(cmd);
 	return 0;
 }
 
