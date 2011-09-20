From: Dan Carpenter <error27@gmail.com>
Subject: [patch 2/2] SCSI: advansys: use a subsystem error code
Date: Tue, 20 Sep 2011 09:47:42 +0300
Message-ID: <20110920064739.GB28892@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:63780 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab1ITGr7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2011 02:47:59 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:ADVANSYS SCSI DRIVER" <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

This was supposed to be a subsystem specific error code.  It makes
static checkers complain because "warn_code" is unsigned short so it
can't store negatives.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 04035af..1a48f8c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4725,7 +4725,7 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	asc_dvc->overrun_dma = dma_map_single(board->dev, asc_dvc->overrun_buf,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
 	if (dma_mapping_error(board->dev, asc_dvc->overrun_dma)) {
-		warn_code = -ENOMEM;
+		warn_code = UW_ERR;
 		goto err_dma_map;
 	}
 	phy_addr = cpu_to_le32(asc_dvc->overrun_dma);
