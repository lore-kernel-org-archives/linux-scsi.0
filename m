From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: fix device registration issues
Date: Fri, 10 Mar 2006 00:56:16 +0100
Message-ID: <20060309235616.GA16524@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:49928 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750809AbWCIX5a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Mar 2006 18:57:30 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id k29NvT7i205418
	for <linux-scsi@vger.kernel.org>; Thu, 9 Mar 2006 23:57:29 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k29Nvqxe157032
	for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2006 00:57:52 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id k29NvTm4003612
	for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2006 00:57:29 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

As always I have some late zfcp bug fixes. This time for 2.6.16.

The patch fixes following issues:

(1) Replace scsi_add_device with scsi_scan_target.
(Thus the rport instead of the scsi_host becomes parent of a
scsi_target again.)

(2) Avoid scsi_device allocation during registration of an remote port.
(Would be done during fc_scsi_scan_rport.)

(3) Fix queuecommand behaviour when an zfcp unit is blocked.
(Call scsi_done with DID_NO_CONNECT instead of returning
SCSI_MLQUEUE_DEVICE_BUSY otherwise we might end up waiting
for completion in blk_execute_rq for ever.)


Please apply. Thanks.

Andreas


zfcp: fix device registration issues

Replace scsi_add_device with scsi_scan_target.
Avoid scsi_device allocation during registration of an remote port.
Fix queuecommand behaviour when an zfcp unit is blocked.


Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>


---

 drivers/s390/scsi/zfcp_def.h  |    1 +
 drivers/s390/scsi/zfcp_erp.c  |   11 +++++++----
 drivers/s390/scsi/zfcp_scsi.c |    6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

7d33dfc4fa7f88f83b70cf1ac41bc4e5e5685fe7
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 7f551d6..6eba56c 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -664,6 +664,7 @@ do { \
 #define ZFCP_STATUS_UNIT_TEMPORARY		0x00000002
 #define ZFCP_STATUS_UNIT_SHARED			0x00000004
 #define ZFCP_STATUS_UNIT_READONLY		0x00000008
+#define ZFCP_STATUS_UNIT_REGISTERED		0x00000010
 
 /* FSF request status (this does not have a common part) */
 #define ZFCP_STATUS_FSFREQ_NOT_INIT		0x00000000
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index e3c4bdd..57cb628 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -3391,10 +3391,13 @@ zfcp_erp_action_cleanup(int action, stru
 		    && (!atomic_test_mask(ZFCP_STATUS_UNIT_TEMPORARY,
 					  &unit->status))
 		    && !unit->device
-		    && port->rport)
- 			scsi_add_device(port->adapter->scsi_host, 0,
- 					port->rport->scsi_target_id,
-					unit->scsi_lun);
+		    && port->rport) {
+			atomic_set_mask(ZFCP_STATUS_UNIT_REGISTERED,
+					&unit->status);
+ 			scsi_scan_target(&port->rport->dev, 0,
+					 port->rport->scsi_target_id,
+					 unit->scsi_lun, 0);
+		}
 		zfcp_unit_put(unit);
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index a2de3c9..9e6d07d 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -183,7 +183,8 @@ zfcp_scsi_slave_alloc(struct scsi_device
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	unit = zfcp_unit_lookup(adapter, sdp->channel, sdp->id, sdp->lun);
-	if (unit) {
+	if (unit && atomic_test_mask(ZFCP_STATUS_UNIT_REGISTERED,
+				     &unit->status)) {
 		sdp->hostdata = unit;
 		unit->device = sdp;
 		zfcp_unit_get(unit);
@@ -208,6 +209,7 @@ zfcp_scsi_slave_destroy(struct scsi_devi
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
 
 	if (unit) {
+		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
 		sdpnt->hostdata = NULL;
 		unit->device = NULL;
 		zfcp_unit_put(unit);
@@ -291,7 +293,7 @@ zfcp_scsi_command_async(struct zfcp_adap
 			       "on port 0x%016Lx in recovery\n",
 			       zfcp_get_busid_by_unit(unit),
 			       unit->fcp_lun, unit->port->wwpn);
-		retval = SCSI_MLQUEUE_DEVICE_BUSY;
+		zfcp_scsi_command_fail(scpnt, DID_NO_CONNECT);
 		goto out;
 	}
 
-- 
1.2.4.gf067

