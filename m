From: "Mahesh Rajashekhara" <Mahesh_Rajashekhara@pmc-sierra.com>
Subject: FW: [PATCH 1/1] aacraid: Added Sync.mode to support series 7/8/9 controllers
Date: Thu, 9 Feb 2012 00:15:05 -0800
Message-ID: <340C71CD25A7EB49BFA81AE8C83926671782D025@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CCE702.EF636E86"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60273 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756556Ab2BIIPJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 03:15:09 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, Achim Leubner <Achim_Leubner@pmc-sierra.com>, Tony Ruiz <Tony_Ruiz@pmc-sierra.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01CCE702.EF636E86
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

*Resending earlier sent email bounce back*

Hi James,

Patch description:
- Added Sync. mode to support Series 7/8/9 controller families:=20
  This is a compatibility mode for all these controller families. The
Async. (Performance) mode can be changed in the future.
- First Async. mode version added for Series 7
- Controller parameter aac_sync_mode added

This attached patch is against current upstream kernel

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments (inline gets damaged, please use
attachment).

Signed-off-by: Mahesh Rajashekhara <aacraid@pmc-sierra.com>

---

drivers/scsi/aacraid/aachba.c   |    4=20
drivers/scsi/aacraid/aacraid.h  |   27 +++
drivers/scsi/aacraid/comminit.c |   21 ++
drivers/scsi/aacraid/commsup.c  |   26 +++
drivers/scsi/aacraid/linit.c    |   28 +++
drivers/scsi/aacraid/rx.c       |    1=20
drivers/scsi/aacraid/sa.c       |    1=20
drivers/scsi/aacraid/src.c      |  291
+++++++++++++++++++++++++++++++++-------
8 files changed, 337 insertions(+), 62 deletions(-)

diff -purN a/drivers/scsi/aacraid/aachba.c
b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c	2012-02-06 16:47:59.000000000
+0530
+++ b/drivers/scsi/aacraid/aachba.c	2012-02-06 16:48:09.000000000
+0530
@@ -151,7 +151,11 @@ int aac_msi;
 int aac_commit =3D -1;
 int startup_timeout =3D 180;
 int aif_timeout =3D 120;
+int aac_sync_mode;  /* Only Sync. transfer - disabled */
=20
+module_param(aac_sync_mode, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(aac_sync_mode, "Force sync. transfer mode"
+	" 0=3Doff, 1=3Don");
 module_param(nondasd, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd
devices."
 	" 0=3Doff, 1=3Don");
diff -purN a/drivers/scsi/aacraid/aacraid.h
b/drivers/scsi/aacraid/aacraid.h
--- a/drivers/scsi/aacraid/aacraid.h	2012-02-06 16:47:59.000000000
+0530
+++ b/drivers/scsi/aacraid/aacraid.h	2012-02-07 13:50:03.000000000
+0530
@@ -12,7 +12,7 @@
=20
*-----------------------------------------------------------------------
-----*/
=20
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 28000
+# define AAC_DRIVER_BUILD 28900
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
@@ -756,8 +756,16 @@ struct src_mu_registers {
=20
 struct src_registers {
 	struct src_mu_registers MUnit;	/* 00h - c7h */
-	__le32 reserved1[130790];	/* c8h - 7fc5fh */
-	struct src_inbound IndexRegs;	/* 7fc60h */
+	union {
+		struct {
+			__le32 reserved1[130790];	/* c8h - 7fc5fh
*/
+			struct src_inbound IndexRegs;	/* 7fc60h */
+		} tupelo;
+		struct {
+			__le32 reserved1[974];		/* c8h - fffh */
+			struct src_inbound IndexRegs;	/* 1000h */
+		} denali;
+	} u;
 };
=20
 #define src_readb(AEP, CSR)
readb(&((AEP)->regs.src.bar0->CSR))
@@ -999,6 +1007,10 @@ struct aac_bus_info_response {
 #define AAC_OPT_NEW_COMM		cpu_to_le32(1<<17)
 #define AAC_OPT_NEW_COMM_64		cpu_to_le32(1<<18)
 #define AAC_OPT_NEW_COMM_TYPE1		cpu_to_le32(1<<28)
+#define AAC_OPT_NEW_COMM_TYPE2		cpu_to_le32(1<<29)
+#define AAC_OPT_NEW_COMM_TYPE3		cpu_to_le32(1<<30)
+#define AAC_OPT_NEW_COMM_TYPE4		cpu_to_le32(1<<31)
+
=20
 struct aac_dev
 {
@@ -1076,6 +1088,8 @@ struct aac_dev
 #	define AAC_MIN_FOOTPRINT_SIZE 8192
 #	define AAC_MIN_SRC_BAR0_SIZE 0x400000
 #	define AAC_MIN_SRC_BAR1_SIZE 0x800
+#	define AAC_MIN_SRCV_BAR0_SIZE 0x100000
+#	define AAC_MIN_SRCV_BAR1_SIZE 0x400
 #endif
 	union
 	{
@@ -1116,7 +1130,10 @@ struct aac_dev
 	u8			msi;
 	int			management_fib_count;
 	spinlock_t		manage_lock;
-
+	spinlock_t		sync_lock;
+	int			sync_mode;
+	struct fib		*sync_fib;
+	struct list_head	sync_fib_list;
 };
=20
 #define aac_adapter_interrupt(dev) \
@@ -1163,6 +1180,7 @@ struct aac_dev
=20
 #define FIB_CONTEXT_FLAG_TIMED_OUT		(0x00000001)
 #define FIB_CONTEXT_FLAG			(0x00000002)
+#define FIB_CONTEXT_FLAG_WAIT			(0x00000004)
=20
 /*
  *	Define the command values
@@ -1970,6 +1988,7 @@ int aac_rkt_init(struct aac_dev *dev);
 int aac_nark_init(struct aac_dev *dev);
 int aac_sa_init(struct aac_dev *dev);
 int aac_src_init(struct aac_dev *dev);
+int aac_srcv_init(struct aac_dev *dev);
 int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct
hw_fib * hw_fib, int wait, struct fib * fibptr, unsigned long
*nonotify);
 unsigned int aac_response_normal(struct aac_queue * q);
 unsigned int aac_command_normal(struct aac_queue * q);
diff -purN a/drivers/scsi/aacraid/comminit.c
b/drivers/scsi/aacraid/comminit.c
--- a/drivers/scsi/aacraid/comminit.c	2012-02-06 16:47:59.000000000
+0530
+++ b/drivers/scsi/aacraid/comminit.c	2012-02-06 16:50:55.000000000
+0530
@@ -325,12 +325,14 @@ struct aac_dev *aac_init_adapter(struct=20
 {
 	u32 status[5];
 	struct Scsi_Host * host =3D dev->scsi_host_ptr;
+	extern int aac_sync_mode;
=20
 	/*
 	 *	Check the preferred comm settings, defaults from
template.
 	 */
 	dev->management_fib_count =3D 0;
 	spin_lock_init(&dev->manage_lock);
+	spin_lock_init(&dev->sync_lock);
 	dev->max_fib_size =3D sizeof(struct hw_fib);
 	dev->sg_tablesize =3D host->sg_tablesize =3D (dev->max_fib_size
 		- sizeof(struct aac_fibhdr)
@@ -344,13 +346,21 @@ struct aac_dev *aac_init_adapter(struct=20
 	 		(status[0] =3D=3D 0x00000001)) {
 		if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_64))
 			dev->raw_io_64 =3D 1;
-		if (dev->a_ops.adapter_comm) {
-			if (status[1] &
le32_to_cpu(AAC_OPT_NEW_COMM_TYPE1)) {
-				dev->comm_interface =3D
AAC_COMM_MESSAGE_TYPE1;
-				dev->raw_io_interface =3D 1;
-			} else if (status[1] &
le32_to_cpu(AAC_OPT_NEW_COMM)) {
+		dev->sync_mode =3D aac_sync_mode;
+		if (dev->a_ops.adapter_comm &&
+			(status[1] & le32_to_cpu(AAC_OPT_NEW_COMM))) {
 				dev->comm_interface =3D AAC_COMM_MESSAGE;
 				dev->raw_io_interface =3D 1;
+			if ((status[1] &
le32_to_cpu(AAC_OPT_NEW_COMM_TYPE1))) {
+				/* driver supports TYPE1 (Tupelo) */
+				dev->comm_interface =3D
AAC_COMM_MESSAGE_TYPE1;
+			} else if ((status[1] &
le32_to_cpu(AAC_OPT_NEW_COMM_TYPE4)) ||
+				  (status[1] &
le32_to_cpu(AAC_OPT_NEW_COMM_TYPE3)) ||
+				  (status[1] &
le32_to_cpu(AAC_OPT_NEW_COMM_TYPE2))) {
+					/* driver doesn't support TYPE2
(Series7), TYPE3 and TYPE4 */
+					/* switch to sync. mode */
+					dev->comm_interface =3D
AAC_COMM_MESSAGE_TYPE1;
+					dev->sync_mode =3D 1;
 			}
 		}
 		if ((dev->comm_interface =3D=3D AAC_COMM_MESSAGE) &&
@@ -455,6 +465,7 @@ struct aac_dev *aac_init_adapter(struct=20
 	}
 	=09
 	INIT_LIST_HEAD(&dev->fib_list);
+	INIT_LIST_HEAD(&dev->sync_fib_list);
=20
 	return dev;
 }
diff -purN a/drivers/scsi/aacraid/commsup.c
b/drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c	2012-02-06 16:47:59.000000000
+0530
+++ b/drivers/scsi/aacraid/commsup.c	2012-02-06 16:56:09.000000000
+0530
@@ -416,6 +416,7 @@ int aac_fib_send(u16 command, struct fib
 	unsigned long flags =3D 0;
 	unsigned long qflags;
 	unsigned long mflags =3D 0;
+	unsigned long sflags =3D 0;
=20
=20
 	if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
@@ -512,6 +513,31 @@ int aac_fib_send(u16 command, struct fib
 		spin_lock_irqsave(&fibptr->event_lock, flags);
 	}
=20
+	if (dev->sync_mode) {
+		if (wait)
+			spin_unlock_irqrestore(&fibptr->event_lock,
flags);
+		spin_lock_irqsave(&dev->sync_lock, sflags);
+		if (dev->sync_fib) {
+			list_add_tail(&fibptr->fiblink,
&dev->sync_fib_list);
+			spin_unlock_irqrestore(&dev->sync_lock, sflags);
+		} else {
+			dev->sync_fib =3D fibptr;
+			spin_unlock_irqrestore(&dev->sync_lock, sflags);
+			aac_adapter_sync_cmd(dev, SEND_SYNCHRONOUS_FIB,
+				(u32)fibptr->hw_fib_pa, 0, 0, 0, 0, 0,
+				NULL, NULL, NULL, NULL, NULL);
+		}
+		if (wait) {
+			fibptr->flags |=3D FIB_CONTEXT_FLAG_WAIT;
+			if (down_interruptible(&fibptr->event_wait)) {
+				fibptr->flags &=3D ~FIB_CONTEXT_FLAG_WAIT;
+				return -EFAULT;
+			}
+			return 0;
+		}
+		return -EINPROGRESS;
+	}
+
 	if (aac_adapter_deliver(fibptr) !=3D 0) {
 		printk(KERN_ERR "aac_fib_send: returned -EBUSY\n");
 		if (wait) {
diff -purN a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c	2012-02-06 16:47:59.000000000
+0530
+++ b/drivers/scsi/aacraid/linit.c	2012-02-06 16:48:09.000000000
+0530
@@ -56,7 +56,7 @@
=20
 #include "aacraid.h"
=20
-#define AAC_DRIVER_VERSION		"1.1-7"
+#define AAC_DRIVER_VERSION		"1.2-0"
 #ifndef AAC_DRIVER_BRANCH
 #define AAC_DRIVER_BRANCH		""
 #endif
@@ -162,7 +162,10 @@ static const struct pci_device_id aac_pc
 	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 59 }, /* Adaptec
Catch All */
 	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 60 }, /* Adaptec
Rocket Catch All */
 	{ 0x9005, 0x0288, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 61 }, /* Adaptec
NEMER/ARK Catch All */
-	{ 0x9005, 0x028b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 62 }, /* Adaptec
PMC Catch All */
+	{ 0x9005, 0x028b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 62 }, /* Adaptec
PMC Series 6 (Tupelo) */
+	{ 0x9005, 0x028c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 63 }, /* Adaptec
PMC Series 7 (Denali) */
+	{ 0x9005, 0x028d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 64 }, /* Adaptec
PMC Series 8 */
+	{ 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /* Adaptec
PMC Series 9 */
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
@@ -238,7 +241,10 @@ static struct aac_driver_ident aac_drive
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2 },
/* Adaptec Catch All */
 	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 },
/* Adaptec Rocket Catch All */
 	{ aac_nark_init, "aacraid", "ADAPTEC ", "RAID           ", 2 },
/* Adaptec NEMER/ARK Catch All */
-	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }
/* Adaptec PMC Catch All */
+	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2 },
/* Adaptec PMC Series 6 (Tupelo) */
+	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 },
/* Adaptec PMC Series 7 (Denali) */
+	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 },
/* Adaptec PMC Series 8 */
+	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }
/* Adaptec PMC Series 9 */
 };
=20
 /**
@@ -1102,6 +1108,7 @@ static int __devinit aac_probe_one(struc
 	int error =3D -ENODEV;
 	int unique_id =3D 0;
 	u64 dmamask;
+	extern int aac_sync_mode;
=20
 	list_for_each_entry(aac, &aac_devices, entry) {
 		if (aac->id > unique_id)
@@ -1162,6 +1169,21 @@ static int __devinit aac_probe_one(struc
 	if ((*aac_drivers[index].init)(aac))
 		goto out_unmap;
=20
+	if (aac->sync_mode) {
+		if (aac_sync_mode)
+			printk(KERN_INFO "%s%d: Sync. mode enforced "
+				"by driver parameter. This will cause "
+				"a significant performance decrease!\n",
+				aac->name,
+				aac->id);
+		else
+			printk(KERN_INFO "%s%d: Async. mode not
supported "
+				"by current driver, sync. mode
enforced."
+				"\nPlease update driver to get full
performance.\n",
+				aac->name,
+				aac->id);
+	}
+
 	/*
 	 *	Start any kernel threads needed
 	 */
diff -purN a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
--- a/drivers/scsi/aacraid/rx.c	2012-02-06 16:47:59.000000000 +0530
+++ b/drivers/scsi/aacraid/rx.c	2012-02-06 16:48:09.000000000 +0530
@@ -643,6 +643,7 @@ int _aac_rx_init(struct aac_dev *dev)
 	if (aac_init_adapter(dev) =3D=3D NULL)
 		goto error_iounmap;
 	aac_adapter_comm(dev, dev->comm_interface);
+	dev->sync_mode =3D 0;	/* sync. mode not supported */
 	dev->msi =3D aac_msi && !pci_enable_msi(dev->pdev);
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
 			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0)
{
diff -purN a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
--- a/drivers/scsi/aacraid/sa.c	2012-02-06 16:47:59.000000000 +0530
+++ b/drivers/scsi/aacraid/sa.c	2012-02-06 16:48:09.000000000 +0530
@@ -385,6 +385,7 @@ int aac_sa_init(struct aac_dev *dev)
=20
 	if(aac_init_adapter(dev) =3D=3D NULL)
 		goto error_irq;
+	dev->sync_mode =3D 0;	/* sync. mode not supported */
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
 			IRQF_SHARED|IRQF_DISABLED,
 			"aacraid", (void *)dev ) < 0) {
diff -purN a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
--- a/drivers/scsi/aacraid/src.c	2012-02-06 16:47:59.000000000
+0530
+++ b/drivers/scsi/aacraid/src.c	2012-02-06 19:02:00.000000000
+0530
@@ -96,6 +96,38 @@ static irqreturn_t aac_src_intr_message(
 			our_interrupt =3D 1;
 			/* handle AIF */
 			aac_intr_normal(dev, 0, 2, 0, NULL);
+		} else if (bellbits_shifted & OUTBOUNDDOORBELL_0) {
+			unsigned long sflags;
+			struct list_head *entry;
+			int send_it =3D 0;
+
+			if (dev->sync_fib) {
+				our_interrupt =3D 1;
+				if (dev->sync_fib->callback)
+
dev->sync_fib->callback(dev->sync_fib->callback_data,
+						dev->sync_fib);
+
spin_lock_irqsave(&dev->sync_fib->event_lock, sflags);
+				if (dev->sync_fib->flags &
FIB_CONTEXT_FLAG_WAIT) {
+					dev->management_fib_count--;
+					up(&dev->sync_fib->event_wait);
+				}
+
spin_unlock_irqrestore(&dev->sync_fib->event_lock, sflags);
+				spin_lock_irqsave(&dev->sync_lock,
sflags);
+				if (!list_empty(&dev->sync_fib_list)) {
+					entry =3D dev->sync_fib_list.next;
+					dev->sync_fib =3D
list_entry(entry, struct fib, fiblink);
+					list_del(entry);
+					send_it =3D 1;
+				} else {
+					dev->sync_fib =3D NULL;
+				}
+				spin_unlock_irqrestore(&dev->sync_lock,
sflags);
+				if (send_it) {
+					aac_adapter_sync_cmd(dev,
SEND_SYNCHRONOUS_FIB,
+
(u32)dev->sync_fib->hw_fib_pa, 0, 0, 0, 0, 0,
+						NULL, NULL, NULL, NULL,
NULL);
+				}
+			}
 		}
 	}
=20
@@ -177,56 +209,63 @@ static int src_sync_cmd(struct aac_dev *
 	 */
 	src_writel(dev, MUnit.IDR, INBOUNDDOORBELL_0 << SRC_IDR_SHIFT);
=20
-	ok =3D 0;
-	start =3D jiffies;
+	if (!dev->sync_mode || command !=3D SEND_SYNCHRONOUS_FIB) {
+		ok =3D 0;
+		start =3D jiffies;
=20
-	/*
-	 *	Wait up to 30 seconds
-	 */
-	while (time_before(jiffies, start+30*HZ)) {
-		/* Delay 5 microseconds to let Mon960 get info. */
-		udelay(5);
-
-		/* Mon960 will set doorbell0 bit
-		 * when it has completed the command
+		/*
+		 *	Wait up to 5 minutes
 		 */
-		if ((src_readl(dev, MUnit.ODR_R) >> SRC_ODR_SHIFT) &
OUTBOUNDDOORBELL_0) {
-			/* Clear the doorbell */
-			src_writel(dev,
-				MUnit.ODR_C,
-				OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
-			ok =3D 1;
-			break;
+		while (time_before(jiffies, start+300*HZ)) {
+			udelay(5);	/* Delay 5 microseconds to let
Mon960 get info. */
+			/*
+			 *	Mon960 will set doorbell0 bit when it
has completed the command.
+			 */
+			if ((src_readl(dev, MUnit.ODR_R) >>
SRC_ODR_SHIFT) & OUTBOUNDDOORBELL_0) {
+				/*
+				 *	Clear the doorbell.
+				 */
+				src_writel(dev, MUnit.ODR_C,
OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
+				ok =3D 1;
+				break;
+			}
+			/*
+			 *	Yield the processor in case we are slow
+			 */
+			msleep(1);
+		}
+		if (unlikely(ok !=3D 1)) {
+			/*
+			 *	Restore interrupt mask even though we
timed out
+			 */
+			aac_adapter_enable_int(dev);
+			return -ETIMEDOUT;
 		}
+		/*
+		 *	Pull the synch status from Mailbox 0.
+		 */
+		if (status)
+			*status =3D readl(&dev->IndexRegs->Mailbox[0]);
+		if (r1)
+			*r1 =3D readl(&dev->IndexRegs->Mailbox[1]);
+		if (r2)
+			*r2 =3D readl(&dev->IndexRegs->Mailbox[2]);
+		if (r3)
+			*r3 =3D readl(&dev->IndexRegs->Mailbox[3]);
+		if (r4)
+			*r4 =3D readl(&dev->IndexRegs->Mailbox[4]);
=20
-		 /* Yield the processor in case we are slow */
-		msleep(1);
+		/*
+		 *	Clear the synch command doorbell.
+		 */
+		src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 <<
SRC_ODR_SHIFT);
 	}
-	if (unlikely(ok !=3D 1)) {
-		 /* Restore interrupt mask even though we timed out */
-		aac_adapter_enable_int(dev);
-		return -ETIMEDOUT;
-	}
-
-	 /* Pull the synch status from Mailbox 0 */
-	if (status)
-		*status =3D readl(&dev->IndexRegs->Mailbox[0]);
-	if (r1)
-		*r1 =3D readl(&dev->IndexRegs->Mailbox[1]);
-	if (r2)
-		*r2 =3D readl(&dev->IndexRegs->Mailbox[2]);
-	if (r3)
-		*r3 =3D readl(&dev->IndexRegs->Mailbox[3]);
-	if (r4)
-		*r4 =3D readl(&dev->IndexRegs->Mailbox[4]);
-
-	 /* Clear the synch command doorbell */
-	src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 <<
SRC_ODR_SHIFT);
=20
-	 /* Restore interrupt mask */
+	/*
+	 *	Restore interrupt mask
+	 */
 	aac_adapter_enable_int(dev);
 	return 0;
-
 }
=20
 /**
@@ -386,9 +425,7 @@ static int aac_src_ioremap(struct aac_de
 {
 	if (!size) {
 		iounmap(dev->regs.src.bar0);
-		dev->regs.src.bar0 =3D NULL;
-		iounmap(dev->base);
-		dev->base =3D NULL;
+		dev->base =3D dev->regs.src.bar0 =3D NULL;
 		return 0;
 	}
 	dev->regs.src.bar1 =3D ioremap(pci_resource_start(dev->pdev, 2),
@@ -404,7 +441,27 @@ static int aac_src_ioremap(struct aac_de
 		return -1;
 	}
 	dev->IndexRegs =3D &((struct src_registers __iomem *)
-		dev->base)->IndexRegs;
+		dev->base)->u.tupelo.IndexRegs;
+	return 0;
+}
+
+/**
+ *  aac_srcv_ioremap
+ *	@size: mapping resize request
+ *
+ */
+static int aac_srcv_ioremap(struct aac_dev *dev, u32 size)
+{
+	if (!size) {
+		iounmap(dev->regs.src.bar0);
+		dev->base =3D dev->regs.src.bar0 =3D NULL;
+		return 0;
+	}
+	dev->base =3D dev->regs.src.bar0 =3D
ioremap(dev->scsi_host_ptr->base, size);
+	if (dev->base =3D=3D NULL)
+		return -1;
+	dev->IndexRegs =3D &((struct src_registers __iomem *)
+		dev->base)->u.denali.IndexRegs;
 	return 0;
 }
=20
@@ -419,7 +476,7 @@ static int aac_src_restart_adapter(struc
 		bled =3D aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
 			0, 0, 0, 0, 0, 0, &var, &reset_mask, NULL, NULL,
NULL);
 			if (bled || (var !=3D 0x00000001))
-				bled =3D -EINVAL;
+				return -EINVAL;
 		if (dev->supplement_adapter_info.SupportedOptions2 &
 			AAC_OPTION_DOORBELL_RESET) {
 			src_writel(dev, MUnit.IDR, reset_mask);
@@ -579,15 +636,149 @@ int aac_src_init(struct aac_dev *dev)
 	dev->dbg_size =3D AAC_MIN_SRC_BAR1_SIZE;
=20
 	aac_adapter_enable_int(dev);
+
+	if (!dev->sync_mode) {
+		/*
+		 * Tell the adapter that all is configured, and it can
+		 * start accepting requests
+		 */
+		aac_src_start_adapter(dev);
+	}
+	return 0;
+
+error_iounmap:
+
+	return -1;
+}
+
+/**
+ *  aac_srcv_init	-	initialize an SRCv card
+ *  @dev: device to configure
+ *
+ */
+
+int aac_srcv_init(struct aac_dev *dev)
+{
+	unsigned long start;
+	unsigned long status;
+	int restart =3D 0;
+	int instance =3D dev->id;
+	const char *name =3D dev->name;
+
+	dev->a_ops.adapter_ioremap =3D aac_srcv_ioremap;
+	dev->a_ops.adapter_comm =3D aac_src_select_comm;
+
+	dev->base_size =3D AAC_MIN_SRCV_BAR0_SIZE;
+	if (aac_adapter_ioremap(dev, dev->base_size)) {
+		printk(KERN_WARNING "%s: unable to map adapter.\n",
name);
+		goto error_iounmap;
+	}
+
+	/* Failure to reset here is an option ... */
+	dev->a_ops.adapter_sync_cmd =3D src_sync_cmd;
+	dev->a_ops.adapter_enable_int =3D aac_src_disable_interrupt;
+	if ((aac_reset_devices || reset_devices) &&
+		!aac_src_restart_adapter(dev, 0))
+		++restart;
+	/*
+	 *	Check to see if the board panic'd while booting.
+	 */
+	status =3D src_readl(dev, MUnit.OMR);
+	if (status & KERNEL_PANIC) {
+		if (aac_src_restart_adapter(dev,
aac_src_check_health(dev)))
+			goto error_iounmap;
+		++restart;
+	}
 	/*
-	 *	Tell the adapter that all is configured, and it can
-	 * start accepting requests
+	 *	Check to see if the board failed any self tests.
+	 */
+	status =3D src_readl(dev, MUnit.OMR);
+	if (status & SELF_TEST_FAILED) {
+		printk(KERN_ERR "%s%d: adapter self-test failed.\n",
dev->name, instance);
+		goto error_iounmap;
+	}
+	/*
+	 *	Check to see if the monitor panic'd while booting.
+	 */
+	if (status & MONITOR_PANIC) {
+		printk(KERN_ERR "%s%d: adapter monitor panic.\n",
dev->name, instance);
+		goto error_iounmap;
+	}
+	start =3D jiffies;
+	/*
+	 *	Wait for the adapter to be up and running. Wait up to 3
minutes
 	 */
-	aac_src_start_adapter(dev);
+	while (!((status =3D src_readl(dev, MUnit.OMR)) &
KERNEL_UP_AND_RUNNING)) {
+		if ((restart &&
+		  (status &
(KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC))) ||
+		  time_after(jiffies, start+HZ*startup_timeout)) {
+			printk(KERN_ERR "%s%d: adapter kernel failed to
start, init status =3D %lx.\n",
+					dev->name, instance, status);
+			goto error_iounmap;
+		}
+		if (!restart &&
+		  ((status &
(KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC)) ||
+		  time_after(jiffies, start + HZ *
+		  ((startup_timeout > 60)
+		    ? (startup_timeout - 60)
+		    : (startup_timeout / 2))))) {
+			if (likely(!aac_src_restart_adapter(dev,
aac_src_check_health(dev))))
+				start =3D jiffies;
+			++restart;
+		}
+		msleep(1);
+	}
+	if (restart && aac_commit)
+		aac_commit =3D 1;
+	/*
+	 *	Fill in the common function dispatch table.
+	 */
+	dev->a_ops.adapter_interrupt =3D aac_src_interrupt_adapter;
+	dev->a_ops.adapter_disable_int =3D aac_src_disable_interrupt;
+	dev->a_ops.adapter_notify =3D aac_src_notify_adapter;
+	dev->a_ops.adapter_sync_cmd =3D src_sync_cmd;
+	dev->a_ops.adapter_check_health =3D aac_src_check_health;
+	dev->a_ops.adapter_restart =3D aac_src_restart_adapter;
+
+	/*
+	 *	First clear out all interrupts.  Then enable the one's
that we
+	 *	can handle.
+	 */
+	aac_adapter_comm(dev, AAC_COMM_MESSAGE);
+	aac_adapter_disable_int(dev);
+	src_writel(dev, MUnit.ODR_C, 0xffffffff);
+	aac_adapter_enable_int(dev);
=20
+	if (aac_init_adapter(dev) =3D=3D NULL)
+		goto error_iounmap;
+	if (dev->comm_interface !=3D AAC_COMM_MESSAGE_TYPE1)
+		goto error_iounmap;
+	dev->msi =3D aac_msi && !pci_enable_msi(dev->pdev);
+	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
+		IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+		if (dev->msi)
+			pci_disable_msi(dev->pdev);
+		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
+			name, instance);
+		goto error_iounmap;
+	}
+	dev->dbg_base =3D dev->scsi_host_ptr->base;
+	dev->dbg_base_mapped =3D dev->base;
+	dev->dbg_size =3D dev->base_size;
+
+	aac_adapter_enable_int(dev);
+
+	if (!dev->sync_mode) {
+		/*
+		 * Tell the adapter that all is configured, and it can
+		 * start accepting requests
+		 */
+		aac_src_start_adapter(dev);
+	}
 	return 0;
=20
 error_iounmap:
=20
 	return -1;
 }
+



------_=_NextPart_001_01CCE702.EF636E86
Content-Type: application/octet-stream;
	name="aacraid-Sync.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid-Sync.patch
Content-Disposition: attachment;
	filename="aacraid-Sync.patch"

ZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjaGJhLmMgICB8ICAgIDQgCmRyaXZlcnMvc2NzaS9hYWNy
YWlkL2FhY3JhaWQuaCAgfCAgIDI3ICsrKwpkcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21taW5pdC5j
IHwgICAyMSArKwpkcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tc3VwLmMgIHwgICAyNiArKysKZHJp
dmVycy9zY3NpL2FhY3JhaWQvbGluaXQuYyAgICB8ICAgMjggKysrCmRyaXZlcnMvc2NzaS9hYWNy
YWlkL3J4LmMgICAgICAgfCAgICAxIApkcml2ZXJzL3Njc2kvYWFjcmFpZC9zYS5jICAgICAgIHwg
ICAgMSAKZHJpdmVycy9zY3NpL2FhY3JhaWQvc3JjLmMgICAgICB8ICAyOTEgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQo4IGZpbGVzIGNoYW5nZWQsIDMzNyBpbnNlcnRp
b25zKCspLCA2MiBkZWxldGlvbnMoLSkKCmRpZmYgLXB1ck4gYS9kcml2ZXJzL3Njc2kvYWFjcmFp
ZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMv
c2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMTItMDItMDYgMTY6NDc6NTkuMDAwMDAwMDAwICswNTMw
CisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMTItMDItMDYgMTY6NDg6MDku
MDAwMDAwMDAwICswNTMwCkBAIC0xNTEsNyArMTUxLDExIEBAIGludCBhYWNfbXNpOwogaW50IGFh
Y19jb21taXQgPSAtMTsKIGludCBzdGFydHVwX3RpbWVvdXQgPSAxODA7CiBpbnQgYWlmX3RpbWVv
dXQgPSAxMjA7CitpbnQgYWFjX3N5bmNfbW9kZTsgIC8qIE9ubHkgU3luYy4gdHJhbnNmZXIgLSBk
aXNhYmxlZCAqLwogCittb2R1bGVfcGFyYW0oYWFjX3N5bmNfbW9kZSwgaW50LCBTX0lSVUdPfFNf
SVdVU1IpOworTU9EVUxFX1BBUk1fREVTQyhhYWNfc3luY19tb2RlLCAiRm9yY2Ugc3luYy4gdHJh
bnNmZXIgbW9kZSIKKwkiIDA9b2ZmLCAxPW9uIik7CiBtb2R1bGVfcGFyYW0obm9uZGFzZCwgaW50
LCBTX0lSVUdPfFNfSVdVU1IpOwogTU9EVUxFX1BBUk1fREVTQyhub25kYXNkLCAiQ29udHJvbCBz
Y2FubmluZyBvZiBoYmEgZm9yIG5vbmRhc2QgZGV2aWNlcy4iCiAJIiAwPW9mZiwgMT1vbiIpOwpk
aWZmIC1wdXJOIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oIGIvZHJpdmVycy9zY3Np
L2FhY3JhaWQvYWFjcmFpZC5oCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY3JhaWQuaAky
MDEyLTAyLTA2IDE2OjQ3OjU5LjAwMDAwMDAwMCArMDUzMAorKysgYi9kcml2ZXJzL3Njc2kvYWFj
cmFpZC9hYWNyYWlkLmgJMjAxMi0wMi0wNyAxMzo1MDowMy4wMDAwMDAwMDAgKzA1MzAKQEAgLTEy
LDcgKzEyLDcgQEAKICAqLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSovCiAKICNpZm5kZWYgQUFDX0RSSVZF
Ul9CVUlMRAotIyBkZWZpbmUgQUFDX0RSSVZFUl9CVUlMRCAyODAwMAorIyBkZWZpbmUgQUFDX0RS
SVZFUl9CVUlMRCAyODkwMAogIyBkZWZpbmUgQUFDX0RSSVZFUl9CUkFOQ0ggIi1tcyIKICNlbmRp
ZgogI2RlZmluZSBNQVhJTVVNX05VTV9DT05UQUlORVJTCTMyCkBAIC03NTYsOCArNzU2LDE2IEBA
IHN0cnVjdCBzcmNfbXVfcmVnaXN0ZXJzIHsKIAogc3RydWN0IHNyY19yZWdpc3RlcnMgewogCXN0
cnVjdCBzcmNfbXVfcmVnaXN0ZXJzIE1Vbml0OwkvKiAwMGggLSBjN2ggKi8KLQlfX2xlMzIgcmVz
ZXJ2ZWQxWzEzMDc5MF07CS8qIGM4aCAtIDdmYzVmaCAqLwotCXN0cnVjdCBzcmNfaW5ib3VuZCBJ
bmRleFJlZ3M7CS8qIDdmYzYwaCAqLworCXVuaW9uIHsKKwkJc3RydWN0IHsKKwkJCV9fbGUzMiBy
ZXNlcnZlZDFbMTMwNzkwXTsJLyogYzhoIC0gN2ZjNWZoICovCisJCQlzdHJ1Y3Qgc3JjX2luYm91
bmQgSW5kZXhSZWdzOwkvKiA3ZmM2MGggKi8KKwkJfSB0dXBlbG87CisJCXN0cnVjdCB7CisJCQlf
X2xlMzIgcmVzZXJ2ZWQxWzk3NF07CQkvKiBjOGggLSBmZmZoICovCisJCQlzdHJ1Y3Qgc3JjX2lu
Ym91bmQgSW5kZXhSZWdzOwkvKiAxMDAwaCAqLworCQl9IGRlbmFsaTsKKwl9IHU7CiB9OwogCiAj
ZGVmaW5lIHNyY19yZWFkYihBRVAsIENTUikJCXJlYWRiKCYoKEFFUCktPnJlZ3Muc3JjLmJhcjAt
PkNTUikpCkBAIC05OTksNiArMTAwNywxMCBAQCBzdHJ1Y3QgYWFjX2J1c19pbmZvX3Jlc3BvbnNl
IHsKICNkZWZpbmUgQUFDX09QVF9ORVdfQ09NTQkJY3B1X3RvX2xlMzIoMTw8MTcpCiAjZGVmaW5l
IEFBQ19PUFRfTkVXX0NPTU1fNjQJCWNwdV90b19sZTMyKDE8PDE4KQogI2RlZmluZSBBQUNfT1BU
X05FV19DT01NX1RZUEUxCQljcHVfdG9fbGUzMigxPDwyOCkKKyNkZWZpbmUgQUFDX09QVF9ORVdf
Q09NTV9UWVBFMgkJY3B1X3RvX2xlMzIoMTw8MjkpCisjZGVmaW5lIEFBQ19PUFRfTkVXX0NPTU1f
VFlQRTMJCWNwdV90b19sZTMyKDE8PDMwKQorI2RlZmluZSBBQUNfT1BUX05FV19DT01NX1RZUEU0
CQljcHVfdG9fbGUzMigxPDwzMSkKKwogCiBzdHJ1Y3QgYWFjX2RldgogewpAQCAtMTA3Niw2ICsx
MDg4LDggQEAgc3RydWN0IGFhY19kZXYKICMJZGVmaW5lIEFBQ19NSU5fRk9PVFBSSU5UX1NJWkUg
ODE5MgogIwlkZWZpbmUgQUFDX01JTl9TUkNfQkFSMF9TSVpFIDB4NDAwMDAwCiAjCWRlZmluZSBB
QUNfTUlOX1NSQ19CQVIxX1NJWkUgMHg4MDAKKyMJZGVmaW5lIEFBQ19NSU5fU1JDVl9CQVIwX1NJ
WkUgMHgxMDAwMDAKKyMJZGVmaW5lIEFBQ19NSU5fU1JDVl9CQVIxX1NJWkUgMHg0MDAKICNlbmRp
ZgogCXVuaW9uCiAJewpAQCAtMTExNiw3ICsxMTMwLDEwIEBAIHN0cnVjdCBhYWNfZGV2CiAJdTgJ
CQltc2k7CiAJaW50CQkJbWFuYWdlbWVudF9maWJfY291bnQ7CiAJc3BpbmxvY2tfdAkJbWFuYWdl
X2xvY2s7Ci0KKwlzcGlubG9ja190CQlzeW5jX2xvY2s7CisJaW50CQkJc3luY19tb2RlOworCXN0
cnVjdCBmaWIJCSpzeW5jX2ZpYjsKKwlzdHJ1Y3QgbGlzdF9oZWFkCXN5bmNfZmliX2xpc3Q7CiB9
OwogCiAjZGVmaW5lIGFhY19hZGFwdGVyX2ludGVycnVwdChkZXYpIFwKQEAgLTExNjMsNiArMTE4
MCw3IEBAIHN0cnVjdCBhYWNfZGV2CiAKICNkZWZpbmUgRklCX0NPTlRFWFRfRkxBR19USU1FRF9P
VVQJCSgweDAwMDAwMDAxKQogI2RlZmluZSBGSUJfQ09OVEVYVF9GTEFHCQkJKDB4MDAwMDAwMDIp
CisjZGVmaW5lIEZJQl9DT05URVhUX0ZMQUdfV0FJVAkJCSgweDAwMDAwMDA0KQogCiAvKgogICoJ
RGVmaW5lIHRoZSBjb21tYW5kIHZhbHVlcwpAQCAtMTk3MCw2ICsxOTg4LDcgQEAgaW50IGFhY19y
a3RfaW5pdChzdHJ1Y3QgYWFjX2RldiAqZGV2KTsKIGludCBhYWNfbmFya19pbml0KHN0cnVjdCBh
YWNfZGV2ICpkZXYpOwogaW50IGFhY19zYV9pbml0KHN0cnVjdCBhYWNfZGV2ICpkZXYpOwogaW50
IGFhY19zcmNfaW5pdChzdHJ1Y3QgYWFjX2RldiAqZGV2KTsKK2ludCBhYWNfc3Jjdl9pbml0KHN0
cnVjdCBhYWNfZGV2ICpkZXYpOwogaW50IGFhY19xdWV1ZV9nZXQoc3RydWN0IGFhY19kZXYgKiBk
ZXYsIHUzMiAqIGluZGV4LCB1MzIgcWlkLCBzdHJ1Y3QgaHdfZmliICogaHdfZmliLCBpbnQgd2Fp
dCwgc3RydWN0IGZpYiAqIGZpYnB0ciwgdW5zaWduZWQgbG9uZyAqbm9ub3RpZnkpOwogdW5zaWdu
ZWQgaW50IGFhY19yZXNwb25zZV9ub3JtYWwoc3RydWN0IGFhY19xdWV1ZSAqIHEpOwogdW5zaWdu
ZWQgaW50IGFhY19jb21tYW5kX25vcm1hbChzdHJ1Y3QgYWFjX3F1ZXVlICogcSk7CmRpZmYgLXB1
ck4gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21taW5pdC5jIGIvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvY29tbWluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21taW5pdC5jCTIwMTIt
MDItMDYgMTY6NDc6NTkuMDAwMDAwMDAwICswNTMwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2NvbW1pbml0LmMJMjAxMi0wMi0wNiAxNjo1MDo1NS4wMDAwMDAwMDAgKzA1MzAKQEAgLTMyNSwx
MiArMzI1LDE0IEBAIHN0cnVjdCBhYWNfZGV2ICphYWNfaW5pdF9hZGFwdGVyKHN0cnVjdCAKIHsK
IAl1MzIgc3RhdHVzWzVdOwogCXN0cnVjdCBTY3NpX0hvc3QgKiBob3N0ID0gZGV2LT5zY3NpX2hv
c3RfcHRyOworCWV4dGVybiBpbnQgYWFjX3N5bmNfbW9kZTsKIAogCS8qCiAJICoJQ2hlY2sgdGhl
IHByZWZlcnJlZCBjb21tIHNldHRpbmdzLCBkZWZhdWx0cyBmcm9tIHRlbXBsYXRlLgogCSAqLwog
CWRldi0+bWFuYWdlbWVudF9maWJfY291bnQgPSAwOwogCXNwaW5fbG9ja19pbml0KCZkZXYtPm1h
bmFnZV9sb2NrKTsKKwlzcGluX2xvY2tfaW5pdCgmZGV2LT5zeW5jX2xvY2spOwogCWRldi0+bWF4
X2ZpYl9zaXplID0gc2l6ZW9mKHN0cnVjdCBod19maWIpOwogCWRldi0+c2dfdGFibGVzaXplID0g
aG9zdC0+c2dfdGFibGVzaXplID0gKGRldi0+bWF4X2ZpYl9zaXplCiAJCS0gc2l6ZW9mKHN0cnVj
dCBhYWNfZmliaGRyKQpAQCAtMzQ0LDEzICszNDYsMjEgQEAgc3RydWN0IGFhY19kZXYgKmFhY19p
bml0X2FkYXB0ZXIoc3RydWN0IAogCSAJCShzdGF0dXNbMF0gPT0gMHgwMDAwMDAwMSkpIHsKIAkJ
aWYgKHN0YXR1c1sxXSAmIGxlMzJfdG9fY3B1KEFBQ19PUFRfTkVXX0NPTU1fNjQpKQogCQkJZGV2
LT5yYXdfaW9fNjQgPSAxOwotCQlpZiAoZGV2LT5hX29wcy5hZGFwdGVyX2NvbW0pIHsKLQkJCWlm
IChzdGF0dXNbMV0gJiBsZTMyX3RvX2NwdShBQUNfT1BUX05FV19DT01NX1RZUEUxKSkgewotCQkJ
CWRldi0+Y29tbV9pbnRlcmZhY2UgPSBBQUNfQ09NTV9NRVNTQUdFX1RZUEUxOwotCQkJCWRldi0+
cmF3X2lvX2ludGVyZmFjZSA9IDE7Ci0JCQl9IGVsc2UgaWYgKHN0YXR1c1sxXSAmIGxlMzJfdG9f
Y3B1KEFBQ19PUFRfTkVXX0NPTU0pKSB7CisJCWRldi0+c3luY19tb2RlID0gYWFjX3N5bmNfbW9k
ZTsKKwkJaWYgKGRldi0+YV9vcHMuYWRhcHRlcl9jb21tICYmCisJCQkoc3RhdHVzWzFdICYgbGUz
Ml90b19jcHUoQUFDX09QVF9ORVdfQ09NTSkpKSB7CiAJCQkJZGV2LT5jb21tX2ludGVyZmFjZSA9
IEFBQ19DT01NX01FU1NBR0U7CiAJCQkJZGV2LT5yYXdfaW9faW50ZXJmYWNlID0gMTsKKwkJCWlm
ICgoc3RhdHVzWzFdICYgbGUzMl90b19jcHUoQUFDX09QVF9ORVdfQ09NTV9UWVBFMSkpKSB7CisJ
CQkJLyogZHJpdmVyIHN1cHBvcnRzIFRZUEUxIChUdXBlbG8pICovCisJCQkJZGV2LT5jb21tX2lu
dGVyZmFjZSA9IEFBQ19DT01NX01FU1NBR0VfVFlQRTE7CisJCQl9IGVsc2UgaWYgKChzdGF0dXNb
MV0gJiBsZTMyX3RvX2NwdShBQUNfT1BUX05FV19DT01NX1RZUEU0KSkgfHwKKwkJCQkgIChzdGF0
dXNbMV0gJiBsZTMyX3RvX2NwdShBQUNfT1BUX05FV19DT01NX1RZUEUzKSkgfHwKKwkJCQkgIChz
dGF0dXNbMV0gJiBsZTMyX3RvX2NwdShBQUNfT1BUX05FV19DT01NX1RZUEUyKSkpIHsKKwkJCQkJ
LyogZHJpdmVyIGRvZXNuJ3Qgc3VwcG9ydCBUWVBFMiAoU2VyaWVzNyksIFRZUEUzIGFuZCBUWVBF
NCAqLworCQkJCQkvKiBzd2l0Y2ggdG8gc3luYy4gbW9kZSAqLworCQkJCQlkZXYtPmNvbW1faW50
ZXJmYWNlID0gQUFDX0NPTU1fTUVTU0FHRV9UWVBFMTsKKwkJCQkJZGV2LT5zeW5jX21vZGUgPSAx
OwogCQkJfQogCQl9CiAJCWlmICgoZGV2LT5jb21tX2ludGVyZmFjZSA9PSBBQUNfQ09NTV9NRVNT
QUdFKSAmJgpAQCAtNDU1LDYgKzQ2NSw3IEBAIHN0cnVjdCBhYWNfZGV2ICphYWNfaW5pdF9hZGFw
dGVyKHN0cnVjdCAKIAl9CiAJCQogCUlOSVRfTElTVF9IRUFEKCZkZXYtPmZpYl9saXN0KTsKKwlJ
TklUX0xJU1RfSEVBRCgmZGV2LT5zeW5jX2ZpYl9saXN0KTsKIAogCXJldHVybiBkZXY7CiB9CmRp
ZmYgLXB1ck4gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tc3VwLmMgYi9kcml2ZXJzL3Njc2kv
YWFjcmFpZC9jb21tc3VwLmMKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbXN1cC5jCTIw
MTItMDItMDYgMTY6NDc6NTkuMDAwMDAwMDAwICswNTMwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNy
YWlkL2NvbW1zdXAuYwkyMDEyLTAyLTA2IDE2OjU2OjA5LjAwMDAwMDAwMCArMDUzMApAQCAtNDE2
LDYgKzQxNiw3IEBAIGludCBhYWNfZmliX3NlbmQodTE2IGNvbW1hbmQsIHN0cnVjdCBmaWIKIAl1
bnNpZ25lZCBsb25nIGZsYWdzID0gMDsKIAl1bnNpZ25lZCBsb25nIHFmbGFnczsKIAl1bnNpZ25l
ZCBsb25nIG1mbGFncyA9IDA7CisJdW5zaWduZWQgbG9uZyBzZmxhZ3MgPSAwOwogCiAKIAlpZiAo
IShod19maWItPmhlYWRlci5YZmVyU3RhdGUgJiBjcHVfdG9fbGUzMihIb3N0T3duZWQpKSkKQEAg
LTUxMiw2ICs1MTMsMzEgQEAgaW50IGFhY19maWJfc2VuZCh1MTYgY29tbWFuZCwgc3RydWN0IGZp
YgogCQlzcGluX2xvY2tfaXJxc2F2ZSgmZmlicHRyLT5ldmVudF9sb2NrLCBmbGFncyk7CiAJfQog
CisJaWYgKGRldi0+c3luY19tb2RlKSB7CisJCWlmICh3YWl0KQorCQkJc3Bpbl91bmxvY2tfaXJx
cmVzdG9yZSgmZmlicHRyLT5ldmVudF9sb2NrLCBmbGFncyk7CisJCXNwaW5fbG9ja19pcnFzYXZl
KCZkZXYtPnN5bmNfbG9jaywgc2ZsYWdzKTsKKwkJaWYgKGRldi0+c3luY19maWIpIHsKKwkJCWxp
c3RfYWRkX3RhaWwoJmZpYnB0ci0+ZmlibGluaywgJmRldi0+c3luY19maWJfbGlzdCk7CisJCQlz
cGluX3VubG9ja19pcnFyZXN0b3JlKCZkZXYtPnN5bmNfbG9jaywgc2ZsYWdzKTsKKwkJfSBlbHNl
IHsKKwkJCWRldi0+c3luY19maWIgPSBmaWJwdHI7CisJCQlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZkZXYtPnN5bmNfbG9jaywgc2ZsYWdzKTsKKwkJCWFhY19hZGFwdGVyX3N5bmNfY21kKGRldiwg
U0VORF9TWU5DSFJPTk9VU19GSUIsCisJCQkJKHUzMilmaWJwdHItPmh3X2ZpYl9wYSwgMCwgMCwg
MCwgMCwgMCwKKwkJCQlOVUxMLCBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMKTsKKwkJfQorCQlpZiAo
d2FpdCkgeworCQkJZmlicHRyLT5mbGFncyB8PSBGSUJfQ09OVEVYVF9GTEFHX1dBSVQ7CisJCQlp
ZiAoZG93bl9pbnRlcnJ1cHRpYmxlKCZmaWJwdHItPmV2ZW50X3dhaXQpKSB7CisJCQkJZmlicHRy
LT5mbGFncyAmPSB+RklCX0NPTlRFWFRfRkxBR19XQUlUOworCQkJCXJldHVybiAtRUZBVUxUOwor
CQkJfQorCQkJcmV0dXJuIDA7CisJCX0KKwkJcmV0dXJuIC1FSU5QUk9HUkVTUzsKKwl9CisKIAlp
ZiAoYWFjX2FkYXB0ZXJfZGVsaXZlcihmaWJwdHIpICE9IDApIHsKIAkJcHJpbnRrKEtFUk5fRVJS
ICJhYWNfZmliX3NlbmQ6IHJldHVybmVkIC1FQlVTWVxuIik7CiAJCWlmICh3YWl0KSB7CmRpZmYg
LXB1ck4gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMTItMDItMDYg
MTY6NDc6NTkuMDAwMDAwMDAwICswNTMwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0
LmMJMjAxMi0wMi0wNiAxNjo0ODowOS4wMDAwMDAwMDAgKzA1MzAKQEAgLTU2LDcgKzU2LDcgQEAK
IAogI2luY2x1ZGUgImFhY3JhaWQuaCIKIAotI2RlZmluZSBBQUNfRFJJVkVSX1ZFUlNJT04JCSIx
LjEtNyIKKyNkZWZpbmUgQUFDX0RSSVZFUl9WRVJTSU9OCQkiMS4yLTAiCiAjaWZuZGVmIEFBQ19E
UklWRVJfQlJBTkNICiAjZGVmaW5lIEFBQ19EUklWRVJfQlJBTkNICQkiIgogI2VuZGlmCkBAIC0x
NjIsNyArMTYyLDEwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCBhYWNfcGMK
IAl7IDB4OTAwNSwgMHgwMjg1LCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAwLCAwLCA1OSB9LCAv
KiBBZGFwdGVjIENhdGNoIEFsbCAqLwogCXsgMHg5MDA1LCAweDAyODYsIFBDSV9BTllfSUQsIFBD
SV9BTllfSUQsIDAsIDAsIDYwIH0sIC8qIEFkYXB0ZWMgUm9ja2V0IENhdGNoIEFsbCAqLwogCXsg
MHg5MDA1LCAweDAyODgsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAsIDYxIH0sIC8qIEFk
YXB0ZWMgTkVNRVIvQVJLIENhdGNoIEFsbCAqLwotCXsgMHg5MDA1LCAweDAyOGIsIFBDSV9BTllf
SUQsIFBDSV9BTllfSUQsIDAsIDAsIDYyIH0sIC8qIEFkYXB0ZWMgUE1DIENhdGNoIEFsbCAqLwor
CXsgMHg5MDA1LCAweDAyOGIsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAsIDYyIH0sIC8q
IEFkYXB0ZWMgUE1DIFNlcmllcyA2IChUdXBlbG8pICovCisJeyAweDkwMDUsIDB4MDI4YywgUENJ
X0FOWV9JRCwgUENJX0FOWV9JRCwgMCwgMCwgNjMgfSwgLyogQWRhcHRlYyBQTUMgU2VyaWVzIDcg
KERlbmFsaSkgKi8KKwl7IDB4OTAwNSwgMHgwMjhkLCBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAw
LCAwLCA2NCB9LCAvKiBBZGFwdGVjIFBNQyBTZXJpZXMgOCAqLworCXsgMHg5MDA1LCAweDAyOGYs
IFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAsIDY1IH0sIC8qIEFkYXB0ZWMgUE1DIFNlcmll
cyA5ICovCiAJeyAwLH0KIH07CiBNT0RVTEVfREVWSUNFX1RBQkxFKHBjaSwgYWFjX3BjaV90Ymwp
OwpAQCAtMjM4LDcgKzI0MSwxMCBAQCBzdGF0aWMgc3RydWN0IGFhY19kcml2ZXJfaWRlbnQgYWFj
X2RyaXZlCiAJeyBhYWNfcnhfaW5pdCwgImFhY3JhaWQiLCAgIkFEQVBURUMgIiwgIlJBSUQgICAg
ICAgICAgICAiLCAyIH0sIC8qIEFkYXB0ZWMgQ2F0Y2ggQWxsICovCiAJeyBhYWNfcmt0X2luaXQs
ICJhYWNyYWlkIiwgIkFEQVBURUMgIiwgIlJBSUQgICAgICAgICAgICAiLCAyIH0sIC8qIEFkYXB0
ZWMgUm9ja2V0IENhdGNoIEFsbCAqLwogCXsgYWFjX25hcmtfaW5pdCwgImFhY3JhaWQiLCAiQURB
UFRFQyAiLCAiUkFJRCAgICAgICAgICAgIiwgMiB9LCAvKiBBZGFwdGVjIE5FTUVSL0FSSyBDYXRj
aCBBbGwgKi8KLQl7IGFhY19zcmNfaW5pdCwgImFhY3JhaWQiLCAiQURBUFRFQyAiLCAiUkFJRCAg
ICAgICAgICAgICIsIDIgfSAvKiBBZGFwdGVjIFBNQyBDYXRjaCBBbGwgKi8KKwl7IGFhY19zcmNf
aW5pdCwgImFhY3JhaWQiLCAiQURBUFRFQyAiLCAiUkFJRCAgICAgICAgICAgICIsIDIgfSwgLyog
QWRhcHRlYyBQTUMgU2VyaWVzIDYgKFR1cGVsbykgKi8KKwl7IGFhY19zcmN2X2luaXQsICJhYWNy
YWlkIiwgIkFEQVBURUMgIiwgIlJBSUQgICAgICAgICAgICAiLCAyIH0sIC8qIEFkYXB0ZWMgUE1D
IFNlcmllcyA3IChEZW5hbGkpICovCisJeyBhYWNfc3Jjdl9pbml0LCAiYWFjcmFpZCIsICJBREFQ
VEVDICIsICJSQUlEICAgICAgICAgICAgIiwgMiB9LCAvKiBBZGFwdGVjIFBNQyBTZXJpZXMgOCAq
LworCXsgYWFjX3NyY3ZfaW5pdCwgImFhY3JhaWQiLCAiQURBUFRFQyAiLCAiUkFJRCAgICAgICAg
ICAgICIsIDIgfSAvKiBBZGFwdGVjIFBNQyBTZXJpZXMgOSAqLwogfTsKIAogLyoqCkBAIC0xMTAy
LDYgKzExMDgsNyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBhYWNfcHJvYmVfb25lKHN0cnVjCiAJ
aW50IGVycm9yID0gLUVOT0RFVjsKIAlpbnQgdW5pcXVlX2lkID0gMDsKIAl1NjQgZG1hbWFzazsK
KwlleHRlcm4gaW50IGFhY19zeW5jX21vZGU7CiAKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5KGFhYywg
JmFhY19kZXZpY2VzLCBlbnRyeSkgewogCQlpZiAoYWFjLT5pZCA+IHVuaXF1ZV9pZCkKQEAgLTEx
NjIsNiArMTE2OSwyMSBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBhYWNfcHJvYmVfb25lKHN0cnVj
CiAJaWYgKCgqYWFjX2RyaXZlcnNbaW5kZXhdLmluaXQpKGFhYykpCiAJCWdvdG8gb3V0X3VubWFw
OwogCisJaWYgKGFhYy0+c3luY19tb2RlKSB7CisJCWlmIChhYWNfc3luY19tb2RlKQorCQkJcHJp
bnRrKEtFUk5fSU5GTyAiJXMlZDogU3luYy4gbW9kZSBlbmZvcmNlZCAiCisJCQkJImJ5IGRyaXZl
ciBwYXJhbWV0ZXIuIFRoaXMgd2lsbCBjYXVzZSAiCisJCQkJImEgc2lnbmlmaWNhbnQgcGVyZm9y
bWFuY2UgZGVjcmVhc2UhXG4iLAorCQkJCWFhYy0+bmFtZSwKKwkJCQlhYWMtPmlkKTsKKwkJZWxz
ZQorCQkJcHJpbnRrKEtFUk5fSU5GTyAiJXMlZDogQXN5bmMuIG1vZGUgbm90IHN1cHBvcnRlZCAi
CisJCQkJImJ5IGN1cnJlbnQgZHJpdmVyLCBzeW5jLiBtb2RlIGVuZm9yY2VkLiIKKwkJCQkiXG5Q
bGVhc2UgdXBkYXRlIGRyaXZlciB0byBnZXQgZnVsbCBwZXJmb3JtYW5jZS5cbiIsCisJCQkJYWFj
LT5uYW1lLAorCQkJCWFhYy0+aWQpOworCX0KKwogCS8qCiAJICoJU3RhcnQgYW55IGtlcm5lbCB0
aHJlYWRzIG5lZWRlZAogCSAqLwpkaWZmIC1wdXJOIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvcngu
YyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQv
cnguYwkyMDEyLTAyLTA2IDE2OjQ3OjU5LjAwMDAwMDAwMCArMDUzMAorKysgYi9kcml2ZXJzL3Nj
c2kvYWFjcmFpZC9yeC5jCTIwMTItMDItMDYgMTY6NDg6MDkuMDAwMDAwMDAwICswNTMwCkBAIC02
NDMsNiArNjQzLDcgQEAgaW50IF9hYWNfcnhfaW5pdChzdHJ1Y3QgYWFjX2RldiAqZGV2KQogCWlm
IChhYWNfaW5pdF9hZGFwdGVyKGRldikgPT0gTlVMTCkKIAkJZ290byBlcnJvcl9pb3VubWFwOwog
CWFhY19hZGFwdGVyX2NvbW0oZGV2LCBkZXYtPmNvbW1faW50ZXJmYWNlKTsKKwlkZXYtPnN5bmNf
bW9kZSA9IDA7CS8qIHN5bmMuIG1vZGUgbm90IHN1cHBvcnRlZCAqLwogCWRldi0+bXNpID0gYWFj
X21zaSAmJiAhcGNpX2VuYWJsZV9tc2koZGV2LT5wZGV2KTsKIAlpZiAocmVxdWVzdF9pcnEoZGV2
LT5wZGV2LT5pcnEsIGRldi0+YV9vcHMuYWRhcHRlcl9pbnRyLAogCQkJSVJRRl9TSEFSRUR8SVJR
Rl9ESVNBQkxFRCwgImFhY3JhaWQiLCBkZXYpIDwgMCkgewpkaWZmIC1wdXJOIGEvZHJpdmVycy9z
Y3NpL2FhY3JhaWQvc2EuYyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NhLmMKLS0tIGEvZHJpdmVy
cy9zY3NpL2FhY3JhaWQvc2EuYwkyMDEyLTAyLTA2IDE2OjQ3OjU5LjAwMDAwMDAwMCArMDUzMAor
KysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9zYS5jCTIwMTItMDItMDYgMTY6NDg6MDkuMDAwMDAw
MDAwICswNTMwCkBAIC0zODUsNiArMzg1LDcgQEAgaW50IGFhY19zYV9pbml0KHN0cnVjdCBhYWNf
ZGV2ICpkZXYpCiAKIAlpZihhYWNfaW5pdF9hZGFwdGVyKGRldikgPT0gTlVMTCkKIAkJZ290byBl
cnJvcl9pcnE7CisJZGV2LT5zeW5jX21vZGUgPSAwOwkvKiBzeW5jLiBtb2RlIG5vdCBzdXBwb3J0
ZWQgKi8KIAlpZiAocmVxdWVzdF9pcnEoZGV2LT5wZGV2LT5pcnEsIGRldi0+YV9vcHMuYWRhcHRl
cl9pbnRyLAogCQkJSVJRRl9TSEFSRUR8SVJRRl9ESVNBQkxFRCwKIAkJCSJhYWNyYWlkIiwgKHZv
aWQgKilkZXYgKSA8IDApIHsKZGlmZiAtcHVyTiBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NyYy5j
IGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvc3JjLmMKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQv
c3JjLmMJMjAxMi0wMi0wNiAxNjo0Nzo1OS4wMDAwMDAwMDAgKzA1MzAKKysrIGIvZHJpdmVycy9z
Y3NpL2FhY3JhaWQvc3JjLmMJMjAxMi0wMi0wNiAxOTowMjowMC4wMDAwMDAwMDAgKzA1MzAKQEAg
LTk2LDYgKzk2LDM4IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCBhYWNfc3JjX2ludHJfbWVzc2FnZSgK
IAkJCW91cl9pbnRlcnJ1cHQgPSAxOwogCQkJLyogaGFuZGxlIEFJRiAqLwogCQkJYWFjX2ludHJf
bm9ybWFsKGRldiwgMCwgMiwgMCwgTlVMTCk7CisJCX0gZWxzZSBpZiAoYmVsbGJpdHNfc2hpZnRl
ZCAmIE9VVEJPVU5ERE9PUkJFTExfMCkgeworCQkJdW5zaWduZWQgbG9uZyBzZmxhZ3M7CisJCQlz
dHJ1Y3QgbGlzdF9oZWFkICplbnRyeTsKKwkJCWludCBzZW5kX2l0ID0gMDsKKworCQkJaWYgKGRl
di0+c3luY19maWIpIHsKKwkJCQlvdXJfaW50ZXJydXB0ID0gMTsKKwkJCQlpZiAoZGV2LT5zeW5j
X2ZpYi0+Y2FsbGJhY2spCisJCQkJCWRldi0+c3luY19maWItPmNhbGxiYWNrKGRldi0+c3luY19m
aWItPmNhbGxiYWNrX2RhdGEsCisJCQkJCQlkZXYtPnN5bmNfZmliKTsKKwkJCQlzcGluX2xvY2tf
aXJxc2F2ZSgmZGV2LT5zeW5jX2ZpYi0+ZXZlbnRfbG9jaywgc2ZsYWdzKTsKKwkJCQlpZiAoZGV2
LT5zeW5jX2ZpYi0+ZmxhZ3MgJiBGSUJfQ09OVEVYVF9GTEFHX1dBSVQpIHsKKwkJCQkJZGV2LT5t
YW5hZ2VtZW50X2ZpYl9jb3VudC0tOworCQkJCQl1cCgmZGV2LT5zeW5jX2ZpYi0+ZXZlbnRfd2Fp
dCk7CisJCQkJfQorCQkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRldi0+c3luY19maWItPmV2
ZW50X2xvY2ssIHNmbGFncyk7CisJCQkJc3Bpbl9sb2NrX2lycXNhdmUoJmRldi0+c3luY19sb2Nr
LCBzZmxhZ3MpOworCQkJCWlmICghbGlzdF9lbXB0eSgmZGV2LT5zeW5jX2ZpYl9saXN0KSkgewor
CQkJCQllbnRyeSA9IGRldi0+c3luY19maWJfbGlzdC5uZXh0OworCQkJCQlkZXYtPnN5bmNfZmli
ID0gbGlzdF9lbnRyeShlbnRyeSwgc3RydWN0IGZpYiwgZmlibGluayk7CisJCQkJCWxpc3RfZGVs
KGVudHJ5KTsKKwkJCQkJc2VuZF9pdCA9IDE7CisJCQkJfSBlbHNlIHsKKwkJCQkJZGV2LT5zeW5j
X2ZpYiA9IE5VTEw7CisJCQkJfQorCQkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmRldi0+c3lu
Y19sb2NrLCBzZmxhZ3MpOworCQkJCWlmIChzZW5kX2l0KSB7CisJCQkJCWFhY19hZGFwdGVyX3N5
bmNfY21kKGRldiwgU0VORF9TWU5DSFJPTk9VU19GSUIsCisJCQkJCQkodTMyKWRldi0+c3luY19m
aWItPmh3X2ZpYl9wYSwgMCwgMCwgMCwgMCwgMCwKKwkJCQkJCU5VTEwsIE5VTEwsIE5VTEwsIE5V
TEwsIE5VTEwpOworCQkJCX0KKwkJCX0KIAkJfQogCX0KIApAQCAtMTc3LDU2ICsyMDksNjMgQEAg
c3RhdGljIGludCBzcmNfc3luY19jbWQoc3RydWN0IGFhY19kZXYgKgogCSAqLwogCXNyY193cml0
ZWwoZGV2LCBNVW5pdC5JRFIsIElOQk9VTkRET09SQkVMTF8wIDw8IFNSQ19JRFJfU0hJRlQpOwog
Ci0Jb2sgPSAwOwotCXN0YXJ0ID0gamlmZmllczsKKwlpZiAoIWRldi0+c3luY19tb2RlIHx8IGNv
bW1hbmQgIT0gU0VORF9TWU5DSFJPTk9VU19GSUIpIHsKKwkJb2sgPSAwOworCQlzdGFydCA9IGpp
ZmZpZXM7CiAKLQkvKgotCSAqCVdhaXQgdXAgdG8gMzAgc2Vjb25kcwotCSAqLwotCXdoaWxlICh0
aW1lX2JlZm9yZShqaWZmaWVzLCBzdGFydCszMCpIWikpIHsKLQkJLyogRGVsYXkgNSBtaWNyb3Nl
Y29uZHMgdG8gbGV0IE1vbjk2MCBnZXQgaW5mby4gKi8KLQkJdWRlbGF5KDUpOwotCi0JCS8qIE1v
bjk2MCB3aWxsIHNldCBkb29yYmVsbDAgYml0Ci0JCSAqIHdoZW4gaXQgaGFzIGNvbXBsZXRlZCB0
aGUgY29tbWFuZAorCQkvKgorCQkgKglXYWl0IHVwIHRvIDUgbWludXRlcwogCQkgKi8KLQkJaWYg
KChzcmNfcmVhZGwoZGV2LCBNVW5pdC5PRFJfUikgPj4gU1JDX09EUl9TSElGVCkgJiBPVVRCT1VO
RERPT1JCRUxMXzApIHsKLQkJCS8qIENsZWFyIHRoZSBkb29yYmVsbCAqLwotCQkJc3JjX3dyaXRl
bChkZXYsCi0JCQkJTVVuaXQuT0RSX0MsCi0JCQkJT1VUQk9VTkRET09SQkVMTF8wIDw8IFNSQ19P
RFJfU0hJRlQpOwotCQkJb2sgPSAxOwotCQkJYnJlYWs7CisJCXdoaWxlICh0aW1lX2JlZm9yZShq
aWZmaWVzLCBzdGFydCszMDAqSFopKSB7CisJCQl1ZGVsYXkoNSk7CS8qIERlbGF5IDUgbWljcm9z
ZWNvbmRzIHRvIGxldCBNb245NjAgZ2V0IGluZm8uICovCisJCQkvKgorCQkJICoJTW9uOTYwIHdp
bGwgc2V0IGRvb3JiZWxsMCBiaXQgd2hlbiBpdCBoYXMgY29tcGxldGVkIHRoZSBjb21tYW5kLgor
CQkJICovCisJCQlpZiAoKHNyY19yZWFkbChkZXYsIE1Vbml0Lk9EUl9SKSA+PiBTUkNfT0RSX1NI
SUZUKSAmIE9VVEJPVU5ERE9PUkJFTExfMCkgeworCQkJCS8qCisJCQkJICoJQ2xlYXIgdGhlIGRv
b3JiZWxsLgorCQkJCSAqLworCQkJCXNyY193cml0ZWwoZGV2LCBNVW5pdC5PRFJfQywgT1VUQk9V
TkRET09SQkVMTF8wIDw8IFNSQ19PRFJfU0hJRlQpOworCQkJCW9rID0gMTsKKwkJCQlicmVhazsK
KwkJCX0KKwkJCS8qCisJCQkgKglZaWVsZCB0aGUgcHJvY2Vzc29yIGluIGNhc2Ugd2UgYXJlIHNs
b3cKKwkJCSAqLworCQkJbXNsZWVwKDEpOworCQl9CisJCWlmICh1bmxpa2VseShvayAhPSAxKSkg
eworCQkJLyoKKwkJCSAqCVJlc3RvcmUgaW50ZXJydXB0IG1hc2sgZXZlbiB0aG91Z2ggd2UgdGlt
ZWQgb3V0CisJCQkgKi8KKwkJCWFhY19hZGFwdGVyX2VuYWJsZV9pbnQoZGV2KTsKKwkJCXJldHVy
biAtRVRJTUVET1VUOwogCQl9CisJCS8qCisJCSAqCVB1bGwgdGhlIHN5bmNoIHN0YXR1cyBmcm9t
IE1haWxib3ggMC4KKwkJICovCisJCWlmIChzdGF0dXMpCisJCQkqc3RhdHVzID0gcmVhZGwoJmRl
di0+SW5kZXhSZWdzLT5NYWlsYm94WzBdKTsKKwkJaWYgKHIxKQorCQkJKnIxID0gcmVhZGwoJmRl
di0+SW5kZXhSZWdzLT5NYWlsYm94WzFdKTsKKwkJaWYgKHIyKQorCQkJKnIyID0gcmVhZGwoJmRl
di0+SW5kZXhSZWdzLT5NYWlsYm94WzJdKTsKKwkJaWYgKHIzKQorCQkJKnIzID0gcmVhZGwoJmRl
di0+SW5kZXhSZWdzLT5NYWlsYm94WzNdKTsKKwkJaWYgKHI0KQorCQkJKnI0ID0gcmVhZGwoJmRl
di0+SW5kZXhSZWdzLT5NYWlsYm94WzRdKTsKIAotCQkgLyogWWllbGQgdGhlIHByb2Nlc3NvciBp
biBjYXNlIHdlIGFyZSBzbG93ICovCi0JCW1zbGVlcCgxKTsKKwkJLyoKKwkJICoJQ2xlYXIgdGhl
IHN5bmNoIGNvbW1hbmQgZG9vcmJlbGwuCisJCSAqLworCQlzcmNfd3JpdGVsKGRldiwgTVVuaXQu
T0RSX0MsIE9VVEJPVU5ERE9PUkJFTExfMCA8PCBTUkNfT0RSX1NISUZUKTsKIAl9Ci0JaWYgKHVu
bGlrZWx5KG9rICE9IDEpKSB7Ci0JCSAvKiBSZXN0b3JlIGludGVycnVwdCBtYXNrIGV2ZW4gdGhv
dWdoIHdlIHRpbWVkIG91dCAqLwotCQlhYWNfYWRhcHRlcl9lbmFibGVfaW50KGRldik7Ci0JCXJl
dHVybiAtRVRJTUVET1VUOwotCX0KLQotCSAvKiBQdWxsIHRoZSBzeW5jaCBzdGF0dXMgZnJvbSBN
YWlsYm94IDAgKi8KLQlpZiAoc3RhdHVzKQotCQkqc3RhdHVzID0gcmVhZGwoJmRldi0+SW5kZXhS
ZWdzLT5NYWlsYm94WzBdKTsKLQlpZiAocjEpCi0JCSpyMSA9IHJlYWRsKCZkZXYtPkluZGV4UmVn
cy0+TWFpbGJveFsxXSk7Ci0JaWYgKHIyKQotCQkqcjIgPSByZWFkbCgmZGV2LT5JbmRleFJlZ3Mt
Pk1haWxib3hbMl0pOwotCWlmIChyMykKLQkJKnIzID0gcmVhZGwoJmRldi0+SW5kZXhSZWdzLT5N
YWlsYm94WzNdKTsKLQlpZiAocjQpCi0JCSpyNCA9IHJlYWRsKCZkZXYtPkluZGV4UmVncy0+TWFp
bGJveFs0XSk7Ci0KLQkgLyogQ2xlYXIgdGhlIHN5bmNoIGNvbW1hbmQgZG9vcmJlbGwgKi8KLQlz
cmNfd3JpdGVsKGRldiwgTVVuaXQuT0RSX0MsIE9VVEJPVU5ERE9PUkJFTExfMCA8PCBTUkNfT0RS
X1NISUZUKTsKIAotCSAvKiBSZXN0b3JlIGludGVycnVwdCBtYXNrICovCisJLyoKKwkgKglSZXN0
b3JlIGludGVycnVwdCBtYXNrCisJICovCiAJYWFjX2FkYXB0ZXJfZW5hYmxlX2ludChkZXYpOwog
CXJldHVybiAwOwotCiB9CiAKIC8qKgpAQCAtMzg2LDkgKzQyNSw3IEBAIHN0YXRpYyBpbnQgYWFj
X3NyY19pb3JlbWFwKHN0cnVjdCBhYWNfZGUKIHsKIAlpZiAoIXNpemUpIHsKIAkJaW91bm1hcChk
ZXYtPnJlZ3Muc3JjLmJhcjApOwotCQlkZXYtPnJlZ3Muc3JjLmJhcjAgPSBOVUxMOwotCQlpb3Vu
bWFwKGRldi0+YmFzZSk7Ci0JCWRldi0+YmFzZSA9IE5VTEw7CisJCWRldi0+YmFzZSA9IGRldi0+
cmVncy5zcmMuYmFyMCA9IE5VTEw7CiAJCXJldHVybiAwOwogCX0KIAlkZXYtPnJlZ3Muc3JjLmJh
cjEgPSBpb3JlbWFwKHBjaV9yZXNvdXJjZV9zdGFydChkZXYtPnBkZXYsIDIpLApAQCAtNDA0LDcg
KzQ0MSwyNyBAQCBzdGF0aWMgaW50IGFhY19zcmNfaW9yZW1hcChzdHJ1Y3QgYWFjX2RlCiAJCXJl
dHVybiAtMTsKIAl9CiAJZGV2LT5JbmRleFJlZ3MgPSAmKChzdHJ1Y3Qgc3JjX3JlZ2lzdGVycyBf
X2lvbWVtICopCi0JCWRldi0+YmFzZSktPkluZGV4UmVnczsKKwkJZGV2LT5iYXNlKS0+dS50dXBl
bG8uSW5kZXhSZWdzOworCXJldHVybiAwOworfQorCisvKioKKyAqICBhYWNfc3Jjdl9pb3JlbWFw
CisgKglAc2l6ZTogbWFwcGluZyByZXNpemUgcmVxdWVzdAorICoKKyAqLworc3RhdGljIGludCBh
YWNfc3Jjdl9pb3JlbWFwKHN0cnVjdCBhYWNfZGV2ICpkZXYsIHUzMiBzaXplKQoreworCWlmICgh
c2l6ZSkgeworCQlpb3VubWFwKGRldi0+cmVncy5zcmMuYmFyMCk7CisJCWRldi0+YmFzZSA9IGRl
di0+cmVncy5zcmMuYmFyMCA9IE5VTEw7CisJCXJldHVybiAwOworCX0KKwlkZXYtPmJhc2UgPSBk
ZXYtPnJlZ3Muc3JjLmJhcjAgPSBpb3JlbWFwKGRldi0+c2NzaV9ob3N0X3B0ci0+YmFzZSwgc2l6
ZSk7CisJaWYgKGRldi0+YmFzZSA9PSBOVUxMKQorCQlyZXR1cm4gLTE7CisJZGV2LT5JbmRleFJl
Z3MgPSAmKChzdHJ1Y3Qgc3JjX3JlZ2lzdGVycyBfX2lvbWVtICopCisJCWRldi0+YmFzZSktPnUu
ZGVuYWxpLkluZGV4UmVnczsKIAlyZXR1cm4gMDsKIH0KIApAQCAtNDE5LDcgKzQ3Niw3IEBAIHN0
YXRpYyBpbnQgYWFjX3NyY19yZXN0YXJ0X2FkYXB0ZXIoc3RydWMKIAkJYmxlZCA9IGFhY19hZGFw
dGVyX3N5bmNfY21kKGRldiwgSU9QX1JFU0VUX0FMV0FZUywKIAkJCTAsIDAsIDAsIDAsIDAsIDAs
ICZ2YXIsICZyZXNldF9tYXNrLCBOVUxMLCBOVUxMLCBOVUxMKTsKIAkJCWlmIChibGVkIHx8ICh2
YXIgIT0gMHgwMDAwMDAwMSkpCi0JCQkJYmxlZCA9IC1FSU5WQUw7CisJCQkJcmV0dXJuIC1FSU5W
QUw7CiAJCWlmIChkZXYtPnN1cHBsZW1lbnRfYWRhcHRlcl9pbmZvLlN1cHBvcnRlZE9wdGlvbnMy
ICYKIAkJCUFBQ19PUFRJT05fRE9PUkJFTExfUkVTRVQpIHsKIAkJCXNyY193cml0ZWwoZGV2LCBN
VW5pdC5JRFIsIHJlc2V0X21hc2spOwpAQCAtNTc5LDE1ICs2MzYsMTQ5IEBAIGludCBhYWNfc3Jj
X2luaXQoc3RydWN0IGFhY19kZXYgKmRldikKIAlkZXYtPmRiZ19zaXplID0gQUFDX01JTl9TUkNf
QkFSMV9TSVpFOwogCiAJYWFjX2FkYXB0ZXJfZW5hYmxlX2ludChkZXYpOworCisJaWYgKCFkZXYt
PnN5bmNfbW9kZSkgeworCQkvKgorCQkgKiBUZWxsIHRoZSBhZGFwdGVyIHRoYXQgYWxsIGlzIGNv
bmZpZ3VyZWQsIGFuZCBpdCBjYW4KKwkJICogc3RhcnQgYWNjZXB0aW5nIHJlcXVlc3RzCisJCSAq
LworCQlhYWNfc3JjX3N0YXJ0X2FkYXB0ZXIoZGV2KTsKKwl9CisJcmV0dXJuIDA7CisKK2Vycm9y
X2lvdW5tYXA6CisKKwlyZXR1cm4gLTE7Cit9CisKKy8qKgorICogIGFhY19zcmN2X2luaXQJLQlp
bml0aWFsaXplIGFuIFNSQ3YgY2FyZAorICogIEBkZXY6IGRldmljZSB0byBjb25maWd1cmUKKyAq
CisgKi8KKworaW50IGFhY19zcmN2X2luaXQoc3RydWN0IGFhY19kZXYgKmRldikKK3sKKwl1bnNp
Z25lZCBsb25nIHN0YXJ0OworCXVuc2lnbmVkIGxvbmcgc3RhdHVzOworCWludCByZXN0YXJ0ID0g
MDsKKwlpbnQgaW5zdGFuY2UgPSBkZXYtPmlkOworCWNvbnN0IGNoYXIgKm5hbWUgPSBkZXYtPm5h
bWU7CisKKwlkZXYtPmFfb3BzLmFkYXB0ZXJfaW9yZW1hcCA9IGFhY19zcmN2X2lvcmVtYXA7CisJ
ZGV2LT5hX29wcy5hZGFwdGVyX2NvbW0gPSBhYWNfc3JjX3NlbGVjdF9jb21tOworCisJZGV2LT5i
YXNlX3NpemUgPSBBQUNfTUlOX1NSQ1ZfQkFSMF9TSVpFOworCWlmIChhYWNfYWRhcHRlcl9pb3Jl
bWFwKGRldiwgZGV2LT5iYXNlX3NpemUpKSB7CisJCXByaW50ayhLRVJOX1dBUk5JTkcgIiVzOiB1
bmFibGUgdG8gbWFwIGFkYXB0ZXIuXG4iLCBuYW1lKTsKKwkJZ290byBlcnJvcl9pb3VubWFwOwor
CX0KKworCS8qIEZhaWx1cmUgdG8gcmVzZXQgaGVyZSBpcyBhbiBvcHRpb24gLi4uICovCisJZGV2
LT5hX29wcy5hZGFwdGVyX3N5bmNfY21kID0gc3JjX3N5bmNfY21kOworCWRldi0+YV9vcHMuYWRh
cHRlcl9lbmFibGVfaW50ID0gYWFjX3NyY19kaXNhYmxlX2ludGVycnVwdDsKKwlpZiAoKGFhY19y
ZXNldF9kZXZpY2VzIHx8IHJlc2V0X2RldmljZXMpICYmCisJCSFhYWNfc3JjX3Jlc3RhcnRfYWRh
cHRlcihkZXYsIDApKQorCQkrK3Jlc3RhcnQ7CisJLyoKKwkgKglDaGVjayB0byBzZWUgaWYgdGhl
IGJvYXJkIHBhbmljJ2Qgd2hpbGUgYm9vdGluZy4KKwkgKi8KKwlzdGF0dXMgPSBzcmNfcmVhZGwo
ZGV2LCBNVW5pdC5PTVIpOworCWlmIChzdGF0dXMgJiBLRVJORUxfUEFOSUMpIHsKKwkJaWYgKGFh
Y19zcmNfcmVzdGFydF9hZGFwdGVyKGRldiwgYWFjX3NyY19jaGVja19oZWFsdGgoZGV2KSkpCisJ
CQlnb3RvIGVycm9yX2lvdW5tYXA7CisJCSsrcmVzdGFydDsKKwl9CiAJLyoKLQkgKglUZWxsIHRo
ZSBhZGFwdGVyIHRoYXQgYWxsIGlzIGNvbmZpZ3VyZWQsIGFuZCBpdCBjYW4KLQkgKiBzdGFydCBh
Y2NlcHRpbmcgcmVxdWVzdHMKKwkgKglDaGVjayB0byBzZWUgaWYgdGhlIGJvYXJkIGZhaWxlZCBh
bnkgc2VsZiB0ZXN0cy4KKwkgKi8KKwlzdGF0dXMgPSBzcmNfcmVhZGwoZGV2LCBNVW5pdC5PTVIp
OworCWlmIChzdGF0dXMgJiBTRUxGX1RFU1RfRkFJTEVEKSB7CisJCXByaW50ayhLRVJOX0VSUiAi
JXMlZDogYWRhcHRlciBzZWxmLXRlc3QgZmFpbGVkLlxuIiwgZGV2LT5uYW1lLCBpbnN0YW5jZSk7
CisJCWdvdG8gZXJyb3JfaW91bm1hcDsKKwl9CisJLyoKKwkgKglDaGVjayB0byBzZWUgaWYgdGhl
IG1vbml0b3IgcGFuaWMnZCB3aGlsZSBib290aW5nLgorCSAqLworCWlmIChzdGF0dXMgJiBNT05J
VE9SX1BBTklDKSB7CisJCXByaW50ayhLRVJOX0VSUiAiJXMlZDogYWRhcHRlciBtb25pdG9yIHBh
bmljLlxuIiwgZGV2LT5uYW1lLCBpbnN0YW5jZSk7CisJCWdvdG8gZXJyb3JfaW91bm1hcDsKKwl9
CisJc3RhcnQgPSBqaWZmaWVzOworCS8qCisJICoJV2FpdCBmb3IgdGhlIGFkYXB0ZXIgdG8gYmUg
dXAgYW5kIHJ1bm5pbmcuIFdhaXQgdXAgdG8gMyBtaW51dGVzCiAJICovCi0JYWFjX3NyY19zdGFy
dF9hZGFwdGVyKGRldik7CisJd2hpbGUgKCEoKHN0YXR1cyA9IHNyY19yZWFkbChkZXYsIE1Vbml0
Lk9NUikpICYgS0VSTkVMX1VQX0FORF9SVU5OSU5HKSkgeworCQlpZiAoKHJlc3RhcnQgJiYKKwkJ
ICAoc3RhdHVzICYgKEtFUk5FTF9QQU5JQ3xTRUxGX1RFU1RfRkFJTEVEfE1PTklUT1JfUEFOSUMp
KSkgfHwKKwkJICB0aW1lX2FmdGVyKGppZmZpZXMsIHN0YXJ0K0haKnN0YXJ0dXBfdGltZW91dCkp
IHsKKwkJCXByaW50ayhLRVJOX0VSUiAiJXMlZDogYWRhcHRlciBrZXJuZWwgZmFpbGVkIHRvIHN0
YXJ0LCBpbml0IHN0YXR1cyA9ICVseC5cbiIsCisJCQkJCWRldi0+bmFtZSwgaW5zdGFuY2UsIHN0
YXR1cyk7CisJCQlnb3RvIGVycm9yX2lvdW5tYXA7CisJCX0KKwkJaWYgKCFyZXN0YXJ0ICYmCisJ
CSAgKChzdGF0dXMgJiAoS0VSTkVMX1BBTklDfFNFTEZfVEVTVF9GQUlMRUR8TU9OSVRPUl9QQU5J
QykpIHx8CisJCSAgdGltZV9hZnRlcihqaWZmaWVzLCBzdGFydCArIEhaICoKKwkJICAoKHN0YXJ0
dXBfdGltZW91dCA+IDYwKQorCQkgICAgPyAoc3RhcnR1cF90aW1lb3V0IC0gNjApCisJCSAgICA6
IChzdGFydHVwX3RpbWVvdXQgLyAyKSkpKSkgeworCQkJaWYgKGxpa2VseSghYWFjX3NyY19yZXN0
YXJ0X2FkYXB0ZXIoZGV2LCBhYWNfc3JjX2NoZWNrX2hlYWx0aChkZXYpKSkpCisJCQkJc3RhcnQg
PSBqaWZmaWVzOworCQkJKytyZXN0YXJ0OworCQl9CisJCW1zbGVlcCgxKTsKKwl9CisJaWYgKHJl
c3RhcnQgJiYgYWFjX2NvbW1pdCkKKwkJYWFjX2NvbW1pdCA9IDE7CisJLyoKKwkgKglGaWxsIGlu
IHRoZSBjb21tb24gZnVuY3Rpb24gZGlzcGF0Y2ggdGFibGUuCisJICovCisJZGV2LT5hX29wcy5h
ZGFwdGVyX2ludGVycnVwdCA9IGFhY19zcmNfaW50ZXJydXB0X2FkYXB0ZXI7CisJZGV2LT5hX29w
cy5hZGFwdGVyX2Rpc2FibGVfaW50ID0gYWFjX3NyY19kaXNhYmxlX2ludGVycnVwdDsKKwlkZXYt
PmFfb3BzLmFkYXB0ZXJfbm90aWZ5ID0gYWFjX3NyY19ub3RpZnlfYWRhcHRlcjsKKwlkZXYtPmFf
b3BzLmFkYXB0ZXJfc3luY19jbWQgPSBzcmNfc3luY19jbWQ7CisJZGV2LT5hX29wcy5hZGFwdGVy
X2NoZWNrX2hlYWx0aCA9IGFhY19zcmNfY2hlY2tfaGVhbHRoOworCWRldi0+YV9vcHMuYWRhcHRl
cl9yZXN0YXJ0ID0gYWFjX3NyY19yZXN0YXJ0X2FkYXB0ZXI7CisKKwkvKgorCSAqCUZpcnN0IGNs
ZWFyIG91dCBhbGwgaW50ZXJydXB0cy4gIFRoZW4gZW5hYmxlIHRoZSBvbmUncyB0aGF0IHdlCisJ
ICoJY2FuIGhhbmRsZS4KKwkgKi8KKwlhYWNfYWRhcHRlcl9jb21tKGRldiwgQUFDX0NPTU1fTUVT
U0FHRSk7CisJYWFjX2FkYXB0ZXJfZGlzYWJsZV9pbnQoZGV2KTsKKwlzcmNfd3JpdGVsKGRldiwg
TVVuaXQuT0RSX0MsIDB4ZmZmZmZmZmYpOworCWFhY19hZGFwdGVyX2VuYWJsZV9pbnQoZGV2KTsK
IAorCWlmIChhYWNfaW5pdF9hZGFwdGVyKGRldikgPT0gTlVMTCkKKwkJZ290byBlcnJvcl9pb3Vu
bWFwOworCWlmIChkZXYtPmNvbW1faW50ZXJmYWNlICE9IEFBQ19DT01NX01FU1NBR0VfVFlQRTEp
CisJCWdvdG8gZXJyb3JfaW91bm1hcDsKKwlkZXYtPm1zaSA9IGFhY19tc2kgJiYgIXBjaV9lbmFi
bGVfbXNpKGRldi0+cGRldik7CisJaWYgKHJlcXVlc3RfaXJxKGRldi0+cGRldi0+aXJxLCBkZXYt
PmFfb3BzLmFkYXB0ZXJfaW50ciwKKwkJSVJRRl9TSEFSRUR8SVJRRl9ESVNBQkxFRCwgImFhY3Jh
aWQiLCBkZXYpIDwgMCkgeworCQlpZiAoZGV2LT5tc2kpCisJCQlwY2lfZGlzYWJsZV9tc2koZGV2
LT5wZGV2KTsKKwkJcHJpbnRrKEtFUk5fRVJSICIlcyVkOiBJbnRlcnJ1cHQgdW5hdmFpbGFibGUu
XG4iLAorCQkJbmFtZSwgaW5zdGFuY2UpOworCQlnb3RvIGVycm9yX2lvdW5tYXA7CisJfQorCWRl
di0+ZGJnX2Jhc2UgPSBkZXYtPnNjc2lfaG9zdF9wdHItPmJhc2U7CisJZGV2LT5kYmdfYmFzZV9t
YXBwZWQgPSBkZXYtPmJhc2U7CisJZGV2LT5kYmdfc2l6ZSA9IGRldi0+YmFzZV9zaXplOworCisJ
YWFjX2FkYXB0ZXJfZW5hYmxlX2ludChkZXYpOworCisJaWYgKCFkZXYtPnN5bmNfbW9kZSkgewor
CQkvKgorCQkgKiBUZWxsIHRoZSBhZGFwdGVyIHRoYXQgYWxsIGlzIGNvbmZpZ3VyZWQsIGFuZCBp
dCBjYW4KKwkJICogc3RhcnQgYWNjZXB0aW5nIHJlcXVlc3RzCisJCSAqLworCQlhYWNfc3JjX3N0
YXJ0X2FkYXB0ZXIoZGV2KTsKKwl9CiAJcmV0dXJuIDA7CiAKIGVycm9yX2lvdW5tYXA6CiAKIAly
ZXR1cm4gLTE7CiB9CisK

------_=_NextPart_001_01CCE702.EF636E86--
