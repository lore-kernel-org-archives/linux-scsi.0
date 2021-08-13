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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA7DC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2D0F610A5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:09:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbhHMCJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238110AbhHMCJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 22:09:25 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A90C0617AF
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:09:00 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id a5so9896707plh.5
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AsxydOY+lNRb2e3ADR2di+F/3cNRDqMO4+kiJOm870I=;
        b=tZ69nqxkDawlA1u8gt3ihzxxBAcC2+F7H17vTaCMfjuzIVNBDaamTeRfyzsHpqSE01
         5tA6k+AJjHgJ59NDd5wD4xQsJriBKdIr1RBgSZZVZ7rv3dO0kRIxsKoQsngj4Fwat6WZ
         QwlBp3pgOr0favwS4mTjmLAEai8en+PZYaEy75cXfXaWf23SVvNBLuwh1ACdv09x+twh
         CofeRg9sdEpvg3lQFU/ihI+AxhGiao5Z6xXq5m09vIPeWwoV0SKUDBSgGgh+iajPEvb+
         3a8AjZ4TOcQNvtozjmhHIm5K6xurqY0sMxUzMQFdIRNK5w6IZcW9xEya/TsNrKECXE0r
         8JEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AsxydOY+lNRb2e3ADR2di+F/3cNRDqMO4+kiJOm870I=;
        b=Ft+U96A//gO3iuOuR7nzDU34HcLrLfW317mDG/zZdvs4NqCT3Z10xKEtE+QzBwro45
         AdMhmV/HwjcBcqbwxwk6hGD96h7TqFKCNe08o1Kjgj1+mi0P1jBtPUbIAfoOwQNvjOsx
         1jVXEc4jp98z5RG5ECA2VU4uJiddNW0z3G18nfJf2cqv91H1I/rNMkojAjflt7iFfGcR
         092LhSfFGsgBRONgpEK1TI495tYZ2YA9exxvrIckh4KylWeAcC+3bViXqvb0V5aiDcJA
         t2m/5StG2oh3m2dqyA926CIie+m7JWxd5xv0UAZycQH7ncEf1whgoiNBIMx5VJEQQOyK
         1dQQ==
X-Gm-Message-State: AOAM532q1zMBa2q+aVLYCqdOM/xS4nGaa1QUIKNgTJVh3E2z/nx2Gz6g
        vOdIkZqksqj6Ou61RJUhXwlBOdQM4tg=
X-Google-Smtp-Source: ABdhPJxsJQdeKrhZ+Ic3q63tP5qLs7ofsmO1/XUKvgP+CxYmoumOQbCd6V+vaQsC3hbdAdAR2e1hug==
X-Received: by 2002:a17:90b:3810:: with SMTP id mq16mr68027pjb.129.1628820539472;
        Thu, 12 Aug 2021 19:08:59 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ca7sm102619pjb.11.2021.08.12.19.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 19:08:59 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 16/16] lpfc: Copyright updates for 14.0.0.1 patches
Date:   Thu, 12 Aug 2021 19:08:12 -0700
Message-Id: <20210813020812.99014-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813020812.99014-1-jsmart2021@gmail.com>
References: <20210813020812.99014-1-jsmart2021@gmail.com>
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

