Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B886FC54FCC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 03:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A31112084D
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 03:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgDUDlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 23:41:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2814 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728083AbgDUDlm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 23:41:42 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0D6158AD129CC593E86E;
        Tue, 21 Apr 2020 11:41:41 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Apr 2020
 11:41:31 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <sathya.prakash@broadcom.com>, <chaitra.basappa@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <sreekanth.reddy@broadcom.com>,
        <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: mpt3sas: use true,false for bool variables
Date:   Tue, 21 Apr 2020 11:41:01 +0800
Message-ID: <20200421034101.28273-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

drivers/scsi/mpt3sas/mpt3sas_base.c:416:6-14: WARNING: Assignment of 0/1
to bool variable
drivers/scsi/mpt3sas/mpt3sas_base.c:485:2-10: WARNING: Assignment of 0/1
to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 06285b03fa00..4544ba4bf47d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -413,7 +413,7 @@ static void _clone_sg_entries(struct MPT3SAS_ADAPTER *ioc,
 {
 	Mpi2SGESimple32_t *sgel, *sgel_next;
 	u32  sgl_flags, sge_chain_count = 0;
-	bool is_write = 0;
+	bool is_write = false;
 	u16 i = 0;
 	void __iomem *buffer_iomem;
 	phys_addr_t buffer_iomem_phys;
@@ -482,7 +482,7 @@ static void _clone_sg_entries(struct MPT3SAS_ADAPTER *ioc,
 
 	if (le32_to_cpu(sgel->FlagsLength) &
 			(MPI2_SGE_FLAGS_HOST_TO_IOC << MPI2_SGE_FLAGS_SHIFT))
-		is_write = 1;
+		is_write = true;
 
 	for (i = 0; i < MPT_MIN_PHYS_SEGMENTS + ioc->facts.MaxChainDepth; i++) {
 
-- 
2.21.1

