From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: pmcraid: use normal copy_from_user
Date: Sat, 22 Apr 2017 00:02:31 +0200
Message-ID: <20170421220250.2427519-1-arnd@arndb.de>
References: <20170420175549.3435196-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:63010 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1426317AbdDUWDA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 18:03:00 -0400
In-Reply-To: <20170420175549.3435196-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Johannes Berg <johannes.berg@intel.com>, Baoyou Xie <baoyou.xie@linaro.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

As pointed out by Al Viro for my previous series, the driver has no need
to call access_ok() and __copy_from_user()/__copy_to_user(). Changing
it to regular copy_from_user()/copy_to_user() simplifies the code without
any real downsides, making it less error-prone at best.

This patch by itself also addresses the warning about the access_ok()
macro on MIPS, but both fixes improve the code, so ideally we apply
them both.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/pmcraid.c | 40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 63298f017171..2091bdf298ef 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3348,9 +3348,9 @@ static int pmcraid_copy_sglist(
 
 		kaddr = kmap(page);
 		if (direction == DMA_TO_DEVICE)
-			rc = __copy_from_user(kaddr, buffer, bsize_elem);
+			rc = copy_from_user(kaddr, buffer, bsize_elem);
 		else
-			rc = __copy_to_user(buffer, kaddr, bsize_elem);
+			rc = copy_to_user(buffer, kaddr, bsize_elem);
 
 		kunmap(page);
 
@@ -3368,9 +3368,9 @@ static int pmcraid_copy_sglist(
 		kaddr = kmap(page);
 
 		if (direction == DMA_TO_DEVICE)
-			rc = __copy_from_user(kaddr, buffer, len % bsize_elem);
+			rc = copy_from_user(kaddr, buffer, len % bsize_elem);
 		else
-			rc = __copy_to_user(buffer, kaddr, len % bsize_elem);
+			rc = copy_to_user(buffer, kaddr, len % bsize_elem);
 
 		kunmap(page);
 
@@ -3697,7 +3697,7 @@ static long pmcraid_ioctl_passthrough(
 
 	request_buffer = arg + request_offset;
 
-	rc = __copy_from_user(buffer, arg,
+	rc = copy_from_user(buffer, arg,
 			     sizeof(struct pmcraid_passthrough_ioctl_buffer));
 
 	ioasa = arg + offsetof(struct pmcraid_passthrough_ioctl_buffer, ioasa);
@@ -3718,14 +3718,7 @@ static long pmcraid_ioctl_passthrough(
 		direction = DMA_FROM_DEVICE;
 	}
 
-	if (request_size > 0) {
-		rc = access_ok(access, arg, request_offset + request_size);
-
-		if (!rc) {
-			rc = -EFAULT;
-			goto out_free_buffer;
-		}
-	} else if (request_size < 0) {
+	if (request_size < 0) {
 		rc = -EINVAL;
 		goto out_free_buffer;
 	}
@@ -3935,11 +3928,6 @@ static long pmcraid_ioctl_driver(
 {
 	int rc = -ENOSYS;
 
-	if (!access_ok(VERIFY_READ, user_buffer, _IOC_SIZE(cmd))) {
-		pmcraid_err("ioctl_driver: access fault in request buffer\n");
-		return -EFAULT;
-	}
-
 	switch (cmd) {
 	case PMCRAID_IOCTL_RESET_ADAPTER:
 		pmcraid_reset_bringup(pinstance);
@@ -3971,8 +3959,7 @@ static int pmcraid_check_ioctl_buffer(
 	struct pmcraid_ioctl_header *hdr
 )
 {
-	int rc = 0;
-	int access = VERIFY_READ;
+	int rc;
 
 	if (copy_from_user(hdr, arg, sizeof(struct pmcraid_ioctl_header))) {
 		pmcraid_err("couldn't copy ioctl header from user buffer\n");
@@ -3988,19 +3975,6 @@ static int pmcraid_check_ioctl_buffer(
 		return -EINVAL;
 	}
 
-	/* check for appropriate buffer access */
-	if ((_IOC_DIR(cmd) & _IOC_READ) == _IOC_READ)
-		access = VERIFY_WRITE;
-
-	rc = access_ok(access,
-		       (arg + sizeof(struct pmcraid_ioctl_header)),
-		       hdr->buffer_length);
-	if (!rc) {
-		pmcraid_err("access failed for user buffer of size %d\n",
-			     hdr->buffer_length);
-		return -EFAULT;
-	}
-
 	return 0;
 }
 
-- 
2.9.0
