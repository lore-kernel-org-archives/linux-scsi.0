From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] scsi_transport_fc: Unexport scsi_is_fc_vport()
Date: Mon, 28 Mar 2016 14:37:28 -0700
Message-ID: <56F9A418.5040607@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0082.outbound.protection.outlook.com ([157.56.111.82]:60011
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751537AbcC1Vhe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2016 17:37:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, James Smart <james.smart@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Running the command "git grep -nHw scsi_is_fc_vport" shows that this
function is only called from inside scsi_transport_fc.c. Hence unexport
this function.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/scsi_transport_fc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 8a88226..90afe5d 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2027,11 +2027,10 @@ static void fc_vport_dev_release(struct device *dev)
 	kfree(vport);
 }
 
-int scsi_is_fc_vport(const struct device *dev)
+static int scsi_is_fc_vport(const struct device *dev)
 {
 	return dev->release == fc_vport_dev_release;
 }
-EXPORT_SYMBOL(scsi_is_fc_vport);
 
 static int fc_vport_match(struct attribute_container *cont,
 			    struct device *dev)
-- 
2.7.3

