From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] scsi: ufs: Fix to avoid a potential NULL pointer dereference
Date: Mon, 18 Mar 2019 19:30:38 -0500
Message-ID: <20190319003038.12896-1-pakki001@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Pedro Sousa <pedrom.sousa@synopsys.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In tc_dwc_g210_pltfm_probe, of_match_node can return a NULL pointer
in case of failure. The patch avoids a potential NULL pointer dereference
in such scenarios.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
index 6dfe5a9206e9..2b5bc6bd715e 100644
--- a/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
+++ b/drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
@@ -61,6 +61,8 @@ static int tc_dwc_g210_pltfm_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 
 	of_id = of_match_node(tc_dwc_g210_pltfm_match, dev->of_node);
+	if (!of_id)
+		return -ENXIO;
 	vops = (struct ufs_hba_variant_ops *)of_id->data;
 
 	/* Perform generic probe */
-- 
2.17.1
