From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch] qlogic: free irq in pcmcia driver
Date: Sun, 26 Oct 2003 11:38:26 -0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031026133825.GB470@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="kORqDWCi7qDJ0mEj"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:40458 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S263128AbTJZNj3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Oct 2003 08:39:29 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-- 
aris


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="qlogic-pcmcia_free_irq.patch"

--- linux/drivers/scsi/pcmcia/qlogic_stub.c.orig	2003-10-23 21:26:11.000000000 -0200
+++ linux/drivers/scsi/pcmcia/qlogic_stub.c	2003-10-24 11:32:58.000000000 -0200
@@ -284,6 +284,7 @@
 	CardServices(ReleaseConfiguration, link->handle);
 	CardServices(ReleaseIO, link->handle, &link->io);
 	CardServices(ReleaseIRQ, link->handle, &link->irq);
+	free_irq(info->host->irq, info->host);
 
 	scsi_host_put(info->host);
 

--kORqDWCi7qDJ0mEj--
