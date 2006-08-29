From: Martin Peschke <mp3@de.ibm.com>
Subject: [Resend] [Patch] cleanup: GFP_ATOMIC to GFP_KERNEL in scsi_scan.c
Date: Tue, 29 Aug 2006 15:56:23 +0200
Message-ID: <1156859783.3017.12.camel@dyn-9-152-230-71.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:3727 "EHLO
	mtagate6.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751385AbWH2N4a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Aug 2006 09:56:30 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.13.7/8.13.7) with ESMTP id k7TDuTkY045060
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 13:56:29 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k7TE0fs63219688
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 16:00:41 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7TDuTZL013537
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 15:56:29 +0200
Received: from dyn-9-152-230-71.boeblingen.de.ibm.com (dyn-9-152-230-71.boeblingen.de.ibm.com [9.152.230.71])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k7TDuTpB013534
	for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2006 15:56:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Unchanged, since no one has objected. Please consider applying it.
Patch is against scsi-misc-2.6 this time.

It seems to be safe to replace all 4 occurrences of GFP_ATOMIC in
scsi_scan.c by GFP_KERNEL. I found that calling code always held a mutex
(indicating process context) while not acquiring a spin_lock or such
inside the mutex sections and when using GFP_ATOMIC (see details below).

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
---

 scsi_scan.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a24d346..80f10ee 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -152,7 +152,7 @@ static struct scsi_device *scsi_alloc_sd
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
-		       GFP_ATOMIC);
+		       GFP_KERNEL);
 	if (!sdev)
 		goto out;
 
@@ -587,7 +587,7 @@ static int scsi_add_lun(struct scsi_devi
 	 * scanning run at their own risk, or supply a user level program
 	 * that can correctly scan.
 	 */
-	sdev->inquiry = kmalloc(sdev->inquiry_len, GFP_ATOMIC);
+	sdev->inquiry = kmalloc(sdev->inquiry_len, GFP_KERNEL);
 	if (sdev->inquiry == NULL) {
 		return SCSI_SCAN_NO_RESPONSE;
 	}
@@ -848,7 +848,7 @@ static int scsi_probe_and_add_lun(struct
 	if (!sdev)
 		goto out;
 
-	result = kmalloc(result_len, GFP_ATOMIC |
+	result = kmalloc(result_len, GFP_KERNEL |
 			((shost->unchecked_isa_dma) ? __GFP_DMA : 0));
 	if (!result)
 		goto out_free_sdev;
@@ -1159,7 +1159,7 @@ static int scsi_report_lun_scan(struct s
 	 * prevent us from finding any LUNs on this target.
 	 */
 	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
-	lun_data = kmalloc(length, GFP_ATOMIC |
+	lun_data = kmalloc(length, GFP_KERNEL |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!lun_data) {
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);


