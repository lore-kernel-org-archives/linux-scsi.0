From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] cxlflash: off by one bug in cxlflash_show_port_status()
Date: Fri, 14 Aug 2015 23:35:25 +0300
Message-ID: <20150814203525.GA27158@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35023 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbHNUfv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2015 16:35:51 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The > should be >= or we read one element past the end of the array.

Fixes: c21e0bbfc485 ('cxlflash: Base support for IBM CXL Flash Adapter')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Fixes: c21e0bbfc485 ('cxlflash: Base support for IBM CXL Flash Adapter')
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 0720d2f..fd70101 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -539,7 +539,7 @@ static ssize_t cxlflash_show_port_status(struct device *dev,
 	u64 *fc_regs;
 
 	rc = kstrtouint((attr->attr.name + 4), 10, &port);
-	if (rc || (port > NUM_FC_PORTS))
+	if (rc || (port >= NUM_FC_PORTS))
 		return 0;
 
 	fc_regs = &afu->afu_map->global.fc_regs[port][0];
