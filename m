Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD23C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 03:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CF7260F0F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 03:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbhHED6X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 23:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhHED6W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Aug 2021 23:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FEE260F0F;
        Thu,  5 Aug 2021 03:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628135887;
        bh=pFF1tr2fsOoIgGDhIxp/x83PpmpH6r4UQOV68JSoU08=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DWfmGK9FEZ/Rz7HqtZGV0Ww1v81sS1pMywHpBKErM7bZOxpUO+VM8rhPLsi/eOOmX
         tdlypgIrEBZvGAPQwDc9UkGN6MlsKcGAgDEmrMCfjfsjPU8RoIWDeX4HXJQOvITfEZ
         5RFxb35/pFAdLLHVg7fK9GKpsUTvu0g8Ug8Vjd5w13NwhJ2DYak+gueAZLDyhrrEj4
         ZW07k8IyYusuTUlA/8p7RlDaNZgW0y8mMkC7UWuFYG/z/OZuTkwYz7bcTbddOOFAo9
         SmcdsMS4tDgwoTwl4Iuh1VWw+7CmTZjuLKMcgWtVfQ6WCX5BzZkqYld1S7HtSXmRyu
         XlwAJIgPp5EMQ==
Date:   Wed, 4 Aug 2021 23:00:47 -0500
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
Subject: [PATCH 3/4][next] scsi: megaraid_sas: Replace one-element array with
 flexible-array member in MR_DRV_RAID_MAP
Message-ID: <e1ac01250cd344e8f1627357bb445f1d0dedd6ed.1628135423.git.gustavoars@kernel.org>
References: <cover.1628135423.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1628135423.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with a flexible-array member in struct
MR_DRV_RAID_MAP and use the flex_array_size() helper.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 6 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index da1cad1ee123..9cb36ef96c2c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -229,8 +229,8 @@ static int MR_PopulateDrvRaidMap(struct megasas_instance *instance, u64 map_id)
 					le32_to_cpu(desc_table->raid_map_desc_offset));
 				memcpy(pDrvRaidMap->ldSpanMap,
 				       fw_map_dyn->ld_span_map,
-				       sizeof(struct MR_LD_SPAN_MAP) *
-				       le32_to_cpu(desc_table->raid_map_desc_elements));
+				       flex_array_size(pDrvRaidMap, ldSpanMap,
+				       le32_to_cpu(desc_table->raid_map_desc_elements)));
 			break;
 			default:
 				dev_dbg(&instance->pdev->dev, "wrong number of desctableElements %d\n",
@@ -254,7 +254,7 @@ static int MR_PopulateDrvRaidMap(struct megasas_instance *instance, u64 map_id)
 			pDrvRaidMap->ldTgtIdToLd[i] =
 				(u16)fw_map_ext->ldTgtIdToLd[i];
 		memcpy(pDrvRaidMap->ldSpanMap, fw_map_ext->ldSpanMap,
-		       sizeof(struct MR_LD_SPAN_MAP) * ld_count);
+		       flex_array_size(pDrvRaidMap, ldSpanMap, ld_count));
 		memcpy(pDrvRaidMap->arMapInfo, fw_map_ext->arMapInfo,
 		       sizeof(struct MR_ARRAY_INFO) * MAX_API_ARRAYS_EXT);
 		memcpy(pDrvRaidMap->devHndlInfo, fw_map_ext->devHndlInfo,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 8b08445f575e..d60137eb519c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1182,7 +1182,7 @@ struct MR_DRV_RAID_MAP {
 		devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES_DYN];
 	u16 ldTgtIdToLd[MAX_LOGICAL_DRIVES_DYN];
 	struct MR_ARRAY_INFO arMapInfo[MAX_API_ARRAYS_DYN];
-	struct MR_LD_SPAN_MAP      ldSpanMap[1];
+	struct MR_LD_SPAN_MAP      ldSpanMap[];
 
 };
 
-- 
2.27.0

