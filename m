From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] move scsi_add_host back to where it belongs in aacraid
Date: Mon, 20 Sep 2004 17:37:35 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040920153735.GA27741@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:38094 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266704AbUITPhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 11:37:40 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi@vger.kernel.org

looks like you applied a premature version of the last aacraid patch.
This one moves the scsi_add_host back so it's not called before the
driver is ready to accept queued commands.

Btw, any chance we can get the performance improvements Mark Salyzyn
mentioned on OLS merged into the mainline driver?


--- 1.39/drivers/scsi/aacraid/linit.c	2004-09-15 21:55:40 +02:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-09-19 16:35:54 +02:00
@@ -579,10 +579,6 @@
 	for (container = 0; container < MAXIMUM_NUM_CONTAINERS; container++)
 		fsa_dev_ptr->devname[container][0] = '\0';
 
-	error = scsi_add_host(shost, &pdev->dev);
-	if (error)
-		goto out_free_fibs;
-
 	if ((*aac_drivers[index].init)(aac))
 		goto out_free_fibs;
 
@@ -619,12 +615,25 @@
 	shost->max_lun = AAC_MAX_LUN;
 
 	pci_set_drvdata(pdev, shost);
+
+	error = scsi_add_host(shost, &pdev->dev);
+	if (error)
+		goto out_deinit;
 	scsi_scan_host(shost);
 
 	return 0;
 
+out_deinit:
+	kill_proc(aac->thread_pid, SIGKILL, 0);
+	wait_for_completion(&aac->aif_completion);
+
+	aac_send_shutdown(aac);
+	fib_map_free(aac);
+	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
+	kfree(aac->queues);
+	free_irq(pdev->irq, aac);
+	iounmap((void * )aac->regs.sa);
  out_free_fibs:
-	scsi_remove_host(shost);
 	kfree(aac->fibs);
  out_free_host:
 	scsi_host_put(shost);
