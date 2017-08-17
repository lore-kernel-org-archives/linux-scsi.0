From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: hpsa: fix the device_id in hpsa_update_device_info()
Date: Thu, 17 Aug 2017 17:44:44 +0300
Message-ID: <20170817144444.tocisnlw6grmaf75@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, ". Hannes Reinecke" <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The parentheses are in the wrong place so we specify the length as
"sizeof(this_device->device_id) < 0" which is zero.

Fixes: 988b87edd231 ("scsi: hpsa: Ignore errors for unsupported LV_DEVICE_ID VPD page")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 2773dd7a2087..a22295ee3b70 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3827,7 +3827,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 	memset(this_device->device_id, 0,
 		sizeof(this_device->device_id));
 	if (hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
-		sizeof(this_device->device_id) < 0))
+		sizeof(this_device->device_id)) < 0)
 		dev_err(&h->pdev->dev,
 			"hpsa%d: %s: can't get device id for host %d:C0:T%d:L%d\t%s\t%.16s\n",
 			h->ctlr, __func__,
