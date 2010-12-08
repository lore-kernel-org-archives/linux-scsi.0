From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/1] zfcp: Add allow_lun_scan module parameter
Date: Wed, 08 Dec 2010 17:30:46 +0100
Message-ID: <20101208163746.352589338@de.ibm.com>
References: <20101208163045.686322948@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:34642 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab0LHQhs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Dec 2010 11:37:48 -0500
Content-Disposition: inline; filename=param.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The zfcpdump tool requires a method to attach exactly one LUN. The
easiest way to achieve this is to add a new zfcp module parameter.
When allow_lun_scan is set to "false", zfcp only accepts LUNs that
have been configured through the unit_add sysfs interface.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -30,6 +30,10 @@ module_param_named(dif, enable_dif, bool
 MODULE_PARM_DESC(dif, "Enable DIF/DIX data integrity support");
 #endif
 
+static bool allow_lun_scan = 1;
+module_param(allow_lun_scan, bool, 0600);
+MODULE_PARM_DESC(allow_lun_scan, "For NPIV, scan and attach all storage LUNs");
+
 static int zfcp_scsi_change_queue_depth(struct scsi_device *sdev, int depth,
 					int reason)
 {
@@ -134,6 +138,7 @@ static int zfcp_scsi_slave_alloc(struct
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
+	int npiv = adapter->connection_features & FSF_FEATURE_NPIV_MODE;
 
 	port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
 	if (!port)
@@ -143,7 +148,7 @@ static int zfcp_scsi_slave_alloc(struct
 	if (unit)
 		put_device(&unit->dev);
 
-	if (!unit && !(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
+	if (!unit && !(allow_lun_scan && npiv)) {
 		put_device(&port->dev);
 		return -ENXIO;
 	}

