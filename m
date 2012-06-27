From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/2 -resend] SCSI: advansys: handle errors from scsi_dma_map()
Date: Wed, 27 Jun 2012 12:00:56 +0300
Message-ID: <20120627090055.GD31212@elgon.mountain>
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

scsi_dma_map() returns -ENOMEM on error.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Originally sent on Tue, 20 Sep 2011.

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 374c4ed..b2c3a1a 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -8426,6 +8426,12 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 
 	/* Build ASC_SCSI_Q */
 	use_sg = scsi_dma_map(scp);
+	if (use_sg < 0) {
+		scsi_dma_unmap(scp);
+		scp->result = HOST_BYTE(DID_SOFT_ERROR);
+		return ASC_ERROR;
+	}
+
 	if (use_sg != 0) {
 		int sgcnt;
 		struct scatterlist *slp;
