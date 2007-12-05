From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in
 directory)
Date: Tue, 4 Dec 2007 18:51:52 -0800
Message-ID: <20071204185152.880af2cf.akpm@linux-foundation.org>
References: <20071204165738.48003b8a.akpm@linux-foundation.org>
	<20071205100403Y.fujita.tomonori@lab.ntt.co.jp>
	<20071204171155.33ea58c9.akpm@linux-foundation.org>
	<20071205103054B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbXLECwJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 21:52:09 -0500
In-Reply-To: <20071205103054B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: matthew@wil.cx, anders.henke@1und1.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Wed, 05 Dec 2007 10:30:54 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 4 Dec 2007 17:11:55 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 05 Dec 2007 10:04:03 +0900
> > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > 
> > > On Tue, 4 Dec 2007 16:57:38 -0800
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > On Thu, 29 Nov 2007 13:31:50 +0100
> > > > Anders Henke <anders.henke@1und1.de> wrote:
> > > > 
> > > > > On November 28 2007, Anders Henke wrote:
> > > > > > As "everything is reported as being zero" is quite odd an Jan took a
> > > > > > guess that it might be block-layer or driver-related, I've assumed
> > > > > > that the driver is responsible for this; just out of the curiousity, 
> > > > > > I've manually replaced the dpt_i2o driver by the 2.6.19 one by copying 
> > > > > > driver/scsi/dpt_i2o.c driver/scsi/dpti.h and driver/scsi/dpt/ into a 
> > > > > > vanilla 2.6.23.1. kernel; using this kernel fixed the issue for me.
> > > > > > 
> > > > > > I haven't yet fine-tested from which kernel release on the dpt_i2o driver 
> > > > > > behaves like this and spews out zeroed blocks when trying to mount
> > > > > > the rootfs. Maybe this is just some timing issue.
> > > > > 
> > > > > I've started the fine-tests and can say so far that dpt_i2o from 
> > > > > 2.6.22 is still fine. Test is simple:
> > > > > 
> > > > > anders@ista:/usr/src/linux-2.6.22/drivers/scsi/dpt$ cp -r dpt/ dpt_i2o.c dpti.h /usr/src/linux-2.6.23.1/drivers/scsi/
> > > > > 
> > > > > ... recompile the kernel, reboot: works.
> > > > > 
> > > > > 2.6.22 and 2.6.23 differ in terms of the dpt_i2o driver by two different
> > > > > patch sets:
> > > > > -one 2 Kb small set of patches from 2.6.22 to 2.6.22-rc1
> > > > > -one 7 Kb set of patches from 2.6.23-rc2 to 2.6.23-rc3
> > > > > -one 162 Kb set of patches from 2.6.23-rc9 to 2.6.23-rc10.
> > > > > 
> > > > > When applying the 2.6.23-rc1-based driver to "my" 2.6.31.1 kernel,
> > > > > the "zero blocks"-symptom show up, so it's the "lucky" situation
> > > > > that the smallest patch actually seams to be the broken one.
> > > > > 
> > > > > According to the 2.6.23-rc1 short-form changelog, there is
> > > > > one major edit on the dpt_i2o driver:
> > > > > 
> > > > > FUJITA Tomonori 
> > > > > 
> > > > >       [SCSI] dpt_i2o: convert to use the data buffer accessors
> > > > > 
> > > > > Stephen Rothwell 
> > > > >       dpt_i2o depends on virt_to_bus
> > > > > 
> > > > > Fujita, would you please take a look at this?
> > > > 
> > > > He won't have seen this.  cc's added.
> > > > 
> > > > > I think that something's broken in there, leading to the dpt_i2o 
> > > > > sending out blocks of zeroes right after initialization, at least on
> > > > > some specific controllers (in this case, Adaptec 2010S on Intel
> > > > > SE7501WV2S-based boxes).
> > > > > 
> > > > > I don't have insight kernel driver development knowledge, so I'm
> > > > > quite out of help right now. Nevertheless, I'll add the diff
> > > > > from 2.6.22 to 2.6.23-rc1 in terms of dpt_i2o:
> > > > > 
> > > > 
> > > > Can you please confirm that this revert (against 2.6.24-rc4) fixes the data
> > > > corruption problems?
> > > 
> > > Anders said that my patch is fine and seems that Matthew's hotplug
> > > conversion patch leads to the problem:
> > > 
> > > http://marc.info/?l=linux-kernel&m=119641892129732&w=2
> > 
> > Oh.  Jan broke message threading :(
> > 
> > So it's been nearly a week and nothing has happened?  Do we revert that
> > change?
> 
> SCSI people really want this conversion...
> 
> Matthew, did you have a chance to look at it?

It seems pretty improbably that a change of that nature could cause data
corruption.  Anders, are you able to determine whether the revert (against
current Linus mainline or 2.6.24-rc4) fixes things?  Because it would be
very strange...

This is a grave bug.  It's really quite urgent...

Thanks.

 drivers/scsi/dpt_i2o.c |  132 ++++++++++++++++++---------------------
 drivers/scsi/dpti.h    |    9 ++
 2 files changed, 68 insertions(+), 73 deletions(-)

diff -puN drivers/scsi/dpt_i2o.c~revert-dpt_i2o-convert-to-scsi-hotplug-model drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~revert-dpt_i2o-convert-to-scsi-hotplug-model
+++ a/drivers/scsi/dpt_i2o.c
@@ -173,20 +173,20 @@ static struct pci_device_id dptids[] = {
 };
 MODULE_DEVICE_TABLE(pci,dptids);
 
-static void adpt_exit(void);
-
-static int adpt_detect(void)
+static int adpt_detect(struct scsi_host_template* sht)
 {
 	struct pci_dev *pDev = NULL;
 	adpt_hba* pHba;
 
+	adpt_init();
+
 	PINFO("Detecting Adaptec I2O RAID controllers...\n");
 
         /* search for all Adatpec I2O RAID cards */
 	while ((pDev = pci_get_device( PCI_DPT_VENDOR_ID, PCI_ANY_ID, pDev))) {
 		if(pDev->device == PCI_DPT_DEVICE_ID ||
 		   pDev->device == PCI_DPT_RAPTOR_DEVICE_ID){
-			if(adpt_install_hba(pDev) ){
+			if(adpt_install_hba(sht, pDev) ){
 				PERROR("Could not Init an I2O RAID device\n");
 				PERROR("Will not try to detect others.\n");
 				return hba_count-1;
@@ -248,33 +248,34 @@ rebuild_sys_tab:
 	}
 
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
-		if (adpt_scsi_register(pHba) < 0) {
+		if( adpt_scsi_register(pHba,sht) < 0){
 			adpt_i2o_delete_hba(pHba);
 			continue;
 		}
 		pHba->initialized = TRUE;
 		pHba->state &= ~DPTI_STATE_RESET;
-		scsi_scan_host(pHba->host);
 	}
 
 	// Register our control device node
 	// nodes will need to be created in /dev to access this
 	// the nodes can not be created from within the driver
 	if (hba_count && register_chrdev(DPTI_I2O_MAJOR, DPT_DRIVER, &adpt_fops)) {
-		adpt_exit();
+		adpt_i2o_sys_shutdown();
 		return 0;
 	}
 	return hba_count;
 }
 
 
-static int adpt_release(adpt_hba *pHba)
+/*
+ * scsi_unregister will be called AFTER we return.
+ */
+static int adpt_release(struct Scsi_Host *host)
 {
-	struct Scsi_Host *shost = pHba->host;
-	scsi_remove_host(shost);
+	adpt_hba* pHba = (adpt_hba*) host->hostdata[0];
 //	adpt_i2o_quiesce_hba(pHba);
 	adpt_i2o_delete_hba(pHba);
-	scsi_host_put(shost);
+	scsi_unregister(host);
 	return 0;
 }
 
@@ -881,7 +882,7 @@ static int adpt_reboot_event(struct noti
 #endif
 
 
-static int adpt_install_hba(struct pci_dev* pDev)
+static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev)
 {
 
 	adpt_hba* pHba = NULL;
@@ -1028,6 +1029,8 @@ static void adpt_i2o_delete_hba(adpt_hba
 
 
 	mutex_lock(&adpt_configuration_lock);
+	// scsi_unregister calls our adpt_release which
+	// does a quiese
 	if(pHba->host){
 		free_irq(pHba->host->irq, pHba);
 	}
@@ -1079,6 +1082,17 @@ static void adpt_i2o_delete_hba(adpt_hba
 }
 
 
+static int adpt_init(void)
+{
+	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
+#ifdef REBOOT_NOTIFIER
+	register_reboot_notifier(&adpt_reboot_notifier);
+#endif
+
+	return 0;
+}
+
+
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun)
 {
 	struct adpt_device* d;
@@ -2164,6 +2178,37 @@ static s32 adpt_scsi_to_i2o(adpt_hba* pH
 }
 
 
+static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht)
+{
+	struct Scsi_Host *host = NULL;
+
+	host = scsi_register(sht, sizeof(adpt_hba*));
+	if (host == NULL) {
+		printk ("%s: scsi_register returned NULL\n",pHba->name);
+		return -1;
+	}
+	host->hostdata[0] = (unsigned long)pHba;
+	pHba->host = host;
+
+	host->irq = pHba->pDev->irq;
+	/* no IO ports, so don't have to set host->io_port and
+	 * host->n_io_port
+	 */
+	host->io_port = 0;
+	host->n_io_port = 0;
+				/* see comments in scsi_host.h */
+	host->max_id = 16;
+	host->max_lun = 256;
+	host->max_channel = pHba->top_scsi_channel + 1;
+	host->cmd_per_lun = 1;
+	host->unique_id = (uint) pHba;
+	host->sg_tablesize = pHba->sg_tablesize;
+	host->can_queue = pHba->post_fifo_size;
+
+	return 0;
+}
+
+
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd)
 {
 	adpt_hba* pHba;
@@ -3279,10 +3324,12 @@ static static void adpt_delay(int millis
 
 #endif
 
-static struct scsi_host_template adpt_template = {
+static struct scsi_host_template driver_template = {
 	.name			= "dpt_i2o",
 	.proc_name		= "dpt_i2o",
 	.proc_info		= adpt_proc_info,
+	.detect			= adpt_detect,
+	.release		= adpt_release,
 	.info			= adpt_info,
 	.queuecommand		= adpt_queue,
 	.eh_abort_handler	= adpt_abort,
@@ -3297,62 +3344,5 @@ static struct scsi_host_template adpt_te
 	.use_clustering		= ENABLE_CLUSTERING,
 	.use_sg_chaining	= ENABLE_SG_CHAINING,
 };
-
-static s32 adpt_scsi_register(adpt_hba* pHba)
-{
-	struct Scsi_Host *host;
-
-	host = scsi_host_alloc(&adpt_template, sizeof(adpt_hba*));
-	if (host == NULL) {
-		printk ("%s: scsi_host_alloc returned NULL\n",pHba->name);
-		return -1;
-	}
-	host->hostdata[0] = (unsigned long)pHba;
-	pHba->host = host;
-
-	host->irq = pHba->pDev->irq;
-	/* no IO ports, so don't have to set host->io_port and
-	 * host->n_io_port
-	 */
-	host->io_port = 0;
-	host->n_io_port = 0;
-				/* see comments in scsi_host.h */
-	host->max_id = 16;
-	host->max_lun = 256;
-	host->max_channel = pHba->top_scsi_channel + 1;
-	host->cmd_per_lun = 1;
-	host->unique_id = (uint) pHba;
-	host->sg_tablesize = pHba->sg_tablesize;
-	host->can_queue = pHba->post_fifo_size;
-
-	if (scsi_add_host(host, &pHba->pDev->dev)) {
-		scsi_host_put(host);
-		return -1;
-	}
-
-	return 0;
-}
-
-static int __init adpt_init(void)
-{
-	int count;
-
-	printk("Loading Adaptec I2O RAID: Version " DPT_I2O_VERSION "\n");
-#ifdef REBOOT_NOTIFIER
-	register_reboot_notifier(&adpt_reboot_notifier);
-#endif
-
-	count = adpt_detect();
-
-	return count > 0 ? 0 : -ENODEV;
-}
-
-static void adpt_exit(void)
-{
-	while (hba_chain)
-		adpt_release(hba_chain);
-}
-
-module_init(adpt_init);
-module_exit(adpt_exit);
+#include "scsi_module.c"
 MODULE_LICENSE("GPL");
diff -puN drivers/scsi/dpti.h~revert-dpt_i2o-convert-to-scsi-hotplug-model drivers/scsi/dpti.h
--- a/drivers/scsi/dpti.h~revert-dpt_i2o-convert-to-scsi-hotplug-model
+++ a/drivers/scsi/dpti.h
@@ -28,9 +28,11 @@
  * SCSI interface function Prototypes
  */
 
+static int adpt_detect(struct scsi_host_template * sht);
 static int adpt_queue(struct scsi_cmnd * cmd, void (*cmdcomplete) (struct scsi_cmnd *));
 static int adpt_abort(struct scsi_cmnd * cmd);
 static int adpt_reset(struct scsi_cmnd* cmd);
+static int adpt_release(struct Scsi_Host *host);
 static int adpt_slave_configure(struct scsi_device *);
 
 static const char *adpt_info(struct Scsi_Host *pSHost);
@@ -47,6 +49,8 @@ static int adpt_device_reset(struct scsi
 
 #define DPT_DRIVER_NAME	"Adaptec I2O RAID"
 
+#ifndef HOSTS_C
+
 #include "dpt/sys_info.h"
 #include <linux/wait.h>
 #include "dpt/dpti_i2o.h"
@@ -285,7 +289,7 @@ static s32 adpt_i2o_init_outbound_q(adpt
 static s32 adpt_i2o_hrt_get(adpt_hba* pHba);
 static s32 adpt_scsi_to_i2o(adpt_hba* pHba, struct scsi_cmnd* cmd, struct adpt_device* dptdevice);
 static s32 adpt_i2o_to_scsi(void __iomem *reply, struct scsi_cmnd* cmd);
-static s32 adpt_scsi_register(adpt_hba* pHba);
+static s32 adpt_scsi_register(adpt_hba* pHba,struct scsi_host_template * sht);
 static s32 adpt_hba_reset(adpt_hba* pHba);
 static s32 adpt_i2o_reset_hba(adpt_hba* pHba);
 static s32 adpt_rescan(adpt_hba* pHba);
@@ -295,7 +299,7 @@ static void adpt_i2o_delete_hba(adpt_hba
 static void adpt_inquiry(adpt_hba* pHba);
 static void adpt_fail_posted_scbs(adpt_hba* pHba);
 static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u32 lun);
-static int adpt_install_hba(struct pci_dev* pDev) ;
+static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev) ;
 static int adpt_i2o_online_hba(adpt_hba* pHba);
 static void adpt_i2o_post_wait_complete(u32, int);
 static int adpt_i2o_systab_send(adpt_hba* pHba);
@@ -339,4 +343,5 @@ static void adpt_i386_info(sysInfo_S* si
 #define FW_DEBUG_BLED_OFFSET       8
 
 #define FW_DEBUG_FLAGS_NO_HEADERS_B    0x01
+#endif				/* !HOSTS_C */
 #endif				/* _DPT_H */
_

