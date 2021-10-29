Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 063D3C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE35760F58
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 19:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhJ2Tn7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 15:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbhJ2Tn7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 15:43:59 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45075C061570;
        Fri, 29 Oct 2021 12:41:30 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id v17so18088843wrv.9;
        Fri, 29 Oct 2021 12:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CrqEIV1z++Qik2hQMCkO4Gy6apl0st+NViiybQ9bg6A=;
        b=q7rvO5m2BP/314MFrQ+T+bOo3ihyqLBCKTnHzSGjF0C9dXYXpdNbkAZznyTky01huH
         CbF1g8+jBd6pdtu7UdDeXnduRDPz/XefL7nLP//V2g3ynI1hJX3Gu3NTXCHEjkKLQOac
         i4BMUoXYKi2aJBK5oLx9DwCC6Y/UCzzYtLUiQe+GUhA0/6XpaatC+7VKPslceDA7FgJu
         nYLKlKyfxCS1EdZuK8BGWBT248TZCU/sVnUbdtekrVZdT2AGQjVNDzRFeJ17VT2O0yus
         QH+aUzXR3aXZ1/muGqrwK3q566mQLtbHizJfzCi0XwWUHxlwwHpDPp7UPoKF5DILLhAF
         OTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CrqEIV1z++Qik2hQMCkO4Gy6apl0st+NViiybQ9bg6A=;
        b=ht8xlsN9LYA619MGPwkpNPxuo3V74Vxrn7fe+rYOE+WunaxhPZBWRaIljo80DvkoPz
         hjNy6uJqugFwRnfEi7KOv5f3GGm/hXRZfJKqTf/jBUtAS0KuwsnmhHmjQDd43TMtaFXZ
         jAd3hxJ6FUhHsFOyYxy6z7OtYQcpK26Dt7tIBDKxQ6AbLmFGMezphmZ+kXVWJ+AJ4JPa
         RuN9TBsbeDNfPTjVVwmaXoWMHS/gi/AkNQueJFADOZDUppNPRpyt9qxXCPNN3QPDIab5
         qAvwg5Fe3GZffwRpCbrMryCzDK9nNplmqnmEGqtiBMN47ZW6GSfdAV5eUfftW3e8WgC3
         /gRQ==
X-Gm-Message-State: AOAM533JqAAcy668lXWpwQa0MNd2ItmLx3jhBCqKtoXEa1ne2Gf7Uxr6
        hI7cpdgb4VCL0HoFCMv2VexMfKXcH71WNg==
X-Google-Smtp-Source: ABdhPJz5NwWcHrfwo5Pt7Zq3N2SauaVlIqsEjAwSKPkwHRwJ1u3oxkNf3/vKYzGEoO+PFW1jPYhN/w==
X-Received: by 2002:a5d:6d07:: with SMTP id e7mr16653144wrq.425.1635536488945;
        Fri, 29 Oct 2021 12:41:28 -0700 (PDT)
Received: from ubuntu-laptop.speedport.ip (p200300e94719c92a81a9947a27df1b21.dip0.t-ipconnect.de. [2003:e9:4719:c92a:81a9:947a:27df:1b21])
        by smtp.gmail.com with ESMTPSA id i6sm8890225wry.71.2021.10.29.12.41.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 12:41:28 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] scsi: core: Ignore the UHPPB preparation result
Date:   Fri, 29 Oct 2021 21:41:12 +0200
Message-Id: <20211029194113.293031-2-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211029194113.293031-1-huobean@gmail.com>
References: <20211029194113.293031-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Ignore the UHPPB preparation result and continue the original request if the
preparation fails

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d91a405fd181..a11248d89a7e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2740,12 +2740,11 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	lrbp->req_abort_skip = false;
 
-	err = ufshpb_prep(hba, lrbp);
-	if (err == -EAGAIN) {
-		lrbp->cmd = NULL;
-		ufshcd_release(hba);
-		goto out;
-	}
+	/*
+	 * Ignore the UHPPB preparation result and continue with the original
+	 * request if preperation fails.
+	 */
+	ufshpb_prep(hba, lrbp);
 
 	ufshcd_comp_scsi_upiu(hba, lrbp);
 
-- 
2.25.1

