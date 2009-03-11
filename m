From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/3] sg: remove unnecessary type casts
Date: Wed, 11 Mar 2009 10:02:46 +0900
Message-ID: <1236733367-30967-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1236733367-30967-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40758 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbZCKBEN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2009 21:04:13 -0400
In-Reply-To: <1236733367-30967-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index e84536b..7d713a0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -208,7 +208,7 @@ static void sg_put_dev(Sg_device *sdp);
 
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
-	struct sg_fd *sfp = (struct sg_fd *)filp->private_data;
+	struct sg_fd *sfp = filp->private_data;
 	struct request_queue *q = sfp->parentdp->device->request_queue;
 
 	if (sfp->parentdp->device->type == TYPE_SCANNER)
@@ -319,7 +319,7 @@ sg_release(struct inode *inode, struct file *filp)
 	Sg_device *sdp;
 	Sg_fd *sfp;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
@@ -343,7 +343,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	struct sg_header *old_hdr = NULL;
 	int retval = 0;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_read: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
@@ -534,7 +534,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	sg_io_hdr_t *hp;
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_write: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
@@ -770,7 +770,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
 	Sg_request *srp;
 	unsigned long iflags;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_ioctl: %s, cmd=0x%x\n",
@@ -1085,7 +1085,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	Sg_fd *sfp;
 	struct scsi_device *sdev;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 
 	sdev = sdp->device;
@@ -1111,7 +1111,7 @@ sg_poll(struct file *filp, poll_table * wait)
 	int count = 0;
 	unsigned long iflags;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp))
 	    || sfp->closed)
 		return POLLERR;
 	poll_wait(filp, &sfp->read_wait, wait);
@@ -1143,7 +1143,7 @@ sg_fasync(int fd, struct file *filp, int mode)
 	Sg_device *sdp;
 	Sg_fd *sfp;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_fasync: %s, mode=%d\n",
 				   sdp->disk->disk_name, mode));
@@ -1160,7 +1160,7 @@ sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	Sg_scatter_hold *rsv_schp;
 	int k, length;
 
-	if ((NULL == vma) || (!(sfp = (Sg_fd *) vma->vm_private_data)))
+	if ((NULL == vma) || (!(sfp = vma->vm_private_data)))
 		return VM_FAULT_SIGBUS;
 	rsv_schp = &sfp->reserve;
 	offset = vmf->pgoff << PAGE_SHIFT;
@@ -1199,7 +1199,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	Sg_scatter_hold *rsv_schp;
 	int k, length;
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if ((!filp) || (!vma) || (!(sfp = filp->private_data)))
 		return -ENXIO;
 	req_sz = vma->vm_end - vma->vm_start;
 	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",
-- 
1.6.0.6

