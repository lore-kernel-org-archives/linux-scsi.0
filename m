Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5CCC04A95
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 20:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiIWUMd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiIWUMa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 16:12:30 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE56D122635
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:12:29 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id t190so1213278pgd.9
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:12:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=1GLKdsE9mlEjI3G0icPW9Cfl6Qc2h3FWYS/7Ll/qo1A=;
        b=N3Q4pahfZ/MiX0MlLJ7JbY2JFrOlaWn1Qo1HIwHf0LO0CP0D+C6kpgiC0AE4NXsfuI
         110Mg3tQUHrrnVi/8rkqwYvAf7X4+Se0d/46YvlFwY1pqchjB3RQJdKUPL76DVIMVidb
         gQcP3nlACyPDl6MjjbCEFQ172qchy3BV1m3wpEzlPThtG6s8CgHFZskBP8lUtvtZKduL
         QhYUEKfMKVmi9llLtWJk+7Fg73BWuotAfT0pd/6jjmaUIFNq05DRO6XNjaOsVabv2u6y
         GecXnrpsZYYcBtJaUYGQL1c0EzzDB1uNmTGopP1YuRmvkHodGHiix6A5iaI+CzeClyhW
         bnNg==
X-Gm-Message-State: ACrzQf0O4Bu2TFq8B8p+yK+mvmZBSzanQeu3ULXCeRn3xD8HmXM3Du+2
        IkO+SmUT5krrm2opC0ZPZmw=
X-Google-Smtp-Source: AMsMyM5UyTg5y8ezqK1+WA0tO+gU9E8B+cTmQmcXF8tGX9YMIFSwGCJGHpdWqYzVN//AHrlABIfavg==
X-Received: by 2002:a05:6a00:854:b0:542:4254:17f6 with SMTP id q20-20020a056a00085400b00542425417f6mr10778307pfk.47.1663963949320;
        Fri, 23 Sep 2022 13:12:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa13:bc38:2a63:318e])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001754fa42065sm6388435plk.143.2022.09.23.13.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:12:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH 5/8] scsi: ufs: Try harder to change the power mode
Date:   Fri, 23 Sep 2022 13:11:35 -0700
Message-Id: <20220923201138.2113123-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220923201138.2113123-1-bvanassche@acm.org>
References: <20220923201138.2113123-1-bvanassche@acm.org>
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
