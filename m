Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC2CC43334
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 21:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiGOVZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 17:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiGOVZn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 17:25:43 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9540A72EF1
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:25:42 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id 70so5695059pfx.1
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:25:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VRLjBHheSx3+WidXlAJ16yE6sr2l4d/LEP3cuBG5S/s=;
        b=vnknvFZbrAkyy3XRzkwS3k+xGSMh4R1BDfW+1dU53acZeyYoA1seGdoFdCvldgFdDD
         qFxpV7x1k/TMRsQV6+bgRGGth+UFSmN2fBzUh1VLzo6pODCeKk6c6GAv9PxGxxef6YT1
         mE9SmXJFlSRkYfHarOkxVybsEqRACJYj5S9Z6l2hCQXTNCCRUibZHSO0ahWZklh0DrMh
         rnowzuOYyM1dK7e06I2A4Pe+guPhryhAHqhPSLJ+8e1jDFdPPKZCYbTKEcIJxwKUCZbO
         9PmtivpnFRWbQhTd5v7BrCftzUICWUXKxVgPYUoj71KoUFKTRoWgova7XSqLof/eONS9
         bHKg==
X-Gm-Message-State: AJIora9El5Q2wcboZJVNJ2tuuiHnBKuJUGxp7L1Rzy26l/o6uIdpjyh/
        m4Uq9/7pKFi/TUhkAo+oW6k=
X-Google-Smtp-Source: AGRyM1vXpYj3O1UgfbgRiWxcBwsegr3XQQp9+itqCz6lsO6AUOF6YNxlJch1QvAG4d7o9euO/Hnu7A==
X-Received: by 2002:a63:8649:0:b0:415:c328:4dff with SMTP id x70-20020a638649000000b00415c3284dffmr13960297pgd.430.1657920342057;
        Fri, 15 Jul 2022 14:25:42 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:276e:f777:f438:e01d])
        by smtp.gmail.com with ESMTPSA id e35-20020a630f23000000b0040c40b022fbsm3535944pgl.94.2022.07.15.14.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 14:25:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 1/5] scsi: ufs: Reduce the clock scaling latency
Date:   Fri, 15 Jul 2022 14:25:11 -0700
Message-Id: <20220715212515.347664-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
In-Reply-To: <20220715212515.347664-1-bvanassche@acm.org>
References: <20220715212515.347664-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Wait at most 20 ms before rechecking the doorbells instead of waiting
for a potentially long time between doorbell checks.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index b92d4fb82bca..a51644bcfbb7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1149,7 +1149,7 @@ static int ufshcd_wait_for_doorbell_clr(struct ufs_hba *hba,
 		}
 
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		schedule();
+		io_schedule_timeout(msecs_to_jiffies(20));
 		if (ktime_to_us(ktime_sub(ktime_get(), start)) >
 		    wait_timeout_us) {
 			timeout = true;
