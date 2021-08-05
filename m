Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3E0C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 03:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2D7761078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 03:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhHEDyh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 23:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230273AbhHEDyh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Aug 2021 23:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1A35603E9;
        Thu,  5 Aug 2021 03:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628135663;
        bh=FiMLe1W4icRUTe2OzDgRfFzRmHsBR7QjWfgeGBQGSJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CI93T3u05PN16i8ExmCdq35eGPfgUyeeUPhzgmH/VsG6ObbrR+iXOxJOXyDaSxUQ0
         YxrFJV1gT6AX/05TwZcnf2UaQdvfA6KDoSaR+vrjeLquVJDY1DKSydCIad46Altk15
         nr+H4xRU7D4YF25Jahj0oLEFwljT089z8oToYL838f/x2mhQmSZCPcQq56jp6RnWOZ
         sOSZDqj36e4aA2wzuY5j1yCwnhxAGurg5vjf2INn7g79OpbCGTPYnVyegqeR/4SEUB
         zw/nGVTzExicoBo3wdoD4SqAjOmazJh+zR/K0BKJrgKHjEhFou30duBH8K/5/1wkS0
         fj4C9k51Uv0CQ==
Date:   Wed, 4 Aug 2021 22:57:03 -0500
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
Subject: [PATCH 1/4][next] scsi: megaraid_sas: Replace one-element array with
 flexible-array member in MR_FW_RAID_MAP_ALL
Message-ID: <10ccd770095328f99438e3aff2ceff6ae17f86c5.1628135423.git.gustavoars@kernel.org>
References: <cover.1628135423.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1628135423.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in struct
MR_FW_RAID_MAP_ALL instead of one-element array, and use the struct_size()
helper.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 6 +++---
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 6 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ec10b2497310..d072f9caeb4a 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5147,9 +5147,9 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		fusion->current_map_sz = ventura_map_sz;
 		fusion->max_map_sz = ventura_map_sz;
 	} else {
-		fusion->old_map_sz =  sizeof(struct MR_FW_RAID_MAP) +
-					(sizeof(struct MR_LD_SPAN_MAP) *
-					(instance->fw_supported_vd_count - 1));
+		fusion->old_map_sz =
+			struct_size((struct MR_FW_RAID_MAP *)0, ldSpanMap,
+				    instance->fw_supported_vd_count);
 		fusion->new_map_sz =  sizeof(struct MR_FW_RAID_MAP_EXT);
 
 		fusion->max_map_sz =
diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index 83f69c33b01a..da1cad1ee123 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -326,9 +326,9 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance, u64 map_id)
 	else if (instance->supportmax256vd)
 		expected_size = sizeof(struct MR_FW_RAID_MAP_EXT);
 	else
-		expected_size =
-			(sizeof(struct MR_FW_RAID_MAP) - sizeof(struct MR_LD_SPAN_MAP) +
-			(sizeof(struct MR_LD_SPAN_MAP) * le16_to_cpu(pDrvRaidMap->ldCount)));
+		expected_size = struct_size((struct MR_FW_RAID_MAP *)0,
+					    ldSpanMap,
+					    le16_to_cpu(pDrvRaidMap->ldCount));
 
 	if (le32_to_cpu(pDrvRaidMap->totalSize) != expected_size) {
 		dev_dbg(&instance->pdev->dev, "megasas: map info structure size 0x%x",
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index ce84f811e5e1..b32a6ad7d5a8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -942,7 +942,7 @@ struct MR_FW_RAID_MAP {
 	u8                  reserved2[7];
 	struct MR_ARRAY_INFO       arMapInfo[MAX_RAIDMAP_ARRAYS];
 	struct MR_DEV_HANDLE_INFO  devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES];
-	struct MR_LD_SPAN_MAP      ldSpanMap[1];
+	struct MR_LD_SPAN_MAP      ldSpanMap[];
 };
 
 struct IO_REQUEST_INFO {
@@ -1147,8 +1147,8 @@ typedef struct LOG_BLOCK_SPAN_INFO {
 } LD_SPAN_INFO, *PLD_SPAN_INFO;
 
 struct MR_FW_RAID_MAP_ALL {
-	struct MR_FW_RAID_MAP raidMap;
 	struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES - 1];
+	struct MR_FW_RAID_MAP raidMap;
 } __attribute__ ((packed));
 
 struct MR_DRV_RAID_MAP {
-- 
2.27.0

