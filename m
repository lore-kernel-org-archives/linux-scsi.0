From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 2/3] Fix 3ware irq handling: remove bogus test
Date: Wed, 02 Mar 2005 02:21:35 -0500
Message-ID: <4225697F.3020008@pobox.com>
References: <20050224015859.55191.qmail@web40910.mail.yahoo.com> <421D3D33.9060707@pobox.com> <20050226193255.GA6256@ime.usp.br> <4220D9DE.10904@pobox.com> <42234279.6030004@rtr.ca> <422568CF.3060307@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030703050505070208030806"
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:63965 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262207AbVCBHVt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 02:21:49 -0500
In-Reply-To: <422568CF.3060307@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, linuxraid@amcc.com
Cc: Mark Lord <liml@rtr.ca>

This is a multi-part message in MIME format.
--------------030703050505070208030806
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Remove bogus irq test.

Driver tested irq handler's "irq" argument against the PCI device's
pci_dev->irq value, a test which would always succeed.

Change this to "if (1)" to avoid re-indenting the [huge]
interrupt handling code.

Signed-off-by: Jeff Garzik <jgarzik@pobox.com>


--------------030703050505070208030806
Content-Type: text/plain;
 name="patch.2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.2"

diff -Nru a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c	2005-03-02 02:14:49 -05:00
+++ b/drivers/scsi/3w-9xxx.c	2005-03-02 02:14:49 -05:00
@@ -1173,8 +1173,7 @@
 	/* Get the per adapter lock */
 	spin_lock(tw_dev->host->host_lock);
 
-	/* See if the interrupt matches this instance */
-	if (tw_dev->tw_pci_dev->irq == (unsigned int)irq) {
+	if (1) {
 
 		/* Read the registers */
 		status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));
diff -Nru a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c	2005-03-02 02:14:49 -05:00
+++ b/drivers/scsi/3w-xxxx.c	2005-03-02 02:14:49 -05:00
@@ -2088,8 +2088,7 @@
 	/* Get the host lock for io completions */
 	spin_lock(tw_dev->host->host_lock);
 
-	/* See if the interrupt matches this instance */
-	if (tw_dev->tw_pci_dev->irq == (unsigned int)irq) {
+	if (1) {
 
 		/* Read the registers */
 		status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));

--------------030703050505070208030806--
