From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: dpt_i2o driver
Date: Tue, 2 Sep 2003 09:51:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0998F43EAD645A47B3F6507196DD70EA25690F@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:11490 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S263447AbTIBNvZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 09:51:25 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

Thanks, Christoph, for your feedback! Appreciated!

- Consider 2.2 history? We no longer build modules for these kernels, but
  I do get monthly requests for driver sources to work in such. Adaptec's
  policy is one version, plus one behind, so supporting these users is a
  violation of this policy. Pleasing everyone is so hard ... :-(
- Will do regarding the ifdef indent, indent is such a hard structured
  programming habit to break!
- I had to mix too many code bases, too many kernels, hard to decide who had
  indent. My guess you would prefer 2.6 base for starters ;->
- I looked through the nits, looks ok except:
	- use_new_eh_code was initialized thus because some kernels would
have
	  the (smp) lock, but not the (up) interrupts disabled; by
initializing
	  after the fact one got consistent io_request_lock behavior. Will
need
	  to instrument and test the current crop of kernels I build for to
see
	  if this issue is no longer there. proc_dir is a 2.2 ism,
will-be-gone.
	- Found some kernels that did not have CONFIG_HIGHIO, yet had
highmem_io
	  functionality :-( Wanted 64 bit to function there ...
	- casting to u8 * follows rules of strict typechecking and
documentation
	  of pointer's purpose. Will remove under this `protest' as the
Linux
	  CodingStyle does frown upon excesses.
	- I remember the author of this code going through hoops to get
	  add_wait_queue to function in some of the kernels, she
	  got abused by a race condition that would only go away once it
	  was coded thus. I will need to revisit these bugs and make sure
	  they are no longer present in the current crop of kernels.
	- pHba->host is not set during early stages of initialization,
	  had to place the if around the
spin_unlock_irq(pHba->host->host_lock)
	  to allow the initialization check for the adapter. One could trust
	  the product Ids and move code around, I chose the easy way out.
	- DPT_TARGET_BUSY is necessary to prevent the management
applications
	  from modifying arrays that are in use. Without this, admittedly
racy,
	  code, we are all doomed (!) Busy checking from the management
	  perspective shall always be racy, we count on the slowness of the
	  operations and the users and the fact that the person utilizing
the
	  applications has some physical access knowledge of the system.
	  However, they make mistakes, and we would have far more serious
	  problems without this ioctl. OEM's would scream *murder* (as they
	  have in the past). I personally do not see an issue with this
being
	  in the way of proper refcounting as it is passive. Looks like a
case
	  of one release for kernels.org, and another for our customers :-(
?

dpt_i2o predated the i2o_scsi driver, and as such contains some legacy.
However, this driver is a pure scsi layer solution, no block device
translation, utilizing a DPT special private scb command that can be issued
to *any* target to simplify the driver (and the firmware) paths. In
addition, the dpt card has the ability to assign SCSI Ids to logical
devices, can only be extracted completely (bus, target and lun) from a DPT
special private getparam page. 64 bit Scatter Gather is supported, by
igniting an unused bit in the SCB command. Finally, need a management
utility path to issue commands to the adapter.

I see no problem with incorporating these enhancements into i2o_scsi, except
for the resistance to management application ioctls though ...

Sincerely -- Mark Salyzyn


-----Original Message-----
From: 'Christoph Hellwig' [mailto:hch@infradead.org]
Sent: Thursday, August 28, 2003 6:12 AM
To: Salyzyn, Mark
Cc: 'Christoph Hellwig'; Mark Haverkamp; linux-scsi
Subject: Re: dpt_i2o driver


On Tue, Aug 26, 2003 at 01:17:49PM -0400, Salyzyn, Mark wrote:
> I will have to admit that currently it has the 2.4 + 2.6 nature to it
> (liberal ifdefs on KERNEL version) so there is some `cleanup' necessary
for
> it to be part of the 2.6 tree. It's last build and test was with
> 2.6.0-test2.
> 
> I don't want to increase the work load, 47 ifdefs by kernel version could
> probably be cleaned up by a sed, awk or perl script. I have enclosed it
here
> for expediency, but should really clean it up into a diff -u to the
current
> variant of the driver in the tree ...

Okay, here's a few comments on the diff vs what's in 2.6.  Additional notes:

 - the driver won't work asis on 2.2 - pci_alloc_consistant is 2.4+.  What
   about dropping at least 2.2 support? :)
 - to make filetering the version checks easier you should avoid addition
   indentation for #ifdefs - that's how linux code is written anyway.  Also
   please don't put the ifdefs inside prototypes - just have to separate
copies
   of the prototype.
 - the driver wants feeding through Documentation/Lindent (_after_ this
update is
   in, as an indentation-change only patch)

BTW, what's the advantage over the i2o_scsi driver that seems to deal with
this
hardware just fine?


@@ -19,7 +18,7 @@
 
 #ifdef __KERNEL__       /* This file to be included by kernel only */
 
-#include <linux/i2o-dev.h>
+#include "dpti_i2o-dev.h"

>>> Sounds like a bad idea to change
 
-#error Please convert me to Documentation/DMA-mapping.txt
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,65))
+//# error Please convert me to Documentation/DMA-mapping.txt
+#endif

>>> well, you just converted it, so kill this completly :)
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,65))
+# include <linux/blkdev.h>

>>> blkdev.h exist at least in all Linux 2.x variants.  <= 2.4 just gets it
>>> implicitly, so you're safe to always include it.

+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0))
+static struct semaphore adpt_configuration_lock = MUTEX;
+#else
 DECLARE_MUTEX(adpt_configuration_lock);
-
-static struct i2o_sys_tbl *sys_tbl = NULL;
+#endif

>>> it might be easier for you to just add a compat.h that does
>>> #define DECLARE_MUTEX(name)		static struct semaphore (name) =
MUTEX;
>>> for 2.2 kernels

+static struct i2o_sys_tbl *sys_tbl_va = NULL;
+static dma_addr_t sys_tbl_pa;
 static int sys_tbl_ind = 0;
 static int sys_tbl_len = 0;

>>> static variables are implicitly zeroed in any ANSI C enviroment,
including
>>> the linux kernel.
 
 
@@ -175,13 +201,20 @@ static int adpt_detect(Scsi_Host_Templat
 	adpt_hba* pHba;
 
 	adpt_init();
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0))
+	sht->proc_dir = &proc_scsi_dptI2O;
+#endif
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,65))
+	sht->use_new_eh_code = 1;
+#endif

>>> please initialize this directly in the struct defintion below..

 
+			pci_set_dma_mask(pHba->pDev,
(dma_addr_t)0xFFFFFFFFFFFFFFFFULL);

>>> you need to check the return value here

+#			if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,18)) &&
defined(CONFIG_HIGHMEM) && ((LINUX_VERSION_CODE != KERNEL_VERSION(2,4,19))
|| defined(CONFIG_HIGHIO))
+                		pHba->host->highmem_io = 1;

>>> 2.6 doesn't have the highmem_io flag anymore, it automatically enables
>>> highmem I/O with the right dma mask.  The 2.4 kernels OTOH always define
>>> CONFIG_HIGHIO IIRC.  So this should be just ifdef CONFIG_HIGHIO

 	s32 rcode;
 
 	memset(msg, 0, sizeof(msg));
-	buf = (u8*)kmalloc(80,GFP_KERNEL|ADDR32);
+	buf = (u8*)pci_alloc_consistent(pHba->pDev, 80, &addr);

>>> pci_alloc_consistent returns void *, not need to cast to (u8 *)

+#	if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,65))
+		pHba = (adpt_hba*)cmd->device->host->hostdata[0];
+#	else
+		pHba = (adpt_hba*)cmd->host->hostdata[0];
+#	endif

>>> the 2.6 version should be fine for 2.2 and 2.4 awell. IIRC we always had
>>> device->host, older kernels just had the information in the command,
too.

-		if ((pDev = adpt_find_device(pHba,
(u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun)) ==
NULL) {
+#		if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,65))
+			if ((pDev = adpt_find_device(pHba,
(u32)cmd->device->channel, (u32)cmd->device->id, (u32)cmd->device->lun)) ==
NULL)
+#		else
+			if ((pDev = adpt_find_device(pHba,
(u32)cmd->channel, (u32)cmd->target, (u32)cmd->lun)) == NULL)
+#		endif

>>> dito here and in a few other places.

 	// this code is taken from
kernel/sched.c:interruptible_sleep_on_timeout
 	wait.task = current;
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0))
+	write_lock_irqsave(&waitqueue_lock,flags);
+	__add_wait_queue(&adpt_wq_i2o_post, &wait);
+	write_unlock(&waitqueue_lock);
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,65))
 	init_waitqueue_entry(&wait, current);
-	spin_lock_irqsave(&adpt_wq_i2o_post.lock, flags);
+	spin_lock_irqsave(&adpt_wq_i2o_post.lock,flags);
 	__add_wait_queue(&adpt_wq_i2o_post, &wait);
 	spin_unlock(&adpt_wq_i2o_post.lock);
+#else
+	init_waitqueue_entry(&wait, current);
+	wq_write_lock_irqsave(&adpt_wq_i2o_post.lock,flags);
+	__add_wait_queue(&adpt_wq_i2o_post, &wait);
+	wq_write_unlock(&adpt_wq_i2o_post.lock);
+#endif


>>> eeek!!!! why don't you simply use add_wait_queue() instead of opencoding
it.

 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0))
 		set_current_state(TASK_INTERRUPTIBLE);
-		spin_unlock_irq(pHba->host->host_lock);
-		if (!timeout)
+//# if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,65))
+//		if (pHba->host != NULL) /* Sad */
+//			spin_unlock_irq(pHba->host->host_lock);
+//# else
+//		spin_unlock_irq(&io_request_lock);
+//# endif
+#else
+		current->state = TASK_INTERRUPTIBLE;
+//		spin_unlock_irq(&io_request_lock);
+#endif

>>> what's this?

+//#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,65))
+//		if (pHba->host != NULL) /* Sad */
+//			spin_lock_irq(pHba->host->host_lock);
+//#else
+//		spin_lock_irq(&io_request_lock);
+//#endif

>>> dito.

+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0))
+	write_lock_irq(&waitqueue_lock);
+	__remove_wait_queue(&adpt_wq_i2o_post, &wait);
+	write_unlock_irqrestore(&waitqueue_lock,flags);
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,65))
 	spin_lock_irq(&adpt_wq_i2o_post.lock);
 	__remove_wait_queue(&adpt_wq_i2o_post, &wait);
-	spin_unlock_irqrestore(&adpt_wq_i2o_post.lock, flags);
+	spin_unlock_irqrestore(&adpt_wq_i2o_post.lock,flags);
+#else
+	wq_write_lock_irq(&adpt_wq_i2o_post.lock);
+	__remove_wait_queue(&adpt_wq_i2o_post, &wait);
+	wq_write_unlock_irqrestore(&adpt_wq_i2o_post.lock,flags);
+#endif

>>> simply use remove_wait_queue()..

+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,65))
 	minor = minor(inode->i_rdev);
+#else
+	minor = MINOR(inode->i_rdev);
+#endif

>>> just put a
>>> #ifndef minor
>>> #define minor(i) MINOR(i)
>>> in compat.h.
>>> in 2.6 it will soon become iminor(inode), though.


+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0))
+		set_current_state(TASK_UNINTERRUPTIBLE);
+#else
+		current->state = TASK_UNINTERRUPTIBLE;
+#endif

>>> add a set_current_state() dummy for 2.2?

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
+		d = adpt_find_device(pHba, busy.channel, busy.id, busy.lun);
+		if(d == NULL){
+			return -ENODEV;
+		}
+		busy.isBusy = ((d->pScsi_dev) && (0 !=
d->pScsi_dev->access_count)) ? 1 : 0;
+		if (copy_to_user ((char*)arg, &busy, sizeof(busy))) {
+			return -EFAULT;
+		}
+		break;
+	}

>>> I removed this for a reason because (a) the ioctl is racy and (b) it's
in the way of
>>> proper refcounting.  please don't re-introduce it.

 	default:
 		return -EINVAL;
 	}
@@ -1956,48 +2286,59 @@ static int adpt_ioctl(struct inode *inod
 	return error;
 }
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0))
 #include "scsi_module.c"
-MODULE_LICENSE("GPL");
+#elif (defined(MODULE))
+#include "scsi_module.c"
+#endif

>>> this is fine for 2.2 aswell, just make sure you link it after
>>> the scsi core and upper drivers in the makefile.

+#ifdef MODULE_LICENSE
+MODULE_LICENSE("Dual BSD/GPL");
+#endif

>>> just put a 
>>> #ifndef MODULE_LICENSE
>>> #define MODULE_LICENSE(foo)	/*NOTHING*/
>>> #endif
>>> in compat.h

+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,65))
+  typedef void irqreturn_t;
+# define IRQ_NONE
+# define IRQ_HANDLED
+#endif

>>> these defintions are in 2.4.23-pre now, too.
>>> use #ifndef IRQ_HANDLED instead.

