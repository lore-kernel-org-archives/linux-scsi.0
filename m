From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 5/7 alloc a request_queue on each scsi_alloc_sdev call
Date: Mon, 24 Mar 2003 18:03:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030324180325.D15047@beaverton.ibm.com>
References: <20030324175337.A14957@beaverton.ibm.com> <20030324175422.A14996@beaverton.ibm.com> <20030324180227.A15047@beaverton.ibm.com> <20030324180247.B15047@beaverton.ibm.com> <20030324180304.C15047@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e35.co.us.ibm.com (8.12.8/8.12.2) with ESMTP id h2P26xgJ062390
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 21:06:59 -0500
Received: from localhost.localdomain (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.8/NCO/VER6.5) with ESMTP id h2P26wVR229608
	for <linux-scsi@vger.kernel.org>; Mon, 24 Mar 2003 19:06:58 -0700
Received: (from patman@localhost)
	by localhost.localdomain (8.11.2/8.11.6) id h2P23PF15153
	for linux-scsi@vger.kernel.org; Mon, 24 Mar 2003 18:03:25 -0800
Content-Disposition: inline
In-Reply-To: <20030324180304.C15047@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Mar 24, 2003 at 06:03:04PM -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Call scsi_alloc_queue each time we call scsi_alloc_sdev; call
scsi_free_queue each time we do not find backing LUN.

This code is less optimal, but leads to cleaner code, and the lock
split-up patch needs this change.

diff -purN -X /home/patman/dontdiff req_fn-cleanup-25/drivers/scsi/scsi_scan.c salloc_queue-25/drivers/scsi/scsi_scan.c
--- req_fn-cleanup-25/drivers/scsi/scsi_scan.c	Mon Mar 24 12:14:28 2003
+++ salloc_queue-25/drivers/scsi/scsi_scan.c	Mon Mar 24 12:15:05 2003
@@ -380,7 +380,7 @@ static void print_inquiry(unsigned char 
  *     Scsi_Device pointer, or NULL on failure.
  **/
 static struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *shost,
-	       	struct request_queue **q, uint channel, uint id, uint lun)
+	       	uint channel, uint id, uint lun)
 {
 	struct scsi_device *sdev, *device;
 
@@ -415,14 +415,9 @@ static struct scsi_device *scsi_alloc_sd
 	 */
 	sdev->borken = 1;
 
-	if (!q || *q == NULL) {
-		sdev->request_queue = scsi_alloc_queue(shost);
-		if (!sdev->request_queue)
-			goto out_free_dev;
-	} else {
-		sdev->request_queue = *q;
-		*q = NULL;
-	}
+	sdev->request_queue = scsi_alloc_queue(shost);
+	if (!sdev->request_queue)
+		goto out_free_dev;
 
 	sdev->request_queue->queuedata = sdev;
 	scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
@@ -462,10 +457,7 @@ static struct scsi_device *scsi_alloc_sd
 	return sdev;
 
 out_free_queue:
-	if (q && sdev->request_queue) {
-		*q = sdev->request_queue;
-		sdev->request_queue = NULL;
-	} else if (sdev->request_queue)
+	if (sdev->request_queue)
 		scsi_free_queue(sdev->request_queue);
 
 out_free_dev:
@@ -1282,15 +1274,15 @@ static int scsi_add_lun(Scsi_Device *sde
  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct Scsi_Host *host,
-		struct request_queue **q, uint channel, uint id, uint lun,
-		int *bflagsp, struct scsi_device **sdevp)
+		uint channel, uint id, uint lun, int *bflagsp,
+		struct scsi_device **sdevp)
 {
 	struct scsi_device *sdev;
 	struct scsi_request *sreq;
 	unsigned char *result;
 	int bflags, res = SCSI_SCAN_NO_RESPONSE;
 
-	sdev = scsi_alloc_sdev(host, q, channel, id, lun);
+	sdev = scsi_alloc_sdev(host, channel, id, lun);
 	if (!sdev)
 		goto out;
 	sreq = scsi_allocate_request(sdev);
@@ -1344,13 +1336,8 @@ static int scsi_probe_and_add_lun(struct
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (sdevp)
 			*sdevp = sdev;
-	} else {
-		if (q) {
-			*q = sdev->request_queue;
-			sdev->request_queue = NULL;
-		}
+	} else
 		scsi_free_sdev(sdev);
-	}
  out:
 	return res;
 }
@@ -1368,9 +1355,8 @@ static int scsi_probe_and_add_lun(struct
  *
  *     Modifies sdevscan->lun.
  **/
-static void scsi_sequential_lun_scan(struct Scsi_Host *shost,
-	       	struct request_queue **q, uint channel, uint id,
-	       	int bflags, int lun0_res, int scsi_level)
+static void scsi_sequential_lun_scan(struct Scsi_Host *shost, uint channel,
+		uint id, int bflags, int lun0_res, int scsi_level)
 {
 	unsigned int sparse_lun, lun, max_dev_lun;
 
@@ -1438,7 +1424,7 @@ static void scsi_sequential_lun_scan(str
 	 * sparse_lun.
 	 */
 	for (lun = 1; lun < max_dev_lun; ++lun)
-		if ((scsi_probe_and_add_lun(shost, q, channel, id, lun,
+		if ((scsi_probe_and_add_lun(shost, channel, id, lun,
 		      NULL, NULL) != SCSI_SCAN_LUN_PRESENT) && !sparse_lun)
 			return;
 }
@@ -1491,8 +1477,7 @@ static int scsilun_to_int(ScsiLun *scsil
  *     0: scan completed (or no memory, so further scanning is futile)
  *     1: no report lun scan, or not configured
  **/
-static int scsi_report_lun_scan(Scsi_Device *sdev, struct request_queue **q,
-		int bflags)
+static int scsi_report_lun_scan(Scsi_Device *sdev, int bflags)
 {
 #ifdef CONFIG_SCSI_REPORT_LUNS
 
@@ -1653,8 +1638,8 @@ static int scsi_report_lun_scan(Scsi_Dev
 		} else {
 			int res;
 
-			res = scsi_probe_and_add_lun(sdev->host, q,
-				sdev->channel, sdev->id, lun, NULL, NULL);
+			res = scsi_probe_and_add_lun(sdev->host, sdev->channel,
+				sdev->id, lun, NULL, NULL);
 			if (res == SCSI_SCAN_NO_RESPONSE) {
 				/*
 				 * Got some results, but now none, abort.
@@ -1682,8 +1667,7 @@ struct scsi_device *scsi_add_device(stru
 	struct scsi_device *sdev;
 	int error = -ENODEV, res;
 
-	res = scsi_probe_and_add_lun(shost, NULL, channel, id, lun,
-			NULL, &sdev);
+	res = scsi_probe_and_add_lun(shost, channel, id, lun, NULL, &sdev);
 	if (res == SCSI_SCAN_LUN_PRESENT)
 		error = scsi_attach_device(sdev);
 
@@ -1724,8 +1708,8 @@ int scsi_remove_device(struct scsi_devic
  *     First try a REPORT LUN scan, if that does not scan the target, do a
  *     sequential scan of LUNs on the target id.
  **/
-static void scsi_scan_target(struct Scsi_Host *shost, struct request_queue **q,
-			     unsigned int channel, unsigned int id)
+static void scsi_scan_target(struct Scsi_Host *shost, unsigned int channel,
+			     unsigned int id)
 {
 	int bflags = 0;
 	int res;
@@ -1741,14 +1725,14 @@ static void scsi_scan_target(struct Scsi
 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
-	res = scsi_probe_and_add_lun(shost, q, channel, id, 0, &bflags, &sdev);
+	res = scsi_probe_and_add_lun(shost, channel, id, 0, &bflags, &sdev);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
-		if (scsi_report_lun_scan(sdev, q, bflags) != 0)
+		if (scsi_report_lun_scan(sdev, bflags) != 0)
 			/*
 			 * The REPORT LUN did not scan the target,
 			 * do a sequential scan.
 			 */
-			scsi_sequential_lun_scan(shost, q, channel, id, bflags,
+			scsi_sequential_lun_scan(shost, channel, id, bflags,
 				       	res, sdev->scsi_level);
 	} else if (res == SCSI_SCAN_TARGET_PRESENT) {
 		/*
@@ -1757,7 +1741,7 @@ static void scsi_scan_target(struct Scsi
 		 * sequential lun scan with a bflags of SPARSELUN and
 		 * a default scsi level of SCSI_2
 		 */
-		scsi_sequential_lun_scan(shost, q, channel, id, BLIST_SPARSELUN,
+		scsi_sequential_lun_scan(shost, channel, id, BLIST_SPARSELUN,
 				SCSI_SCAN_TARGET_PRESENT, SCSI_2);
 	}
 }
@@ -1772,7 +1756,6 @@ static void scsi_scan_target(struct Scsi
  **/
 void scsi_scan_host(struct Scsi_Host *shost)
 {
-	struct request_queue *q = NULL;
 	uint channel, id, order_id;
 
 	/*
@@ -1797,12 +1780,9 @@ void scsi_scan_host(struct Scsi_Host *sh
 				order_id = shost->max_id - id - 1;
 			else
 				order_id = id;
-			scsi_scan_target(shost, &q, channel, order_id);
+			scsi_scan_target(shost, channel, order_id);
 		}
 	}
-
-	if (q)
-		scsi_free_queue(q);
 }
 
 void scsi_forget_host(struct Scsi_Host *shost)
@@ -1841,7 +1821,7 @@ struct scsi_device *scsi_get_host_dev(st
 {
 	struct scsi_device *sdev;
 
-	sdev = scsi_alloc_sdev(shost, NULL, 0, shost->this_id, 0);
+	sdev = scsi_alloc_sdev(shost, 0, shost->this_id, 0);
 	if (sdev) {
 		sdev->borken = 0;
 	}
