Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 935DFC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 14:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6788761355
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 14:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347956AbhESOgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 10:36:55 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4537 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346231AbhESOgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 10:36:54 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Flb1n4ds4zsScl;
        Wed, 19 May 2021 22:32:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 22:35:31 +0800
Received: from localhost.localdomain (10.69.192.58) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 15:35:27 +0100
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: core: Cap shost cmd_per_lun at can_queue
Date:   Wed, 19 May 2021 22:31:02 +0800
Message-ID: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
exceed Shost.can_queue.

The sdev initial value comes from shost cmd_per_lun.

However, the LLDD may still set cmd_per_lun > can_queue, which leads to an
initial sdev queue depth greater than can_queue.

Such an issue was reported in [0], which caused a hang. That has since
been fixed in commit fc09acb7de31 ("scsi: scsi_debug: Fix cmd_per_lun,
set to max_queue").

Stop this possibly happening for other drivers by capping
shost.cmd_per_lun at shost.can_queue.

[0] https://lore.kernel.org/linux-scsi/YHaez6iN2HHYxYOh@T590/

Signed-off-by: John Garry <john.garry@huawei.com>
---
Earlier patch was in https://lore.kernel.org/linux-scsi/1618848384-204144-1-git-send-email-john.garry@huawei.com/

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ba72bd4202a2..624e2582c3df 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -220,6 +220,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 	}
 
+	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
+				   shost->can_queue);
+
 	error = scsi_init_sense_cache(shost);
 	if (error)
 		goto fail;
-- 
2.26.2

