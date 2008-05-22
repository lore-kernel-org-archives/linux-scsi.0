From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] aacraid: BKL push down
Date: Thu, 22 May 2008 22:39:57 +0100
Message-ID: <20080522223957.6c079b33@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934872AbYEVVws@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The aacraid definitely needs the BKL internally right now so push the
lock take down into the driver but go no further

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index b31faec..5e6b47f 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -111,7 +111,7 @@ static void twa_aen_queue_event(TW_Device_Extension *tw_dev, TW_Command_Apache_H
 static int twa_aen_read_queue(TW_Device_Extension *tw_dev, int request_id);
 static char *twa_aen_severity_lookup(unsigned char severity_code);
 static void twa_aen_sync_time(TW_Device_Extension *tw_dev, int request_id);
-static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
+static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 static int twa_chrdev_open(struct inode *inode, struct file *file);
 static int twa_fill_sense(TW_Device_Extension *tw_dev, int request_id, int copy_sense, int print_host);
 static void twa_free_request_id(TW_Device_Extension *tw_dev,int request_id);
@@ -202,7 +202,7 @@ static struct device_attribute *twa_host_attrs[] = {
 /* File operations struct for character device */
 static const struct file_operations twa_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= twa_chrdev_ioctl,
+	.unlocked_ioctl	= twa_chrdev_ioctl,
 	.open		= twa_chrdev_open,
 	.release	= NULL
 };
@@ -619,7 +619,7 @@ out:
 } /* End twa_check_srl() */
 
 /* This function handles ioctl for the character device */
-static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long timeout;
 	unsigned long *cpu_addr, data_buffer_length_adjusted = 0, flags = 0;
@@ -635,7 +635,8 @@ static int twa_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int
 	TW_Event *event;
 	struct timeval current_time;
 	u32 current_time_ms;
-	TW_Device_Extension *tw_dev = twa_device_extension_list[iminor(inode)];
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
+	TW_Device_Extension *tw_dev = twa_device_extension_list[minor];
 	int retval = TW_IOCTL_ERROR_OS_EFAULT;
 	void __user *argp = (void __user *)arg;
 
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 8c22329..33a6a2e 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -874,7 +874,7 @@ static int tw_allocate_memory(TW_Device_Extension *tw_dev, int size, int which)
 } /* End tw_allocate_memory() */
 
 /* This function handles ioctl for the character device */
-static int tw_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int request_id;
 	dma_addr_t dma_handle;
@@ -886,7 +886,8 @@ static int tw_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int
 	long timeout;
 	TW_New_Ioctl *tw_ioctl;
 	TW_Passthru *passthru;
-	TW_Device_Extension *tw_dev = tw_device_extension_list[iminor(inode)];
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
+	TW_Device_Extension *tw_dev = tw_device_extension_list[minor];
 	int retval = -EFAULT;
 	void __user *argp = (void __user *)arg;
 
@@ -1043,7 +1044,7 @@ static int tw_chrdev_open(struct inode *inode, struct file *file)
 /* File operations struct for character device */
 static const struct file_operations tw_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= tw_chrdev_ioctl,
+	.unlocked_ioctl	= tw_chrdev_ioctl,
 	.open		= tw_chrdev_open,
 	.release	= NULL
 };
