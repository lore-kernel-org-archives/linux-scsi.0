Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0DB9C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 06:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99DA664FFD
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Mar 2021 06:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhCEGLd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Mar 2021 01:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhCEGLc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Mar 2021 01:11:32 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F236C061574
        for <linux-scsi@vger.kernel.org>; Thu,  4 Mar 2021 22:11:31 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id z12so607137pga.11
        for <linux-scsi@vger.kernel.org>; Thu, 04 Mar 2021 22:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=pIHlJZ21DexKDQHuWyZUq1RT8j5sDUoJyRKrr5clMwY=;
        b=ICKz5coyea2SH+WhjNtxPJ3XG59pnwhsiEk8W8AL+D2+G9EhbPTJAXYnVFIuJFEoxM
         x2pK38nqr/z/mzfCpFZ72dCE4olVBJwlQaPGdC/a17WVq3ybRRFzxj/Ir/yENH+UabG0
         psCzxZcE6Colvnp0lOmnjlXOzBpN4FXMqTGKBh27fSnkfh3UGXMSFJZStD7hnMzn5Cng
         e5kcKy44+5KyWVmnpbmPIwLSPxZD6BzkNj/2rWuNvex2FlOCblh++3ydhfPfKZrDvnni
         TepftQpEq2e1Vs7oSNycIjK98ZHsn1S5kd1REt6bworgnjpYuvGhAW0xiPz+nxScXaaB
         kfog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=pIHlJZ21DexKDQHuWyZUq1RT8j5sDUoJyRKrr5clMwY=;
        b=F6uetNJL3b25f0Vb/vtXlTQFo9oyZzqArDGr6n7pzhrMepD8vqC3J73FApvysFx4w0
         vhTCOglYOxWi9iP6Kzlz+rSIhxBkbeEKfHC0LU/LwGABrr9ohfQkrrvOLxOdvL2Jwh6h
         cMtSrpvAYlgGIN8z9/OpWOtljRQLUtx8RuHXLXOwKYkBSL5VThXToYc5SR72Gfc2J/BB
         nhhTgUVQOP7/0MiApmuE7ubhbjU2zGI+rkpHispzqJeqwJPV8rVNDnVgNoXILo+t9ubM
         UMzwvANj3zzzDXMvc/lTjUZ47SOp7Bcdo2LX3xH1F34JEXHEI4Ws788ixioZgjG8on9e
         sVag==
X-Gm-Message-State: AOAM532G6DSlNUhdsIUDuzAiyvIc1iqoAzBiGh5q+c+YyihOsAYbeKd3
        WDnPa2yjBNRZB9aWja1zsmwg4tzl6GnU1g==
X-Google-Smtp-Source: ABdhPJww6brHKaXkl5f11kAj9Zr2JJJ45puPzQJuaOmf4fSymUrobNg10da8PCv+CV4lncONQnWc0+PLVm1o8Q==
Sender: "ipylypiv via sendgmr" <ipylypiv@ipylypiv.svl.corp.google.com>
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:64b3:d31b:bec8:bf6c])
 (user=ipylypiv job=sendgmr) by 2002:a17:903:2301:b029:e4:9026:4c7b with SMTP
 id d1-20020a1709032301b02900e490264c7bmr7440954plh.76.1614924690629; Thu, 04
 Mar 2021 22:11:30 -0800 (PST)
Date:   Thu,  4 Mar 2021 22:09:08 -0800
Message-Id: <20210305060908.2476850-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH] scsi: pm80xx: Replace magic numbers with device state defines
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Akshat Jain <akshatzen@google.com>,
        Jolly Shah <jollys@google.com>, linux-scsi@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This improves the code readability.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a98d4496ff8b..0cbd25a2ee9f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -738,7 +738,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 		if (pm8001_ha->chip_id != chip_8001) {
 			pm8001_dev->setds_completion = &completion_setstate;
 			PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
-				pm8001_dev, 0x01);
+				pm8001_dev, DS_OPERATIONAL);
 			wait_for_completion(&completion_setstate);
 		}
 		res = -TMF_RESP_FUNC_FAILED;
@@ -1110,7 +1110,7 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 		sas_put_local_phy(phy);
 		pm8001_dev->setds_completion = &completion_setstate;
 		rc = PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
-			pm8001_dev, 0x01);
+			pm8001_dev, DS_OPERATIONAL);
 		wait_for_completion(&completion_setstate);
 	} else {
 		tmf_task.tmf = TMF_LU_RESET;
@@ -1229,7 +1229,7 @@ int pm8001_abort_task(struct sas_task *task)
 			/* 1. Set Device state as Recovery */
 			pm8001_dev->setds_completion = &completion;
 			PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
-				pm8001_dev, 0x03);
+				pm8001_dev, DS_IN_RECOVERY);
 			wait_for_completion(&completion);
 
 			/* 2. Send Phy Control Hard Reset */
@@ -1300,7 +1300,7 @@ int pm8001_abort_task(struct sas_task *task)
 			reinit_completion(&completion);
 			pm8001_dev->setds_completion = &completion;
 			PM8001_CHIP_DISP->set_dev_state_req(pm8001_ha,
-				pm8001_dev, 0x01);
+				pm8001_dev, DS_OPERATIONAL);
 			wait_for_completion(&completion);
 		} else {
 			rc = pm8001_exec_internal_task_abort(pm8001_ha,
-- 
2.30.1.766.gb4fecdf3b7-goog

