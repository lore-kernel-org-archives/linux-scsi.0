From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/3] Fix 3ware irq handling: correct IRQ_HANDLED
Date: Wed, 02 Mar 2005 02:20:34 -0500
Message-ID: <42256942.2050408@pobox.com>
References: <20050224015859.55191.qmail@web40910.mail.yahoo.com> <421D3D33.9060707@pobox.com> <20050226193255.GA6256@ime.usp.br> <4220D9DE.10904@pobox.com> <42234279.6030004@rtr.ca> <422568CF.3060307@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080408050501060404050406"
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:57565 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262209AbVCBHUs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 02:20:48 -0500
In-Reply-To: <422568CF.3060307@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, linuxraid@amcc.com
Cc: Mark Lord <liml@rtr.ca>

This is a multi-part message in MIME format.
--------------080408050501060404050406
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Only indicate irq-handled if that is really true

Driver currently returns IRQ_HANDLED for all interrupts.  Fix this.

Signed-off-by: Jeff Garzik <jgarzik@pobox.com>

--------------080408050501060404050406
Content-Type: text/plain;
 name="patch.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.1"

diff -Nru a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c	2005-03-02 02:14:42 -05:00
+++ b/drivers/scsi/3w-9xxx.c	2005-03-02 02:14:42 -05:00
@@ -1176,14 +1176,14 @@
 	/* See if the interrupt matches this instance */
 	if (tw_dev->tw_pci_dev->irq == (unsigned int)irq) {
 
-		handled = 1;
-
 		/* Read the registers */
 		status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));
 
 		/* Check if this is our interrupt, otherwise bail */
 		if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
 			goto twa_interrupt_bail;
+
+		handled = 1;
 
 		/* Check controller for errors */
 		if (twa_check_bits(status_reg_value)) {
diff -Nru a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c	2005-03-02 02:14:42 -05:00
+++ b/drivers/scsi/3w-xxxx.c	2005-03-02 02:14:42 -05:00
@@ -2091,14 +2091,14 @@
 	/* See if the interrupt matches this instance */
 	if (tw_dev->tw_pci_dev->irq == (unsigned int)irq) {
 
-		handled = 1;
-
 		/* Read the registers */
 		status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 
 		/* Check if this is our interrupt, otherwise bail */
 		if (!(status_reg_value & TW_STATUS_VALID_INTERRUPT))
 			goto tw_interrupt_bail;
+
+		handled = 1;
 
 		/* Check controller for errors */
 		if (tw_check_bits(status_reg_value)) {

--------------080408050501060404050406--
