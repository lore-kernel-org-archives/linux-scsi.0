From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/2] cciss: fix regression in procfs display fw version, obsoletes previous patch 2 of 2
Date: Thu, 16 Oct 2008 16:50:16 -0500
Message-ID: <20081016215016.GB25704@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:7504 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369AbYJPVuS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 17:50:18 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, JensAxboejens.axboe@oracle.com
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>


Patch 2 of 2

This patch obsoletes patch 2/2 from yesterday. It fixes a regression in
procfs where the controller firmware version is not displayed. The previous
patch also addressed the problem but the code would be called whenever
anything changed on the array such as the number of logical volumes, etc.
This patch only gets called once for each controller.
Please consider this for inclusion.

Signed-of-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0f367b1..efa5414 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3404,7 +3404,8 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	int i;
 	int j = 0;
 	int rc;
-	int dac;
+	int dac, return_code;
+	InquiryData_struct *inq_buff = NULL;
 
 	i = alloc_cciss_hba();
 	if (i < 0)
@@ -3510,6 +3511,25 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 	/* Turn the interrupts on so we can service requests */
 	hba[i]->access.set_intr_mask(hba[i], CCISS_INTR_ON);
 
+	/* Get the firmware version */ 
+	inq_buff = kzalloc(sizeof(InquiryData_struct), GFP_KERNEL);
+        if (inq_buff == NULL) {
+                printk(KERN_ERR "cciss: out of memory\n");
+                return ENOMEM;
+        }
+
+	return_code = sendcmd_withirq(CISS_INQUIRY, i, inq_buff, 
+		sizeof(InquiryData_struct), 0, 0 ,0, TYPE_CMD);
+	if (return_code == IO_OK) {
+		hba[i]->firm_ver[0] = inq_buff->data_byte[32];
+		hba[i]->firm_ver[1] = inq_buff->data_byte[33];
+		hba[i]->firm_ver[2] = inq_buff->data_byte[34];
+		hba[i]->firm_ver[3] = inq_buff->data_byte[35];
+	} else {	 /* send command failed */
+		printk(KERN_WARNING "cciss: unable to determine firmware"
+			" version of controller\n");
+	}
+
 	cciss_procinit(i);
 
 	hba[i]->cciss_max_sectors = 2048;
