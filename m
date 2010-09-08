From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/12] zfcp: Reorder registration of initial SCSI device
Date: Wed, 08 Sep 2010 14:39:50 +0200
Message-ID: <20100908124352.674351232@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56807 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674Ab0IHMnz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:55 -0400
Content-Disposition: inline; filename=700-zfcp-reorder-registration.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Make sure that the rport registration did complete and then register
SCSI device directly. Otherwise the unit_unqueue would race with the
call to zfcp_scsi_queue_unit_register.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2010-09-08 08:49:25.000000000 +0200
@@ -73,13 +73,14 @@ static void __init zfcp_init_device_conf
 	if (!port)
 		goto out_port;
 
+	flush_work(&port->rport_work);
 	unit = zfcp_unit_enqueue(port, lun);
 	if (IS_ERR(unit))
 		goto out_unit;
 
 	zfcp_erp_unit_reopen(unit, 0, "auidc_1", NULL);
 	zfcp_erp_wait(adapter);
-	flush_work(&unit->scsi_work);
+	zfcp_scsi_scan(unit);
 
 out_unit:
 	put_device(&port->dev);

