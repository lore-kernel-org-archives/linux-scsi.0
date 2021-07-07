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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC521C07E9B
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98FAB61CD1
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbhGGSrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbhGGSqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:49 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E15C061767
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:09 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id a127so3025479pfa.10
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=veF7IArj5RvOtdG254L8uPv6LZo+bKNp6QXwGfagVqY=;
        b=txYFtMP5W89y/uLqfRRLV+Jm2YpqGwy1z33JnshNfkw4SIABfsAPJv/Kv8Ip7+NePb
         5TtKWemNoil39pJGeawGjDYHc68PRoUTTg8p4qR1KVTDSw8R3NoBjw/NZ1n3vABE7r4F
         ZKc6FHq9m48PloEdCMNdlcKszy70G9swosb7gaOjoCr6k5ZTQD5bHgZ8wJXwCLRIYMIr
         4SrtJwdUv7F61pEuWL+9A1YkkuGI4PeP8Tdk2tY8AlbzmisH2Yi0EwW1t+54dFdA0ktI
         Rvn8fz4IOEqAcFd6CzmTIsSsssZqKygYUGO/KsWGPIy8ZRHniBTmC+bDl6G2xQAq6VAz
         kV1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=veF7IArj5RvOtdG254L8uPv6LZo+bKNp6QXwGfagVqY=;
        b=gB4VJM5OmqyvmhaDzKXKobom/mphiuEC2sS1JaFdUcAzWDrEBqjIrRQvF6TubC64X/
         KBxEQbO+8uK7bQC/8B1gZ9LwRnRtonc5qEkQBTt5g5vB3ZBXI+1WsK7T0701M3Kw86bh
         mFLgkVU292MZo4x4DFlmJexPUokHOXnyfJELzjuNiRfTSrgYEgW4qndrc6D7TYsl6fRp
         DDuvOmGtERepCZ/w3ORBTISZcj6TWRseaTo127zxJ882DY8vQrY3mR69Iss5gJ/CisiY
         u3pSnd+Jtrx6TNYHnomt1H/JBSYg/cmvFgz9BwIjDO9X2IifnhlA+qOEn+NpR/1uvNJP
         so8w==
X-Gm-Message-State: AOAM533aKgJdMI0Ku4O67O40krniFnnIGRzkQU6UdlJQF2AbSyz9YXSC
        QWSp7ZW0NGiHv5/LuoncxUqMFLi6QV0=
X-Google-Smtp-Source: ABdhPJx6IJASv8MHeQe7YIaWqsg/YHIKf3jSupvZ6VENlF+fYVwWKF0p+cIxOadZXZISuPextzu0WQ==
X-Received: by 2002:a63:3584:: with SMTP id c126mr27440508pga.33.1625683448768;
        Wed, 07 Jul 2021 11:44:08 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:08 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 20/20] lpfc: Copyright updates for 12.8.0.11 patches
Date:   Wed,  7 Jul 2021 11:43:51 -0700
Message-Id: <20210707184351.67872-21-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights for files modified by the 12.8.0.11 patch set.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.h | 2 +-
 drivers/scsi/lpfc/lpfc_sli4.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index 060a7c111bad..f61223fbe644 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 021edbfbbca5..f250b666ac57 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2021 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2009-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.26.2

