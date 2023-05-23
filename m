Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 659B2C7EE2D
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbjEWSWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236973AbjEWSWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:42 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D6C91
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:36 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-52888681eebso355380a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866155; x=1687458155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ropAzCCllF6eKn5RRkEiwcllPoz4AYCNGAvsxRzmgNo=;
        b=pr2BMLJx2dk//Y41xCP0BMf7QppPKFfOz0oYD/BONcTEIFNJQPpM/TBnMdv4h/H7Ri
         zVDilcduKQxee90A7EDNPH0iyfOG1aJhcotOsnoXUqMKR2N/JNrYTKjUIaPVdzYTug/U
         e+Rpg9xDEfSjtplWqdBJhmmcYfcmAbSSpANjG9uQCSKOQrWOKWS5LIrhETGnxnQeUfBV
         G6uUrIKt+Dgnt/xJi5E+XZI6xPv5KP/Mi04gmAB/kJN3dfnsSoSTTygqqQitULIYOFyF
         UMunSI9ri5Aavj6wZhc6PQwNB17QKU0SNLO3t7fS2+mC2p14DGQjU5958LhWZa5tEl6C
         9nsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866155; x=1687458155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ropAzCCllF6eKn5RRkEiwcllPoz4AYCNGAvsxRzmgNo=;
        b=Kn0JdhNOwjihitNkjI0zftUt7OBUiC7ZSJyg0s+3hg/hlSAif7xdXMsJRkprfNiaKX
         PnmKW7HFaWLHiwcjA3SVBgDomVduYHQgbrAhEovPyB+kkOmZyXZ5bdCIujPs/MfozNv2
         Y0B0WTi6xvMEZtTgI/gV1kcukEGkk8skBqzpIY5VUjR/3E+IqFqHd0++7Z3Dl4umOmAU
         SJv5+3fGVjubojKCmK7DfrBSXHCJNwQdD6psOHEFOIWKGZ2eFO50etofjfyT12ea5z8O
         Sw49LHWV3EjosGwfTo/U20U9MRxfYWdtVU3l6YDEyLdSJF+hZ8gfzZ2hMQE/6BlbtnGx
         Q7gg==
X-Gm-Message-State: AC+VfDxknlFjiM/pdGkybRwcfferZRyGB/Alar260TseKQ2+wlvRynAo
        ng14mQqlH9Bo7sJ38bkZRuvyUfLhKRA=
X-Google-Smtp-Source: ACHHUZ7GJOiUttIQo/XV43yc0BMVrueng/pQSi6b4oJQKEFMIu84cldCKSSTvPIaRs1CZ2OJeQW4dQ==
X-Received: by 2002:a17:902:ec8a:b0:1a9:6467:aa8d with SMTP id x10-20020a170902ec8a00b001a96467aa8dmr16183875plg.1.1684866155358;
        Tue, 23 May 2023 11:22:35 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:35 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 9/9] lpfc: Copyright updates for 14.2.0.13 patches
Date:   Tue, 23 May 2023 11:32:06 -0700
Message-Id: <20230523183206.7728-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230523183206.7728-1-justintee8345@gmail.com>
References: <20230523183206.7728-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2023 for files modified in the 14.2.0.13 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_logmsg.h | 2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_logmsg.h b/drivers/scsi/lpfc/lpfc_logmsg.h
index 324b865db0e1..f896ec610433 100644
--- a/drivers/scsi/lpfc/lpfc_logmsg.h
+++ b/drivers/scsi/lpfc/lpfc_logmsg.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index ce201465dc6f..dff4584d338b 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.38.0

