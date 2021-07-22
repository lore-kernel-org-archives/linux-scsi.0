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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB0BEC43214
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D479B60EB6
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhGVVhO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 17:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbhGVVhL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 17:37:11 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2411C061757
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id a20so1143641plm.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4m+vn3jta4RJi0CP8X5MSWl6OqWXnIHz1zepEJYFRuo=;
        b=Et10yCS6kSwFJ/yI2K+8n8gLXM+X9WdN9C6vSIpIQ9neRFwoIFbZtqXrx++2spSDMN
         3KvCxg2QyWNN0UlOY3rJ9tPb8Npybg3PDbFsanYuI8plqYiWwTRt/0IIWNPtvjPkhZcz
         IK8Ck+7um6eTOAow2aZ05hrgwEPVGkuK7I09/r/U20fFWpDglgoLuBMmzIePyhBUdPCc
         57b9KwIEZb3V1lzABugXxlY5AJpdARAiCkOMx6Pg4OT04NAq1zvBLUQC/Rv1ndmMIdQ3
         h0o5hdwJoLHKCzKwmmsBW0YuuB8TGwJmmaNhdQ8wdrWlUSZQPIbqj2edNA8rjs1lUbDF
         1OrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4m+vn3jta4RJi0CP8X5MSWl6OqWXnIHz1zepEJYFRuo=;
        b=B2yWBG560E1/tUa7a/D0m3kCKVWnQq4ZiiHLl+tByBz2KjxYzNB/h76FpXJW9U18Bv
         qJKTxgrIj9zwrPoWwoNz5+hWm/D4OmO9Ur3QQcGOZx4623QeCJNS1zowFDQK7Bra0PJH
         ckoVJy7NtFSrSK+roZXWv9qg+sqzhpfdeq4zePH+kz7bLtAX4X3InK/7TsiyMnIgKK/x
         Oiy834zvf5wYeLeqBwmBUVlPoz9MS+5zkaEKRWAeaVInbbKgRQ6hvXdxkXrJTcBhu+72
         Jba8l2eG451js7JJnxJtZJCGHBE5ldl+0KdcLDx/Ari3om7VsECHyr0r5L1+WJXLtK13
         tR0A==
X-Gm-Message-State: AOAM531on6HSGGuumTvkMOHkzUYHcl7aBnCzhF6WjTFXomtXsQy+n6c7
        SraVDGV0bX/cxfVKdU7DzguV6yfeZWI=
X-Google-Smtp-Source: ABdhPJxcSN8k4aqzhRWlZ2fx7YfWvDrmaMAjrUaWr6hlVXFQPH9lL0LTOSh5YJphdQHZ/vQKof4lTQ==
X-Received: by 2002:a63:4002:: with SMTP id n2mr2034744pga.124.1626992265261;
        Thu, 22 Jul 2021 15:17:45 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a18sm31374460pfi.6.2021.07.22.15.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:17:45 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 6/6] lpfc: Copyright updates for 14.0.0.0 patches
Date:   Thu, 22 Jul 2021 15:17:21 -0700
Message-Id: <20210722221721.74388-7-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210722221721.74388-1-jsmart2021@gmail.com>
References: <20210722221721.74388-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2021 for files modified in the 14.0.0.0 patch set.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw.h   | 2 +-
 drivers/scsi/lpfc/lpfc_ids.h  | 2 +-
 drivers/scsi/lpfc/lpfc_scsi.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 476d17708157..4083764916a5 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index 72ad9ecb87ab..6a90e6e53d09 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index 46989532c23d..3836d7f6a575 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.26.2

