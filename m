Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A14FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 05:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233729AbiGVFYJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 01:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbiGVFYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 01:24:08 -0400
X-Greylist: delayed 126607 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Jul 2022 22:24:07 PDT
Received: from smtp.smtpout.orange.fr (smtp-14.smtpout.orange.fr [80.12.242.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257A089A84
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2022 22:24:07 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id El8uolwqo9xlAEl8uoA2Wm; Fri, 22 Jul 2022 07:24:05 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 22 Jul 2022 07:24:05 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH] scsi: elx: efct: Avoid open coded arithmetic in memory allocation
Date:   Fri, 22 Jul 2022 07:24:03 +0200
Message-Id: <09772a4478dae212604459a32b68337f7dc1f902.1658467368.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

kmalloc_array()/kcalloc() should be used to avoid potential overflow when
a multiplication is needed to compute the size of the requested memory.

So turn a kzalloc()+explicit size computation into an equivalent kcalloc().

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Discussion about it at:
   https://lore.kernel.org/all/eab847fe-8d17-1a38-b55e-e68a2f6a1829@linux-m68k.org/
---
 drivers/scsi/elx/efct/efct_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_io.c b/drivers/scsi/elx/efct/efct_io.c
index c612f0a48839..1ae2e4e950ef 100644
--- a/drivers/scsi/elx/efct/efct_io.c
+++ b/drivers/scsi/elx/efct/efct_io.c
@@ -56,7 +56,7 @@ efct_io_pool_create(struct efct *efct, u32 num_sgl)
 		}
 
 		/* Allocate SGL */
-		io->sgl = kzalloc(sizeof(*io->sgl) * num_sgl, GFP_KERNEL);
+		io->sgl = kcalloc(num_sgl, sizeof(*io->sgl), GFP_KERNEL);
 		if (!io->sgl) {
 			efct_io_pool_free(io_pool);
 			return NULL;
-- 
2.34.1

