Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3E2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 01:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbiEQBZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 21:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiEQBZo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 21:25:44 -0400
Received: from mail.meizu.com (edge01.meizu.com [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF8A64CE;
        Mon, 16 May 2022 18:25:40 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Tue, 17 May
 2022 09:25:41 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Tue, 17 May
 2022 09:25:38 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: elx: efct: remove null check after call container_of()
Date:   Tue, 17 May 2022 09:25:36 +0800
Message-ID: <1652750737-22673-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

container_of() will never return NULL, so remove useless code.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/scsi/elx/efct/efct_lio.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index 8b004a5818d6..be4b5c1ee32d 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -370,9 +370,6 @@ static int efct_lio_get_cmd_state(struct se_cmd *cmd)
 		container_of(cmd, struct efct_scsi_tgt_io, cmd);
 	struct efct_io *io = container_of(ocp, struct efct_io, tgt_io);
 
-	if (!io)
-		return 0;
-
 	return io->tgt_io.state;
 }
 
-- 
2.7.4

