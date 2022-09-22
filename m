Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29627C6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 04:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiIVEaz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 00:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiIVEay (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 00:30:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAE889919;
        Wed, 21 Sep 2022 21:30:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 317466297A;
        Thu, 22 Sep 2022 04:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EC4C433D6;
        Thu, 22 Sep 2022 04:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663821052;
        bh=0cVqkxRIHZH/P1nh/IXYkahOysAuOUCnPG3hBtZWP0w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XaJU/KLbUgzRdlQZzvBM7wB+8RTQtz5ChgAMlN3Qw5DRuHed7o2AfnyfttSPAG5+L
         xuyGR4zWo1TVSeBcXl6z2RdoNRs1H4hAfh54Cz0b4NvkMeduseC+bkXdNR9MynnHii
         dLlybO0OANRTYJ/ECUfRIFXIhcDh9sU4iEIiP3R3IZOVXrTFguPXL1OKnj0+QLLHAw
         4o2hv/CsmiKek3kD68yGpu9qEUmjI410Mf8YMg8yYkNoYl3JdUjzZ7r971Gxjcj8oa
         m0p/XkijFO+l7PzA8L1VDkgySjBXBGgXrREclLf+nzQaxaQmXk4p7pLPDHqsy4seys
         hOpZ/BZ395Hsw==
Date:   Wed, 21 Sep 2022 23:30:47 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kevin Barnett <kevin.barnett@microsemi.com>,
        Don Brace <don.brace@microchip.com>, storagedev@microchip.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 3/3][next] scsi: smartpqi: Use struct_size() helper in
 pqi_report_phys_luns()
Message-ID: <b6a23dbc136710e98580ac01daa39ad971eecb5d.1663816572.git.gustavoars@kernel.org>
References: <cover.1663816572.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1663816572.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prefer struct_size() over open-coded versions of idiom:

sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count

where count is the max number of items the flexible array is supposed to
contain.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 544cd18a90d7..17bdc8b3f161 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1192,7 +1192,7 @@ static inline int pqi_report_phys_luns(struct pqi_ctrl_info *ctrl_info, void **b
 
 	rpl_8byte_wwid_list = rpl_list;
 	num_physicals = get_unaligned_be32(&rpl_8byte_wwid_list->header.list_length) / sizeof(rpl_8byte_wwid_list->lun_entries[0]);
-	rpl_16byte_wwid_list_length = sizeof(struct report_lun_header) + (num_physicals * sizeof(struct report_phys_lun_16byte_wwid));
+	rpl_16byte_wwid_list_length = struct_size(rpl_16byte_wwid_list, lun_entries, num_physicals);
 
 	rpl_16byte_wwid_list = kmalloc(rpl_16byte_wwid_list_length, GFP_KERNEL);
 	if (!rpl_16byte_wwid_list)
-- 
2.34.1

