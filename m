From: swen@vnet.ibm.com
Subject: [patch 2/6] zfcp: Use also port and adapter to identify unit in messages.
Date: Mon, 05 Nov 2007 12:37:44 +0100
Message-ID: <20071105114543.819398000@vnet.ibm.com>
References: <20071105113742.233391000@vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:16798 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbXKELqU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Nov 2007 06:46:20 -0500
Content-Disposition: inline; filename=802-zfcp-msg.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2007-11-02 08:38:25.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2007-11-02 08:38:25.000000000 +0100
@@ -458,7 +458,9 @@ zfcp_scsi_eh_device_reset_handler(struct
 		retval = SUCCESS;
 		goto out;
 	}
-	ZFCP_LOG_NORMAL("resetting unit 0x%016Lx\n", unit->fcp_lun);
+	ZFCP_LOG_NORMAL("resetting unit 0x%016Lx on port 0x%016Lx, adapter %s\n",
+			unit->fcp_lun, unit->port->wwpn,
+			zfcp_get_busid_by_adapter(unit->port->adapter));
 
 	/*
 	 * If we do not know whether the unit supports 'logical unit reset'
@@ -552,7 +554,9 @@ static int zfcp_scsi_eh_host_reset_handl
 	adapter = unit->port->adapter;
 
 	ZFCP_LOG_NORMAL("host reset because of problems with "
-			"unit 0x%016Lx\n", unit->fcp_lun);
+		"unit 0x%016Lx on port 0x%016Lx, adapter %s\n",
+		unit->fcp_lun, unit->port->wwpn,
+		zfcp_get_busid_by_adapter(unit->port->adapter));
 
 	zfcp_erp_adapter_reopen(adapter, 0);
 	zfcp_erp_wait(adapter);

-- 
