From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] mptfusion: buffer overflow in mptctl_do_mpt_command()
Date: Tue, 23 Dec 2014 13:05:13 +0300
Message-ID: <20141223100513.GB21469@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The main problem is that this copy can overflow:

	if (copy_from_user(mf, mfPtr, karg.dataSgeOffset * 4)) {

We try to prevent an overflow by checking "if (sz > ioc->req_sz) {" but
the problem is that "sz" is signed so the test can underflow or their
could be an integer overflow.

A second problem was this check which could underflow if "maxSenseBytes"
was negative.

	if (karg.maxSenseBytes > MPT_SENSE_BUFFER_SIZE)

I made the variables unsigned to prevent underflow and I added a new
test to prevent integer overflows.  I had to update a call to printk()
and change some min() usages to min_t() as part of the fallout from the
type changes.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff, and not tested but I think it is safe.

diff --git a/drivers/message/fusion/mptctl.h b/drivers/message/fusion/mptctl.h
index d564cc9..117fe89 100644
--- a/drivers/message/fusion/mptctl.h
+++ b/drivers/message/fusion/mptctl.h
@@ -324,11 +324,11 @@ struct mpt_ioctl_command {
 	char		__user *dataInBufPtr;
 	char		__user *dataOutBufPtr;
 	char		__user *senseDataPtr;
-	int		maxReplyBytes;
-	int		dataInSize;
-	int		dataOutSize;
-	int		maxSenseBytes;
-	int		dataSgeOffset;
+	unsigned int	maxReplyBytes;
+	unsigned int	dataInSize;
+	unsigned int	dataOutSize;
+	unsigned int	maxSenseBytes;
+	unsigned int	dataSgeOffset;
 	char		MF[1];
 };
 
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 70bb753..5646830 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1829,7 +1829,8 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 	dma_addr_t	dma_addr_out;
 	int		sgSize = 0;	/* Num SG elements */
 	int		iocnum, flagsLength;
-	int		sz, rc = 0;
+	size_t		sz;
+	int		rc = 0;
 	int		msgContext;
 	u16		req_idx;
 	ulong 		timeout;
@@ -1861,6 +1862,9 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
 	/* Verify that the final request frame will not be too large.
 	 */
+	if (karg.dataSgeOffset > ioc->req_sz)
+		return -EFAULT;
+
 	sz = karg.dataSgeOffset * 4;
 	if (karg.dataInSize > 0)
 		sz += ioc->SGE_size;
@@ -1869,7 +1873,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 
 	if (sz > ioc->req_sz) {
 		printk(MYIOC_s_ERR_FMT "%s@%d::mptctl_do_mpt_command - "
-			"Request frame too large (%d) maximum (%d)\n",
+			"Request frame too large (%ld) maximum (%d)\n",
 			ioc->name, __FILE__, __LINE__, sz, ioc->req_sz);
 		return -EFAULT;
 	}
@@ -2316,8 +2320,8 @@ retry_wait:
 	 */
 	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_RF_VALID) {
 		if (karg.maxReplyBytes < ioc->reply_sz) {
-			sz = min(karg.maxReplyBytes,
-				4*ioc->ioctl_cmds.reply[2]);
+			sz = min_t(size_t, karg.maxReplyBytes,
+				   4*ioc->ioctl_cmds.reply[2]);
 		} else {
 			 sz = min(ioc->reply_sz, 4*ioc->ioctl_cmds.reply[2]);
 		}
@@ -2337,7 +2341,7 @@ retry_wait:
 	/* If valid sense data, copy to user.
 	 */
 	if (ioc->ioctl_cmds.status & MPT_MGMT_STATUS_SENSE_VALID) {
-		sz = min(karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);
+		sz = min_t(size_t, karg.maxSenseBytes, MPT_SENSE_BUFFER_SIZE);
 		if (sz > 0) {
 			if (copy_to_user(karg.senseDataPtr,
 				ioc->ioctl_cmds.sense, sz)) {
