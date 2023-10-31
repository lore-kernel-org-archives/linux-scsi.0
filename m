Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC408C4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:59:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbjJaS71 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbjJaS7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:59:25 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DC6ED
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:23 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6bb744262caso1633264b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778763; x=1699383563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EiRiYpRTXS+2WWemyWGygLIOM2rmQEI/Y7EUynmYac8=;
        b=c2k56UjnlF1VbR/6GA3Wrne0P8HuZV6Djm7Q8zwbgKJMqOuMes2R49d8Age/414aSD
         PeCsqraFBqzTVIEOjJsxkJj2GFSYnqaFNWt0sOWYsoDONcvMRxqhESPMDjVFqzKs8/Mx
         rEsaaep70/bVRhLzRRNRPScKoTlXgwmki9qbFfSjb+2FXvomC9hHvCHaUUBh5ROiTw44
         YQXd+vKYcSRrbrFEl9BR10ydvohfUKbVbzMVVy/Ab077vm8dFv+mfryr8EWmzcez/OUf
         dd4Y1ToqvaWMIWedniV9uEbO0J3Gg07d0lAioDn/bwZfem0tKT3nvwY6syleDMxlXTUm
         Nz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778763; x=1699383563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EiRiYpRTXS+2WWemyWGygLIOM2rmQEI/Y7EUynmYac8=;
        b=Q8G3rqiF/8W2croJJlyo5qEAhehTHlmd/4q76PyE5p9OtUJwfNojdNac1Iy8zCzmWD
         lu1gi6w32mQRvhdw1EPHEq01Q1cV6ung4hNRptF7jxYwkz+u1mDkR15z9ienUwS6+2ka
         E+yhkI0tPGbfczJj0Xqdit2n56XLS+1PV08XDtNdNWthXbjnRm2iIkVOz4sKsaPh/xoM
         W6/OKyGFKw+UTiM+XbfVXZ7PpAUurq6b3darzuq72ke63fgwH4XQ1JyiC5Dnun57d4tx
         RVG/SokX/egeS90NB38g3nGXRkna7+iaOAbPDKrcG6y4233fwt5RnFonDpUP9WTXBXO6
         12/Q==
X-Gm-Message-State: AOJu0YxRzImUbAHdiOKSlGU00CZc1kJZOpDXLw7LyDo1HrCtJW5YoZVT
        WzMGnqJ6Gi7uW9MrZYoM7JKkcvfMG8M=
X-Google-Smtp-Source: AGHT+IGRWNB7AUG9NewNZC6cMyigZR1cYoXB0LYa4TZHvYUtXWBn8gET3FukM88Qw9MLeMMXqAAxjw==
X-Received: by 2002:a05:6a20:d419:b0:171:737:dfaf with SMTP id il25-20020a056a20d41900b001710737dfafmr13355227pzb.5.1698778762747;
        Tue, 31 Oct 2023 11:59:22 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.59.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:59:22 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 9/9] lpfc: Copyright updates for 14.2.0.16 patches
Date:   Tue, 31 Oct 2023 12:12:24 -0700
Message-Id: <20231031191224.150862-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update copyrights to 2023 for files modified in the 14.2.0.16 patch set.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 2 +-
 drivers/scsi/lpfc/lpfc_mem.c  | 2 +-
 drivers/scsi/lpfc/lpfc_sli.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index b5ab44234f20..cadcd16494e1 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2016 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index ef6e5256a35e..2697da3248b3 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2017-2022 Broadcom. All Rights Reserved. The term *
+ * Copyright (C) 2017-2023 Broadcom. All Rights Reserved. The term *
  * “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.     *
  * Copyright (C) 2004-2014 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 14b8b5a3addf..c911a39cb46b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
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

