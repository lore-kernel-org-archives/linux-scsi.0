From: Brian King <brking@us.ibm.com>
Subject: [PATCH] Midlayer initiated START_UNIT
Date: Mon, 26 Jan 2004 13:43:48 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40156DF4.1010104@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080700060208010003050702"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:51621 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264534AbUAZTnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jan 2004 14:43:50 -0500
Received: from northrelay02.pok.ibm.com (northrelay02.pok.ibm.com [9.56.224.150])
	by e3.ny.us.ibm.com (8.12.10/8.12.2) with ESMTP id i0QJhncg784058
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2004 14:43:49 -0500
Received: from us.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by northrelay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i0QJhnec038700
	for <linux-scsi@vger.kernel.org>; Mon, 26 Jan 2004 14:43:49 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080700060208010003050702
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

The ipr driver that is currently out for review talks to disk array devices
that require a START_UNIT prior to media ops, similar to normal scsi devices.
However, any time the adapter gets reset, these devices end up needing another
START_UNIT. This causes problems with the current error handling and these
devices get taken offline when this occurs. Attached is a patch which will
better handle these devices and issue a START_UNIT from the error handler
when appropriate.





-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------080700060208010003050702
Content-Type: text/plain;
 name="patch-2.6.1-start_unit"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-2.6.1-start_unit"

diff -Naur linux-2.6.1/drivers/scsi/scsi_error.c linux-2.6.1-start_unit/drivers/scsi/scsi_error.c
--- linux-2.6.1/drivers/scsi/scsi_error.c	Fri Jan  9 00:59:03 2004
+++ linux-2.6.1-start_unit/drivers/scsi/scsi_error.c	Mon Jan 26 10:51:37 2004
@@ -37,6 +37,8 @@
 #define SENSE_TIMEOUT (10*HZ)
 #endif
 
+#define START_UNIT_TIMEOUT (30*HZ)
+
 /*
  * These should *probably* be handled by the host itself.
  * Since it is allowed to sleep, it probably should.
@@ -282,6 +284,15 @@
 			(scmd->sense_buffer[13] == 0x01)) {
 			return NEEDS_RETRY;
 		}
+		/*
+		 * if the device is not started, we need to wake
+		 * the error handler to start the motor
+		 */
+		if (scmd->device->allow_restart &&
+		    (scmd->sense_buffer[12] == 0x04) &&
+		    (scmd->sense_buffer[13] == 0x02)) {
+			return FAILED;
+		}
 		return SUCCESS;
 
 		/* these three are not supported */
@@ -829,6 +840,105 @@
 }
 
 /**
+ * scsi_eh_try_stu - Send START_UNIT to device.
+ * @scmd:	Scsi cmd to send START_UNIT
+ *
+ * Return value:
+ *    0 - Device is ready. 1 - Device NOT ready.
+ **/
+static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
+{
+	static unsigned char stu_command[6] = {START_STOP, 0, 0, 0, 1, 0};
+	int rtn;
+
+	if (!scmd->device->allow_restart)
+		return 1;
+
+	memcpy(scmd->cmnd, stu_command, sizeof(stu_command));
+
+	/*
+	 * zero the sense buffer.  the scsi spec mandates that any
+	 * untransferred sense data should be interpreted as being zero.
+	 */
+	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
+
+	scmd->request_buffer = NULL;
+	scmd->request_bufflen = 0;
+	scmd->use_sg = 0;
+	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
+	scmd->underflow = 0;
+	scmd->sc_data_direction = DMA_NONE;
+
+	rtn = scsi_send_eh_cmnd(scmd, START_UNIT_TIMEOUT);
+
+	/*
+	 * when we eventually call scsi_finish, we really wish to complete
+	 * the original request, so let's restore the original data. (db)
+	 */
+	scsi_setup_cmd_retry(scmd);
+
+	/*
+	 * hey, we are done.  let's look to see what happened.
+	 */
+	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd %p rtn %x\n",
+		__FUNCTION__, scmd, rtn));
+	if (rtn == SUCCESS)
+		return 0;
+	return 1;
+}
+
+ /**
+ * scsi_eh_stu - send START_UNIT if needed
+ * @shost:	scsi host being recovered.
+ * @eh_done_q:	list_head for processed commands.
+ *
+ * Notes:
+ *    If commands are failing due to not ready, initializing command required,
+ *	try revalidating the device, which will end up sending a start unit. 
+ **/
+static int scsi_eh_stu(struct Scsi_Host *shost,
+			      struct list_head *work_q,
+			      struct list_head *done_q)
+{
+	struct list_head *lh, *lh_sf;
+	struct scsi_cmnd *scmd, *stu_scmd;
+	struct scsi_device *sdev;
+
+	shost_for_each_device(sdev, shost) {
+		stu_scmd = NULL;
+		list_for_each_entry(scmd, work_q, eh_entry)
+			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
+			    scsi_check_sense(scmd) == FAILED ) {
+				stu_scmd = scmd;
+				break;
+			}
+
+		if (!stu_scmd)
+			continue;
+
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Sending START_UNIT to sdev:"
+						  " 0x%p\n", current->comm, sdev));
+
+		if (!scsi_eh_try_stu(stu_scmd)) {
+			if (!sdev->online || !scsi_eh_tur(stu_scmd)) {
+				list_for_each_safe(lh, lh_sf, work_q) {
+					scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
+					if (scmd->device == sdev)
+						scsi_eh_finish_cmd(scmd, done_q);
+				}
+			}
+		} else {
+			SCSI_LOG_ERROR_RECOVERY(3,
+						printk("%s: START_UNIT failed to sdev:"
+						       " 0x%p\n", current->comm, sdev));
+		}
+	}
+
+	return list_empty(work_q);
+}
+
+
+/**
  * scsi_eh_bus_device_reset - send bdr if needed
  * @shost:	scsi host being recovered.
  * @eh_done_q:	list_head for processed commands.
@@ -1033,7 +1143,9 @@
 		if (rtn == SUCCESS) {
 			list_for_each_safe(lh, lh_sf, work_q) {
 				scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
-				if (!scmd->device->online || !scsi_eh_tur(scmd)) 
+				if (!scmd->device->online ||
+				    (!scsi_eh_try_stu(scmd) && !scsi_eh_tur(scmd)) ||
+				    !scsi_eh_tur(scmd))
 					scsi_eh_finish_cmd(scmd, done_q);
 			}
 		} else {
@@ -1401,10 +1513,11 @@
 			       struct list_head *work_q,
 			       struct list_head *done_q)
 {
-	if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
-		if (!scsi_eh_bus_reset(shost, work_q, done_q))
-			if (!scsi_eh_host_reset(work_q, done_q))
-				scsi_eh_offline_sdevs(work_q, done_q);
+	if (!scsi_eh_stu(shost, work_q, done_q))
+		if (!scsi_eh_bus_device_reset(shost, work_q, done_q))
+			if (!scsi_eh_bus_reset(shost, work_q, done_q))
+				if (!scsi_eh_host_reset(work_q, done_q))
+					scsi_eh_offline_sdevs(work_q, done_q);
 }
 
 /**
diff -Naur linux-2.6.1/include/scsi/scsi_device.h linux-2.6.1-start_unit/include/scsi/scsi_device.h
--- linux-2.6.1/include/scsi/scsi_device.h	Fri Jan  9 00:59:06 2004
+++ linux-2.6.1-start_unit/include/scsi/scsi_device.h	Mon Jan 26 08:48:07 2004
@@ -94,6 +94,7 @@
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
+	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 

--------------080700060208010003050702--

