From: Arjan van de Ven <arjan@infradead.org>
Subject: turn most scsi semaphores into mutexes
Date: Wed, 11 Jan 2006 13:16:10 +0100
Message-ID: <1136981770.2929.36.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36231 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751354AbWAKMQS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 07:16:18 -0500
Received: from [2002:d55d:ead:110:20e:35ff:fea5:7eb2] (helo=[IPv6:2002:d55d:ead:110:20e:35ff:fea5:7eb2])
	by pentafluge.infradead.org with esmtpsa (Exim 4.54 #1 (Red Hat Linux))
	id 1Ewetg-0007H2-E5
	for linux-scsi@vger.kernel.org; Wed, 11 Jan 2006 12:16:16 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

the scsi layer is using semaphores in a mutex way, this patch converts
these into using mutexes instead

Signed-off-by: Arjan van de Ven <arjan@infradead.org>

 drivers/scsi/ch.c                    |   31 ++++++++++++++++---------------
 drivers/scsi/dpt_i2o.c               |   35 ++++++++++++++++++-----------------
 drivers/scsi/hosts.c                 |    8 ++++----
 drivers/scsi/megaraid.h              |    4 ++--
 drivers/scsi/megaraid/megaraid_sas.c |    7 ++++---
 drivers/scsi/scsi.c                  |   13 +++++++------
 drivers/scsi/scsi_proc.c             |   11 ++++++-----
 drivers/scsi/scsi_scan.c             |   16 ++++++++--------
 drivers/scsi/scsi_sysfs.c            |    4 ++--
 drivers/scsi/scsi_transport_iscsi.c  |   17 +++++++++--------
 drivers/scsi/sd.c                    |   21 +++++++++++----------
 drivers/scsi/sr.c                    |   17 +++++++++--------
 drivers/scsi/st.c                    |   17 +++++++++--------
 include/scsi/scsi_host.h             |    3 ++-
 14 files changed, 107 insertions(+), 97 deletions(-)

Index: linux-2.6.15/drivers/scsi/dpt_i2o.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/dpt_i2o.c
+++ linux-2.6.15/drivers/scsi/dpt_i2o.c
@@ -61,6 +61,7 @@ MODULE_DESCRIPTION("Adaptec I2O RAID Dri
 #include <linux/timer.h>
 #include <linux/string.h>
 #include <linux/ioport.h>
+#include <linux/mutex.h>
 
 #include <asm/processor.h>	/* for boot_cpu_data */
 #include <asm/pgtable.h>
@@ -106,7 +107,7 @@ static dpt_sig_S DPTI_sig = {
  *============================================================================
  */
 
-static DECLARE_MUTEX(adpt_configuration_lock);
+static DEFINE_MUTEX(adpt_configuration_lock);
 
 static struct i2o_sys_tbl *sys_tbl = NULL;
 static int sys_tbl_ind = 0;
@@ -537,13 +538,13 @@ static int adpt_proc_info(struct Scsi_Ho
 	 */
 
 	// Find HBA (host bus adapter) we are looking for
-	down(&adpt_configuration_lock);
+	mutex_lock(&adpt_configuration_lock);
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
 		if (pHba->host == host) {
 			break;	/* found adapter */
 		}
 	}
-	up(&adpt_configuration_lock);
+	mutex_unlock(&adpt_configuration_lock);
 	if (pHba == NULL) {
 		return 0;
 	}
@@ -958,7 +959,7 @@ static int adpt_install_hba(struct scsi_
 	}
 	memset(pHba, 0, sizeof(adpt_hba));
 
-	down(&adpt_configuration_lock);
+	mutex_lock(&adpt_configuration_lock);
 
 	if(hba_chain != NULL){
 		for(p = hba_chain; p->next; p = p->next);
@@ -971,7 +972,7 @@ static int adpt_install_hba(struct scsi_
 	sprintf(pHba->name, "dpti%d", hba_count);
 	hba_count++;
 	
-	up(&adpt_configuration_lock);
+	mutex_unlock(&adpt_configuration_lock);
 
 	pHba->pDev = pDev;
 	pHba->base_addr_phys = base_addr0_phys;
@@ -1027,7 +1028,7 @@ static void adpt_i2o_delete_hba(adpt_hba
 	struct adpt_device* pNext;
 
 
-	down(&adpt_configuration_lock);
+	mutex_lock(&adpt_configuration_lock);
 	// scsi_unregister calls our adpt_release which
 	// does a quiese
 	if(pHba->host){
@@ -1046,7 +1047,7 @@ static void adpt_i2o_delete_hba(adpt_hba
 	}
 
 	hba_count--;
-	up(&adpt_configuration_lock);
+	mutex_unlock(&adpt_configuration_lock);
 
 	iounmap(pHba->base_addr_virt);
 	pci_release_regions(pHba->pDev);
@@ -1549,7 +1550,7 @@ static int adpt_i2o_parse_lct(adpt_hba* 
  
 static int adpt_i2o_install_device(adpt_hba* pHba, struct i2o_device *d)
 {
-	down(&adpt_configuration_lock);
+	mutex_lock(&adpt_configuration_lock);
 	d->controller=pHba;
 	d->owner=NULL;
 	d->next=pHba->devices;
@@ -1560,7 +1561,7 @@ static int adpt_i2o_install_device(adpt_
 	pHba->devices=d;
 	*d->dev_name = 0;
 
-	up(&adpt_configuration_lock);
+	mutex_unlock(&adpt_configuration_lock);
 	return 0;
 }
 
@@ -1575,24 +1576,24 @@ static int adpt_open(struct inode *inode
 	if (minor >= hba_count) {
 		return -ENXIO;
 	}
-	down(&adpt_configuration_lock);
+	mutex_lock(&adpt_configuration_lock);
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
 		if (pHba->unit == minor) {
 			break;	/* found adapter */
 		}
 	}
 	if (pHba == NULL) {
-		up(&adpt_configuration_lock);
+		mutex_unlock(&adpt_configuration_lock);
 		return -ENXIO;
 	}
 
 //	if(pHba->in_use){
-	//	up(&adpt_configuration_lock);
+	//	mutex_unlock(&adpt_configuration_lock);
 //		return -EBUSY;
 //	}
 
 	pHba->in_use = 1;
-	up(&adpt_configuration_lock);
+	mutex_unlock(&adpt_configuration_lock);
 
 	return 0;
 }
@@ -1606,13 +1607,13 @@ static int adpt_close(struct inode *inod
 	if (minor >= hba_count) {
 		return -ENXIO;
 	}
-	down(&adpt_configuration_lock);
+	mutex_lock(&adpt_configuration_lock);
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
 		if (pHba->unit == minor) {
 			break;	/* found adapter */
 		}
 	}
-	up(&adpt_configuration_lock);
+	mutex_unlock(&adpt_configuration_lock);
 	if (pHba == NULL) {
 		return -ENXIO;
 	}
@@ -1910,13 +1911,13 @@ static int adpt_ioctl(struct inode *inod
 	if (minor >= DPTI_MAX_HBA){
 		return -ENXIO;
 	}
-	down(&adpt_configuration_lock);
+	mutex_lock(&adpt_configuration_lock);
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
 		if (pHba->unit == minor) {
 			break;	/* found adapter */
 		}
 	}
-	up(&adpt_configuration_lock);
+	mutex_unlock(&adpt_configuration_lock);
 	if(pHba == NULL){
 		return -ENXIO;
 	}
Index: linux-2.6.15/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/megaraid/megaraid_sas.c
+++ linux-2.6.15/drivers/scsi/megaraid/megaraid_sas.c
@@ -35,6 +35,7 @@
 #include <asm/uaccess.h>
 #include <linux/fs.h>
 #include <linux/compat.h>
+#include <linux/mutex.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -72,7 +73,7 @@ MODULE_DEVICE_TABLE(pci, megasas_pci_tab
 static int megasas_mgmt_majorno;
 static struct megasas_mgmt_info megasas_mgmt_info;
 static struct fasync_struct *megasas_async_queue;
-static DECLARE_MUTEX(megasas_async_queue_mutex);
+static DEFINE_MUTEX(megasas_async_queue_mutex);
 
 /**
  * megasas_get_cmd -	Get a command from the free pool
@@ -2362,11 +2363,11 @@ static int megasas_mgmt_fasync(int fd, s
 {
 	int rc;
 
-	down(&megasas_async_queue_mutex);
+	mutex_lock(&megasas_async_queue_mutex);
 
 	rc = fasync_helper(fd, filep, mode, &megasas_async_queue);
 
-	up(&megasas_async_queue_mutex);
+	mutex_unlock(&megasas_async_queue_mutex);
 
 	if (rc >= 0) {
 		/* For sanity check when we get ioctl */
Index: linux-2.6.15/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/scsi.c
+++ linux-2.6.15/drivers/scsi/scsi.c
@@ -55,6 +55,7 @@
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
+#include <linux/mutex.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -209,7 +210,7 @@ static struct scsi_host_cmd_pool scsi_cm
 	.gfp_mask	= __GFP_DMA,
 };
 
-static DECLARE_MUTEX(host_cmd_pool_mutex);
+static DEFINE_MUTEX(host_cmd_pool_mutex);
 
 static struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost,
 					    gfp_t gfp_mask)
@@ -330,7 +331,7 @@ int scsi_setup_command_freelist(struct S
 	 * Select a command slab for this host and create it if not
 	 * yet existant.
 	 */
-	down(&host_cmd_pool_mutex);
+	mutex_lock(&host_cmd_pool_mutex);
 	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
 	if (!pool->users) {
 		pool->slab = kmem_cache_create(pool->name,
@@ -342,7 +343,7 @@ int scsi_setup_command_freelist(struct S
 
 	pool->users++;
 	shost->cmd_pool = pool;
-	up(&host_cmd_pool_mutex);
+	mutex_unlock(&host_cmd_pool_mutex);
 
 	/*
 	 * Get one backup command for this host.
@@ -359,7 +360,7 @@ int scsi_setup_command_freelist(struct S
 		kmem_cache_destroy(pool->slab);
 	return -ENOMEM;
  fail:
-	up(&host_cmd_pool_mutex);
+	mutex_unlock(&host_cmd_pool_mutex);
 	return -ENOMEM;
 
 }
@@ -381,10 +382,10 @@ void scsi_destroy_command_freelist(struc
 		kmem_cache_free(shost->cmd_pool->slab, cmd);
 	}
 
-	down(&host_cmd_pool_mutex);
+	mutex_lock(&host_cmd_pool_mutex);
 	if (!--shost->cmd_pool->users)
 		kmem_cache_destroy(shost->cmd_pool->slab);
-	up(&host_cmd_pool_mutex);
+	mutex_unlock(&host_cmd_pool_mutex);
 }
 
 #ifdef CONFIG_SCSI_LOGGING
Index: linux-2.6.15/drivers/scsi/scsi_proc.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/scsi_proc.c
+++ linux-2.6.15/drivers/scsi/scsi_proc.c
@@ -25,6 +25,7 @@
 #include <linux/errno.h>
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -41,7 +42,7 @@
 static struct proc_dir_entry *proc_scsi;
 
 /* Protect sht->present and sht->proc_dir */
-static DECLARE_MUTEX(global_host_template_sem);
+static DEFINE_MUTEX(global_host_template_mutex);
 
 static int proc_scsi_read(char *buffer, char **start, off_t offset,
 			  int length, int *eof, void *data)
@@ -83,7 +84,7 @@ void scsi_proc_hostdir_add(struct scsi_h
 	if (!sht->proc_info)
 		return;
 
-	down(&global_host_template_sem);
+	mutex_lock(&global_host_template_mutex);
 	if (!sht->present++) {
 		sht->proc_dir = proc_mkdir(sht->proc_name, proc_scsi);
         	if (!sht->proc_dir)
@@ -92,7 +93,7 @@ void scsi_proc_hostdir_add(struct scsi_h
 		else
 			sht->proc_dir->owner = sht->module;
 	}
-	up(&global_host_template_sem);
+	mutex_unlock(&global_host_template_mutex);
 }
 
 void scsi_proc_hostdir_rm(struct scsi_host_template *sht)
@@ -100,12 +101,12 @@ void scsi_proc_hostdir_rm(struct scsi_ho
 	if (!sht->proc_info)
 		return;
 
-	down(&global_host_template_sem);
+	mutex_lock(&global_host_template_mutex);
 	if (!--sht->present && sht->proc_dir) {
 		remove_proc_entry(sht->proc_name, proc_scsi);
 		sht->proc_dir = NULL;
 	}
-	up(&global_host_template_sem);
+	mutex_unlock(&global_host_template_mutex);
 }
 
 void scsi_proc_host_add(struct Scsi_Host *shost)
Index: linux-2.6.15/drivers/scsi/scsi_transport_iscsi.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/scsi_transport_iscsi.c
+++ linux-2.6.15/drivers/scsi/scsi_transport_iscsi.c
@@ -24,6 +24,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/mempool.h>
+#include <linux/mutex.h>
 #include <net/tcp.h>
 
 #include <scsi/scsi.h>
@@ -46,7 +47,7 @@ struct iscsi_internal {
 	struct list_head sessions;
 	/*
 	 * lock to serialize access to the sessions list which must
-	 * be taken after the rx_queue_sema
+	 * be taken after the rx_queue_mutex
 	 */
 	spinlock_t session_lock;
 	/*
@@ -70,7 +71,7 @@ struct iscsi_internal {
 /*
  * list of registered transports and lock that must
  * be held while accessing list. The iscsi_transport_lock must
- * be acquired after the rx_queue_sema.
+ * be acquired after the rx_queue_mutex.
  */
 static LIST_HEAD(iscsi_transports);
 static DEFINE_SPINLOCK(iscsi_transport_lock);
@@ -145,7 +146,7 @@ static DECLARE_TRANSPORT_CLASS(iscsi_con
 
 static struct sock *nls;
 static int daemon_pid;
-static DECLARE_MUTEX(rx_queue_sema);
+static DEFINE_MUTEX(rx_queue_mutex);
 
 struct mempool_zone {
 	mempool_t *pool;
@@ -881,7 +882,7 @@ iscsi_if_rx(struct sock *sk, int len)
 {
 	struct sk_buff *skb;
 
-	down(&rx_queue_sema);
+	mutex_lock(&rx_queue_mutex);
 	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
 		while (skb->len >= NLMSG_SPACE(0)) {
 			int err;
@@ -923,7 +924,7 @@ iscsi_if_rx(struct sock *sk, int len)
 		}
 		kfree_skb(skb);
 	}
-	up(&rx_queue_sema);
+	mutex_unlock(&rx_queue_mutex);
 }
 
 /*
@@ -1159,7 +1160,7 @@ int iscsi_unregister_transport(struct is
 
 	BUG_ON(!tt);
 
-	down(&rx_queue_sema);
+	mutex_lock(&rx_queue_mutex);
 
 	priv = iscsi_if_transport_lookup(tt);
 	BUG_ON (!priv);
@@ -1167,7 +1168,7 @@ int iscsi_unregister_transport(struct is
 	spin_lock_irqsave(&priv->session_lock, flags);
 	if (!list_empty(&priv->sessions)) {
 		spin_unlock_irqrestore(&priv->session_lock, flags);
-		up(&rx_queue_sema);
+		mutex_unlock(&rx_queue_mutex);
 		return -EPERM;
 	}
 	spin_unlock_irqrestore(&priv->session_lock, flags);
@@ -1181,7 +1182,7 @@ int iscsi_unregister_transport(struct is
 
 	sysfs_remove_group(&priv->cdev.kobj, &iscsi_transport_group);
 	class_device_unregister(&priv->cdev);
-	up(&rx_queue_sema);
+	mutex_unlock(&rx_queue_mutex);
 
 	return 0;
 }
Index: linux-2.6.15/drivers/scsi/sd.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/sd.c
+++ linux-2.6.15/drivers/scsi/sd.c
@@ -49,6 +49,7 @@
 #include <linux/blkpg.h>
 #include <linux/kref.h>
 #include <linux/delay.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -111,7 +112,7 @@ static DEFINE_SPINLOCK(sd_index_lock);
 /* This semaphore is used to mediate the 0->1 reference get in the
  * face of object destruction (i.e. we can't allow a get on an
  * object after last put) */
-static DECLARE_MUTEX(sd_ref_sem);
+static DEFINE_MUTEX(sd_ref_mutex);
 
 static int sd_revalidate_disk(struct gendisk *disk);
 static void sd_rw_intr(struct scsi_cmnd * SCpnt);
@@ -193,9 +194,9 @@ static struct scsi_disk *scsi_disk_get(s
 {
 	struct scsi_disk *sdkp;
 
-	down(&sd_ref_sem);
+	mutex_lock(&sd_ref_mutex);
 	sdkp = __scsi_disk_get(disk);
-	up(&sd_ref_sem);
+	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
 }
 
@@ -203,11 +204,11 @@ static struct scsi_disk *scsi_disk_get_f
 {
 	struct scsi_disk *sdkp;
 
-	down(&sd_ref_sem);
+	mutex_lock(&sd_ref_mutex);
 	sdkp = dev_get_drvdata(dev);
 	if (sdkp)
 		sdkp = __scsi_disk_get(sdkp->disk);
-	up(&sd_ref_sem);
+	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
 }
 
@@ -215,10 +216,10 @@ static void scsi_disk_put(struct scsi_di
 {
 	struct scsi_device *sdev = sdkp->device;
 
-	down(&sd_ref_sem);
+	mutex_lock(&sd_ref_mutex);
 	kref_put(&sdkp->kref, scsi_disk_release);
 	scsi_device_put(sdev);
-	up(&sd_ref_sem);
+	mutex_unlock(&sd_ref_mutex);
 }
 
 /**
@@ -1635,10 +1636,10 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
-	down(&sd_ref_sem);
+	mutex_lock(&sd_ref_mutex);
 	dev_set_drvdata(dev, NULL);
 	kref_put(&sdkp->kref, scsi_disk_release);
-	up(&sd_ref_sem);
+	mutex_unlock(&sd_ref_mutex);
 
 	return 0;
 }
@@ -1647,7 +1648,7 @@ static int sd_remove(struct device *dev)
  *	scsi_disk_release - Called to free the scsi_disk structure
  *	@kref: pointer to embedded kref
  *
- *	sd_ref_sem must be held entering this routine.  Because it is
+ *	sd_ref_mutex must be held entering this routine.  Because it is
  *	called on last put, you should always use the scsi_disk_get()
  *	scsi_disk_put() helpers which manipulate the semaphore directly
  *	and never do a direct kref_put().
Index: linux-2.6.15/drivers/scsi/sr.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/sr.c
+++ linux-2.6.15/drivers/scsi/sr.c
@@ -44,6 +44,7 @@
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
+#include <linux/mutex.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -90,7 +91,7 @@ static DEFINE_SPINLOCK(sr_index_lock);
 /* This semaphore is used to mediate the 0->1 reference get in the
  * face of object destruction (i.e. we can't allow a get on an
  * object after last put) */
-static DECLARE_MUTEX(sr_ref_sem);
+static DEFINE_MUTEX(sr_ref_mutex);
 
 static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
@@ -133,7 +134,7 @@ static inline struct scsi_cd *scsi_cd_ge
 {
 	struct scsi_cd *cd = NULL;
 
-	down(&sr_ref_sem);
+	mutex_lock(&sr_ref_mutex);
 	if (disk->private_data == NULL)
 		goto out;
 	cd = scsi_cd(disk);
@@ -146,7 +147,7 @@ static inline struct scsi_cd *scsi_cd_ge
 	kref_put(&cd->kref, sr_kref_release);
 	cd = NULL;
  out:
-	up(&sr_ref_sem);
+	mutex_unlock(&sr_ref_mutex);
 	return cd;
 }
 
@@ -154,10 +155,10 @@ static inline void scsi_cd_put(struct sc
 {
 	struct scsi_device *sdev = cd->device;
 
-	down(&sr_ref_sem);
+	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
 	scsi_device_put(sdev);
-	up(&sr_ref_sem);
+	mutex_unlock(&sr_ref_mutex);
 }
 
 /*
@@ -845,7 +846,7 @@ static int sr_packet(struct cdrom_device
  *	sr_kref_release - Called to free the scsi_cd structure
  *	@kref: pointer to embedded kref
  *
- *	sr_ref_sem must be held entering this routine.  Because it is
+ *	sr_ref_mutex must be held entering this routine.  Because it is
  *	called on last put, you should always use the scsi_cd_get()
  *	scsi_cd_put() helpers which manipulate the semaphore directly
  *	and never do a direct kref_put().
@@ -874,9 +875,9 @@ static int sr_remove(struct device *dev)
 
 	del_gendisk(cd->disk);
 
-	down(&sr_ref_sem);
+	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
-	up(&sr_ref_sem);
+	mutex_unlock(&sr_ref_mutex);
 
 	return 0;
 }
Index: linux-2.6.15/drivers/scsi/st.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/st.c
+++ linux-2.6.15/drivers/scsi/st.c
@@ -38,6 +38,7 @@ static const char *verstr = "20050830";
 #include <linux/devfs_fs_kernel.h>
 #include <linux/cdev.h>
 #include <linux/delay.h>
+#include <linux/mutex.h>
 
 #include <asm/uaccess.h>
 #include <asm/dma.h>
@@ -220,7 +221,7 @@ static void scsi_tape_release(struct kre
 
 #define to_scsi_tape(obj) container_of(obj, struct scsi_tape, kref)
 
-static DECLARE_MUTEX(st_ref_sem);
+static DEFINE_MUTEX(st_ref_mutex);
 
 

 #include "osst_detect.h"
@@ -237,7 +238,7 @@ static struct scsi_tape *scsi_tape_get(i
 {
 	struct scsi_tape *STp = NULL;
 
-	down(&st_ref_sem);
+	mutex_lock(&st_ref_mutex);
 	write_lock(&st_dev_arr_lock);
 
 	if (dev < st_dev_max && scsi_tapes != NULL)
@@ -259,7 +260,7 @@ out_put:
 	STp = NULL;
 out:
 	write_unlock(&st_dev_arr_lock);
-	up(&st_ref_sem);
+	mutex_unlock(&st_ref_mutex);
 	return STp;
 }
 
@@ -267,10 +268,10 @@ static void scsi_tape_put(struct scsi_ta
 {
 	struct scsi_device *sdev = STp->device;
 
-	down(&st_ref_sem);
+	mutex_lock(&st_ref_mutex);
 	kref_put(&STp->kref, scsi_tape_release);
 	scsi_device_put(sdev);
-	up(&st_ref_sem);
+	mutex_unlock(&st_ref_mutex);
 }
 
 struct st_reject_data {
@@ -4141,9 +4142,9 @@ static int st_remove(struct device *dev)
 				}
 			}
 
-			down(&st_ref_sem);
+			mutex_lock(&st_ref_mutex);
 			kref_put(&tpnt->kref, scsi_tape_release);
-			up(&st_ref_sem);
+			mutex_unlock(&st_ref_mutex);
 			return 0;
 		}
 	}
@@ -4156,7 +4157,7 @@ static int st_remove(struct device *dev)
  *      scsi_tape_release - Called to free the Scsi_Tape structure
  *      @kref: pointer to embedded kref
  *
- *      st_ref_sem must be held entering this routine.  Because it is
+ *      st_ref_mutex must be held entering this routine.  Because it is
  *      called on last put, you should always use the scsi_tape_get()
  *      scsi_tape_put() helpers which manipulate the semaphore directly
  *      and never do a direct kref_put().
Index: linux-2.6.15/drivers/scsi/hosts.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/hosts.c
+++ linux-2.6.15/drivers/scsi/hosts.c
@@ -156,16 +156,16 @@ EXPORT_SYMBOL(scsi_host_set_state);
 void scsi_remove_host(struct Scsi_Host *shost)
 {
 	unsigned long flags;
-	down(&shost->scan_mutex);
+	mutex_lock(&shost->scan_mutex);
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_CANCEL))
 		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
 			spin_unlock_irqrestore(shost->host_lock, flags);
-			up(&shost->scan_mutex);
+			mutex_unlock(&shost->scan_mutex);
 			return;
 		}
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	up(&shost->scan_mutex);
+	mutex_unlock(&shost->scan_mutex);
 	scsi_forget_host(shost);
 	scsi_proc_host_rm(shost);
 
@@ -320,7 +320,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 	INIT_LIST_HEAD(&shost->starved_list);
 	init_waitqueue_head(&shost->host_wait);
 
-	init_MUTEX(&shost->scan_mutex);
+	mutex_init(&shost->scan_mutex);
 
 	shost->host_no = scsi_host_next_hn++; /* XXX(hch): still racy */
 	shost->dma_channel = 0xff;
Index: linux-2.6.15/drivers/scsi/scsi_scan.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6.15/drivers/scsi/scsi_scan.c
@@ -1289,14 +1289,14 @@ struct scsi_device *__scsi_add_device(st
 		return ERR_PTR(-ENOMEM);
 
 	get_device(&starget->dev);
-	down(&shost->scan_mutex);
+	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost)) {
 		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
 					     hostdata);
 		if (res != SCSI_SCAN_LUN_PRESENT)
 			sdev = ERR_PTR(-ENODEV);
 	}
-	up(&shost->scan_mutex);
+	mutex_unlock(&shost->scan_mutex);
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
 
@@ -1404,10 +1404,10 @@ void scsi_scan_target(struct device *par
 {
 	struct Scsi_Host *shost = dev_to_shost(parent);
 
-	down(&shost->scan_mutex);
+	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost))
 		__scsi_scan_target(parent, channel, id, lun, rescan);
-	up(&shost->scan_mutex);
+	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_scan_target);
 
@@ -1454,7 +1454,7 @@ int scsi_scan_host_selected(struct Scsi_
 	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
 		return -EINVAL;
 
-	down(&shost->scan_mutex);
+	mutex_lock(&shost->scan_mutex);
 	if (scsi_host_scan_allowed(shost)) {
 		if (channel == SCAN_WILD_CARD)
 			for (channel = 0; channel <= shost->max_channel;
@@ -1464,7 +1464,7 @@ int scsi_scan_host_selected(struct Scsi_
 		else
 			scsi_scan_channel(shost, channel, id, lun, rescan);
 	}
-	up(&shost->scan_mutex);
+	mutex_unlock(&shost->scan_mutex);
 
 	return 0;
 }
@@ -1522,7 +1522,7 @@ struct scsi_device *scsi_get_host_dev(st
 	struct scsi_device *sdev = NULL;
 	struct scsi_target *starget;
 
-	down(&shost->scan_mutex);
+	mutex_lock(&shost->scan_mutex);
 	if (!scsi_host_scan_allowed(shost))
 		goto out;
 	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->this_id);
@@ -1536,7 +1536,7 @@ struct scsi_device *scsi_get_host_dev(st
 	}
 	put_device(&starget->dev);
  out:
-	up(&shost->scan_mutex);
+	mutex_unlock(&shost->scan_mutex);
 	return sdev;
 }
 EXPORT_SYMBOL(scsi_get_host_dev);
Index: linux-2.6.15/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6.15/drivers/scsi/scsi_sysfs.c
@@ -745,9 +745,9 @@ void scsi_remove_device(struct scsi_devi
 {
 	struct Scsi_Host *shost = sdev->host;
 
-	down(&shost->scan_mutex);
+	mutex_lock(&shost->scan_mutex);
 	__scsi_remove_device(sdev);
-	up(&shost->scan_mutex);
+	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_remove_device);
 
Index: linux-2.6.15/include/scsi/scsi_host.h
===================================================================
--- linux-2.6.15.orig/include/scsi/scsi_host.h
+++ linux-2.6.15/include/scsi/scsi_host.h
@@ -5,6 +5,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
+#include <linux/mutex.h>
 
 struct block_device;
 struct completion;
@@ -469,7 +470,7 @@ struct Scsi_Host {
 	spinlock_t		default_lock;
 	spinlock_t		*host_lock;
 
-	struct semaphore	scan_mutex;/* serialize scanning activity */
+	struct mutex		scan_mutex;/* serialize scanning activity */
 
 	struct list_head	eh_cmd_q;
 	struct task_struct    * ehandler;  /* Error recovery thread. */
Index: linux-2.6.15/drivers/scsi/ch.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/ch.c
+++ linux-2.6.15/drivers/scsi/ch.c
@@ -23,6 +23,7 @@
 #include <linux/ioctl32.h>
 #include <linux/compat.h>
 #include <linux/chio.h>			/* here are all the ioctls */
+#include <linux/mutex.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -112,7 +113,7 @@ typedef struct {
 	u_int               counts[CH_TYPES];
 	u_int               unit_attention;
 	u_int		    voltags;
-	struct semaphore    lock;
+	struct mutex	    lock;
 } scsi_changer;
 
 static LIST_HEAD(ch_devlist);
@@ -566,7 +567,7 @@ static int ch_gstatus(scsi_changer *ch, 
 	u_char data[16];
 	unsigned int i;
 	
-	down(&ch->lock);
+	mutex_lock(&ch->lock);
 	for (i = 0; i < ch->counts[type]; i++) {
 		if (0 != ch_read_element_status
 		    (ch, ch->firsts[type]+i,data)) {
@@ -583,7 +584,7 @@ static int ch_gstatus(scsi_changer *ch, 
 		if (0 != retval)
 			break;
 	}
-	up(&ch->lock);
+	mutex_unlock(&ch->lock);
 	return retval;
 }
 
@@ -688,11 +689,11 @@ static int ch_ioctl(struct inode * inode
 			dprintk("CHIOPOSITION: invalid parameter\n");
 			return -EBADSLT;
 		}
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_position(ch,0,
 				     ch->firsts[pos.cp_type] + pos.cp_unit,
 				     pos.cp_flags & CP_INVERT);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 	
@@ -709,12 +710,12 @@ static int ch_ioctl(struct inode * inode
 			return -EBADSLT;
 		}
 		
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_move(ch,0,
 				 ch->firsts[mv.cm_fromtype] + mv.cm_fromunit,
 				 ch->firsts[mv.cm_totype]   + mv.cm_tounit,
 				 mv.cm_flags & CM_INVERT);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 
@@ -732,14 +733,14 @@ static int ch_ioctl(struct inode * inode
 			return -EBADSLT;
 		}
 		
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_exchange
 			(ch,0,
 			 ch->firsts[mv.ce_srctype]  + mv.ce_srcunit,
 			 ch->firsts[mv.ce_fdsttype] + mv.ce_fdstunit,
 			 ch->firsts[mv.ce_sdsttype] + mv.ce_sdstunit,
 			 mv.ce_flags & CE_INVERT1, mv.ce_flags & CE_INVERT2);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 
@@ -773,7 +774,7 @@ static int ch_ioctl(struct inode * inode
 		buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
 		if (!buffer)
 			return -ENOMEM;
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		
 	voltag_retry:
 		memset(cmd,0,sizeof(cmd));
@@ -824,7 +825,7 @@ static int ch_ioctl(struct inode * inode
 			goto voltag_retry;
 		}
 		kfree(buffer);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		
 		if (copy_to_user(argp, &cge, sizeof (cge)))
 			return -EFAULT;
@@ -833,9 +834,9 @@ static int ch_ioctl(struct inode * inode
 
 	case CHIOINITELEM:
 	{
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_init_elem(ch);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 		
@@ -852,12 +853,12 @@ static int ch_ioctl(struct inode * inode
 			return -EBADSLT;
 		}
 		elem = ch->firsts[csv.csv_type] + csv.csv_unit;
-		down(&ch->lock);
+		mutex_lock(&ch->lock);
 		retval = ch_set_voltag(ch, elem,
 				       csv.csv_flags & CSV_AVOLTAG,
 				       csv.csv_flags & CSV_CLEARTAG,
 				       csv.csv_voltag);
-		up(&ch->lock);
+		mutex_unlock(&ch->lock);
 		return retval;
 	}
 
@@ -930,7 +931,7 @@ static int ch_probe(struct device *dev)
 	memset(ch,0,sizeof(*ch));
 	ch->minor = ch_devcount;
 	sprintf(ch->name,"ch%d",ch->minor);
-	init_MUTEX(&ch->lock);
+	mutex_init(&ch->lock);
 	ch->device = sd;
 	ch_readconfig(ch);
 	if (init)
Index: linux-2.6.15/drivers/scsi/megaraid.h
===================================================================
--- linux-2.6.15.orig/drivers/scsi/megaraid.h
+++ linux-2.6.15/drivers/scsi/megaraid.h
@@ -2,7 +2,7 @@
 #define __MEGARAID_H__
 
 #include <linux/spinlock.h>
-
+#include <linux/mutex.h>
 
 #define MEGARAID_VERSION	\
 	"v2.00.3 (Release Date: Wed Feb 19 08:51:30 EST 2003)\n"
@@ -889,7 +889,7 @@ typedef struct {
 
 	scb_t			int_scb;
 	Scsi_Cmnd		int_scmd;
-	struct semaphore	int_mtx;	/* To synchronize the internal
+	struct mutex		int_mtx;	/* To synchronize the internal
 						commands */
 	struct completion	int_waitq;	/* wait queue for internal
 						 cmds */
Index: linux-2.6.15/drivers/scsi/megaraid.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/megaraid.c
+++ linux-2.6.15/drivers/scsi/megaraid.c
@@ -4479,7 +4479,7 @@ mega_internal_command(adapter_t *adapter
 	 * serialized. This is so because we want to reserve maximum number of
 	 * available command ids for the I/O commands.
 	 */
-	down(&adapter->int_mtx);
+	mutex_lock(&adapter->int_mtx);
 
 	scb = &adapter->int_scb;
 	memset(scb, 0, sizeof(scb_t));
@@ -4527,7 +4527,7 @@ mega_internal_command(adapter_t *adapter
 			mc->cmd, mc->opcode, mc->subopcode, scmd->result);
 	}
 
-	up(&adapter->int_mtx);
+	mutex_unlock(&adapter->int_mtx);
 
 	return rval;
 }
@@ -4866,7 +4866,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 		adapter->has_64bit_addr = 0;
 	}
 		
-	init_MUTEX(&adapter->int_mtx);
+	mutex_init(&adapter->int_mtx);
 	init_completion(&adapter->int_waitq);
 
 	adapter->this_id = DEFAULT_INITIATOR_ID;
Index: linux-2.6.15/drivers/scsi/iscsi_tcp.c
===================================================================
--- linux-2.6.15.orig/drivers/scsi/iscsi_tcp.c
+++ linux-2.6.15/drivers/scsi/iscsi_tcp.c
@@ -33,6 +33,7 @@
 #include <linux/delay.h>
 #include <linux/kfifo.h>
 #include <linux/scatterlist.h>
+#include <linux/mutex.h>
 #include <net/tcp.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -2300,10 +2301,10 @@ iscsi_xmitworker(void *data)
 	/*
 	 * serialize Xmit worker on a per-connection basis.
 	 */
-	down(&conn->xmitsema);
+	mutex_lock(&conn->xmitmutex);
 	if (iscsi_data_xmit(conn))
 		schedule_work(&conn->xmitwork);
-	up(&conn->xmitsema);
+	mutex_unlock(&conn->xmitmutex);
 }
 
 #define FAILURE_BAD_HOST		1
@@ -2367,11 +2368,11 @@ iscsi_queuecommand(struct scsi_cmnd *sc,
 		session->cmdsn, session->max_cmdsn - session->exp_cmdsn + 1);
 	spin_unlock(&session->lock);
 
-        if (!in_interrupt() && !down_trylock(&conn->xmitsema)) {
+        if (!in_interrupt() && mutex_trylock(&conn->xmitmutex)) {
 		spin_unlock_irq(host->host_lock);
 		if (iscsi_data_xmit(conn))
 			schedule_work(&conn->xmitwork);
-		up(&conn->xmitsema);
+		mutex_unlock(&conn->xmitmutex);
 		spin_lock_irq(host->host_lock);
 	} else
 		schedule_work(&conn->xmitwork);
@@ -2531,7 +2532,7 @@ iscsi_conn_create(iscsi_sessionh_t sessi
 		goto max_recv_dlenght_alloc_fail;
 
 	init_timer(&conn->tmabort_timer);
-	init_MUTEX(&conn->xmitsema);
+	mutex_init(&conn->xmitmutex);
 	init_waitqueue_head(&conn->ehwait);
 
 	return iscsi_handle(conn);
@@ -2561,7 +2562,7 @@ iscsi_conn_destroy(iscsi_connh_t connh)
 	struct iscsi_conn *conn = iscsi_ptr(connh);
 	struct iscsi_session *session = conn->session;
 
-	down(&conn->xmitsema);
+	mutex_lock(&conn->xmitmutex);
 	set_bit(SUSPEND_BIT, &conn->suspend_tx);
 	if (conn->c_stage == ISCSI_CONN_INITIAL_STAGE && conn->sock) {
 		struct sock *sk = conn->sock->sk;
@@ -2592,7 +2593,7 @@ iscsi_conn_destroy(iscsi_connh_t connh)
 	}
 	spin_unlock_bh(&session->lock);
 
-	up(&conn->xmitsema);
+	mutex_unlock(&conn->xmitmutex);
 
 	/*
 	 * Block until all in-progress commands for this connection
@@ -2796,7 +2797,7 @@ iscsi_conn_stop(iscsi_connh_t connh, int
 	set_bit(SUSPEND_BIT, &conn->suspend_rx);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	down(&conn->xmitsema);
+	mutex_lock(&conn->xmitmutex);
 
 	spin_lock_irqsave(session->host->host_lock, flags);
 	spin_lock(&session->lock);
@@ -2878,7 +2879,7 @@ iscsi_conn_stop(iscsi_connh_t connh, int
 			conn->datadgst_en = 0;
 		}
 	}
-	up(&conn->xmitsema);
+	mutex_unlock(&conn->xmitmutex);
 }
 
 static int
@@ -3029,12 +3030,12 @@ iscsi_eh_abort(struct scsi_cmnd *sc)
 	 * 1) connection-level failure;
 	 * 2) recovery due protocol error;
 	 */
-	down(&conn->xmitsema);
+	mutex_lock(&conn->xmitmutex);
 	spin_lock_bh(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
 		if (session->state == ISCSI_STATE_TERMINATE) {
 			spin_unlock_bh(&session->lock);
-			up(&conn->xmitsema);
+			mutex_unlock(&conn->xmitmutex);
 			goto failed;
 		}
 		spin_unlock_bh(&session->lock);
@@ -3052,7 +3053,7 @@ iscsi_eh_abort(struct scsi_cmnd *sc)
 			 * 2) session was re-open during time out of ctask.
 			 */
 			spin_unlock_bh(&session->lock);
-			up(&conn->xmitsema);
+			mutex_unlock(&conn->xmitmutex);
 			goto success;
 		}
 		conn->tmabort_state = TMABORT_INITIAL;
@@ -3107,7 +3108,7 @@ iscsi_eh_abort(struct scsi_cmnd *sc)
 				    conn->tmabort_state == TMABORT_SUCCESS) {
 					conn->tmabort_state = TMABORT_INITIAL;
 					spin_unlock_bh(&session->lock);
-					up(&conn->xmitsema);
+					mutex_unlock(&conn->xmitmutex);
 					goto success;
 				}
 				conn->tmabort_state = TMABORT_INITIAL;
@@ -3116,7 +3117,7 @@ iscsi_eh_abort(struct scsi_cmnd *sc)
 			spin_unlock_bh(&session->lock);
 		}
 	}
-	up(&conn->xmitsema);
+	mutex_unlock(&conn->xmitmutex);
 
 
 	/*
@@ -3182,7 +3183,7 @@ failed:
 exit:
 	del_timer_sync(&conn->tmabort_timer);
 
-	down(&conn->xmitsema);
+	mutex_lock(&conn->xmitmutex);
 	if (conn->sock) {
 		struct sock *sk = conn->sock->sk;
 
@@ -3190,7 +3191,7 @@ exit:
 		iscsi_ctask_cleanup(conn, ctask);
 		write_unlock_bh(&sk->sk_callback_lock);
 	}
-	up(&conn->xmitsema);
+	mutex_unlock(&conn->xmitmutex);
 	return rc;
 }
 
@@ -3601,9 +3602,9 @@ iscsi_conn_send_pdu(iscsi_connh_t connh,
 	struct iscsi_conn *conn = iscsi_ptr(connh);
 	int rc;
 
-	down(&conn->xmitsema);
+	mutex_lock(&conn->xmitmutex);
 	rc = iscsi_conn_send_generic(conn, hdr, data, data_size);
-	up(&conn->xmitsema);
+	mutex_unlock(&conn->xmitmutex);
 
 	return rc;
 }
Index: linux-2.6.15/drivers/scsi/iscsi_tcp.h
===================================================================
--- linux-2.6.15.orig/drivers/scsi/iscsi_tcp.h
+++ linux-2.6.15/drivers/scsi/iscsi_tcp.h
@@ -158,7 +158,7 @@ struct iscsi_conn {
 	struct kfifo		*mgmtqueue;	/* mgmt (control) xmit queue */
 	struct kfifo		*xmitqueue;	/* data-path cmd queue */
 	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
-	struct semaphore	xmitsema;	/* serializes connection xmit,
+	struct mutex		xmitmutex;	/* serializes connection xmit,
 						 * access to kfifos:	  *
 						 * xmitqueue, writequeue, *
 						 * immqueue, mgmtqueue    */


