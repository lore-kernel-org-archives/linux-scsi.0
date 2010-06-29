From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH 10/25] sg: remove casts from void*
Date: Tue, 29 Jun 2010 14:15:32 +0400
Message-ID: <1277806533-31044-1-git-send-email-segooon@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Alexey Dobriyan <adobriyan@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/sg.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef752b2..5fd2964 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -210,7 +210,7 @@ static void sg_put_dev(Sg_device *sdp);
 
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
-	struct sg_fd *sfp = (struct sg_fd *)filp->private_data;
+	struct sg_fd *sfp = filp->private_data;
 
 	if (sfp->parentdp->device->type == TYPE_SCANNER)
 		return 0;
@@ -318,7 +318,7 @@ sg_release(struct inode *inode, struct file *filp)
 	Sg_device *sdp;
 	Sg_fd *sfp;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_release: %s\n", sdp->disk->disk_name));
 
@@ -342,7 +342,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 	struct sg_header *old_hdr = NULL;
 	int retval = 0;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp =  filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_read: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
@@ -533,7 +533,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 	sg_io_hdr_t *hp;
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_write: %s, count=%d\n",
 				   sdp->disk->disk_name, (int) count));
@@ -768,7 +768,7 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 	Sg_request *srp;
 	unsigned long iflags;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_ioctl: %s, cmd=0x%x\n",
@@ -1096,7 +1096,7 @@ static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned lon
 	Sg_fd *sfp;
 	struct scsi_device *sdev;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 
 	sdev = sdp->device;
@@ -1122,7 +1122,7 @@ sg_poll(struct file *filp, poll_table * wait)
 	int count = 0;
 	unsigned long iflags;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp))
 	    || sfp->closed)
 		return POLLERR;
 	poll_wait(filp, &sfp->read_wait, wait);
@@ -1153,7 +1153,7 @@ sg_fasync(int fd, struct file *filp, int mode)
 	Sg_device *sdp;
 	Sg_fd *sfp;
 
-	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 	SCSI_LOG_TIMEOUT(3, printk("sg_fasync: %s, mode=%d\n",
 				   sdp->disk->disk_name, mode));
@@ -1208,7 +1208,7 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	Sg_scatter_hold *rsv_schp;
 	int k, length;
 
-	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
+	if ((!filp) || (!vma) || (!(sfp = filp->private_data)))
 		return -ENXIO;
 	req_sz = vma->vm_end - vma->vm_start;
 	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",
-- 
1.7.0.4
