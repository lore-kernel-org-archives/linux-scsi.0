From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [RFC] How to fix an async scan - 'rmmod --wait' race?
Date: Thu, 17 May 2012 16:51:50 +0200
Message-ID: <4FB51086.3060406@redhat.com>
References: <4F7DA4F8.90104@redhat.com> <4F86CF34.2000906@redhat.com>   <4F8EF05F.8080307@redhat.com>  <1337244177.2926.21.camel@dabdike.int.hansenpartnership.com>  <4FB4BCEB.60506@acm.org> <1337245278.30498.2.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966579Ab2EQOwJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 10:52:09 -0400
In-Reply-To: <1337245278.30498.2.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <mchristi@redhat.com>, stefanr@s5r6.in-berlin.de

On 05/17/2012 11:01 AM, James Bottomley wrote:
> On Thu, 2012-05-17 at 08:55 +0000, Bart Van Assche wrote:
>> On 05/17/12 08:42, James Bottomley wrote:
>>
>>> On Wed, 2012-04-18 at 18:48 +0200, Tomas Henzl wrote:
>>>> On 04/12/2012 02:48 PM, Tomas Henzl wrote:
>>>>> Hi,
>>>>>
>>>>> the first patch waited in scsi_remove_host was until the scan thread ends, some flags were set
>>>>> so the thread could be aborted prematurely. 
>>>>>
>>>>> This patch uses a try_module_get to lock the module and prevents a rmmod while it's locked.
>>>>> The disadvantage is that in the protection we use again the same host template (shost->hostt->module;),
>>>>> and when this were not valid I think and oops in try_module_get will follow. It seems to me
>>>>> that the LLDs use scsi_scan_host only in the initial attach function so this is safe now, but ..
>>>> Actually I did some testing and it is not so stable as it should be - after 'modprobe mpt2sas && rmmod --wait mpt2sas'
>>>> I sometimes see:
>>>>
>>>> [  215.126197] mpt2sas version 12.100.00.00 loaded                                                                                                                                         
>>>> [  215.127509] scsi8 : Fusion MPT SAS Host                                                                                                                                                 
>>>> [  215.128058] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (6096496 kB)                                                                                                   
>>>> [  215.128167] mpt2sas 0000:03:00.0: irq 69 for MSI/MSI-X
>>>> [  215.128190] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 69
>>>> [  215.128192] mpt2sas0: iomem(0x00000000f7040000), mapped(0xffffc90006010000), size(16384)
>>>> [  215.128194] mpt2sas0: ioport(0x000000000000d000), size(256)
>>>> [  215.241249] mpt2sas0: Allocated physical memory: size(3988 kB)
>>>> [  215.241253] mpt2sas0: Current Controller Queue Depth(1753), Max Controller Queue Depth(2000)
>>>> [  215.241256] mpt2sas0: Scatter Gather Elements per IO(128)
>>>> [  215.300281] mpt2sas0: LSISAS2008: FWVersion(11.00.00.00), ChipRevision(0x01), BiosVersion(07.23.01.00)
>>>> [  215.300284] mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
>>>> [  215.300602] mpt2sas0: sending port enable !!
>>>> [  216.854720] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b0006b8530), phys(8)
>>>> [  222.978469] mpt2sas0: port enable: SUCCESS
>>>> [  222.980104] scsi 8:0:0:0: Direct-Access     SEAGATE  ST9146852SS      0005 PQ: 0 ANSI: 5
>>>> [  222.980113] scsi 8:0:0:0: SSP: handle(0x0009), sas_addr(0x5000c5001ac10319), phy(2), device_name(0x5000c5001ac10318)
>>>> [  222.980117] scsi 8:0:0:0: SSP: enclosure_logical_id(0x500605b0006b8530), slot(2)
>>>> [  222.980121] scsi 8:0:0:0: qdepth(254), tagged(1), simple(0), ordered(0), scsi_level(6), cmd_que(1)
>>>> [  222.981149] mpt2sas version 12.100.00.00 unloading
>>>> [  222.981467] BUG: unable to handle kernel NULL pointer dereference at 0000000000000079
>>>> [  222.981483] IP: [<ffffffff811f0c45>] sysfs_create_dir+0x35/0xc0
>>>> [  222.981499] PGD 0 
>>>> [  222.981507] Oops: 0000 [#1] SMP 
>>>> [  222.981518] CPU 0 
>>>> [  222.981522] Modules linked in: mpt2sas(-) lockd bnep bluetooth be2iscsi iscsi_boot_sysfs bnx2i cnic uio ip6t_REJECT cxgb4i cxgb4 cxgb3i
>>>> [  222.981571] mpt2sas0: removing handle(0x0009), sas_addr(0x5000c5001ac10319)
>>>> [  222.981583]  libcxgbi cxgb3 nf_conntrack_ipv6 nf_defrag_ipv6 mdio nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep i7core_edac edac_core snd_seq snd_seq_device hp_wmi iTCO_wdt iTCO_vendor_support snd_pcm snd_timer snd microcode soundcore snd_page_alloc sparse_keymap serio_raw tg3 rfkill uinput sunrpc firewire_ohci firewire_core crc_itu_t scsi_transport_sas raid_class nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded: mpt2sas]
>>>> [  222.981790] 
>>>> [  222.981796] Pid: 1311, comm: scsi_scan_8 Not tainted 3.3.0 #21 Hewlett-Packard HP Z400 Workstation/0B4Ch
>>>> [  222.981815] RIP: 0010:[<ffffffff811f0c45>]  [<ffffffff811f0c45>] sysfs_create_dir+0x35/0xc0
>>>> [  222.981829] RSP: 0018:ffff8801929a7ce0  EFLAGS: 00010246
>>>> [  222.981837] RAX: ffff880190c65810 RBX: ffff880190d5a438 RCX: 0000000000000000
>>>> [  222.981846] RDX: ffff880199034c60 RSI: ffff880192a81018 RDI: ffff880190d5a438
>>>> [  222.981854] RBP: ffff8801929a7d10 R08: ffff880199034c60 R09: ffff880195516d80
>>>> [  222.981863] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
>>>> [  222.981872] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880190d5a400
>>>> [  222.981881] FS:  0000000000000000(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
>>>> [  222.981891] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>> [  222.981899] CR2: 0000000000000079 CR3: 0000000001c05000 CR4: 00000000000006f0
>>>> [  222.981913] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>> [  222.981922] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>>> [  222.981932] Process scsi_scan_8 (pid: 1311, threadinfo ffff8801929a6000, task ffff88018b6e8000)
>>>> [  222.981941] Stack:
>>>> [  222.981946]  ffff8801929a7d30 ffffffff810583a5 ffff8801929a7d10 ffff880190d5a438
>>>> [  222.981965] mpt2sas0: sending diag reset !!
>>>> [  222.983072]  ffff880190c65810 0000000000000000 ffff8801929a7d60 ffffffff812c2e6e
>>>> [  222.983644]  ffff8801929a7d66 0044b82fa09b5a53 ffff8801929a7dd0 ffff880190d5a438
>>>> [  222.984215] Call Trace:
>>>> [  222.984776]  [<ffffffff810583a5>] ? console_unlock+0x1f5/0x270
>>>> [  222.985334]  [<ffffffff812c2e6e>] kobject_add_internal+0xae/0x250
>>>> [  222.985888]  [<ffffffff812c3417>] kobject_add+0x67/0xc0
>>>> [  222.986461]  [<ffffffff8139eb32>] device_add+0x102/0x6c0
>>>> [  222.987050]  [<ffffffff813c8288>] scsi_sysfs_add_sdev+0x198/0x340
>>>> [  222.987643]  [<ffffffff813c6b24>] do_scan_async+0x84/0x170
>>>> [  222.988241]  [<ffffffff813c6aa0>] ? do_scsi_scan_host+0xa0/0xa0
>>>> [  222.988845]  [<ffffffff81079c63>] kthread+0x93/0xa0
>>>> [  222.989443]  [<ffffffff815fd1e4>] kernel_thread_helper+0x4/0x10
>>>> [  222.990046]  [<ffffffff81079bd0>] ? kthread_freezable_should_stop+0x70/0x70
>>>> [  222.990655]  [<ffffffff815fd1e0>] ? gs_change+0x13/0x13
>>>> [  222.991256] Code: 83 ec 18 66 66 66 66 90 48 85 ff 48 89 fb 0f 84 98 00 00 00 48 8b 47 18 49 c7 c4 20 0e c5 81 48 85 c0 74 04 4c 8b 60 30 45 31 ed <41> 80 7c 24 79 00 75 5b 48 89 df e8 8b 2c 0d 00 48 85 c0 74 66 
>>>> [  222.992012] RIP  [<ffffffff811f0c45>] sysfs_create_dir+0x35/0xc0
>>>> [  222.992626]  RSP <ffff8801929a7ce0>
>>>> [  222.993265] CR2: 0000000000000079
>>>> [  222.993943] ---[ end trace 024b7be18310b205 ]---
>>>> [  224.049467] mpt2sas0: diag reset: SUCCESS
>>>>
>>>> This means that the module protection with try_module_get doesn't work, the driver removal starts again
>>>> in the middle of a scan.
>>> Not necessarily; it means that the remove proceeded too far before it
>>> got to the sync point, which is the scan mutex acquisition in
>>> scsi_remove_host().  The fix is to make sure outstanding async work is
>>> completed before beginning the removal.  That can't really be done in
>>> SCSI, but it looks like this might be the trick.
>>>
>>> James
>>>
>>> ---
>>> diff --git a/drivers/base/driver.c b/drivers/base/driver.c
>>> index 3ec3896..246e652 100644
>>> --- a/drivers/base/driver.c
>>> +++ b/drivers/base/driver.c
>>> @@ -10,6 +10,7 @@
>>>   *
>>>   */
>>>  
>>> +#include <linux/async.h>
>>>  #include <linux/device.h>
>>>  #include <linux/module.h>
>>>  #include <linux/errno.h>
>>> @@ -199,6 +200,13 @@ EXPORT_SYMBOL_GPL(driver_register);
>>>   */
>>>  void driver_unregister(struct device_driver *drv)
>>>  {
>>> +	/*
>>> +	 * make sure all async bits that may be running have completed the way
>>> +	 * this works is that try_module_get() now fails, so new async work
>>> +	 * should take a reference to the module which now fails, so it should
>>> +	 * be safe to remove the driver.
>>> +	 */
>>> +	async_synchronize_full();
>>>  	if (!drv || !drv->p) {
>>>  		WARN(1, "Unexpected driver unregister!\n");
>>>  		return;
Is this safe? I mean, is it possible that a new scan starts after the
async_synchronize_full() ends?
I wish this were fixed by fixing the real root of this problem which lies
in scssi_device_get:
int scsi_device_get(struct scsi_device *sdev)
{
        if (sdev->sdev_state == SDEV_DEL)
                return -ENXIO;
        if (!get_device(&sdev->sdev_gendev))
                return -ENXIO;
        /* We can fail this if we're doing SCSI operations
         * from module exit (like cache flush) */
        try_module_get(sdev->host->hostt->module);
here  ^ by ignoring the return value. This is why rmmod --wait causes the problem
and likely every other process which calls scsi_device_get would show the same bug.

>>
>> I'm hoping there exists another way to fix this. A patch like the above
>> will cause driver_unregister() to take forever if the rate at which new
>> devices are added is high enough. As far as I understand
>> async_synchronize_full() the time during which this function waits is
>> extended every time scanning of a newly added device starts.
> module removal isn't really supposed to be a common occurrence.  Rusty
> even argued it's impossible to fix the races, which is why there's a
> kernel option to disallow it.  I don't think inserting a checkpoint in
> the async domain for module removal is unreasonable.
>
> If it shows up as unreasonable in practise, we can label all the async
> work by THIS_MODULE and implement async_synchronize_module(THIS_MODULE)
> which would limit it, but I don't really think there'll be a huge
> problem.
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


