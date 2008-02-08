From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] advansys: fix overrun_buf aligned bug
Date: Fri, 08 Feb 2008 09:50:08 +0900
Message-ID: <20080208095008V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:59943 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933715AbYBHAuS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 19:50:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: skogtun.linux@gmail.com, matthew@wil.cx, linux-scsi@vger.kernel.org, tomof@acm.org

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
1.5.3.7

