From: akpm@osdl.org
Subject: [patch 18/34] coverity: i386: scsi_lib buffer overrun fix
Date: Tue, 28 Jun 2005 20:45:06 -0700
Message-ID: <200506290345.j5T3jXOu017089@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:65420 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261178AbVF2Dpj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 23:45:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: akpm@osdl.org, kambarov@berkeley.edu, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, zkambarov@coverity.com


From: "KAMBAROV, ZAUR" <kambarov@berkeley.edu>

The check in

627  		BUG_ON(index > SG_MEMPOOL_NR);

with SG_MEMPOOL_NR defined in

32   	#define SG_MEMPOOL_NR		(sizeof(scsi_sg_pools)/sizeof(struct scsi_host_sg_pool))

was not sufficient.

sgp, set in

629  		sgp = scsi_sg_pools + index;

is dereferenced in

630  		mempool_free(sgl, sgp->pool);

Signed-off-by: Zaur Kambarov <zkambarov@coverity.com> 
Cc: <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~coverity-i386-scsi_lib-buffer-overrun-fix drivers/scsi/scsi_lib.c
--- 25/drivers/scsi/scsi_lib.c~coverity-i386-scsi_lib-buffer-overrun-fix	2005-06-28 19:58:38.000000000 -0700
+++ 25-akpm/drivers/scsi/scsi_lib.c	2005-06-28 19:58:38.000000000 -0700
@@ -632,7 +632,7 @@ static void scsi_free_sgtable(struct sca
 {
 	struct scsi_host_sg_pool *sgp;
 
-	BUG_ON(index > SG_MEMPOOL_NR);
+	BUG_ON(index >= SG_MEMPOOL_NR);
 
 	sgp = scsi_sg_pools + index;
 	mempool_free(sgl, sgp->pool);
_
