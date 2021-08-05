Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BC6C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 03:57:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE19460F58
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 03:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhHED5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 23:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhHED5b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Aug 2021 23:57:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B52A360F0F;
        Thu,  5 Aug 2021 03:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628135837;
        bh=aRaT11tpdN3NXvopAfSAE4vegHLcdwhGUm+niJ8e2Vg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UBQC5aOS5hJ75+q80YUkOt0GthUF7DOtTlketNXEO8jMRJbb7nsk7eNbfdaMGXwOT
         jPc12lqCNySg9VSzfbwicUTak71W2qajKl4Tj8LXOk61WonAvV1Nh6AL6tCO2FCmh+
         Nq72EIi0P5e7LNKDRRB71ZhEwkXeazOZ/khlSuxgZLC8bv6m5gjhdXco0vyr17CQtS
         PgiTnPFheL0EuTR5LE+bPyeank5QVbRuQtHlwBdXsuQ/Hl7HoPid3MhJhkeSa1/Em4
         QniVRL1R9iD9oRbHVHzXjZpynIro9Ib6kQlyAf3ogn3lRWplHnMpjSvED7tb3ksc/k
         T7hkxme+/5H2g==
Date:   Wed, 4 Aug 2021 22:59:58 -0500
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
Subject: [PATCH 2/4][next] scsi: megaraid_sas: Replace one-element array with
 flexible-array member in MR_FW_RAID_MAP_DYNAMIC
Message-ID: <600564eef022b547c561407c17ba88dd0f5df7e0.1628135423.git.gustavoars@kernel.org>
References: <cover.1628135423.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1628135423.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace one-element array with a flexible-array member in struct
MR_FW_RAID_MAP_DYNAMIC.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index b32a6ad7d5a8..8b08445f575e 100644
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

