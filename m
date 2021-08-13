Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DAA0C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD586109E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbhHMXCB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235498AbhHMXB4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 19:01:56 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75718C0617AF
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:01:29 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id a20so13994881plm.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AsxydOY+lNRb2e3ADR2di+F/3cNRDqMO4+kiJOm870I=;
        b=PW9kHWxVTVKr+4czkc2exMMHdtXShVcgRiXuj8Eq1qjoQffy9HN/b3AHUVnoaqmSMy
         6DG/qs3r/gvPYiUg4eMxc5vbmoq486TKyrTvL85LijcF8rCsiQXENQ44pXMvz7sqrjCZ
         qZulP9FI7L9Y6ZnHLjBZRfSmSJCxHfNjSdabvTEhtt8YoK2VpM6UeW5kn2++RMGty6eH
         5GdB0J2ERUiH5elY4ygx71e3KjlBm/UlM7sbVf8epzHSfZBfw1TVR1YIrPXMe4iZnbuJ
         sWungw6Vu//BAtcRc+CSoIAwx8BeeJBKW51v0K/Y6KGeCr64PVV0rBTgvC/Fh+SJqJiF
         IMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AsxydOY+lNRb2e3ADR2di+F/3cNRDqMO4+kiJOm870I=;
        b=UkHOBc0DyclIbK5Y+fNlK2weu3w8RojWDF9BgYxDhtXW8uxdLPzsm9neHa78RT0S0m
         xfSMnQOQ4xwJSAv94R6xij/71ARX0JhNSe1mcMHPkEhPLb9tLG9adtMLMQDlOFTBmNDg
         /taAg66HTFkwhtiCZbCy8XGzdyCXJ5KZSj0FHmRSnmOYLH23kjGP+3XoquBL9n0PA3Lx
         v0sRbyAyz8ZTM9B+X3AJXfZAMeGirGQBOrI4VZk9PovO2Th+LuZblaslomMgUEI7SPdE
         9mXuaBj20grSRAkK4LBBGKBJbc7fIrQ3mcWL0cIb46GhE0gWWeSy166n8t6WmItaMMYh
         RX0g==
X-Gm-Message-State: AOAM531b/H2M9f6vzVvcg1deRAR0zzBgFNGQcmLPKJ5x/KnFsBf4MS9/
        PEMx2Jrftf7Z06UZj/kGIDBhLfAJXW8=
X-Google-Smtp-Source: ABdhPJyU/IrI8R1EIvgVG5nHRO+baAN6iJ4ew0lECzYdoMG9mT/h/VL7bQbl5f7N7NNK/3+cRK4aug==
X-Received: by 2002:a17:902:e20a:b029:12d:76cd:6721 with SMTP id u10-20020a170902e20ab029012d76cd6721mr3747221plb.43.1628895688961;
        Fri, 13 Aug 2021 16:01:28 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e8sm4001997pgg.31.2021.08.13.16.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 16:01:28 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 16/16] lpfc: Copyright updates for 14.0.0.1 patches
Date:   Fri, 13 Aug 2021 16:00:39 -0700
Message-Id: <20210813230039.110546-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813230039.110546-1-jsmart2021@gmail.com>
References: <20210813230039.110546-1-jsmart2021@gmail.com>
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

