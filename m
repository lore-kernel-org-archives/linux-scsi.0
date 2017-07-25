From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/2] scsi: aacraid: reading out of bounds
Date: Tue, 25 Jul 2017 22:49:55 +0300
Message-ID: <20170725194955.dd4g6msevoesty4t@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17296 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753950AbdGYTuK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2017 15:50:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

"qd.id" comes directly from the copy_from_user() on the line before so
we should verify that it's within bounds.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This bug predates git.

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 707ee2f5954d..4591113c49de 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -3198,10 +3198,11 @@ static int query_disk(struct aac_dev *dev, void __user *arg)
 		return -EBUSY;
 	if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
 		return -EFAULT;
-	if (qd.cnum == -1)
+	if (qd.cnum == -1) {
+		if (qd.id < 0 || qd.id >= dev->maximum_num_containers)
+			return -EINVAL;
 		qd.cnum = qd.id;
-	else if ((qd.bus == -1) && (qd.id == -1) && (qd.lun == -1))
-	{
+	} else if ((qd.bus == -1) && (qd.id == -1) && (qd.lun == -1)) {
 		if (qd.cnum < 0 || qd.cnum >= dev->maximum_num_containers)
 			return -EINVAL;
 		qd.instance = dev->scsi_host_ptr->host_no;
