From: Jeremy Linton <jlinton@tributary.com>
Subject: [PATCH] Use a more selective error recovery strategy based on device
 capabilities
Date: Tue, 12 Feb 2013 12:19:54 -0600
Message-ID: <511A87CA.5010901@tributary.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------030303020504060502000601"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:26086 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933597Ab3BLSUD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2013 13:20:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi <linux-scsi@vger.kernel.org>

--------------030303020504060502000601
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Ideally, Linux should not be sending task management commands to devices that
don't support the given task mgmt operation.

This patch uses the REPORT SUPPORTED TASK MGMT FUNCTIONS command to enable or
disable error recovery paths for a given device. For older devices, we make an
educated guess about what kind of error recovery the device supports. This isn't
going to be 100% accurate as it should probably take the transport as well as
the SCSI version into account, but it is a start.

While this patch improves the error recovery paths for modern SCSI networks, the
error recovery logic continues to fall through to host reset. It also continues
to send bus and target resets in cases where they may affect working devices. I
have a partial set of patches which attempt to make intelligent decisions in
these cases, but they are far more intrusive and at this point not as clear cut.


Just in case...
Signed-off-by: Jeremy Linton <jlinton@tributary.com>
---

--------------030303020504060502000601
Content-Type: text/x-patch; name="more_selective_error_recovery.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="more_selective_error_recovery.patch"

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c1b05a8..b249c2f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -572,24 +572,25 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
-	int rtn;
+	int rtn = FAILED ;
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
+	struct scsi_device *sdev = scmd->device;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __func__));
 
-	if (!hostt->eh_bus_reset_handler)
-		return FAILED;
+	if ((sdev->bus_reset_ok) && (hostt->eh_bus_reset_handler)) {
 
-	rtn = hostt->eh_bus_reset_handler(scmd);
+		rtn = hostt->eh_bus_reset_handler(scmd);
 
-	if (rtn == SUCCESS) {
-		if (!hostt->skip_settle_delay)
-			ssleep(BUS_RESET_SETTLE_TIME);
-		spin_lock_irqsave(host->host_lock, flags);
-		scsi_report_bus_reset(host, scmd_channel(scmd));
-		spin_unlock_irqrestore(host->host_lock, flags);
+		if (rtn == SUCCESS) {
+			if (!hostt->skip_settle_delay)
+				ssleep(BUS_RESET_SETTLE_TIME);
+			spin_lock_irqsave(host->host_lock, flags);
+			scsi_report_bus_reset(host, scmd_channel(scmd));
+			spin_unlock_irqrestore(host->host_lock, flags);
+		}
 	}
 
 	return rtn;
@@ -601,6 +602,7 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
 	sdev->expecting_cc_ua = 1;
 }
 
+
 /**
  * scsi_try_target_reset - Ask host to perform a target reset
  * @scmd:	SCSI cmd used to send a target reset
@@ -614,19 +616,26 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
 static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
-	int rtn;
+	int rtn = FAILED;
+	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
-	if (!hostt->eh_target_reset_handler)
-		return FAILED;
+	if ((sdev->target_reset_ok) && (hostt->eh_target_reset_handler)) {
 
-	rtn = hostt->eh_target_reset_handler(scmd);
-	if (rtn == SUCCESS) {
-		spin_lock_irqsave(host->host_lock, flags);
-		__starget_for_each_device(scsi_target(scmd->device), NULL,
-					  __scsi_report_device_reset);
-		spin_unlock_irqrestore(host->host_lock, flags);
+		// TODO: Determine if other devices on this IT are experiencing
+		// issues. If not, return success without doing anything. 
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd target RST\n", 
+						  __func__));
+
+		rtn = hostt->eh_target_reset_handler(scmd);
+
+		if (rtn == SUCCESS) {
+			spin_lock_irqsave(host->host_lock, flags);
+			__starget_for_each_device(scsi_target(scmd->device), NULL,
+						     __scsi_report_device_reset);
+			spin_unlock_irqrestore(host->host_lock, flags);
+		}
 	}
 
 	return rtn;
@@ -644,24 +653,36 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
  */
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
-	int rtn;
+	int rtn = FAILED;
 	struct scsi_host_template *hostt = scmd->device->host->hostt;
+	struct scsi_device *sdev = scmd->device;
 
-	if (!hostt->eh_device_reset_handler)
-		return FAILED;
+	if ((sdev->task_unit_reset_ok) && (hostt->eh_device_reset_handler)) {
+	       SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd LUN RST\n", 
+						 __func__));
+		rtn = hostt->eh_device_reset_handler(scmd);
+
+		if (rtn == SUCCESS)
+		    __scsi_report_device_reset(scmd->device, NULL);
+	}
 
-	rtn = hostt->eh_device_reset_handler(scmd);
-	if (rtn == SUCCESS)
-		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
 }
 
 static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt, struct scsi_cmnd *scmd)
 {
-	if (!hostt->eh_abort_handler)
-		return FAILED;
+	int rtn = FAILED;
+	struct scsi_device *sdev = scmd->device;
+
+	if ((sdev->task_abort_ok) && (hostt->eh_abort_handler))
+	{
+		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n", 
+						  __func__));
 
-	return hostt->eh_abort_handler(scmd);
+		rtn=hostt->eh_abort_handler(scmd);
+	}
+
+	return rtn;
 }
 
 static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3e58b22..a71552b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -525,6 +525,144 @@ static void sanitize_inquiry_string(unsigned char *s, int len)
 }
 
 /**
+ * scsi_query_task_mgmt_support - retrieve task mgmt bits from device
+ * @sdev: Readonly, scsi_device to probe
+ *
+ * Description:
+ *     sends as REPORT SUPPORTED TASK MGMT FUNCTIONS command to given device.
+ *     if it succeeds then the error recovery bits (abort, LU reset, IT reset
+ *     , etc) are set based on the return data. 
+ **/
+static void scsi_query_task_mgmt_support(struct scsi_device *sdev)
+{
+	int retries;
+	int resid,result;
+	struct scsi_sense_hdr sshdr;
+	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
+	unsigned char *report_task_result = NULL;
+
+	report_task_result = kmalloc(4, GFP_ATOMIC | 
+				     ((sdev->host->unchecked_isa_dma) 
+				      ? __GFP_DMA : 0));
+	if (report_task_result)
+	{
+	        retries=3; result=1;
+		/* This tends to be the first command sent that can catch the UA
+		 * as we are probing, in this case it might be ok to trap the 
+		 * UA. In general UA's _MUST_ propagate to the owner of the 
+		 * device that is so mode pages, tape positions, etc may be 
+		 * updated after power loss/IT nexus failure. 
+		 **/
+		while ((retries) && (result))
+		{
+		    memset(scsi_cmd,0,MAX_COMMAND_SIZE);
+		    scsi_cmd[0]=0xa3;
+		    scsi_cmd[1]=0x0D;
+		    scsi_cmd[9]=0x04;
+		    
+		    /* send the command, use the inq timeout as this command 
+		     * should be fairly fast */
+		    result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
+					      report_task_result, 4, &sshdr, 
+					      HZ / 2 + HZ * scsi_inq_timeout,
+					      3, &resid);
+		    if (result==0) 
+		    {
+			sdev->task_abort_ok =
+			    ((report_task_result[0]&0x80)==0x80); 
+			sdev->task_unit_reset_ok =
+			    ((report_task_result[0]&0x08)==0x08);
+			sdev->target_reset_ok =
+			    ((report_task_result[0]&0x02)==0x02);
+			sdev->it_reset_ok =
+			    (report_task_result[1]&0x01);
+			
+			
+			
+			/* Use only a single reset strategy.
+			 * Both IT and Target can affect devices besides the one
+			 * in question. Until the linux eh code is smart enough
+			 * to be able to test other devices on the IT/target 
+			 * then really only the LUN reset should be used.
+			 */
+			if (sdev->task_unit_reset_ok)
+			{
+			    sdev->target_reset_ok=0;
+			}
+			
+		    }
+		    else
+		    {
+			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"query task mgmt: Got task mgmt error 0x%X"
+							 ,result));
+			retries--;
+		    }
+		}
+		kfree(report_task_result);
+	}
+}
+
+/**
+ * scsi_retrieve_task_mgmt_support - sets the error recovery bits
+ * @sdev: Readonly, scsi_device to probe
+ *
+ * Description:
+ *     Sets the default error recovery strategy based on the SCSI level
+ *     of the given device. Newer devices will also be queried to determine
+ *     if they can report their supported error recovery methods. 
+ **/
+static int scsi_retrieve_task_mgmt_support(struct scsi_device *sdev)
+{
+	/* default to some basic capabilities based on reported scsi level.
+	 * Of course this can't be 100% accurate, due to converter boxes, bad 
+	 * devices, etc. Hence the need for the device to report its capabilities. 
+	 
+	 * For now lets default the capabilities roughly based on the version 
+	 * aka old SCSI can do bus reset, but not abort..
+	 * FC can do abort/target reset, etc..
+	 **/
+	switch (sdev->scsi_level)  {
+	/* mostly ancient and broken SPI devices */
+	case SCSI_UNKNOWN:
+	case SCSI_1:
+	case SCSI_1_CCS:
+		 sdev->task_abort_ok=0;
+		 sdev->task_unit_reset_ok=0;
+		 sdev->target_reset_ok=0;
+		 sdev->it_reset_ok=0;
+		 sdev->bus_reset_ok=1;
+		 break;
+	/*lots of fairly common hardware here*/
+	case SCSI_2: 
+	case SCSI_3: 
+	        sdev->task_abort_ok=1;
+		sdev->task_unit_reset_ok=0;
+		sdev->target_reset_ok=1;
+		sdev->it_reset_ok=0;
+		sdev->bus_reset_ok=0;
+		break;
+	case SCSI_SPC_2:
+	case SCSI_SPC_3:
+	/* newer than SPC3 */
+        default: 
+	       sdev->task_abort_ok=1;
+	       sdev->task_unit_reset_ok=1;
+	       sdev->target_reset_ok=0;
+	       sdev->it_reset_ok=0;
+	       sdev->bus_reset_ok=0;
+	       break;
+	}
+			
+	if (sdev->scsi_level>SCSI_3)
+	{
+	    scsi_query_task_mgmt_support(sdev);
+	}
+
+	return 0;
+}
+
+/**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
  * @sdev:	scsi_device to probe
  * @inq_result:	area to store the INQUIRY result
@@ -898,6 +1036,11 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
 
+	/* determine the supported error handing */
+	scsi_retrieve_task_mgmt_support(sdev);
+	
+
+
 	/* set the device running here so that slave configure
 	 * may do I/O */
 	ret = scsi_device_set_state(sdev, SDEV_RUNNING);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e65c62e..349563c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -160,6 +160,11 @@ struct scsi_device {
 	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
+	unsigned task_abort_ok:1; /* can we send aborts? */
+	unsigned task_unit_reset_ok:1;  /* can we send lun reset? */
+	unsigned target_reset_ok:1;  /* can we send target reset? */
+	unsigned it_reset_ok:1;  /* can we send IT nexus reset */
+	unsigned bus_reset_ok:1;  /* can we send bus reset */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */

--------------030303020504060502000601--
