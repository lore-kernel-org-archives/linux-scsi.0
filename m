From: Dave Carroll <david.carroll@microsemi.com>
Subject: [PATCH V2] aacraid: Check size values after double-fetch from user
Date: Fri, 5 Aug 2016 13:44:10 -0600
Message-ID: <20160805194410.7198-1-david.carroll@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0060.outbound.protection.outlook.com ([104.47.33.60]:44632
	"EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1949451AbcHETos (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 15:44:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: aacraid@microsemi.com, wpengfeinudt@gmail.com, scott.banesh@microsemi.com, Dave Carroll <david.carroll@microsemi.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, Johannes Thumshurn <jthumshirn@suse.de>, stable@vger.kernel.org

 In aacraid's ioctl_send_fib() we do two fetches from userspace, one 
 the get the fib header's size and one for the fib itself. Later we use 
 the size field from the second fetch to further process the fib. If 
 for some reason the size from the second fetch is different than from 
 the first fix, we may encounter an out-of- bounds access in 
 aac_fib_send(). We also check the sender size to insure it is not
 out of bounds. This was reported in
 https://bugzilla.kernel.org/show_bug.cgi?id=116751 and was assigned
 CVE- 2016-6480.
 
Reported-by: Pengfei Wang <wpengfeinudt@gmail.com>
Fixes: 7c00ffa31 '[SCSI] 2.6 aacraid: Variable FIB size (updated patch)'
Cc: stable@vger.kernel.org
Signed-off-by: Dave Carroll <david.carroll@microsemi.com>
---
 drivers/scsi/aacraid/commctrl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index b381b37..eadca7b 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -63,7 +63,7 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 	struct fib *fibptr;
 	struct hw_fib * hw_fib = (struct hw_fib *)0;
 	dma_addr_t hw_fib_pa = (dma_addr_t)0LL;
-	unsigned size;
+	unsigned int size, osize;
 	int retval;
 
 	if (dev->in_reset) {
@@ -87,7 +87,8 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 	 *	will not overrun the buffer when we copy the memory. Return
 	 *	an error if we would.
 	 */
-	size = le16_to_cpu(kfib->header.Size) + sizeof(struct aac_fibhdr);
+	osize = size = le16_to_cpu(kfib->header.Size) +
+		sizeof(struct aac_fibhdr);
 	if (size < le16_to_cpu(kfib->header.SenderSize))
 		size = le16_to_cpu(kfib->header.SenderSize);
 	if (size > dev->max_fib_size) {
@@ -117,6 +117,14 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 		retval = -EFAULT;
 		goto cleanup;
 	}
+
+	/* Sanity check the second copy */
+	if ((osize != le16_to_cpu(kfib->header.Size) +
+		sizeof(struct aac_fibhdr))
+		|| (size < le16_to_cpu(kfib->header.SenderSize))) {
+		retval = -EINVAL;
+		goto cleanup;
+	}
 
 	if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
 		aac_adapter_interrupt(dev);
-- 
2.8.3

