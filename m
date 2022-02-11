Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D166C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 06:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346063AbiBKGsY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 01:48:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344334AbiBKGsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 01:48:22 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FC110FF
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 22:48:20 -0800 (PST)
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Jw3yT1FPtzdZfB;
        Fri, 11 Feb 2022 14:45:05 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Fri, 11 Feb 2022 14:48:18 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH 4/4] scsi: Remove unused member cmd_pool for structure scsi_host_template
Date:   Fri, 11 Feb 2022 14:42:58 +0800
Message-ID: <1644561778-183074-5-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
References: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

After the commit e9c787e65c0c ("scsi: allocate scsi_cmnd structures as
part of struct request"), the member cmd_pool in structure
scsi_host_template is not used, so remove it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 include/scsi/scsi_host.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 72e1a347baa6..667d889b92b5 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -16,7 +16,6 @@ struct completion;
 struct module;
 struct scsi_cmnd;
 struct scsi_device;
-struct scsi_host_cmd_pool;
 struct scsi_target;
 struct Scsi_Host;
 struct scsi_transport_template;
@@ -493,8 +492,6 @@ struct scsi_host_template {
 	 */
 	u64 vendor_id;
 
-	struct scsi_host_cmd_pool *cmd_pool;
-
 	/* Delay for runtime autosuspend */
 	int rpm_autosuspend_delay;
 };
-- 
2.33.0

