From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: [PATCH] prevent sym53c8xx SMP deadlock (2.4)
Date: Mon, 2 Jun 2003 12:36:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000c01c32925$27d40140$e0019d89@cybernetics.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:54541 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S263802AbTFBQXY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2003 12:23:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: groudier@free.fr
Cc: linux-scsi@vger.kernel.org

Ok, so here is the cheesy hack that I am using to get sym53c8xx to load on
my SMP system without locking up.  Of course this patch is a piece of crap,
and no one should consider merging it, but it does fix the deadlock on my
SMP system.  I am posting this since I have not received any replies to my
previous message on the subject dated 5/27/2003.

Anthony J. Battersby
Cybernetics

--- drivers/scsi/sym53c8xx_2/sym_glue.c.orig	Mon Jun  2 09:25:20 2003
+++ drivers/scsi/sym53c8xx_2/sym_glue.c	Mon Jun  2 09:34:46 2003
@@ -224,15 +224,43 @@
 {
 	u_long page_base	= ((u_long) base) & PAGE_MASK;
 	u_long page_offs	= ((u_long) base) - page_base;
-	u_long page_remapped	= (u_long) ioremap(page_base, page_offs+size);
+	u_long page_remapped;
+	int io_request_lock_held = spin_is_locked(&io_request_lock);
+	unsigned long flags = 0;
+
+	if (io_request_lock_held) {
+		save_flags(flags);
+		spin_unlock_irq(&io_request_lock);
+	}
+
+	page_remapped = (u_long) ioremap(page_base, page_offs+size);
+
+	if (io_request_lock_held) {
+		restore_flags(flags);
+		spin_lock(&io_request_lock);
+	}

 	return page_remapped? (page_remapped + page_offs) : 0UL;
 }

 static void __init pci_unmap_mem(u_long vaddr, u_long size)
 {
-	if (vaddr)
+	if (vaddr) {
+		int io_request_lock_held = spin_is_locked(&io_request_lock);
+		unsigned long flags = 0;
+
+		if (io_request_lock_held) {
+			save_flags(flags);
+			spin_unlock_irq(&io_request_lock);
+		}
+
 		iounmap((void *) (vaddr & PAGE_MASK));
+
+		if (io_request_lock_held) {
+			restore_flags(flags);
+			spin_lock(&io_request_lock);
+		}
+	}
 }
 #endif


