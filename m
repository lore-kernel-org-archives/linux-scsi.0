From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi_dh_emc: return success in clariion_std_inquiry()
Date: Tue, 21 Feb 2017 21:46:37 +0300
Message-ID: <20170221183050.GB28595@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35254 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753115AbdBUSrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Feb 2017 13:47:02 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

We accidentally return an uninitialized variable on success.

Fixes: b6ff1b14cdf4 ("[SCSI] scsi_dh: Update EMC handler")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 4a7679f6c73d..f1578832ec7a 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -358,7 +358,7 @@ static int clariion_prep_fn(struct scsi_device *sdev, struct request *req)
 static int clariion_std_inquiry(struct scsi_device *sdev,
 				struct clariion_dh_data *csdev)
 {
-	int err;
+	int err = SCSI_DH_OK;
 	char *sp_model;
 
 	sp_model = parse_sp_model(sdev, sdev->inquiry);
