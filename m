Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 438A6C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 217C8611AE
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhDJRbO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbhDJRbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:10 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F889C06138A
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:55 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p16so286632plf.12
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LHpg6cBX2RgWOwsKY5givgdByKnAhsGjFDq0W/sqBps=;
        b=A/4c5rCOF6YDO+VVw+/hoqGEkiMIvujiIi+PdI29J5qiBAJVfPbQ7hEAmf4zRrdLI7
         5JvXPF72tijbyHBr+WowPX5v4am32ikcCcDUPKBtxp+JkvyE7xVRqoEOLv3kPSg5FPhc
         1Jx32UalxU5E3zzKIclO3sjvXOn1GCA4eH8YzZPnj8ZUaO5jBUNiXfiT6dnVcDsZ/PK2
         XHCAs+WGSp5Gq2vmmIk+18LZcB30vM2OMBgkZgKxB6/1OOR+PLyIx0POTf/FDyHglREn
         BZO1sX8GDhC3s8+7tHl3rQjR4YaRiGykOYNB+4oYzb9QcgKeDqzjgILCdSirrVJ8HyhC
         EgQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LHpg6cBX2RgWOwsKY5givgdByKnAhsGjFDq0W/sqBps=;
        b=DS5Yh3nUA82C/U5OF2ke7ovKjFT7fF/XB9dYrPWQqZKwCZXXEjpCMu7velVst3167/
         gvOhxurpDroa+pldX8joftPg2ybJg4bn8+13AS4RATZVkaaPDD9Zp0IWul+9SisO3O+6
         uKAuU88UvyyBJThYLygjYsEhi1a+NWIjNRbKkf5b5FUsp1E8svPgudATICodU1etUtki
         +4cWwsZlx3QtlZdY74eZfGZRjaj33Yo5pLuF6S5da4iJzSnNeLoqhWrjSfOVxo0nGfWd
         uIvhvnCmgc8YVMThcqbch1Ayue0MFK/0IPzGb6KhHqCCGlF8DMifLXvAsW8xG5nditjz
         psVA==
X-Gm-Message-State: AOAM533Ss7pRKYO6MgTeNBoXALPW+PmMM+bdEJBEZSoLxXw4lTJpVPpj
        bBA0lJPJl7SCdIe/pkzLHSS0+OCwJSY=
X-Google-Smtp-Source: ABdhPJxhVF2IQKn9/YM1CbAafBdvsK1bDgp1eRbkZTNk/1Z2XWas2VP5ZH/+akgHRCwS2shGiP40Nw==
X-Received: by 2002:a17:90a:7047:: with SMTP id f65mr19286007pjk.44.1618075854536;
        Sat, 10 Apr 2021 10:30:54 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:54 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 16/16] lpfc: Copyright updates for 12.8.0.9 patches
Date:   Sat, 10 Apr 2021 10:30:34 -0700
Message-Id: <20210410173034.67618-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
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

