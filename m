From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: gdth new set of patches for 2.6.24 stable
Date: Mon, 18 Feb 2008 11:23:42 +0200
Message-ID: <47B94E9E.8070202@panasas.com>
References: <47B48CAE.2020705@panasas.com>  <47B864CB.4040604@panasas.com> <1203269091.3082.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:19722 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751302AbYBRJ1n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Feb 2008 04:27:43 -0500
In-Reply-To: <1203269091.3082.47.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tobias Oetiker <tobi@oetiker.ch>, allied internet ag- Stefan Priebe <s.priebe@allied-internet.ag>, Jon Chelton <jchelton@ffpglobal.com>, Andrew Morton <akpm@linux-foundation.org>, Dave Milter <davemilter@gmail.com>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, David Brownell <dbrownell@users.sourceforge.net>, Greg Kroah-Hartman <gregkh@suse.de>

On Sun, Feb 17 2008 at 19:24 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Sun, 2008-02-17 at 18:46 +0200, Boaz Harrosh wrote:
>> On Thu, Feb 14 2008 at 20:47 +0200, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>> Submitted are a new set of patches, that fix lots of problems
>>> with the gdth driver.
>>>
>>> It fixes the following problems:
>>> - scan for drives on hosts. (Already in mainline)
>>> - truly fixes the exit/reboot problems but does call flush() before
>>>   reboot.
>>> - fix crash when accessing array with icpcon management application.
>>> - fix crash when doing $ cat /proc/sys/gdth/0.
>>>   This one still has the below WARN_ON in messages (see <gdth_info> below)
>>>   So there is one more thing hiding in there.
>>> - use pci_get_device
>>>   One of the testers requested if we can also put the move to pci_get_device 
>>>   patch with removal of dependency on PCI_LEGACY, to the stable release.
>>>
>>> The patches are for and based on Linux-2.6.24. here is the list of patches:
>>>   [PATCH 1/5] gdth: update deprecated pci_find_device
>>>   [PATCH 2/5] gdth: scan for scsi devices
>>>   [PATCH 3/5] gdth: bugfix for the at-exit problems
>>>   [PATCH 4/5] gdth: fix to internal commands execution
>>>   [PATCH 5/5] gdth: remove gdth cooked up command accessors
>>>
>>> Please all test and report your findings.
>>>
>>> Thanks in advance
>>> Boaz
>>>
>>> ---
>>> <gdth_info>
>>>   WARNING: at arch/x86/kernel/pci-dma_32.c:66 dma_free_coherent()
>>>   Pid: 5501, comm: cat Not tainted 2.6.24 #43
>>>    [<c0107137>] dma_free_coherent+0x93/0x95
>>>    [<c025ef73>] gdth_ioctl_free+0x4c/0x69
>>>    [<c0264a36>] gdth_proc_info+0x165f/0x182c
>>>    [<c0111f7a>] update_curr+0xeb/0xf2
>>>    [<c01132aa>] task_rq_lock+0x29/0x50
>>>    [<c0113706>] try_to_wake_up+0x42/0x342
>>>    [<c0113706>] try_to_wake_up+0x42/0x342
>>>    [<c0111a9f>] __wake_up_common+0x46/0x6d
>>>    [<c0113569>] __wake_up+0x32/0x42
>>>    [<c022dad9>] n_tty_receive_buf+0x2e8/0xe97
>>>    [<c022dad9>] n_tty_receive_buf+0x2e8/0xe97
>>>    [<c0111f0a>] update_curr+0x7b/0xf2
>>>    [<c0112625>] enqueue_task_fair+0x27/0x30
>>>    [<c0111783>] enqueue_task+0xa/0x14
>>>    [<c025e351>] proc_scsi_read+0x29/0x3d
>>>    [<c025e328>] proc_scsi_read+0x0/0x3d
>>>    [<c0189704>] proc_file_read+0x1c6/0x279
>>>    [<c018953e>] proc_file_read+0x0/0x279
>>>    [<c0185eca>] proc_reg_read+0x53/0x71
>>>    [<c0185e77>] proc_reg_read+0x0/0x71
>>>    [<c0159968>] vfs_read+0x85/0x11b
>>>    [<c0159d9d>] sys_read+0x41/0x6a
>>>    [<c0102822>] sysenter_past_esp+0x5f/0x85
>>>  </gdth_info>
>>> -
>> James hi.
>>
>> All my testers have reported back that with these 5 patches applied they can
>> now run with a 2.6.24 kernel the same way they ran before. However there is
>> that reported issue, with the dma_free_coherent WARN_ON (above). The code was 
>> like that from day one and it is a very old issue, however it is a regression 
>> because 2.6.24 introduced that new WARN_ON.
>> (infamous commit aa24886e379d2b641c5117e178b15ce1d5d366ba)
>> >From posts on lkml and even recent one in linux-scsi about the arcmsr driver
>> it looks that all a driver can do is work around it with different kernel mechanisms
>> and driver rewrites. I'm afraid I need your help here. I'm not sure I understand
>> why does the gdth driver uses the pci_{alloc,free}_consistent() API's, and what
>> is needed to replace it. Could you please have a look in gdth_proc.c and also in
>> gdth.c for all the places that call gdth_ioctl_alloc/gdth_ioctl_free, and advise
>> what can I do in it's place. Please bear in mind that we need it for 2.6.24, as
>> a bugfix.
>>
>> Apart from the above issue, please accept patches 3,4,5 above they have now
>> been tested and are reported to bring broken system back to production.
>> (Given that you approve off course). And mark them for inclusion to the
>> 2.6.24 stable releases. (Or is there some thing that I should do)
>>
>> ---
>> Meanwhile on x86 systems I understand the WARN_ON is cosmetic, and does not
>> pose any harm. Some people have reported stability with temporarily disabling
>> it. For testers that want to try, here it is below. At your own risk.
> 
> Isn't this the correct fix?  pscratch is a permanent address (it's
> allocated at boot time and never changes).  All you need the smp lock
> for is mediating the scratch in use flag.
> 
> James
> 
> diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
> index de57734..ce0228e 100644
> --- a/drivers/scsi/gdth_proc.c
> +++ b/drivers/scsi/gdth_proc.c
> @@ -694,15 +694,13 @@ static void gdth_ioctl_free(gdth_ha_str *ha, int size, char *buf, ulong64 paddr)
>  {
>      ulong flags;
>  
> -    spin_lock_irqsave(&ha->smp_lock, flags);
> -
>      if (buf == ha->pscratch) {
> +	spin_lock_irqsave(&ha->smp_lock, flags);
>          ha->scratch_busy = FALSE;
> +	spin_unlock_irqrestore(&ha->smp_lock, flags);
>      } else {
>          pci_free_consistent(ha->pdev, size, buf, paddr);
>      }
> -
> -    spin_unlock_irqrestore(&ha->smp_lock, flags);
>  }
>  
>  #ifdef GDTH_IOCTL_PROC
> 
> 
> -

James
You are bung on the money. It was tested and it works. So simple, I was 
thinking it was accessed by DMA and freed at interrupt. But no, just a 
simple lock like this.

So that's it then, all reported problems with gdth are now resolved. Please
Submit above together with the other patches.

Do I need to do anything else to get it into 2.6.24.x stable releases?

Thanks for everything
Boaz
