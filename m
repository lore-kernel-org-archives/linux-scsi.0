From: malahal@us.ibm.com
Subject: [PATCH] AIC94XX: call tasklet_kill while unloading the module
Date: Wed, 18 Oct 2006 20:25:51 -0700
Message-ID: <20061019032551.GB19570@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:5772 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1423231AbWJSDZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 23:25:54 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k9J3PrSN025955
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 23:25:53 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k9J3Pre0280486
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 23:25:53 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k9J3PrFN016523
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 23:25:53 -0400
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.93])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k9J3Pqb1016509
	for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2006 23:25:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>

diff -r d134b26a8da8 drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c	Wed Oct 18 16:34:30 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_init.c	Wed Oct 18 18:21:40 2006 -0700
@@ -737,6 +737,11 @@ static void __devexit asd_pci_remove(str
 	/* XXX more here as needed */
 
 	free_irq(dev->irq, asd_ha);
+
+	/* We already disabled interrupts and freed the IRQ. Now, it is
+	 * safe to kill the tasklet that processes done list */
+	tasklet_kill(&asd_ha->seq.dl_tasklet);
+
 	if (use_msi)
 		pci_disable_msi(asd_ha->pcidev);
 	asd_turn_off_leds(asd_ha);
