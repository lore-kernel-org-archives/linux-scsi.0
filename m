From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 5/6] aha152x.c - Fix check_condition code-path
Date: Thu, 2 Aug 2007 12:09:26 -0700
Message-ID: <20070802120926.63a76fce.rdunlap@xenotime.net>
References: <46ACE62F.4070108@panasas.com>
	<46ACEA0A.5040101@panasas.com>
	<20070730171331.5237bb94.rdunlap@xenotime.net>
	<46AEEBF7.3060808@panasas.com>
	<20070731114021.488735ec.rdunlap@xenotime.net>
	<1185976274.3468.70.camel@localhost.localdomain>
	<20070801093422.f986597d.rdunlap@xenotime.net>
	<46B1BF77.6060804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:48052 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752844AbXHBTDp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Aug 2007 15:03:45 -0400
Received: from midway.site ([71.245.96.223]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 2 Aug 2007 12:03:40 -0700
In-Reply-To: <46B1BF77.6060804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "=?ISO-8859-1?Q? J=FCrg?= =?ISO-8859-1?Q?en_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "David A. Hinds" <dahinds@users.sourceforge.net>

On Thu, 02 Aug 2007 14:26:47 +0300 Boaz Harrosh wrote:

> Randy Dunlap wrote:
> > On Wed, 01 Aug 2007 08:51:14 -0500 James Bottomley wrote:
> > 
> >> On Tue, 2007-07-31 at 11:40 -0700, Randy Dunlap wrote:
> >>> On Tue, 31 Jul 2007 10:59:51 +0300 Boaz Harrosh wrote:
> >>>
> >>>> Randy Dunlap wrote:
> >>>>> Since you grok all of that (above), maybe you can help here:
> >>>>>
> >>>>> With these 6 patches applied, I do the following:
> >>>>>
> >>>>> 1.  insert PCMCIA aha152x card with SCSI drive attached (/dev/sdb4)
> >>>>> 2.  mount -t vfat /dev/sdb4 /mnt/disk
> >>>>> 3.  play with /mnt/disk
> >>>>> 4.  umount /mnt/disk
> >>>>>
> >>>>> Now I would like to rmmod the aha152x_cs module, but its use count
> >>>>> is 2.  Even if I eject the card, its use count stays at 2.
> >>>>> Maybe the reset or check_condition patch doesn't clean up correctly,
> >>>>> or one of them isn't releasing a used resource ?
> >>>>>
> >>>>> (this is 2.6.23-rc1 + your 6 patches + 1 acpi seq-file throttling fix.)
> >>>>>
> >>>> I had an hard look and a very careful line-by-line compare
> >>>> and I can't find anything obvious. Could you do a bisect.
> >>>> maybe it will give me a clue as to where to look. Also please
> >>>> Enable debug prints. Maybe the driver is stuck at some state 
> >>>> and does not exit.
> >>> The good news is that this problem has nothing to do with this
> >>> patch series.  The bad news is that this problem is there anyway.
> I was afraid of that. I will try and see what other PCMCIA drivers
> are doing in this situation. It looks like the driver should bailout
> much earlier in the event that the card is not present. But it lets
> the request in anyway. The original driver was not written for hotplug
> PCMCIA maybe that's why.

Yes, Christoph would like to see the ISA & PCMCIA drivers as separate
drivers, using the correct driver models, and not using that ugly
#include .c source file trick.


> Please correct me if I'm wrong
> 1. pccard senses an eject coming and is doing device_unregister()
> 2. sd.c in sd_shutdown() is doing a Synchronize Cache.
> 3. The command is queued but since card is not there anymore an interrupt never
>    comes and the command is just stuck.
> 
> 4. After one second an abort comes in an is returned with success (line 1113)
> [   88.869051] (scsi-1:-1:-1) (aha152x_internal_queue:1055) unlocked
> [   89.884469] (scsi-1:-1:-1) (aha152x_abort:1113) locking

This all sounds correct to me (AFAIK).

> 5. Now a Test Unit Ready comes in. Already a good second and more after
>    the eject. The card is clearly not powered by now.
>    aha152x_internal_queue should check it's own presence. and return 
>    appropriate value.
>    Two questions:
>    a. What should be the return value from a queuecommand handler
>       when the card is no longer present?
>    b. What should we check to know we no longer have a card?

Anyone??

> 6. One more second passes and 2nd abort comes in.
> 7. Than a reset comes in. Here too Should driver check for hardware
>    presence.
> 
> since ds.c is doing: p_dev->_removed=1;
> before the shutdown. Maybe a solution is to have aha152x_stub.c,
> which is the only one that knows of PCMCIA, Override queuecommand
> and just check for p_dev->_removed==1. Something like:
> 
> 
>  -------------------------------------------------------------------------------------------------------------
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index d30a307..5fe55d0 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -1062,7 +1063,7 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
>   *  queue a command
>   *
>   */
> -static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
> +int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
>  {
>  #if 0
>  	if(*SCpnt->cmnd == REQUEST_SENSE) {
> diff --git a/drivers/scsi/aha152x.h b/drivers/scsi/aha152x.h
> index ac4bfa4..065612f 100644
> --- a/drivers/scsi/aha152x.h
> +++ b/drivers/scsi/aha152x.h
> @@ -333,5 +333,6 @@ struct aha152x_setup {
>  struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *);
>  void aha152x_release(struct Scsi_Host *);
>  int aha152x_host_reset_host(struct Scsi_Host *);
> +int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *));
>  
>  #endif /* _AHA152X_H */
> diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
> index 370802d..e2f5ea5 100644
> --- a/drivers/scsi/pcmcia/aha152x_stub.c
> +++ b/drivers/scsi/pcmcia/aha152x_stub.c
> @@ -137,6 +137,19 @@ static void aha152x_detach(struct pcmcia_device *link)
>  } /* aha152x_detach */
>  
>  /*====================================================================*/
> +static int aha152x_queue_cs(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
> +{
> +struct pcmcia_device *p_dev;
> +struct device *dev = &SCpnt->device->sdev_gendev;
> +
> +	p_dev = to_pcmcia_dev(dev);
> +	if (p_dev->_removed==1)
> +		return ENODEV;
> +	
> +	return aha152x_queue(SCpnt, done);
> +}
> +
> +/*====================================================================*/
>  
>  #define CS_CHECK(fn, ret) \
>  do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
> @@ -201,6 +214,7 @@ static int aha152x_config_cs(struct pcmcia_device *link)
>  	goto cs_failed;
>      }
>  
> +    host->hostt->queuecommand = aha152x_queue_cs;
>      sprintf(info->node.dev_name, "scsi%d", host->host_no);
>      link->dev_node = &info->node;
>      info->host = host;
> -------------------------------------------------------------------------------------------------------------

This makes sense, but it didn't work:

[   68.771566] pccard: card ejected from slot 0
[   68.781006] sd 2:0:4:0: [sdb] Synchronizing SCSI cache
[   68.786311] (scsi2:4:0) queue: f7f1a950; cmd_len=10 pieces=0 size=0 cmnd=Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[   68.797671] (scsi2:4:0) queue-simple: dir=3, buffer=sglist=00000000, ptr=ADDR=00000000, this_resid=0, bufs_resid=0
[   68.807976] (scsi-1:-1:-1) (aha152x_internal_queue:1075) locking
[   68.813957] (scsi-1:-1:-1) (aha152x_internal_queue:1075) locked
[   68.819853] (scsi-1:-1:-1) expecting:  (busfree)
[   68.824460] (scsi-1:-1:-1) (aha152x_internal_queue:1091) unlocking (locked at aha152x_internal_queue:1075)
[   68.834072] (scsi-1:-1:-1) (aha152x_internal_queue:1091) unlocked
[   69.925905] (scsi2:4:0) abort(f7f1a950)<7>(scsi-1:-1:-1) (show_queues:3041) locking
[   69.933592] (scsi-1:-1:-1) (show_queues:3041) locked
[   69.938538] queue status:
[   69.938539] issue_SC:
[   69.944902] sd 2:0:4:0: f7f1a950: cmnd=(Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[   69.953403] ); request_bufflen=0; resid=0; phase |not issued|; next=0x00000000
[   69.960624] (scsi-1:-1:-1) (show_queues:3045) unlocking (locked at show_queues:3041)
[   69.968360] (scsi-1:-1:-1) (show_queues:3045) unlocked
[   69.973488] current_SC:
[   69.975936] none
[   69.977781] disconnected_SC:
[   70.047619] enabled interrupts ( ENSELDO ENSELDI ENSELINGO ENSWRAP ENSDONE ENSPIORDY ENDMADONE ENSELTIMO ENATNTARG ENPHASEMIS ENBUSFREE ENSCSIPERR ENPHASECHG ENREQINIT )
[   70.063021] (scsi-1:-1:-1) (aha152x_abort:1149) locking
[   70.068236] (scsi-1:-1:-1) (aha152x_abort:1149) locked
[   70.073353] (scsi2:4:0) not yet issued - SUCCESS
[   70.077953] (scsi-1:-1:-1) (aha152x_abort:1159) unlocking (locked at aha152x_abort:1149)
[   70.086020] (scsi-1:-1:-1) (aha152x_abort:1159) unlocked
[   70.091325] (scsi2:4:0) queue: f7f1a950; cmd_len=6 pieces=0 size=0 cmnd=Test Unit Ready 00 00 00 00 00 00
[   70.100971] (scsi2:4:0) queue-simple: dir=3, buffer=sglist=00000000, ptr=ADDR=00000000, this_resid=0, bufs_resid=0
[   70.111274] (scsi-1:-1:-1) (aha152x_internal_queue:1075) locking
[   70.117256] (scsi-1:-1:-1) (aha152x_internal_queue:1075) locked
[   70.123152] (scsi-1:-1:-1) expecting:  (busfree)
[   70.127756] (scsi-1:-1:-1) (aha152x_internal_queue:1091) unlocking (locked at aha152x_internal_queue:1075)
[   70.137368] (scsi-1:-1:-1) (aha152x_internal_queue:1091) unlocked
[   71.127877] (scsi2:4:0) abort(f7f1a950)<7>(scsi-1:-1:-1) (show_queues:3041) locking
[   71.135588] (scsi-1:-1:-1) (show_queues:3041) locked
[   71.140534] queue status:
[   71.140535] issue_SC:
[   71.146895] sd 2:0:4:0: f7f1a950: cmnd=(Test Unit Ready 00 00 00 00 00 00
[   71.153777] ); request_bufflen=0; resid=0; phase |not issued|; next=0x00000000
[   71.160999] (scsi-1:-1:-1) (show_queues:3045) unlocking (locked at show_queues:3041)
[   71.168759] (scsi-1:-1:-1) (show_queues:3045) unlocked
[   71.173887] current_SC:
[   71.176336] none
[   71.178174] disconnected_SC:
[   71.248007] enabled interrupts ( ENSELDO ENSELDI ENSELINGO ENSWRAP ENSDONE ENSPIORDY ENDMADONE ENSELTIMO ENATNTARG ENPHASEMIS ENBUSFREE ENSCSIPERR ENPHASECHG ENREQINIT )
[   71.263415] (scsi-1:-1:-1) (aha152x_abort:1149) locking
[   71.268632] (scsi-1:-1:-1) (aha152x_abort:1149) locked
[   71.273748] (scsi2:4:0) not yet issued - SUCCESS
[   71.278350] (scsi-1:-1:-1) (aha152x_abort:1159) unlocking (locked at aha152x_abort:1149)
[   71.286436] (scsi-1:-1:-1) (aha152x_abort:1159) unlocked
[   71.291750] (scsi2:4:0) aha152x_device_reset(f7f1a950)<7>(scsi-1:-1:-1) (show_queues:3041) locking
[   71.300726] (scsi-1:-1:-1) (show_queues:3041) locked
[   71.305669] queue status:
[   71.305669] issue_SC:
[   71.312029] (scsi-1:-1:-1) (show_queues:3045) unlocking (locked at show_queues:3041)
[   71.319769] (scsi-1:-1:-1) (show_queues:3045) unlocked
[   71.324898] current_SC:
[   71.327340] none
[   71.329182] disconnected_SC:
[   71.399049] enabled interrupts ( ENSELDO ENSELDI ENSELINGO ENSWRAP ENSDONE ENSPIORDY ENDMADONE ENSELTIMO ENATNTARG ENPHASEMIS ENBUSFREE ENSCSIPERR ENPHASECHG ENREQINIT )
[   71.414455] (scsi-1:-1:-1) (aha152x_device_reset:1206) locking
[   71.420274] (scsi-1:-1:-1) (aha152x_device_reset:1206) locked
[   71.425996] (scsi-1:-1:-1) (aha152x_device_reset:1209) unlocking (locked at aha152x_device_reset:1206)
[   71.435275] (scsi-1:-1:-1) (aha152x_device_reset:1209) unlocked
[   71.441208] (scsi2:4:0) queue: f7f1a950; cmd_len=0 pieces=0 size=0 cmnd=Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
[   71.452569] (scsi2:4:0) cannot reuse command
[   75.237817] (scsi-1:-1:-1) (aha152x_device_reset:1218) locking
[   75.243664] (scsi-1:-1:-1) (aha152x_device_reset:1218) locked
[   75.249387] (scsi-1:-1:-1) (aha152x_device_reset:1220) unlocking (locked at aha152x_device_reset:1218)
[   75.258686] (scsi-1:-1:-1) (aha152x_device_reset:1220) unlocked
[   75.264592] (scsi-1:-1:-1) (aha152x_device_reset:1225) locking
[   75.270414] (scsi-1:-1:-1) (aha152x_device_reset:1225) locked
[   75.276137] (scsi-1:-1:-1) (aha152x_device_reset:1246) unlocking (locked at aha152x_device_reset:1225)
[   75.285417] (scsi-1:-1:-1) (aha152x_device_reset:1246) unlocked
[   75.291345] (scsi-1:-1:-1) (aha152x_bus_reset_host:1285) locking
[   75.297340] (scsi-1:-1:-1) (aha152x_bus_reset_host:1285) locked
[   75.303237] scsi2: bus reset<7>(scsi-1:-1:-1) (show_queues:3041) already locked at aha152x_bus_reset_host:1285
[   75.313213] (scsi-1:-1:-1) (show_queues:3041) locking
[   75.318245] BUG: spinlock recursion on CPU#0, scsi_eh_2/6093
[   75.323882]  lock: f7f4a518, .magic: dead4ead, .owner: scsi_eh_2/6093, .owner_cpu: 0
[   75.331591]  [<c0103644>] show_trace_log_lvl+0x1a/0x2f
[   75.336727]  [<c0104031>] show_trace+0x12/0x14
[   75.341170]  [<c0104049>] dump_stack+0x16/0x18
[   75.345615]  [<c01d780a>] spin_bug+0x94/0xdf
[   75.349885]  [<c01d78f7>] _raw_spin_lock+0x35/0x102
[   75.354759]  [<c033d5f0>] _spin_lock_irqsave+0xc/0x11
[   75.359811]  [<f8b78490>] show_queues+0x122/0x478 [aha152x_cs]
[   75.365643]  [<f8b78c72>] aha152x_bus_reset_host+0x1d0/0x3af [aha152x_cs]
[   75.372422]  [<f8b78ece>] aha152x_bus_reset+0xc/0xe [aha152x_cs]
[   75.378423]  [<c027552d>] scsi_try_bus_reset+0x46/0x9a
[   75.383558]  [<c0275f49>] scsi_eh_ready_devs+0x26d/0x41b
[   75.388865]  [<c02768fe>] scsi_error_handler+0x2d6/0x460
[   75.394174]  [<c0129512>] kthread+0x3b/0x61
[   75.398356]  [<c01032bf>] kernel_thread_helper+0x7/0x10
[   75.403580]  =======================
[  211.336753] BUG: spinlock lockup on CPU#0, scsi_eh_2/6093, f7f4a518
[  211.342993]  [<c0103644>] show_trace_log_lvl+0x1a/0x2f
[  211.348127]  [<c0104031>] show_trace+0x12/0x14
[  211.352571]  [<c0104049>] dump_stack+0x16/0x18
[  211.357018]  [<c01d799c>] _raw_spin_lock+0xda/0x102
[  211.361893]  [<c033d5f0>] _spin_lock_irqsave+0xc/0x11
[  211.366943]  [<f8b78490>] show_queues+0x122/0x478 [aha152x_cs]
[  211.372770]  [<f8b78c72>] aha152x_bus_reset_host+0x1d0/0x3af [aha152x_cs]
[  211.379550]  [<f8b78ece>] aha152x_bus_reset+0xc/0xe [aha152x_cs]
[  211.385552]  [<c027552d>] scsi_try_bus_reset+0x46/0x9a
[  211.390686]  [<c0275f49>] scsi_eh_ready_devs+0x26d/0x41b
[  211.395994]  [<c02768fe>] scsi_error_handler+0x2d6/0x460
[  211.401302]  [<c0129512>] kthread+0x3b/0x61
[  211.405483]  [<c01032bf>] kernel_thread_helper+0x7/0x10
[  211.410705]  =======================



> But you will have to totally check me out on that: to_pcmcia_dev() 
> thing above.

Looks OK to me.

> And maybe it is plain lobotomy. I wish sd.c could Just signal the
> SCSI device that it is on the shutdown path.
> 
> Or maybe my original Question. How can a card identify it's un-presence?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
