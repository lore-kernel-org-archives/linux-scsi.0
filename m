From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch] qlogic: remove "bad hack"
Date: Thu, 23 Oct 2003 23:18:29 -0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031024011829.GG474@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0rSojgWGcpz+ezC3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:46605 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261914AbTJXBTc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Oct 2003 21:19:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>


--0rSojgWGcpz+ezC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi,
	please confirm this. i noticed that __qlogic_detect doesn't call
request_region() for the pcmcia case and the region remains free.

-- 
aris


--0rSojgWGcpz+ezC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-pcmcia_dont_release_region.patch"

--- linux/drivers/scsi/pcmcia/qlogic_stub.c.orig	2003-10-22 22:31:05.000000000 -0200
+++ linux/drivers/scsi/pcmcia/qlogic_stub.c	2003-10-22 22:31:36.000000000 -0200
@@ -240,9 +240,6 @@
 		outb(0x04, link->io.BasePort1 + 0xd);
 	}
 
-	/* A bad hack... */
-	release_region(link->io.BasePort1, link->io.NumPorts1);
-
 	/* The KXL-810AN has a bigger IO port window */
 	if (link->io.NumPorts1 == 32)
 		qlogicfas_preset(link->io.BasePort1 + 16, link->irq.AssignedIRQ);

--0rSojgWGcpz+ezC3--
