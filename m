From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] Re: GFP_ATOMIC allocations...
Date: Fri, 30 Aug 2002 14:55:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020830145517.A27603@eng2.beaverton.ibm.com>
References: <patmans@us.ibm.com> <200208301646.g7UGk2c15401@localhost.localdomain> <20020830145811.H30927@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020830145811.H30927@redhat.com>; from dledford@redhat.com on Fri, Aug 30, 2002 at 02:58:11PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, zaitcev@redhat.com

On Fri, Aug 30, 2002 at 02:58:11PM -0400, Doug Ledford wrote:
> On Fri, Aug 30, 2002 at 11:46:02AM -0500, James Bottomley wrote:
> > What about, instead of Pete's patch, changing the GFP_ATOMIC to GFP_KERNEL and 
> > adding a BUG_ON(in_interrupt()) at the top and see who sends back bug 
> > reports...

How about with printk instead of BUG_ON? BUG_ON is better in the
long run, but I would rather printk for now.

Here's the patch against 2.5.32:

--- 1.25/drivers/scsi/scsi_scan.c	Tue Aug 27 15:36:34 2002
+++ edited/drivers/scsi/scsi_scan.c	Fri Aug 30 14:21:53 2002
@@ -502,7 +502,7 @@
 {
 	Scsi_Device *sdev;
 
-	sdev = (Scsi_Device *) kmalloc(sizeof(Scsi_Device), GFP_ATOMIC);
+	sdev = (Scsi_Device *) kmalloc(sizeof(Scsi_Device), GFP_KERNEL);
 	if (sdev == NULL)
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 	else {
@@ -616,7 +616,7 @@
 	int max_lgth = 255;
 
 retry:
-	evpd_page = kmalloc(max_lgth, GFP_ATOMIC |
+	evpd_page = kmalloc(max_lgth, GFP_KERNEL |
 			      (sdev->host->unchecked_isa_dma) ?
 			      GFP_DMA : 0);
 	if (!evpd_page) {
@@ -875,7 +875,7 @@
 	int max_lgth = 255;
 
 retry:
-	id_page = kmalloc(max_lgth, GFP_ATOMIC |
+	id_page = kmalloc(max_lgth, GFP_KERNEL |
 			      (sdev->host->unchecked_isa_dma) ?
 			      GFP_DMA : 0);
 	if (!id_page) {
@@ -982,7 +982,7 @@
 	int max_lgth = 255;
 
  retry:
-	serialnumber_page = kmalloc(max_lgth, GFP_ATOMIC |
+	serialnumber_page = kmalloc(max_lgth, GFP_KERNEL |
 			      (sdev->host->unchecked_isa_dma) ?
 			      GFP_DMA : 0);
 	if (!serialnumber_page) {
@@ -1337,7 +1337,7 @@
 	 * that can correctly scan.
 	 */
 	sdev->inquiry_len = sdevscan->inquiry_len;
-	sdev->inquiry = kmalloc(sdev->inquiry_len, GFP_ATOMIC);
+	sdev->inquiry = kmalloc(sdev->inquiry_len, GFP_KERNEL);
 	if (sdev->inquiry == NULL) {
 		scsi_free_sdev(sdev);
 		return SCSI_SCAN_NO_RESPONSE;
@@ -1521,7 +1521,7 @@
 	 * The sreq is for use only with sdevscan.
 	 */
 
-	scsi_result = kmalloc(256, GFP_ATOMIC |
+	scsi_result = kmalloc(256, GFP_KERNEL |
 			      (sdevscan->host->unchecked_isa_dma) ?
 			      GFP_DMA : 0);
 	if (scsi_result == NULL)
@@ -1763,7 +1763,7 @@
 	 * prevent us from finding any LUNs on this target.
 	 */
 	length = (max_scsi_report_luns + 1) * sizeof(ScsiLun);
-	lun_data = (ScsiLun *) kmalloc(length, GFP_ATOMIC |
+	lun_data = (ScsiLun *) kmalloc(length, GFP_KERNEL |
 					   (sdevscan->host->unchecked_isa_dma ?
 					    GFP_DMA : 0));
 	if (lun_data == NULL) {
@@ -2053,6 +2053,9 @@
 void scan_scsis(struct Scsi_Host *shost, uint hardcoded, uint hchannel,
 		uint hid, uint hlun)
 {
+	if (in_interrupt())
+		printk(KERN_ERR "scsi: scanning while in interrupt context!\n");
+
 	if (hardcoded == 1) {
 		/*
 		 * XXX Overload hchannel/hid/hlun to figure out what to
