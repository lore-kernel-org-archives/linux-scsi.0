From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 4/5] scsi_transport_iscsi: Unexport
 iscsi_is_flashnode_conn_dev()
Date: Wed, 30 Mar 2016 11:27:47 -0700
Message-ID: <56FC1AA3.5040600@sandisk.com>
References: <56FC1A3B.4040704@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0062.outbound.protection.outlook.com ([207.46.100.62]:64384
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754579AbcC3S1w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 14:27:52 -0400
In-Reply-To: <56FC1A3B.4040704@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The output of "git grep -nHw iscsi_is_flashnode_conn_dev" shows
that this function is only called from inside source file
drivers/scsi/scsi_transport_iscsi.c. Hence unexport this function.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 446781d..dff7413 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1324,11 +1324,10 @@ EXPORT_SYMBOL_GPL(iscsi_create_flashnode_conn);
  *  1 on success
  *  0 on failure
  */
-int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
+static int iscsi_is_flashnode_conn_dev(struct device *dev, void *data)
 {
 	return dev->bus == &iscsi_flashnode_bus;
 }
-EXPORT_SYMBOL_GPL(iscsi_is_flashnode_conn_dev);
 
 static int iscsi_destroy_flashnode_conn(struct iscsi_bus_flash_conn *fnode_conn)
 {
-- 
2.7.3

