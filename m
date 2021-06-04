Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8803EC4708F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 07:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5840361415
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 07:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhFDHLq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 03:11:46 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4468 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhFDHLq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 03:11:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxDNJ2lh2zZcPQ;
        Fri,  4 Jun 2021 15:07:12 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 15:09:58 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 4 Jun 2021
 15:09:58 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
Subject: [PATCH -next v2] scsi: mpi3mr: Make some symbols static
Date:   Fri, 4 Jun 2021 15:14:07 +0800
Message-ID: <20210604071407.1360742-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following warnings:

  drivers/scsi/mpi3mr/mpi3mr_os.c:24:5: warning: symbol 'prot_mask' was not declared. Should it be static?
  drivers/scsi/mpi3mr/mpi3mr_os.c:28:5: warning: symbol 'prot_guard_mask' was not declared. Should it be static?
  drivers/scsi/mpi3mr/mpi3mr_os.c:31:5: warning: symbol 'logging_level' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  move extern int prot_mask to mpi3mr.h
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 1 -
 drivers/scsi/mpi3mr/mpi3mr_os.c | 4 ++--
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 5d5529167350..6f5dc9e78553 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -50,6 +50,7 @@
 /* Global list and lock for storing multiple adapters managed by the driver */
 extern spinlock_t mrioc_list_lock;
 extern struct list_head mrioc_list;
+extern int prot_mask;
 
 #define MPI3MR_DRIVER_VERSION	"00.255.45.01"
 #define MPI3MR_DRIVER_RELDATE	"12-December-2020"
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 8aea1c2ae712..4a007cf54ad7 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -9,7 +9,6 @@
 
 #include "mpi3mr.h"
 #include <linux/io-64-nonatomic-lo-hi.h>
-extern int prot_mask;
 
 #if defined(writeq) && defined(CONFIG_64BIT)
 static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index a54aa009ec5a..eec0b269a4db 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -25,10 +25,10 @@ int prot_mask = -1;
 module_param(prot_mask, int, 0);
 MODULE_PARM_DESC(prot_mask, "Host protection capabilities mask, def=0x07");
 
-int prot_guard_mask = 3;
+static int prot_guard_mask = 3;
 module_param(prot_guard_mask, int, 0);
 MODULE_PARM_DESC(prot_guard_mask, " Host protection guard mask, def=3");
-int logging_level;
+static int logging_level;
 module_param(logging_level, int, 0);
 MODULE_PARM_DESC(logging_level,
 	" bits for enabling additional logging info (default=0)");
-- 
2.25.1

