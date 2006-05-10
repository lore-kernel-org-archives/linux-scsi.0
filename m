From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/5] aacraid: remove unneeded locking
Date: Wed, 10 May 2006 09:11:38 -0700
Message-ID: <1147277498.29108.31.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63107 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964997AbWEJQLv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 12:11:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received From Mark Salyzyn

Since new commands to the card are quiesced, respect the changes in
the SCSI error path which dropped locking around the hba reset handler
and similarly drop the lock requirement in the driver's path.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---
Applies to the scsi-misc-2.6 tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-04-17 13:22:35.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-04-17 13:23:45.000000000 -0700
@@ -453,15 +453,10 @@
 
 	printk(KERN_ERR "%s: Host adapter reset request. SCSI hang ?\n", 
 					AAC_DRIVERNAME);
-
-
-	spin_lock_irq(host->host_lock);
-
 	aac = (struct aac_dev *)host->hostdata;
 	if (aac_adapter_check_health(aac)) {
 		printk(KERN_ERR "%s: Host adapter appears dead\n", 
 				AAC_DRIVERNAME);
-		spin_unlock_irq(host->host_lock);
 		return -ENODEV;
 	}
 	/*
@@ -487,13 +482,10 @@
 		/*
 		 * We can exit If all the commands are complete
 		 */
-		spin_unlock_irq(host->host_lock);
 		if (active == 0)
 			return SUCCESS;
 		ssleep(1);
-		spin_lock_irq(host->host_lock);
 	}
-	spin_unlock_irq(host->host_lock);
 	printk(KERN_ERR "%s: SCSI bus appears hung\n", AAC_DRIVERNAME);
 	return -ETIMEDOUT;
 }

-- 
Mark Haverkamp <markh@osdl.org>

