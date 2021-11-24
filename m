Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA389C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 00:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhKXA4G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:56:06 -0500
Received: from mail-pj1-f41.google.com ([209.85.216.41]:46797 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbhKXA4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 19:56:05 -0500
Received: by mail-pj1-f41.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so913294pjb.5
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 16:52:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iv1XeNcDXoHZ906hRTP3lSCQfXZfMWb9FlKnZa6cB8c=;
        b=b0xCbXkFPDvMEyIjBJXoum1nYjyK+0AYcMo6Ofi6rXVH7DU8bM06Qg6Z8ZJGMXp3JN
         mB0Lkf2IeCz7KcbxQxwi2m8ovH3aIqjWXRlRRBo4hFqOEYy0emlqT49T/ecZQ/QFWJ1j
         kQSXokSYILc0HEGyuf2k1LTTmh6KAN80aj/u8vRUgxLLF2DgxEyaKAAtK8FHEOqzuqFI
         4yGSqwtNN0vbOmBaz+OF/c5wlevIZMYmY6B5XUXMmpmXJGEHHdmoyHpZAnRO5h2rAn1i
         uBFbpuqEC8W1KTytWDlWB/khOOLCQKnZXqzWaZWQ9JCStRC0sl4FcnbaGl8CrLdvhOmg
         zmTQ==
X-Gm-Message-State: AOAM531xpLZ093yN1xS6LJJsGeObu4cCwNCws4YBxsdJT4HMa8hXSFan
        tMH9+U5uwDyt9fOiHqKN4aU3Sz67SiaKow==
X-Google-Smtp-Source: ABdhPJz1GZrqCwROxoOnfse4rJ/rJuHWHIrrMaoCGnTVfL6vVW6CoMgOacCSqa/apXxigff2bwtoiA==
X-Received: by 2002:a17:90b:4b86:: with SMTP id lr6mr2522125pjb.98.1637715176783;
        Tue, 23 Nov 2021 16:52:56 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id x33sm14210387pfh.133.2021.11.23.16.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 16:52:56 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Keoseong Park <keosung.park@samsung.com>
Subject: [PATCH 13/13] scsi: Remove superfluous #include <linux/async.h> directives
Date:   Tue, 23 Nov 2021 16:52:17 -0800
Message-Id: <20211124005217.2300458-14-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211124005217.2300458-1-bvanassche@acm.org>
References: <20211124005217.2300458-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove this include directive from code that does not use any
functionality from kernel/async.c.

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
