From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64 bit and bitrot (part 1)
Date: Tue, 10 Feb 2004 16:47:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F255028@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:46530 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261506AbUBJVr7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 16:47:59 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Responses embedded with [MS]

Thanks!

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Tuesday, February 10, 2004 4:22 PM
To: Salyzyn, Mark
Cc: linux-scsi
Subject: Re: [PATCH] dpt_i2o changes for 2.6.2 kernel in support of 64
bit and bitrot (part 1)

+#if (defined(__x86_64__))
+# include <asm-x86_64/ioctl32.h>
+#endif

	This is broken.  Please use the generic ioctl32 facilities.

[MS] baby steps perhaps. This *worked* with the 32 bit configuration
utilities under an AMD-64 machine using a 2.4 based kernel and we are
merely seeing me poluting code coming in from the 2.4 tree. I had a ToDo
in order to investigate IA64 support and application function under the
2.6 kernel.

-static struct i2o_sys_tbl *sys_tbl = NULL;
+static struct i2o_sys_tbl *sys_tbl_va = NULL;

	No need to NULL-initialize this..
[MS] no disagreement here!

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

[MS] I am unsure of the origin of this change, could be dropped I am
sure.


-        /* search for all Adatpec I2O RAID cards */
-	while ((pDev = pci_find_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID,
pDev))) {
-		if(pDev->device == PCI_DPT_DEVICE_ID ||
-		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
+        /* search for all Adaptec I2O RAID cards */
+	while ((pDev = pci_find_device( dptids[0].vendor, PCI_ANY_ID,
pDev))) {
+		if(pDev->device == dptids[0].device ||
+		   pDev->device == dptids[1].device){

	This screams for using a proper pci_driver interface..
[MS] on the to-do list. This patch is already big enough just to '64bit'
enable the driver.

+		/*
+		 *	We are called before the host & host lock has
been
+		 * assigned, and may be called with, or without, the
host lock
+		 * held. We need to free the lock, if held, before going
+		 * to sleep.
+		 */
+		if ((pHba->host != NULL) /* Sad */
+		 && (spin_is_locked(pHba->host->host_lock))) {

	This is bogus as hell.  Who said you took the lock?
[MS] without this code (under the 2.4 tree) I had a lockup. I did not
check that this problem existed under the 2.6 tree, simply mimicking the
innocuous 2.4ism. This would need to be tested when removed

+	case DPT_TARGET_BUSY & 0xFFFF:
+	case DPT_TARGET_BUSY:
+	{
+		TARGET_BUSY_T busy;
+		struct adpt_device* d;
+
+		if (copy_from_user((void*)&busy, (void*)arg,
sizeof(TARGET_BUSY_T))) {
+			return -EFAULT;
+		}
+
+		d = adpt_find_device(pHba, busy.channel, busy.id,
busy.lun);
+		if(d == NULL){
+			return -ENODEV;
+		}
+		busy.isBusy = ((d->pScsi_dev)
+		 && (d->pScsi_dev->device_busy /* Imperfect */
+		  || test_bit(SHOST_RECOVERY,
&pHba->host->shost_state)));
+		if (copy_to_user ((char*)arg, &busy, sizeof(busy))) {
+			return -EFAULT;
+		}
+		break;
+	}

	This ioctl was removed because it's broken.  Don't readd it.
[MS] the applications need this ... without this the user is *not*
warned when they perform dangerous raid manipulations when the device is
in use, or for that matter currently in error recovery. Suggestions to
re-enable this support in the 2.6 tree?

+		shost_for_each_device(d, pHba->host) {
+			unsigned long flags;
+			spin_lock_irqsave(&d->list_lock, flags);
+			list_for_each_entry(cmd, &d->cmd_list, list) {
+				if (((u32)cmd->serial_number == context)
+				 || ((u32)cmd->serial_number_at_timeout
== context)) {
+
spin_unlock_irqrestore(&d->list_lock, flags);
+					return cmd;

	Where do release the reference to the scsi_device again?

[MS] Eeek. I may need some 'splaining here. Am I using the
shost_for_each_device interface incorrectly? We are using
__shost_for_each_device in the aacraid driver ...

