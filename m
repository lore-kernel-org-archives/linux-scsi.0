Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E781FC4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 03:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCBBF60F58
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 03:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238613AbhHED73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 23:59:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhHED73 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Aug 2021 23:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C72F260F0F;
        Thu,  5 Aug 2021 03:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628135955;
        bh=+CmUqoyIYshFvS7sAel7Bg5ZiyKxXU1G+HgxdE/n+T8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lg9VMFGOMrTBu1g1ssM1/0ANqCDT5VlgZWo42yBfJywDSbhN1waW+Z9N9dknh113g
         9Tjrverb5CJmFdtz300hnXxR+TrpXMvjL76JqX51q+XFdGo/w8bInYc4+f+TvN7Y7c
         7dck0+jOSy3v0KcZCZozHKzSdZBod6HVoe3r0q5In1q6EbSTRuyW9W8VtFV47OBLoK
         /hWVhrbcBS/XZCZcvRgvu4sTkZhfRohK3S68Qwo6q8KQ5WgsTSTuqX8NlQJS6oVA0v
         RhJt6CK4AVdTn6XjElK6XxifDkv3vPCm1CEFvhi7wAHB7lnsLT3BcQHyQuhzVW/Sn4
         NC9rXRoRrdsSg==
Date:   Wed, 4 Aug 2021 23:01:56 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 4/4][next] scsi: megaraid_sas: Replace one-element array with
 flexible-array member in MR_PD_CFG_SEQ_NUM_SYNC
Message-ID: <97d9c7fd288a11a919a0b8e6cbd7f0378d51c117.1628135423.git.gustavoars@kernel.org>
References: <cover.1628135423.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1628135423.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with a flexible-array member in struct
MR_PD_CFG_SEQ_NUM_SYNC and use the struct_size() helper.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://en.wikipedia.org/wiki/Flexible_array_member
Link: https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 14 +++++++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d072f9caeb4a..a4131dd510e3 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5782,10 +5782,10 @@ megasas_setup_jbod_map(struct megasas_instance *instance)
 {
 	int i;
 	struct fusion_context *fusion = instance->ctrl_context;
-	u32 pd_seq_map_sz;
+	size_t pd_seq_map_sz;
 
-	pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
-		(sizeof(struct MR_PD_CFG_SEQ) * (MAX_PHYSICAL_DEVICES - 1));
+	pd_seq_map_sz = struct_size((struct MR_PD_CFG_SEQ_NUM_SYNC *)0, seq,
+				    MAX_PHYSICAL_DEVICES);
 
 	instance->use_seqnum_jbod_fp =
 		instance->support_seqnum_jbod_fp;
@@ -7961,7 +7961,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	struct fusion_context *fusion;
-	u32 pd_seq_map_sz;
+	size_t pd_seq_map_sz;
 
 	instance = pci_get_drvdata(pdev);
 
@@ -8033,9 +8033,9 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 	if (instance->adapter_type != MFI_SERIES) {
 		megasas_release_fusion(instance);
-			pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
-				(sizeof(struct MR_PD_CFG_SEQ) *
-					(MAX_PHYSICAL_DEVICES - 1));
+			pd_seq_map_sz =
+				struct_size((struct MR_PD_CFG_SEQ_NUM_SYNC *)0,
+					    seq, MAX_PHYSICAL_DEVICES);
 		for (i = 0; i < 2 ; i++) {
 			if (fusion->ld_map[i])
 				dma_free_coherent(&instance->pdev->dev,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 06399c026a8d..a824fb641fda 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1310,7 +1310,7 @@ megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
 
 	pd_sync = (void *)fusion->pd_seq_sync[(instance->pd_seq_map_id & 1)];
 	pd_seq_h = fusion->pd_seq_phys[(instance->pd_seq_map_id & 1)];
-	pd_seq_map_sz = struct_size(pd_sync, seq, MAX_PHYSICAL_DEVICES - 1);
+	pd_seq_map_sz = struct_size(pd_sync, seq, MAX_PHYSICAL_DEVICES);
 
 	cmd = megasas_get_cmd(instance);
 	if (!cmd) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index d60137eb519c..b4084c6f5c0c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1249,7 +1249,7 @@ struct MR_PD_CFG_SEQ {
 struct MR_PD_CFG_SEQ_NUM_SYNC {
 	__le32 size;
 	__le32 count;
-	struct MR_PD_CFG_SEQ seq[1];
+	struct MR_PD_CFG_SEQ seq[];
 } __packed;
 
 /* stream detection */
-- 
2.27.0

