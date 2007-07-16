From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 22:19:38 +0900
Message-ID: <200707161319.l6GDJd07027464@mbox.iij4u.or.jp>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41536 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935AbXGPNT5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 09:19:57 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mark_salyzyn@adaptec.com, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 11:47:14 +0200

> Changes since last post:
> 
> - Rebase to current -git. Lots of SCSI drivers have been converted
>   to use the sg accessor helpers, which nicely shrinks this patchset
>   from 70 to 33 patches. Great!

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ips: sg chaining support

ips properly uses scsi_for_each_sg for the normal I/O path, however,
the breakup path doesn't.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ips.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 9f8ed6b..cc5ac4f 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3251,7 +3251,7 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 		 */
 		if ((scb->breakup) || (scb->sg_break)) {
                         struct scatterlist *sg;
-                        int sg_dma_index, ips_sg_index = 0;
+                        int i, sg_dma_index, ips_sg_index = 0;
 
 			/* we had a data breakup */
 			scb->data_len = 0;
@@ -3260,20 +3260,22 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 
                         /* Spin forward to last dma chunk */
                         sg_dma_index = scb->breakup;
+                        for (i = 0; i < scb->breakup; i++)
+                                sg = sg_next(sg);
 
 			/* Take care of possible partial on last chunk */
                         ips_fill_scb_sg_single(ha,
-                                               sg_dma_address(&sg[sg_dma_index]),
+                                               sg_dma_address(sg),
                                                scb, ips_sg_index++,
-                                               sg_dma_len(&sg[sg_dma_index]));
+                                               sg_dma_len(sg));
 
                         for (; sg_dma_index < scsi_sg_count(scb->scsi_cmd);
-                             sg_dma_index++) {
+                             sg_dma_index++, sg = sg_next(sg)) {
                                 if (ips_fill_scb_sg_single
                                     (ha,
-                                     sg_dma_address(&sg[sg_dma_index]),
+                                     sg_dma_address(sg),
                                      scb, ips_sg_index++,
-                                     sg_dma_len(&sg[sg_dma_index])) < 0)
+                                     sg_dma_len(sg)) < 0)
                                         break;
                         }
 
-- 
1.4.3.2

