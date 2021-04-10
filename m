Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1CAC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2E66611AE
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhDJGsO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 02:48:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16882 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbhDJGsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 02:48:09 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FHQWJ5wYMzkhsK;
        Sat, 10 Apr 2021 14:46:04 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Sat, 10 Apr 2021
 14:47:45 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <luojiaxing@huawei.com>
Subject: [PATCH v1 8/8] scsi: megaraid: clean up for static variable initialise to 0
Date:   Sat, 10 Apr 2021 14:48:07 +0800
Message-ID: <1618037287-460-9-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
References: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Following error is reported by checkpatch.pl:

ERROR: do not initialise statics to 0
+static int megaraid_expose_unconf_disks = 0;

So fix them.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 486c01d..0f8fcbf 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -146,7 +146,7 @@ MODULE_VERSION(MEGARAID_VERSION);
 /*
  * Set to enable driver to expose unconfigured disk to kernel
  */
-static int megaraid_expose_unconf_disks = 0;
+static int megaraid_expose_unconf_disks;
 module_param_named(unconf_disks, megaraid_expose_unconf_disks, int, 0);
 MODULE_PARM_DESC(unconf_disks,
 	"Set to expose unconfigured disks to kernel (default=0)");
@@ -181,7 +181,7 @@ MODULE_PARM_DESC(cmd_per_lun,
  * This would result in non-disk devices being skipped during driver load
  * time. These can be later added though, using /proc/scsi/scsi
  */
-static unsigned int megaraid_fast_load = 0;
+static unsigned int megaraid_fast_load;
 module_param_named(fast_load, megaraid_fast_load, int, 0);
 MODULE_PARM_DESC(fast_load,
 	"Faster loading of the driver, skips physical devices! (default=0)");
-- 
2.7.4

