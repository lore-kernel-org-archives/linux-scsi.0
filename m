From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/4] scsi: pmcraid: use __iomem pointers for ioctl argument
Date: Thu, 20 Apr 2017 19:54:45 +0200
Message-ID: <20170420175549.3435196-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Johannes Berg <johannes.berg@intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

kernelci.org reports a new compile warning for old code in the pmcraid
driver:

arch/mips/include/asm/uaccess.h:138:21: warning: passing argument 1 of '__access_ok' makes pointer from integer without a cast [-Wint-conversion]

The warning got introduced by a cleanup to the access_ok() helper
that requires the argument to be a pointer, where the old version
silently accepts 'unsigned long' arguments as it still does on most
other architectures.

The new behavior in MIPS however seems absolutely sensible, and so far I
could only find one other file with the same issue, so the best solution
seems to be to clean up the pmcraid driver.

This makes the driver consistently use 'void __iomem *' pointers for
passing around the address of the user space ioctl arguments, which gets
rid of the kernelci warning as well as several sparse warnings.

Fixes: f0a955f4eeec ("mips: sanitize __access_ok()")
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I wanted to be sure that I get all the __iomem annotations right, so
I ended up fixing all other sparse warnings as well, see the three
follow-up patches.
---
 drivers/scsi/pmcraid.c | 44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 49e70a383afa..096c704ca39a 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3325,7 +3325,7 @@ static struct pmcraid_sglist *pmcraid_alloc_sglist(int buflen)
  */
 static int pmcraid_copy_sglist(
 	struct pmcraid_sglist *sglist,
-	unsigned long buffer,
+	void __user *buffer,
 	u32 len,
 	int direction
 )
@@ -3346,11 +3346,9 @@ static int pmcraid_copy_sglist(
 
 		kaddr = kmap(page);
 		if (direction == DMA_TO_DEVICE)
-			rc = __copy_from_user(kaddr,
-					      (void *)buffer,
-					      bsize_elem);
+			rc = __copy_from_user(kaddr, buffer, bsize_elem);
 		else
-			rc = __copy_to_user((void *)buffer, kaddr, bsize_elem);
+			rc = __copy_to_user(buffer, kaddr, bsize_elem);
 
 		kunmap(page);
 
@@ -3368,13 +3366,9 @@ static int pmcraid_copy_sglist(
 		kaddr = kmap(page);
 
 		if (direction == DMA_TO_DEVICE)
-			rc = __copy_from_user(kaddr,
-					      (void *)buffer,
-					      len % bsize_elem);
+			rc = __copy_from_user(kaddr, buffer, len % bsize_elem);
 		else
-			rc = __copy_to_user((void *)buffer,
-					    kaddr,
-					    len % bsize_elem);
+			rc = __copy_to_user(buffer, kaddr, len % bsize_elem);
 
 		kunmap(page);
 
@@ -3652,17 +3646,17 @@ static long pmcraid_ioctl_passthrough(
 	struct pmcraid_instance *pinstance,
 	unsigned int ioctl_cmd,
 	unsigned int buflen,
-	unsigned long arg
+	void __user *arg
 )
 {
 	struct pmcraid_passthrough_ioctl_buffer *buffer;
 	struct pmcraid_ioarcb *ioarcb;
 	struct pmcraid_cmd *cmd;
 	struct pmcraid_cmd *cancel_cmd;
-	unsigned long request_buffer;
+	void __user *request_buffer;
 	unsigned long request_offset;
 	unsigned long lock_flags;
-	void *ioasa;
+	void __user *ioasa;
 	u32 ioasc;
 	int request_size;
 	int buffer_size;
@@ -3701,13 +3695,10 @@ static long pmcraid_ioctl_passthrough(
 
 	request_buffer = arg + request_offset;
 
-	rc = __copy_from_user(buffer,
-			     (struct pmcraid_passthrough_ioctl_buffer *) arg,
+	rc = __copy_from_user(buffer, arg,
 			     sizeof(struct pmcraid_passthrough_ioctl_buffer));
 
-	ioasa =
-	(void *)(arg +
-		offsetof(struct pmcraid_passthrough_ioctl_buffer, ioasa));
+	ioasa = arg + offsetof(struct pmcraid_passthrough_ioctl_buffer, ioasa);
 
 	if (rc) {
 		pmcraid_err("ioctl: can't copy passthrough buffer\n");
@@ -4021,6 +4012,7 @@ static long pmcraid_chr_ioctl(
 {
 	struct pmcraid_instance *pinstance = NULL;
 	struct pmcraid_ioctl_header *hdr = NULL;
+	void __user *argp = (void __user *)arg;
 	int retval = -ENOTTY;
 
 	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
@@ -4030,7 +4022,7 @@ static long pmcraid_chr_ioctl(
 		return -ENOMEM;
 	}
 
-	retval = pmcraid_check_ioctl_buffer(cmd, (void *)arg, hdr);
+	retval = pmcraid_check_ioctl_buffer(cmd, argp, hdr);
 
 	if (retval) {
 		pmcraid_info("chr_ioctl: header check failed\n");
@@ -4055,10 +4047,8 @@ static long pmcraid_chr_ioctl(
 		if (cmd == PMCRAID_IOCTL_DOWNLOAD_MICROCODE)
 			scsi_block_requests(pinstance->host);
 
-		retval = pmcraid_ioctl_passthrough(pinstance,
-						   cmd,
-						   hdr->buffer_length,
-						   arg);
+		retval = pmcraid_ioctl_passthrough(pinstance, cmd,
+						   hdr->buffer_length, argp);
 
 		if (cmd == PMCRAID_IOCTL_DOWNLOAD_MICROCODE)
 			scsi_unblock_requests(pinstance->host);
@@ -4066,10 +4056,8 @@ static long pmcraid_chr_ioctl(
 
 	case PMCRAID_DRIVER_IOCTL:
 		arg += sizeof(struct pmcraid_ioctl_header);
-		retval = pmcraid_ioctl_driver(pinstance,
-					      cmd,
-					      hdr->buffer_length,
-					      (void __user *)arg);
+		retval = pmcraid_ioctl_driver(pinstance, cmd,
+					      hdr->buffer_length, argp);
 		break;
 
 	default:
-- 
2.9.0
