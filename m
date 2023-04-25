Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19D3DC77B61
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236459AbjDYXaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236456AbjDYXaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:30:17 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4FCBBA4
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:30:16 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-63b5ce4f069so7938926b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:30:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465416; x=1685057416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xxouWt0uEijuhb5iMXDgWRbgWnoCjnarrdU7Xj5nBBU=;
        b=Tuuh6slEa+Qlj92ZLC/VZ5oRcUxbfQYOx0Sqxw80acBIULtiIsrCX1PjPJ8jXAh/aL
         crBpUl44A5Rjqk9DUZc1FDrJPx8nB2f/ldIJKcd2OKVoI5ewA4XchKtdD0e4kilR9Vk5
         Ub7OgzCgjE6mIerWF+tjOJWG41eLnVjybEz4aKdMPQ0lO6ynFpyNTdjR2R0tXtfKTMIE
         9Ly4tAjGLJsdalx0zgEGe2YvdnvQTdFHJZ0wM2ino9vsN2o60j8/qFAAbIKBZv8Pu/x+
         wc33xVkMTpoL16bzOkw797Hx2g0PhA0nPo7lxvnTfbTCBkFknOWH06A/RP7bEtpbZfZ5
         BWwg==
X-Gm-Message-State: AAQBX9fCMtmEZfFtmZZa7UdSfFDBIPJAsr7fPZTn9Lb/3DUZiFf4Wle5
        SVutOUrAbkK4q4+u2+pWMYU=
X-Google-Smtp-Source: AKy350YOfFhfpqiVZdOgAKpfaoGCKZT6m3NR3O9mwuxb0jxIuI9svKYz8HPTCSQU3KvV3962uetktw==
X-Received: by 2002:a05:6a00:1823:b0:63b:4313:f8b5 with SMTP id y35-20020a056a00182300b0063b4313f8b5mr27748449pfa.23.1682465415930;
        Tue, 25 Apr 2023 16:30:15 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5099:ad7c:6c1:9570])
        by smtp.gmail.com with ESMTPSA id b20-20020a056a0002d400b006348cb791f4sm9829941pft.192.2023.04.25.16.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:30:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>
Subject: [PATCH 1/4] scsi: ufs: Increase the START STOP UNIT timeout from one to ten seconds
Date:   Tue, 25 Apr 2023 16:29:51 -0700
Message-ID: <20230425232954.1229916-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
In-Reply-To: <20230425232954.1229916-1-bvanassche@acm.org>
References: <20230425232954.1229916-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One UFS vendor asked to increase the UFS timeout from 1 s to 3 s.
Another UFS vendor asked to increase the UFS timeout from 1 s to 10 s.
Hence this patch that increases the UFS timeout to 10 s. This patch can
cause the total timeout to exceed 20 s, the Android shutdown timeout.
This is fine since the loop around ufshcd_execute_start_stop() exists to
deal with unit attentions and because unit attentions are reported
quickly.

Fixes: dcd5b7637c6d ("scsi: ufs: Reduce the START STOP UNIT timeout")
Fixes: 8f2c96420c6e ("scsi: ufs: core: Reduce the power mode change timeout")
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9434328ba323..0e2a0656858a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9182,7 +9182,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
 	};
 
 	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=*/NULL,
-			/*bufflen=*/0, /*timeout=*/HZ, /*retries=*/0, &args);
+			/*bufflen=*/0, /*timeout=*/10 * HZ, /*retries=*/0,
+			&args);
 }
 
 /**
