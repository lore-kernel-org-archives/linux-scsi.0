From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] give scsi_allocate_request a gfp_mask
Date: Mon, 25 Aug 2003 14:28:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825122852.GG15506@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:60827 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261830AbTHYM24 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:28:56 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

most callers really want GFP_KERNEL, not GFP_ATOMIC.


diff -Nru a/drivers/scsi/cpqfcTSinit.c b/drivers/scsi/cpqfcTSinit.c
--- a/drivers/scsi/cpqfcTSinit.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/cpqfcTSinit.c	Mon Aug 25 13:37:40 2003
@@ -603,7 +603,7 @@
 	    return -ENOMEM;
 	}
         // Now build a Scsi_Request to pass down...
-        ScsiPassThruReq = scsi_allocate_request(ScsiDev);
+        ScsiPassThruReq = scsi_allocate_request(ScsiDev, GFP_KERNEL);
 	if (ScsiPassThruReq == NULL) {
 		kfree(buf);
 		return -ENOMEM;
diff -Nru a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/gdth.c	Mon Aug 25 13:37:40 2003
@@ -4990,7 +4990,7 @@
         cmd.u.cache.DeviceNo = res.number;
 #if LINUX_VERSION_CODE >= 0x020503
         sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        srp  = scsi_allocate_request(sdev);
+        srp  = scsi_allocate_request(sdev, GFP_KERNEL);
         if (!srp)
             return -ENOMEM;
         srp->sr_cmd_len = 12;
@@ -5091,7 +5091,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020503
         sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        srp  = scsi_allocate_request(sdev);
+        srp  = scsi_allocate_request(sdev, GFP_KERNEL);
         if (!srp)
             return -ENOMEM;
         srp->sr_cmd_len = 12;
@@ -5164,7 +5164,7 @@
    
 #if LINUX_VERSION_CODE >= 0x020503
         sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        srp  = scsi_allocate_request(sdev);
+        srp  = scsi_allocate_request(sdev, GFP_KERNEL);
         if (!srp)
             return -ENOMEM;
         srp->sr_cmd_len = 12;
@@ -5253,7 +5253,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020503
         sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        srp  = scsi_allocate_request(sdev);
+        srp  = scsi_allocate_request(sdev, GFP_KERNEL);
         if (!srp)
             return -ENOMEM;
         srp->sr_cmd_len = 12;
@@ -5631,7 +5631,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020503
     sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-    srp  = scsi_allocate_request(sdev);
+    srp  = scsi_allocate_request(sdev, GFP_KERNEL);
     if (!srp)
         return;
     srp->sr_cmd_len = 12;
@@ -5727,7 +5727,7 @@
         TRACE2(("gdth_halt(): reset controller %d\n", hanum));
 #if LINUX_VERSION_CODE >= 0x020503
         sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        srp  = scsi_allocate_request(sdev);
+        srp  = scsi_allocate_request(sdev, GFP_KERNEL);
         if (!srp) {
 #if LINUX_VERSION_CODE >= 0x020100
             unregister_reboot_notifier(&gdth_notifier);
diff -Nru a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
--- a/drivers/scsi/gdth_proc.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/gdth_proc.c	Mon Aug 25 13:37:40 2003
@@ -44,7 +44,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020503
     sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-    scp  = scsi_allocate_request(sdev);
+    scp  = scsi_allocate_request(sdev, GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
     scp->sr_cmd_len = 12;
@@ -797,7 +797,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020503
     sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-    scp  = scsi_allocate_request(sdev);
+    scp  = scsi_allocate_request(sdev, GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
     scp->sr_cmd_len = 12;
diff -Nru a/drivers/scsi/osst.c b/drivers/scsi/osst.c
--- a/drivers/scsi/osst.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/osst.c	Mon Aug 25 13:37:40 2003
@@ -316,7 +316,7 @@
 	static   int   repeat = 0;
 #endif
 	if (SRpnt == NULL) {
-		if ((SRpnt = scsi_allocate_request(STp->device)) == NULL) {
+		if ((SRpnt = scsi_allocate_request(STp->device, GFP_ATOMIC)) == NULL) {
 			printk(KERN_ERR "%s:E: Can't get SCSI request.\n", tape_name(STp));
 			if (signal_pending(current))
 				(STp->buffer)->syscall_result = (-EINTR);
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/scsi.c	Mon Aug 25 13:37:40 2003
@@ -113,26 +113,21 @@
  *
  * Purpose:     Allocate a request descriptor.
  *
- * Arguments:   device    - device for which we want a request
+ * Arguments:   device		- device for which we want a request
+ *		gfp_mask	- allocation flags passed to kmalloc
  *
  * Lock status: No locks assumed to be held.  This function is SMP-safe.
  *
  * Returns:     Pointer to request block.
- *
- * Notes:       With the new queueing code, it becomes important
- *              to track the difference between a command and a
- *              request.  A request is a pending item in the queue that
- *              has not yet reached the top of the queue.
- *
- * XXX(hch):	Need to add a gfp_mask argument.
  */
-struct scsi_request *scsi_allocate_request(struct scsi_device *sdev)
+struct scsi_request *scsi_allocate_request(struct scsi_device *sdev,
+					   int gfp_mask)
 {
 	const int offset = ALIGN(sizeof(struct scsi_request), 4);
 	const int size = offset + sizeof(struct request);
 	struct scsi_request *sreq;
   
-	sreq = kmalloc(size, GFP_ATOMIC);
+	sreq = kmalloc(size, gfp_mask);
 	if (likely(sreq != NULL)) {
 		memset(sreq, 0, size);
 		sreq->sr_request = (struct request *)(((char *)sreq) + offset);
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/scsi_error.c	Mon Aug 25 13:37:40 2003
@@ -1339,7 +1339,7 @@
  **/
 static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
-	struct scsi_request *sreq = scsi_allocate_request(sdev);
+	struct scsi_request *sreq = scsi_allocate_request(sdev, GFP_KERNEL);
 
 	if (unlikely(!sreq)) {
 		printk(KERN_ERR "%s: request allocate failed,"
diff -Nru a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
--- a/drivers/scsi/scsi_ioctl.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/scsi_ioctl.c	Mon Aug 25 13:37:40 2003
@@ -98,7 +98,7 @@
 
 	SCSI_LOG_IOCTL(1, printk("Trying ioctl with scsi command %d\n", *cmd));
 
-	sreq = scsi_allocate_request(sdev);
+	sreq = scsi_allocate_request(sdev, GFP_KERNEL);
 	if (!sreq) {
 		printk("SCSI internal ioctl failed, no memory\n");
 		return -ENOMEM;
@@ -321,7 +321,7 @@
 		break;
 	}
 
-	sreq = scsi_allocate_request(sdev);
+	sreq = scsi_allocate_request(sdev, GFP_KERNEL);
         if (!sreq) {
                 result = -EINTR;
                 goto error;
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/scsi_lib.c	Mon Aug 25 13:37:40 2003
@@ -1454,7 +1454,7 @@
 		unsigned char *buffer, int len, int timeout, int retries,
 		struct scsi_mode_data *data)
 {
-	struct scsi_request *sreq = scsi_allocate_request(sdev);
+	struct scsi_request *sreq = scsi_allocate_request(sdev, GFP_KERNEL);
 	int ret;
 
 	if (!sreq)
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/scsi_scan.c	Mon Aug 25 13:37:40 2003
@@ -693,7 +693,7 @@
 	sdev = scsi_alloc_sdev(host, channel, id, lun);
 	if (!sdev)
 		goto out;
-	sreq = scsi_allocate_request(sdev);
+	sreq = scsi_allocate_request(sdev, GFP_ATOMIC);
 	if (!sreq)
 		goto out_free_sdev;
 	result = kmalloc(256, GFP_ATOMIC |
@@ -906,7 +906,7 @@
 	if (bflags & BLIST_NOLUN)
 		return 0;
 
-	sreq = scsi_allocate_request(sdev);
+	sreq = scsi_allocate_request(sdev, GFP_ATOMIC);
 	if (!sreq)
 		goto out;
 
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/sd.c	Mon Aug 25 13:37:40 2003
@@ -1174,7 +1174,7 @@
 	if (!sdp->online)
 		goto out;
 
-	sreq = scsi_allocate_request(sdp);
+	sreq = scsi_allocate_request(sdp, GFP_KERNEL);
 	if (!sreq) {
 		printk(KERN_WARNING "(sd_revalidate_disk:) Request allocation "
 		       "failure.\n");
@@ -1355,12 +1355,12 @@
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-       struct scsi_disk *sdkp;
+	struct scsi_disk *sdkp;
 	struct scsi_request *sreq;
 	int retries, res;
 
-       sdkp = dev_get_drvdata(dev);
-       if (!sdkp)
+	sdkp = dev_get_drvdata(dev);
+	if (!sdkp)
                return;         /* this can happen */
 
 	if (!sdp->online || !sdkp->WCE)
@@ -1369,7 +1369,7 @@
 	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: ",
 			sdkp->disk->disk_name);
 
-	sreq = scsi_allocate_request(sdp);
+	sreq = scsi_allocate_request(sdp, GFP_KERNEL);
 	if (!sreq) {
 		printk("FAILED\n  No memory for request\n");
 		return;
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/sg.c	Mon Aug 25 13:37:40 2003
@@ -680,7 +680,7 @@
 		sg_finish_rem_req(srp);
 		return -ENODEV;
 	}
-	SRpnt = scsi_allocate_request(sdp->device);
+	SRpnt = scsi_allocate_request(sdp->device, GFP_ATOMIC);
 	if (SRpnt == NULL) {
 		SCSI_LOG_TIMEOUT(1, printk("sg_write: no mem\n"));
 		sg_finish_rem_req(srp);
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/sr.c	Mon Aug 25 13:37:40 2003
@@ -599,7 +599,7 @@
 	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 	if (!buffer)
 		goto Enomem;
-	SRpnt = scsi_allocate_request(cd->device);
+	SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL);
 	if (!SRpnt)
 		goto Enomem;
 
diff -Nru a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/sr_ioctl.c	Mon Aug 25 13:37:40 2003
@@ -82,7 +82,7 @@
 	int result, err = 0, retries = 0;
 
 	SDev = cd->device;
-	SRpnt = scsi_allocate_request(SDev);
+	SRpnt = scsi_allocate_request(SDev, GFP_KERNEL);
         if (!SRpnt) {
                 printk(KERN_ERR "Unable to allocate SCSI request in sr_do_ioctl");
 		err = -ENOMEM;
diff -Nru a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	Mon Aug 25 13:37:40 2003
+++ b/drivers/scsi/st.c	Mon Aug 25 13:37:40 2003
@@ -374,7 +374,7 @@
 	unsigned char *bp;
 
 	if (SRpnt == NULL) {
-		SRpnt = scsi_allocate_request(STp->device);
+		SRpnt = scsi_allocate_request(STp->device, GFP_ATOMIC);
 		if (SRpnt == NULL) {
 			DEBC( printk(KERN_ERR "%s: Can't get SCSI request.\n",
 				     tape_name(STp)); );
diff -Nru a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
--- a/include/scsi/scsi_request.h	Mon Aug 25 13:37:40 2003
+++ b/include/scsi/scsi_request.h	Mon Aug 25 13:37:40 2003
@@ -45,7 +45,7 @@
  					   level driver) of this request */
 };
 
-extern struct scsi_request *scsi_allocate_request(struct scsi_device *);
+extern struct scsi_request *scsi_allocate_request(struct scsi_device *, int);
 extern void scsi_release_request(struct scsi_request *);
 extern void scsi_wait_req(struct scsi_request *, const void *cmnd,
 			  void *buffer, unsigned bufflen,
