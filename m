From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/11] zfcp: Dont use 0 to indicate invalid LUN in rec trace
Date: Wed, 17 Feb 2010 11:18:54 +0100
Message-ID: <20100217102018.671750000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:46627 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0BQKUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:23 -0500
Content-Disposition: inline; filename=706-zfcp-invalid-lun.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

0 is a valid value for a LUN. It is slightly confusing to also see 0
in the trace entries relating to adapter and port. Change this to use
0xFFFFFFFFFFFFFFFF in the LUN field when the trace entry does not 
relate to a LUN or unit.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |   12 ++++++------
 drivers/s390/scsi/zfcp_dbf.h |    2 ++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2010-02-16 09:43:30.000000000 +0100
@@ -576,7 +576,8 @@ void zfcp_dbf_rec_adapter(char *id, void
 	struct zfcp_adapter *adapter = dbf->adapter;
 
 	zfcp_dbf_rec_target(id, ref, dbf, &adapter->status,
-				  &adapter->erp_counter, 0, 0, 0);
+			    &adapter->erp_counter, 0, 0,
+			    ZFCP_DBF_INVALID_LUN);
 }
 
 /**
@@ -590,8 +591,8 @@ void zfcp_dbf_rec_port(char *id, void *r
 	struct zfcp_dbf *dbf = port->adapter->dbf;
 
 	zfcp_dbf_rec_target(id, ref, dbf, &port->status,
-				  &port->erp_counter, port->wwpn, port->d_id,
-				  0);
+			    &port->erp_counter, port->wwpn, port->d_id,
+			    ZFCP_DBF_INVALID_LUN);
 }
 
 /**
@@ -642,10 +643,9 @@ void zfcp_dbf_rec_trigger(char *id2, voi
 		r->u.trigger.ps = atomic_read(&port->status);
 		r->u.trigger.wwpn = port->wwpn;
 	}
-	if (unit) {
+	if (unit)
 		r->u.trigger.us = atomic_read(&unit->status);
-		r->u.trigger.fcp_lun = unit->fcp_lun;
-	}
+	r->u.trigger.fcp_lun = unit ? unit->fcp_lun : ZFCP_DBF_INVALID_LUN;
 	debug_event(dbf->rec, action ? 1 : 4, r, sizeof(*r));
 	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.h linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.h	2010-02-16 09:43:30.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h	2010-02-16 09:43:30.000000000 +0100
@@ -30,6 +30,8 @@
 #define ZFCP_DBF_TAG_SIZE      4
 #define ZFCP_DBF_ID_SIZE       7
 
+#define ZFCP_DBF_INVALID_LUN	0xFFFFFFFFFFFFFFFFull
+
 struct zfcp_dbf_dump {
 	u8 tag[ZFCP_DBF_TAG_SIZE];
 	u32 total_size;		/* size of total dump data */

