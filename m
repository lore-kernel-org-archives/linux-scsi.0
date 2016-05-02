From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] aic94xx: silence a static checker warning
Date: Mon, 2 May 2016 11:34:58 +0300
Message-ID: <20160502083458.GA19792@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23139 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbcEBIfK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2016 04:35:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

"ddb" is a number between 0-64.  It can't ever be >= 0xFFFF.  But the
static checker complains that since we're capping the upper bound, we
may as well cap the lower bound and disallow negatives as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/aic94xx/aic94xx_dev.c b/drivers/scsi/aic94xx/aic94xx_dev.c
index 3307238..84eba3e 100644
--- a/drivers/scsi/aic94xx/aic94xx_dev.c
+++ b/drivers/scsi/aic94xx/aic94xx_dev.c
@@ -73,7 +73,7 @@ out:
 
 static void asd_free_ddb(struct asd_ha_struct *asd_ha, int ddb)
 {
-	if (!ddb || ddb >= 0xFFFF)
+	if (ddb <= 0 || ddb >= 0xFFFF)
 		return;
 	asd_ddbsite_write_byte(asd_ha, ddb, DDB_TYPE, DDB_TYPE_UNUSED);
 	CLEAR_DDB(ddb, asd_ha);
