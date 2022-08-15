Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CBB3C25B0D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Aug 2022 01:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243185AbiHPBzA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Aug 2022 21:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbiHPByl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Aug 2022 21:54:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1641C21146F;
        Mon, 15 Aug 2022 14:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95823B811FE;
        Mon, 15 Aug 2022 21:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58E7C433D6;
        Mon, 15 Aug 2022 21:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660599980;
        bh=9P1wiCHMqEfEMRjp5RWcePkGLroiFvT2II+AyFuabVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pN/UAeEWR9Cl72HCG6eavcTQAflelQE+1zXehSk9ZT47IZIlHVgTjYoi04Up2QF/g
         Q4VTLIjzsH7OR05f3XRTB6psxqkFDSccQgH3gPRAGePI3eXmMT4ScH5lu/+TT32oW6
         9AsxpEFF9s+rehxFo+mJTLNtXomhXoinL6+OfE15YhQtbzhrcMaAsQALOiF1xlvDxZ
         2i7CnO3wiIKmfI6nsGTjtChMBUo7UqfqbmqTRLqH0l8dSpcfVxcPPVHotXtQwLd/je
         iOrE6ljiNHJqe1TE3qkYgzwPTG0ku4RN3+Ey+vk60EkemJUynjYa+gjrcKIStJq9HB
         XeRnjA1BlqQeQ==
Date:   Mon, 15 Aug 2022 16:46:13 -0500
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
Subject: [PATCH v3 3/6] scsi: megaraid_sas: Replace one-element array with
 flexible-array member in MR_DRV_RAID_MAP
Message-ID: <1448f387821833726b99f0ce13069ada89164eb5.1660592640.git.gustavoars@kernel.org>
References: <cover.1660592640.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1660592640.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

One-element arrays are deprecated, and we are replacing them with
flexible array members, instead. So, replace one-element array with
flexible-array member in struct MR_DRV_RAID_MAP and refactor the
code accordingly.

This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
routines on memcpy().

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Enhanced-by: Kees Cook <keescook@chromium.org> # Change in struct MR_DRV_RAID_MAP_ALL
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v3:
 - Revert use of flex_array_size() helper.
 - Modify MR_DRV_RAID_MAP_ALL structure.

Changes in v2:
 - None.

 drivers/scsi/megaraid/megaraid_sas_fusion.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 66e13b74fcdc..df92d4369e04 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1182,7 +1182,7 @@ struct MR_DRV_RAID_MAP {
 		devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES_DYN];
 	u16 ldTgtIdToLd[MAX_LOGICAL_DRIVES_DYN];
 	struct MR_ARRAY_INFO arMapInfo[MAX_API_ARRAYS_DYN];
-	struct MR_LD_SPAN_MAP      ldSpanMap[1];
+	struct MR_LD_SPAN_MAP      ldSpanMap[];
 
 };
 
@@ -1193,7 +1193,7 @@ struct MR_DRV_RAID_MAP {
 struct MR_DRV_RAID_MAP_ALL {
 
 	struct MR_DRV_RAID_MAP raidMap;
-	struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES_DYN - 1];
+	struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES_DYN];
 } __packed;
 
 
-- 
2.34.1

