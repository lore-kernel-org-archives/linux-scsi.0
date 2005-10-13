From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid: host_lock not released fix
Date: Thu, 13 Oct 2005 07:48:17 -0700
Message-ID: <1129214897.20935.15.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63631 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751471AbVJMOsU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Oct 2005 10:48:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

While doing some testing of error cases I ran into this bug.  In some
cases the reset handler can exit with the host_lock still held.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

Index: linux-2.6-aac/drivers/scsi/aacraid/linit.c
===================================================================
--- linux-2.6-aac.orig/drivers/scsi/aacraid/linit.c	2005-10-12 13:24:42.000000000 -0700
+++ linux-2.6-aac/drivers/scsi/aacraid/linit.c	2005-10-13 07:21:24.000000000 -0700
@@ -453,9 +453,9 @@
 		/*
 		 * We can exit If all the commands are complete
 		 */
+		spin_unlock_irq(host->host_lock);
 		if (active == 0)
 			return SUCCESS;
-		spin_unlock_irq(host->host_lock);
 		ssleep(1);
 		spin_lock_irq(host->host_lock);
 	}

-- 
Mark Haverkamp <markh@osdl.org>

