Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DAE2C43616
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5510B61027
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbhDLBce (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbhDLBc1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:27 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F18CC061342
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id a85so7716964pfa.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LHpg6cBX2RgWOwsKY5givgdByKnAhsGjFDq0W/sqBps=;
        b=tVv/VR0nn94f8EE84osM2wjoIaL1YvJgm1NhgaTxyZe7ZjDY8D39UGn2kQoIzLc71/
         05q4Oa68oTzj5NbV+KqxMXahO/q7qmkC86luges3qF00p2zL8+WLbxOfvV6cZvG1/HBI
         voAtpzBNNRKFv09gySmgqiNlchDB8akv7/p4JExiLskjM8szukvI7mcFsUg3UqE2FkdH
         P6xQ0u+PuJHdM8AdKB2pf3ZaYQtHVtAof/fQgQX9RHg2P5PIS9QOLs3ylqVqtwTYD38c
         2g9cghu7SGn26NZdJbtWpHNO/iFBdHWxX8usJTS7naR3RgW7FQNk5Vi5bEDix9quH2ND
         ic3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LHpg6cBX2RgWOwsKY5givgdByKnAhsGjFDq0W/sqBps=;
        b=EeExcATwEMFGmjrM3QDvocqZoX5NfjBJBR2NQqffQCeOUgUOWTMOpBEJCdus+lJ5Yg
         HxYxOoTxbeB9nibEl9WFv246gjrOI26qaUj4c9dRd4CsqzC1MVkgfoFvHsWr7Mpy8QAR
         Uc58wQfl32r4fP7wDN7/rltkDjNeKDP/mZf2k58FYiZFxJbvx7UjT/Iz/MFzYm1pyVWc
         rmMGKnflfLrZs63M1hTLfOtRghAits4gCipPaaLeaSk+mjeOA5tqlIdARXDoSCPtcWEj
         KWYdTtwAL5lGtYW/BEI7KPVFTGUSb/VxJmd6erOFnp1PR5qKb8tIpzCrTYn5QF6Hsb8Q
         EHAw==
X-Gm-Message-State: AOAM531+Yfmtksg13YTkBefEgfjLsXXYF1zhTeCY+GfZAl8OCmq4Jatl
        EGHqYDb2/dqrDJPTm9yxOUtDFuxA8m4=
X-Google-Smtp-Source: ABdhPJxQ96Zh6DqhYV7OIu5AKte7OeIETxEWRp7jO3XxHBm+0yxD6f9A3Yj1dgvs6GYU2XiKxR5g5w==
X-Received: by 2002:a65:558c:: with SMTP id j12mr24404279pgs.271.1618191129832;
        Sun, 11 Apr 2021 18:32:09 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:32:09 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 16/16] lpfc: Copyright updates for 12.8.0.9 patches
Date:   Sun, 11 Apr 2021 18:31:27 -0700
Message-Id: <20210412013127.2387-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210412013127.2387-1-jsmart2021@gmail.com>
References: <20210412013127.2387-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2021 for files modified in the 12.8.0.9 patch set.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c  | 2 +-
 drivers/scsi/lpfc/lpfc_ct.c   | 2 +-
 drivers/scsi/lpfc/lpfc_hw4.h  | 2 +-
 drivers/scsi/lpfc/lpfc_mbox.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 32e562f27e8f..c2776b88d493 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index b9bccd8fc355..3bbefa225484 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index f5bc2c32a817..f77e71e6dbbd 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 72dd22ad5dcc..1b40a3bbd1cd 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.26.2

