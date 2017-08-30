From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] scsi: qla2xxx: Fix an integer overflow in sysfs code
Date: Wed, 30 Aug 2017 15:21:07 +0300
Message-ID: <20170830122106.dmdfril4kwi4p5e5@mwanda>
References: <CAER+mfKPOt03DmPB4FTCjVvQ=2uRSMVbBHP-3CdoG+mQnSiYFw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20652 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdH3MVk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Aug 2017 08:21:40 -0400
Content-Disposition: inline
In-Reply-To: <CAER+mfKPOt03DmPB4FTCjVvQ=2uRSMVbBHP-3CdoG+mQnSiYFw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, shqking <shqking@gmail.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, security@kernel.org

The value of "size" comes from the user.  When we add "start + size"
it could lead to an integer overflow bug.

It means we vmalloc() a lot more memory than we had intended.  I believe
that on 64 bit systems vmalloc() can succeed even if we ask it to
allocate huge 4GB buffers.  So we would get memory corruption and likely
a crash when we call ha->isp_ops->write_optrom() and ->read_optrom().

Only root can trigger this bug.

Fixes: b7cc176c9eb3 ("[SCSI] qla2xxx: Allow region-based flash-part accesses.")
Reported-by: shqking <shqking@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 75c4b312645e..9ce28c4f9812 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -318,6 +318,8 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		return -EINVAL;
 	if (start > ha->optrom_size)
 		return -EINVAL;
+	if (size > ha->optrom_size - start)
+		size = ha->optrom_size - start;
 
 	mutex_lock(&ha->optrom_mutex);
 	switch (val) {
@@ -343,8 +345,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		}
 
 		ha->optrom_region_start = start;
-		ha->optrom_region_size = start + size > ha->optrom_size ?
-		    ha->optrom_size - start : size;
+		ha->optrom_region_size = start + size;
 
 		ha->optrom_state = QLA_SREADING;
 		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
@@ -417,8 +418,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		}
 
 		ha->optrom_region_start = start;
-		ha->optrom_region_size = start + size > ha->optrom_size ?
-		    ha->optrom_size - start : size;
+		ha->optrom_region_size = start + size;
 
 		ha->optrom_state = QLA_SWRITING;
 		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
