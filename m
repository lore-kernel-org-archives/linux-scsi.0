Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB11DC32771
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B401622527
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qNjPLNNa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgA1AXs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:48 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50261 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA1AXs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:48 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so631268wmb.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bxd8CGDlLjbttsrGbtMv3GSBY7Mjac1INhfQBPVa4NY=;
        b=qNjPLNNa1sBscRFeO7KlS//QRylTa4s9vP+lq3rHcQFV98emElO9vYe9F6W7kUp0j+
         DVDX0MeFBQNELoKGtUEyHz+Qc9cVsn/nChztnRVg/PduhzsPQwcd9zUhEYVF0sa8/tAE
         6qwYbVZFVA4JC12Fbq/GYM0GssBdVATlQeeJagfZKr1M2UdU5HAv08qxLAXcCb1ON0jr
         yfV43HFgn2Fmyk2oOkc/3TEF3m2pPxIgfNfv1Wn/YKy2W+HE23WoR6BMPbZWrvxDKy+l
         gts2mTrclS1ka6y6zwosVnUDhpSlx7OsNeymHJNNUqgNgntEDnxD/HaSsmotOJ2aA2hL
         Bkug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bxd8CGDlLjbttsrGbtMv3GSBY7Mjac1INhfQBPVa4NY=;
        b=JGTVVz8PZvsbeZoRStrql1xChQ6ndt+9Tul9yWjLsOGh41Ouu2d6K226Svb9soEbn8
         3MazZ3wS5C8cXqvxQ5Inkmkicb4+Z5XJX0D2H54yz3APQrmm7MhDJuZJbGboRmgLYki+
         xyf57z1XizctfTblF90xDK8GvEjtJJEdLxrmqSE5eRi084FmV+s9t2q8xM7GbpyGmX6n
         Y9UIq4lO9KTRy9zh1BeYV7uQT+kK+sIwlYn8XzRg0TSz7a/TVx/OyAaKlB2ic1e2xl9g
         8W/76NIaX+ehqGhHhR9XX+hRGGDs71A5SePazexQTsPxmMjJkPhjHRFcmuhhFKOYOO5V
         GCig==
X-Gm-Message-State: APjAAAUU9Ascj/EUdeuA9JqFFVMfiJXgcRHPE0D5Gs9NX7VhARCx8qBC
        5T7ZN1NmNFpB+tV22Hqso6CfcrSA
X-Google-Smtp-Source: APXvYqwCCrUfXqm5im2Bv41j9MnPym7KPpsOOrpPfMm6zBMfZgHASbzsXOc3jhsFMCx5431Aj3xiZw==
X-Received: by 2002:a1c:dcd5:: with SMTP id t204mr1267803wmg.34.1580171025469;
        Mon, 27 Jan 2020 16:23:45 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:45 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 12/12] lpfc: Copyright updates for 12.6.0.4 patches
Date:   Mon, 27 Jan 2020 16:23:12 -0800
Message-Id: <20200128002312.16346-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2020 for files modified in the 12.6.0.4 patch set.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         | 2 +-
 drivers/scsi/lpfc/lpfc_attr.c    | 2 +-
 drivers/scsi/lpfc/lpfc_ct.c      | 2 +-
 drivers/scsi/lpfc/lpfc_els.c     | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 drivers/scsi/lpfc/lpfc_hw.h      | 2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 2 +-
 drivers/scsi/lpfc/lpfc_scsi.c    | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c     | 2 +-
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index d26ae94e6f1e..3d985581b470 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 127484061f18..b6224487909e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 8db27e84263e..2aa578d20f8c 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 371599d67eb4..8a38e6f7f853 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6a2bdae0e52a..e8937071c748 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 9a5979075646..68f62ae6ef4f 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2018 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6d571e0b74f0..9d03e9b71efb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 96ac4a154c58..0fc9a242bc65 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a5fd043e9be4..86ac10ecd65a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.  *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 25193146ef20..c4ab006e6ecc 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2019 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2020 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
-- 
2.13.7

