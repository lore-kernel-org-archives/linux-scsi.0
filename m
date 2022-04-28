Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A39F1C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 00:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiD1AHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 20:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiD1AHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 20:07:05 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E1312E
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 17:03:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p22-20020a254216000000b0064588c45fbaso3049025yba.16
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 17:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CgqUIPBtVSO8Gqan4yRteEeW7q+BhxEILt5DczgB6Vs=;
        b=bvYkZmSr9Ani68uZhWRDtHE07DzENzx5iJDb05W67sQduDN11G09SOlOposWnPsrWd
         ol3IuYvCHeossdYKMRghn6Jitln14IvvATzAaiNWpjIgjJhAG+lbr2M6J3T1UFArDhiU
         p3swLtbDmwpLc/J5CFOfKNKHJXD5T65t1RXktnLfxDqG8vCs37uVbKbUoa01VlKwm5l7
         e5cBLM0hZ9J4p5d+6O09wgKOHDsE/Oj8h0NFXVS0K6FgHtrpOR80DjZQVbr0kVGM4MdC
         AgYlQsWgszQaDhOjAAxVdA5y2ad5/C3BmIXCMXFXqOKA6GdB8kiZcSTKdur9/e+yI5NP
         pQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CgqUIPBtVSO8Gqan4yRteEeW7q+BhxEILt5DczgB6Vs=;
        b=CqKcHg22vthMRBNNlDKFI/FpKH2Ztbi3/5bcI+3z51nps0g8fbSBhAmVsy6MXj2hp1
         nJ0RCmGeEshAHDK+EL3dnOmE/yVAwIW7Cs1Js7uo41wIPiQioCLsP1dxjwWsW/ZcjYSk
         tq/sTPeYqJ1cHL+NBCx9IBSqNshxFrG2BGRsFbvJHQ5lAC1q6Zddl4CuGUEZs4N4wLpR
         aSI7oO7AgYgneDhbb/VQkxfC9HJktuke6Ljv7+i1H4fXWLRXAyZ+9z9FhRPs9y/HhLra
         88gD0DqqC9OkYpkFOTL1t+ZQ8AmZ4SMAAZklCisPEuThiwoQr32Y6ue226z7c8oFAo8X
         ckQg==
X-Gm-Message-State: AOAM533ymThdmE/daTKAK10+WU62EMy8Yq+onpSvEZ9BGqV10xWSaPSW
        1UzUyG7+GSGoGptY5b96MzH7x2eIBnvzCw==
X-Google-Smtp-Source: ABdhPJxAm+gHXdl6imPr3+R6PuQYqaerQV+WX3x6cLrzFrlhSwnnfGhIGgxTFnBss/prYEmctaFAFVUHtbfyNw==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:bab:b5ff:736e:352f])
 (user=ipylypiv job=sendgmr) by 2002:a25:2a49:0:b0:648:f2b4:cd3d with SMTP id
 q70-20020a252a49000000b00648f2b4cd3dmr2231048ybq.231.1651104232325; Wed, 27
 Apr 2022 17:03:52 -0700 (PDT)
Date:   Wed, 27 Apr 2022 17:03:26 -0700
Message-Id: <20220428000326.3622230-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH] scsi: pm80xx: Remove pm8001_tag_init()
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jolly Shah <jollys@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In commit 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding
I/O supported to 1024") the pm8001_ha->tags allocation was moved into
pm8001_init_ccb_tag(). This changed the execution order of allocation.
pm8001_tag_init() used to be called after the pm8001_ha->tags allocation
and now it is called before the allocation.

Before:

pm8001_pci_probe()
`--> pm8001_pci_alloc()
     `--> pm8001_alloc()
          `--> pm8001_ha->tags = kzalloc(...)
          `--> pm8001_tag_init(pm8001_ha); // OK: tags are allocated

After:

pm8001_pci_probe()
`--> pm8001_pci_alloc()
|    `--> pm8001_alloc()
|         `--> pm8001_tag_init(pm8001_ha); // NOK: tags are not allocated
|
`--> pm8001_init_ccb_tag()
     `-->  pm8001_ha->tags = kzalloc(...) // today it is bitmap_zalloc()

Since pm8001_ha->tags_num is zero when pm8001_tag_init() is called it does
nothing. Tags memory is allocated with bitmap_zalloc() so there is no need
to manually clear each bit with pm8001_tag_free().

Fixes: 5a141315ed7c ("scsi: pm80xx: Increase the number of outstanding
I/O supported to 1024")
Reviewed-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 2 --
 drivers/scsi/pm8001/pm8001_sas.c  | 7 -------
 drivers/scsi/pm8001/pm8001_sas.h  | 1 -
 3 files changed, 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 9b04f1a6a67d..7040cecd861b 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -420,8 +420,6 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		atomic_set(&pm8001_ha->devices[i].running_req, 0);
 	}
 	pm8001_ha->flags = PM8001F_INIT_TIME;
-	/* Initialize tags */
-	pm8001_tag_init(pm8001_ha);
 	return 0;
 
 err_out_nodev:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 3a863d776724..dc689055341b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -92,13 +92,6 @@ int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
 	return 0;
 }
 
-void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha)
-{
-	int i;
-	for (i = 0; i < pm8001_ha->tags_num; ++i)
-		pm8001_tag_free(pm8001_ha, i);
-}
-
 /**
  * pm8001_mem_alloc - allocate memory for pm8001.
  * @pdev: pci device.
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 060ab680a7ed..ba959f986c1e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -633,7 +633,6 @@ extern struct workqueue_struct *pm8001_wq;
 
 /******************** function prototype *********************/
 int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out);
-void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);
 u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag);
 void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
 			  struct pm8001_ccb_info *ccb);
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

