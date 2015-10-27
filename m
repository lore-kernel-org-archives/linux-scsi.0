From: Weidong Wang <wangweidong1@huawei.com>
Subject: [PATCH 2/3] megaraid_sas: Convert printk to printk_<level>
Date: Tue, 27 Oct 2015 16:26:14 +0800
Message-ID: <1445934375-17784-3-git-send-email-wangweidong1@huawei.com>
References: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, JBottomley@odin.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, wangweidong1@huawei.com
List-Id: linux-scsi@vger.kernel.org

Reduce object size a little by using pr_<level>
calls instead of printk(KERN_<LEVEL>.

Signed-off-by: Weidong Wang <wangweidong1@huawei.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ed9846d..2287aa1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5889,7 +5889,7 @@ static int megasas_mgmt_fasync(int fd, struct file *filep, int mode)
 		return 0;
 	}
 
-	printk(KERN_DEBUG "megasas: fasync_helper failed [%d]\n", rc);
+	pr_debug("megasas: fasync_helper failed [%d]\n", rc);
 
 	return rc;
 }
@@ -6233,7 +6233,7 @@ static int megasas_mgmt_ioctl_aen(struct file *file, unsigned long arg)
 	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
 	if (file->private_data != file) {
-		printk(KERN_DEBUG "megasas: fasync_helper was not "
+		pr_debug("megasas: fasync_helper was not "
 		       "called first\n");
 		return -EINVAL;
 	}
@@ -6355,7 +6355,7 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 
 	if (copy_in_user(&cioc->frame.hdr.cmd_status,
 			 &ioc->frame.hdr.cmd_status, sizeof(u8))) {
-		printk(KERN_DEBUG "megasas: error copy_in_user cmd_status\n");
+		pr_debug("megasas: error copy_in_user cmd_status\n");
 		return -EFAULT;
 	}
 	return error;
@@ -6455,7 +6455,7 @@ megasas_sysfs_set_dbg_lvl(struct device_driver *dd, const char *buf, size_t coun
 	int retval = count;
 
 	if (sscanf(buf, "%u", &megasas_dbg_lvl) < 1) {
-		printk(KERN_ERR "megasas: could not set dbg_lvl\n");
+		pr_err("megasas: could not set dbg_lvl\n");
 		retval = -EINVAL;
 	}
 	return retval;
@@ -6480,7 +6480,7 @@ megasas_aen_polling(struct work_struct *work)
 	int error;
 
 	if (!instance) {
-		printk(KERN_ERR "invalid instance!\n");
+		pr_err("invalid instance!\n");
 		kfree(ev);
 		return;
 	}
@@ -6740,7 +6740,7 @@ static int __init megasas_init(void)
 	rval = register_chrdev(0, "megaraid_sas_ioctl", &megasas_mgmt_fops);
 
 	if (rval < 0) {
-		printk(KERN_DEBUG "megasas: failed to open device node\n");
+		pr_debug("megasas: failed to open device node\n");
 		return rval;
 	}
 
@@ -6752,7 +6752,7 @@ static int __init megasas_init(void)
 	rval = pci_register_driver(&megasas_pci_driver);
 
 	if (rval) {
-		printk(KERN_DEBUG "megasas: PCI hotplug registration failed \n");
+		pr_debug("megasas: PCI hotplug registration failed \n");
 		goto err_pcidrv;
 	}
 
-- 
1.9.0
