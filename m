From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: scsi traffic sniffing
Date: Tue, 01 Sep 2009 12:57:51 -0400
Message-ID: <4A9D528F.3090903@redhat.com>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>	 <48e952f40908312313u75e4d00cr3d934f1dbdd1cca9@mail.gmail.com>	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>	 <da824cf30909010906q677e59e8v17dbd3d54cd2614d@mail.gmail.com>	 <48e952f40909010917n7590d364sc4a16317d5e7fb0a@mail.gmail.com> <da824cf30909010948p65d54d8cr744a4b1082f720c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbZIAQ4G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2009 12:56:06 -0400
In-Reply-To: <da824cf30909010948p65d54d8cr744a4b1082f720c3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Jonathan Nell <crtrn13@gmail.com>, linux-scsi@vger.kernel.org

On 09/01/2009 12:48 PM, Grant Grundler wrote:
> +linux-scsi
>
> On Tue, Sep 1, 2009 at 9:17 AM, Jonathan Nell<crtrn13@gmail.com>  wrote:
>    
>> 2009/9/1 Grant Grundler<grundler@google.com>:
>>      
>>> The ideal tool is a protocol analyzer for whatever transport the SCSI
>>> device is attached to.
>>> Here's the slide deck from a talk I once gave at OLS outlining the HW
>>> debug tools:
>>>     http://iou.parisc-linux.org/ols_2001/slides/generated/
>>>
>>> (and "SCSI" in that slide deck often means Parallel SCSI transport.)
>>>
>>> Using the scsi_logging hooks described by Stefan Richter are often enough
>>> to understand where in the process something is failing.
>>>
>>> hth,
>>> grant
>>>
>>>        
>> Unfortunately I need a data dump as well so the scsi_logging hooks
>> aren't going to do the job I believe.
>>      
> IMHO, if a data dump is needed, a logic analyzer is probably the right tool.
> Which transport is being used here?
>
> Folks might have suggestions on tools that are available. Often those can
> be rented for a few days/week at a time.
>    

You can get specific analyzers for storage protocols (Fibre channel, 
s-ata, SAS, etc). They can be pricey (especially if you need to monitor 
multiple devices with a multi-port analyzer)

ric

>
>    
>> My next though was to wrap the
>> SG_IO ioctl call (i.e. trap it in the kernel) and have that dump the
>> data from (struct sg_io_hdr).dxferp. (The ioctl sniffer would be
>> useful anyway for other things).
>>      
> The drawback here is it only tells you what data is being handed to
> the interface card, not what data is sent to the device or how it is
> sent exactly (framing, timing, etc).
>
>
>    
>> Having issues with doing the kernel trap in the newer kernel versions
>> though (trying on 2.6.30). The syscall table is now read-only but for
>> some reason my set_memory_rw() call is failing... Any ideas how to do
>> this properly?
>>      
> Nope, sorry. At least not offhand.
>
> cheers,
> grant
>
>    
>> Here are the relevant bits of code:
>>
>> unsigned long **find_sys_call_table(void)
>> {
>>    unsigned long **sctable;
>>    unsigned long ptr;
>>
>>    sctable = NULL;
>>    for (ptr = (unsigned long)&unlock_kernel;
>>         ptr<  (unsigned long)&loops_per_jiffy;
>>         ptr += sizeof(void *))
>>    {
>>       unsigned long *p;
>>       p = (unsigned long *)ptr;
>>       if (p[__NR_close] == (unsigned long) sys_close)
>>       {
>>          sctable = (unsigned long **)p;
>>          return&sctable[0];
>>       }
>>    }
>>    return NULL;
>> }
>>
>> static int __init scsisniff_init_module(void)
>> {
>>         if ( (sys_call_table = find_sys_call_table()) ) {
>>             real_ioctl = (int(*)(unsigned int fd, unsigned int cmd,
>> unsigned long arg))sys_call_table[__NR_ioctl];
>>
>>                 if ( set_memory_rw( (unsigned
>> long)sys_call_table[__NR_ioctl], 1 ) )
>>                         printk( "set_memory_rw: succeeded\n" );
>>                 else {
>>                         printk( "set_memory_rw: failed!\n" );
>>                       return -1;
>>                 }
>>
>>                 sys_call_table[__NR_ioctl] = (unsigned long)my_ioctl;
>>         }
>>         else {
>>                 return -1;
>>         }
>>       return 0;
>> }
>>
>> This gives me a lovely OOPS:
>>
>> [   71.143742] WARNING: at arch/x86/mm/pageattr.c:833
>> change_page_attr_set_clr+0x1a0/0x400()
>> [   71.143745] Modules linked in: scsi_sniff(+) i915 binfmt_misc drm
>> i2c_algo_bit bridge stp bnep lp snd_hda_codec_analog snd_hda_intel
>> snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm
>> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
>> snd_seq snd_timer snd_seq_device video snd psmouse tpm_infineon tpm
>> ppdev soundcore serio_raw pcspkr intel_agp tpm_bios output heci(C)
>> iTCO_wdt iTCO_vendor_support parport_pc parport snd_page_alloc floppy
>> usbhid usb_storage e1000e
>> [   71.143768] Pid: 3378, comm: insmod Tainted: G         C
>> 2.6.30.4custom-1.0 #6
>> [   71.143769] Call Trace:
>> [   71.143773]  [<ffffffff802da6d5>] ? __vunmap+0xc5/0x110
>> [   71.143775]  [<ffffffff80235200>] ? change_page_attr_set_clr+0x1a0/0x400
>> [   71.143778]  [<ffffffff8024edf8>] warn_slowpath_common+0x78/0xd0
>> [   71.143780]  [<ffffffff8024ee5f>] warn_slowpath_null+0xf/0x20
>> [   71.143783]  [<ffffffff80235200>] change_page_attr_set_clr+0x1a0/0x400
>> [   71.143785]  [<ffffffffa0274050>] ? my_ioctl+0x0/0x120 [scsi_sniff]
>> [   71.143789]  [<ffffffff802a6dcd>] ? marker_update_probe_range+0x1dd/0x2d0
>> [   71.143791]  [<ffffffffa0277000>] ? scsisniff_init_module+0x0/0xf4
>> [scsi_sniff]
>> [   71.143793]  [<ffffffff80235b9a>] set_memory_rw+0x2a/0x30
>> [   71.143796]  [<ffffffff802ff000>] ? sys_fcntl+0x180/0x420
>> [   71.143798]  [<ffffffffa02770bb>] scsisniff_init_module+0xbb/0xf4
>> [scsi_sniff]
>> [   71.143801]  [<ffffffff8020a04c>] do_one_initcall+0x3c/0x180
>> [   71.143804]  [<ffffffff8026b7f3>] ? __blocking_notifier_call_chain+0x63/0x80
>> [   71.143807]  [<ffffffff8027dc0d>] sys_init_module+0xad/0x200
>> [   71.143810]  [<ffffffff80210fc2>] system_call_fastpath+0x16/0x1b
>> [   71.143812] ---[ end trace 5b3efe312296b587 ]---
>> [   71.143958] set_memory_rw: failed!
>>
>>      
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    

