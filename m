From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 1/3] qla4xxx: qla4xxx: Remove funcs with no callers in ql4_init.c
Date: Sat, 05 Aug 2006 02:05:25 -0500
Message-ID: <20060805070525.23332.67301.stgit@bebe.enoyolf.org>
References: <20060805070514.23332.36344.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:33730 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1161593AbWHEHHf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Aug 2006 03:07:35 -0400
In-Reply-To: <20060805070514.23332.36344.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, dwm@austin.ibm.com

From: Doug Maxey <dwm@enoyolf.org>

These can be added later when a caller exists.
    qla4xxx_login_device()
    qla4xxx_logout_device()
    qla4xxx_delete_device()

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_init.c |  163 +--------------------------------------
 1 files changed, 5 insertions(+), 158 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 1e55e42..8608106 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -41,7 +41,7 @@ static void ql4xxx_set_mac_number(struct
 }
 
 /**
- * qla4xxx_free_ddb - deallocate ddb	
+ * qla4xxx_free_ddb - deallocate ddb
  * @ha: pointer to host adapter structure.
  * @ddb_entry: pointer to device database entry
  *
@@ -376,7 +376,7 @@ static struct ddb_entry* qla4xxx_get_ddb
  *
  * This routine updates the driver's internal device database entry
  * with information retrieved from the firmware's device database
- * entry for the specified device. The ddb_entry->fw_ddb_index field 
+ * entry for the specified device. The ddb_entry->fw_ddb_index field
  * must be initialized prior to	calling this routine
  *
  **/
@@ -494,7 +494,7 @@ struct ddb_entry * qla4xxx_alloc_ddb(str
  * @ha: Pointer to host adapter structure.
  *
  * This routine searches for all valid firmware ddb entries and builds
- * an internal ddb list. Ddbs that are considered valid are those with 
+ * an internal ddb list. Ddbs that are considered valid are those with
  * a device state of SESSION_ACTIVE.
  **/
 static int qla4xxx_build_ddb_list(struct scsi_qla_host *ha)
@@ -540,7 +540,7 @@ static int qla4xxx_build_ddb_list(struct
 				qla4xxx_set_ddb_entry(ha, fw_ddb_index, 0);
 		}
 
-		if (ddb_state != DDB_DS_SESSION_ACTIVE) 
+		if (ddb_state != DDB_DS_SESSION_ACTIVE)
 			goto next_one;
 		/*
 		 * if fw_ddb with session active state found,
@@ -1134,7 +1134,7 @@ static int qla4xxx_start_firmware(struct
  * @renew_ddb_list: Indicates what to do with the adapter's ddb list
  *	after adapter recovery has completed.
  *	0=preserve ddb list, 1=destroy and rebuild ddb list
- * 
+ *
  * This routine parforms all of the steps necessary to initialize the adapter.
  *
  **/
@@ -1340,156 +1340,3 @@ int qla4xxx_process_ddb_changed(struct s
 	return QLA_SUCCESS;
 }
 
-/**
- * qla4xxx_login_device - login to target device
- * @ha: Pointer to host adapter structure.
- * @fw_ddb_index: Index of the device to login
- * @connection_id: Connection ID of the device to login
- *
- * This routine is called by the login IOCTL to log in the specified device.
- **/
-int qla4xxx_login_device(struct scsi_qla_host *ha, uint16_t fw_ddb_index,
-			 uint16_t connection_id)
-{
-	struct ddb_entry * ddb_entry;
-	int status = QLA_ERROR;
-
-	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
-	if (ddb_entry == NULL)
-		goto exit_login_device;
-
-	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL, NULL,
-				    &ddb_entry->fw_ddb_device_state, NULL,
-				    NULL, NULL) == QLA_ERROR)
-		goto exit_login_device;
-
-	if (ddb_entry->fw_ddb_device_state == DDB_DS_SESSION_ACTIVE) {
-		status = QLA_SUCCESS;
-		goto exit_login_device;
-	}
-
-	if (qla4xxx_conn_close_sess_logout(ha, fw_ddb_index, connection_id,
-					   LOGOUT_OPTION_RELOGIN)
-	    != QLA_SUCCESS)
-		goto exit_login_device;
-
-	status = QLA_SUCCESS;
-
-exit_login_device:
-	return status;
-}
-
-/**
- * qla4xxx_logout_device - logout target device
- * @ha: Pointer to host adapter structure.
- * @fw_ddb_index: Index of the device to logout
- * @connection_id: Connection ID of the device to logout
- *
- * This support routine is called by the logout IOCTL to log out
- * the specified device.
- **/
-int qla4xxx_logout_device(struct scsi_qla_host *ha, uint16_t fw_ddb_index,
-			  uint16_t connection_id)
-{
-	int status = QLA_ERROR;
-	struct ddb_entry * ddb_entry;
-	uint32_t old_fw_ddb_device_state;
-
-	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
-	if (ddb_entry == NULL)
-		goto exit_logout_device;
-
-	if (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL, NULL,
-				    &old_fw_ddb_device_state, NULL, NULL,
-				    NULL) != QLA_SUCCESS)
-		goto exit_logout_device;
-
-	set_bit(DF_NO_RELOGIN, &ddb_entry->flags);
-	if (qla4xxx_conn_close_sess_logout(ha, fw_ddb_index, connection_id,
-					   LOGOUT_OPTION_CLOSE_SESSION)
-	    != QLA_SUCCESS)
-		goto exit_logout_device;
-
-	status = QLA_SUCCESS;
-
-exit_logout_device:
-	return status;
-}
-
-/**
- * qla4xxx_delete_device - delete specified ddb entry
- * @ha: Pointer to host adapter structure.
- * @fw_ddb_index: Index of the device to delete
- * @connection_id: Connection ID of the device to delete
- *
- * This routine is called by the logout IOCTL to delete the specified
- * device. Send the LOGOUT and DELETE_DDB commands for the specified
- * target, even if it's not in our internal database.
- **/
-int qla4xxx_delete_device(struct scsi_qla_host *ha, uint16_t fw_ddb_index,
-			  uint16_t connection_id)
-{
-	int status = QLA_ERROR;
-	uint32_t fw_ddb_device_state = 0xFFFF;
-	u_long wait_count;
-	struct ddb_entry * ddb_entry;
-
-	/* If the device is in our internal tables, set the NO_RELOGIN bit. */
-	ddb_entry = qla4xxx_lookup_ddb_by_fw_index(ha, fw_ddb_index);
-	if (ddb_entry != NULL)
-		set_bit(DF_NO_RELOGIN, &ddb_entry->flags);
-
-	/*
-	 * If the device state is already one that we can delete, bypass the
-	 * logout command.
-	 */
-	qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL, NULL,
-				&fw_ddb_device_state, NULL, NULL, NULL);
-	if (fw_ddb_device_state == DDB_DS_UNASSIGNED ||
-	    fw_ddb_device_state == DDB_DS_NO_CONNECTION_ACTIVE ||
-	    fw_ddb_device_state == DDB_DS_SESSION_FAILED)
-		goto delete_ddb;
-
-	/* First logout index */
-	if (qla4xxx_conn_close_sess_logout(ha, fw_ddb_index, connection_id,
-					   LOGOUT_OPTION_CLOSE_SESSION) !=
-	    QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld: %s: LOGOUT_OPTION_CLOSE_SESSION "
-			      "failed index [%d]\n", ha->host_no, __func__,
-			      fw_ddb_index));
-		goto exit_delete_ddb;
-	}
-
-	/* Wait enough time to complete logout */
-	wait_count = jiffies + LOGOUT_TOV * HZ;
-	while (qla4xxx_get_fwddb_entry(ha, fw_ddb_index, NULL, 0, NULL, NULL,
-				       &fw_ddb_device_state, NULL, NULL, NULL)
-	       == QLA_SUCCESS) {
-		if (time_after_eq(jiffies, wait_count))
-			goto exit_delete_ddb;
-		if (fw_ddb_device_state == DDB_DS_UNASSIGNED ||
-		    fw_ddb_device_state == DDB_DS_NO_CONNECTION_ACTIVE ||
-		    fw_ddb_device_state == DDB_DS_SESSION_FAILED)
-			break;
-		udelay(50);
-	}
-
-delete_ddb:
-	/* Now delete index */
-	if (qla4xxx_clear_database_entry(ha, fw_ddb_index) == QLA_SUCCESS) {
-		status = QLA_SUCCESS;
-
-		if (!ddb_entry)
-			goto exit_delete_ddb;
-
-		atomic_set(&ddb_entry->state, DDB_STATE_DEAD);
-		DEBUG(printk("scsi%ld: %s: removing index %d.\n", ha->host_no,
-			     __func__, fw_ddb_index));
-		ha->fw_ddb_index_map[fw_ddb_index] =
-			(struct ddb_entry *)INVALID_ENTRY;
-	}
-
-exit_delete_ddb:
-	return status;
-
-}
