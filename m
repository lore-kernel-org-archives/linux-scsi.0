From: akpm@linux-foundation.org
Subject: [patch 11/17] drivers/scsi/aic7xxx_old.c: remove redundant GFP_ATOMIC from kmalloc
Date: Mon, 09 Jul 2007 12:00:07 -0700
Message-ID: <200707091900.l69J08wo002540@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57585 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbXGITJJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 15:09:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, ssatyam@cse.iitk.ac.in

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

drivers/scsi/aic7xxx_old.c:aic7xxx_slave_alloc() unnecessarily passes
GFP_ATOMIC (along with GFP_KERNEL) to kmalloc() from a context that is not
atomic. Remove the pointless GFP_ATOMIC.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx_old.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx_old.c~drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c~drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc
+++ a/drivers/scsi/aic7xxx_old.c
@@ -6572,7 +6572,7 @@ aic7xxx_slave_alloc(struct scsi_device *
   struct aic7xxx_host *p = (struct aic7xxx_host *)SDptr->host->hostdata;
   struct aic_dev_data *aic_dev;
 
-  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
+  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_KERNEL);
   if(!aic_dev)
     return 1;
   /*
_
