Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940B4C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 20:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239970AbiGHUup (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 16:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239997AbiGHUul (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 16:50:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB2084EF3
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 13:50:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b129-20020a25e487000000b0066e1c52ac55so14103613ybh.11
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2022 13:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=WTzYPIBJJJ/rSmblnN5WfaE5Ee0B2WW7riiHrhesMLY=;
        b=ZWVnX674PE55H7yQFZVgNFbRZU0ugAKP8Ypvj+VJRV/M53jakl3NkWnfXIAUNzwH9Y
         KN2/Mq0SHt2f3IKQdoYlliWWUYJJQql6oa6a9xZqEADyU8KUz/keLgCoTANNhbU0gUOI
         HgnTjvq2pjz2G50JHuUTtN+qptJcYkvKxPQqw5e1lo8XTI6bdEtEcmfJ5eRBhV9IYUoK
         aCBPaPScm0xcehBvb3rtBrFKyRTNmEk8KlxY+SWuOG4YfY++K71+J2gXQcbSvH4Bdh3m
         3+KtaxviwNq2NZGqpqCi6dM2oO81+/xGvxxhJZJSgi/G7tzrUubA5I955UY8vsZn8AhV
         1OPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=WTzYPIBJJJ/rSmblnN5WfaE5Ee0B2WW7riiHrhesMLY=;
        b=Q9Fgv8jIQRiqPorioFl1EM9BysRM5vOpwcUJ2n3XsF9qkWnEQ/plhVZMek5mxJ5pe8
         Q5t8xfONhOB3IRrl7z6HH8XdhU2awYg+lA8xz8r004nKuNVPvkuxoNlQdvY1b2QTf2vm
         Ek4ETLk5roVAZJfMrsEmIKO6BOz8xMyj3qseSXRJlzUMuDJAI0u6ljjHRyBr9SajZqYg
         iAYSIOpk/9OIQJkn4cOOA57rcVUZSgQofPQhbO9n+XuSfx0s7eiLWCgpvcO9YHE4pDaW
         QY4tGB359tF5iaUu+QNDzlOdZ3tMXM7pVVG5m80442kQ9xAnmlUDqwEgXlBa6JhOvjrR
         bY4A==
X-Gm-Message-State: AJIora8JPAfyXiojKUEY51WYd6W4uGzjxiOiE32UmWNgWQ0130KAqFfD
        eSlaI6f5HNcKWzBbx+6kZ+dyw07FWN+SeG5V
X-Google-Smtp-Source: AGRyM1ux9QxoKG/ViNLLdg62pT/xVXRJkHhlT1h8CHiK+7ET+kOh6pfDTSW8iuPANJKiF+kN0V8AbMlfGtwlf+FF
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2c5:13:8b09:9913:f2a4:cbbf])
 (user=changyuanl job=sendgmr) by 2002:a25:d210:0:b0:66e:c7d3:b8c5 with SMTP
 id j16-20020a25d210000000b0066ec7d3b8c5mr5454299ybg.97.1657313440193; Fri, 08
 Jul 2022 13:50:40 -0700 (PDT)
Date:   Fri,  8 Jul 2022 13:50:26 -0700
Message-Id: <20220708205026.969161-1-changyuanl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] scsi: pm80xx: Set stopped phy's linkrate to Disabled
From:   Changyuan Lyu <changyuanl@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Changyuan Lyu <changyuanl@google.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Negotiated link rate needs to be updated to Disabled when phy is
stopped.

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Changyuan Lyu <changyuanl@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 01c5e8ff4cc5..303cd05fec50 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3723,8 +3723,12 @@ static int mpi_phy_stop_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_dbg(pm8001_ha, MSG, "phy:0x%x status:0x%x\n",
 		   phyid, status);
 	if (status == PHY_STOP_SUCCESS ||
-		status == PHY_STOP_ERR_DEVICE_ATTACHED)
+		status == PHY_STOP_ERR_DEVICE_ATTACHED) {
 		phy->phy_state = PHY_LINK_DISABLE;
+		phy->sas_phy.phy->negotiated_linkrate = SAS_PHY_DISABLED;
+		phy->sas_phy.linkrate = SAS_PHY_DISABLED;
+	}
+
 	return 0;
 }
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

