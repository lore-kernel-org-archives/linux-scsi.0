From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] check for can_queue != 0 in scsi_host_alloc
Date: Tue, 24 Jun 2003 08:48:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624064826.GA26582@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:42138 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265721AbTFXGec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 02:34:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This is to give a proper warning if someone tries to load an
unconverted old-style driver.


--- 1.77/drivers/scsi/hosts.c	Thu Jun  5 20:52:51 2003
+++ edited/drivers/scsi/hosts.c	Sat Jun 21 12:24:27 2003
@@ -144,6 +144,12 @@
 		dump_stack();
         }
 
+	if (!sht->can_queue) {
+		printk(KERN_ERR "%s: can_queue = 0 no more supported\n",
+				sht->name);
+		return NULL;
+	}
+
 	/* if its not set in the template, use the default */
 	if (!sht->shost_attrs)
 		 sht->shost_attrs = scsi_sysfs_shost_attrs;
