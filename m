Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC7EEC4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92F7561073
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbhHEES0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 00:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhHEES0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Aug 2021 00:18:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA10F60EE8;
        Thu,  5 Aug 2021 04:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628137092;
        bh=mB5MPS4/ftvIsrloxEwJS3TMsTJM3QZc0j0Jm9hQDTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ft/IvNgtM0BjaNgo8URgJEl9VK4qdiNqXXHbKxXc2OEo95uBzW+IO/BAgxGjDzsdp
         HFLR+Fzy/p/NrEkV2M3hCF8skWxinorua25+mbs6oKE71XNjVnkIxVhqF28zhBBBmG
         MD3E2nYng9lEAoPG3Oj1tc3FiucKaK/Z5xNbhInDCqQXnbsVLKoBlRpu3ponfCNyRQ
         JGeYBxgNyIZi7MfPRvF3F/RJ5q9kRAtaYAZp3QS+0qIgAI0FBTLaTvZL6MBVKNwpOz
         BqCdawVBLSuBqUsHtz4xEGRkF70spLCNj4/gDPa55hUpgAk3XnpCXeWlil+YammEtP
         qYLByuFGplkSA==
Date:   Wed, 4 Aug 2021 23:20:53 -0500
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
Subject: [PATCH v2 4/4][next] scsi: megaraid_sas: Replace one-element array
 with flexible-array member in MR_PD_CFG_SEQ_NUM_SYNC
Message-ID: <3860f4f6f06dff8e6aea4a8318e9515a0e9cbde3.1628136510.git.gustavoars@kernel.org>
References: <cover.1628136510.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1628136510.git.gustavoars@kernel.org>
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
Changes in v2:
 - None.

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
index 5fe2f7a6eebe..af39d9c20cc6 100644
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

