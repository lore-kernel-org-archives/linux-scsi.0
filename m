Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7065FC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 11:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiGSLLN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 07:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbiGSLLM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 07:11:12 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5022FFC8;
        Tue, 19 Jul 2022 04:11:11 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPS id B435F40D4004;
        Tue, 19 Jul 2022 11:11:09 +0000 (UTC)
From:   Andrey Strachuk <strochuk@ispras.ru>
To:     Sathya Prakash <sathya.prakash@broadcom.com>
Cc:     Andrey Strachuk <strochuk@ispras.ru>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] scsi: mpt3sas: remove useless comparisons in _base_get_chain_buffer_dma_to_chain_buffer(), _base_release_memory_pools()
Date:   Tue, 19 Jul 2022 14:11:04 +0300
Message-Id: <20220719111104.7554-1-strochuk@ispras.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Local variable 'ct' is initialized by an address
of field of MPT3SAS_ADAPTER structure, so it does
not make sense to compare 'ct' with NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Andrey Strachuk <strochuk@ispras.ru>
Fixes: 93204b782a88 ("scsi: mpt3sas: Lockless access for chain buffers.")
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 9a1ae52bb621..dead0f7d4d9e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -396,7 +396,7 @@ _base_get_chain_buffer_dma_to_chain_buffer(struct MPT3SAS_ADAPTER *ioc,
 	for (index = 0; index < ioc->scsiio_depth; index++) {
 		for (j = 0; j < ioc->chains_needed_per_io; j++) {
 			ct = &ioc->chain_lookup[index].chains_per_smid[j];
-			if (ct && ct->chain_buffer_dma == chain_buffer_dma)
+			if (ct->chain_buffer_dma == chain_buffer_dma)
 				return ct->chain_buffer;
 		}
 	}
@@ -5699,7 +5699,7 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			for (j = ioc->chains_per_prp_buffer;
 			    j < ioc->chains_needed_per_io; j++) {
 				ct = &ioc->chain_lookup[i].chains_per_smid[j];
-				if (ct && ct->chain_buffer)
+				if (ct->chain_buffer)
 					dma_pool_free(ioc->chain_dma_pool,
 						ct->chain_buffer,
 						ct->chain_buffer_dma);
-- 
2.25.1

