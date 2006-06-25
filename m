From: akpm@osdl.org
Subject: [patch 16/26] random: remove redundant SA_SAMPLE_RANDOM from NinjaSCSI
Date: Sun, 25 Jun 2006 01:58:54 -0700
Message-ID: <200606250858.k5P8wsYt021228@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:21653 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932093AbWFYI7B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 04:59:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, mpm@selenic.com


From: Matt Mackall <mpm@selenic.com>

The scsi layer is already calling add_disk_randomness in scsi_end_request.

ps: ninjas rule!

Signed-off-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/nsp32.c         |    3 +--
 drivers/scsi/pcmcia/nsp_cs.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/nsp32.c~random-remove-redundant-sa_sample_random-from-ninjascsi drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c~random-remove-redundant-sa_sample_random-from-ninjascsi
+++ a/drivers/scsi/nsp32.c
@@ -2866,8 +2866,7 @@ static int nsp32_detect(struct scsi_host
 	 */
 	nsp32_do_bus_reset(data);
 
-	ret = request_irq(host->irq, do_nsp32_isr,
-			  SA_SHIRQ | SA_SAMPLE_RANDOM, "nsp32", data);
+	ret = request_irq(host->irq, do_nsp32_isr, SA_SHIRQ, "nsp32", data);
 	if (ret < 0) {
 		nsp32_msg(KERN_ERR, "Unable to allocate IRQ for NinjaSCSI32 "
 			  "SCSI PCI controller. Interrupt: %d", host->irq);
diff -puN drivers/scsi/pcmcia/nsp_cs.c~random-remove-redundant-sa_sample_random-from-ninjascsi drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c~random-remove-redundant-sa_sample_random-from-ninjascsi
+++ a/drivers/scsi/pcmcia/nsp_cs.c
@@ -1623,7 +1623,7 @@ static int nsp_cs_probe(struct pcmcia_de
 	/* Interrupt handler */
 	link->irq.Handler	 = &nspintr;
 	link->irq.Instance       = info;
-	link->irq.Attributes     |= (SA_SHIRQ | SA_SAMPLE_RANDOM);
+	link->irq.Attributes     |= SA_SHIRQ;
 
 	/* General socket configuration */
 	link->conf.Attributes	 = CONF_ENABLE_IRQ;
_
