Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C3D9C4320A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3390561029
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhHPQaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 12:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhHPQaX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 12:30:23 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BC7C0613C1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:51 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so33319678pjn.4
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AsxydOY+lNRb2e3ADR2di+F/3cNRDqMO4+kiJOm870I=;
        b=l0RYUjBxFMGLYZ84eKpoHawgw/sk6jUWglYCL5VLXQ3YPMC+uXwZLuCL5vLpDDHL2Z
         cWiROS2z43AtaEoEF1TRNw88Y2YFiJK9FNBehLIcTpTYxg5RSKvrdkX7QLMuD0YC6O4C
         1W6lddGEzAU5tSUjH5bZV5B3HyC/pgrl2nIJzWoheKEkJMhOhFLUWJme8B8jdO8Leh5J
         RIr915YFvFUWzM/KgcWGGbSUNlyVe3mxKuK0t5Zoc0duZ22mY/oCSE6ermbIsz0U8kpG
         9OdMfTrRN9uZoKRTBHKI60qJcRg0a5kMkxMxiW4b/lUtpPuHOog9ohSeRqf8pDaDCRz3
         Bd5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AsxydOY+lNRb2e3ADR2di+F/3cNRDqMO4+kiJOm870I=;
        b=cYiWx95ZieS087tDbcOYIdpAuh4e5LwdFH9nZQXuElkV/qgWxUCMFGyDzliyLaIndP
         jS7VECNVdGuUi+mmHHsLHUOhPqq+huJbZT3SBMXeViOTJz0Phf4/ebUxoYlpsH5IcHV6
         nP0F6Gb3tH+CQOBwCS9ui0Wh9ustLlZeGuieH8Af13u9zyp6NJH8N/k5/buIrUa12cKY
         y5JIaYmACAgMZsLKV2ywMTSdlJ+dOZ8W86ukFTJAT2iZmaZHpYxkm0mOgWy2yahYplSV
         gNj770OwGi/8JSU9dHCy2RxeVDVgF+bj4VFkIrEAoW+7AnHwgTMK/hZNJ344EDOG2ys6
         qTsQ==
X-Gm-Message-State: AOAM530GjfzRvzGODks7e5sDZWU6UuDOqLyYAOq2UVskjf3x593qgc9T
        4DJPTiWCflxhcmDit/oceIexsEJjSS8=
X-Google-Smtp-Source: ABdhPJxGqCIvZZaPJoncVPqQdaJ7qt2C5hKse4viA3UgRrZv2ts8rJ8qug9w29mGERtcnU9/rYaG/A==
X-Received: by 2002:a17:90a:9af:: with SMTP id 44mr17887374pjo.62.1629131390967;
        Mon, 16 Aug 2021 09:29:50 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm11257938pfv.131.2021.08.16.09.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:29:50 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v3 16/16] lpfc: Copyright updates for 14.0.0.1 patches
Date:   Mon, 16 Aug 2021 09:29:01 -0700
Message-Id: <20210816162901.121235-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210816162901.121235-1-jsmart2021@gmail.com>
References: <20210816162901.121235-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2021 for files modified in the 14.0.0.1 patch set.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.h     | 2 +-
 drivers/scsi/lpfc/lpfc_debugfs.h | 2 +-
 drivers/scsi/lpfc/lpfc_logmsg.h  | 2 +-
 drivers/scsi/lpfc/lpfc_mem.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index 17012bcc7c38..749d6c43cfce 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2010-2015 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.h b/drivers/scsi/lpfc/lpfc_debugfs.h
index dd4cdd8563eb..a5bf71b34972 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.h
+++ b/drivers/scsi/lpfc/lpfc_debugfs.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2007-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index d719a16c0f96..7d480c798794 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index 7cb9f4b52b49..870e53b8f81d 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2014 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.26.2

