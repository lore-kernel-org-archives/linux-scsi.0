Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B11C001DE
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Jul 2023 10:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjGWKXo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Jul 2023 06:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjGWKX0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2023 06:23:26 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF14018C;
        Sun, 23 Jul 2023 03:22:58 -0700 (PDT)
Received: from kwepemm600012.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4R7zmx60ZTztRQR;
        Sun, 23 Jul 2023 18:19:45 +0800 (CST)
Received: from build.huawei.com (10.175.101.6) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Sun, 23 Jul 2023 18:22:56 +0800
From:   Wenchao Hao <haowenchao2@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Dan Carpenter <error27@gmail.com>, <louhongxiang@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH 03/13] scsi:scsi_error: Check if to do reset in scsi_try_xxx_reset
Date:   Mon, 24 Jul 2023 07:44:12 +0800
Message-ID: <20230723234422.1629194-4-haowenchao2@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230723234422.1629194-1-haowenchao2@huawei.com>
References: <20230723234422.1629194-1-haowenchao2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600012.china.huawei.com (7.193.23.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is preparation for a genernal LUN/target based error handle
strategy, the strategy would reuse some origin error handler APIs,
but some steps of these function should not be performed. For
example, we should not perform target reset if we just stop IOs
on one single LUN.

This change add checks in scsi_try_xxx_reset to make sure
the reset operations would not be performed only if the condition
is not satisfied.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_error.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 879fdd7c165b..d80492366527 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -930,6 +930,9 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 	struct Scsi_Host *host = scmd->device->host;
 	const struct scsi_host_template *hostt = host->hostt;
 
+	if (!scsi_host_in_recovery(host))
+		return FAILED;
+
 	SCSI_LOG_ERROR_RECOVERY(3,
 		shost_printk(KERN_INFO, host, "Snd Host RST\n"));
 
@@ -960,6 +963,9 @@ static enum scsi_disposition scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	struct Scsi_Host *host = scmd->device->host;
 	const struct scsi_host_template *hostt = host->hostt;
 
+	if (!scsi_host_in_recovery(host))
+		return FAILED;
+
 	SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
 		"%s: Snd Bus RST\n", __func__));
 
@@ -1001,6 +1007,10 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 	enum scsi_disposition rtn;
 	struct Scsi_Host *host = scmd->device->host;
 	const struct scsi_host_template *hostt = host->hostt;
+	struct scsi_target *starget = scsi_target(scmd->device);
+
+	if (!(scsi_target_in_recovery(starget) || scsi_host_in_recovery(host)))
+		return FAILED;
 
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
@@ -1008,7 +1018,7 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 	rtn = hostt->eh_target_reset_handler(scmd);
 	if (rtn == SUCCESS) {
 		spin_lock_irqsave(host->host_lock, flags);
-		__starget_for_each_device(scsi_target(scmd->device), NULL,
+		__starget_for_each_device(starget, NULL,
 					  __scsi_report_device_reset);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
-- 
2.35.3

