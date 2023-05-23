Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0747C7EE2E
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 21:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbjEWVlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 17:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238498AbjEWVls (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 17:41:48 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E29013E
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 14:41:47 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-51b743d592dso194429a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 14:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684878106; x=1687470106;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p0y4TtuUdT60W21aKygGNQwI4gipZiKpcs4SNuMEkSY=;
        b=ssXbTfLiWJHzNKyW9cRLv4qJz0+wozWiG0m+T7u/6ikFqQa5Y1voVgqWwarbUqIA4B
         QOGC04YUxTx/kg90d6Y65h2gFL9dQ/u9STNqIgjXo8DmBHwII50n3e3q0pHw3cuN9t2A
         HYS7AzQLooXf0NDESkkjAvVK0LVfnduzvb2mGkfN17NuhdhrAOMHoIkw0ygPw2Xy0ill
         kZgs7ZSv+m2jod/FW+qOuDrpSIzv3CyPqc6/cKJsmeTeaDtRvoU0H2X9ooys5QbLADPK
         G0ycwST00lBJntyLG1Vk1zR6xO+8MY05IJFbFiSmfbk0OqQeS5vSRghj1LBju+M8ek0I
         SmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684878106; x=1687470106;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p0y4TtuUdT60W21aKygGNQwI4gipZiKpcs4SNuMEkSY=;
        b=IhuI7W1gXMOp/nYxV/63Cht1FKJFgP9SHDFGpqg6rjri27Ays/ZnTg9K7L13jgWcL+
         XVIekI377Aup0C7d0QwKAMn8bmt+COgVpZxZbsKaklGOW964XAeNqzOK31lnAJwkQxY6
         +VXMuw2p9vhBPmnkpxD3TemLWs8CpyXmSYjunM1uiKRszujtncpnIzsDU4LnSaO8/65M
         65yM4cBmQtrYQd3vw2oA/j2wTtEgAw8BGeUATkwZGbxtW/zbqwI8AO7yPyRTv0EzVkyB
         H9ebhU/oaGU/rjKHQMm6bCeB6EEjvTSL06cfFsq93aXXOpy9X6Q9/RTj3Gpo87F7uodv
         Xl3A==
X-Gm-Message-State: AC+VfDyp0hpJ7vQ4YXyHdQb+sACIyZO65F3QyLQ1mSjw+W/CiLjv2lJV
        j7pFJpLp15zKZaAUtvm2gywJPScecb1GUQ==
X-Google-Smtp-Source: ACHHUZ5WbWCRwFFb7/v5db2npTTTZeheQ9Ywyi+pn2dnNcfvDn7hCXLkYgl5gQEaWlkCabgD3PZgzaIkuZyHrQ==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a63:111a:0:b0:530:236e:1bfe with SMTP id
 g26-20020a63111a000000b00530236e1bfemr4372514pgl.1.1684878106282; Tue, 23 May
 2023 14:41:46 -0700 (PDT)
Date:   Tue, 23 May 2023 21:41:27 +0000
In-Reply-To: <20230523214127.4006891-1-pranavpp@google.com>
Mime-Version: 1.0
References: <20230523214127.4006891-1-pranavpp@google.com>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523214127.4006891-3-pranavpp@google.com>
Subject: [PATCH 2/2] scsi: pm80xx: Add fatal error check for pm8001_lu_reset()
From:   Pranav Prasad <pranavpp@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>,
        Pranav Prasad <pranavpp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Igor Pylypiv <ipylypiv@google.com>

This patch adds a fatal error check for pm8001_lu_reset().

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Pranav Prasad <pranavpp@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index b153f0966e5d..e302d5879bb7 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -918,6 +918,16 @@ int pm8001_lu_reset(struct domain_device *dev, u8 *lun)
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
 	DECLARE_COMPLETION_ONSTACK(completion_setstate);
+
+	if (PM8001_CHIP_DISP->fatal_errors(pm8001_ha)) {
+		/* If the controller is in fatal error state,
+		 * we will not get a response from the controller
+		 */
+		pm8001_dbg(pm8001_ha, FAIL,
+				"LUN reset failed due to fatal errors\n");
+		return rc;
+	}
+
 	if (dev_is_sata(dev)) {
 		struct sas_phy *phy = sas_get_local_phy(dev);
 		sas_execute_internal_abort_dev(dev, 0, NULL);
-- 
2.40.1.698.g37aff9b760-goog

