From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sym53c416 check_region usage
Date: Mon, 31 May 2004 14:59:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040531125921.GA17037@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:30381 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263019AbUEaM7Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 May 2004 08:59:25 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

again, the init code could use some bigger rework, but let's stick to
the minimal fix until we have some testers.


--- 1.20/drivers/scsi/sym53c416.c	2003-09-26 01:35:39 +02:00
+++ edited/drivers/scsi/sym53c416.c	2004-05-31 14:18:12 +02:00
@@ -622,12 +622,13 @@
 	int ints[2];
 
 	ints[0] = 1;
-	for(; *base; base++)
-	{
-		if(!check_region(*base, IO_RANGE) && sym53c416_test(*base))
-		{
-			ints[1] = *base;
-			sym53c416_setup(NULL, ints);
+	for(; *base; base++) {
+		if (request_region(*base, IO_RANGE, ID)) {
+			if (sym53c416_test(*base)) {
+				ints[1] = *base;
+				sym53c416_setup(NULL, ints);
+			}
+			release_region(*base, IO_RANGE);
 		}
 	}
 }
@@ -702,44 +703,42 @@
 	sym53c416_probe();
 
 	/* Now we register and set up each host adapter found... */
-	for(count = 0, i = 0; i < host_index; i++)
-	{
-		if(!sym53c416_test(hosts[i].base))
+	for(count = 0, i = 0; i < host_index; i++) {
+		if (!request_region(hosts[i].base, IO_RANGE, ID))
+			continue;
+		if (!sym53c416_test(hosts[i].base)) {
 			printk(KERN_WARNING "No sym53c416 found at address 0x%03x\n", hosts[i].base);
-		else
-		{
-			if(hosts[i].irq == 0)
-			/* We don't have an irq yet, so we should probe for one */
-				if((hosts[i].irq = sym53c416_probeirq(hosts[i].base, hosts[i].scsi_id)) == 0)
-					printk(KERN_WARNING "IRQ autoprobing failed for sym53c416 at address 0x%03x\n", hosts[i].base);
-			if(hosts[i].irq && !check_region(hosts[i].base, IO_RANGE))
-			{
-				shpnt = scsi_register(tpnt, 0);
-				if(shpnt==NULL)
-					continue;
-				spin_lock_irqsave(&sym53c416_lock, flags);
-				/* Request for specified IRQ */
-				if(request_irq(hosts[i].irq, sym53c416_intr_handle, 0, ID, shpnt))
-				{
-					spin_unlock_irqrestore(&sym53c416_lock, flags);
-					printk(KERN_ERR "sym53c416: Unable to assign IRQ %d\n", hosts[i].irq);
-					scsi_unregister(shpnt);
-				}
-				else
-				{
-					/* Inform the kernel of our IO range */
-					request_region(hosts[i].base, IO_RANGE, ID);
-					shpnt->unique_id = hosts[i].base;
-					shpnt->io_port = hosts[i].base;
-					shpnt->n_io_port = IO_RANGE;
-					shpnt->irq = hosts[i].irq;
-					shpnt->this_id = hosts[i].scsi_id;
-					sym53c416_init(hosts[i].base, hosts[i].scsi_id);
-					count++;
-					spin_unlock_irqrestore(&sym53c416_lock, flags);
-				}
-			}
+			goto fail_release_region;
 		}
+
+		/* We don't have an irq yet, so we should probe for one */
+		if (!hosts[i].irq)
+			hosts[i].irq = sym53c416_probeirq(hosts[i].base, hosts[i].scsi_id);
+		if (!hosts[i].irq)
+			goto fail_release_region;
+	
+		shpnt = scsi_register(tpnt, 0);
+		if (!shpnt)
+			goto fail_release_region;
+		/* Request for specified IRQ */
+		if (request_irq(hosts[i].irq, sym53c416_intr_handle, 0, ID, shpnt))
+			goto fail_free_host;
+
+		spin_lock_irqsave(&sym53c416_lock, flags);
+		shpnt->unique_id = hosts[i].base;
+		shpnt->io_port = hosts[i].base;
+		shpnt->n_io_port = IO_RANGE;
+		shpnt->irq = hosts[i].irq;
+		shpnt->this_id = hosts[i].scsi_id;
+		sym53c416_init(hosts[i].base, hosts[i].scsi_id);
+		count++;
+		spin_unlock_irqrestore(&sym53c416_lock, flags);
+		continue;
+
+ fail_free_host:
+		scsi_unregister(shpnt);
+ fail_release_region:
+		release_region(hosts[i].base, IO_RANGE);
 	}
 	return count;
 }
