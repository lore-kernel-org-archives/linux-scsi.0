Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D20C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 18:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiI0Soe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbiI0SoK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 14:44:10 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379701C430E
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:44:09 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id u12so1981339pjj.1
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=l/aLlXmMnRU00Ow6DKfjvx/KHHUnXAX6M5393iNpbng=;
        b=0o8xRbEfuj4MmViGeOhtSf6Q9nut/4ShSXormzSAuBBcLotzXJBuzFIiL6dZC+jkm7
         edTtbmUQH06cHer+9sJv+LucouqO31HGFa7r430XdjP7C/xvuUrkLC0k1bOyu0lxi5dC
         ictjD9LVxTc0VmEnCtPC0sdcJB08k2mAJ/+H4Gr5sTaTF9oGIAyMGSLQ1V+vpbwWYtjg
         YeDkiNTgs0L04zJPOJzgwtmexZStP50LtarowsdgJYwIIxIp5J6i4NO6ZmTVouvwZPMJ
         4H6xWNaz1wr2og/dEEY3jtHyg3vUsxOBYr/OrYjnFMGrs+NSoYVPdbfrBOsb+oxMONi1
         ACrg==
X-Gm-Message-State: ACrzQf2Evsi0I8sSZdiPxLpGz4TCKjDKva+7OvAFMoWfBvYCwE150RHA
        zBhv9KVINFjZYvNX4pYQCH7DoCME02g=
X-Google-Smtp-Source: AMsMyM7juT5JjdWEVWZ+yx7eaTbRWp+pM2fyJqIcOzokY/9dfdWKz68v3iusJ5WGJjlryDWPKMUPzw==
X-Received: by 2002:a17:902:cecc:b0:177:f3f4:cc90 with SMTP id d12-20020a170902cecc00b00177f3f4cc90mr28530020plg.83.1664304248533;
        Tue, 27 Sep 2022 11:44:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7956f000000b0052e987c64efsm2184083pfq.174.2022.09.27.11.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:44:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v2 5/8] scsi: ufs: Use 'else' in ufshcd_set_dev_pwr_mode()
Date:   Tue, 27 Sep 2022 11:43:06 -0700
Message-Id: <20220927184309.2223322-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
In-Reply-To: <20220927184309.2223322-1-bvanassche@acm.org>
References: <20220927184309.2223322-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert if (ret) { ... } if (!ret) { ... } into
if (ret) { ... } else { ... }.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 78c980585dc3..02e73208b921 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8798,10 +8798,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 				scsi_print_sense_hdr(sdp, NULL, &sshdr);
 			ret = -EIO;
 		}
-	}
-
-	if (!ret)
+	} else {
 		hba->curr_dev_pwr_mode = pwr_mode;
+	}
 
 	scsi_device_put(sdp);
 	hba->host->eh_noresume = 0;
