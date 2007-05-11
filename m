From: akpm@linux-foundation.org
Subject: [patch 23/28] drivers/scsi/aic7xxx_old.c: remove redundant GFP_ATOMIC from kmalloc
Date: Thu, 10 May 2007 23:01:07 -0700
Message-ID: <200705110601.l4B61741008184@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754958AbXEKGJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:09:30 -0400
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
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx_old.c~drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c~drivers-scsi-aic7xxx_oldc-remove-redundant-gfp_atomic-from-kmalloc
+++ a/drivers/scsi/aic7xxx_old.c
@@ -6581,7 +6581,7 @@ aic7xxx_slave_alloc(struct scsi_device *
   struct aic7xxx_host *p = (struct aic7xxx_host *)SDptr->host->hostdata;
   struct aic_dev_data *aic_dev;
 
-  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
+  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_KERNEL);
   if(!aic_dev)
     return 1;
   /*
_
