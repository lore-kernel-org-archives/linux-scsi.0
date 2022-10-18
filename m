Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E4BC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:31:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJRUbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:31:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiJRUay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:30:54 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E9863F01
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:42 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id f193so14356293pgc.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/QjT97Ydpo7SWG7fECByOT3IKJiFK70uC0pu8L38W4s=;
        b=iZZh9hagxI8d31yT1MxKUk65xkQ0d7z+Ue8iTZNLq7TTvTU7vjX/kmLvadzpreDpgn
         39qb0Rf2g+454JgqPkcIqSouGG3FfIi4jAF6ohwmC0ewIzeTNildCk0NEOCMUeDJw85M
         tJUS01VTMeEHmZPP9fAKjvvE2wIXaKb2WdwsrRGajEcFvTtniKYRngAtoxbsDWAaauwZ
         z3HQBRM05ZRIavR3yOfrvtre+/1XKUlLKLdctUThEjAA/EdZV5mQBSJ5K9u8NMLexGC7
         ZXwxh8XCvn+icAUetDytbq4g21UqrLDwmFrw5X7AC5CKVMkGOOg6HWcNPoXzboAiBPFt
         HHKw==
X-Gm-Message-State: ACrzQf2QoM7+qGIBOBZ/Zh6oftZFU37zGewNJZy6sOcJuqioMXp67D3J
        hitu73ExZxK2i9ln+wiy6rc=
X-Google-Smtp-Source: AMsMyM5BzsoOO88HY2ItpTC1cl6KL9ztpJzh0KxLIFQBcEoeQt7x7VoXGaRMKQX7L1VC8oBnB5ZL/Q==
X-Received: by 2002:aa7:810a:0:b0:55b:674d:d123 with SMTP id b10-20020aa7810a000000b0055b674dd123mr5171855pfi.52.1666125041503;
        Tue, 18 Oct 2022 13:30:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:30:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
Subject: [PATCH v4 05/10] scsi: ufs: Use 'else' in ufshcd_set_dev_pwr_mode()
Date:   Tue, 18 Oct 2022 13:29:53 -0700
Message-Id: <20221018202958.1902564-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221018202958.1902564-1-bvanassche@acm.org>
References: <20221018202958.1902564-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert if (ret) { ... } if (!ret) { ... } into
if (ret) { ... } else { ... }.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bdee494381ca..db1997e99da2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8797,10 +8797,9 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
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
