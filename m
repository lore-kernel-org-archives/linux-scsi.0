Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB134C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 19:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378207AbhK2TwF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 14:52:05 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:42718 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243752AbhK2TuE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 14:50:04 -0500
Received: by mail-pf1-f174.google.com with SMTP id u80so18025806pfc.9
        for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2021 11:46:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=raXhQaIAWBkFfxmbVFEMBS2txHLtjJxntwQvPLU0v/o=;
        b=AfzABir0KfuSIG4NM6cSrkr7JEpkTde4Dfe0fNS5KSn5+mUjqVJRBnYBlT833hcJZz
         zpbaG+bVYhLQPv+XPjmyKYEyssSYqms4TBun5POr0fNZqFYiBBIeodYxTYZ/V7gXTqb/
         IhY+uUx7ZZTe3SkRDtubpap1E2m2HOVUNrbK5Nn+MwyKN+dutJRTivrGFqMTm6qPQaAN
         W6kF6yX/tfbNVcAGfpU7tTEElkDk46o2Ieo/bSaVluU4P4B/NJC9NpL2qHYlDrWT+4Z1
         AwFavueAZQojUI+apyss0+X5f0EBZdAlKv8OTiP5mqNR4Z943Ax9mtV4j9Z7hhRE3dlQ
         rAHA==
X-Gm-Message-State: AOAM530zghMxTXlIpMMb9EQcj/YOw0fusq0NY+PC8KRNuOpZKNj2dxhf
        ZUPE7HLn5QVb0CabATtLuwKQX4W40fg=
X-Google-Smtp-Source: ABdhPJzwFze3iF82/k5ETikjMUHHU6wm83UZYca9IvCRZWwCjhJ6+MMq7v5xsmmCXud2og1k9/zGAw==
X-Received: by 2002:a63:3117:: with SMTP id x23mr37189323pgx.126.1638215206672;
        Mon, 29 Nov 2021 11:46:46 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a4a0:8cb5:fff:67db])
        by smtp.gmail.com with ESMTPSA id ns21sm141715pjb.37.2021.11.29.11.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 11:46:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH v2 12/12] scsi: Remove superfluous #include <linux/async.h> directives
Date:   Mon, 29 Nov 2021 11:46:09 -0800
Message-Id: <20211129194609.3466071-13-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211129194609.3466071-1-bvanassche@acm.org>
References: <20211129194609.3466071-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove this include directive from code that does not use any
functionality from kernel/async.c.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h   | 1 -
 drivers/scsi/libsas/sas_discover.c | 1 -
 drivers/scsi/scsi.c                | 1 -
 drivers/scsi/scsi_pm.c             | 1 -
 drivers/scsi/scsi_priv.h           | 1 -
 drivers/scsi/sd.c                  | 1 -
 drivers/scsi/ufs/ufshpb.c          | 1 -
 7 files changed, 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 2213a91923a5..ed9419643235 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -8,7 +8,6 @@
 #define _HISI_SAS_H_
 
 #include <linux/acpi.h>
-#include <linux/async.h>
 #include <linux/blk-mq.h>
 #include <linux/blk-mq-pci.h>
 #include <linux/clk.h>
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 12e1e36d7c04..758213694091 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -8,7 +8,6 @@
 
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
-#include <linux/async.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_eh.h>
 #include "sas_internal.h"
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index f6af1562cba4..dee4d9c6046d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -55,7 +55,6 @@
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
-#include <linux/async.h>
 #include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index b5a858c29488..0e841e8761c5 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -8,7 +8,6 @@
 
 #include <linux/pm_runtime.h>
 #include <linux/export.h>
-#include <linux/async.h>
 #include <linux/blk-pm.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 0f5743f4769b..5c4786310a31 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -3,7 +3,6 @@
 #define _SCSI_PRIV_H
 
 #include <linux/device.h>
-#include <linux/async.h>
 #include <scsi/scsi_device.h>
 #include <linux/sbitmap.h>
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 65875a598d62..2a50a840a00c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -51,7 +51,6 @@
 #include <linux/major.h>
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
-#include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/sed-opal.h>
 #include <linux/pm_runtime.h>
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 2e31e1413826..9778d4fd03cc 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -10,7 +10,6 @@
  */
 
 #include <asm/unaligned.h>
-#include <linux/async.h>
 
 #include "ufshcd.h"
 #include "ufshpb.h"
