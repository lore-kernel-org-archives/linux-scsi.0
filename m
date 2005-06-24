From: akpm@osdl.org
Subject: coverity-i386-scsi_lib-buffer-overrun-fix.patch added to -mm tree
Date: Fri, 24 Jun 2005 14:18:55 -0700
Message-ID: <200506242117.j5OLHuFH013124@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:976 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S263291AbVFXVR7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2005 17:17:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kambarov@berkeley.edu, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, zkambarov@coverity.com, mm-commits@vger.kernel.org


The patch titled

     coverity: i386: scsi_lib buffer overrun fix

has been added to the -mm tree.  Its filename is

     coverity-i386-scsi_lib-buffer-overrun-fix.patch

Patches currently in -mm which might be from kambarov@berkeley.edu are

coverity-i386-build-negative-return-to-unsigned-fix.patch
coverity-ipv4-fib_frontend-ifa_dev-null-check.patch
coverity-i386-scsi_lib-buffer-overrun-fix.patch
coverity-ipmi_msghandler-channels-array-overrun-fix.patch
a.patch



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
--- 25/drivers/scsi/scsi_lib.c~coverity-i386-scsi_lib-buffer-overrun-fix	Fri Jun 24 14:18:52 2005
+++ 25-akpm/drivers/scsi/scsi_lib.c	Fri Jun 24 14:18:52 2005
@@ -632,7 +632,7 @@ static void scsi_free_sgtable(struct sca
 {
 	struct scsi_host_sg_pool *sgp;
 
-	BUG_ON(index > SG_MEMPOOL_NR);
+	BUG_ON(index >= SG_MEMPOOL_NR);
 
 	sgp = scsi_sg_pools + index;
 	mempool_free(sgl, sgp->pool);
_
