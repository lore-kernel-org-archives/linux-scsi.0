Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F343DC77B7D
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 19:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232513AbjDRTBz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbjDRTBw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 15:01:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8BF659F
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 85-20020a250d58000000b00b8f380b2bccso17565073ybn.14
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681844510; x=1684436510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3M04/PVG/NW2ywLizOW6+L2fN0aG9yYd0DnDu5UetZk=;
        b=jg+iCQtwdF8xsttudTN/6DvOTpNp4mkmnjDOOLQnElAXlkSTlPdIIA2PKtJG7o6J8k
         Z5ZIc6nHuE629pFZDMqIMndfSHLVvTAjtrI6dcs8cyWnCHLZjkl6U+XX9oC1biQKyEQc
         s+xMXOR+KpQsABmTJZL595TnCs/MvZRoUR3InKPvoAUe8nf4RY0gY+Ex5HHroIZel8Fe
         3mpbtlZhJfAsTMZGCwt3488DtYArf9ovsAhjZ51Mt64qdcBG6h8fzSZMXeseLPSK6aX6
         mpBVOfcMHEDD8DmLqgowfyihlH4Kqj0SOvNuCWsJyKIrYuqoZDQELFQNU4Y9eGTUjdrI
         qMSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681844510; x=1684436510;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3M04/PVG/NW2ywLizOW6+L2fN0aG9yYd0DnDu5UetZk=;
        b=aN+/pLMURwEL09GJo1g98KRYvt4S/oDkirmn3HZ7a2yx2aDjAdKzcrDE3lj22bHBX6
         eoI3ebmZyhdRYyn62G7hoC7si4OxVOUjFsCLnmlOGDyU/X96huusJMxMoKhXueA6t09o
         6+a/lyyw/ko9Cfx7AsHwRgkeC4s0qEDZI63lOraXqJNoGBNxSPDt82YaQ/EHVl7LV1Wy
         3WYGpM+qTz/FMhtWwz3F4wvoElixtU3DxvHXOQmWWX9p8f+6g+YvFT/QiIQwXV9ASdA+
         lKH7lqY9eO0ttTwQXOhrxDeZSeozxGtiRyIr7ldTrZ/QPK3tAzbHUPo54eXlSMXUeFG7
         whxA==
X-Gm-Message-State: AAQBX9cAWCQ0qjtpIGx+ix2VPQD2fygelPVD4N3KZHlipOUKiXyDnSn0
        DS9nBprp/sxNJJsf0ElR9NpiiPP8qDAzEA==
X-Google-Smtp-Source: AKy350aDSqTsTQCebasG2cB6gB8hD1DfdBwJKUKWrYLTNz8UDhSK5dFMSgm3phdGYBYmENs5K9KUzTEzUrHlRw==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a81:bd4f:0:b0:54c:bf7:1853 with SMTP id
 n15-20020a81bd4f000000b0054c0bf71853mr499349ywk.6.1681844510798; Tue, 18 Apr
 2023 12:01:50 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:00:57 +0000
In-Reply-To: <20230418190101.696345-1-pranavpp@google.com>
Mime-Version: 1.0
References: <20230418190101.696345-1-pranavpp@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418190101.696345-3-pranavpp@google.com>
Subject: [PATCH 2/6] scsi: pm80xx: Enable init logging
From:   Pranav Prasad <pranavpp@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Akshat Jain <akshatzen@google.com>,
        Pranav Prasad <pranavpp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Akshat Jain <akshatzen@google.com>

Enable init logging to debug drive discovery issues.

Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Pranav Prasad <pranavpp@google.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index d8dc629c0efb..041cdc41af80 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -44,7 +44,7 @@
 #include "pm80xx_hwi.h"
 
 static ulong logging_level = PM8001_FAIL_LOGGING | PM8001_IOERR_LOGGING |
-							 PM8001_EVENT_LOGGING;
+				PM8001_EVENT_LOGGING | PM8001_INIT_LOGGING;
 module_param(logging_level, ulong, 0644);
 MODULE_PARM_DESC(logging_level, " bits for enabling logging info.");
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index ce6a442d2418..61c1bf3d98a0 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4837,7 +4837,7 @@ static void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.ppc_phyid =
 		cpu_to_le32(((operation & 0xF) << 8) | (phyid  & 0xFF));
-	pm8001_dbg(pm8001_ha, INIT,
+	pm8001_dbg(pm8001_ha, DISC,
 		   " phy profile command for phy %x ,length is %d\n",
 		   le32_to_cpu(payload.ppc_phyid), length);
 	for (i = length; i < (length + PHY_DWORD_LENGTH - 1); i++) {
-- 
2.40.0.634.g4ca3ef3211-goog

