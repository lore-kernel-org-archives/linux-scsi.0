From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 24/27] zfcp: proper use of device register
Date: Tue, 18 Aug 2009 15:43:29 +0200
Message-ID: <20090818135031.964241000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:38065 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967AbZHRNuc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:32 -0400
Content-Disposition: inline; filename=721-zfcp-device-register.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Sebastian Ott <sebott@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

Don't use kfree directly after device registration started.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:30:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:30:23.000000000 +0200
@@ -309,8 +309,10 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	}
 	read_unlock_irq(&zfcp_data.config_lock);
 
-	if (device_register(&unit->sysfs_device))
-		goto err_out_free;
+	if (device_register(&unit->sysfs_device)) {
+		put_device(&unit->sysfs_device);
+		return ERR_PTR(-EINVAL);
+	}
 
 	if (sysfs_create_group(&unit->sysfs_device.kobj,
 			       &zfcp_sysfs_unit_attrs)) {
@@ -675,8 +677,10 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	}
 	read_unlock_irq(&zfcp_data.config_lock);
 
-	if (device_register(&port->sysfs_device))
-		goto err_out_free;
+	if (device_register(&port->sysfs_device)) {
+		put_device(&port->sysfs_device);
+		goto err_out;
+	}
 
 	retval = sysfs_create_group(&port->sysfs_device.kobj,
 				    &zfcp_sysfs_port_attrs);

