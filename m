From: Joe Perches <joe@perches.com>
Subject: [PATCH 17/36] drivers/scsi: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:09 -0700
Message-ID: <a39a442a2a98c79079570bd0b2437e73a1ff092d.1278967121.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1760 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab0GLUuv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:51 -0400
In-Reply-To: <cover.1278967120.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/aacraid/linit.c |    2 +-
 drivers/scsi/pmcraid.c       |    7 +++----
 drivers/scsi/sg.c            |   18 +++++++++---------
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 33898b6..d0a7c1d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -770,7 +770,7 @@ static long aac_compat_cfg_ioctl(struct file *file, unsigned cmd, unsigned long
 {
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	return aac_compat_do_ioctl((struct aac_dev *)file->private_data, cmd, arg);
+	return aac_compat_do_ioctl(file->private_data, cmd, arg);
 }
 #endif
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 9ebcea3..ecc45c8 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3599,8 +3599,7 @@ static int pmcraid_chr_open(struct inode *inode, struct file *filep)
  */
 static int pmcraid_chr_release(struct inode *inode, struct file *filep)
 {
-	struct pmcraid_instance *pinstance =
-		((struct pmcraid_instance *)filep->private_data);
+	struct pmcraid_instance *pinstance = filep->private_data;
 
 	filep->private_data = NULL;
 	fasync_helper(-1, filep, 0, &pinstance->aen_queue);
@@ -3619,7 +3618,7 @@ static int pmcraid_chr_fasync(int fd, struct file *filep, int mode)
 	struct pmcraid_instance *pinstance;
 	int rc;
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 	mutex_lock(&pinstance->aen_queue_lock);
 	rc = fasync_helper(fd, filep, mode, &pinstance->aen_queue);
 	mutex_unlock(&pinstance->aen_queue_lock);
@@ -4110,7 +4109,7 @@ static long pmcraid_chr_ioctl(
 		return retval;
 	}
 
-	pinstance = (struct pmcraid_instance *)filep->private_data;
+	pinstance = filep->private_data;
 
 	if (!pinstance) {
 		pmcraid_info("adapter instance is not found\n");
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef752b2..c11ab95 100644
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
+	if ((!(sfp = filp->private_data)) || (!(sdp = sfp->parentdp)))
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
1.7.1.337.g6068.dirty

