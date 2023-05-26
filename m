Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E792C77B7C
	for <linux-scsi@archiver.kernel.org>; Fri, 26 May 2023 23:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjEZXwh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 May 2023 19:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbjEZXwf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2023 19:52:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33B513A
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 16:52:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-babb53e6952so2832721276.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 16:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685145120; x=1687737120;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3gkL2ZysifCX6QuWFr+kemlXIPFMHwY6YLDYqUvek4g=;
        b=zzD3toTUDIquQRqQxVbpkGZCNhAGQJVkVodWmJyBF5PKTm6ASrqgwxniGFDtinz9zZ
         rboUSdqPDY+nHOBIzLtsP21/bNWzI9bLvYAmHorq/VHjS7xRK/yiS6CWXeIZjKevCtiA
         rjoHoRVpwUMcwyr4JSKijQTllPlzGJ1wgpeE1BfSABrAFhBfXGQCtSDxLUmcfIgmcwLe
         HXFGe62HDokUZj7jztEtEHeN4T9lgksA7NLqGeVeDc4sEP7PCe5unSRKAoiNSmfgzuvq
         G0Y8e6sSFKWowXQUAQnE1h1qByiWfWeICT8bks9Kp2ja+EyUU/p+iGMDlXHUBJVk5+JN
         HPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685145120; x=1687737120;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3gkL2ZysifCX6QuWFr+kemlXIPFMHwY6YLDYqUvek4g=;
        b=OHlqCtCOaeJEahYcO6LvfscDBmsbrkln69wxLVhOY1ZvmOJLZjiure7vzM4ZtozX6a
         5+bdRZx4j22ZwaM213FGAuKonNwG0hGtE6WIIbXLKytmqImEaFDIzjJ27rR0R7zo0/q4
         8zzB5sOdwpnPV7vJrS8tEWmlZWA2890MgBUMMLeKx+PtyP9kumREq5uzreUavwzfgYlP
         oz6Q0TTPQdl0BYEPNCXfoI23NWJ5ZsPrI9OC++tGP09/neBBIeAOOASEBqPs9pyyoq4J
         6fupiYs/p9DO/Tn92xQoGeeLbtZXkJxlc57kgd6Zor+pw+ObXxCdIJ2VU9KCts15UJIl
         5irQ==
X-Gm-Message-State: AC+VfDyHSX5CW5dKG+BLn8Er4+u11zTnUqaS4Y2JysKM+sPR/IhR7gVM
        sM08dwaM2+M17c6Uyspno4lNAmXqLaxBBA==
X-Google-Smtp-Source: ACHHUZ5j0DjM8sq5pG0MJ56RrsWclxTU1KJd7CMJmIXPcL0xUwk9eY/XbzgabbsKPXKeyfU+QWGDnMxOSK626w==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a25:4582:0:b0:ba8:91c2:268a with SMTP id
 s124-20020a254582000000b00ba891c2268amr1885823yba.0.1685145120249; Fri, 26
 May 2023 16:52:00 -0700 (PDT)
Date:   Fri, 26 May 2023 23:51:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230526235155.433243-1-pranavpp@google.com>
Subject: [PATCH v2] scsi: pm80xx: Add fatal error checks
From:   Pranav Prasad <pranavpp@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changyuan Lyu <changyuanl@google.com>,
        Pranav Prasad <pranavpp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Changyuan Lyu <changyuanl@google.com>

This patch adds a fatal error check for the pm8001_phy_control()
and pm8001_lu_reset() functions.

Changes compared to v1:
- Changed the patch series to a single patch.
- Added empty "/*" line to the comments as requested
  by Damien Le Moal.
- Aligned function arguments in pm8001_dbg() as
  requested by Damien Le Moal.

Signed-off-by: Changyuan Lyu <changyuanl@google.com>
Signed-off-by: Pranav Prasad <pranavpp@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index e5673c774f66..a5a31dfa4512 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -167,6 +167,17 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	pm8001_ha = sas_phy->ha->lldd_ha;
 	phy = &pm8001_ha->phy[phy_id];
 	pm8001_ha->phy[phy_id].enable_completion = &completion;
+
+	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
+		/*
+		 * If the controller is in fatal error state,
+		 * we will not get a response from the controller
+		 */
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "Phy control failed due to fatal errors\n");
+		return -EFAULT;
+	}
+
 	switch (func) {
 	case PHY_FUNC_SET_LINK_RATE:
 		rates = funcdata;
@@ -908,6 +919,17 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
 	DECLARE_COMPLETION_ONSTACK(completion_setstate);
+
+	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
+		/*
+		 * If the controller is in fatal error state,
+		 * we will not get a response from the controller
+		 */
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "LUN reset failed due to fatal errors\n");
+		return rc;
+	}
+
 	if (dev_is_sata(dev)) {
 		struct sas_phy *phy = sas_get_local_phy(dev);
 		sas_execute_internal_abort_dev(dev, 0, NULL);
-- 
2.40.1.698.g37aff9b760-goog

