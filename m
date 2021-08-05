Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE30C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABCFE61078
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 04:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbhHEEQb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 00:16:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:57502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230215AbhHEEQa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Aug 2021 00:16:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD94E60F58;
        Thu,  5 Aug 2021 04:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628136977;
        bh=GYTjY+KFDYtNGY3RO8J3n+kq9mUnaStEDB2XfegLVEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=somduTLxShxmAvjd1+6s3qrOvnopdi13zb7wLzTjGIMKGuKQRo72sD4oj5TqqLhuw
         H7Cdm5zlZBFI2+W5bCqiy1BOYYObOVnGD37Ix8OvdYopWbY5K5sa0xAVeQXh386t0c
         /BOQYyGtUxLCN1W8VzoqZTvzx8ByRvPhvX34gXTX0r4qR84UG0ZThsGMKcW1NBLrA+
         cnOQE0QP1BosV2Qs0dt/Nb6jt5OG0iQHpxZu0XQiK+vS20d7+ahl1NARUB3NiwTNoB
         LUIdS4TzRoTqaIo4o7VzquFrECLs+1RiDNA1REemCabQRc3IJ8xOq1ik/SWHFboXbk
         Q4yP3E042Fqwg==
Date:   Wed, 4 Aug 2021 23:18:58 -0500
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
Subject: [PATCH v2 2/4][next] scsi: megaraid_sas: Replace one-element array
 with flexible-array member in MR_FW_RAID_MAP_DYNAMIC
Message-ID: <894f0df7940def9afe2bcd3b8a982404a45bcba9.1628136510.git.gustavoars@kernel.org>
References: <cover.1628136510.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1628136510.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with a flexible-array member in struct
MR_FW_RAID_MAP_DYNAMIC.

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

 drivers/scsi/megaraid/megaraid_sas_fusion.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index a47139ef9ee2..9adb8b30f422 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1053,7 +1053,7 @@ struct MR_FW_RAID_MAP_DYNAMIC {
 	struct MR_RAID_MAP_DESC_TABLE
 			raid_map_desc_table[RAID_MAP_DESC_TYPE_COUNT];
 	/* Variable Size buffer containing all data */
-	u32 raid_map_desc_data[1];
+	u32 raid_map_desc_data[];
 }; /* Dynamicaly sized RAID MAp structure */
 
 #define IEEE_SGE_FLAGS_ADDR_MASK            (0x03)
-- 
2.27.0

