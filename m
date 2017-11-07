From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: hpsa: remove an unecessary NULL check
Date: Tue, 7 Nov 2017 16:01:32 +0300
Message-ID: <20171107130131.3zohbeoobjxbqmdz@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39055 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932706AbdKGNBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 08:01:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

device->scsi3addr[] is an array, not a pointer, so it can't be NULL.
I've removed the check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 287e5eb0723f..b0aa5dc1d54c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8223,8 +8223,6 @@ static void hpsa_set_ioaccel_status(struct ctlr_info *h)
 
 		if (!device)
 			continue;
-		if (!device->scsi3addr)
-			continue;
 		if (!hpsa_vpd_page_supported(h, device->scsi3addr,
 						HPSA_VPD_LV_IOACCEL_STATUS))
 			continue;
