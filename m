From: "Mahesh Rajashekhara" <Mahesh_Rajashekhara@pmc-sierra.com>
Subject: RE: [PATCH 1/1] aacraid: Added Sync.mode to support series 7/8/9 controllers
Date: Fri, 10 Feb 2012 04:18:54 -0800
Message-ID: <340C71CD25A7EB49BFA81AE8C839266717894EEC@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <340C71CD25A7EB49BFA81AE8C83926671782D025@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <F80D634A-1476-45DE-9ACC-2C3B856B53D3@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:44419 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727Ab2BJMS6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 07:18:58 -0500
Content-class: urn:content-classes:message
In-Reply-To: <F80D634A-1476-45DE-9ACC-2C3B856B53D3@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, Achim Leubner <Achim_Leubner@pmc-sierra.com>, Tony Ruiz <Tony_Ruiz@pmc-sierra.com>

Hello Mark,

Thanks for your review comments.

- There are no more AAC_OPT_NEW_COMM bits available, how will the
feature-bits be expanded in the future? (e.g., what about series 10...)

[PMC]>>> Yes, there is no space for more new comm types; we now have
defined AAC_OPT_NEW_COMM_TYPE1... _TYPE4 for Tupelo, Denali, Series 8
and Series 9 controllers.
But for all these subtypes AAC_OPT_NEW_COMM is also set. For future
products (>= Series 10) we can define a new flag (i.e.
AAC_OPT_NEW_COMM2) and then we can start again with the subtype
definitions (i.e. AAC_OPT_NEW_COMM2_TYPE1 etc.)

- Is there a schedule or a plan as to when asynchronous (performance)
mode will be made available for these new adapters? (I assume that the
changes to src.c module are complicated/risky at this moment of time or
are blocked behind quality assurance testing)

[PMC]>>> The plan is to submit asynchronous for Series 7 in late
June/early July after it has completed Alpha testing and started Beta
testing.  The asynchronous mode are still changing thus they have not
solidify and will need to go thru months of testing before submitting.

- Why was the startup period for the firmware increased from 30 seconds
to 5 minutes, is there reasoning as to why it is taking longer? (I
assume more targets to start up, more array metadata to collect)

[PMC]>>> The timeout value for the Sync. Commands (30 seconds) are too
short for a max configuration with a lot of drives (Yes, more targets to
start up, more array metadata to collect). Hence, we increased timeout
from 30 seconds to 5 minutes.

Thanks,
Mahesh


-----Original Message-----
From: Mark Salyzyn [mailto:mark_salyzyn@xyratex.com] 
Sent: Thursday, February 09, 2012 9:35 PM
To: Mahesh Rajashekhara
Cc: Mark Salyzyn; James.Bottomley@HansenPartnership.com;
linux-scsi@vger.kernel.org; aacraid@pmc-sierra.com; Achim Leubner; Tony
Ruiz
Subject: Re: [PATCH 1/1] aacraid: Added Sync.mode to support series
7/8/9 controllers

I ACK this patch. Except for the sync_mode bit initialization and the
lengthening of the startup timeout (which can not be considered bad),
this patch appears orthogonal to legacy adapters, this is a good sign,
only affects the new adapters. I understand the need to get the driver
out early for propagation to the distributions for those that need to
boot/install to the adapters.

But do have a few questions that can be answered outside the scope of
the code review, only because I am curious and others may wish to see
the answers.

- There are no more AAC_OPT_NEW_COMM bits available, how will the
feature-bits be expanded in the future? (e.g., what about series 10...)
- Is there a schedule or a plan as to when asynchronous (performance)
mode will be made available for these new adapters? (I assume that the
changes to src.c module are complicated/risky at this moment of time or
are blocked behind quality assurance testing)
- Why was the startup period for the firmware increased from 30 seconds
to 5 minutes, is there a reasoning as to why it is taking longer? (I
assume more targets to start up, more array metadata to collect)

Sincerely -- Mark Salyzyn

On Feb 9, 2012, at 3:15 AM, Mahesh Rajashekhara wrote:

> *Resending earlier sent email bounce back*
> 
> Hi James,
> 
> Patch description:
> - Added Sync. mode to support Series 7/8/9 controller families: 
>  This is a compatibility mode for all these controller families. The
> Async. (Performance) mode can be changed in the future.
> - First Async. mode version added for Series 7
> - Controller parameter aac_sync_mode added
> 
> This attached patch is against current upstream kernel
> 
> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
> handling of patch attachments (inline gets damaged, please use
> attachment).
> 
> Signed-off-by: Mahesh Rajashekhara <aacraid@pmc-sierra.com>
> 
> ---
> 
> drivers/scsi/aacraid/aachba.c   |    4 
> drivers/scsi/aacraid/aacraid.h  |   27 +++
> drivers/scsi/aacraid/comminit.c |   21 ++
> drivers/scsi/aacraid/commsup.c  |   26 +++
> drivers/scsi/aacraid/linit.c    |   28 +++
> drivers/scsi/aacraid/rx.c       |    1 
> drivers/scsi/aacraid/sa.c       |    1 
> drivers/scsi/aacraid/src.c      |  291
> +++++++++++++++++++++++++++++++++-------
> 8 files changed, 337 insertions(+), 62 deletions(-)
> 
> diff -purN a/drivers/scsi/aacraid/aachba.c
> b/drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c	2012-02-06 16:47:59.000000000
> +0530
> +++ b/drivers/scsi/aacraid/aachba.c	2012-02-06 16:48:09.000000000
> +0530
> @@ -151,7 +151,11 @@ int aac_msi;
> int aac_commit = -1;
> int startup_timeout = 180;
> int aif_timeout = 120;
> +int aac_sync_mode;  /* Only Sync. transfer - disabled */
> 
> +module_param(aac_sync_mode, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(aac_sync_mode, "Force sync. transfer mode"
> +	" 0=off, 1=on");
> module_param(nondasd, int, S_IRUGO|S_IWUSR);
> MODULE_PARM_DESC(nondasd, "Control scanning of hba for nondasd
> devices."
> 	" 0=off, 1=on");
> diff -purN a/drivers/scsi/aacraid/aacraid.h
> b/drivers/scsi/aacraid/aacraid.h
> --- a/drivers/scsi/aacraid/aacraid.h	2012-02-06 16:47:59.000000000
> +0530
> +++ b/drivers/scsi/aacraid/aacraid.h	2012-02-07 13:50:03.000000000
> +0530
> @@ -12,7 +12,7 @@
> 
>
*-----------------------------------------------------------------------
> -----*/
> 
> #ifndef AAC_DRIVER_BUILD
> -# define AAC_DRIVER_BUILD 28000
> +# define AAC_DRIVER_BUILD 28900
> # define AAC_DRIVER_BRANCH "-ms"
> #endif
> #define MAXIMUM_NUM_CONTAINERS	32
> @@ -756,8 +756,16 @@ struct src_mu_registers {
> 
> struct src_registers {
> 	struct src_mu_registers MUnit;	/* 00h - c7h */
> -	__le32 reserved1[130790];	/* c8h - 7fc5fh */
> -	struct src_inbound IndexRegs;	/* 7fc60h */
> +	union {
> +		struct {
> +			__le32 reserved1[130790];	/* c8h - 7fc5fh
> */
> +			struct src_inbound IndexRegs;	/* 7fc60h */
> +		} tupelo;
> +		struct {
> +			__le32 reserved1[974];		/* c8h - fffh */
> +			struct src_inbound IndexRegs;	/* 1000h */
> +		} denali;
> +	} u;
> };
> 
> #define src_readb(AEP, CSR)
> readb(&((AEP)->regs.src.bar0->CSR))
> @@ -999,6 +1007,10 @@ struct aac_bus_info_response {
> #define AAC_OPT_NEW_COMM		cpu_to_le32(1<<17)
> #define AAC_OPT_NEW_COMM_64		cpu_to_le32(1<<18)
> #define AAC_OPT_NEW_COMM_TYPE1		cpu_to_le32(1<<28)
> +#define AAC_OPT_NEW_COMM_TYPE2		cpu_to_le32(1<<29)
> +#define AAC_OPT_NEW_COMM_TYPE3		cpu_to_le32(1<<30)
> +#define AAC_OPT_NEW_COMM_TYPE4		cpu_to_le32(1<<31)
> +
> 
> struct aac_dev
> {
> @@ -1076,6 +1088,8 @@ struct aac_dev
> #	define AAC_MIN_FOOTPRINT_SIZE 8192
> #	define AAC_MIN_SRC_BAR0_SIZE 0x400000
> #	define AAC_MIN_SRC_BAR1_SIZE 0x800
> +#	define AAC_MIN_SRCV_BAR0_SIZE 0x100000
> +#	define AAC_MIN_SRCV_BAR1_SIZE 0x400
> #endif
> 	union
> 	{
> @@ -1116,7 +1130,10 @@ struct aac_dev
> 	u8			msi;
> 	int			management_fib_count;
> 	spinlock_t		manage_lock;
> -
> +	spinlock_t		sync_lock;
> +	int			sync_mode;
> +	struct fib		*sync_fib;
> +	struct list_head	sync_fib_list;
> };
> 
> #define aac_adapter_interrupt(dev) \
> @@ -1163,6 +1180,7 @@ struct aac_dev
> 
> #define FIB_CONTEXT_FLAG_TIMED_OUT		(0x00000001)
> #define FIB_CONTEXT_FLAG			(0x00000002)
> +#define FIB_CONTEXT_FLAG_WAIT			(0x00000004)
> 
> /*
>  *	Define the command values
> @@ -1970,6 +1988,7 @@ int aac_rkt_init(struct aac_dev *dev);
> int aac_nark_init(struct aac_dev *dev);
> int aac_sa_init(struct aac_dev *dev);
> int aac_src_init(struct aac_dev *dev);
> +int aac_srcv_init(struct aac_dev *dev);
> int aac_queue_get(struct aac_dev * dev, u32 * index, u32 qid, struct
> hw_fib * hw_fib, int wait, struct fib * fibptr, unsigned long
> *nonotify);
> unsigned int aac_response_normal(struct aac_queue * q);
> unsigned int aac_command_normal(struct aac_queue * q);
> diff -purN a/drivers/scsi/aacraid/comminit.c
> b/drivers/scsi/aacraid/comminit.c
> --- a/drivers/scsi/aacraid/comminit.c	2012-02-06 16:47:59.000000000
> +0530
> +++ b/drivers/scsi/aacraid/comminit.c	2012-02-06 16:50:55.000000000
> +0530
> @@ -325,12 +325,14 @@ struct aac_dev *aac_init_adapter(struct 
> {
> 	u32 status[5];
> 	struct Scsi_Host * host = dev->scsi_host_ptr;
> +	extern int aac_sync_mode;
> 
> 	/*
> 	 *	Check the preferred comm settings, defaults from
> template.
> 	 */
> 	dev->management_fib_count = 0;
> 	spin_lock_init(&dev->manage_lock);
> +	spin_lock_init(&dev->sync_lock);
> 	dev->max_fib_size = sizeof(struct hw_fib);
> 	dev->sg_tablesize = host->sg_tablesize = (dev->max_fib_size
> 		- sizeof(struct aac_fibhdr)
> @@ -344,13 +346,21 @@ struct aac_dev *aac_init_adapter(struct 
> 	 		(status[0] == 0x00000001)) {
> 		if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_64))
> 			dev->raw_io_64 = 1;
> -		if (dev->a_ops.adapter_comm) {
> -			if (status[1] &
> le32_to_cpu(AAC_OPT_NEW_COMM_TYPE1)) {
> -				dev->comm_interface =
> AAC_COMM_MESSAGE_TYPE1;
> -				dev->raw_io_interface = 1;
> -			} else if (status[1] &
> le32_to_cpu(AAC_OPT_NEW_COMM)) {
> +		dev->sync_mode = aac_sync_mode;
> +		if (dev->a_ops.adapter_comm &&
> +			(status[1] & le32_to_cpu(AAC_OPT_NEW_COMM))) {
> 				dev->comm_interface = AAC_COMM_MESSAGE;
> 				dev->raw_io_interface = 1;
> +			if ((status[1] &
> le32_to_cpu(AAC_OPT_NEW_COMM_TYPE1))) {
> +				/* driver supports TYPE1 (Tupelo) */
> +				dev->comm_interface =
> AAC_COMM_MESSAGE_TYPE1;
> +			} else if ((status[1] &
> le32_to_cpu(AAC_OPT_NEW_COMM_TYPE4)) ||
> +				  (status[1] &
> le32_to_cpu(AAC_OPT_NEW_COMM_TYPE3)) ||
> +				  (status[1] &
> le32_to_cpu(AAC_OPT_NEW_COMM_TYPE2))) {
> +					/* driver doesn't support TYPE2
> (Series7), TYPE3 and TYPE4 */
> +					/* switch to sync. mode */
> +					dev->comm_interface =
> AAC_COMM_MESSAGE_TYPE1;
> +					dev->sync_mode = 1;
> 			}
> 		}
> 		if ((dev->comm_interface == AAC_COMM_MESSAGE) &&
> @@ -455,6 +465,7 @@ struct aac_dev *aac_init_adapter(struct 
> 	}
> 		
> 	INIT_LIST_HEAD(&dev->fib_list);
> +	INIT_LIST_HEAD(&dev->sync_fib_list);
> 
> 	return dev;
> }
> diff -purN a/drivers/scsi/aacraid/commsup.c
> b/drivers/scsi/aacraid/commsup.c
> --- a/drivers/scsi/aacraid/commsup.c	2012-02-06 16:47:59.000000000
> +0530
> +++ b/drivers/scsi/aacraid/commsup.c	2012-02-06 16:56:09.000000000
> +0530
> @@ -416,6 +416,7 @@ int aac_fib_send(u16 command, struct fib
> 	unsigned long flags = 0;
> 	unsigned long qflags;
> 	unsigned long mflags = 0;
> +	unsigned long sflags = 0;
> 
> 
> 	if (!(hw_fib->header.XferState & cpu_to_le32(HostOwned)))
> @@ -512,6 +513,31 @@ int aac_fib_send(u16 command, struct fib
> 		spin_lock_irqsave(&fibptr->event_lock, flags);
> 	}
> 
> +	if (dev->sync_mode) {
> +		if (wait)
> +			spin_unlock_irqrestore(&fibptr->event_lock,
> flags);
> +		spin_lock_irqsave(&dev->sync_lock, sflags);
> +		if (dev->sync_fib) {
> +			list_add_tail(&fibptr->fiblink,
> &dev->sync_fib_list);
> +			spin_unlock_irqrestore(&dev->sync_lock, sflags);
> +		} else {
> +			dev->sync_fib = fibptr;
> +			spin_unlock_irqrestore(&dev->sync_lock, sflags);
> +			aac_adapter_sync_cmd(dev, SEND_SYNCHRONOUS_FIB,
> +				(u32)fibptr->hw_fib_pa, 0, 0, 0, 0, 0,
> +				NULL, NULL, NULL, NULL, NULL);
> +		}
> +		if (wait) {
> +			fibptr->flags |= FIB_CONTEXT_FLAG_WAIT;
> +			if (down_interruptible(&fibptr->event_wait)) {
> +				fibptr->flags &= ~FIB_CONTEXT_FLAG_WAIT;
> +				return -EFAULT;
> +			}
> +			return 0;
> +		}
> +		return -EINPROGRESS;
> +	}
> +
> 	if (aac_adapter_deliver(fibptr) != 0) {
> 		printk(KERN_ERR "aac_fib_send: returned -EBUSY\n");
> 		if (wait) {
> diff -purN a/drivers/scsi/aacraid/linit.c
b/drivers/scsi/aacraid/linit.c
> --- a/drivers/scsi/aacraid/linit.c	2012-02-06 16:47:59.000000000
> +0530
> +++ b/drivers/scsi/aacraid/linit.c	2012-02-06 16:48:09.000000000
> +0530
> @@ -56,7 +56,7 @@
> 
> #include "aacraid.h"
> 
> -#define AAC_DRIVER_VERSION		"1.1-7"
> +#define AAC_DRIVER_VERSION		"1.2-0"
> #ifndef AAC_DRIVER_BRANCH
> #define AAC_DRIVER_BRANCH		""
> #endif
> @@ -162,7 +162,10 @@ static const struct pci_device_id aac_pc
> 	{ 0x9005, 0x0285, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 59 }, /* Adaptec
> Catch All */
> 	{ 0x9005, 0x0286, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 60 }, /* Adaptec
> Rocket Catch All */
> 	{ 0x9005, 0x0288, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 61 }, /* Adaptec
> NEMER/ARK Catch All */
> -	{ 0x9005, 0x028b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 62 }, /* Adaptec
> PMC Catch All */
> +	{ 0x9005, 0x028b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 62 }, /* Adaptec
> PMC Series 6 (Tupelo) */
> +	{ 0x9005, 0x028c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 63 }, /* Adaptec
> PMC Series 7 (Denali) */
> +	{ 0x9005, 0x028d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 64 }, /* Adaptec
> PMC Series 8 */
> +	{ 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /* Adaptec
> PMC Series 9 */
> 	{ 0,}
> };
> MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
> @@ -238,7 +241,10 @@ static struct aac_driver_ident aac_drive
> 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2 },
> /* Adaptec Catch All */
> 	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 },
> /* Adaptec Rocket Catch All */
> 	{ aac_nark_init, "aacraid", "ADAPTEC ", "RAID           ", 2 },
> /* Adaptec NEMER/ARK Catch All */
> -	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }
> /* Adaptec PMC Catch All */
> +	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2 },
> /* Adaptec PMC Series 6 (Tupelo) */
> +	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 },
> /* Adaptec PMC Series 7 (Denali) */
> +	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 },
> /* Adaptec PMC Series 8 */
> +	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }
> /* Adaptec PMC Series 9 */
> };
> 
> /**
> @@ -1102,6 +1108,7 @@ static int __devinit aac_probe_one(struc
> 	int error = -ENODEV;
> 	int unique_id = 0;
> 	u64 dmamask;
> +	extern int aac_sync_mode;
> 
> 	list_for_each_entry(aac, &aac_devices, entry) {
> 		if (aac->id > unique_id)
> @@ -1162,6 +1169,21 @@ static int __devinit aac_probe_one(struc
> 	if ((*aac_drivers[index].init)(aac))
> 		goto out_unmap;
> 
> +	if (aac->sync_mode) {
> +		if (aac_sync_mode)
> +			printk(KERN_INFO "%s%d: Sync. mode enforced "
> +				"by driver parameter. This will cause "
> +				"a significant performance decrease!\n",
> +				aac->name,
> +				aac->id);
> +		else
> +			printk(KERN_INFO "%s%d: Async. mode not
> supported "
> +				"by current driver, sync. mode
> enforced."
> +				"\nPlease update driver to get full
> performance.\n",
> +				aac->name,
> +				aac->id);
> +	}
> +
> 	/*
> 	 *	Start any kernel threads needed
> 	 */
> diff -purN a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
> --- a/drivers/scsi/aacraid/rx.c	2012-02-06 16:47:59.000000000
+0530
> +++ b/drivers/scsi/aacraid/rx.c	2012-02-06 16:48:09.000000000
+0530
> @@ -643,6 +643,7 @@ int _aac_rx_init(struct aac_dev *dev)
> 	if (aac_init_adapter(dev) == NULL)
> 		goto error_iounmap;
> 	aac_adapter_comm(dev, dev->comm_interface);
> +	dev->sync_mode = 0;	/* sync. mode not supported */
> 	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
> 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
> 			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0)
> {
> diff -purN a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
> --- a/drivers/scsi/aacraid/sa.c	2012-02-06 16:47:59.000000000
+0530
> +++ b/drivers/scsi/aacraid/sa.c	2012-02-06 16:48:09.000000000
+0530
> @@ -385,6 +385,7 @@ int aac_sa_init(struct aac_dev *dev)
> 
> 	if(aac_init_adapter(dev) == NULL)
> 		goto error_irq;
> +	dev->sync_mode = 0;	/* sync. mode not supported */
> 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
> 			IRQF_SHARED|IRQF_DISABLED,
> 			"aacraid", (void *)dev ) < 0) {
> diff -purN a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> --- a/drivers/scsi/aacraid/src.c	2012-02-06 16:47:59.000000000
> +0530
> +++ b/drivers/scsi/aacraid/src.c	2012-02-06 19:02:00.000000000
> +0530
> @@ -96,6 +96,38 @@ static irqreturn_t aac_src_intr_message(
> 			our_interrupt = 1;
> 			/* handle AIF */
> 			aac_intr_normal(dev, 0, 2, 0, NULL);
> +		} else if (bellbits_shifted & OUTBOUNDDOORBELL_0) {
> +			unsigned long sflags;
> +			struct list_head *entry;
> +			int send_it = 0;
> +
> +			if (dev->sync_fib) {
> +				our_interrupt = 1;
> +				if (dev->sync_fib->callback)
> +
> dev->sync_fib->callback(dev->sync_fib->callback_data,
> +						dev->sync_fib);
> +
> spin_lock_irqsave(&dev->sync_fib->event_lock, sflags);
> +				if (dev->sync_fib->flags &
> FIB_CONTEXT_FLAG_WAIT) {
> +					dev->management_fib_count--;
> +					up(&dev->sync_fib->event_wait);
> +				}
> +
> spin_unlock_irqrestore(&dev->sync_fib->event_lock, sflags);
> +				spin_lock_irqsave(&dev->sync_lock,
> sflags);
> +				if (!list_empty(&dev->sync_fib_list)) {
> +					entry = dev->sync_fib_list.next;
> +					dev->sync_fib =
> list_entry(entry, struct fib, fiblink);
> +					list_del(entry);
> +					send_it = 1;
> +				} else {
> +					dev->sync_fib = NULL;
> +				}
> +				spin_unlock_irqrestore(&dev->sync_lock,
> sflags);
> +				if (send_it) {
> +					aac_adapter_sync_cmd(dev,
> SEND_SYNCHRONOUS_FIB,
> +
> (u32)dev->sync_fib->hw_fib_pa, 0, 0, 0, 0, 0,
> +						NULL, NULL, NULL, NULL,
> NULL);
> +				}
> +			}
> 		}
> 	}
> 
> @@ -177,56 +209,63 @@ static int src_sync_cmd(struct aac_dev *
> 	 */
> 	src_writel(dev, MUnit.IDR, INBOUNDDOORBELL_0 << SRC_IDR_SHIFT);
> 
> -	ok = 0;
> -	start = jiffies;
> +	if (!dev->sync_mode || command != SEND_SYNCHRONOUS_FIB) {
> +		ok = 0;
> +		start = jiffies;
> 
> -	/*
> -	 *	Wait up to 30 seconds
> -	 */
> -	while (time_before(jiffies, start+30*HZ)) {
> -		/* Delay 5 microseconds to let Mon960 get info. */
> -		udelay(5);
> -
> -		/* Mon960 will set doorbell0 bit
> -		 * when it has completed the command
> +		/*
> +		 *	Wait up to 5 minutes
> 		 */
> -		if ((src_readl(dev, MUnit.ODR_R) >> SRC_ODR_SHIFT) &
> OUTBOUNDDOORBELL_0) {
> -			/* Clear the doorbell */
> -			src_writel(dev,
> -				MUnit.ODR_C,
> -				OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
> -			ok = 1;
> -			break;
> +		while (time_before(jiffies, start+300*HZ)) {
> +			udelay(5);	/* Delay 5 microseconds to let
> Mon960 get info. */
> +			/*
> +			 *	Mon960 will set doorbell0 bit when it
> has completed the command.
> +			 */
> +			if ((src_readl(dev, MUnit.ODR_R) >>
> SRC_ODR_SHIFT) & OUTBOUNDDOORBELL_0) {
> +				/*
> +				 *	Clear the doorbell.
> +				 */
> +				src_writel(dev, MUnit.ODR_C,
> OUTBOUNDDOORBELL_0 << SRC_ODR_SHIFT);
> +				ok = 1;
> +				break;
> +			}
> +			/*
> +			 *	Yield the processor in case we are slow
> +			 */
> +			msleep(1);
> +		}
> +		if (unlikely(ok != 1)) {
> +			/*
> +			 *	Restore interrupt mask even though we
> timed out
> +			 */
> +			aac_adapter_enable_int(dev);
> +			return -ETIMEDOUT;
> 		}
> +		/*
> +		 *	Pull the synch status from Mailbox 0.
> +		 */
> +		if (status)
> +			*status = readl(&dev->IndexRegs->Mailbox[0]);
> +		if (r1)
> +			*r1 = readl(&dev->IndexRegs->Mailbox[1]);
> +		if (r2)
> +			*r2 = readl(&dev->IndexRegs->Mailbox[2]);
> +		if (r3)
> +			*r3 = readl(&dev->IndexRegs->Mailbox[3]);
> +		if (r4)
> +			*r4 = readl(&dev->IndexRegs->Mailbox[4]);
> 
> -		 /* Yield the processor in case we are slow */
> -		msleep(1);
> +		/*
> +		 *	Clear the synch command doorbell.
> +		 */
> +		src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 <<
> SRC_ODR_SHIFT);
> 	}
> -	if (unlikely(ok != 1)) {
> -		 /* Restore interrupt mask even though we timed out */
> -		aac_adapter_enable_int(dev);
> -		return -ETIMEDOUT;
> -	}
> -
> -	 /* Pull the synch status from Mailbox 0 */
> -	if (status)
> -		*status = readl(&dev->IndexRegs->Mailbox[0]);
> -	if (r1)
> -		*r1 = readl(&dev->IndexRegs->Mailbox[1]);
> -	if (r2)
> -		*r2 = readl(&dev->IndexRegs->Mailbox[2]);
> -	if (r3)
> -		*r3 = readl(&dev->IndexRegs->Mailbox[3]);
> -	if (r4)
> -		*r4 = readl(&dev->IndexRegs->Mailbox[4]);
> -
> -	 /* Clear the synch command doorbell */
> -	src_writel(dev, MUnit.ODR_C, OUTBOUNDDOORBELL_0 <<
> SRC_ODR_SHIFT);
> 
> -	 /* Restore interrupt mask */
> +	/*
> +	 *	Restore interrupt mask
> +	 */
> 	aac_adapter_enable_int(dev);
> 	return 0;
> -
> }
> 
> /**
> @@ -386,9 +425,7 @@ static int aac_src_ioremap(struct aac_de
> {
> 	if (!size) {
> 		iounmap(dev->regs.src.bar0);
> -		dev->regs.src.bar0 = NULL;
> -		iounmap(dev->base);
> -		dev->base = NULL;
> +		dev->base = dev->regs.src.bar0 = NULL;
> 		return 0;
> 	}
> 	dev->regs.src.bar1 = ioremap(pci_resource_start(dev->pdev, 2),
> @@ -404,7 +441,27 @@ static int aac_src_ioremap(struct aac_de
> 		return -1;
> 	}
> 	dev->IndexRegs = &((struct src_registers __iomem *)
> -		dev->base)->IndexRegs;
> +		dev->base)->u.tupelo.IndexRegs;
> +	return 0;
> +}
> +
> +/**
> + *  aac_srcv_ioremap
> + *	@size: mapping resize request
> + *
> + */
> +static int aac_srcv_ioremap(struct aac_dev *dev, u32 size)
> +{
> +	if (!size) {
> +		iounmap(dev->regs.src.bar0);
> +		dev->base = dev->regs.src.bar0 = NULL;
> +		return 0;
> +	}
> +	dev->base = dev->regs.src.bar0 =
> ioremap(dev->scsi_host_ptr->base, size);
> +	if (dev->base == NULL)
> +		return -1;
> +	dev->IndexRegs = &((struct src_registers __iomem *)
> +		dev->base)->u.denali.IndexRegs;
> 	return 0;
> }
> 
> @@ -419,7 +476,7 @@ static int aac_src_restart_adapter(struc
> 		bled = aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
> 			0, 0, 0, 0, 0, 0, &var, &reset_mask, NULL, NULL,
> NULL);
> 			if (bled || (var != 0x00000001))
> -				bled = -EINVAL;
> +				return -EINVAL;
> 		if (dev->supplement_adapter_info.SupportedOptions2 &
> 			AAC_OPTION_DOORBELL_RESET) {
> 			src_writel(dev, MUnit.IDR, reset_mask);
> @@ -579,15 +636,149 @@ int aac_src_init(struct aac_dev *dev)
> 	dev->dbg_size = AAC_MIN_SRC_BAR1_SIZE;
> 
> 	aac_adapter_enable_int(dev);
> +
> +	if (!dev->sync_mode) {
> +		/*
> +		 * Tell the adapter that all is configured, and it can
> +		 * start accepting requests
> +		 */
> +		aac_src_start_adapter(dev);
> +	}
> +	return 0;
> +
> +error_iounmap:
> +
> +	return -1;
> +}
> +
> +/**
> + *  aac_srcv_init	-	initialize an SRCv card
> + *  @dev: device to configure
> + *
> + */
> +
> +int aac_srcv_init(struct aac_dev *dev)
> +{
> +	unsigned long start;
> +	unsigned long status;
> +	int restart = 0;
> +	int instance = dev->id;
> +	const char *name = dev->name;
> +
> +	dev->a_ops.adapter_ioremap = aac_srcv_ioremap;
> +	dev->a_ops.adapter_comm = aac_src_select_comm;
> +
> +	dev->base_size = AAC_MIN_SRCV_BAR0_SIZE;
> +	if (aac_adapter_ioremap(dev, dev->base_size)) {
> +		printk(KERN_WARNING "%s: unable to map adapter.\n",
> name);
> +		goto error_iounmap;
> +	}
> +
> +	/* Failure to reset here is an option ... */
> +	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
> +	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
> +	if ((aac_reset_devices || reset_devices) &&
> +		!aac_src_restart_adapter(dev, 0))
> +		++restart;
> +	/*
> +	 *	Check to see if the board panic'd while booting.
> +	 */
> +	status = src_readl(dev, MUnit.OMR);
> +	if (status & KERNEL_PANIC) {
> +		if (aac_src_restart_adapter(dev,
> aac_src_check_health(dev)))
> +			goto error_iounmap;
> +		++restart;
> +	}
> 	/*
> -	 *	Tell the adapter that all is configured, and it can
> -	 * start accepting requests
> +	 *	Check to see if the board failed any self tests.
> +	 */
> +	status = src_readl(dev, MUnit.OMR);
> +	if (status & SELF_TEST_FAILED) {
> +		printk(KERN_ERR "%s%d: adapter self-test failed.\n",
> dev->name, instance);
> +		goto error_iounmap;
> +	}
> +	/*
> +	 *	Check to see if the monitor panic'd while booting.
> +	 */
> +	if (status & MONITOR_PANIC) {
> +		printk(KERN_ERR "%s%d: adapter monitor panic.\n",
> dev->name, instance);
> +		goto error_iounmap;
> +	}
> +	start = jiffies;
> +	/*
> +	 *	Wait for the adapter to be up and running. Wait up to 3
> minutes
> 	 */
> -	aac_src_start_adapter(dev);
> +	while (!((status = src_readl(dev, MUnit.OMR)) &
> KERNEL_UP_AND_RUNNING)) {
> +		if ((restart &&
> +		  (status &
> (KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC))) ||
> +		  time_after(jiffies, start+HZ*startup_timeout)) {
> +			printk(KERN_ERR "%s%d: adapter kernel failed to
> start, init status = %lx.\n",
> +					dev->name, instance, status);
> +			goto error_iounmap;
> +		}
> +		if (!restart &&
> +		  ((status &
> (KERNEL_PANIC|SELF_TEST_FAILED|MONITOR_PANIC)) ||
> +		  time_after(jiffies, start + HZ *
> +		  ((startup_timeout > 60)
> +		    ? (startup_timeout - 60)
> +		    : (startup_timeout / 2))))) {
> +			if (likely(!aac_src_restart_adapter(dev,
> aac_src_check_health(dev))))
> +				start = jiffies;
> +			++restart;
> +		}
> +		msleep(1);
> +	}
> +	if (restart && aac_commit)
> +		aac_commit = 1;
> +	/*
> +	 *	Fill in the common function dispatch table.
> +	 */
> +	dev->a_ops.adapter_interrupt = aac_src_interrupt_adapter;
> +	dev->a_ops.adapter_disable_int = aac_src_disable_interrupt;
> +	dev->a_ops.adapter_notify = aac_src_notify_adapter;
> +	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
> +	dev->a_ops.adapter_check_health = aac_src_check_health;
> +	dev->a_ops.adapter_restart = aac_src_restart_adapter;
> +
> +	/*
> +	 *	First clear out all interrupts.  Then enable the one's
> that we
> +	 *	can handle.
> +	 */
> +	aac_adapter_comm(dev, AAC_COMM_MESSAGE);
> +	aac_adapter_disable_int(dev);
> +	src_writel(dev, MUnit.ODR_C, 0xffffffff);
> +	aac_adapter_enable_int(dev);
> 
> +	if (aac_init_adapter(dev) == NULL)
> +		goto error_iounmap;
> +	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE1)
> +		goto error_iounmap;
> +	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
> +	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
> +		IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
> +		if (dev->msi)
> +			pci_disable_msi(dev->pdev);
> +		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
> +			name, instance);
> +		goto error_iounmap;
> +	}
> +	dev->dbg_base = dev->scsi_host_ptr->base;
> +	dev->dbg_base_mapped = dev->base;
> +	dev->dbg_size = dev->base_size;
> +
> +	aac_adapter_enable_int(dev);
> +
> +	if (!dev->sync_mode) {
> +		/*
> +		 * Tell the adapter that all is configured, and it can
> +		 * start accepting requests
> +		 */
> +		aac_src_start_adapter(dev);
> +	}
> 	return 0;
> 
> error_iounmap:
> 
> 	return -1;
> }
> +
> 
> 
> <aacraid-Sync.patch>

______________________________________________________________________
This email may contain privileged or confidential information, which
should only be used for the purpose for which it was sent by Xyratex. No
further rights or licenses are granted to use such information. If you
are not the intended recipient of this message, please notify the sender
by return and delete it. You may not use, copy, disclose or rely on the
information contained in it.
 
Internet email is susceptible to data corruption, interception and
unauthorised amendment for which Xyratex does not accept liability.
While we have taken reasonable precautions to ensure that this email is
free of viruses, Xyratex does not accept liability for the presence of
any computer viruses in this email, nor for any losses caused as a
result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales,
Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in
Bermuda, Xyratex International Inc, registered in California, Xyratex
(Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co
Ltd registered in The People's Republic of China and Xyratex Japan
Limited registered in Japan.
______________________________________________________________________
 


