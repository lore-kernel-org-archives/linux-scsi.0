Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3E39C64E69
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 04:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 845C420870
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 04:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgKXEgN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:36:13 -0500
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:33448 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729090AbgKXEgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 23:36:12 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 7BB35181D3025;
        Tue, 24 Nov 2020 04:36:11 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: month31_550b9d52736b
X-Filterd-Recvd-Size: 2517
Received: from joe-laptop.perches.com (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Tue, 24 Nov 2020 04:36:10 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     kernel test robot <lkp@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: pm8001: Fix misindentation
Date:   Mon, 23 Nov 2020 20:36:04 -0800
Message-Id: <9542a8be9954c1dca744f93f53bb1af6dd1436e8.1606192458.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <cover.1606192458.git.joe@perches.com>
References: <cover.1606192458.git.joe@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

kernel robot reported a misindentation of a goto.

Fix it.

At the same time, use a temporary for a repeated entry in the same block
to reduce visual noise.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 38907f45c845..17b29163c13d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -386,17 +386,17 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 	pm8001_ha->memoryMap.region[FORENSIC_MEM].element_size = 0x10000;
 	pm8001_ha->memoryMap.region[FORENSIC_MEM].alignment = 0x10000;
 	for (i = 0; i < pm8001_ha->max_memcnt; i++) {
+		struct mpi_mem *region = &pm8001_ha->memoryMap.region[i];
+
 		if (pm8001_mem_alloc(pm8001_ha->pdev,
-			&pm8001_ha->memoryMap.region[i].virt_ptr,
-			&pm8001_ha->memoryMap.region[i].phys_addr,
-			&pm8001_ha->memoryMap.region[i].phys_addr_hi,
-			&pm8001_ha->memoryMap.region[i].phys_addr_lo,
-			pm8001_ha->memoryMap.region[i].total_len,
-			pm8001_ha->memoryMap.region[i].alignment) != 0) {
-			pm8001_dbg(pm8001_ha, FAIL,
-				   "Mem%d alloc failed\n",
-				   i);
-				goto err_out;
+				     &region->virt_ptr,
+				     &region->phys_addr,
+				     &region->phys_addr_hi,
+				     &region->phys_addr_lo,
+				     region->total_len,
+				     region->alignment) != 0) {
+			pm8001_dbg(pm8001_ha, FAIL, "Mem%d alloc failed\n", i);
+			goto err_out;
 		}
 	}
 
-- 
2.26.0

