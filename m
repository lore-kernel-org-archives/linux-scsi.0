From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH v2 10/25] scsi/sg: remove casts from void*
Date: Thu,  1 Jul 2010 22:49:00 +0400
Message-ID: <1278010141-25638-1-git-send-email-segooon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove unnesessary casts from void*.
Style fixes with assignments in if (...).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/sg.c |   64 ++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef752b2..5289796 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -210,7 +210,7 @@ static void sg_put_dev(Sg_device *sdp);
 
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
-	struct sg_fd *sfp = (struct sg_fd *)filp->private_data;
+	struct sg_fd *sfp = filp->private_data;
 
 	if (sfp->parentdp->device->type == TYPE_SCANNER)
 		return 0;
@@ -315,11 +315,15 @@ sg_put:
 static int
 sg_release(struct inode *inode, struct file *filp)
 {
+	Sg_fd *sfp = filp->private_data;
 	Sg_device *sdp;
-	Sg_fd *sfp;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if (!sfp)
+		return -ENXIO;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
+
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
 	sfp->closed = 1;
@@ -334,16 +338,20 @@ sg_release(struct inode *inode, struct file *filp)
 static ssize_t
 sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 {
+	Sg_fd *sfp = filp->private_data;
 	Sg_device *sdp;
-	Sg_fd *sfp;
 	Sg_request *srp;
 	int req_pack_id = -1;
 	sg_io_hdr_t *hp;
 	struct sg_header *old_hdr = NULL;
 	int retval = 0;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if (!sfp)
+		return -ENXIO;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
+
 	SCSI_LOG_TIMEOUT(3, printk("sg_read: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
 
@@ -526,15 +534,19 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	int mxsize, cmd_size, k;
 	int input_size, blocking;
 	unsigned char opcode;
+	Sg_fd *sfp = filp->private_data;
 	Sg_device *sdp;
-	Sg_fd *sfp;
 	Sg_request *srp;
 	struct sg_header old_hdr;
 	sg_io_hdr_t *hp;
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if (!sfp)
+		return -ENXIO;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
+
 	SCSI_LOG_TIMEOUT(3, printk("sg_write: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
 	if (sdp->detached)
@@ -763,12 +775,15 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
 	int result, val, read_only;
+	Sg_fd *sfp = filp->private_data;
 	Sg_device *sdp;
-	Sg_fd *sfp;
 	Sg_request *srp;
 	unsigned long iflags;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if (!sfp)
+		return -ENXIO;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_ioctl: %s, cmd=0x%x\n",
@@ -1093,14 +1108,17 @@ sg_unlocked_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	Sg_device *sdp;
-	Sg_fd *sfp;
+	Sg_fd *sfp = filp->private_data;
 	struct scsi_device *sdev;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if (!sfp)
+		return -ENXIO;
+	sdp = sfp->parentdp;
+	if (!sdp)
 		return -ENXIO;
 
 	sdev = sdp->device;
-	if (sdev->host->hostt->compat_ioctl) { 
+	if (sdev->host->hostt->compat_ioctl) {
 		int ret;
 
 		ret = sdev->host->hostt->compat_ioctl(sdev, cmd_in, (void __user *)arg);
@@ -1116,15 +1134,18 @@ static unsigned int
 sg_poll(struct file *filp, poll_table * wait)
 {
 	unsigned int res = 0;
+	Sg_fd *sfp = filp->private_data;
 	Sg_device *sdp;
-	Sg_fd *sfp;
 	Sg_request *srp;
 	int count = 0;
 	unsigned long iflags;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp))
-	    || sfp->closed)
+	if (!sfp)
 		return POLLERR;
+	sdp = sfp->parentdp;
+	if ((!sdp) || sfp->closed)
+		return POLLERR;
+
 	poll_wait(filp, &sfp->read_wait, wait);
 	read_lock_irqsave(&sfp->rq_list_lock, iflags);
 	for (srp = sfp->headrp; srp; srp = srp->nextrp) {
@@ -1150,11 +1171,15 @@ sg_poll(struct file *filp, poll_table * wait)
 static int
 sg_fasync(int fd, struct file *filp, int mode)
 {
+	Sg_fd *sfp = filp->private_data;
 	Sg_device *sdp;
-	Sg_fd *sfp;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if (!sfp)
 		return -ENXIO;
+	sdp = sfp->parentdp;
+	if (!sdp)
+		return -ENXIO;
+
 	SCSI_LOG_TIMEOUT(3, printk("sg_fasync: %s, mode=%d\n",
 				   sdp->disk->disk_name, mode));
 
@@ -1208,7 +1233,10 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	Sg_scatter_hold *rsv_schp;
 	int k, length;
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if (!filp)
+		return -ENXIO;
+	sfp = filp->private_data;
+	if (!vma || !sfp)
 		return -ENXIO;
 	req_sz = vma->vm_end - vma->vm_start;
 	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",
-- 
1.7.0.4
