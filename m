Return-Path: <SRS0=Z0Y/=AH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B46C433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 04:06:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D578206A1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Jun 2020 04:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgFZEF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 00:05:57 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:49158 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbgFZEF4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 00:05:56 -0400
Received: from localhost.localdomain ([92.148.198.76])
        by mwinf5d16 with ME
        id vg5u2200F1fPLi403g5vwo; Fri, 26 Jun 2020 06:05:55 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 26 Jun 2020 06:05:55 +0200
X-ME-IP: 92.148.198.76
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     linux@armlinux.org.uk, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH V2] scsi: eesox: Fix different dev_id between 'request_irq()' and 'free_irq()'
Date:   Fri, 26 Jun 2020 06:05:53 +0200
Message-Id: <20200626040553.944352-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <26d388f5-be67-b643-c76c-b9fe52f111f7@wanadoo.fr>
References: <26d388f5-be67-b643-c76c-b9fe52f111f7@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The dev_id used in 'request_irq()' and 'free_irq()' should match.
So use 'info' in both cases.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
V2: update free_irq instead of request_irq in order not to obviously break
    code
---
 drivers/scsi/arm/eesox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 6e204a2e0c8d..591ae2a6dd74 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -571,7 +571,7 @@ static int eesoxscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 
 	if (info->info.scsi.dma != NO_DMA)
 		free_dma(info->info.scsi.dma);
-	free_irq(ec->irq, host);
+	free_irq(ec->irq, info);
 
  out_remove:
 	fas216_remove(host);
-- 
2.25.1

