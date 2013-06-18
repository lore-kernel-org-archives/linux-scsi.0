From: Paul Guo <ggang@tilera.com>
Subject: Re: Re: [SCSI] mvsas: Fix the kernel panic due to unaligned data
 access
Date: Tue, 18 Jun 2013 17:50:47 +0800
Message-ID: <51C02D77.4010603@tilera.com>
References: <5189F864.5080808@tilera.com> <1370794996.2097.12.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usmamail.tilera.com ([12.216.194.151]:18492 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3FRJu5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jun 2013 05:50:57 -0400
In-Reply-To: <1370794996.2097.12.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org

Hi James,

Thanks for the reply. See more below.

> On Wed, 2013-05-08 at 15:01 +0800, Paul Guo wrote:
>> It's easy to find the address and symbol that causes the unalignd data
>> access according to the stack dump information. The following small
>> patch will fix it.
> 
> Do you have the panic log?  because it sounds like a bug in your
> platform code.  All platforms have to support unaligned accesses because
> some of the kernel parsers generate them as well.  You can see examples
> of how to do this in e.g. arch/parisc/kernel/unaligned.c

Yes, our HW has the trap type for unaligned data access. Our kernel
(see arch/tile/kernel/unaligned.c) has the ability to do fixup for
user unaligned data access but we have limited ability to do fixup
for kernel unaligned data access (In theory we can do it better but
the work is more complex), and I'm not sure other platforms which do
not support unaligned data access on HW could do kernel data fixup or
not, but many kernel components have had considered the alignment for
either performance or functionality purpose. At least we have run well
with network stack, storage io stack, etc. I have to admit that
there seems to exist kernel code that does not consider unaligned
data access much, but why not try to fix them, for whatever reason.

Following is the panic stack, from the PC register I can easily find
which code line causes the unaligned data access.

Pid: 0, comm:              swapper, CPU: 1
  r0 : 0xfffffe43f67e2c94 r1 : 0xfffffe43f86b2450 r2 : 0xfffffe43f86b2450
  r3 : 0xfffffe43f86b2440 r4 : 0x0000000000000000 r5 : 0x0000000000000000
  r6 : 0x0000000000000000 r7 : 0x0000000000000000 r8 : 0x0000000000000000
  r9 : 0x0000000000000000 r10: 0xfffffe43f86b2450 r11: 0xfffffe43f86b2448
  r12: 0xe000003780f29b84 r13: 0x1fffffc87f0d647c r14: 0x0000000000000001
  r15: 0x0000000000000080 r16: 0x0000000000000040 r17: 0x0000000000000002
  r18: 0x0000000000000001 r19: 0xfffffe43f86b2448 r20: 0x0000000000000001
  r21: 0x0000000000020000 r22: 0xfffffe43ffedfaa8 r23: 0x0000000000020000
  r24: 0xfffffe43ffedfab0 r25: 0xfffffe43ffedfaf0 r26: 0xfffffe43ffedfab8
  r27: 0xfffffe03f8a64648 r28: 0x00000000000245f0 r29: 0x000000000000245f
  r30: 0xfffffe43f86b2300 r31: 0xfffffe03f8a40000 r32: 0x0000000000000001
  r33: 0xfffffe03f8a42590 r34: 0x0000000000000001 r35: 0x0000000000030001
  r36: 0xfffffe43f86b2318 r37: 0xfffffe03f8a40058 r38: 0xfffffe03f8a64610
  r39: 0x0000000000000001 r40: 0x0000000000000000 r41: 0x0000000000000000
  r42: 0xfffffe0000a856f8 r43: 0xfffffe00009a78d8 r44: 0xfffffe00008e1298
  r45: 0xfffffe0000a70080 r46: 0x0000000000000001 r47: 0x0000000000000000
  r48: 0x0000000000000000 r49: 0x0000000000000000 r50: 0x0000000000000000
  r51: 0x0000000000000000 r52: 0xfffffe43ffedfc40 tp : 0x000001f4ff730000  
  sp : 0xfffffe43ffedfa90 lr : 0xfffffff7002abec0 pc : 0xfffffff7002ac370 
  ex1: 1     faultnum: 17
Starting stack dump of tid 0, pid 0 (swapper) on cpu 1 at cycle 341465978177
  frame 0: 0xfffffff7002ac370 mvs_slot_complete+0x5f0/0x12a0 (sp 0xfffffe43ffedfa90)
  frame 1: 0xfffffff7002abec0 mvs_slot_complete+0x140/0x12a0 (sp 0xfffffe43ffedfa90)
  frame 2: 0xfffffff7005cc840 mvs_int_rx+0x140/0x2a0 (sp 0xfffffe43ffedfb00)
  frame 3: 0xfffffff7005bbaf0 mvs_94xx_isr+0xd8/0x2b8 (sp 0xfffffe43ffedfb68)
  frame 4: 0xfffffff700658ba0 mvs_tasklet+0x128/0x1f8 (sp 0xfffffe43ffedfba8)
  frame 5: 0xfffffff7003e8230 tasklet_action+0x178/0x2c8 (sp 0xfffffe43ffedfbe0)
  frame 6: 0xfffffff700103850 __do_softirq+0x210/0x398 (sp 0xfffffe43ffedfc40)
  frame 7: 0xfffffff700180308 do_softirq+0xc8/0x140 (sp 0xfffffe43ffedfcd8)
  frame 8: 0xfffffff7000bd7f0 irq_exit+0xb0/0x158 (sp 0xfffffe43ffedfcf0)
  frame 9: 0xfffffff70013fa58 tile_dev_intr+0x1d8/0x2f0 (sp 0xfffffe43ffedfd00)
  frame 10: 0xfffffff70044ca78 handle_interrupt+0x270/0x278 (sp 0xfffffe43ffedfd40)
   <interrupt 30 while in kernel mode>
   frame 11: 0xfffffff700143e68 _cpu_idle_nap+0x0/0x18 (sp 0xfffffe43ffedffb0)
   frame 12: 0xfffffff700482480 cpu_idle+0x310/0x428 (sp 0xfffffe43ffedffb0)
Stack dump complete Kernel panic - not syncing: 
 Kernel unalign fault running the idle task!
 Starting stack dump of tid 0, pid 0 (swapper) on cpu 1 at cycle 341586172541
   frame 0: 0xfffffff700140ee0 dump_stack+0x0/0x20 (sp 0xfffffe43ffedf420)
   frame 1: 0xfffffff700283270 panic+0x150/0x3a0 (sp 0xfffffe43ffedf420)
   frame 2: 0xfffffff70012bff8 jit_bundle_gen+0xfd8/0x27e0 (sp 0xfffffe43ffedf4c8)
   frame 3: 0xfffffff7003b5b68 do_unaligned+0xc0/0x5a0 (sp 0xfffffe43ffedf710)
   frame 4: 0xfffffff70044ca78 handle_interrupt+0x270/0x278 (sp 0xfffffe43ffedf840)
   <interrupt 17 while in kernel mode>
   frame 5: 0xfffffff7002ac370 mvs_slot_complete+0x5f0/0x12a0 (sp 0xfffffe43ffedfa90)
   frame 6: 0xfffffff7002abec0 mvs_slot_complete+0x140/0x12a0 (sp 0xfffffe43ffedfa90)
   frame 7: 0xfffffff7005cc840 mvs_int_rx+0x140/0x2a0 (sp 0xfffffe43ffedfb00)
   frame 8: 0xfffffff7005bbaf0 mvs_94xx_isr+0xd8/0x2b8 (sp 0xfffffe43ffedfb68)
   frame 9: 0xfffffff700658ba0 mvs_tasklet+0x128/0x1f8 (sp 0xfffffe43ffedfba8)
   frame 10: 0xfffffff7003e8230 tasklet_action+0x178/0x2c8 (sp 0xfffffe43ffedfbe0)
   frame 11: 0xfffffff700103850 __do_softirq+0x210/0x398 (sp 0xfffffe43ffedfc40)
   frame 12: 0xfffffff700180308 do_softirq+0xc8/0x140 (sp 0xfffffe43ffedfcd8)
   frame 13: 0xfffffff7000bd7f0 irq_exit+0xb0/0x158 (sp 0xfffffe43ffedfcf0)
   frame 14: 0xfffffff70013fa58 tile_dev_intr+0x1d8/0x2f0 (sp 0xfffffe43ffedfd00)
   frame 15: 0xfffffff70044ca78 handle_interrupt+0x270/0x278 (sp 0xfffffe43ffedfd40)
   <interrupt 30 while in kernel mode>
   frame 16: 0xfffffff700143e68 _cpu_idle_nap+0x0/0x18 (sp 0xfffffe43ffedffb0)
   frame 17: 0xfffffff700482480 cpu_idle+0x310/0x428 (sp 0xfffffe43ffedffb0)
Stack dump complete Client requested halt.
 
>> This change is harmless for platforms (like x86/x64) which support
>> unaligned data access but is critical for platforms those do not support
>> unaligned data access (like our platform: arch/tile).
>>
>> I sent the patch but did not ping the status. I sync-up the workspace
>> and re-generate the patch again. Feel free to give me any feedback. It's
>> really annoying to maintain the change internally.
> 
> First off, you didn't compile this on x86, did you?
> 
>> @@ -39,6 +39,7 @@
>>  #include <linux/irq.h>
>>  #include <linux/slab.h>
>>  #include <linux/vmalloc.h>
>> +#include <linux/unaligned.h>
>>  #include <scsi/libsas.h>
>>  #include <scsi/scsi.h>
>>  #include <scsi/scsi_tcq.h>
> 
> Causes
> 
>   CC [M]  drivers/scsi/scsi_sysfs.o
> In file included from drivers/scsi/mvsas/mv_sas.c:26:0:
> drivers/scsi/mvsas/mv_sas.h:41:29: fatal error: linux/unaligned.h: No
> such file or directory
> 
> because it should be asm/unaligned.h.  If it actually compiles on your
> platform, you've got a serious problem with the way include paths work.

Yes, my bad. Sorry for that. I forgot to try popular x86.

> Secondly, the reason we have get_unaligned() macros is to speed up
> things by avoiding the trap when we know the data is unaligned, but it
> is really inefficient on most platforms because it will unroll a u64
> deref into 8 single byte loads.  In this case, the DMA buffer looks to
> be a word file, so the below is probably how it should be done.  Notice
> the efficient access in the fast path and the inefficient one in the
> error path.

OK, you change is better. I recompiled it on our platform successively.
I assume you've compiled it on x86, right?

Thanks,
Paul

> James
> 
> ---
> 
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
> index f14665a..6b1b4e9 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -1857,11 +1857,16 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
>  		goto out;
>  	}
>  
> -	/* error info record present */
> -	if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
> +	/*
> +	 * error info record present; slot->response is 32 bit aligned but may
> +	 * not be 64 bit aligned, so check for zero in two 32 bit reads
> +	 */
> +	if (unlikely((rx_desc & RXQ_ERR)
> +		     && (*((u32 *)slot->response)
> +			 || *(((u32 *)slot->response) + 1)))) {
>  		mv_dprintk("port %d slot %d rx_desc %X has error info"
>  			"%016llX.\n", slot->port->sas_port.id, slot_idx,
> -			 rx_desc, (u64)(*(u64 *)slot->response));
> +			 rx_desc, get_unaligned_le64(slot->response));
>  		tstat->stat = mvs_slot_err(mvi, task, slot_idx);
>  		tstat->resp = SAS_TASK_COMPLETE;
>  		goto out;
> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
> index 60e2fb7..d6b19dc 100644
> --- a/drivers/scsi/mvsas/mv_sas.h
> +++ b/drivers/scsi/mvsas/mv_sas.h
> @@ -39,6 +39,7 @@
>  #include <linux/irq.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> +#include <asm/unaligned.h>
>  #include <scsi/libsas.h>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_tcq.h>
> 
> 
