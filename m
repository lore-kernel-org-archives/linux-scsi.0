From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1, now 2.20.2.0
Date: Fri, 23 Jul 2004 18:02:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC8B1@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63378 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S268102AbUGWWFj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2004 18:05:39 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Mukker, Atul" <Atulm@lsil.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

All,

Here is the patch for the 2.20.2.0 as per suggestions made by James
Bottomley. The details are available in the changelog. As usual, the driver
package with kernel patches, complete driver code, and this patch is
available for download from
ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.2.0/ as well.

Highlights are:

1.	Changes made to remove yield()
2.	Added new vendor ids and corrected an existing one
3.	fix a bug in the management module, which causes a system lockup
after unloading io module


diff -Naur megaraid2.20.1.0/ChangeLog.megaraid
megaraid2.20.2.0/ChangeLog.megaraid
--- megaraid2.20.1.0/ChangeLog.megaraid	2004-06-25 21:42:30.000000000 -0400
+++ megaraid2.20.2.0/ChangeLog.megaraid	2004-07-23 17:41:52.144345736 -0400
@@ -1,3 +1,46 @@
+Release Date	: Fri Jul 23 15:22:07 EDT 2004 - Atul Mukker
<atulm@lsil.com>
+Current Version	: 2.20.2.0 (scsi module), 2.20.1.0 (cmm module)
+Older Version	: 2.20.1.0 (scsi module), 2.20.0.0 (cmm module)
+
+i.	Add PCI ids for Acer ROMB 2E solution
+
+ii.	Add PCI ids for I4 lk lk
+
+iii.	Typo corrected for subsys id for megaraid sata 300-4x
+
+iv.	Remove yield() while mailbox handshake in synchronous commands
+
+
+	"My other main gripe is things like this:
+
+	+	// wait for maximum 1 second for status to post
+	+	for (i = 0; i < 40000; i++) {
+	+		if (mbox->numstatus != 0xFF) break;
+	+		udelay(25); yield();
+	+	}
+
+	which litter the driver.  Use of yield() in drivers is deprecated."
+
+		- James Bottomley <James.Bottomley@SteelEye.com>, 07.14.2004
+		 linux-scsi mailing list
+
+v.	Remove redundant __megaraid_busywait_mbox routine
+
+vi.	Fix bug in the managment module, which causes a system lockup when
the
+	IO module is loaded and then unloaded, followed by executing any
+	management utility. The current version of management module does
not
+	handle the adapter unregister properly.
+
+	Specifically, it still keeps a reference to the unregistered
+	controllers. To avoid this, the static array adapters has been
+	replaced by a dynamic list, which gets updated every time an adapter
+	is added or removed.
+
+	Also, during unregistration of the IO module, the resources are
+	now released in the exact reverse order of the allocation time
+	sequence.
+
+
 Release Date	: Fri Jun 25 18:58:43 EDT 2004 - Atul Mukker
<atulm@lsil.com>
 Current Version	: 2.20.1.0
 Older Version	: megaraid 2.20.0.1
diff -Naur megaraid2.20.1.0/Kconfig.megaraid
megaraid2.20.2.0/Kconfig.megaraid
--- megaraid2.20.1.0/Kconfig.megaraid	2004-06-25 21:42:30.000000000 -0400
+++ megaraid2.20.2.0/Kconfig.megaraid	2004-07-23 17:41:52.144345736 -0400
@@ -51,8 +51,8 @@
 	LSI MegaRAID SATA 150-2		1095:3112:1000:0534
 	LSI MegaRAID SATA 150-4		1000:1960:1000:4523
 	LSI MegaRAID SATA 150-6		1000:1960:1000:0523
-	LSI MegaRAID SATA 150-4X	1000:0409:1000:1504
-	LSI MegaRAID SATA 150-8X	1000:0409:1000:1508
+	LSI MegaRAID SATA 150-4X	1000:0409:1000:3004
+	LSI MegaRAID SATA 150-8X	1000:0409:1000:3008
 	INTEL RAID Controller SRCU42X	1000:0407:8086:0532
 	INTEL RAID Controller SRCS16	1000:1960:8086:0523
 	INTEL RAID Controller SRCU42E	1000:0408:8086:0002
diff -Naur megaraid2.20.1.0/megaraid_ioctl.h
megaraid2.20.2.0/megaraid_ioctl.h
--- megaraid2.20.1.0/megaraid_ioctl.h	2004-06-25 21:42:30.000000000 -0400
+++ megaraid2.20.2.0/megaraid_ioctl.h	2004-07-23 17:41:52.145345584 -0400
@@ -64,8 +64,6 @@
 #define GET_STATS		0x50000
 #define GET_IOCTL_VERSION	0x01
 
-#define MAX_LSI_CMN_ADAPS	16
-
 #define EXT_IOCTL_SIGN_SZ	16
 #define EXT_IOCTL_SIGN		"$$_EXTD_IOCTL_$$"
 
@@ -249,6 +247,7 @@
  * @pdev		: pci dev; used for allocating dma'ble memory
  * @issue_uioc		: Driver supplied routine to issue uioc_t commands
  *			: issue_uioc(drvr_data, kioc, ISSUE/ABORT,
uioc_done)
+ * @list		: attach with the global list of adapters
  * @kioc_list		: block of mem for @max_kioc number of kiocs
  * @kioc_pool		: pool of free kiocs
  * @kioc_pool_lock	: protection for free pool
@@ -274,6 +273,7 @@
 
 /* Maintained by common module */
 
+	struct list_head	list;
 	uioc_t			*kioc_list;
 	struct list_head	kioc_pool;
 	spinlock_t		kioc_pool_lock;
diff -Naur megaraid2.20.1.0/megaraid_mbox.c megaraid2.20.2.0/megaraid_mbox.c
--- megaraid2.20.1.0/megaraid_mbox.c	2004-06-25 21:42:30.000000000 -0400
+++ megaraid2.20.2.0/megaraid_mbox.c	2004-07-23 17:44:43.416308440 -0400
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid.c
- * Version	: v2.20.1.0 (June 25 2004)
+ * Version	: v2.20.2.0 (July 22 2004)
  *
  * Authors:
  * 	Atul Mukker		<Atul.Mukker@lsil.com>
@@ -49,8 +49,8 @@
  * LSI MegaRAID SATA 150-2		1095	3112	1000	0534
  * LSI MegaRAID SATA 150-4		1000	1960	1000	4523
  * LSI MegaRAID SATA 150-6		1000	1960	1000	0523
- * LSI MegaRAID SATA 150-4X		1000	0409	1000	1504
- * LSI MegaRAID SATA 150-8X		1000	0409	1000	1508
+ * LSI MegaRAID SATA 150-4X		1000	0409	1000	3004
+ * LSI MegaRAID SATA 150-8X		1000	0409	1000	3008
  *
  * INTEL RAID Controller SRCU42X	1000	0407	8086	0532
  * INTEL RAID Controller SRCS16		1000	1960	8086	0523
@@ -128,7 +128,6 @@
 static inline int megaraid_ack_sequence(adapter_t *);
 
 static inline int megaraid_busywait_mbox(mraid_device_t *);
-static inline int __megaraid_busywait_mbox(mraid_device_t *);
 
 static int megaraid_cmm_register(adapter_t *);
 static int megaraid_cmm_unregister(adapter_t *);
@@ -206,7 +205,7 @@
  * ### global data ###
  */
 static uint8_t megaraid_mbox_version[8] =
-	{ 0x02, 0x20, 0x00, 0x01, 6, 24, 20, 4 };
+	{ 0x02, 0x20, 0x02, 0x00, 7, 22, 20, 4 };
 
 
 /*
@@ -353,6 +352,12 @@
 	},
 	{
 		PCI_VENDOR_ID_LSI_LOGIC,
+		PCI_DEVICE_ID_MEGARAID_I4_133_RAID,
+		PCI_VENDOR_ID_LSI_LOGIC,
+		PCI_SUBSYS_ID_MEGARAID_I4_133_RAID,
+	},
+	{
+		PCI_VENDOR_ID_LSI_LOGIC,
 		PCI_DEVICE_ID_MEGARAID_SATA_150_4,
 		PCI_VENDOR_ID_LSI_LOGIC,
 		PCI_SUBSYS_ID_MEGARAID_SATA_150_4,
@@ -429,6 +434,12 @@
 		PCI_SUBSYS_ID_FSC,
 		PCI_SUBSYS_ID_FSC_MEGARAID_PCI_EXPRESS_ROMB,
 	},
+	{
+		PCI_VENDOR_ID_LSI_LOGIC,
+		PCI_DEVICE_ID_MEGARAID_ACER_ROMB_2E,
+		PCI_VENDOR_ID_AI,
+		PCI_SUBSYS_ID_MEGARAID_ACER_ROMB_2E,
+	},
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, pci_id_table_g);
@@ -2750,7 +2761,6 @@
 	int		recovery_window;
 	int		recovering;
 	int		i;
-	DECLARE_WAIT_QUEUE_HEAD(wq);
 
 	adapter		= SCP2ADAPTER(scp);
 	raid_dev	= ADAP2RAIDDEV(adapter);
@@ -2819,8 +2829,7 @@
 			break;
 		}
 
-		//msleep(1000);
-		sleep_on_timeout(&wq, HZ);
+		msleep(1000);
 	}
 
 	spin_lock(adapter->host_lock);
@@ -2911,44 +2920,51 @@
 	WRINDOOR(raid_dev, raid_dev->mbox_dma | 0x1);
 
 	// wait for maximum 1 second for status to post
-	for (i = 0; i < 40000; i++) {
-		if (mbox->numstatus != 0xFF) break;
-		udelay(25); yield();
-	}
-	if (i == 40000) {
-		con_log(CL_ANN, (KERN_WARNING
-			"megaraid mailbox: status not available\n"));
-		return -1;
+	if (mbox->numstatus == 0xFF) {	// status not yet available
+		udelay(25);;
+
+		for (i = 0; mbox->numstatus == 0xFF && i < 1000; i++)
+			mdelay(1);
+
+		if (i == 1000) {
+			con_log(CL_ANN, (KERN_WARNING
+				"megaraid mailbox: status not
available\n"));
+			return -1;
+		}
 	}
 
 	// wait for maximum 1 second for poll semaphore
-	for (i = 0; i < 40000; i++) {
-		if (mbox->poll == 0x77) break;
-		udelay(25); yield();
-	}
-	if (i == 40000) {
-		con_log(CL_ANN, (KERN_WARNING
-		"megaraid mailbox: could not get poll semaphore\n"));
-		return -1;
+	if (mbox->poll != 0x77) {
+		udelay(25);
+
+		for (i = 0; mbox->poll != 0x77 && i < 1000; i++)
+			mdelay(1);
+
+		if (i == 1000) {
+			con_log(CL_ANN, (KERN_WARNING
+			"megaraid mailbox: could not get poll
semaphore\n"));
+			return -1;
+		}
 	}
 
 	WRINDOOR(raid_dev, raid_dev->mbox_dma | 0x2);
 	wmb();
 
 	// wait for maximum 1 second for acknowledgement
-	for (i = 0; i < 40000; i++) {
-		if ((RDINDOOR(raid_dev) & 0x2) == 0) {
-			mbox->poll	= 0;
-			mbox->ack	= 0x77;
-			break;
+	if (RDINDOOR(raid_dev) & 0x2) {
+		udelay(25);
+
+		for (i = 0; RDINDOOR(raid_dev) & 0x2 && i < 1000; i++)
+			mdelay(1);
+
+		if (i == 1000) {
+			con_log(CL_ANN, (KERN_WARNING
+				"megaraid mailbox: could not
acknowledge\n"));
+			return -1;
 		}
-		udelay(25); yield();
-	}
-	if (i == 40000) {
-		con_log(CL_ANN, (KERN_WARNING
-			"megaraid mailbox: could not acknowledge\n"));
-		return -1;
 	}
+	mbox->poll	= 0;
+	mbox->ack	= 0x77;
 
 	status = mbox->status;
 
@@ -3025,41 +3041,23 @@
  * @raid_dev	- RAID device (HBA) soft state
  *
  * wait until the controller's mailbox is available to accept more
commands.
+ * wait for at most 1 second
  */
 static inline int
 megaraid_busywait_mbox(mraid_device_t *raid_dev)
 {
 	mbox_t	*mbox = raid_dev->mbox;
+	int	i = 0;
 
-	if (mbox->busy)
-		return __megaraid_busywait_mbox(raid_dev);
-
-	return 0;
-}
-
-
-/**
- * __megaraid_busywait_mbox() - Wait until controller's mailbox is
available
- * @raid_dev	- mailbox data structures
- *
- * wait until the controller's mailbox is available to accept more
commands.
- */
-static inline int
-__megaraid_busywait_mbox(mraid_device_t *raid_dev)
-{
-	mbox_t		*mbox = raid_dev->mbox;
-	unsigned long	counter;
-
-
-	for (counter = 0; counter < 10000; counter++) {
-
-		if (!mbox->busy) return 0;
-
-		udelay(100); yield();
+	if (mbox->busy) {
+		udelay(25);
+		for (i = 0; mbox->busy && i < 1000; i++)
+			msleep(1);
 	}
-	return -1;	// give up after 1 second
-}
 
+	if (i < 1000) return 0;
+	else return -1;
+}
 
 
 /**
@@ -3761,7 +3759,6 @@
 	unsigned long	flags = 0;
 	int		i;
 
-	DECLARE_WAIT_QUEUE_HEAD(wq);
 
 	/*
 	 * Set the quiescent flag to stop issuing cmds to FW.
@@ -3779,8 +3776,7 @@
 			"megaraid: FW has %d pending commands\n",
 			adapter->outstanding_cmds));
 
-		//msleep(1000);
-		sleep_on_timeout(&wq, HZ);
+		msleep(1000);
 	}
 
 	return adapter->outstanding_cmds;
diff -Naur megaraid2.20.1.0/megaraid_mbox.h megaraid2.20.2.0/megaraid_mbox.h
--- megaraid2.20.1.0/megaraid_mbox.h	2004-06-25 21:42:30.000000000 -0400
+++ megaraid2.20.2.0/megaraid_mbox.h	2004-07-23 17:41:52.146345432 -0400
@@ -21,8 +21,8 @@
 #include "megaraid_ioctl.h"
 
 
-#define MEGARAID_VERSION	"2.20.1.0"
-#define MEGARAID_EXT_VERSION	"(Release Date: Fri Jun 25 18:58:43 EDT
2004)"
+#define MEGARAID_VERSION	"2.20.2.0"
+#define MEGARAID_EXT_VERSION	"(Release Date: Thu Jul 22 15:18:22 EDT
2004)"
 
 
 /*
@@ -88,6 +88,9 @@
 #define PCI_DEVICE_ID_MEGARAID_SCSI_320_2E		0x0408
 #define PCI_SUBSYS_ID_MEGARAID_SCSI_320_2E		0x0002
 
+#define PCI_DEVICE_ID_MEGARAID_I4_133_RAID		0x1960
+#define PCI_SUBSYS_ID_MEGARAID_I4_133_RAID		0x0522
+
 #define PCI_DEVICE_ID_MEGARAID_SATA_150_4		0x1960
 #define PCI_SUBSYS_ID_MEGARAID_SATA_150_4		0x4523
 
@@ -95,7 +98,7 @@
 #define PCI_SUBSYS_ID_MEGARAID_SATA_150_6		0x0523
 
 #define PCI_DEVICE_ID_MEGARAID_SATA_300_4x		0x0409
-#define PCI_SUBSYS_ID_MEGARAID_SATA_300_4x		0x3008
+#define PCI_SUBSYS_ID_MEGARAID_SATA_300_4x		0x3004
 
 #define PCI_DEVICE_ID_MEGARAID_SATA_300_8x		0x0409
 #define PCI_SUBSYS_ID_MEGARAID_SATA_300_8x		0x3008
@@ -127,6 +130,9 @@
 #define PCI_DEVICE_ID_FSC_MEGARAID_PCI_EXPRESS_ROMB	0x0408
 #define PCI_SUBSYS_ID_FSC_MEGARAID_PCI_EXPRESS_ROMB	0x1065
 
+#define PCI_DEVICE_ID_MEGARAID_ACER_ROMB_2E		0x0408
+#define PCI_SUBSYS_ID_MEGARAID_ACER_ROMB_2E		0x004D
+
 #define PCI_SUBSYS_ID_PERC3_QC				0x0471
 #define PCI_SUBSYS_ID_PERC3_DC				0x0493
 #define PCI_SUBSYS_ID_PERC3_SC				0x0475
diff -Naur megaraid2.20.1.0/megaraid_mm.c megaraid2.20.2.0/megaraid_mm.c
--- megaraid2.20.1.0/megaraid_mm.c	2004-06-25 21:42:30.000000000 -0400
+++ megaraid2.20.2.0/megaraid_mm.c	2004-07-23 17:41:52.146345432 -0400
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_mm.c
- * Version	: v2.20.0.0 (June 23 2004)
+ * Version	: v2.20.1.0 (July 23 2004)
  *
  * Common management module
  */
@@ -30,10 +30,10 @@
 EXPORT_SYMBOL(mraid_mm_unregister_adp);
 
 static int majorno;
-static uint32_t drvr_ver	= 0x01000000;
+static uint32_t drvr_ver	= 0x02200100;
 
-static int slots_inuse	= 0;
-static mraid_mmadp_t  adparr[MAX_LSI_CMN_ADAPS];
+static int adapters_count_g;
+static struct list_head adapters_list_g;
 
 wait_queue_head_t wait_q;
 
@@ -76,7 +76,6 @@
 	char		signature[EXT_IOCTL_SIGN_SZ]	= {0};
 	int		rval;
 	mraid_mmadp_t	*adp;
-	int		adp_index;
 	uint8_t		old_ioctl;
 	int		drvrcmd_rval;
 
@@ -120,12 +119,11 @@
 	else if (rval == 0)
 		return drvrcmd_rval;
 
-	if ((rval = mraid_mm_get_adpindex((mimd_t*)arg, &adp_index))) {
+	rval = 0;
+	if ((adp = mraid_mm_get_adapter((mimd_t*)arg, &rval)) == NULL) {
 		return rval;
 	}
 
-	adp = &adparr[adp_index];
-
 	/*
 	 * The following call will block till a kioc is available
 	 */
@@ -164,29 +162,44 @@
 
 
 /**
- * mraid_mm_get_adpindex - Returns adp number from mimd_t user packet
+ * mraid_mm_get_adapter - Returns corresponding adapters for the mimd
packet
  * @umimd	: User space mimd_t ioctl packet
- * @adp_index	: Contains adp number if success
+ * @adapter	: pointer to the adapter (OUT)
  */
-static int
-mraid_mm_get_adpindex(mimd_t *umimd, int *adp_index)
+static mraid_mmadp_t *
+mraid_mm_get_adapter(mimd_t *umimd, int *rval)
 {
+	mraid_mmadp_t	*adapter;
 	mimd_t		mimd;
 	uint32_t	adapno;
+	int		iterator;
 
-	*adp_index = -1;
 
-	if (copy_from_user( &mimd, umimd, sizeof(mimd_t)))
-		return (-EFAULT);
+	if (copy_from_user(&mimd, umimd, sizeof(mimd_t))) {
+		*rval = -EFAULT;
+		return NULL;
+	}
 
 	adapno = GETADAP(mimd.ui.fcs.adapno);
 
-	if (adapno >= slots_inuse)
-		return (-ENODEV);
+	if (adapno >= adapters_count_g) {
+		*rval = -ENODEV;
+		return NULL;
+	}
 
-	*adp_index = adapno;
+	adapter = NULL;
+	iterator = 0;
 
-	return 0;
+	list_for_each_entry(adapter, &adapters_list_g, list) {
+		if (iterator++ == adapno) break;
+	}
+
+	if (!adapter) {
+		*rval = -ENODEV;
+		return NULL;
+	}
+
+	return adapter;
 }
 
 /*
@@ -240,9 +253,10 @@
 
 	case MEGAIOC_QNADAP:
 
-		*rval = slots_inuse;
+		*rval = adapters_count_g;
 
-		if (copy_to_user(kmimd.data, &slots_inuse,
sizeof(uint32_t)))
+		if (copy_to_user(kmimd.data, &adapters_count_g,
+				sizeof(uint32_t)))
 			return (-EFAULT);
 
 		return 0;
@@ -291,7 +305,7 @@
 	subopcode	= mimd.ui.fcs.subopcode;
 	adapno		= GETADAP(mimd.ui.fcs.adapno);
 
-	if (adapno >= slots_inuse)
+	if (adapno >= adapters_count_g)
 		return (-ENODEV);
 
 	kioc->adapno	= adapno;
@@ -592,7 +606,7 @@
 /**
  * lld_ioctl - Routine to issue ioctl to low level drvr
  *
- * @adp		: The adapter entry in adparr
+ * @adp		: The adapter handle
  * @kioc	: The ioctl packet with kernel addresses
  */
 static int
@@ -796,7 +810,13 @@
 	if (lld_adp->drvr_type != DRVRTYPE_MBOX)
 		return (-EINVAL);
 
-	adapter	= &adparr[slots_inuse];
+	adapter = kmalloc(sizeof(mraid_mmadp_t), GFP_KERNEL);
+
+	if (!adapter) {
+		rval = -ENOMEM;
+		goto memalloc_error;
+	}
+
 	memset(adapter, 0, sizeof(mraid_mmadp_t));
 
 	adapter->unique_id	= lld_adp->unique_id;
@@ -867,7 +887,10 @@
 		goto dma_pool_error;
 	}
 
-	slots_inuse++;
+	list_add_tail(&adapter->list, &adapters_list_g);
+
+	adapters_count_g++;
+
 	return 0;
 
 dma_pool_error:
@@ -894,6 +917,9 @@
 	if (adapter->pthru_dma_pool)
 		pci_pool_destroy(adapter->pthru_dma_pool);
 
+	if (adapter)
+		kfree(adapter);
+
 	return rval;
 }
 
@@ -961,15 +987,21 @@
 int
 mraid_mm_unregister_adp(uint32_t unique_id)
 {
-	int i;
+	mraid_mmadp_t	*adapter;
+	mraid_mmadp_t	*tmp;
 
-	for (i = 0; i < MAX_LSI_CMN_ADAPS; i++) {
+	list_for_each_entry_safe(adapter, tmp, &adapters_list_g, list) {
 
-		if (adparr[i].unique_id == unique_id) {
 
-			mraid_mm_free_adp_resources(&adparr[i]);
+		if (adapter->unique_id == unique_id) {
 
-			memset(&adparr[i], 0, sizeof(mraid_mmadp_t));
+			adapters_count_g--;
+
+			list_del_init(&adapter->list);
+
+			mraid_mm_free_adp_resources(adapter);
+
+			kfree(adapter);
 
 			con_log(CL_ANN, (
 				"megaraid cmm: Unregistered one
adapter:%#x\n",
@@ -993,11 +1025,7 @@
 	uioc_t	*kioc;
 	int	i;
 
-	INIT_LIST_HEAD(&adp->kioc_pool);
-
-	kfree(adp->kioc_list);
-
-	kfree(adp->mbox_list);
+	mraid_mm_teardown_dma_pools(adp);
 
 	for (i = 0; i < adp->max_kioc; i++) {
 
@@ -1007,9 +1035,12 @@
 				kioc->pthru32_h);
 	}
 
+	kfree(adp->kioc_list);
+
+	kfree(adp->mbox_list);
+
 	pci_pool_destroy(adp->pthru_dma_pool);
 
-	mraid_mm_teardown_dma_pools(adp);
 
 	return;
 }
@@ -1062,9 +1093,8 @@
 	}
 
 	init_waitqueue_head(&wait_q);
-	memset(adparr, 0, sizeof(mraid_mmadp_t) * MAX_LSI_CMN_ADAPS);
 
-	slots_inuse = 0;
+	INIT_LIST_HEAD(&adapters_list_g);
 
 	register_ioctl32_conversion(MEGAIOCCMD, mraid_mm_compat_ioctl);
 
diff -Naur megaraid2.20.1.0/megaraid_mm.h megaraid2.20.2.0/megaraid_mm.h
--- megaraid2.20.1.0/megaraid_mm.h	2004-06-25 21:42:30.000000000 -0400
+++ megaraid2.20.2.0/megaraid_mm.h	2004-07-23 17:41:52.146345432 -0400
@@ -28,9 +28,9 @@
 #include "megaraid_ioctl.h"
 
 
-#define LSI_COMMON_MOD_VERSION	"2.20.0.0"
+#define LSI_COMMON_MOD_VERSION	"2.20.1.0"
 #define LSI_COMMON_MOD_EXT_VERSION	\
-		"(Release Date: Wed Jun 23 11:38:38 EDT 2004)"
+		"(Release Date: Fri Jul 23 15:22:07 EDT 2004)"
 
 
 #define LSI_DBGLVL			dbglevel
@@ -129,7 +129,7 @@
 static void ioctl_done(uioc_t *);
 static void lld_timedout(unsigned long);
 static void hinfo_to_cinfo(mraid_hba_info_t *, mcontroller_t *);
-static int mraid_mm_get_adpindex(mimd_t *, int *);
+static mraid_mmadp_t *mraid_mm_get_adapter(mimd_t *, int *);
 static uioc_t *mraid_mm_alloc_kioc(mraid_mmadp_t *);
 static void mraid_mm_dealloc_kioc(mraid_mmadp_t *, uioc_t *);
 static int mraid_mm_attach_buf(mraid_mmadp_t *, uioc_t *, int);
