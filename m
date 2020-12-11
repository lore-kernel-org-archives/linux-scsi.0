Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6025CC2BB40
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F20F24125
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404256AbgLKOBq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395137AbgLKOBb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 09:01:31 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9DEC061794;
        Fri, 11 Dec 2020 06:00:51 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f23so12490474ejk.2;
        Fri, 11 Dec 2020 06:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U7gSLsQcFEBe8WcOSAmmf0rsSetrSeSprNaqCiGaY3w=;
        b=hYDKma4sZCFK/PgOg67zxGCLCFDGTqcuiJC1713g1ea1usbJqpgDKN2ZOEHzzaz0An
         0YCqPsCSv8nOAsN4snCRT4BmYFLzcRYUaboxKbPMKI1j2lsThT0QXI+mmabOg3KhmniV
         GuXdnaHgTuOpwVDBObbOkIpNYb/ufH7EQDM7Xx82kCI/uIldBM5WFHCJdEzQLV5fB7vG
         XefBeMzfA0Tdx1kpG0nDbhiOHacME9x43UQ4IogUnFiEYo8BMN/GR7+eeL8d+8e+JLzj
         wBFZlAfcRrZWc939ggdWoPGpPNnahINtoM4fbWwkW/uyYmr5FDM46kyyDBPuK0eUdnf9
         SuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U7gSLsQcFEBe8WcOSAmmf0rsSetrSeSprNaqCiGaY3w=;
        b=drH8teTVjyYhFt/ypSzHwhwr2/W3mxVy8Z+s9Y5wjYNwXRcC/JoUtpL/1PUoY/P08Q
         KlMUCa0JCh6cF1P3J1Fp9bV64eeaVICU62J/XSN+4akWnjhr8ITtPa10MUX7/VJVq7MS
         C8oIfIjOkxWyWFEeKNeIGgfM4oEgWzS+J14FjMWVcLL7RIde8xSoxuo7QCNnDSe6gERn
         E6rO5ndf1Qnhz/vFx3CZTpUgxJSBjgxLCkvBmO38gyV5smeXQAYIsSdD+g6YG2ylOQqO
         dFqIo9hZKl/q3CigPnlPgYaJb5rVI2gp6W+WtK7D7g6ljJf6rscSpWQeor/abz2HNC2q
         +CBw==
X-Gm-Message-State: AOAM533oh2kw8xffl8UFFx7Zmac1I4zwlHQniHCRUxnO4OGAfvtuCuht
        /o0a2nwqrl0xdMKSNZuqLeTvlbfJi5M=
X-Google-Smtp-Source: ABdhPJyDVeP7TC28a3yTy5BTNtsqKJKHOCt3QGhp4+7Gw59ZSjLGsY2fMT8PSpkl+gVLwEX9PIk/3w==
X-Received: by 2002:a17:906:c007:: with SMTP id e7mr10794415ejz.511.1607695250023;
        Fri, 11 Dec 2020 06:00:50 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id z24sm7797818edr.9.2020.12.11.06.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:00:49 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/6] scsi: ufs: Changes comment in the function ufshcd_wb_probe()
Date:   Fri, 11 Dec 2020 15:00:31 +0100
Message-Id: <20201211140035.20016-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201211140035.20016-1-huobean@gmail.com>
References: <20201211140035.20016-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

USFHCD supports WriteBooster "LU dedicated buffer” mode and
“shared buffer” mode both, so changes the comment in the
function ufshcd_wb_probe().

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5e1dcf4de67e..6a5532b752aa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7232,10 +7232,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 		goto wb_disabled;
 
 	/*
-	 * WB may be supported but not configured while provisioning.
-	 * The spec says, in dedicated wb buffer mode,
-	 * a max of 1 lun would have wb buffer configured.
-	 * Now only shared buffer mode is supported.
+	 * WB may be supported but not configured while provisioning. The spec
+	 * says, in dedicated wb buffer mode, a max of 1 lun would have wb
+	 * buffer configured.
 	 */
 	dev_info->b_wb_buffer_type =
 		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
-- 
2.17.1

