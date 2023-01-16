Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F6AC677F1
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 14:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbjAPOQM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 09:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjAPOOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 09:14:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F54C233E8;
        Mon, 16 Jan 2023 06:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3D1760FDD;
        Mon, 16 Jan 2023 14:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D81C433EF;
        Mon, 16 Jan 2023 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877941;
        bh=jxRk/3po3zwHzlOmefLkoIwHFneUHHpPpdaXfpXPihk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3c4+YoQ1FA3cHWX1mvj3EQcXDHKH1AMQbdU3roaPBK9j4TKkkkgtBQ6kBcfYwNz1
         4KX4dks8U68+847jPjMfc+AkC/y0r7t3O2DhghmE9TxSgK/Utpw3qdt4XIY8Sw6r13
         ixXGZJItrJmJNUOGy6fhK6fiM58P9z8Rm/egiBGwkgPYWcF46VbVZ2fYm9dlkn+92/
         UJgR+RpcWeumg4VU8tWqrJ/Y0hXnOebFZS1YYlrwivRvOjHvaQBzCFwX7JK4D/0SDM
         ZKgZvSaIOtG9cAiltGJ4gjmP52UvS4fOIqyWqx6UixilCWGN8YjOkbu23s/Wl07Yus
         n+Z5FEEjkP32g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yihang Li <liyihang9@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/16] scsi: hisi_sas: Set a port invalid only if there are no devices attached when refreshing port id
Date:   Mon, 16 Jan 2023 09:05:15 -0500
Message-Id: <20230116140520.116257-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140520.116257-1-sashal@kernel.org>
References: <20230116140520.116257-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit f58c89700630da6554b24fd3df293a24874c10c1 ]

Currently the driver sets the port invalid if one phy in the port is not
enabled, which may cause issues in expander situation. In directly attached
situation, if phy up doesn't occur in time when refreshing port id, the
port is incorrectly set to invalid which will also cause disk lost.

Therefore set a port invalid only if there are no devices attached to the
port.

Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1672805000-141102-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 031aa4043c5e..7135bbe5abb8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1397,7 +1397,7 @@ static void hisi_sas_refresh_port_id(struct hisi_hba *hisi_hba)
 				device->linkrate = phy->sas_phy.linkrate;
 
 			hisi_hba->hw->setup_itct(hisi_hba, sas_dev);
-		} else
+		} else if (!port->port_attached)
 			port->id = 0xff;
 	}
 }
-- 
2.35.1

