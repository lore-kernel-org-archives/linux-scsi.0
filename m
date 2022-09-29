Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12397C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiI2WqM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiI2Wpn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:45:43 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E41205D4
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:52 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id w2so2718360pfb.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=RZcV9LBa/cv0m+Kpk45TstAi3vY3bw2i/LMaNRSAq4Q=;
        b=6tvYSHcDctQdQdnH892+vwTUXqbhS1SWfw4g+pZAuheV4wJuIMndjsawYFEAP9zmJD
         ci2zpHh3p37Je9LQBkPm2r3rrmxWfk+P60RNo+5B6pL5bx4LXZkgxyxa1yx0McQvysD0
         hLRCxTw1j8LMa7BcqeQnd1ggYUSj+JcmITOPV6H0MY/S33ZUizveMDaMDvG2AnqS7r8L
         GuUtNtuHGjKj0AHpMJg1pmjLZZgs2kAu5KJlde29/K/STVA/jZ71mzzB8IEbnwieq7A1
         adOwuGsUrc7lhBH815GJ6Kz107DwP9IaMeMO27AEWtJTVN6q2om7HtlyizQA+N/IOzRq
         ENWA==
X-Gm-Message-State: ACrzQf1sQljqLNcMIWTpkwvB7itajCF/pRypCl65D7iWObC5nO+KQ5TT
        McyVC0em2MDPX5w6XbSM4w3u7r3PGvw=
X-Google-Smtp-Source: AMsMyM4ukYFxDvg99vEBbRJycZO31GPYJUgD7KZJPZpE7i+7IOmuFC0ffjMyTs0Mq8G9fY5GR4ggRA==
X-Received: by 2002:a62:84c6:0:b0:538:3c39:5819 with SMTP id k189-20020a6284c6000000b005383c395819mr5805887pfd.4.1664491491716;
        Thu, 29 Sep 2022 15:44:51 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016d1b70872asm404508plk.134.2022.09.29.15.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:44:51 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v6 6/8] scsi: ufs: Simplify ufshcd_set_dev_pwr_mode()
Date:   Thu, 29 Sep 2022 15:44:19 -0700
Message-Id: <20220929224421.587465-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929224421.587465-1-bvanassche@acm.org>
References: <20220929224421.587465-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Simplify the code for incrementing the SCSI device reference count in
ufshcd_set_dev_pwr_mode(). This patch removes one scsi_device_put() call
that happens from atomic context.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7c15cbc737b4..6e61372fe027 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8753,15 +8753,10 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	sdp = hba->ufs_device_wlun;
-	if (sdp) {
+	if (sdp && scsi_device_online(sdp))
 		ret = scsi_device_get(sdp);
-		if (!ret && !scsi_device_online(sdp)) {
-			ret = -ENODEV;
-			scsi_device_put(sdp);
-		}
-	} else {
+	else
 		ret = -ENODEV;
-	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (ret)
