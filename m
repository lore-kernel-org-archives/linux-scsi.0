From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] scsi: wrap remaining problem users of ->ioctl
Date: Thu, 22 May 2008 22:42:31 +0100
Message-ID: <20080522224231.70d8a866@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53896 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756909AbYEVVzA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2008 17:55:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

These appear to need the lock so we wrap the method

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 8508816..32396b6 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -118,7 +118,7 @@ static long compat_adpt_ioctl(struct file *, unsigned int, unsigned long);
 #endif
 
 static const struct file_operations adpt_fops = {
-	.ioctl		= adpt_ioctl,
+	.unlocked_ioctl	= adpt_ioctl,
 	.open		= adpt_open,
 	.release	= adpt_close,
 #ifdef CONFIG_COMPAT
@@ -2057,19 +2057,19 @@ static int adpt_system_info(void __user *buffer)
 	return 0;
 }
 
-static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
-	      ulong arg)
+static long adpt_ioctl(struct file *file, uint cmd, ulong arg)
 {
-	int minor;
-	int error = 0;
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
+	long ret = 0;
 	adpt_hba* pHba;
 	ulong flags = 0;
 	void __user *argp = (void __user *)arg;
 
-	minor = iminor(inode);
 	if (minor >= DPTI_MAX_HBA){
 		return -ENXIO;
 	}
+
+	lock_kernel();
 	mutex_lock(&adpt_configuration_lock);
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
 		if (pHba->unit == minor) {
@@ -2078,6 +2078,7 @@ static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
 	}
 	mutex_unlock(&adpt_configuration_lock);
 	if(pHba == NULL){
+		unlock_kernel();
 		return -ENXIO;
 	}
 
@@ -2087,12 +2088,12 @@ static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
 	switch (cmd) {
 	// TODO: handle 3 cases
 	case DPT_SIGNATURE:
-		if (copy_to_user(argp, &DPTI_sig, sizeof(DPTI_sig))) {
-			return -EFAULT;
-		}
+		if (copy_to_user(argp, &DPTI_sig, sizeof(DPTI_sig)))
+			ret = -EFAULT;
 		break;
 	case I2OUSRCMD:
-		return adpt_i2o_passthru(pHba, argp);
+		ret = adpt_i2o_passthru(pHba, argp);
+		break;
 
 	case DPT_CTRLINFO:{
 		drvrHBAinfo_S HbaInfo;
@@ -2110,17 +2111,18 @@ static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
 		HbaInfo.hbaFlags = FLG_OSD_PCI_VALID | FLG_OSD_DMA | FLG_OSD_I2O;
 		if(copy_to_user(argp, &HbaInfo, sizeof(HbaInfo))){
 			printk(KERN_WARNING"%s: Could not copy HbaInfo TO user\n",pHba->name);
-			return -EFAULT;
+			ret = -EFAULT;
 		}
 		break;
 		}
 	case DPT_SYSINFO:
-		return adpt_system_info(argp);
+		ret = adpt_system_info(argp);
+		break;
 	case DPT_BLINKLED:{
 		u32 value;
 		value = (u32)adpt_read_blink_led(pHba);
 		if (copy_to_user(argp, &value, sizeof(value))) {
-			return -EFAULT;
+			ret = -EFAULT;
 		}
 		break;
 		}
@@ -2135,10 +2137,10 @@ static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
 		adpt_rescan(pHba);
 		break;
 	default:
-		return -EINVAL;
+		ret = -ENOTTY;
 	}
-
-	return error;
+	unlock_kernel();
+	return ret;
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 337746d..a6784b8 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -307,7 +307,7 @@ static int adpt_i2o_online_hba(adpt_hba* pHba);
 static void adpt_i2o_post_wait_complete(u32, int);
 static int adpt_i2o_systab_send(adpt_hba* pHba);
 
-static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg);
+static long adpt_ioctl(struct file *file, uint cmd, ulong arg);
 static int adpt_open(struct inode *inode, struct file *file);
 static int adpt_close(struct inode *inode, struct file *file);
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 8e2e964..bd1289d 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -178,8 +178,8 @@ static const char *gdth_ctr_name(gdth_ha_str *ha);
 
 static int gdth_open(struct inode *inode, struct file *filep);
 static int gdth_close(struct inode *inode, struct file *filep);
-static int gdth_ioctl(struct inode *inode, struct file *filep,
-                      unsigned int cmd, unsigned long arg);
+static long gdth_ioctl(struct file *filep, unsigned int cmd,
+						unsigned long arg);
 
 static void gdth_flush(gdth_ha_str *ha);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
@@ -367,7 +367,7 @@ MODULE_LICENSE("GPL");
 
 /* ioctl interface */
 static const struct file_operations gdth_fops = {
-    .ioctl   = gdth_ioctl,
+    .unlocked_ioctl   = gdth_ioctl,
     .open    = gdth_open,
     .release = gdth_close,
 };
@@ -4419,12 +4419,13 @@ free_fail:
     return rc;
 }
   
-static int gdth_ioctl(struct inode *inode, struct file *filep,
-                      unsigned int cmd, unsigned long arg)
+static long gdth_ioctl(struct file *filep, unsigned int cmd,
+						unsigned long arg)
 {
     gdth_ha_str *ha; 
     Scsi_Cmnd *scp;
     ulong flags;
+    long ret = 0;
     char cmnd[MAX_COMMAND_SIZE];   
     void __user *argp = (void __user *)arg;
 
@@ -4432,12 +4433,13 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
     
     TRACE(("gdth_ioctl() cmd 0x%x\n", cmd));
  
+    lock_kernel();
     switch (cmd) {
       case GDTIOCTL_CTRCNT:
       { 
         int cnt = gdth_ctr_count;
         if (put_user(cnt, (int __user *)argp))
-                return -EFAULT;
+                ret = -EFAULT;
         break;
       }
 
@@ -4445,7 +4447,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
       { 
         int ver = (GDTH_VERSION<<8) | GDTH_SUBVERSION;
         if (put_user(ver, (int __user *)argp))
-                return -EFAULT;
+                ret = -EFAULT;
         break;
       }
       
@@ -4457,7 +4459,7 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         osv.subversion = (unchar)(LINUX_VERSION_CODE >> 8);
         osv.revision = (ushort)(LINUX_VERSION_CODE & 0xff);
         if (copy_to_user(argp, &osv, sizeof(gdth_ioctl_osvers)))
-                return -EFAULT;
+                ret = -EFAULT;
         break;
       }
 
@@ -4466,8 +4468,10 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         gdth_ioctl_ctrtype ctrt;
         
         if (copy_from_user(&ctrt, argp, sizeof(gdth_ioctl_ctrtype)) ||
-            (NULL == (ha = gdth_find_ha(ctrt.ionode))))
-            return -EFAULT;
+            (NULL == (ha = gdth_find_ha(ctrt.ionode)))) {
+            ret = -EFAULT;
+            break;
+        }
 
         if (ha->type == GDT_ISA || ha->type == GDT_EISA) {
             ctrt.type = (unchar)((ha->stype>>20) - 0x10);
@@ -4488,18 +4492,21 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         ctrt.info = ha->brd_phys;
         ctrt.oem_id = ha->oem_id;
         if (copy_to_user(argp, &ctrt, sizeof(gdth_ioctl_ctrtype)))
-            return -EFAULT;
+            ret = -EFAULT;
         break;
       }
         
       case GDTIOCTL_GENERAL:
-        return ioc_general(argp, cmnd);
+        ret = ioc_general(argp, cmnd);
+        break;
 
       case GDTIOCTL_EVENT:
-        return ioc_event(argp);
+        ret = ioc_event(argp);
+        break;
 
       case GDTIOCTL_LOCKDRV:
-        return ioc_lockdrv(argp);
+        ret = ioc_lockdrv(argp);
+        break;
 
       case GDTIOCTL_LOCKCHN:
       {
@@ -4507,8 +4514,10 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         unchar i, j;
 
         if (copy_from_user(&lchn, argp, sizeof(gdth_ioctl_lockchn)) ||
-            (NULL == (ha = gdth_find_ha(lchn.ionode))))
-            return -EFAULT;
+            (NULL == (ha = gdth_find_ha(lchn.ionode)))) {
+            ret = -EFAULT;
+            break;
+        }
 
         i = lchn.channel;
         if (i < ha->bus_cnt) {
@@ -4534,10 +4543,12 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
       }
 
       case GDTIOCTL_RESCAN:
-        return ioc_rescan(argp, cmnd);
+        ret = ioc_rescan(argp, cmnd);
+        break;
 
       case GDTIOCTL_HDRLIST:
-        return ioc_hdrlist(argp, cmnd);
+        ret = ioc_hdrlist(argp, cmnd);
+        break;
 
       case GDTIOCTL_RESET_BUS:
       {
@@ -4545,12 +4556,16 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         int rval;
 
         if (copy_from_user(&res, argp, sizeof(gdth_ioctl_reset)) ||
-            (NULL == (ha = gdth_find_ha(res.ionode))))
-            return -EFAULT;
+            (NULL == (ha = gdth_find_ha(res.ionode)))) {
+            ret = -EFAULT;
+            break;
+        }
 
         scp  = kzalloc(sizeof(*scp), GFP_KERNEL);
-        if (!scp)
-            return -ENOMEM;
+        if (!scp) {
+            ret = -ENOMEM;
+            break;
+        }
         scp->device = ha->sdev;
         scp->cmd_len = 12;
         scp->device->channel = res.number;
@@ -4559,17 +4574,19 @@ static int gdth_ioctl(struct inode *inode, struct file *filep,
         kfree(scp);
 
         if (copy_to_user(argp, &res, sizeof(gdth_ioctl_reset)))
-            return -EFAULT;
+            ret = -EFAULT;
         break;
       }
 
       case GDTIOCTL_RESET_DRV:
-        return ioc_resetdrv(argp, cmnd);
+        ret = ioc_resetdrv(argp, cmnd);
+        break;
 
       default:
-        break; 
+        ret = -ENOTTY; 
     }
-    return 0;
+    unlock_kernel();
+    return ret;
 }
 
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 18551aa..d7d0375 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -94,7 +94,7 @@ static struct mega_hbas mega_hbas[MAX_CONTROLLERS];
  */
 static const struct file_operations megadev_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= megadev_ioctl,
+	.unlocked_ioctl	= megadev_ioctl,
 	.open		= megadev_open,
 };
 
@@ -3288,8 +3288,7 @@ megadev_open (struct inode *inode, struct file *filep)
 
 
 /**
- * megadev_ioctl()
- * @inode - Our device inode
+ * megadev_do_ioctl()
  * @filep - unused
  * @cmd - ioctl command
  * @arg - user buffer
@@ -3299,14 +3298,13 @@ megadev_open (struct inode *inode, struct file *filep)
  * ioctl to new ioctl command), and issue a synchronous command to the
  * controller.
  */
-static int
-megadev_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
-		unsigned long arg)
+static long
+megadev_do_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	adapter_t	*adapter;
 	nitioctl_t	uioc;
 	int		adapno;
-	int		rval;
+	long		rval;
 	mega_passthru	__user *upthru;	/* user address for passthru */
 	mega_passthru	*pthru;		/* copy user passthru here */
 	dma_addr_t	pthru_dma_hndl;
@@ -3692,6 +3690,16 @@ freemem_and_return:
 	return 0;
 }
 
+static long
+megadev_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = megadev_do_ioctl(filep, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 /**
  * mega_m_to_n()
  * @arg - user address
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index ee70bd4..ff44445 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -1013,8 +1013,7 @@ static void mega_8_to_40ld (mraid_inquiry *inquiry,
 		mega_inquiry3 *enquiry3, mega_product_info *);
 
 static int megadev_open (struct inode *, struct file *);
-static int megadev_ioctl (struct inode *, struct file *, unsigned int,
-		unsigned long);
+static long megadev_ioctl(struct file *, unsigned int, unsigned long);
 static int mega_m_to_n(void __user *, nitioctl_t *);
 static int mega_n_to_m(void __user *, megacmd_t *);
 
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 31f7aec..d88e2bd 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4843,8 +4843,8 @@ static int os_scsi_tape_close(struct inode * inode, struct file * filp)
 
 
 /* The ioctl command */
-static int osst_ioctl(struct inode * inode,struct file * file,
-	 unsigned int cmd_in, unsigned long arg)
+static long osst_ioctl(struct file * file, unsigned int cmd_in,
+							unsigned long arg)
 {
 	int		      i, cmd_nr, cmd_type, blk, retval = 0;
 	struct st_modedef   * STm;
@@ -4854,8 +4854,11 @@ static int osst_ioctl(struct inode * inode,struct file * file,
 	char		    * name  = tape_name(STp);
 	void	    __user  * p     = (void __user *)arg;
 
-	if (mutex_lock_interruptible(&STp->lock))
+	lock_kernel();
+	if (mutex_lock_interruptible(&STp->lock)) {
+		unlock_kernel();
 		return -ERESTARTSYS;
+	}
 
 #if DEBUG
 	if (debugging && !STp->in_use) {
@@ -5166,13 +5169,15 @@ static int osst_ioctl(struct inode * inode,struct file * file,
 	if (SRpnt) osst_release_request(SRpnt);
 
 	mutex_unlock(&STp->lock);
-
-	return scsi_ioctl(STp->device, cmd_in, p);
+	retval = scsi_ioctl(STp->device, cmd_in, p);
+	unlock_kernel();
+	return retval;
 
 out:
 	if (SRpnt) osst_release_request(SRpnt);
 
 	mutex_unlock(&STp->lock);
+	unlock_kernel();
 
 	return retval;
 }
@@ -5529,7 +5534,7 @@ static const struct file_operations osst_fops = {
 	.owner =        THIS_MODULE,
 	.read =         osst_read,
 	.write =        osst_write,
-	.ioctl =        osst_ioctl,
+	.unlocked_ioctl = osst_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = osst_compat_ioctl,
 #endif
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c9d7f72..ca8755a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -769,9 +769,8 @@ sg_srp_done(Sg_request *srp, Sg_fd *sfp)
 	return done;
 }
 
-static int
-sg_ioctl(struct inode *inode, struct file *filp,
-	 unsigned int cmd_in, unsigned long arg)
+static long
+do_sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
@@ -1086,6 +1085,16 @@ sg_ioctl(struct inode *inode, struct file *filp,
 	}
 }
 
+static long sg_ioctl(struct file *filp, unsigned int cmd_in,
+							unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = do_sg_ioctl(filp, cmd_in, arg);
+	unlock_kernel();
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -1329,7 +1338,7 @@ static struct file_operations sg_fops = {
 	.read = sg_read,
 	.write = sg_write,
 	.poll = sg_poll,
-	.ioctl = sg_ioctl,
+	.unlocked_ioctl = sg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = sg_compat_ioctl,
 #endif
