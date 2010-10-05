From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/3] zfcp: Call get_device on port before calling put_device
Date: Tue, 05 Oct 2010 17:12:54 +0200
Message-ID: <20101005151359.072444057@de.ibm.com>
References: <20101005151252.217141720@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:47741 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab0JEPOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2010 11:14:07 -0400
Content-Disposition: inline; filename=713-zfcp-ref-counting.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

zfcp_unit_release calls put_device on the port. Ensure that get_device
has been called before possibly triggering the release function
through put_device or device_unregister.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_unit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_unit.c linux-2.6-patched/drivers/s390/scsi/zfcp_unit.c
--- linux-2.6/drivers/s390/scsi/zfcp_unit.c	2010-10-05 15:58:17.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_unit.c	2010-10-05 15:58:21.000000000 +0200
@@ -142,6 +142,8 @@ int zfcp_unit_add(struct zfcp_port *port
 		return -ENOMEM;
 	}
 
+	get_device(&port->dev);
+
 	if (device_register(&unit->dev)) {
 		put_device(&unit->dev);
 		return -ENOMEM;
@@ -152,8 +154,6 @@ int zfcp_unit_add(struct zfcp_port *port
 		return -EINVAL;
 	}
 
-	get_device(&port->dev);
-
 	write_lock_irq(&port->unit_list_lock);
 	list_add_tail(&unit->list, &port->unit_list);
 	write_unlock_irq(&port->unit_list_lock);

