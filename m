From: Brian King <brking@us.ibm.com>
Subject: [PATCH] sym53c8xx_2 pci_remove cleanup
Date: Wed, 08 Oct 2003 16:17:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F847EEB.4060306@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000309060304030404030403"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:6337 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261784AbTJHVRk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2003 17:17:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>

This is a multi-part message in MIME format.
--------------000309060304030404030403
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


This is a patch to the sym2 driver to properly cleanup midlayer 
resources both on module unload and pci hot remove.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------000309060304030404030403
Content-Type: text/plain;
 name="sym_glue-free_resources.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sym_glue-free_resources.patch"

--- linux-2.6.0-test6/drivers/scsi/sym53c8xx_2/sym_glue.c	Sat Sep 27 19:51:29 2003
+++ linux-2.6.0-test6-sym/drivers/scsi/sym53c8xx_2/sym_glue.c	Tue Oct  7 12:33:42 2003
@@ -1605,6 +1605,8 @@
 	sym_hcb_free(np);
 
 	sym_mfree_dma(np, sizeof(*np), "HCB");
+
+	scsi_host_put(np->s.host);
 }
 
 /*
@@ -1861,7 +1863,8 @@
 	printf_info("%s: giving up ...\n", sym_name(np));
 	if (np)
 		sym_free_resources(np);
-	scsi_host_put(instance);
+	else
+		scsi_host_put(instance);
 
 	return -1;
  }
@@ -2213,6 +2216,8 @@
 {
 	printk("%s: detaching ...\n", sym_name(np));
 
+	scsi_remove_host(np->s.host);
+
 	del_timer_sync(&np->s.timer);
 
 	/*

--------------000309060304030404030403--

