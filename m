Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0E7C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Nov 2022 07:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiKYHxI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 02:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiKYHxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 02:53:07 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAA12F661
        for <linux-scsi@vger.kernel.org>; Thu, 24 Nov 2022 23:53:06 -0800 (PST)
Received: from kwepemi500016.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NJRsj5gR3zHw8q;
        Fri, 25 Nov 2022 15:52:25 +0800 (CST)
Received: from huawei.com (10.175.100.227) by kwepemi500016.china.huawei.com
 (7.221.188.220) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 25 Nov
 2022 15:53:03 +0800
From:   Shang XiaoJing <shangxiaojing@huawei.com>
To:     <linuxdrivers@attotech.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <JBottomley@Parallels.com>,
        <linux-scsi@vger.kernel.org>
CC:     <shangxiaojing@huawei.com>
Subject: [PATCH] scsi: esas2r: Fix missing pci_disable_device() in esas2r_probe()
Date:   Fri, 25 Nov 2022 15:51:15 +0800
Message-ID: <20221125075115.27390-1-shangxiaojing@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.227]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500016.china.huawei.com (7.221.188.220)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add missing pci_disable_device() in fail path of scsi_host_alloc() and
scsi_add_host().

Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
---
 drivers/scsi/esas2r/esas2r_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7a4eadad23d7..9e06a6e2da48 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -388,6 +388,7 @@ static int esas2r_probe(struct pci_dev *pcid,
 	host = scsi_host_alloc(&driver_template, host_alloc_size);
 	if (host == NULL) {
 		esas2r_log(ESAS2R_LOG_CRIT, "scsi_host_alloc() FAIL");
+		pci_disable_device(pcid);
 		return -ENODEV;
 	}
 
@@ -459,6 +460,7 @@ static int esas2r_probe(struct pci_dev *pcid,
 			       pcid);
 
 		pci_set_drvdata(pcid, NULL);
+		pci_disable_device(pcid);
 
 		return -ENODEV;
 	}
-- 
2.17.1

