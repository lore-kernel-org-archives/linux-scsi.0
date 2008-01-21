From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: INITIO scsi driver fails to work properly
Date: Mon, 21 Jan 2008 22:20:37 +0000
Message-ID: <20080121222037.3d8b46a1@lxorguk.ukuu.org.uk>
References: <1200070903.3286.28.camel@localhost.localdomain>
	<9f00bd9d0801130428s5e4c034apf21052b918470f99@mail.gmail.com>
	<1200410166.9273.4.camel@localhost.localdomain>
	<20080116145916A.fujita.tomonori@lab.ntt.co.jp>
	<1200495471.3136.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50548 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754544AbYAUW1J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jan 2008 17:27:09 -0500
In-Reply-To: <1200495471.3136.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, psybases@gmail.com, linux-scsi@vger.kernel.org, cebbert@redhat.com, bharrosh@panasas.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org

Ok my attempt to get the card failed so we are going to have to do this
the hard way. See where this patch crashes and what it prints

(On top of the other patches)

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/drivers/scsi/initio.c linux-2.6.24-rc8-mm1/drivers/scsi/initio.c
--- linux.vanilla-2.6.24-rc8-mm1/drivers/scsi/initio.c	2008-01-19 14:22:43.000000000 +0000
+++ linux-2.6.24-rc8-mm1/drivers/scsi/initio.c	2008-01-21 14:54:48.000000000 +0000
@@ -2537,10 +2537,12 @@
 	struct Scsi_Host *dev = dev_id;
 	unsigned long flags;
 	int r;
-	
+
+	printk("ISR\n");	
 	spin_lock_irqsave(dev->host_lock, flags);
 	r = initio_isr((struct initio_host *)dev->hostdata);
 	spin_unlock_irqrestore(dev->host_lock, flags);
+	printk("ISR DONE %d\n", r);
 	if (r)
 		return IRQ_HANDLED;
 	else
@@ -2643,6 +2645,7 @@
 	struct initio_host *host = (struct initio_host *) cmd->device->host->hostdata;
 	struct scsi_ctrl_blk *cmnd;
 
+	printk("SCB QUEUE\n");
 	cmd->scsi_done = done;
 
 	cmnd = initio_alloc_scb(host);
@@ -2650,7 +2653,9 @@
 		return SCSI_MLQUEUE_HOST_BUSY;
 
 	initio_build_scb(host, cmnd, cmd);
+	printk("SCB EXEC\n");
 	initio_exec_scb(host, cmnd);
+	printk("SCB EXEC DONE\n");
 	return 0;
 }
 
@@ -2766,6 +2771,8 @@
 	struct scsi_cmnd *cmnd;	/* Pointer to SCSI request block */
 	struct initio_host *host;
 	struct scsi_ctrl_blk *cblk;
+	
+	printk("SCB POST\n");
 
 	host = (struct initio_host *) host_mem;
 	cblk = (struct scsi_ctrl_blk *) cblk_mem;
@@ -2934,9 +2941,11 @@
 
 	pci_set_drvdata(pdev, shost);
 
+	printk("SAH\n");
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
 		goto out_free_irq;
+	printk("SSH\n");
 	scsi_scan_host(shost);
 	return 0;
 out_free_irq:
