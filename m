From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of scan_scsis
Date: Thu, 21 Nov 2002 02:26:52 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121022652.B8931@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

this function was a multiplexer for two very different things, but
with my last patch one of those faded away and only one callers
is left.  Simplify it to what's still needed and rename to
scsi_scan_host.


--- 1.31/drivers/scsi/hosts.c	Sun Nov 17 16:47:02 2002
+++ edited/drivers/scsi/hosts.c	Thu Nov 21 01:06:53 2002
@@ -308,7 +308,7 @@
 			sht->info ? sht->info(shost) : sht->name);
 
 	device_register(&shost->host_driverfs_dev);
-	scan_scsis(shost, 0, 0, 0, 0);
+	scsi_scan_host(shost);
 			
 	for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
 		if (sdev->host->hostt != sht)
--- 1.39/drivers/scsi/hosts.h	Sun Nov 17 16:37:54 2002
+++ edited/drivers/scsi/hosts.h	Thu Nov 21 01:11:57 2002
@@ -519,7 +519,7 @@
 /*
  * Prototypes for functions/data in scsi_scan.c
  */
-extern void scan_scsis(struct Scsi_Host *, uint, uint, uint, uint);
+extern void scsi_scan_host(struct Scsi_Host *);
 
 struct Scsi_Device_Template
 {
--- 1.38/drivers/scsi/scsi_scan.c	Sun Nov 17 16:47:20 2002
+++ edited/drivers/scsi/scsi_scan.c	Thu Nov 21 01:16:03 2002
@@ -1927,111 +1990,56 @@
 }
 
 /**
- * scsi_scan_selected_lun - probe and add one LUN
+ * scsi_scan_host - scan the given adapter
+ * @shost:	adapter to scan
  *
  * Description:
- *     Probe a single LUN on @shost, @channel, @id and @lun. If the LUN is
- *     found, set the queue depth, allocate command blocks, and call
- *     init/attach/finish of the upper level (sd, sg, etc.) drivers.
+ *     Iterate and call scsi_scan_target to scan all possible target id's
+ *     on all possible channels.
  **/
-static void scsi_scan_selected_lun(struct Scsi_Host *shost, uint channel,
-				   uint id, uint lun)
+void scsi_scan_host(struct Scsi_Host *shost)
 {
-	Scsi_Device *sdevscan, *sdev = NULL;
-	int res;
-
-	if ((channel > shost->max_channel) || (id >= shost->max_id) ||
-	    (lun >= shost->max_lun))
-		return;
+	struct scsi_device *sdevscan;
+	uint channel, id, order_id;
 
-	sdevscan = scsi_alloc_sdev(shost, channel, id, lun);
+	/*
+	 * The blk layer queue allocation is a bit expensive to
+	 * repeat for each channel and id - for FCP max_id is near
+	 * 255: each call to scsi_alloc_sdev() implies a call to
+	 * blk_init_queue, and then blk_init_free_list, where 2 *
+	 * queue_nr_requests requests are allocated. Don't do so
+	 * here for scsi_scan_selected_lun, since we end up
+	 * calling select_queue_depths with an extra Scsi_Device
+	 * on the host_queue list.
+	 */
+	sdevscan = scsi_alloc_sdev(shost, 0, 0, 0);
 	if (sdevscan == NULL)
 		return;
-
-	sdevscan->scsi_level = scsi_find_scsi_level(channel, id, shost);
-	res = scsi_probe_and_add_lun(sdevscan, &sdev, NULL);
-	scsi_free_sdev(sdevscan);
-
-	if (res != SCSI_SCAN_LUN_PRESENT) 
-		return;
-
-	scsi_attach_device(sdev);
-}
-
-/**
- * scan_scsis - scan the given adapter, or scan a single LUN
- * @shost:	adapter to scan
- * @hardcoded:	1 if a single channel/id/lun should be scanned, else 0
- * @hchannel:	channel to scan for hardcoded case
- * @hid:	target id to scan for hardcoded case
- * @hlun:	lun to scan for hardcoded case
- *
- * Description:
- *     If @hardcoded is 1, call scsi_scan_selected_lun to scan a single
- *     LUN; else, iterate and call scsi_scan_target to scan all possible
- *     target id's on all possible channels.
- **/
-void scan_scsis(struct Scsi_Host *shost, uint hardcoded, uint hchannel,
-		uint hid, uint hlun)
-{
-	if (hardcoded == 1) {
+	/*
+	 * The sdevscan host, channel, id and lun are filled in as
+	 * needed to scan.
+	 */
+	for (channel = 0; channel <= shost->max_channel; channel++) {
 		/*
-		 * XXX Overload hchannel/hid/hlun to figure out what to
-		 * scan, and use the standard scanning code rather than
-		 * this function - that way, an entire bus (or fabric), or
-		 * target id can be scanned. There are problems with queue
-		 * depth and the init/attach/finish that must be resolved
-		 * before (re-)scanning can handle finding more than one new
-		 * LUN.
+		 * XXX adapter drivers when possible (FCP, iSCSI)
+		 * could modify max_id to match the current max,
+		 * not the absolute max.
 		 *
-		 * For example, set hchannel 0 and hid to 5, and hlun to -1
-		 * in order to scan all LUNs on channel 0, target id 5.
-		 */
-		scsi_scan_selected_lun(shost, hchannel, hid, hlun);
-	} else {
-		Scsi_Device *sdevscan;
-		uint channel;
-		unsigned int id, order_id;
-
-		/*
-		 * The blk layer queue allocation is a bit expensive to
-		 * repeat for each channel and id - for FCP max_id is near
-		 * 255: each call to scsi_alloc_sdev() implies a call to
-		 * blk_init_queue, and then blk_init_free_list, where 2 *
-		 * queue_nr_requests requests are allocated. Don't do so
-		 * here for scsi_scan_selected_lun, since we end up
-		 * calling select_queue_depths with an extra Scsi_Device
-		 * on the host_queue list.
-		 */
-		sdevscan = scsi_alloc_sdev(shost, 0, 0, 0);
-		if (sdevscan == NULL)
-			return;
-		/*
-		 * The sdevscan host, channel, id and lun are filled in as
-		 * needed to scan.
+		 * XXX add a shost id iterator, so for example,
+		 * the FC ID can be the same as a target id
+		 * without a huge overhead of sparse id's.
 		 */
-		for (channel = 0; channel <= shost->max_channel; channel++) {
-			/*
-			 * XXX adapter drivers when possible (FCP, iSCSI)
-			 * could modify max_id to match the current max,
-			 * not the absolute max.
-			 *
-			 * XXX add a shost id iterator, so for example,
-			 * the FC ID can be the same as a target id
-			 * without a huge overhead of sparse id's.
-			 */
-			for (id = 0; id < shost->max_id; ++id) {
-				if (shost->reverse_ordering)
-					/*
-					 * Scan from high to low id.
-					 */
-					order_id = shost->max_id - id - 1;
-				else
-					order_id = id;
-				scsi_scan_target(sdevscan, shost, channel,
-						 order_id);
-			}
+		for (id = 0; id < shost->max_id; ++id) {
+			if (shost->reverse_ordering)
+				/*
+				 * Scan from high to low id.
+				 */
+				order_id = shost->max_id - id - 1;
+			else
+				order_id = id;
+			scsi_scan_target(sdevscan, shost, channel,
+					 order_id);
 		}
-		scsi_free_sdev(sdevscan);
 	}
+	scsi_free_sdev(sdevscan);
 }
