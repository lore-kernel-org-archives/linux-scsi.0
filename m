From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Thu, 07 Feb 2008 19:37:07 -0600
Message-ID: <1202434627.3171.63.camel@localhost.localdomain>
References: <1202432206.3171.53.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46748 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761074AbYBHBhM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 20:37:12 -0500
In-Reply-To: <1202432206.3171.53.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


On Thu, 2008-02-07 at 18:56 -0600, James Bottomley wrote:
> Quite a bit of this is fixing things broken previously (the advansys fix
> is still pending resolution, but I'll send it as an -rc fix when we have
> it).  There's the final elimination of all drivers that are esp based
> but don't use the scsi_esp core (that's mostly m68k and alpha).  Plus
> the usual bunch of driver updates and the addition of a new enclosure
> services driver and the corresponding ULD.

OK, the advansys fix came in.  I've added it to the patch.

James

----

>From f983323fea178352ed3b69c70561a13825a3ce59 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 8 Feb 2008 09:50:08 +0900
Subject: [SCSI] advansys: fix overrun_buf aligned bug

struct asc_dvc_var needs overrun buffer to be placed on an 8 byte
boundary. advansys defines struct asc_dvc_var:

struct asc_dvc_var {
	...
	uchar overrun_buf[ASC_OVERRUN_BSIZE] __aligned(8);

The problem is that struct asc_dvc_var is placed on
shost->hostdata. So if the hostdata is not on an 8 byte boundary, the
advansys crashes. The hostdata is placed on a sizeof(unsigned long)
boundary so the 8 byte boundary is not garanteed with x86_32.

With 2.6.23 and 2.6.24, the hostdata is on an 8 byte boundary by
chance, but with the current git, it's not.

This patch removes overrun_buf static array and use kzalloc.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/advansys.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ccef891..3c2d688 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -566,7 +566,7 @@ typedef struct asc_dvc_var {
 	ASC_SCSI_BIT_ID_TYPE unit_not_ready;
 	ASC_SCSI_BIT_ID_TYPE queue_full_or_busy;
 	ASC_SCSI_BIT_ID_TYPE start_motor;
-	uchar overrun_buf[ASC_OVERRUN_BSIZE] __aligned(8);
+	uchar *overrun_buf;
 	dma_addr_t overrun_dma;
 	uchar scsi_reset_wait;
 	uchar chip_no;
@@ -13833,6 +13833,12 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	 */
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DBG(2, "AscInitAsc1000Driver()\n");
+
+		asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
+		if (!asc_dvc_varp->overrun_buf) {
+			ret = -ENOMEM;
+			goto err_free_wide_mem;
+		}
 		warn_code = AscInitAsc1000Driver(asc_dvc_varp);
 
 		if (warn_code || asc_dvc_varp->err_code) {
@@ -13840,8 +13846,10 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 					"warn 0x%x, error 0x%x\n",
 					asc_dvc_varp->init_state, warn_code,
 					asc_dvc_varp->err_code);
-			if (asc_dvc_varp->err_code)
+			if (asc_dvc_varp->err_code) {
 				ret = -ENODEV;
+				kfree(asc_dvc_varp->overrun_buf);
+			}
 		}
 	} else {
 		if (advansys_wide_init_chip(shost))
@@ -13894,6 +13902,7 @@ static int advansys_release(struct Scsi_Host *shost)
 		dma_unmap_single(board->dev,
 					board->dvc_var.asc_dvc_var.overrun_dma,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+		kfree(board->dvc_var.asc_dvc_var.overrun_buf);
 	} else {
 		iounmap(board->ioremap_addr);
 		advansys_wide_free_mem(board);
-- 
1.5.3.8



