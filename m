From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [RFC][PATCH] 2.5.44 scsi-misc-2.5 handle INQUIRY VPD page 0 failure
Date: Mon, 28 Oct 2002 16:27:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021028162715.A22258@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e31.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g9T0SX5u014136
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 19:28:33 -0500
Received: from gateway1.beaverton.ibm.com (gateway1.beaverton.ibm.com [138.95.180.2])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g9T0RGa8231496
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 17:27:16 -0700
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway1.beaverton.ibm.com (8.11.6/8.11.6) with ESMTP id g9T0NwV02157
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2002 16:23:58 -0800
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g9T0RFR22433
	for linux-scsi@vger.kernel.org; Mon, 28 Oct 2002 16:27:15 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi -

This patch against scsi-miscs-2.5 changes the scsi_scan.c behaviour a bit,
so when we cannot send an INQUIRY VPD page 0, a default name is used, and
after sending ID related commands, we set the device back online. This way
broken devices have some chance of coming back online and being used.

This assumes the error handler and adpter driver can recover any hung 
bus (that is, it won't fix the buslogic driver).

I did not add any special printk's - on failure, the error handler
will print some cryptic messages, and then ideally the device would
still be attached by the appropriate upper level drivers. 

Any comments? Should I add a printk if !sdev->online?

===== drivers/scsi/scsi_scan.c 1.31 vs edited =====
--- 1.31/drivers/scsi/scsi_scan.c	Wed Oct 23 10:04:01 2002
+++ edited/drivers/scsi/scsi_scan.c	Mon Oct 28 16:12:42 2002
@@ -1106,12 +1106,9 @@
 
 	memset(sdev->sdev_driverfs_dev.name, 0, DEVICE_NAME_SIZE);
 	evpd_page = scsi_get_evpd_page(sdev, sreq);
-	if (evpd_page == NULL) {
-		/*
-		 * try to obtain serial number anyway
-		 */
-		(void)scsi_get_serialnumber(sdev, sreq);
-	} else {
+	if (evpd_page == NULL)
+		scsi_get_default_name(sdev);
+	else {
 		/*
 		 * XXX search high to low, since the pages are lowest to
 		 * highest - page 0x83 will be after page 0x80.
@@ -1131,6 +1128,14 @@
 
 	}
 leave:
+	/*
+	 * Errors sending the above pages can offline the device, set it
+	 * back online so it can still be used. 
+	 *
+	 * Specifically, sending an INQUIRY VPD page 0 to a SEAGATE
+	 * SX423451W via a buslogic adapter caused a bus hang.
+	 */
+	sdev->online = TRUE;
 	if (evpd_page) kfree(evpd_page);
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: host %d channel %d"
 	    " id %d lun %d name/id: '%s'\n", sdev->host->host_no,

Thanks.

-- Patrick Mansfield
