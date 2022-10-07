Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DACC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Oct 2022 23:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiJGXIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Oct 2022 19:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJGXIE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Oct 2022 19:08:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47F5F88F9
        for <linux-scsi@vger.kernel.org>; Fri,  7 Oct 2022 16:08:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id t8-20020a258388000000b006bfb0865043so1371298ybk.13
        for <linux-scsi@vger.kernel.org>; Fri, 07 Oct 2022 16:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BRUAkgPbXDSUy8pZqqQenKuEBRZxhxn7JY7Ad7kPHQ8=;
        b=ZdggaZj2i3uevwtZ/H/mBA+CsujtrxI85/rbNEnsI+UOD66YCkgq07bMm9IalY9AoH
         n9+16ISh9EaKLtW9NRgFtTfpTU5KlEXZBKqlES+hxIdau6EedXbSTkdEild6q6CB57cl
         KxxZEgM+4x+Y+maqvSsUNviTxRQ372yWrDXBVMchJ9ywAW5Z+jJyBMHA+jVnNvoExfRE
         kxmMQG1RA1evS9l7s0VwgiLhPECeo6QI6RJDDaGYr7L/P2eThhZmkKakQ+1kAGpyhHFN
         80eSi6KjuBuc6F9RWSAATMkgV1toEkkJlz8M5qfLTamsF2AmTw4RNmsXxdGAD4ZFt/lc
         AYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BRUAkgPbXDSUy8pZqqQenKuEBRZxhxn7JY7Ad7kPHQ8=;
        b=eQUFQsTB8dyfp2GOGeYUBLNXF5GR+zo0ESgOHNxOKDyVfvBDnyrf64r0n8lgtZyoUW
         yl8e5oG9/1AkUr7Z9if7HmC/ZDJuPVxa+rEkldkpsG/HQOMZN1DseYdbU5aFnydocXl7
         xEqp8+ONVaLBBzss6Ert6lr6QeLcM0w3au0kFqyw20uqSqyiHnpeB7N2MlZmkaEcbDgX
         jGihddQd83gEOzbZiuyjKxbTbKPlG5Wh4QESZpShWGla9FRJv8SMLMP8SExWQc26GUS5
         C9MybmWp9SaKIeHxd/SRSblMnbd7PPxNYUC+xsDct0HUMbJ8Qq09GRvhVcZ8fR+Mn+L+
         g1qg==
X-Gm-Message-State: ACrzQf0YzvHWdREUlI4wSJjRV4Kupf/4NQ96dZMmgSNVrhLgIrOROcOS
        9ZUlDVE631F2mVd98Yrqr1v5679aP4hoUQ==
X-Google-Smtp-Source: AMsMyM4q4geKC43BIla1KUjt40xSc0TIqvi4wVXU1k0d7N/O84rFlzj4lSyo1vz+bWaPdN799kIdtODqVTzC3g==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:13:4341:2093:c9c3:a120])
 (user=ipylypiv job=sendgmr) by 2002:a81:6c7:0:b0:353:cc42:3d12 with SMTP id
 190-20020a8106c7000000b00353cc423d12mr6851426ywg.60.1665184083045; Fri, 07
 Oct 2022 16:08:03 -0700 (PDT)
Date:   Fri,  7 Oct 2022 16:07:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221007230751.309363-1-ipylypiv@google.com>
Subject: [PATCH] scsi: pm80xx: Remove unused reset_in_progress flag logic
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jolly Shah <jollys@google.com>,
        Andrew Konecki <awkonecki@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The reset_in_progress flag was never set.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Andrew Konecki <awkonecki@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.h | 1 -
 drivers/scsi/pm8001/pm80xx_hwi.c | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index b08f52673889..2bbec5083106 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -535,7 +535,6 @@ struct pm8001_hba_info {
 	bool			controller_fatal_error;
 	const struct firmware 	*fw_image;
 	struct isr_param irq_vector[PM8001_MAX_MSIX_VEC];
-	u32			reset_in_progress;
 	u32			non_fatal_count;
 	u32			non_fatal_read_length;
 	u32 max_q_num;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index f8b8624458f7..51c9541f6f4d 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3550,10 +3550,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case HW_EVENT_PHY_DOWN:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
 		hw_event_phy_down(pm8001_ha, piomb);
-		if (pm8001_ha->reset_in_progress) {
-			pm8001_dbg(pm8001_ha, MSG, "Reset in progress\n");
-			return 0;
-		}
 		phy->phy_attached = 0;
 		phy->phy_state = PHY_LINK_DISABLE;
 		break;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

