From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 1)
Date: Tue, 10 Feb 2004 21:21:57 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210212157.A10734@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F255013@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:2832 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265924AbUBJVV7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 16:21:59 -0500
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F255013@otce2k03.adaptec.com>; from mark_salyzyn@adaptec.com on Tue, Feb 10, 2004 at 03:53:06PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

+#if (defined(__x86_64__))
+# include <asm-x86_64/ioctl32.h>
+#endif

	This is broken.  Please use the generic ioctl32 facilities.

-static struct i2o_sys_tbl *sys_tbl = NULL;
+static struct i2o_sys_tbl *sys_tbl_va = NULL;

	No need to NULL-initialize this..

+// If this is driver is embedded in the kernel this define
+// should be moved to include/linux/proc_fs.h as an emumerated type
+#define PROC_SCSI_DPT_I2O  0
+struct proc_dir_entry proc_scsi_dptI2O = {
+	PROC_SCSI_DPT_I2O, 7, DPT_DRIVER,
+	S_IFDIR | S_IRUGO | S_IXUGO, 2,
+	0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL
+};

	This seems unused, and if it wasn't it would be a bug.

 	PINFO("Detecting Adaptec I2O RAID controllers...\n");


-        /* search for all Adatpec I2O RAID cards */
-	while ((pDev = pci_find_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
-		if(pDev->device == PCI_DPT_DEVICE_ID ||
-		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
+        /* search for all Adaptec I2O RAID cards */
+	while ((pDev = pci_find_device( dptids[0].vendor, PCI_ANY_ID, pDev))) {
+		if(pDev->device == dptids[0].device ||
+		   pDev->device == dptids[1].device){

	This screams for using a proper pci_driver interface..

+		/*
+		 *	We are called before the host & host lock has been
+		 * assigned, and may be called with, or without, the host lock
+		 * held. We need to free the lock, if held, before going
+		 * to sleep.
+		 */
+		if ((pHba->host != NULL) /* Sad */
+		 && (spin_is_locked(pHba->host->host_lock))) {

	This is bogus as hell.  Who said you took the lock?

+	case DPT_TARGET_BUSY & 0xFFFF:
+	case DPT_TARGET_BUSY:
+	{
+		TARGET_BUSY_T busy;
+		struct adpt_device* d;
+
+		if (copy_from_user((void*)&busy, (void*)arg, sizeof(TARGET_BUSY_T))) {
+			return -EFAULT;
+		}
+
+		d = adpt_find_device(pHba, busy.channel, busy.id, busy.lun);
+		if(d == NULL){
+			return -ENODEV;
+		}
+		busy.isBusy = ((d->pScsi_dev)
+		 && (d->pScsi_dev->device_busy /* Imperfect */
+		  || test_bit(SHOST_RECOVERY, &pHba->host->shost_state)));
+		if (copy_to_user ((char*)arg, &busy, sizeof(busy))) {
+			return -EFAULT;
+		}
+		break;
+	}

	This ioctl was removed because it's broken.  Don't readd it.

+		shost_for_each_device(d, pHba->host) {
+			unsigned long flags;
+			spin_lock_irqsave(&d->list_lock, flags);
+			list_for_each_entry(cmd, &d->cmd_list, list) {
+				if (((u32)cmd->serial_number == context)
+				 || ((u32)cmd->serial_number_at_timeout == context)) {
+					spin_unlock_irqrestore(&d->list_lock, flags);
+					return cmd;

	Where do release the reference to the scsi_device again?

