Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6DBEC07E95
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 07:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CECA6613E9
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 07:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhGPHkl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 03:40:41 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:15026 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236342AbhGPHkk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 03:40:40 -0400
Received: from dggeml756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GR30J3ZP7zZqW3;
        Fri, 16 Jul 2021 15:34:24 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggeml756-chm.china.huawei.com
 (10.1.199.158) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 16
 Jul 2021 15:37:42 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: libsas: allow libsas include scsi header files directly
Date:   Fri, 16 Jul 2021 15:45:51 +0800
Message-ID: <20210716074551.771312-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml756-chm.china.huawei.com (10.1.199.158)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

libsas needs to include some header files in the scsi directory. However
they are now hardcoded with the path "../" in the C files. Let's do this
in the Makefile to avoid the hardcode.

Cc: John Garry <john.garry@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/Makefile        | 2 +-
 drivers/scsi/libsas/sas_ata.c       | 4 ++--
 drivers/scsi/libsas/sas_discover.c  | 2 +-
 drivers/scsi/libsas/sas_expander.c  | 2 +-
 drivers/scsi/libsas/sas_host_smp.c  | 2 +-
 drivers/scsi/libsas/sas_init.c      | 2 +-
 drivers/scsi/libsas/sas_phy.c       | 2 +-
 drivers/scsi/libsas/sas_port.c      | 2 +-
 drivers/scsi/libsas/sas_scsi_host.c | 6 +++---
 9 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
index e63a54f5ab8c..9dc32736cf21 100644
--- a/drivers/scsi/libsas/Makefile
+++ b/drivers/scsi/libsas/Makefile
@@ -18,4 +18,4 @@ libsas-y +=  sas_init.o     \
 libsas-$(CONFIG_SCSI_SAS_ATA) +=	sas_ata.o
 libsas-$(CONFIG_SCSI_SAS_HOST_SMP) +=	sas_host_smp.o
 
-ccflags-y := -DDEBUG
+ccflags-y := -DDEBUG -I$(srctree)/drivers/scsi
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 4aa1fda95f35..1e0df6b17227 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -20,8 +20,8 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
-#include "../scsi_sas_internal.h"
-#include "../scsi_transport_api.h"
+#include "scsi_sas_internal.h"
+#include "scsi_transport_api.h"
 #include <scsi/scsi_eh.h>
 
 static enum ata_completion_errors sas_to_ata_err(struct task_status_struct *ts)
diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index dd205414e505..12e1e36d7c04 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -16,7 +16,7 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 #include <scsi/sas_ata.h>
-#include "../scsi_sas_internal.h"
+#include "scsi_sas_internal.h"
 
 /* ---------- Basic task processing for discovery purposes ---------- */
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index e00688540219..c2150a818423 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -18,7 +18,7 @@
 #include <scsi/sas_ata.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
-#include "../scsi_sas_internal.h"
+#include "scsi_sas_internal.h"
 
 static int sas_discover_expander(struct domain_device *dev);
 static int sas_configure_routing(struct domain_device *dev, u8 *sas_addr);
diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index eca2a6bf3601..32cdc969b736 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -14,7 +14,7 @@
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
-#include "../scsi_sas_internal.h"
+#include "scsi_sas_internal.h"
 
 static void sas_host_smp_discover(struct sas_ha_struct *sas_ha, u8 *resp_data,
 				  u8 phy_id)
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 2b0f98ca6ec3..80592f53017a 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -19,7 +19,7 @@
 
 #include "sas_internal.h"
 
-#include "../scsi_sas_internal.h"
+#include "scsi_sas_internal.h"
 
 static struct kmem_cache *sas_task_cache;
 static struct kmem_cache *sas_event_cache;
diff --git a/drivers/scsi/libsas/sas_phy.c b/drivers/scsi/libsas/sas_phy.c
index 4ca4b1f30bd0..a0d592d11dfb 100644
--- a/drivers/scsi/libsas/sas_phy.c
+++ b/drivers/scsi/libsas/sas_phy.c
@@ -10,7 +10,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
-#include "../scsi_sas_internal.h"
+#include "scsi_sas_internal.h"
 
 /* ---------- Phy events ---------- */
 
diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
index e3d03d744713..67b429dcf1ff 100644
--- a/drivers/scsi/libsas/sas_port.c
+++ b/drivers/scsi/libsas/sas_port.c
@@ -10,7 +10,7 @@
 
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
-#include "../scsi_sas_internal.h"
+#include "scsi_sas_internal.h"
 
 static bool phy_is_wideport_member(struct asd_sas_port *port, struct asd_sas_phy *phy)
 {
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index ee44a0d7730b..5db10248f187 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -22,9 +22,9 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 #include <scsi/sas_ata.h>
-#include "../scsi_sas_internal.h"
-#include "../scsi_transport_api.h"
-#include "../scsi_priv.h"
+#include "scsi_sas_internal.h"
+#include "scsi_transport_api.h"
+#include "scsi_priv.h"
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
-- 
2.31.1

