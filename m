Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1068C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D8060C40
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhKAXbb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 19:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbhKAXbb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 19:31:31 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92082C061714
        for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2021 16:28:57 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a84-20020a621a57000000b00480fcb384a7so3121407pfa.20
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2021 16:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2Xh/if2j5bKs14GrXeGI4p8CW0yILG7SJ9GF2+i+STs=;
        b=ZMDUFD7ea1ImDpI3iLIQoTbu2T0gCc67XYB9QpX00C1r7hiYuLg3KGlbJDGXYENSUq
         0sYAVLlFkJENfXAQFjROtKZbN3RMEdvxPGqRQFUqeDV4zB57vP2mbapYkKHeJfQl+V3F
         OKTCgU7oaWqNi2/2Nrj7fE3bR64LX372+fx0BBV/75+iUhJkw0V0nwnV4GJrusw7dgou
         KSgbkKOkS9T4s0x1vXLIc6tohaea/SAMUj3IKrsmo2KSUqr5y+GLqPOnuFO0Ezj/UIJA
         kZp1nBvkcPWApblFeR/Bi0rSrg8PPR+zMu4vuk3MBBdrXt3YHdNsK6VW9Qfo2XXAXgxS
         VdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2Xh/if2j5bKs14GrXeGI4p8CW0yILG7SJ9GF2+i+STs=;
        b=LuGIpO/wuICHHjhn0QnyOtMsf/M+7Z9HOpjA6rrymZ1lt0aqqDlyT1Z9hpb8kyg0cU
         c755uufi0FJM3YyQYLhm0Oujvjt97TKyZvm68DRiidVkRbMEFjhJm0UEqSPdzzuEIk5y
         Du41y3K96/uTAv6vaLfWF5/N6Ek5/Vz5iFl2eONAocCZCsVesCwt42xwtxgO+2W+Bhwj
         y1NFotr1RbETOVbqNWw5rbxej0EV9jKdqSLBSemdcKJwmHK6lnIfMqTIvupRQ/bDZkk9
         FUMpGbVK+eVa2dzC5xkmTva5KjoRQhFiKYC/g6iyYeNaWzgJbUV/fQf88F9QoutO4yMW
         BMPQ==
X-Gm-Message-State: AOAM531MKt6glMsIajErK3EP46NwVqjuBFgicbwKdsvCC1oBOUF2BnEq
        zi0gImCVzstpaeqHoSzpHcL0yy9uIi0BOA==
X-Google-Smtp-Source: ABdhPJxfOvCCi39pnxFC3U3uZ3wARZYxZNKNReBz5h0gZeTd5C59iOUeXb2FC/ycQqWN6Kki/1SBFLf0OoQ06A==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:3684:4dd2:e6b6:ef66])
 (user=ipylypiv job=sendgmr) by 2002:a17:90b:4ad2:: with SMTP id
 mh18mr2280516pjb.18.1635809337132; Mon, 01 Nov 2021 16:28:57 -0700 (PDT)
Date:   Mon,  1 Nov 2021 16:28:23 -0700
In-Reply-To: <20211101232825.2350233-1-ipylypiv@google.com>
Message-Id: <20211101232825.2350233-3-ipylypiv@google.com>
Mime-Version: 1.0
References: <20211101232825.2350233-1-ipylypiv@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 2/4] scsi: pm80xx: Do not check the address-of value for NULL
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Address-of operator cannot return NULL.

Reviewed-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 24 ++++--------------------
 drivers/scsi/pm8001/pm80xx_hwi.c | 29 ++++++++---------------------
 2 files changed, 12 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 63690508313b..1a593f2b2c87 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2304,21 +2304,17 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	psataPayload = (struct sata_completion_resp *)(piomb + 4);
 	status = le32_to_cpu(psataPayload->status);
+	param = le32_to_cpu(psataPayload->param);
 	tag = le32_to_cpu(psataPayload->tag);
 
 	if (!tag) {
 		pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
 		return;
 	}
+
 	ccb = &pm8001_ha->ccb_info[tag];
-	param = le32_to_cpu(psataPayload->param);
-	if (ccb) {
-		t = ccb->task;
-		pm8001_dev = ccb->device;
-	} else {
-		pm8001_dbg(pm8001_ha, FAIL, "ccb null\n");
-		return;
-	}
+	t = ccb->task;
+	pm8001_dev = ccb->device;
 
 	if (t) {
 		if (t->dev && (t->dev->lldd_dev))
@@ -2335,10 +2331,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	}
 
 	ts = &t->task_status;
-	if (!ts) {
-		pm8001_dbg(pm8001_ha, FAIL, "ts null\n");
-		return;
-	}
 
 	if (status)
 		pm8001_dbg(pm8001_ha, IOERR,
@@ -2695,14 +2687,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 dev_id = le32_to_cpu(psataPayload->device_id);
 	unsigned long flags;
 
-	ccb = &pm8001_ha->ccb_info[tag];
-
-	if (ccb) {
-		t = ccb->task;
-		pm8001_dev = ccb->device;
-	} else {
-		pm8001_dbg(pm8001_ha, FAIL, "No CCB !!!. returning\n");
-	}
 	if (event)
 		pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 4f887925c9d2..f9e997b23d42 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2399,21 +2399,17 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	psataPayload = (struct sata_completion_resp *)(piomb + 4);
 	status = le32_to_cpu(psataPayload->status);
+	param = le32_to_cpu(psataPayload->param);
 	tag = le32_to_cpu(psataPayload->tag);
 
 	if (!tag) {
 		pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
 		return;
 	}
+
 	ccb = &pm8001_ha->ccb_info[tag];
-	param = le32_to_cpu(psataPayload->param);
-	if (ccb) {
-		t = ccb->task;
-		pm8001_dev = ccb->device;
-	} else {
-		pm8001_dbg(pm8001_ha, FAIL, "ccb null\n");
-		return;
-	}
+	t = ccb->task;
+	pm8001_dev = ccb->device;
 
 	if (t) {
 		if (t->dev && (t->dev->lldd_dev))
@@ -2430,10 +2426,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	}
 
 	ts = &t->task_status;
-	if (!ts) {
-		pm8001_dbg(pm8001_ha, FAIL, "ts null\n");
-		return;
-	}
 
 	if (status != IO_SUCCESS) {
 		pm8001_dbg(pm8001_ha, FAIL,
@@ -2804,15 +2796,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 dev_id = le32_to_cpu(psataPayload->device_id);
 	unsigned long flags;
 
-	ccb = &pm8001_ha->ccb_info[tag];
-
-	if (ccb) {
-		t = ccb->task;
-		pm8001_dev = ccb->device;
-	} else {
-		pm8001_dbg(pm8001_ha, FAIL, "No CCB !!!. returning\n");
-		return;
-	}
 	if (event)
 		pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
 
@@ -2826,6 +2809,10 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		return;
 	}
 
+	ccb = &pm8001_ha->ccb_info[tag];
+	t = ccb->task;
+	pm8001_dev = ccb->device;
+
 	if (unlikely(!t || !t->lldd_task || !t->dev)) {
 		pm8001_dbg(pm8001_ha, FAIL, "task or dev null\n");
 		return;
-- 
2.33.1.1089.g2158813163f-goog

