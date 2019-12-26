Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7199BC3F68F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 15:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 520B420882
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 15:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbfLZPfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 10:35:42 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:55103 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfLZPfm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 10:35:42 -0500
Received: from localhost.localdomain ([90.40.29.152])
        by mwinf5d81 with ME
        id ifbf210053Gv28S03fbfGR; Thu, 26 Dec 2019 16:35:40 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Thu, 26 Dec 2019 16:35:40 +0100
X-ME-IP: 90.40.29.152
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] scsi: aha1740: avoid a duplicated 'scsi_host_put()' call
Date:   Thu, 26 Dec 2019 16:33:35 +0100
Message-Id: <20191226153335.9151-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If 'dma_map_single()' fails, 'scsi_host_put (shpnt)' will be called twice.
Once in the 'if' block, and once in the error handling path.
Axe one of this call.

Fixes: 1dc09e120c83 ("scsi: aha1740: stop using scsi_unregister")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
I'm not sure of the commit used in the Fixes tag. This commit has made
obvious the redundant scsi_host_put call, but it was already hidden in
'scsi_unregister()' ('scsi_unregister()' is not part of the kernel anymore,
but see 4.8.17 for example:
https://elixir.bootlin.com/linux/v4.8.17/source/drivers/scsi/hosts.c#L552)
---
 drivers/scsi/aha1740.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index da4150c17781..5a227c03895f 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -592,7 +592,6 @@ static int aha1740_probe (struct device *dev)
 					     DMA_BIDIRECTIONAL);
 	if (!host->ecb_dma_addr) {
 		printk (KERN_ERR "aha1740_probe: Couldn't map ECB, giving up\n");
-		scsi_host_put (shpnt);
 		goto err_host_put;
 	}
 	
-- 
2.20.1

