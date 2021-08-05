Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB28C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 124AA61029
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbhHEERm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 00:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhHEERh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Aug 2021 00:17:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0BD460EE8;
        Thu,  5 Aug 2021 04:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628137043;
        bh=RTGwVC+e9lhvKEwZi7nLPinHG/f37RvaD3B5wfWsEIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GxifsXfmL6DnJo2RffAXP6/4ec+BTljLySYSlKCStKrr1G+PjoCdVDA1F7hobU+ZS
         ccFA49K5s+aRNlei6pweCcIAgdR/OAJLLGC4VApvvTCoT+JjK6nBVdO/xLyFbHaBFv
         Ryc/UeXAcnp5hM+MzjIw0iV7BQPyMYlzBftNJJ8jKh9SR7cjU7KRgM2CjOiLm0T+nI
         5DfAzOpreAffTKu0gTkMW0MIEq2R9W7iPAsdbzr0AvaJxijT0DwxQlvZV7ECKThXKQ
         3TAhbieG1JAdLl/LEJ+23IHxLG665+K+US8wPCwA0hMKzQG5d6/jWdlsa3rIEAuMnD
         N53zjdGkr4LLA==
Date:   Wed, 4 Aug 2021 23:20:04 -0500
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
Subject: [PATCH v2 3/4][next] scsi: megaraid_sas: Replace one-element array
 with flexible-array member in MR_DRV_RAID_MAP
Message-ID: <b43d4083d9788bb746dc0b2205d6a67ebb609b0d.1628136510.git.gustavoars@kernel.org>
References: <cover.1628136510.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1628136510.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with a flexible-array member in struct
MR_DRV_RAID_MAP and use the flex_array_size() helper.

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
index 9adb8b30f422..5fe2f7a6eebe 100644
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

