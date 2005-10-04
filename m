From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] 3ware: use scsi_scan_target()
Date: Mon, 03 Oct 2005 20:57:46 -0400
Message-ID: <4341D38A.40509@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020901080806010202010106"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:26274 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751175AbVJDA5u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 20:57:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

This is a multi-part message in MIME format.
--------------020901080806010202010106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This change updates the 3ware raid drivers to use scsi_scan_target(), 
rather than scsi_scan_host().  This is especially nice for 3w-xxxx, 
which does not support LUNs.  The device scan is a bit quicker and more 
direct, even if it is a tiny bit more code in the driver.

Patch untested.

--------------020901080806010202010106
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1992,7 +1992,7 @@ static int __devinit twa_probe(struct pc
 	struct Scsi_Host *host = NULL;
 	TW_Device_Extension *tw_dev;
 	u32 mem_addr;
-	int retval = -ENODEV;
+	int retval = -ENODEV, i;
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
@@ -2092,7 +2092,8 @@ static int __devinit twa_probe(struct pc
 	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
 
 	/* Finally, scan the host */
-	scsi_scan_host(host);
+	for (i = 0; i < TW_MAX_UNITS; i++)
+		scsi_scan_target(&host->shost_gendev, 0, i, ~0, 0);
 
 	if (twa_major == -1) {
 		if ((twa_major = register_chrdev (0, "twa", &twa_fops)) < 0)
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2315,7 +2315,7 @@ static int __devinit tw_probe(struct pci
 {
 	struct Scsi_Host *host = NULL;
 	TW_Device_Extension *tw_dev;
-	int retval = -ENODEV;
+	int retval = -ENODEV, i;
 
 	retval = pci_enable_device(pdev);
 	if (retval) {
@@ -2404,7 +2404,8 @@ static int __devinit tw_probe(struct pci
 	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
 
 	/* Finally, scan the host */
-	scsi_scan_host(host);
+	for (i = 0; i < TW_MAX_UNITS; i++)
+		scsi_scan_target(&host->shost_gendev, 0, i, 0, 0);
 
 	if (twe_major == -1) {
 		if ((twe_major = register_chrdev (0, "twe", &tw_fops)) < 0)

--------------020901080806010202010106--
