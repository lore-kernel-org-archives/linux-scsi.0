From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 2/2 -resend] SCSI: advansys: use a subsystem error code
Date: Wed, 27 Jun 2012 12:01:18 +0300
Message-ID: <20120627090118.GE31212@elgon.mountain>
References: <20120627085800.GA3007@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This was supposed to be a subsystem specific error code.  It makes
static checkers complain because "warn_code" is unsigned short so it
can't store negatives.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Originally sent on Tue, 20 Sep 2011.

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index b2c3a1a..4212586 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4724,7 +4724,7 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	asc_dvc->overrun_dma = dma_map_single(board->dev, asc_dvc->overrun_buf,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
 	if (dma_mapping_error(board->dev, asc_dvc->overrun_dma)) {
-		warn_code = -ENOMEM;
+		warn_code = UW_ERR;
 		goto err_dma_map;
 	}
 	phy_addr = cpu_to_le32(asc_dvc->overrun_dma);
