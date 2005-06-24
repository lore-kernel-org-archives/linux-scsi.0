From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] 2.6 aacraid: shutdown notification
Date: Fri, 24 Jun 2005 15:30:39 -0500
Message-ID: <42BC6D6F.5090402@us.ibm.com>
References: <1119643035.25270.20.camel@markh1.pdx.osdl.net>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:1515 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263115AbVFXUap (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2005 16:30:45 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5OKUfgL005605
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2005 16:30:41 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5OKUftC204308
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2005 16:30:41 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5OKUeIl026784
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2005 16:30:41 -0400
In-Reply-To: <1119643035.25270.20.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

The pci_driver->shutdown method should be used instead of registering
a reboot notifier.

Brian

Mark Haverkamp wrote:
> Received from Mark Salyzyn at Adaptec
> 
> Add in reboot notification so that the adapter shuts down correctly and
> flushes its cache. Shutdown should also disable the adapter's interrupt
> when shutdown (in particularly if the driver is rmmod'd) to prevent
> spurious hardware activities.
> 
> 
> Patch against scsi-misc-2.6 git tree.
> 
> Signed-off-by: Mark Haverkamp <markh@osdl.org>
> 
>  aacraid.h |    4 ++++
>  linit.c   |   28 +++++++++++++++++++++++++++-
>  rkt.c     |   20 ++++++++++++++++++++
>  rx.c      |   20 ++++++++++++++++++++
>  sa.c      |   22 ++++++++++++++++++++--
>  5 files changed, 91 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -460,6 +460,7 @@ struct adapter_ops
>  {
>  	void (*adapter_interrupt)(struct aac_dev *dev);
>  	void (*adapter_notify)(struct aac_dev *dev, u32 event);
> +	void (*adapter_disable_int)(struct aac_dev *dev);
>  	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6, u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4);
>  	int  (*adapter_check_health)(struct aac_dev *dev);
>  };
> @@ -970,6 +971,9 @@ struct aac_dev
>  #define aac_adapter_notify(dev, event) \
>  	(dev)->a_ops.adapter_notify(dev, event)
>  
> +#define aac_adapter_disable_int(dev) \
> +	(dev)->a_ops.adapter_disable_int(dev)
> +
>  #define aac_adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4) \
>  	(dev)->a_ops.adapter_sync_cmd(dev, command, p1, p2, p3, p4, p5, p6, status, r1, r2, r3, r4)
>  
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -55,6 +55,7 @@
>  #include <scsi/scsi_tcq.h>
>  #include <scsi/scsicam.h>
>  #include <scsi/scsi_eh.h>
> +#include <linux/reboot.h>
>  
>  #include "aacraid.h"
>  
> @@ -815,11 +816,12 @@ static int __devinit aac_probe_one(struc
>  
>  	return 0;
>  
> -out_deinit:
> + out_deinit:
>  	kill_proc(aac->thread_pid, SIGKILL, 0);
>  	wait_for_completion(&aac->aif_completion);
>  
>  	aac_send_shutdown(aac);
> +	aac_adapter_disable_int(aac);
>  	fib_map_free(aac);
>  	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
>  	kfree(aac->queues);
> @@ -847,6 +849,7 @@ static void __devexit aac_remove_one(str
>  	wait_for_completion(&aac->aif_completion);
>  
>  	aac_send_shutdown(aac);
> +	aac_adapter_disable_int(aac);
>  	fib_map_free(aac);
>  	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
>  			aac->comm_phys);
> @@ -869,6 +872,26 @@ static struct pci_driver aac_pci_driver 
>  	.remove		= __devexit_p(aac_remove_one),
>  };
>  
> +static int aac_reboot_event(struct notifier_block * n, ulong code, void *p)
> +{
> +	if ((code == SYS_RESTART) ||
> +	  (code == SYS_HALT) ||
> +	  (code == SYS_POWER_OFF)) {
> +		struct aac_dev *aac;
> +
> +		list_for_each_entry(aac, &aac_devices, entry)
> +			aac_send_shutdown(aac);
> +	}
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block aac_reboot_notifier =
> +{
> +	aac_reboot_event,
> +	NULL,
> +	0
> +};
> +
>  static int __init aac_init(void)
>  {
>  	int error;
> @@ -885,12 +908,15 @@ static int __init aac_init(void)
>  		printk(KERN_WARNING
>  		       "aacraid: unable to register \"aac\" device.\n");
>  	}
> +	register_reboot_notifier(&aac_reboot_notifier);
> +
>  	return 0;
>  }
>  
>  static void __exit aac_exit(void)
>  {
>  	unregister_chrdev(aac_cfg_major, "aac");
> +	unregister_reboot_notifier(&aac_reboot_notifier);
>  	pci_unregister_driver(&aac_pci_driver);
>  }
>  
> diff --git a/drivers/scsi/aacraid/rkt.c b/drivers/scsi/aacraid/rkt.c
> --- a/drivers/scsi/aacraid/rkt.c
> +++ b/drivers/scsi/aacraid/rkt.c
> @@ -88,6 +88,16 @@ static irqreturn_t aac_rkt_intr(int irq,
>  }
>  
>  /**
> + *	aac_rkt_disable_interrupt	-	Disable interrupts
> + *	@dev: Adapter
> + */
> +
> +static void aac_rkt_disable_interrupt(struct aac_dev *dev)
> +{
> +	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
> +}
> +
> +/**
>   *	rkt_sync_cmd	-	send a command and wait
>   *	@dev: Adapter
>   *	@command: Command to execute
> @@ -412,10 +422,19 @@ int aac_rkt_init(struct aac_dev *dev)
>  	 *	Fill in the function dispatch table.
>  	 */
>  	dev->a_ops.adapter_interrupt = aac_rkt_interrupt_adapter;
> +	dev->a_ops.adapter_disable_int = aac_rkt_disable_interrupt;
>  	dev->a_ops.adapter_notify = aac_rkt_notify_adapter;
>  	dev->a_ops.adapter_sync_cmd = rkt_sync_cmd;
>  	dev->a_ops.adapter_check_health = aac_rkt_check_health;
>  
> +	/*
> +	 *	First clear out all interrupts.  Then enable the one's that we
> +	 *	can handle.
> +	 */
> +	rkt_writeb(dev, MUnit.OIMR, 0xff);
> +	rkt_writel(dev, MUnit.ODR, 0xffffffff);
> +	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
> +
>  	if (aac_init_adapter(dev) == NULL)
>  		goto error_irq;
>  	/*
> @@ -438,6 +457,7 @@ error_kfree:
>  	kfree(dev->queues);
>  
>  error_irq:
> +	rkt_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
>  	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
>  
>  error_iounmap:
> diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
> --- a/drivers/scsi/aacraid/rx.c
> +++ b/drivers/scsi/aacraid/rx.c
> @@ -88,6 +88,16 @@ static irqreturn_t aac_rx_intr(int irq, 
>  }
>  
>  /**
> + *	aac_rx_disable_interrupt	-	Disable interrupts
> + *	@dev: Adapter
> + */
> +
> +static void aac_rx_disable_interrupt(struct aac_dev *dev)
> +{
> +	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
> +}
> +
> +/**
>   *	rx_sync_cmd	-	send a command and wait
>   *	@dev: Adapter
>   *	@command: Command to execute
> @@ -412,10 +422,19 @@ int aac_rx_init(struct aac_dev *dev)
>  	 *	Fill in the function dispatch table.
>  	 */
>  	dev->a_ops.adapter_interrupt = aac_rx_interrupt_adapter;
> +	dev->a_ops.adapter_disable_int = aac_rx_disable_interrupt;
>  	dev->a_ops.adapter_notify = aac_rx_notify_adapter;
>  	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
>  	dev->a_ops.adapter_check_health = aac_rx_check_health;
>  
> +	/*
> +	 *	First clear out all interrupts.  Then enable the one's that we
> +	 *	can handle.
> +	 */
> +	rx_writeb(dev, MUnit.OIMR, 0xff);
> +	rx_writel(dev, MUnit.ODR, 0xffffffff);
> +	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xfb);
> +
>  	if (aac_init_adapter(dev) == NULL)
>  		goto error_irq;
>  	/*
> @@ -438,6 +457,7 @@ error_kfree:
>  	kfree(dev->queues);
>  
>  error_irq:
> +	rx_writeb(dev, MUnit.OIMR, dev->OIMR = 0xff);
>  	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
>  
>  error_iounmap:
> diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
> --- a/drivers/scsi/aacraid/sa.c
> +++ b/drivers/scsi/aacraid/sa.c
> @@ -82,6 +82,16 @@ static irqreturn_t aac_sa_intr(int irq, 
>  }
>  
>  /**
> + *	aac_sa_disable_interrupt	-	disable interrupt
> + *	@dev: Which adapter to enable.
> + */
> +
> +static void aac_sa_disable_interrupt (struct aac_dev *dev)
> +{
> +	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
> +}
> +
> +/**
>   *	aac_sa_notify_adapter		-	handle adapter notification
>   *	@dev:	Adapter that notification is for
>   *	@event:	Event to notidy
> @@ -214,9 +224,8 @@ static int sa_sync_cmd(struct aac_dev *d
>   
>  static void aac_sa_interrupt_adapter (struct aac_dev *dev)
>  {
> -	u32 ret;
>  	sa_sync_cmd(dev, BREAKPOINT_REQUEST, 0, 0, 0, 0, 0, 0,
> -			&ret, NULL, NULL, NULL, NULL);
> +			NULL, NULL, NULL, NULL, NULL);
>  }
>  
>  /**
> @@ -352,10 +361,18 @@ int aac_sa_init(struct aac_dev *dev)
>  	 */
>  
>  	dev->a_ops.adapter_interrupt = aac_sa_interrupt_adapter;
> +	dev->a_ops.adapter_disable_int = aac_sa_disable_interrupt;
>  	dev->a_ops.adapter_notify = aac_sa_notify_adapter;
>  	dev->a_ops.adapter_sync_cmd = sa_sync_cmd;
>  	dev->a_ops.adapter_check_health = aac_sa_check_health;
>  
> +	/*
> +	 *	First clear out all interrupts.  Then enable the one's that 
> +	 *	we can handle.
> +	 */
> +	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
> +	sa_writew(dev, SaDbCSR.PRICLEARIRQMASK, (PrintfReady | DOORBELL_1 | 
> +				DOORBELL_2 | DOORBELL_3 | DOORBELL_4));
>  
>  	if(aac_init_adapter(dev) == NULL)
>  		goto error_irq;
> @@ -381,6 +398,7 @@ error_kfree:
>  	kfree(dev->queues);
>  
>  error_irq:
> +	sa_writew(dev, SaDbCSR.PRISETIRQMASK, 0xffff);
>  	free_irq(dev->scsi_host_ptr->irq, (void *)dev);
>  
>  error_iounmap:
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
