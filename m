From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Tue, 8 Feb 2005 17:22:23 -0600
Message-ID: <20050208232223.GB30086@lists.us.dell.com>
References: <20050207182753.GA16526@lists.us.dell.com> <20050208231923.GA30086@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from lists.us.dell.com ([143.166.224.162]:12930 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261684AbVBHXW3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Feb 2005 18:22:29 -0500
Received: from lists.us.dell.com (localhost.localdomain [127.0.0.1])
	by lists.us.dell.com (8.12.11/8.12.11) with ESMTP id j18NMNHl031763
	for <linux-scsi@vger.kernel.org>; Tue, 8 Feb 2005 17:22:23 -0600
Received: (from mdomsch@localhost)
	by lists.us.dell.com (8.12.11/8.12.11/Submit) id j18NMNGk031761
	for linux-scsi@vger.kernel.org; Tue, 8 Feb 2005 17:22:23 -0600
Content-Disposition: inline
In-Reply-To: <20050208231923.GA30086@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Feb 08, 2005 at 05:19:23PM -0600, Matt Domsch wrote:
> I've added and reworked the megaraid_mbox driver to make use of this
> new infrastructure.  I'll send that patch next.  The rest is unchanged
> from yesterday.

This is the megaraid_mbox 2.20.4.5 patch as submitted by LSI on-list
last week.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

You can import this changeset into BK by piping this whole message to
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.2132.2.2, 2005-02-08 14:53:12-06:00, Matt_Domsch@dell.com
  megaraid_2.20.4.5.patch


 Documentation/scsi/ChangeLog.megaraid  |  104 ++++++++
 drivers/scsi/megaraid/Kconfig.megaraid |    1 
 drivers/scsi/megaraid/mega_common.h    |    3 
 drivers/scsi/megaraid/megaraid_ioctl.h |    1 
 drivers/scsi/megaraid/megaraid_mbox.c  |  403 ++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_mbox.h  |   24 +
 drivers/scsi/megaraid/megaraid_mm.c    |   39 +++
 drivers/scsi/megaraid/megaraid_mm.h    |    5 
 8 files changed, 561 insertions, 19 deletions


diff -Nru a/Documentation/scsi/ChangeLog.megaraid b/Documentation/scsi/ChangeLog.megaraid
--- a/Documentation/scsi/ChangeLog.megaraid	2005-02-08 17:16:50 -06:00
+++ b/Documentation/scsi/ChangeLog.megaraid	2005-02-08 17:16:50 -06:00
@@ -1,3 +1,105 @@
+Release Date	: Thu Feb 03 12:27:22 EST 2005 - Seokmann Ju <sju@lsil.com>
+Current Version	: 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)
+Older Version	: 2.20.4.4 (scsi module), 2.20.2.4 (cmm module)
+
+1.	Modified name of two attributes in scsi_host_template.
+	On Wed, 2005-02-02 at 10:56 -0500, Ju, Seokmann wrote:
+	> +	.sdev_attrs			= megaraid_device_attrs,
+	> +	.shost_attrs			= megaraid_class_device_attrs,
+
+	These are, perhaps, slightly confusing names.
+	The terms device and class_device have well defined meanings in the
+	generic device model, neither of which is what you mean here.
+	Why not simply megaraid_sdev_attrs and megaraid_shost_attrs?
+
+	Other than this, it looks fine to me too.
+
+Release Date	: Thu Jan 27 00:01:03 EST 2005 - Atul Mukker <atulm@lsil.com>
+Current Version	: 2.20.4.4 (scsi module), 2.20.2.5 (cmm module)
+Older Version	: 2.20.4.3 (scsi module), 2.20.2.4 (cmm module)
+
+1.	Bump up the version of scsi module due to its conflict.
+
+Release Date	: Thu Jan 21 00:01:03 EST 2005 - Atul Mukker <atulm@lsil.com>
+Current Version	: 2.20.4.3 (scsi module), 2.20.2.5 (cmm module)
+Older Version	: 2.20.4.2 (scsi module), 2.20.2.4 (cmm module)
+
+1.	Remove driver ioctl for logical drive to scsi address translation and
+	replace with the sysfs attribute. To remove drives and change
+	capacity, application shall now use the device attribute to get the
+	logical drive number for a scsi device. For adding newly created
+	logical drives, class device attribute would be required to uniquely
+	identify each controller.
+		- Atul Mukker <atulm@lsil.com>
+
+	"James, I've been thinking about this a little more, and you may be on
+	to something here. Let each driver add files as such:"
+
+		- Matt Domsch <Matt_Domsch@dell.com>, 12.15.2004
+		 linux-scsi mailing list
+
+
+	"Then, if you simply publish your LD number as an extra parameter of
+	the device, you can look through /sys to find it."
+
+		- James Bottomley <James.Bottomley@SteelEye.com>, 01.03.2005
+		 linux-scsi mailing list
+
+
+	"I don't see why not ... it's your driver, you can publish whatever
+	extra information you need as scsi_device attributes; that was one of
+	the designs of the extensible attribute system."
+
+		- James Bottomley <James.Bottomley@SteelEye.com>, 01.06.2005
+		 linux-scsi mailing list
+
+2.	Add AMI megaraid support - Brian King <brking@charter.net>
+		PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_VENDOR_ID_AMI, PCI_SUBSYS_ID_PERC3_DC,
+
+3.	Make some code static - Adrian Bunk <bunk@stusta.de>
+	Date:	Mon, 15 Nov 2004 03:14:57 +0100
+
+	The patch below makes some needlessly global code static.
+	-wait_queue_head_t wait_q;
+	+static wait_queue_head_t wait_q;
+
+	Signed-off-by: Adrian Bunk <bunk@stusta.de>
+
+4.	Added NEC ROMB support - NEC MegaRAID PCI Express ROMB controller
+		PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_MEGARAID_NEC_ROMB_2E,
+		PCI_SUBSYS_ID_NEC, PCI_SUBSYS_ID_MEGARAID_NEC_ROMB_2E,
+
+5.	Fixed Tape drive issue : For any Direct CDB command to physical device
+	including tape, timeout value set by driver was 10 minutes. With this 
+	value, most of command will return within timeout. However, for those
+	command like ERASE or FORMAT, it takes more than an hour depends on
+	capacity of the device and the command could be terminated before it 
+	completes.
+	To address this issue, the 'timeout' field in the DCDB command will 
+	have NO TIMEOUT (i.e., 4) value as its timeout on DCDB command.
+
+
+
+Release Date	: Thu Dec  9 19:10:23 EST 2004
+	- Sreenivas Bagalkote <sreenib@lsil.com>
+
+Current Version	: 2.20.4.2 (scsi module), 2.20.2.4 (cmm module)
+Older Version	: 2.20.4.1 (scsi module), 2.20.2.3 (cmm module)
+
+i.	Introduced driver ioctl that returns scsi address for a given ld.
+	
+	"Why can't the existing sysfs interfaces be used to do this?"
+		- Brian King (brking@us.ibm.com)
+	
+	"I've looked into solving this another way, but I cannot see how
+	to get this driver-private mapping of logical drive number-> HCTL
+	without putting code something like this into the driver."
+
+	"...and by providing a mapping a function to userspace, the driver
+	is free to change its mapping algorithm in the future if necessary .."
+		- Matt Domsch (Matt_Domsch@dell.com)
+
 Release Date	: Thu Dec  9 19:02:14 EST 2004 - Sreenivas Bagalkote <sreenib@lsil.com>
 
 Current Version	: 2.20.4.1 (scsi module), 2.20.2.3 (cmm module)
@@ -13,7 +115,7 @@
 i.	Handle IOCTL cmd timeouts more properly.
 
 ii.	pci_dma_sync_{sg,single}_for_cpu was introduced into megaraid_mbox
-	incorrectly (instead of _for_device). Changed to appropriate
+	incorrectly (instead of _for_device). Changed to appropriate 
 	pci_dma_sync_{sg,single}_for_device.
 
 Release Date	: Wed Oct 06 11:15:29 EDT 2004 - Sreenivas Bagalkote <sreenib@lsil.com>
diff -Nru a/drivers/scsi/megaraid/Kconfig.megaraid b/drivers/scsi/megaraid/Kconfig.megaraid
--- a/drivers/scsi/megaraid/Kconfig.megaraid	2005-02-08 17:16:50 -06:00
+++ b/drivers/scsi/megaraid/Kconfig.megaraid	2005-02-08 17:16:50 -06:00
@@ -59,6 +59,7 @@
 	INTEL RAID Controller SRCU51L	1000:1960:8086:0520
 	FSC MegaRAID PCI Express ROMB	1000:0408:1734:1065
 	ACER MegaRAID ROMB-2E		1000:0408:1025:004D
+	NEC MegaRAID PCI Express ROMB	1000:0408:1033:8287
 
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid_mbox
diff -Nru a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
--- a/drivers/scsi/megaraid/mega_common.h	2005-02-08 17:16:50 -06:00
+++ b/drivers/scsi/megaraid/mega_common.h	2005-02-08 17:16:50 -06:00
@@ -221,6 +221,9 @@
 #define MRAID_IS_LOGICAL(adp, scp)	\
 	(SCP2CHANNEL(scp) == (adp)->max_channel) ? 1 : 0
 
+#define MRAID_IS_LOGICAL_SDEV(adp, sdev)	\
+	(sdev->channel == (adp)->max_channel) ? 1 : 0
+
 #define MRAID_GET_DEVICE_MAP(adp, scp, p_chan, target, islogical)	\
 	/*								\
 	 * Is the request coming for the virtual channel		\
diff -Nru a/drivers/scsi/megaraid/megaraid_ioctl.h b/drivers/scsi/megaraid/megaraid_ioctl.h
--- a/drivers/scsi/megaraid/megaraid_ioctl.h	2005-02-08 17:16:50 -06:00
+++ b/drivers/scsi/megaraid/megaraid_ioctl.h	2005-02-08 17:16:50 -06:00
@@ -291,5 +291,6 @@
 
 int mraid_mm_register_adp(mraid_mmadp_t *);
 int mraid_mm_unregister_adp(uint32_t);
+uint32_t mraid_mm_adapter_app_handle(uint32_t);
 
 #endif /* _MEGARAID_IOCTL_H_ */
diff -Nru a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c	2005-02-08 17:16:50 -06:00
+++ b/drivers/scsi/megaraid/megaraid_mbox.c	2005-02-08 17:16:50 -06:00
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_mbox.c
- * Version	: v2.20.4.1 (Nov 04 2004)
+ * Version	: v2.20.4.5 (Feb 03 2005)
  *
  * Authors:
  * 	Atul Mukker		<Atul.Mukker@lsil.com>
@@ -60,12 +60,11 @@
  * INTEL RAID Controller SROMBU42E	1000	0408	8086	3499
  * INTEL RAID Controller SRCU51L	1000	1960	8086	0520
  *
- *
  * FSC	MegaRAID PCI Express ROMB	1000	0408	1734	1065
  *
- *
  * ACER	MegaRAID ROMB-2E		1000	0408	1025	004D
  *
+ * NEC	MegaRAID PCI Express ROMB	1000	0408	1033	8287
  *
  * For history of changes, see Documentation/ChangeLog.megaraid
  */
@@ -91,6 +90,9 @@
 static int megaraid_mbox_setup_dma_pools(adapter_t *);
 static void megaraid_mbox_teardown_dma_pools(adapter_t *);
 
+static int megaraid_sysfs_alloc_resources(adapter_t *);
+static void megaraid_sysfs_free_resources(adapter_t *);
+
 static int megaraid_abort_handler(struct scsi_cmnd *);
 static int megaraid_reset_handler(struct scsi_cmnd *);
 
@@ -121,6 +123,9 @@
 
 static void megaraid_mbox_dpc(unsigned long);
 
+static ssize_t megaraid_sysfs_show_app_hndl(struct class_device *, char *);
+static ssize_t megaraid_sysfs_show_ldnum(struct device *, char *);
+
 static int megaraid_cmm_register(adapter_t *);
 static int megaraid_cmm_unregister(adapter_t *);
 static int megaraid_mbox_mm_handler(unsigned long, uioc_t *, uint32_t);
@@ -197,7 +202,7 @@
  * ### global data ###
  */
 static uint8_t megaraid_mbox_version[8] =
-	{ 0x02, 0x20, 0x04, 0x00, 9, 27, 20, 4 };
+	{ 0x02, 0x20, 0x04, 0x05, 2, 3, 20, 5 };
 
 
 /*
@@ -301,6 +306,12 @@
 		PCI_SUBSYS_ID_PERC3_SC,
 	},
 	{
+		PCI_VENDOR_ID_AMI,
+		PCI_DEVICE_ID_AMI_MEGARAID3,
+		PCI_VENDOR_ID_AMI,
+		PCI_SUBSYS_ID_PERC3_DC,
+	},
+	{
 		PCI_VENDOR_ID_LSI_LOGIC,
 		PCI_DEVICE_ID_MEGARAID_SCSI_320_0,
 		PCI_VENDOR_ID_LSI_LOGIC,
@@ -438,6 +449,12 @@
 		PCI_VENDOR_ID_AI,
 		PCI_SUBSYS_ID_MEGARAID_ACER_ROMB_2E,
 	},
+	{
+		PCI_VENDOR_ID_LSI_LOGIC,
+		PCI_DEVICE_ID_MEGARAID_NEC_ROMB_2E,
+		PCI_VENDOR_ID_NEC,
+		PCI_SUBSYS_ID_MEGARAID_NEC_ROMB_2E,
+	},
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, pci_id_table_g);
@@ -454,6 +471,29 @@
 };
 
 
+
+// definitions for the device attributes for exporting logical drive number
+// for a scsi address (Host, Channel, Id, Lun)
+
+CLASS_DEVICE_ATTR(megaraid_mbox_app_hndl, S_IRUSR, megaraid_sysfs_show_app_hndl,
+		NULL);
+
+// Host template initializer for megaraid mbox sysfs device attributes
+static struct class_device_attribute *megaraid_shost_attrs[] = {
+	&class_device_attr_megaraid_mbox_app_hndl,
+	NULL,
+};
+
+
+DEVICE_ATTR(megaraid_mbox_ld, S_IRUSR, megaraid_sysfs_show_ldnum, NULL);
+
+// Host template initializer for megaraid mbox sysfs device attributes
+static struct device_attribute *megaraid_sdev_attrs[] = {
+	&dev_attr_megaraid_mbox_ld,
+	NULL,
+};
+
+
 /*
  * Scsi host template for megaraid unified driver
  */
@@ -467,6 +507,8 @@
 	.eh_bus_reset_handler		= megaraid_reset_handler,
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.sdev_attrs			= megaraid_sdev_attrs,
+	.shost_attrs			= megaraid_shost_attrs,
 };
 
 
@@ -953,6 +995,8 @@
 		}
 		adapter->device_ids[adapter->max_channel][adapter->init_id] =
 			0xFF;
+
+		raid_dev->random_del_supported = 1;
 	}
 
 	/*
@@ -977,6 +1021,14 @@
 	 */
 	adapter->cmd_per_lun = megaraid_cmd_per_lun;
 
+	/*
+	 * Allocate resources required to issue FW calls, when sysfs is
+	 * accessed
+	 */
+	if (megaraid_sysfs_alloc_resources(adapter) != 0) {
+		goto out_alloc_cmds;
+	}
+
 	// Set the DMA mask to 64-bit. All supported controllers as capable of
 	// DMA in this range
 	if (pci_set_dma_mask(adapter->pdev, 0xFFFFFFFFFFFFFFFFULL) != 0) {
@@ -984,7 +1036,7 @@
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: could not set DMA mask for 64-bit.\n"));
 
-		goto out_alloc_cmds;
+		goto out_free_sysfs_res;
 	}
 
 	// setup tasklet for DPC
@@ -996,6 +1048,8 @@
 
 	return 0;
 
+out_free_sysfs_res:
+	megaraid_sysfs_free_resources(adapter);
 out_alloc_cmds:
 	megaraid_free_cmd_packets(adapter);
 out_free_irq:
@@ -1025,6 +1079,8 @@
 
 	tasklet_kill(&adapter->dpc_h);
 
+	megaraid_sysfs_free_resources(adapter);
+
 	megaraid_free_cmd_packets(adapter);
 
 	free_irq(adapter->irq, adapter);
@@ -1559,12 +1615,14 @@
 
 	if (scb->dma_direction == PCI_DMA_TODEVICE) {
 		if (!scb->scp->use_sg) {	// sg list not used
-			pci_dma_sync_single_for_device(adapter->pdev, ccb->buf_dma_h,
+			pci_dma_sync_single_for_device(adapter->pdev,
+					ccb->buf_dma_h,
 					scb->scp->request_bufflen,
 					PCI_DMA_TODEVICE);
 		}
 		else {
-			pci_dma_sync_sg_for_device(adapter->pdev, scb->scp->request_buffer,
+			pci_dma_sync_sg_for_device(adapter->pdev,
+				scb->scp->request_buffer,
 				scb->scp->use_sg, PCI_DMA_TODEVICE);
 		}
 	}
@@ -2107,7 +2165,8 @@
 	channel	= scb->dev_channel;
 	target	= scb->dev_target;
 
-	pthru->timeout		= 1;	// 0=6sec, 1=60sec, 2=10min, 3=3hrs
+	// 0=6sec, 1=60sec, 2=10min, 3=3hrs, 4=NO timeout
+	pthru->timeout		= 4;	
 	pthru->ars		= 1;
 	pthru->islogical	= 0;
 	pthru->channel		= 0;
@@ -2155,7 +2214,8 @@
 	channel	= scb->dev_channel;
 	target	= scb->dev_target;
 
-	epthru->timeout		= 1;	// 0=6sec, 1=60sec, 2=10min, 3=3hrs
+	// 0=6sec, 1=60sec, 2=10min, 3=3hrs, 4=NO timeout
+	epthru->timeout		= 4;	
 	epthru->ars		= 1;
 	epthru->islogical	= 0;
 	epthru->channel		= 0;
@@ -3306,7 +3366,7 @@
 	memset((caddr_t)raw_mbox, 0, sizeof(mbox_t));
 
 	raw_mbox[0] = FC_DEL_LOGDRV;
-	raw_mbox[0] = OP_SUP_DEL_LOGDRV;
+	raw_mbox[2] = OP_SUP_DEL_LOGDRV;
 
 	// Issue the command
 	rval = 0;
@@ -3719,8 +3779,9 @@
 
 	spin_unlock_irqrestore(USER_FREE_LIST_LOCK(adapter), flags);
 
-	scb->state	= SCB_ACTIVE;
-	scb->dma_type	= MRAID_DMA_NONE;
+	scb->state		= SCB_ACTIVE;
+	scb->dma_type		= MRAID_DMA_NONE;
+	scb->dma_direction	= PCI_DMA_NONE;
 
 	ccb		= (mbox_ccb_t *)scb->ccb;
 	mbox64		= (mbox64_t *)(unsigned long)kioc->cmdbuf;
@@ -3886,6 +3947,324 @@
 /*
  * END: Interface for the common management module
  */
+
+
+
+/**
+ * megaraid_sysfs_alloc_resources - allocate sysfs related resources
+ *
+ * Allocate packets required to issue FW calls whenever the sysfs attributes
+ * are read. These attributes would require up-to-date information from the
+ * FW. Also set up resources for mutual exclusion to share these resources and
+ * the wait queue.
+ *
+ * @param adapter : controller's soft state
+ *
+ * @return 0 on success
+ * @return -ERROR_CODE on failure
+ */
+static int
+megaraid_sysfs_alloc_resources(adapter_t *adapter)
+{
+	mraid_device_t	*raid_dev = ADAP2RAIDDEV(adapter);
+	int		rval = 0;
+
+	raid_dev->sysfs_uioc = kmalloc(sizeof(uioc_t), GFP_KERNEL);
+
+	raid_dev->sysfs_mbox64 = kmalloc(sizeof(mbox64_t), GFP_KERNEL);
+
+	raid_dev->sysfs_buffer = pci_alloc_consistent(adapter->pdev,
+			PAGE_SIZE, &raid_dev->sysfs_buffer_dma);
+
+	if (!raid_dev->sysfs_uioc || !raid_dev->sysfs_mbox64 ||
+		!raid_dev->sysfs_buffer) {
+
+		con_log(CL_ANN, (KERN_WARNING
+			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			__LINE__));
+
+		rval = -ENOMEM;
+
+		megaraid_sysfs_free_resources(adapter);
+	}
+
+	sema_init(&raid_dev->sysfs_sem, 1);
+
+	init_waitqueue_head(&raid_dev->sysfs_wait_q);
+
+	return rval;
+}
+
+
+/**
+ * megaraid_sysfs_free_resources - free sysfs related resources
+ *
+ * Free packets allocated for sysfs FW commands
+ *
+ * @param adapter : controller's soft state
+ */
+static void
+megaraid_sysfs_free_resources(adapter_t *adapter)
+{
+	mraid_device_t	*raid_dev = ADAP2RAIDDEV(adapter);
+
+	if (raid_dev->sysfs_uioc) kfree(raid_dev->sysfs_uioc);
+
+	if (raid_dev->sysfs_mbox64) kfree(raid_dev->sysfs_mbox64);
+
+	if (raid_dev->sysfs_buffer) {
+		pci_free_consistent(adapter->pdev, PAGE_SIZE,
+			raid_dev->sysfs_buffer, raid_dev->sysfs_buffer_dma);
+	}
+}
+
+
+/**
+ * megaraid_sysfs_get_ldmap_done - callback for get ldmap
+ *
+ * Callback routine called in the ISR/tasklet context for get ldmap call
+ *
+ * @param uioc : completed packet
+ */
+static void
+megaraid_sysfs_get_ldmap_done(uioc_t *uioc)
+{
+	adapter_t	*adapter = (adapter_t *)uioc->buf_vaddr;
+	mraid_device_t	*raid_dev = ADAP2RAIDDEV(adapter);
+
+	uioc->status = 0;
+
+	wake_up(&raid_dev->sysfs_wait_q);
+}
+
+
+/**
+ * megaraid_sysfs_get_ldmap_timeout - timeout handling for get ldmap
+ *
+ * Timeout routine to recover and return to application, in case the adapter
+ * has stopped responding. A timeout of 60 seconds for this command seem like
+ * a good value
+ *
+ * @param uioc : timed out packet
+ */
+static void
+megaraid_sysfs_get_ldmap_timeout(unsigned long data)
+{
+	uioc_t		*uioc = (uioc_t *)data;
+	adapter_t	*adapter = (adapter_t *)uioc->buf_vaddr;
+	mraid_device_t	*raid_dev = ADAP2RAIDDEV(adapter);
+
+	uioc->status = -ETIME;
+
+	wake_up(&raid_dev->sysfs_wait_q);
+}
+
+
+/**
+ * megaraid_sysfs_get_ldmap - get update logical drive map
+ *
+ * This routine will be called whenever user reads the logical drive
+ * attributes, go get the current logical drive mapping table from the
+ * firmware. We use the managment API's to issue commands to the controller.
+ *
+ * NOTE: The commands issuance functionality is not generalized and
+ * implemented in context of "get ld map" command only. If required, the
+ * command issuance logical can be trivially pulled out and implemented as a
+ * standalone libary. For now, this should suffice since there is no other
+ * user of this interface.
+ *
+ * @param adapter : controller's soft state
+ *
+ * @return 0 on success
+ * @return -1 on failure
+ */
+static int
+megaraid_sysfs_get_ldmap(adapter_t *adapter)
+{
+	mraid_device_t		*raid_dev = ADAP2RAIDDEV(adapter);
+	uioc_t			*uioc;
+	mbox64_t		*mbox64;
+	mbox_t			*mbox;
+	char			*raw_mbox;
+	struct timer_list	sysfs_timer;
+	struct timer_list	*timerp;
+	caddr_t			ldmap;
+	int			rval = 0;
+
+	/*
+	 * Allow only one read at a time to go through the sysfs attributes
+	 */
+	down(&raid_dev->sysfs_sem);
+
+	uioc	= raid_dev->sysfs_uioc;
+	mbox64	= raid_dev->sysfs_mbox64;
+	ldmap	= raid_dev->sysfs_buffer;
+
+	memset(uioc, sizeof(uioc_t), 0);
+	memset(mbox64, sizeof(mbox64_t), 0);
+	memset(ldmap, sizeof(raid_dev->curr_ldmap), 0);
+
+	mbox		= &mbox64->mbox32;
+	raw_mbox	= (char *)mbox;
+	uioc->cmdbuf    = (uint64_t)(unsigned long)mbox64;
+	uioc->buf_vaddr	= (caddr_t)adapter;
+	uioc->status	= -ENODATA;
+	uioc->done	= megaraid_sysfs_get_ldmap_done;
+
+	/*
+	 * Prepare the mailbox packet to get the current logical drive mapping
+	 * table
+	 */
+	mbox->xferaddr = (uint32_t)raid_dev->sysfs_buffer_dma;
+
+	raw_mbox[0] = FC_DEL_LOGDRV;
+	raw_mbox[2] = OP_GET_LDID_MAP;
+
+	/*
+	 * Setup a timer to recover from a non-responding controller
+	 */
+	timerp	= &sysfs_timer;
+	init_timer(timerp);
+
+	timerp->function	= megaraid_sysfs_get_ldmap_timeout;
+	timerp->data		= (unsigned long)uioc;
+	timerp->expires		= jiffies + 60 * HZ;
+
+	add_timer(timerp);
+
+	/*
+	 * Send the command to the firmware
+	 */
+	rval = megaraid_mbox_mm_command(adapter, uioc);
+
+	if (rval == 0) {	// command successfully issued
+		wait_event(raid_dev->sysfs_wait_q, (uioc->status != -ENODATA));
+
+		/*
+		 * Check if the command timed out
+		 */
+		if (uioc->status == -ETIME) {
+			con_log(CL_ANN, (KERN_NOTICE
+				"megaraid: sysfs get ld map timed out\n"));
+
+			rval = -ETIME;
+		}
+		else {
+			rval = mbox->status;
+		}
+
+		if (rval == 0) {
+			memcpy(raid_dev->curr_ldmap, ldmap,
+				sizeof(raid_dev->curr_ldmap));
+		}
+		else {
+			con_log(CL_ANN, (KERN_NOTICE
+				"megaraid: get ld map failed with %x\n", rval));
+		}
+	}
+	else {
+		con_log(CL_ANN, (KERN_NOTICE
+			"megaraid: could not issue ldmap command:%x\n", rval));
+	}
+
+
+	del_timer_sync(timerp);
+
+	up(&raid_dev->sysfs_sem);
+
+	return rval;
+}
+
+
+/**
+ * megaraid_sysfs_show_app_hndl - display application handle for this adapter
+ *
+ * Display the handle used by the applications while executing management
+ * tasks on the adapter. We invoke a management module API to get the adapter
+ * handle, since we do not interface with applications directly.
+ *
+ * @param cdev	: class device object representation for the host
+ * @param buf	: buffer to send data to
+ */
+static ssize_t
+megaraid_sysfs_show_app_hndl(struct class_device *cdev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	adapter_t	*adapter = (adapter_t *)SCSIHOST2ADAP(shost);
+	uint32_t	app_hndl;
+
+	app_hndl = mraid_mm_adapter_app_handle(adapter->unique_id);
+
+	return snprintf(buf, 8, "%u\n", app_hndl);
+}
+
+
+/**
+ * megaraid_sysfs_show_ldnum - display the logical drive number for this device
+ *
+ * Display the logical drive number for the device in question, if it a valid
+ * logical drive. For physical devices, "-1" is returned
+ * The logical drive number is displayed in following format
+ *
+ * <SCSI ID> <LD NUM> <LD STICKY ID> <APP ADAPTER HANDLE>
+ *   <int>     <int>       <int>            <int>
+ *
+ * @param dev	: device object representation for the scsi device
+ * @param buf	: buffer to send data to
+ */
+static ssize_t
+megaraid_sysfs_show_ldnum(struct device *dev, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	adapter_t	*adapter = (adapter_t *)SCSIHOST2ADAP(sdev->host);
+	mraid_device_t	*raid_dev = ADAP2RAIDDEV(adapter);
+	int		scsi_id = -1;
+	int		logical_drv = -1;
+	int		ldid_map = -1;
+	uint32_t	app_hndl = 0;
+	int		mapped_sdev_id;
+	int		rval;
+	int		i;
+
+	if (raid_dev->random_del_supported &&
+			MRAID_IS_LOGICAL_SDEV(adapter, sdev)) {
+
+		rval = megaraid_sysfs_get_ldmap(adapter);
+		if (rval == 0) {
+
+			for (i = 0; i < MAX_LOGICAL_DRIVES_40LD; i++) {
+
+				mapped_sdev_id = sdev->id;
+
+				if (sdev->id > adapter->init_id) {
+					mapped_sdev_id -= 1;
+				}
+
+				if (raid_dev->curr_ldmap[i] == mapped_sdev_id) {
+
+					scsi_id = sdev->id;
+
+					logical_drv = i;
+
+					ldid_map = raid_dev->curr_ldmap[i];
+
+					app_hndl = mraid_mm_adapter_app_handle(
+							adapter->unique_id);
+
+					break;
+				}
+			}
+		}
+		else {
+			con_log(CL_ANN, (KERN_NOTICE
+				"megaraid: sysfs get ld map failed: %x\n",
+				rval));
+		}
+	}
+
+	return snprintf(buf, 36, "%d %d %d %d\n", scsi_id, logical_drv,
+			ldid_map, app_hndl);
+}
 
 
 /*
diff -Nru a/drivers/scsi/megaraid/megaraid_mbox.h b/drivers/scsi/megaraid/megaraid_mbox.h
--- a/drivers/scsi/megaraid/megaraid_mbox.h	2005-02-08 17:16:50 -06:00
+++ b/drivers/scsi/megaraid/megaraid_mbox.h	2005-02-08 17:16:50 -06:00
@@ -21,8 +21,8 @@
 #include "megaraid_ioctl.h"
 
 
-#define MEGARAID_VERSION	"2.20.4.1"
-#define MEGARAID_EXT_VERSION	"(Release Date: Thu Nov  4 17:44:59 EST 2004)"
+#define MEGARAID_VERSION	"2.20.4.5"
+#define MEGARAID_EXT_VERSION	"(Release Date: Thu Feb 03 12:27:22 EST 2005)"
 
 
 /*
@@ -137,6 +137,9 @@
 #define PCI_SUBSYS_ID_PERC3_DC				0x0493
 #define PCI_SUBSYS_ID_PERC3_SC				0x0475
 
+#define PCI_DEVICE_ID_MEGARAID_NEC_ROMB_2E		0x0408
+#define PCI_SUBSYS_ID_MEGARAID_NEC_ROMB_2E		0x8287
+
 #ifndef PCI_SUBSYS_ID_FSC
 #define PCI_SUBSYS_ID_FSC				0x1734
 #endif
@@ -216,6 +219,14 @@
  * @param hw_error		: set if FW not responding
  * @param fast_load		: If set, skip physical device scanning
  * @channel_class		: channel class, RAID or SCSI
+ * @sysfs_sem			: semaphore to serialize access to sysfs res.
+ * @sysfs_uioc			: management packet to issue FW calls from sysfs
+ * @sysfs_mbox64		: mailbox packet to issue FW calls from sysfs
+ * @sysfs_buffer		: data buffer for FW commands issued from sysfs
+ * @sysfs_buffer_dma		: DMA buffer for FW commands issued from sysfs
+ * @sysfs_wait_q		: wait queue for sysfs operations
+ * @random_del_supported	: set if the random deletion is supported
+ * @curr_ldmap			: current LDID map
  *
  * Initialization structure for mailbox controllers: memory based and IO based
  * All the fields in this structure are LLD specific and may be discovered at
@@ -223,6 +234,7 @@
  *
  * NOTE: The fields of this structures are placed to minimize cache misses
  */
+#define MAX_LD_EXTENDED64	64
 typedef struct {
 	mbox64_t			*una_mbox64;
 	dma_addr_t			una_mbox64_dma;
@@ -247,6 +259,14 @@
 	int				hw_error;
 	int				fast_load;
 	uint8_t				channel_class;
+	struct semaphore		sysfs_sem;
+	uioc_t				*sysfs_uioc;
+	mbox64_t			*sysfs_mbox64;
+	caddr_t				sysfs_buffer;
+	dma_addr_t			sysfs_buffer_dma;
+	wait_queue_head_t		sysfs_wait_q;
+	int				random_del_supported;
+	uint16_t			curr_ldmap[MAX_LD_EXTENDED64];
 } mraid_device_t;
 
 // route to raid device from adapter
diff -Nru a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
--- a/drivers/scsi/megaraid/megaraid_mm.c	2005-02-08 17:16:50 -06:00
+++ b/drivers/scsi/megaraid/megaraid_mm.c	2005-02-08 17:16:50 -06:00
@@ -10,7 +10,7 @@
  *	   2 of the License, or (at your option) any later version.
  *
  * FILE		: megaraid_mm.c
- * Version	: v2.20.2.3 (Dec 09 2004)
+ * Version	: v2.20.2.5 (Jan 21 2005)
  *
  * Common management module
  */
@@ -58,6 +58,7 @@
 
 EXPORT_SYMBOL(mraid_mm_register_adp);
 EXPORT_SYMBOL(mraid_mm_unregister_adp);
+EXPORT_SYMBOL(mraid_mm_adapter_app_handle);
 
 static int majorno;
 static uint32_t drvr_ver	= 0x02200201;
@@ -65,7 +66,7 @@
 static int adapters_count_g;
 static struct list_head adapters_list_g;
 
-wait_queue_head_t wait_q;
+static wait_queue_head_t wait_q;
 
 static struct file_operations lsi_fops = {
 	.open	= mraid_mm_open,
@@ -1006,6 +1007,40 @@
 
 	return rval;
 }
+
+
+/**
+ * mraid_mm_adapter_app_handle - return the application handle for this adapter
+ *
+ * For the given driver data, locate the adadpter in our global list and
+ * return the corresponding handle, which is also used by applications to
+ * uniquely identify an adapter.
+ *
+ * @param unique_id : adapter unique identifier
+ *
+ * @return adapter handle if found in the list
+ * @return 0 if adapter could not be located, should never happen though
+ */
+uint32_t
+mraid_mm_adapter_app_handle(uint32_t unique_id)
+{
+	mraid_mmadp_t	*adapter;
+	mraid_mmadp_t	*tmp;
+	int		index = 0;
+
+	list_for_each_entry_safe(adapter, tmp, &adapters_list_g, list) {
+
+		if (adapter->unique_id == unique_id) {
+
+			return MKADAP(index);
+		}
+
+		index++;
+	}
+
+	return 0;
+}
+
 
 /**
  * mraid_mm_setup_dma_pools - Set up dma buffer pools per adapter
diff -Nru a/drivers/scsi/megaraid/megaraid_mm.h b/drivers/scsi/megaraid/megaraid_mm.h
--- a/drivers/scsi/megaraid/megaraid_mm.h	2005-02-08 17:16:50 -06:00
+++ b/drivers/scsi/megaraid/megaraid_mm.h	2005-02-08 17:16:50 -06:00
@@ -29,9 +29,10 @@
 #include "megaraid_ioctl.h"
 
 
-#define LSI_COMMON_MOD_VERSION	"2.20.2.3"
+#define LSI_COMMON_MOD_VERSION	"2.20.2.5"
 #define LSI_COMMON_MOD_EXT_VERSION	\
-		"(Release Date: Thu Dec  9 19:02:14 EST 2004)"
+		"(Release Date: Fri Jan 21 00:01:03 EST 2005)"
+
 
 #define LSI_DBGLVL			dbglevel
 

===================================================================


This BitKeeper patch contains the following changesets:
1.2132.2.2
## Wrapped with gzip_uu ##


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
.QOXK?^M_Q4O/SX-:    
 

