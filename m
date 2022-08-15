Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA83C25B0D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 01:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiHPB7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 21:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbiHPB7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 21:59:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B7610777F;
        Mon, 15 Aug 2022 14:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9558361035;
        Mon, 15 Aug 2022 21:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D74C433C1;
        Mon, 15 Aug 2022 21:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660600360;
        bh=v73qbvSX6GJicRQwVqQQUy2yDqvcefvj35hzxha3Ko8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CwddLgwnQwPWoZWTgO8y6rBBleH3lFDakZmISIh2bidn8E4Ny/XWI1/bDLMrJ/WMS
         +8a554SFqvUvUtpFJgB/83fpwbH3mxzJe2ZUq5ftR+lo+awqDKgHKvgayEbki4M47U
         ntJ6FslzTlKfJzlGVfj72kcKwQCysBJiEssyIMKPoM2c79YNMMQbL/meXlADO+QvFn
         0SJK8EKesa+bxvnOTXj1zQDm7bzB8CubK/5YhzaWABzIV9x84KkZUBuHelPvBAyxDE
         pjnxwBmU3FFcUB0ZJja0vV72vrCrTWSZVFg6PkcjkhHITZ2UsQGtLQnF3fR/Gw7W0h
         DVBH/lkRsfBjg==
Date:   Mon, 15 Aug 2022 16:52:33 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v3 6/6] scsi: megaraid_sas: Use struct_size() in code related
 to struct MR_PD_CFG_SEQ_NUM_SYNC
Message-ID: <b215f4760f0e8fbe5fc35be20f2487e89924424d.1660592640.git.gustavoars@kernel.org>
References: <cover.1660592640.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1660592640.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prefer struct_size() over open-coded versions of idiom:

        sizeof(struct-with-flex-array) + sizeof(type-of-flex-array) * count

where count is the max number of items the flexible array is supposed to
have.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - This patch is new in the series.

 drivers/scsi/megaraid/megaraid_sas_base.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 09eef1bef430..d57cb787db0b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5792,10 +5792,10 @@ megasas_setup_jbod_map(struct megasas_instance *instance)
 {
 	int i;
 	struct fusion_context *fusion = instance->ctrl_context;
-	u32 pd_seq_map_sz;
+	size_t pd_seq_map_sz;
 
-	pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
-		(sizeof(struct MR_PD_CFG_SEQ) * MAX_PHYSICAL_DEVICES);
+	pd_seq_map_sz = struct_size((struct MR_PD_CFG_SEQ_NUM_SYNC *)0, seq,
+				    MAX_PHYSICAL_DEVICES);
 
 	instance->use_seqnum_jbod_fp =
 		instance->support_seqnum_jbod_fp;
@@ -7974,7 +7974,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	struct fusion_context *fusion;
-	u32 pd_seq_map_sz;
+	size_t pd_seq_map_sz;
 
 	instance = pci_get_drvdata(pdev);
 
@@ -8046,9 +8046,9 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 	if (instance->adapter_type != MFI_SERIES) {
 		megasas_release_fusion(instance);
-		pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
-				(sizeof(struct MR_PD_CFG_SEQ) *
-					MAX_PHYSICAL_DEVICES);
+		pd_seq_map_sz =
+			struct_size((struct MR_PD_CFG_SEQ_NUM_SYNC *)0,
+				    seq, MAX_PHYSICAL_DEVICES);
 		for (i = 0; i < 2 ; i++) {
 			if (fusion->ld_map[i])
 				dma_free_coherent(&instance->pdev->dev,
-- 
2.34.1

