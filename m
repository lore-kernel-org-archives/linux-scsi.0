Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 526BECE7A8B
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Sep 2023 13:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjIXNVt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Sep 2023 09:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjIXNVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Sep 2023 09:21:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE1E1F3D;
        Sun, 24 Sep 2023 06:18:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBE0C43391;
        Sun, 24 Sep 2023 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695561532;
        bh=bL/VnMwO75WldEZU5EOyvcqVwP5Rmd1qVJU5lgCRZuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iS6bECebt1IiKGQLH9q2budrxRuH3uyQ12guK9qSPIEj287JdhEIB1Oaa5dShM5HB
         ZD3MZPoLxGHspGqUSdY+asxXJqLS6d9pJnwQFlSvSspJy9NY8icjvjwG5JVYsbx5pp
         +G8/AsiDQAYbldIe+ZIMx4QD52XXYJT1pNm7f03CiZuYkXCa/cR/JyW9mNGxvqKUWo
         s9PD74CtAKusmCDiVTBaJEow6qX68kveV5QLPDtP/wgQXvQhtFBYpO+R11Izu+Zw6A
         4nMxNw8hgyBKfIRY0UIvnghwc2CCoZySKKCtUw3uAgKZLKNFpQnTWA3LotNWTLVNqo
         ioftR5Mv03RJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Grzedzicki <mge@meta.com>, Jack Wang <jinpu.wang@ionos.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 26/28] scsi: pm80xx: Avoid leaking tags when processing OPC_INB_SET_CONTROLLER_CONFIG command
Date:   Sun, 24 Sep 2023 09:17:43 -0400
Message-Id: <20230924131745.1275960-26-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230924131745.1275960-1-sashal@kernel.org>
References: <20230924131745.1275960-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.55
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Michal Grzedzicki <mge@meta.com>

[ Upstream commit c13e7331745852d0dd7c35eabbe181cbd5b01172 ]

Tags allocated for OPC_INB_SET_CONTROLLER_CONFIG command need to be freed
when we receive the response.

Signed-off-by: Michal Grzedzicki <mge@meta.com>
Link: https://lore.kernel.org/r/20230911170340.699533-2-mge@meta.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index bcccea7c1244a..2bf293e8f7472 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3750,10 +3750,12 @@ static int mpi_set_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 			(struct set_ctrl_cfg_resp *)(piomb + 4);
 	u32 status = le32_to_cpu(pPayload->status);
 	u32 err_qlfr_pgcd = le32_to_cpu(pPayload->err_qlfr_pgcd);
+	u32 tag = le32_to_cpu(pPayload->tag);
 
 	pm8001_dbg(pm8001_ha, MSG,
 		   "SET CONTROLLER RESP: status 0x%x qlfr_pgcd 0x%x\n",
 		   status, err_qlfr_pgcd);
+	pm8001_tag_free(pm8001_ha, tag);
 
 	return 0;
 }
-- 
2.40.1

