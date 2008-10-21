From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/PSCSI]: Added support for
	->create_virtdevice_from_fd()
Date: Tue, 21 Oct 2008 13:26:27 -0700
Message-ID: <1224620787.24358.35.camel__38465.5019770891$1224620877$gmane$org@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:48174 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751969AbYJUU0a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 16:26:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vg>
Cc: Joel Becker <joel.becker@oracle.com>, Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>, Ming Zhang <blackmagic02881@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "H. Peter Anvin" <hpa@zytor.com>, Mike Christie <michaelc@cs.wisc.edu>

>From bd4227278bbb6ec911a15b380f2479782cbe94ce Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 20 Oct 2008 23:35:44 -0700
Subject: [PATCH] [Target_Core_Mod/PSCSI]: Added support for ->create_virtdevice_from_fd()

Added se_subsystem_api_t->create_virtdevice_from_fd() for locating (and
for TYPE_DISK, claiming) struct scsi_device from a passed open file descriptor
for Linux/SCSI storage objects.

This patch relies upon commit 362d4ef391699b0282dfbef3da633a561d9cbde7 for
the target_core_mod configfs infrastructure.

Here are the FIXMEs specific to configfs/fd and Linux/SCSI:

*) Determine long term status of struct gendisk->driverfs_dev for
   locating struct scsi_device from struct inode for Linux/SCSI.
*) Add support for struct scsi_device's backed by character device.
*) SCSI CDROM can only be attached through the fd method when medium
   is in the drive.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pscsi.c |  385 ++++++++++++++++++++--------------
 drivers/lio-core/target_core_pscsi.h |    2 +
 2 files changed, 234 insertions(+), 153 deletions(-)

diff --git a/drivers/lio-core/target_core_pscsi.c b/drivers/lio-core/target_core_pscsi.c
index f8fd2d5..be5c648 100644
--- a/drivers/lio-core/target_core_pscsi.c
+++ b/drivers/lio-core/target_core_pscsi.c
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/smp_lock.h>
 #include <linux/genhd.h>
+#include <linux/file.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -243,23 +244,8 @@ extern int pscsi_attach_hba (iscsi_portal_group_t *tpg, se_hba_t *hba, se_hbainf
 	PYXPRINT("CORE_HBA[%d] - Attached Parallel SCSI HBA to Generic Target Core"
 		" with TCQ Depth: %d MaxSectors: %hu\n", hba->hba_id,
 		atomic_read(&hba->max_queue_depth), max_sectors);
-#if 0
-	/*
-	 * For Parallel SCSI we assume the devices are already attached to the
-	 * HBA, so go ahead and scan the bus for devices to export as iSCSI LUNs.
-	 */
-	if ((pscsi_dev_count = pscsi_scan_devices(hba, hi)) < 0) {
-		PYXPRINT("No devices present, ignoring request to add"
-			" Parallel SCSI HBA %d.\n", sh->host_no);
-		goto fail;
-	}
-#endif		
+
 	return(0);
-#if 0
-fail:
-	scsi_host_put(sh);
-	return(-1);
-#endif
 }
 
 /*	pscsi_detach_hba(): (Part of se_subsystem_api_t template)
@@ -280,92 +266,6 @@ extern int pscsi_detach_hba (se_hba_t *hba)
 	return(0);
 }
 
-/*	pscsi_scan_devices(): (Part of se_subsystem_api_t template)
- *
- * 	FIXME: For <= v2.4, check what locking the midlayer does for accessing Scsi_Host->host_queue (if any?)
- */
-#if 0
-extern int pscsi_scan_devices (se_hba_t *iscsi_hba, se_hbainfo_t *hi)
-{
-	int pscsi_dev_count = 0;
-	int dev_flags = 0;
-	se_device_t *dev;
-	struct scsi_device *sd;
-	struct Scsi_Host *sh = (struct Scsi_Host *) iscsi_hba->hba_ptr;
-
-	spin_lock_irq(sh->host_lock);
-	list_for_each_entry(sd, &sh->__devices, siblings) {
-		if (sd->type == TYPE_DISK) {
-			if (scsi_device_get(sd))
-			    continue;
-
-			spin_unlock_irq(sh->host_lock);
-
-			if (pscsi_check_sd(sd) < 0) {
-				spin_lock_irq(sh->host_lock);
-				scsi_device_put(sd);
-				continue;
-			}
-
-			/*
-			 * In some cases (namely the iSCSI Initiator Case) we want to
-			 * grab exclusive access to the underlying Linux block device
-			 * immediately at this point.  We use parameter that is passed
-			 * with addhbatotarget to determine when to claim for this case.
-			 */
-			if (hi->os_claim_devices) 
-				if (!(pscsi_claim_sd(sd))) {
-					dev_flags |= DF_CLAIMED_BLOCKDEV;
-					dev_flags |= DF_PERSISTENT_CLAIMED_BLOCKDEV;
-				}
-			
-			dev = pscsi_add_device_to_list(iscsi_hba, sd, dev_flags);
-			
-			if (dev_flags & DF_CLAIMED_BLOCKDEV) {
-				dev_flags &= ~DF_CLAIMED_BLOCKDEV;
-				dev_flags &= ~DF_PERSISTENT_CLAIMED_BLOCKDEV;
-			}
-			
-			spin_lock_irq(sh->host_lock);
-
-			if (!dev) {
-			    scsi_device_put(sd);
-			    continue;
-			}
-			
-			pscsi_dev_count++;
-			continue;
-		}
-
-		/*
-		 * We may need to do peripheral-type specific checking of access counts.
-		 */
-//#warning FIXME v2.8: Check usage of scsi_device_get() for non TYPE_DISK
-		if (sd->type == TYPE_ROM || sd->type == TYPE_TAPE || sd->type == TYPE_MEDIUM_CHANGER) {
-			spin_unlock_irq(sh->host_lock);
-			dev = pscsi_add_device_to_list(iscsi_hba, sd, dev_flags);
-			spin_lock_irq(sh->host_lock);
-
-			if (!dev)
-				continue;
-			
-			pscsi_dev_count++;
-			continue;
-		}
-
-	}
-	spin_unlock_irq(sh->host_lock);
-		
-	if (!pscsi_dev_count)
-		return(-1);
-
-	PYXPRINT("iSCSI_PSCSI[%d] - Detected %d Parallel SCSI Devices\n",
-			sh->host_no, pscsi_dev_count);
-
-	return(pscsi_dev_count);
-}
-#endif
-
 /*	pscsi_add_device_to_list():
  *
  *	FIXME: We are going to want to increment struct scsi_device->access_count
@@ -504,13 +404,105 @@ extern void *pscsi_allocate_virtdevice (se_hba_t *hba, const char *name)
 	return((void *)pdv);
 }
 
+/*
+ * Called with struct Scsi_Host->host_lock called.
+ */
+extern se_device_t *pscsi_create_type_disk (struct scsi_device *sd, pscsi_dev_virt_t *pdv, se_hba_t *hba)
+{
+	se_device_t *dev;
+	struct Scsi_Host *sh = sd->host;
+	u32 dev_flags = 0;
+
+	if (sd->type != TYPE_DISK)
+		return(NULL);
+
+	if (scsi_device_get(sd)) {
+		printk(KERN_ERR "scsi_device_get() failed for %d:%d:%d:%d\n",
+			sh->host_no, sd->channel, sd->id, sd->lun);
+		spin_unlock_irq(sh->host_lock);
+		return(NULL);
+	}
+	spin_unlock_irq(sh->host_lock);
+
+	if (pscsi_check_sd(sd) < 0) {
+		scsi_device_put(sd);
+		printk(KERN_ERR "pscsi_check_sd() failed for %d:%d:%d:%d\n",
+			sh->host_no, sd->channel, sd->id, sd->lun);
+		return(NULL);
+	}
+	if (!(pscsi_claim_sd(sd))) {
+		dev_flags |= DF_CLAIMED_BLOCKDEV;
+		dev_flags |= DF_PERSISTENT_CLAIMED_BLOCKDEV;
+	}	
+	if (!(dev = pscsi_add_device_to_list(hba, pdv, sd, dev_flags))) {
+		scsi_device_put(sd);
+		return(NULL);
+	}
+	PYXPRINT("CORE_PSCSI[%d] - Added TYPE_DISK for %d:%d:%d\n",
+		sh->host_no, sd->channel, sd->id, sd->lun);
+
+	return(dev);
+}
+
+/*
+ * Called with struct Scsi_Host->host_lock called.
+ */
+extern se_device_t *pscsi_create_type_rom (struct scsi_device *sd, pscsi_dev_virt_t *pdv, se_hba_t *hba)
+{
+	se_device_t *dev;
+	struct Scsi_Host *sh = sd->host;
+	u32 dev_flags = 0;
+
+	if (sd->type != TYPE_ROM)
+		return(NULL);
+
+	if (scsi_device_get(sd)) {
+		printk(KERN_ERR "scsi_device_get() failed for %d:%d:%d:%d\n",
+			sh->host_no, sd->channel, sd->id, sd->lun);
+		spin_unlock_irq(sh->host_lock);
+		return(NULL);
+	}
+	spin_unlock_irq(sh->host_lock);
+
+	if (!(dev = pscsi_add_device_to_list(hba, pdv, sd, dev_flags))) {
+		scsi_device_put(sd);
+		return(NULL);
+	}
+	PYXPRINT("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d\n",
+		sh->host_no, scsi_device_type(sd->type), sd->channel,
+		sd->id, sd->lun);
+
+	return(dev);	
+}
+
+/*
+ *Called with struct Scsi_Host->host_lock called.
+ */
+extern se_device_t *pscsi_create_type_other (struct scsi_device *sd, pscsi_dev_virt_t *pdv, se_hba_t *hba)
+{
+	se_device_t *dev;
+	struct Scsi_Host *sh = sd->host;
+	u32 dev_flags = 0;
+
+	if ((sd->type == TYPE_DISK) || (sd->type == TYPE_ROM))
+		return(NULL);
+	spin_unlock_irq(sh->host_lock);
+
+	if (!(dev = pscsi_add_device_to_list(hba, pdv, sd, dev_flags)))
+		return(NULL);
+	
+	PYXPRINT("CORE_PSCSI[%d] - Added Type: %s for %d:%d:%d\n",
+		sh->host_no, scsi_device_type(sd->type), sd->channel,
+		sd->id, sd->lun);
+
+	return(dev);
+}
+
 extern se_device_t *pscsi_create_virtdevice (se_hba_t *hba, void *p)
 {
 	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *)p;
-	se_device_t *dev;
 	struct scsi_device *sd;
 	struct Scsi_Host *sh = (struct Scsi_Host *) hba->hba_ptr;
-	u32 dev_flags = 0;
 
 	if (!(pdv)) {
 		printk(KERN_ERR "Unable to locate pscsi_dev_virt_t parameter\n");
@@ -523,54 +515,17 @@ extern se_device_t *pscsi_create_virtdevice (se_hba_t *hba, void *p)
 		    !(pdv->pdv_target_id == sd->id) ||
 		    !(pdv->pdv_lun_id == sd->lun))
 			continue;
-
-		if (sd->type == TYPE_DISK) {
-			if (scsi_device_get(sd)) {
-				spin_unlock_irq(sh->host_lock);
-				printk(KERN_ERR "scsi_device_get() failed for %d:%d:%d:%d\n",
-					sh->host_no, sd->channel, sd->id, sd->lun);
-				return(NULL);
-			}
-			spin_unlock_irq(sh->host_lock);
-
-			if (pscsi_check_sd(sd) < 0) {
-				scsi_device_put(sd);
-				printk(KERN_ERR "pscsi_check_sd() failed for %d:%d:%d:%d\n",
-					sh->host_no, sd->channel, sd->id, sd->lun);
-				return(NULL);
-			}
-#warning FIXME: Is this already being done inside target_core_mod..?
-			if (!(pscsi_claim_sd(sd))) {
-				dev_flags |= DF_CLAIMED_BLOCKDEV;
-				dev_flags |= DF_PERSISTENT_CLAIMED_BLOCKDEV;
-			}
-
-			if (!(dev = pscsi_add_device_to_list(hba, pdv, sd, dev_flags))) {
-				scsi_device_put(sd);
-				return(NULL);
-			}	
-			PYXPRINT("CORE_PSCSI[%d] - Added TYPE_DISK for %d:%d:%d\n",
-				sh->host_no, sd->channel, sd->id, sd->lun);	
-
-			return(dev);
-		}
-#warning FIXME: Can all NON TYPE_DISK be handled this way..?
-		if ((sd->type == TYPE_ROM) ||
-		    (sd->type == TYPE_TAPE) ||
-		    (sd->type == TYPE_MEDIUM_CHANGER)) {	
-			spin_unlock_irq(sh->host_lock);
-
-			if (!(dev = pscsi_add_device_to_list(hba, pdv, sd, dev_flags)))
-				return(NULL);	
-
-			PYXPRINT("CORE_PSCSI[%d] - Added TYPE_DISK for %d:%d:%d\n",
-				sh->host_no, sd->channel, sd->id, sd->lun);   	
-
-			return(dev);
+		/*
+		 * Functions will release struct scsi_host->host_lock
+		 */
+		switch (sd->type) {
+		case TYPE_DISK:
+			return(pscsi_create_type_disk(sd, pdv, hba));
+		case TYPE_ROM:
+			return(pscsi_create_type_rom(sd, pdv, hba));
+		default:
+			return(pscsi_create_type_other(sd, pdv, hba));
 		}
-
-		printk(KERN_ERR "Unable to process SCSI device type: %d\n", sd->type);
-		return(NULL);
 	}
 	spin_unlock_irq(sh->host_lock);
 
@@ -672,8 +627,10 @@ extern void pscsi_free_device (void *p)
 	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) p;
 	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
 
-	if (sd && (sd->type == TYPE_DISK)) {
-		scsi_device_put(sd);
+	if (sd) {
+		if ((sd->type == TYPE_DISK) || (sd->type == TYPE_ROM)) 
+			scsi_device_put(sd);
+
 		pdv->pdv_sd = NULL;
 	}
 	
@@ -1011,6 +968,128 @@ extern ssize_t pscsi_show_configfs_dev_params (se_hba_t *hba, se_subsystem_dev_t
 	return((ssize_t)bl);
 }
 
+extern se_device_t *pscsi_create_virtdevice_from_fd (
+	se_subsystem_dev_t *se_dev,
+	const char *page)
+{
+	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) se_dev->se_dev_su_ptr;
+	se_device_t *dev = NULL;
+	se_hba_t *hba = se_dev->se_dev_hba;
+	struct block_device *bd = NULL;
+	struct file *filp;
+	struct gendisk *gd = NULL;
+	struct inode *inode;
+	struct scsi_device *sd = NULL;
+	struct Scsi_Host *sh = (struct Scsi_Host *)hba->hba_ptr;
+	char *p = (char *)page;
+	int fd;
+
+	fd = simple_strtol(p, &p, 0);
+	if ((fd < 3 || fd > 7)) {
+		printk(KERN_ERR "PSCSI: Illegal value of file descriptor: %d\n", fd);
+		return(ERR_PTR(-EINVAL));
+	}
+	if (!(filp = fget(fd))) {
+		printk(KERN_ERR "PSCSI: Unable to fget() fd: %d\n", fd);
+		return(ERR_PTR(-EBADF));
+	}
+	if (!(inode = igrab(filp->f_mapping->host))) {
+		printk(KERN_ERR "PSCSI: Unable to locate struct inode for struct"
+				" block_device fd\n");
+		fput(filp);
+		return(ERR_PTR(-EINVAL));
+	}
+	/*
+	 * Look for struct scsi_device with a backing struct block_device.
+	 *
+	 * This means struct scsi_device->type == TYPE_DISK && TYPE_ROM.
+	 */
+	if (S_ISBLK(inode->i_mode)) {
+		if (!(bd = I_BDEV(filp->f_mapping->host))) {
+			printk(KERN_ERR "PSCSI: Unable to locate struct"
+				" block_device from I_BDEV()\n");
+			iput(inode);
+			fput(filp);
+			return(ERR_PTR(-EINVAL));
+		}
+		if (!(gd = bd->bd_disk)) {
+			printk(KERN_ERR "PSCSI: Unable to locate struct gendisk"
+				" from struct block_device\n");
+			iput(inode);
+			fput(filp);
+			return(ERR_PTR(-EINVAL));
+		}
+		/*
+		 * This struct gendisk->driver_fs() is marked as "// remove'
+		 * in include/linux/genhd.h..
+		 *
+		 * Currently in drivers/scsi/s[d,r].c:s[d,r]_probe(), this
+		 * pointer gets set by struct scsi_device->sdev_gendev.
+		 *
+		 * Is there a better way to locate struct scsi_device from
+		 * struct inode..?
+		 */
+		if (!(gd->driverfs_dev)) {
+			printk(KERN_ERR "PSCSI: struct gendisk->driverfs_dev"
+					" is NULL!\n");
+			iput(inode);
+			fput(filp);
+			return(ERR_PTR(-EINVAL));
+		}
+		if (!(sd = to_scsi_device(gd->driverfs_dev))) {
+			printk(KERN_ERR "PSCSI: Unable to locate struct scsi_device"
+				" from struct gendisk->driverfs_dev\n");
+			iput(inode);
+			fput(filp);
+			return(ERR_PTR(-EINVAL));
+		}
+		if (sd->host != sh) {
+			printk(KERN_ERR "PSCSI: Trying to attach scsi_device"
+				" Host ID: %d, but se_hba_t has SCSI Host ID: %d\n",
+				sd->host->host_no, sh->host_no);
+			iput(inode);
+			fput(filp);
+			return(ERR_PTR(-EINVAL));
+		}
+		/*
+		 * pscsi_create_type_[disk,rom]() will release host_lock..
+		 */
+		spin_lock_irq(sh->host_lock);
+		switch (sd->type) {
+		case TYPE_DISK:
+			dev = pscsi_create_type_disk(sd, pdv, se_dev->se_dev_hba);
+			break;
+		case TYPE_ROM:
+			dev = pscsi_create_type_rom(sd, pdv, se_dev->se_dev_hba);
+			break;
+		default:
+			printk(KERN_ERR "PSCSI: Unable to handle type S_ISBLK() =="
+				" TRUE Type: %s\n", scsi_device_type(sd->type));
+			spin_unlock_irq(sh->host_lock);
+			iput(inode);
+			fput(filp);
+			return(ERR_PTR(-ENOSYS));
+		}
+	} else if (S_ISCHR(inode->i_mode)) {
+#warning FIXME: Figure how to get struct scsi_device from character device's struct inode
+		printk(KERN_ERR "SCSI Character Device unsupported via"
+			" configfs/fd  method.  Use configfs/control instead\n");
+		iput(inode);
+		fput(filp);
+		return(ERR_PTR(-ENOSYS));
+	} else {
+		printk(KERN_ERR "PSCSI: File destriptor is not SCSI block or character"
+			" device, ignoring\n");
+		iput(inode);
+		fput(filp);
+		return(ERR_PTR(-ENODEV));
+	}
+
+	iput(inode);
+	fput(filp);
+	return(dev);
+}
+
 extern int pscsi_check_dev_params (se_hba_t *hba, struct iscsi_target *t, se_dev_transport_info_t *dti)
 {
 	if (!(t->hba_params_set & PARAM_HBA_SCSI_CHANNEL_ID)) {
diff --git a/drivers/lio-core/target_core_pscsi.h b/drivers/lio-core/target_core_pscsi.h
index 74d444b..f2883d8 100644
--- a/drivers/lio-core/target_core_pscsi.h
+++ b/drivers/lio-core/target_core_pscsi.h
@@ -75,6 +75,7 @@ extern int pscsi_check_hba_params (se_hbainfo_t *, struct iscsi_target *, int);
 extern ssize_t pscsi_set_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *, const char *, ssize_t);
 extern ssize_t pscsi_check_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *);
 extern ssize_t pscsi_show_configfs_dev_params (se_hba_t *, se_subsystem_dev_t *, char *);
+extern se_device_t *pscsi_create_virtdevice_from_fd (se_subsystem_dev_t *, const char *);
 extern int pscsi_check_dev_params (se_hba_t *, struct iscsi_target *, se_dev_transport_info_t *);
 extern void pscsi_get_plugin_info (void *, char *, int *);
 extern void pscsi_get_hba_info (se_hba_t *, char *, int *);
@@ -166,6 +167,7 @@ se_subsystem_spc_t pscsi_template_spc = ISCSI_PSCSI_SPC;
 	check_configfs_dev_params: pscsi_check_configfs_dev_params, \
 	set_configfs_dev_params: pscsi_set_configfs_dev_params, \
 	show_configfs_dev_params: pscsi_show_configfs_dev_params, \
+	create_virtdevice_from_fd: pscsi_create_virtdevice_from_fd, \
 	check_dev_params:	pscsi_check_dev_params,		\
 	get_plugin_info:	pscsi_get_plugin_info,		\
 	get_hba_info:		pscsi_get_hba_info,		\
-- 
1.5.4.1



