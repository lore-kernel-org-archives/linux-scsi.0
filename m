From: Martin Peschke <mp3@de.ibm.com>
Subject: [Patch] cleanup: GFP_ATOMIC to GFP_KERNEL in scsi_scan.c
Date: Mon, 21 Aug 2006 21:07:53 +0200
Message-ID: <1156187273.2924.12.camel@dyn-9-152-230-71.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:51751 "EHLO
	mtagate5.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750736AbWHUTH4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 15:07:56 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate5.uk.ibm.com (8.13.7/8.13.7) with ESMTP id k7LJ7tSE077176
	for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2006 19:07:55 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7LJ9prC130670
	for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2006 20:09:51 +0100
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7LJ7t8V024465
	for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2006 20:07:55 +0100
Received: from dyn-9-152-230-71.boeblingen.de.ibm.com (dyn-9-152-230-71.boeblingen.de.ibm.com [9.152.230.71])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7LJ7t8R024462
	for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2006 20:07:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

It seems to be safe to replace all 4 occurrences of GFP_ATOMIC in
scsi_scan.c by GFP_KERNEL. I found that calling code always held a mutex
(indicating process context) while not acquiring a spin_lock or such
inside the mutex sections and when using GFP_ATOMIC (see details below).

http://marc.theaimsgroup.com/?l=linux-scsi&m=115522223917634&w=2
indicates that these occurrences of GFP_ATOMIC are just there for
historical reasons.

Patch ist against 2.6.18-rc4-mm2. Please consider applying this cleanup.
It didn't break my test machine with 3 SCSI disks attached.

kzalloc(..., GFP_ATOMIC) in scsi_alloc_sdev()
        scsi_get_host_dev()
                => holds mutex
        scsi_report_lun_scan()
                __scsi_scan_target()
                        scsi_scan_target()
                                => holds mutex
                        scsi_scan_channel()
                                scsi_scan_host_selected()
                                        => holds mutex
        scsi_probe_and_add_lun()
                scsi_sequential_lun_scan()
                        __scsi_scan_target()
                                ... => holds mutex (see above)
                scsi_report_lun_scan()
                        ... => holds mutex (see above)
                __scsi_add_device()
                        => holds mutex
                __scsi_scan_target()
                        ... => holds mutex (see above)

kmalloc(..., GFP_ATOMIC) in scsi_add_lun()
        scsi_probe_and_add_lun()
                ... => holds mutex (see above)

kmalloc(..., GFP_ATOMIC) in scsi_probe_and_add_lun()
        ... => holds mutex (see above)

kmalloc(..., GFP_ATOMIC) in scsi_report_lun_scan()
        ... => holds mutex (see above)

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 scsi_scan.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -ur a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2006-08-21 20:10:26.000000000 +0200
+++ b/drivers/scsi/scsi_scan.c	2006-08-21 20:07:57.000000000 +0200
@@ -205,7 +205,7 @@
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
-		       GFP_ATOMIC);
+		       GFP_KERNEL);
 	if (!sdev)
 		goto out;
 
@@ -640,7 +640,7 @@
 	 * scanning run at their own risk, or supply a user level program
 	 * that can correctly scan.
 	 */
-	sdev->inquiry = kmalloc(sdev->inquiry_len, GFP_ATOMIC);
+	sdev->inquiry = kmalloc(sdev->inquiry_len, GFP_KERNEL);
 	if (sdev->inquiry == NULL) {
 		return SCSI_SCAN_NO_RESPONSE;
 	}
@@ -898,7 +898,7 @@
 	if (!sdev)
 		goto out;
 
-	result = kmalloc(result_len, GFP_ATOMIC |
+	result = kmalloc(result_len, GFP_KERNEL |
 			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
 	if (!result)
 		goto out_free_sdev;
@@ -1194,7 +1194,7 @@
 	 * prevent us from finding any LUNs on this target.
 	 */
 	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
-	lun_data = kmalloc(length, GFP_ATOMIC |
+	lun_data = kmalloc(length, GFP_KERNEL |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);


