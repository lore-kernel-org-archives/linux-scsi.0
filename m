From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 03/12] scsi: autoconvert trivial BKL users to private mutex
Date: Sun, 11 Jul 2010 23:18:54 +0200
Message-ID: <1278883143-29035-4-git-send-email-arnd@arndb.de>
References: <1278883143-29035-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1278883143-29035-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>
List-Id: linux-scsi@vger.kernel.org

All these files use the big kernel lock in a trivial
way to serialize their private file operations,
typically resulting from an earlier semi-automatic
pushdown from VFS.

None of these drivers appears to want to lock against
other code, and they all use the BKL as the top-level
lock in their file operations, meaning that there
is no lock-order inversion problem.

Consequently, we can remove the BKL completely,
replacing it with a per-file mutex in every case.
Using a scripted approach means we can avoid
typos.

file=$1
name=$2
if grep -q lock_kernel ${file} ; then
    if grep -q 'include.*linux.mutex.h' ${file} ; then
            sed -i '/include.*<linux\/smp_lock.h>/d' ${file}
    else
            sed -i 's/include.*<linux\/smp_lock.h>.*$/include <linux\/mutex.h>/g' ${file}
    fi
    sed -i ${file} \
        -e "/^#include.*linux.mutex.h/,$ {
                1,/^\(static\|int\|long\)/ {
                     /^\(static\|int\|long\)/istatic DEFINE_MUTEX(${name}_mutex);

} }"  \
    -e "s/\(un\)*lock_kernel\>[ ]*()/mutex_\1lock(\&${name}_mutex)/g" \
    -e '/[      ]*cycle_kernel_lock();/d'
else
    sed -i -e '/include.*\<smp_lock.h\>/d' ${file}  \
                -e '/cycle_kernel_lock()/d'
fi

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
---
 drivers/message/fusion/mptctl.c      |   15 ++++++++-------
 drivers/message/i2o/i2o_config.c     |   23 ++++++++++++-----------
 drivers/scsi/3w-9xxx.c               |    7 +++----
 drivers/scsi/3w-sas.c                |    7 +++----
 drivers/scsi/3w-xxxx.c               |    9 ++++-----
 drivers/scsi/aacraid/linit.c         |   15 ++++++++-------
 drivers/scsi/ch.c                    |    8 ++++----
 drivers/scsi/dpt_i2o.c               |   18 +++++++++---------
 drivers/scsi/gdth.c                  |   11 ++++++-----
 drivers/scsi/megaraid.c              |    8 ++++----
 drivers/scsi/megaraid/megaraid_mm.c  |    8 ++++----
 drivers/scsi/megaraid/megaraid_sas.c |    2 --
 drivers/scsi/mpt2sas/mpt2sas_ctl.c   |   11 ++++++-----
 drivers/scsi/osst.c                  |   15 ++++++++-------
 drivers/scsi/scsi_tgt_if.c           |    2 --
 drivers/scsi/sg.c                    |   11 ++++++-----
 16 files changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index f06b291..5c6f206 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -54,7 +54,7 @@
 #include <linux/pci.h>
 #include <linux/delay.h>	/* for mdelay */
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/compat.h>
 
 #include <asm/io.h>
@@ -83,6 +83,7 @@ MODULE_VERSION(my_VERSION);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 
+static DEFINE_MUTEX(mpctl_mutex);
 static u8 mptctl_id = MPT_MAX_PROTOCOL_DRIVERS;
 static u8 mptctl_taskmgmt_id = MPT_MAX_PROTOCOL_DRIVERS;
 
@@ -593,12 +594,12 @@ mptctl_fasync(int fd, struct file *filep, int mode)
 	MPT_ADAPTER	*ioc;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&mpctl_mutex);
 	list_for_each_entry(ioc, &ioc_list, list)
 		ioc->aen_event_read_flag=0;
 
 	ret = fasync_helper(fd, filep, mode, &async_queue);
-	unlock_kernel();
+	mutex_unlock(&mpctl_mutex);
 	return ret;
 }
 
@@ -690,9 +691,9 @@ static long
 mptctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
+	mutex_lock(&mpctl_mutex);
 	ret = __mptctl_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&mpctl_mutex);
 	return ret;
 }
 
@@ -2908,7 +2909,7 @@ compat_mpt_command(struct file *filp, unsigned int cmd,
 static long compat_mpctl_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
+	mutex_lock(&mpctl_mutex);
 	switch (cmd) {
 	case MPTIOCINFO:
 	case MPTIOCINFO1:
@@ -2933,7 +2934,7 @@ static long compat_mpctl_ioctl(struct file *f, unsigned int cmd, unsigned long a
 		ret = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&mpctl_mutex);
 	return ret;
 }
 
diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_config.c
index c4b117f..771640a 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -31,7 +31,7 @@
  */
 
 #include <linux/miscdevice.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/compat.h>
 #include <linux/slab.h>
 
@@ -41,6 +41,7 @@
 
 #define SG_TABLESIZE		30
 
+static DEFINE_MUTEX(i2o_cfg_mutex);
 static long i2o_cfg_ioctl(struct file *, unsigned int, unsigned long);
 
 static spinlock_t i2o_config_lock;
@@ -739,7 +740,7 @@ static long i2o_cfg_compat_ioctl(struct file *file, unsigned cmd,
 				 unsigned long arg)
 {
 	int ret;
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	switch (cmd) {
 	case I2OGETIOPS:
 		ret = i2o_cfg_ioctl(file, cmd, arg);
@@ -751,7 +752,7 @@ static long i2o_cfg_compat_ioctl(struct file *file, unsigned cmd,
 		ret = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 	return ret;
 }
 
@@ -979,7 +980,7 @@ static long i2o_cfg_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	switch (cmd) {
 	case I2OGETIOPS:
 		ret = i2o_cfg_getiops(arg);
@@ -1035,7 +1036,7 @@ static long i2o_cfg_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		osm_debug("unknown ioctl called!\n");
 		ret = -EINVAL;
 	}
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 	return ret;
 }
 
@@ -1049,7 +1050,7 @@ static int cfg_open(struct inode *inode, struct file *file)
 	if (!tmp)
 		return -ENOMEM;
 
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	file->private_data = (void *)(i2o_cfg_info_id++);
 	tmp->fp = file;
 	tmp->fasync = NULL;
@@ -1063,7 +1064,7 @@ static int cfg_open(struct inode *inode, struct file *file)
 	spin_lock_irqsave(&i2o_config_lock, flags);
 	open_files = tmp;
 	spin_unlock_irqrestore(&i2o_config_lock, flags);
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 
 	return 0;
 }
@@ -1074,14 +1075,14 @@ static int cfg_fasync(int fd, struct file *fp, int on)
 	struct i2o_cfg_info *p;
 	int ret = -EBADF;
 
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	for (p = open_files; p; p = p->next)
 		if (p->q_id == id)
 			break;
 
 	if (p)
 		ret = fasync_helper(fd, fp, on, &p->fasync);
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 	return ret;
 }
 
@@ -1091,7 +1092,7 @@ static int cfg_release(struct inode *inode, struct file *file)
 	struct i2o_cfg_info *p, **q;
 	unsigned long flags;
 
-	lock_kernel();
+	mutex_lock(&i2o_cfg_mutex);
 	spin_lock_irqsave(&i2o_config_lock, flags);
 	for (q = &open_files; (p = *q) != NULL; q = &p->next) {
 		if (p->q_id == id) {
@@ -1101,7 +1102,7 @@ static int cfg_release(struct inode *inode, struct file *file)
 		}
 	}
 	spin_unlock_irqrestore(&i2o_config_lock, flags);
-	unlock_kernel();
+	mutex_unlock(&i2o_cfg_mutex);
 
 	return 0;
 }
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index e20b7bd..09a139f 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -92,7 +92,6 @@
 #include <linux/pci.h>
 #include <linux/time.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -105,6 +104,7 @@
 
 /* Globals */
 #define TW_DRIVER_VERSION "2.26.02.014"
+static DEFINE_MUTEX(twa_chrdev_mutex);
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -658,7 +658,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	int retval = TW_IOCTL_ERROR_OS_EFAULT;
 	void __user *argp = (void __user *)arg;
 
-	lock_kernel();
+	mutex_lock(&twa_chrdev_mutex);
 
 	/* Only let one of these through at a time */
 	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
@@ -879,7 +879,7 @@ out3:
 out2:
 	mutex_unlock(&tw_dev->ioctl_lock);
 out:
-	unlock_kernel();
+	mutex_unlock(&twa_chrdev_mutex);
 	return retval;
 } /* End twa_chrdev_ioctl() */
 
@@ -890,7 +890,6 @@ static int twa_chrdev_open(struct inode *inode, struct file *file)
 	unsigned int minor_number;
 	int retval = TW_IOCTL_ERROR_OS_ENODEV;
 
-	cycle_kernel_lock();
 	minor_number = iminor(inode);
 	if (minor_number >= twa_device_extension_count)
 		goto out;
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index f481e73..7e5f238 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -64,7 +64,6 @@
 #include <linux/pci.h>
 #include <linux/time.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -77,6 +76,7 @@
 
 /* Globals */
 #define TW_DRIVER_VERSION "3.26.02.000"
+static DEFINE_MUTEX(twl_chrdev_mutex);
 static TW_Device_Extension *twl_device_extension_list[TW_MAX_SLOT];
 static unsigned int twl_device_extension_count;
 static int twl_major = -1;
@@ -764,7 +764,7 @@ static long twl_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	int retval = -EFAULT;
 	void __user *argp = (void __user *)arg;
 
-	lock_kernel();
+	mutex_lock(&twl_chrdev_mutex);
 
 	/* Only let one of these through at a time */
 	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
@@ -861,7 +861,7 @@ out3:
 out2:
 	mutex_unlock(&tw_dev->ioctl_lock);
 out:
-	unlock_kernel();
+	mutex_unlock(&twl_chrdev_mutex);
 	return retval;
 } /* End twl_chrdev_ioctl() */
 
@@ -876,7 +876,6 @@ static int twl_chrdev_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	cycle_kernel_lock();
 	minor_number = iminor(inode);
 	if (minor_number >= twl_device_extension_count)
 		goto out;
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 30d735a..081c864 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -199,7 +199,6 @@
 
 #include <linux/module.h>
 #include <linux/reboot.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
@@ -221,6 +220,7 @@
 
 /* Globals */
 #define TW_DRIVER_VERSION "1.26.02.003"
+static DEFINE_MUTEX(tw_mutex);
 static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 static int tw_device_extension_count = 0;
 static int twe_major = -1;
@@ -900,10 +900,10 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 
 	dprintk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl()\n");
 
-	lock_kernel();
+	mutex_lock(&tw_mutex);
 	/* Only let one of these through at a time */
 	if (mutex_lock_interruptible(&tw_dev->ioctl_lock)) {
-		unlock_kernel();
+		mutex_unlock(&tw_mutex);
 		return -EINTR;
 	}
 
@@ -1034,7 +1034,7 @@ out2:
 	dma_free_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_New_Ioctl) - 1, cpu_addr, dma_handle);
 out:
 	mutex_unlock(&tw_dev->ioctl_lock);
-	unlock_kernel();
+	mutex_unlock(&tw_mutex);
 	return retval;
 } /* End tw_chrdev_ioctl() */
 
@@ -1044,7 +1044,6 @@ static int tw_chrdev_open(struct inode *inode, struct file *file)
 {
 	unsigned int minor_number;
 
-	cycle_kernel_lock();
 	dprintk(KERN_WARNING "3w-xxxx: tw_ioctl_open()\n");
 
 	minor_number = iminor(inode);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 33898b6..39e8395 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -38,7 +38,7 @@
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/syscalls.h>
 #include <linux/delay.h>
@@ -76,6 +76,7 @@ MODULE_DESCRIPTION("Dell PERC2, 2/Si, 3/Si, 3/Di, "
 MODULE_LICENSE("GPL");
 MODULE_VERSION(AAC_DRIVER_FULL_VERSION);
 
+static DEFINE_MUTEX(aac_mutex);
 static LIST_HEAD(aac_devices);
 static int aac_cfg_major = -1;
 char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
@@ -678,7 +679,7 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
 	unsigned minor_number = iminor(inode);
 	int err = -ENODEV;
 
-	lock_kernel();  /* BKL pushdown: nothing else protects this list */
+	mutex_lock(&aac_mutex);  /* BKL pushdown: nothing else protects this list */
 	list_for_each_entry(aac, &aac_devices, entry) {
 		if (aac->id == minor_number) {
 			file->private_data = aac;
@@ -686,7 +687,7 @@ static int aac_cfg_open(struct inode *inode, struct file *file)
 			break;
 		}
 	}
-	unlock_kernel();
+	mutex_unlock(&aac_mutex);
 
 	return err;
 }
@@ -711,9 +712,9 @@ static long aac_cfg_ioctl(struct file *file,
 	int ret;
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
-	lock_kernel();
+	mutex_lock(&aac_mutex);
 	ret = aac_do_ioctl(file->private_data, cmd, (void __user *)arg);
-	unlock_kernel();
+	mutex_unlock(&aac_mutex);
 
 	return ret;
 }
@@ -722,7 +723,7 @@ static long aac_cfg_ioctl(struct file *file,
 static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long arg)
 {
 	long ret;
-	lock_kernel();
+	mutex_lock(&aac_mutex);
 	switch (cmd) {
 	case FSACTL_MINIPORT_REV_CHECK:
 	case FSACTL_SENDFIB:
@@ -756,7 +757,7 @@ static long aac_compat_do_ioctl(struct aac_dev *dev, unsigned cmd, unsigned long
 		ret = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&aac_mutex);
 	return ret;
 }
 
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 4799d43..9ac271f 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -22,7 +22,6 @@
 #include <linux/chio.h>			/* here are all the ioctls */
 #include <linux/mutex.h>
 #include <linux/idr.h>
-#include <linux/smp_lock.h>
 #include <linux/slab.h>
 
 #include <scsi/scsi.h>
@@ -44,6 +43,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_CHANGER_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MEDIUM_CHANGER);
 
+static DEFINE_MUTEX(ch_mutex);
 static int init = 1;
 module_param(init, int, 0444);
 MODULE_PARM_DESC(init, \
@@ -580,19 +580,19 @@ ch_open(struct inode *inode, struct file *file)
 	scsi_changer *ch;
 	int minor = iminor(inode);
 
-	lock_kernel();
+	mutex_lock(&ch_mutex);
 	spin_lock(&ch_index_lock);
 	ch = idr_find(&ch_index_idr, minor);
 
 	if (NULL == ch || scsi_device_get(ch->device)) {
 		spin_unlock(&ch_index_lock);
-		unlock_kernel();
+		mutex_unlock(&ch_mutex);
 		return -ENXIO;
 	}
 	spin_unlock(&ch_index_lock);
 
 	file->private_data = ch;
-	unlock_kernel();
+	mutex_unlock(&ch_mutex);
 	return 0;
 }
 
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index b0c576f..0416ed8 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -49,7 +49,6 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Driver");
 #include <linux/kernel.h>	/* for printk */
 #include <linux/sched.h>
 #include <linux/reboot.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/dma-mapping.h>
 
@@ -76,6 +75,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Driver");
  * Needed for our management apps
  *============================================================================
  */
+static DEFINE_MUTEX(adpt_mutex);
 static dpt_sig_S DPTI_sig = {
 	{'d', 'P', 't', 'S', 'i', 'G'}, SIG_VERSION,
 #ifdef __i386__
@@ -1732,12 +1732,12 @@ static int adpt_open(struct inode *inode, struct file *file)
 	int minor;
 	adpt_hba* pHba;
 
-	lock_kernel();
+	mutex_lock(&adpt_mutex);
 	//TODO check for root access
 	//
 	minor = iminor(inode);
 	if (minor >= hba_count) {
-		unlock_kernel();
+		mutex_unlock(&adpt_mutex);
 		return -ENXIO;
 	}
 	mutex_lock(&adpt_configuration_lock);
@@ -1748,7 +1748,7 @@ static int adpt_open(struct inode *inode, struct file *file)
 	}
 	if (pHba == NULL) {
 		mutex_unlock(&adpt_configuration_lock);
-		unlock_kernel();
+		mutex_unlock(&adpt_mutex);
 		return -ENXIO;
 	}
 
@@ -1759,7 +1759,7 @@ static int adpt_open(struct inode *inode, struct file *file)
 
 	pHba->in_use = 1;
 	mutex_unlock(&adpt_configuration_lock);
-	unlock_kernel();
+	mutex_unlock(&adpt_mutex);
 
 	return 0;
 }
@@ -2160,9 +2160,9 @@ static long adpt_unlocked_ioctl(struct file *file, uint cmd, ulong arg)
  
 	inode = file->f_dentry->d_inode;
  
-	lock_kernel();
+	mutex_lock(&adpt_mutex);
 	ret = adpt_ioctl(inode, file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&adpt_mutex);
 
 	return ret;
 }
@@ -2176,7 +2176,7 @@ static long compat_adpt_ioctl(struct file *file,
  
 	inode = file->f_dentry->d_inode;
  
-	lock_kernel();
+	mutex_lock(&adpt_mutex);
  
 	switch(cmd) {
 		case DPT_SIGNATURE:
@@ -2194,7 +2194,7 @@ static long compat_adpt_ioctl(struct file *file,
 			ret =  -ENOIOCTLCMD;
 	}
  
-	unlock_kernel();
+	mutex_unlock(&adpt_mutex);
  
 	return ret;
 }
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index f672d62..56eb6c9 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -120,7 +120,7 @@
 #include <linux/timer.h>
 #include <linux/dma-mapping.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 
 #ifdef GDTH_RTC
@@ -140,6 +140,7 @@
 #include <scsi/scsi_host.h>
 #include "gdth.h"
 
+static DEFINE_MUTEX(gdth_mutex);
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(u32 size, u32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id);
@@ -4042,12 +4043,12 @@ static int gdth_open(struct inode *inode, struct file *filep)
 {
     gdth_ha_str *ha;
 
-    lock_kernel();
+    mutex_lock(&gdth_mutex);
     list_for_each_entry(ha, &gdth_instances, list) {
         if (!ha->sdev)
             ha->sdev = scsi_get_host_dev(ha->shost);
     }
-    unlock_kernel();
+    mutex_unlock(&gdth_mutex);
 
     TRACE(("gdth_open()\n"));
     return 0;
@@ -4615,9 +4616,9 @@ static long gdth_unlocked_ioctl(struct file *file, unsigned int cmd,
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&gdth_mutex);
 	ret = gdth_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&gdth_mutex);
 
 	return ret;
 }
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 0b6e322..4d0cf5c 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -46,7 +46,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/slab.h>
 #include <scsi/scsicam.h>
 
@@ -62,6 +62,7 @@ MODULE_DESCRIPTION ("LSI Logic MegaRAID legacy driver");
 MODULE_LICENSE ("GPL");
 MODULE_VERSION(MEGARAID_MODULE_VERSION);
 
+static DEFINE_MUTEX(megadev_mutex);
 static unsigned int max_cmd_per_lun = DEF_CMD_PER_LUN;
 module_param(max_cmd_per_lun, uint, 0);
 MODULE_PARM_DESC(max_cmd_per_lun, "Maximum number of commands which can be issued to a single LUN (default=DEF_CMD_PER_LUN=63)");
@@ -3282,7 +3283,6 @@ mega_init_scb(adapter_t *adapter)
 static int
 megadev_open (struct inode *inode, struct file *filep)
 {
-	cycle_kernel_lock();
 	/*
 	 * Only allow superuser to access private ioctl interface
 	 */
@@ -3701,9 +3701,9 @@ megadev_unlocked_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&megadev_mutex);
 	ret = megadev_ioctl(filep, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&megadev_mutex);
 
 	return ret;
 }
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 41f82f7..42770a1 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -16,11 +16,12 @@
  */
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include "megaraid_mm.h"
 
 
 // Entry points for char node driver
+static DEFINE_MUTEX(mraid_mm_mutex);
 static int mraid_mm_open(struct inode *, struct file *);
 static long mraid_mm_unlocked_ioctl(struct file *, uint, unsigned long);
 
@@ -98,7 +99,6 @@ mraid_mm_open(struct inode *inode, struct file *filep)
 	 */
 	if (!capable(CAP_SYS_ADMIN)) return (-EACCES);
 
-	cycle_kernel_lock();
 	return 0;
 }
 
@@ -224,9 +224,9 @@ mraid_mm_unlocked_ioctl(struct file *filep, unsigned int cmd,
 	int err;
 
 	/* inconsistant: mraid_mm_compat_ioctl doesn't take the BKL */
-	lock_kernel();
+	mutex_lock(&mraid_mm_mutex);
 	err = mraid_mm_ioctl(filep, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&mraid_mm_mutex);
 
 	return err;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 99e4478..c4a595d 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -33,7 +33,6 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
 #include <linux/uio.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
@@ -3557,7 +3556,6 @@ static void megasas_shutdown(struct pci_dev *pdev)
  */
 static int megasas_mgmt_open(struct inode *inode, struct file *filep)
 {
-	cycle_kernel_lock();
 	/*
 	 * Allow only those users with admin rights
 	 */
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index d88e975..56d08c0 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -51,7 +51,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/compat.h>
 #include <linux/poll.h>
 
@@ -61,6 +61,7 @@
 #include "mpt2sas_base.h"
 #include "mpt2sas_ctl.h"
 
+static DEFINE_MUTEX(_ctl_mutex);
 static struct fasync_struct *async_queue;
 static DECLARE_WAIT_QUEUE_HEAD(ctl_poll_wait);
 
@@ -2159,9 +2160,9 @@ _ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 
-	lock_kernel();
+	mutex_lock(&_ctl_mutex);
 	ret = _ctl_ioctl_main(file, cmd, (void __user *)arg);
-	unlock_kernel();
+	mutex_unlock(&_ctl_mutex);
 	return ret;
 }
 
@@ -2230,12 +2231,12 @@ _ctl_ioctl_compat(struct file *file, unsigned cmd, unsigned long arg)
 {
 	long ret;
 
-	lock_kernel();
+	mutex_lock(&_ctl_mutex);
 	if (cmd == MPT2COMMAND32)
 		ret = _ctl_compat_mpt_command(file, cmd, arg);
 	else
 		ret = _ctl_ioctl_main(file, cmd, (void __user *)arg);
-	unlock_kernel();
+	mutex_unlock(&_ctl_mutex);
 	return ret;
 }
 #endif
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index d64b717..358fd9c 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -51,7 +51,7 @@ static const char * osst_version = "0.99.4";
 #include <linux/moduleparam.h>
 #include <linux/delay.h>
 #include <linux/jiffies.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
 #include <asm/system.h>
@@ -80,6 +80,7 @@ static const char * osst_version = "0.99.4";
 #include "osst_options.h"
 #include "osst_detect.h"
 
+static DEFINE_MUTEX(osst_int_mutex);
 static int max_dev = 0;
 static int write_threshold_kbs = 0;
 static int max_sg_segs = 0;
@@ -4807,9 +4808,9 @@ static int os_scsi_tape_open(struct inode * inode, struct file * filp)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&osst_int_mutex);
 	ret = __os_scsi_tape_open(inode, filp);
-	unlock_kernel();
+	mutex_unlock(&osst_int_mutex);
 	return ret;
 }
 
@@ -4943,9 +4944,9 @@ static long osst_ioctl(struct file * file,
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
 
-	lock_kernel();
+	mutex_lock(&osst_int_mutex);
 	if (mutex_lock_interruptible(&STp->lock)) {
-		unlock_kernel();
+		mutex_unlock(&osst_int_mutex);
 		return -ERESTARTSYS;
 	}
 
@@ -5260,14 +5261,14 @@ static long osst_ioctl(struct file * file,
 	mutex_unlock(&STp->lock);
 
 	retval = scsi_ioctl(STp->device, cmd_in, p);
-	unlock_kernel();
+	mutex_unlock(&osst_int_mutex);
 	return retval;
 
 out:
 	if (SRpnt) osst_release_request(SRpnt);
 
 	mutex_unlock(&STp->lock);
-	unlock_kernel();
+	mutex_unlock(&osst_int_mutex);
 
 	return retval;
 }
diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index a87e21c..0203446 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -22,7 +22,6 @@
 #include <linux/miscdevice.h>
 #include <linux/gfp.h>
 #include <linux/file.h>
-#include <linux/smp_lock.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -323,7 +322,6 @@ static int tgt_open(struct inode *inode, struct file *file)
 {
 	tx_ring.tr_idx = rx_ring.tr_idx = 0;
 
-	cycle_kernel_lock();
 	return 0;
 }
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef752b2..f359da1 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -49,7 +49,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -62,6 +62,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 
 #ifdef CONFIG_SCSI_PROC_FS
 #include <linux/proc_fs.h>
+static DEFINE_MUTEX(sg_mutex);
 static char *sg_version_date = "20061027";
 
 static int sg_proc_init(void);
@@ -229,7 +230,7 @@ sg_open(struct inode *inode, struct file *filp)
 	int res;
 	int retval;
 
-	lock_kernel();
+	mutex_lock(&sg_mutex);
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
 	sdp = sg_get_dev(dev);
@@ -307,7 +308,7 @@ error_out:
 sg_put:
 	if (sdp)
 		sg_put_dev(sdp);
-	unlock_kernel();
+	mutex_unlock(&sg_mutex);
 	return retval;
 }
 
@@ -1082,9 +1083,9 @@ sg_unlocked_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&sg_mutex);
 	ret = sg_ioctl(filp, cmd_in, arg);
-	unlock_kernel();
+	mutex_unlock(&sg_mutex);
 
 	return ret;
 }
-- 
1.7.1
