Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAF7C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E39761073
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhHEEPk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 00:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhHEEPk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Aug 2021 00:15:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E389861008;
        Thu,  5 Aug 2021 04:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628136926;
        bh=sKYzfoQnOauHaBevSJJ+01Qcw+1Iy/ZwKyQRsQ9BISE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZz4wI/AMUyESr4eJ7QZZ8JVYq1lIkjE09UZrX92uyKsLqw2iqL8U6UsKXwbX0G1l
         Cf7B97aXb3hVsOh/gfUnFz3LPbueDbR0AaH7GoYvbV8WY8P3qXBxsaiSi3SaXRaChF
         jqiJ4PXVm+chC8rS5AUCqW/CfWRCPJBYbJ07bEPycCv2owwtx5ESZmBOtnwt9CDqLr
         vJfM+W3cPNd+niILrjVQ6sZg9nlUXV9tpwSBsfpghkKOAQDUixGaHexuLzKFB3vcmn
         eXdHE9yP1ecuFqsc/qS6H7D+dWdjkL3noZKjjr+89FXOuqkmpsBK6pt43qlxtKAaLL
         tR+jab5EVLPWw==
Date:   Wed, 4 Aug 2021 23:18:07 -0500
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
Subject: [PATCH v2 1/4][next] scsi: megaraid_sas: Replace one-element array
 with flexible-array member in MR_FW_RAID_MAP
Message-ID: <8f32956f8e1699cd78231fd49a3a333b8fa11546.1628136510.git.gustavoars@kernel.org>
References: <cover.1628136510.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1628136510.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use “flexible array members”[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code according to the use of a flexible-array member in struct
MR_FW_RAID_MAP instead of one-element array, and use the struct_size()
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
Changes in v2:
 - Revert changes in struct MR_FW_RAID_MAP_ALL.
 - Update Subject line and changelog text.

 drivers/scsi/megaraid/megaraid_sas_base.c   | 6 +++---
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 6 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

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
index ce84f811e5e1..a47139ef9ee2 100644
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
-- 
2.27.0

