From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] scsi_scan: Convert GFP_ATOMIC to GFP_KERNEL
Date: Wed, 20 Feb 2008 11:10:30 -0700
Message-ID: <20080220181029.GC27736@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38542 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857AbYBTSKb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2008 13:10:31 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


There is no need to allocate this memory atomically.  There is no problem
with sleeping during a bus scan, and it's actually causing problems
for libata.

Also remove the GFP_DMA flag.  If it's needed, the block layer will
bounce-buffer it.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 1dc165a..98c66bd 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -242,7 +242,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	extern void scsi_evt_thread(struct work_struct *work);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
-		       GFP_ATOMIC);
+		       GFP_KERNEL);
 	if (!sdev)
 		goto out;
 
@@ -747,7 +747,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 */
 	sdev->inquiry = kmemdup(inq_result,
 				max_t(size_t, sdev->inquiry_len, 36),
-				GFP_ATOMIC);
+				GFP_KERNEL);
 	if (sdev->inquiry == NULL)
 		return SCSI_SCAN_NO_RESPONSE;
 
@@ -1010,8 +1010,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (!sdev)
 		goto out;
 
-	result = kmalloc(result_len, GFP_ATOMIC |
-			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
+	result = kmalloc(result_len, GFP_KERNEL);
 	if (!result)
 		goto out_free_sdev;
 
@@ -1328,8 +1327,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	 * prevent us from finding any LUNs on this target.
 	 */
 	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
-	lun_data = kmalloc(length, GFP_ATOMIC |
-			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
+	lun_data = kmalloc(length, GFP_KERNEL);
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 		goto out;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
