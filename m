Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07652C433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 08:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C49F461A23
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 08:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCYIhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Mar 2021 04:37:48 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14472 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhCYIh2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Mar 2021 04:37:28 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F5dhv0zyZzwQmF;
        Thu, 25 Mar 2021 16:35:27 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 16:37:19 +0800
From:   Yufen Yu <yuyufen@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <yuyufen@huawei.com>
Subject: [RFC PATCH] scsi: megaraid_sas: set msix index for NON_READ_WRITE_LDIO type cmd
Date:   Thu, 25 Mar 2021 04:42:47 -0400
Message-ID: <20210325084247.4136519-1-yuyufen@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before commit 132147d7f620 ("scsi: megaraid_sas: Add support for
High IOPS queues"), all interrupt of megaraid_sas is managed when
smp_affinity_enable for misx_enable. The mapping between vectors and
cpus for a 128 vectors likely:
    vector0 maps to cpu0
    vector1 maps to cpu1
    ...
If cpu0 is offline, vector0 cannot handle any io.

For now, we have not pointed msix index in megasas_build_ld_nonrw_fusion().
The default value of index is '0'. So, cmd like TEST_UNIT_READY will hung
forever after cpu0 offline. We can simplely reproduce by:

    echo 0 > /sys/devices/system/cpu/cpu0/online
    sg_turs /dev/sda # hung

After commit 132147d7f620, low_latency_index_start is set as 1 (not sure
for all scenario), then vector 0 is not managed. Thus, io issue to vector0
can be handled by other cpus after cpu0 offline.

Nevertheless, we may also conside to set msix index rather than default 0
in megasas_build_ld_nonrw_fusion().

Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 38fc9467c625..ddc6176f12c4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -3021,6 +3021,8 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
 		io_request->DevHandle = devHandle;
 	}
+
+	megasas_get_msix_index(instance, scmd, cmd, 1);
 }
 
 /**
-- 
2.25.4

