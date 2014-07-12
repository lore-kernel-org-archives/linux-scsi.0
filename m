From: Arthur Marsh <arthur.marsh@internode.on.net>
Subject: Re: eata - issue appeared in Linus git master in last 24-48 hours
Date: Sat, 12 Jul 2014 14:43:39 +0930
Message-ID: <53C0C403.1010503@internode.on.net>
References: <dd468b-sj5.ln1@ppp14-2-48-242.lns21.adl2.internode.on.net> <20140711092006.GB26912@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:46940 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbaGLFNp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2014 01:13:45 -0400
In-Reply-To: <20140711092006.GB26912@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org



Christoph Hellwig wrote, on 11/07/14 18:50:
> On Mon, Jun 30, 2014 at 04:31:33AM +0930, Arthur Marsh wrote:
>> Hi, I haven't had time to do a git bisect yet, but just saw this after
>> rebuilding the kernel in the last day or so:
>
> It seems like some of the routines called during the driver
> initialization may sleep while the driver_lock is held and irqs are
> disabled.
>
> As eata2x_detect is only called during module load the lock seems
> entirely pointless and should be removed, like in the patch below:
>
>
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index 03372cf..980898e 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -837,7 +837,6 @@ struct hostdata {
>   static struct Scsi_Host *sh[MAX_BOARDS];
>   static const char *driver_name = "EATA";
>   static char sha[MAX_BOARDS];
> -static DEFINE_SPINLOCK(driver_lock);
>
>   /* Initialize num_boards so that ihdlr can work while detect is in progress */
>   static unsigned int num_boards = MAX_BOARDS;
> @@ -1097,8 +1096,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
>   		goto fail;
>   	}
>
> -	spin_lock_irq(&driver_lock);
> -
>   	if (do_dma(port_base, 0, READ_CONFIG_PIO)) {
>   #if defined(DEBUG_DETECT)
>   		printk("%s: detect, do_dma failed at 0x%03lx.\n", name,
> @@ -1265,10 +1262,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
>   	}
>   #endif
>
> -	spin_unlock_irq(&driver_lock);
>   	sh[j] = shost = scsi_register(tpnt, sizeof(struct hostdata));
> -	spin_lock_irq(&driver_lock);
> -
>   	if (shost == NULL) {
>   		printk("%s: unable to register host, detaching.\n", name);
>   		goto freedma;
> @@ -1345,8 +1339,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
>   	else
>   		sprintf(dma_name, "DMA %u", dma_channel);
>
> -	spin_unlock_irq(&driver_lock);
> -
>   	for (i = 0; i < shost->can_queue; i++)
>   		ha->cp[i].cp_dma_addr = pci_map_single(ha->pdev,
>   							  &ha->cp[i],
> @@ -1439,7 +1431,6 @@ static int port_detect(unsigned long port_base, unsigned int j,
>         freeirq:
>   	free_irq(irq, &sha[j]);
>         freelock:
> -	spin_unlock_irq(&driver_lock);
>   	release_region(port_base, REGION_SIZE);
>         fail:
>   	return 0;
>

Thanks, I've rebuilt the kernel with this patch applied and running the 
rebuilt kernel fine using a DPT 2044W SCSI adaptor:

$ lspci|grep DPT
00:0c.0 SCSI storage controller: Adaptec (formerly DPT) SmartCache/Raid 
I-IV Controller (rev 02)


$ dmesg|grep -i eata
[    1.038968] EATA0: warning, DMA protocol support not asserted.
[    1.039041] EATA0: IRQ 11 mapped to IO-APIC IRQ 16.
[    1.040801] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
[    1.040861] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n, 
ip:n, ep:n, pp:y.
[    1.040922] EATA0: 2.0C, PCI 0x7410, IRQ 16, BMST, SG 122, MB 64.
[    1.040973] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
[    1.041025] EATA0: SCSI channel 0 enabled, host target ID 7.
[    1.041095] scsi2 : EATA/DMA 2.0x rev. 8.10.00

Arthur.
