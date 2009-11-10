From: Dan Carpenter <error27@gmail.com>
Subject: [patch] fix use after kfree() bugs in dpt_i2o.c
Date: Tue, 10 Nov 2009 10:50:12 +0200 (SAST)
Message-ID: <alpine.DEB.2.00.0911091502110.28271@bicker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56794 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbZKJIwc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2009 03:52:32 -0500
Received: by ewy3 with SMTP id 3so3995426ewy.37
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2009 00:52:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org

I re-orderred things a bit.

All four bugs were found by smatch (http://repo.or.cz/w/smatch.git), but I 
had to wade through a gazillion false positives as well so smatch still 
sucks.  Compile tested.

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/scsi/dpt_i2o.c	2009-11-07 22:19:42.000000000 +0200
+++ devel/drivers/scsi/dpt_i2o.c	2009-11-07 22:31:21.000000000 +0200
@@ -189,6 +189,7 @@
 {
 	struct pci_dev *pDev = NULL;
 	adpt_hba* pHba;
+	adpt_hba* next;
 
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
@@ -206,7 +207,8 @@
 	}
 
 	/* In INIT state, Activate IOPs */
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		// Activate does get status , init outbound, and get hrt
 		if (adpt_i2o_activate_hba(pHba) < 0) {
 			adpt_i2o_delete_hba(pHba);
@@ -243,7 +245,8 @@
 	PDEBUG("HBA's in OPERATIONAL state\n");
 
 	printk("dpti: If you have a lot of devices this could take a few minutes.\n");
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		printk(KERN_INFO"%s: Reading the hardware resource table.\n", pHba->name);
 		if (adpt_i2o_lct_get(pHba) < 0){
 			adpt_i2o_delete_hba(pHba);
@@ -263,7 +266,8 @@
 		adpt_sysfs_class = NULL;
 	}
 
-	for (pHba = hba_chain; pHba; pHba = pHba->next) {
+	for (pHba = hba_chain; pHba; pHba = next) {
+		next = pHba->next;
 		if (adpt_scsi_host_alloc(pHba, sht) < 0){
 			adpt_i2o_delete_hba(pHba);
 			continue;
@@ -1229,11 +1233,10 @@
 		}
 	}
 	pci_dev_put(pHba->pDev);
-	kfree(pHba);
-
 	if (adpt_sysfs_class)
 		device_destroy(adpt_sysfs_class,
 				MKDEV(DPTI_I2O_MAJOR, pHba->unit));
+	kfree(pHba);
 
 	if(hba_count <= 0){
 		unregister_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER);   
