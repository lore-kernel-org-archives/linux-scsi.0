Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074F9C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiI2WBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiI2WBN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:01:13 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70E513A3B0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:01:12 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id f23so2384607plr.6
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:01:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1GLKdsE9mlEjI3G0icPW9Cfl6Qc2h3FWYS/7Ll/qo1A=;
        b=M0F3NOFzllOONcvJJZc/QMMSv3uj+WeuUGmMlEQFJL8jfp76y7I0I5BAPlX8K5cnBS
         LWtMek7dOvS0CjuultJlpEz1mC+IDFimc0rWVxKlPOOh0LyPPcgKQ/MJkeJKHx0LBFva
         PUFVtfLGoHd/nzthLFYAi8dBmvO4MMAgMEq1RmeJPks26ewFpSiC/i+UW9zan8Kp4yrr
         3T8WOIE+jkZZkF+85gHj7O4C1zyZdjw4mjxsosD/NKAKmVfp86zJ7eLUeOXvrSMCYcYS
         v7p1kpRMxL8dwNZK0c/R3osG6BErKsZ+/A+nirFV7ksFjVivf+5e3exrABiRTTVHpGge
         UWig==
X-Gm-Message-State: ACrzQf3ZrHIpTVqMJ86xGk4+zRT+gxAy1h2tPh/VSDV8iekuTr4AGjDo
        nAhfQitqTXRCA/QbuTD+rwZwepLJ6G0=
X-Google-Smtp-Source: AMsMyM7bxa6qFKuO1Q/ppZTs83iI1szU/tPWBB+RL96wQ/RIZ/5eG+3qkiP6baxuip3gOQ58fu7EsA==
X-Received: by 2002:a17:90b:2686:b0:203:bf90:f791 with SMTP id pl6-20020a17090b268600b00203bf90f791mr6106647pjb.50.1664488872146;
        Thu, 29 Sep 2022 15:01:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001782f94f8ebsm407787plh.3.2022.09.29.15.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:01:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v3 6/8] scsi: ufs: Try harder to change the power mode
Date:   Thu, 29 Sep 2022 15:00:19 -0700
Message-Id: <20220929220021.247097-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929220021.247097-1-bvanassche@acm.org>
References: <20220929220021.247097-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of only retrying the START STOP UNIT command if a unit attention
is reported, repeat it if any SCSI error is reported by the device or if
the command timed out.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 02e73208b921..e8c0504e9e83 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8784,9 +8784,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	for (retries = 3; retries > 0; --retries) {
 		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
 				START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
-		if (!scsi_status_is_check_condition(ret) ||
-				!scsi_sense_valid(&sshdr) ||
-				sshdr.sense_key != UNIT_ATTENTION)
+		if (ret < 0)
+			break;
+		if (host_byte(ret) == 0 && scsi_status_is_good(ret))
 			break;
 	}
 	if (ret) {
