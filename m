From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [RFC] How to fix an async scan - 'rmmod --wait' race?
Date: Fri, 25 May 2012 17:13:18 +0200
Message-ID: <4FBFA18E.9040904@redhat.com>
References: <4F7DA4F8.90104@redhat.com> <4F86CF34.2000906@redhat.com>    <4F8EF05F.8080307@redhat.com>   <1337244177.2926.21.camel@dabdike.int.hansenpartnership.com>   <4FB4BCEB.60506@acm.org>  <1337245278.30498.2.camel@dabdike.int.hansenpartnership.com>  <4FB51086.3060406@redhat.com> <1337681133.2932.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2EYPNg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 11:13:36 -0400
In-Reply-To: <1337681133.2932.4.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>, Mike Christie <mchristi@redhat.com>, stefanr@s5r6.in-berlin.de

On 05/22/2012 12:05 PM, James Bottomley wrote:
> On Thu, 2012-05-17 at 16:51 +0200, Tomas Henzl wrote:
>>>>> diff --git a/drivers/base/driver.c b/drivers/base/driver.c
>>>>> index 3ec3896..246e652 100644
>>>>> --- a/drivers/base/driver.c
>>>>> +++ b/drivers/base/driver.c
>>>>> @@ -10,6 +10,7 @@
>>>>>   *
>>>>>   */
>>>>>  
>>>>> +#include <linux/async.h>
>>>>>  #include <linux/device.h>
>>>>>  #include <linux/module.h>
>>>>>  #include <linux/errno.h>
>>>>> @@ -199,6 +200,13 @@ EXPORT_SYMBOL_GPL(driver_register);
>>>>>   */
>>>>>  void driver_unregister(struct device_driver *drv)
>>>>>  {
>>>>> +	/*
>>>>> +	 * make sure all async bits that may be running have completed the way
>>>>> +	 * this works is that try_module_get() now fails, so new async work
>>>>> +	 * should take a reference to the module which now fails, so it should
>>>>> +	 * be safe to remove the driver.
>>>>> +	 */
>>>>> +	async_synchronize_full();
>>>>>  	if (!drv || !drv->p) {
>>>>>  		WARN(1, "Unexpected driver unregister!\n");
>>>>>  		return;
>> Is this safe? I mean, is it possible that a new scan starts after the
>> async_synchronize_full() ends?
> Not really, because the module is now removing, so the try module get
> guard fails
The async_synchronize_full : "This function returns when there are no asynchronous
function calls in the system."
The point is that the async scan is not started with async_schedule but with kthread_run,
so the synchronization doesn't work in this case (an error log is attached at bottom).
>
>> I wish this were fixed by fixing the real root of this problem which lies
>> in scssi_device_get:
>> int scsi_device_get(struct scsi_device *sdev)
>> {
>>         if (sdev->sdev_state == SDEV_DEL)
>>                 return -ENXIO;
>>         if (!get_device(&sdev->sdev_gendev))
>>                 return -ENXIO;
>>         /* We can fail this if we're doing SCSI operations
>>          * from module exit (like cache flush) */
>>         try_module_get(sdev->host->hostt->module);
>> here  ^ by ignoring the return value. This is why rmmod --wait causes the problem
>> and likely every other process which calls scsi_device_get would show the same bug.
> I'm not sure how ... this has to be usable in the teardown path by which
> point try_module_get will fail (as the comment says).  What do you
> propose?
I wish I would knew, but everything seems to be too much complicated, one idea
was to use in the teardown path new special functions only for this use, but...

Tomas

>
> James
>
>

May 25 04:25:54 localhost kernel: [  461.525209] BUG: unable to handle kernel NULL pointer dereference at 0000000000000079
May 25 04:25:54 localhost kernel: [  461.525242] IP: [<ffffffff811f0c45>] sysfs_create_dir+0x35/0xc0
May 25 04:25:54 localhost kernel: [  461.525259] PGD 0 
May 25 04:25:54 localhost kernel: [  461.525267] Oops: 0000 [#1] SMP 
May 25 04:25:54 localhost kernel: [  461.525278] CPU 0 
May 25 04:25:54 localhost kernel: [  461.525283] Modules linked in: mpt2sas(-) lockd bnep bluetooth be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i libcxgbi cxgb3 mdio ib_iser
May 25 04:25:54 localhost kernel: [  461.525342] mpt2sas0: removing handle(0x0009), sas_addr(0x5000c5001ac10319)
May 25 04:25:54 localhost kernel: [  461.525355]  rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ip6table_filter ip6_tables i7core_edac edac_core hp_wmi iTCO_wdt snd_hda_codec_realtek tg3 iTCO_vendor_support snd_hda_intel snd_hda_codec snd_hwdep scsi_transport_sas raid_class snd_seq snd_seq_device snd_pcm snd_timer sparse_keymap rfkill serio_raw snd soundcore snd_page_alloc microcode sunrpc uinput firewire_ohci firewire_core crc_itu_t nouveau ttm drm_kms_helper drm i2c_core mxm_wmi video wmi [last unloaded: mpt2sas]
May 25 04:25:54 localhost kernel: [  461.525640] 
May 25 04:25:54 localhost kernel: [  461.525651] Pid: 1341, comm: scsi_scan_12 Not tainted 3.3.0 #4 Hewlett-Packard HP Z400 Workstation/0B4Ch
May 25 04:25:54 localhost kernel: [  461.525669] RIP: 0010:[<ffffffff811f0c45>]  [<ffffffff811f0c45>] sysfs_create_dir+0x35/0xc0
May 25 04:25:54 localhost kernel: [  461.525685] RSP: 0018:ffff88019419bce0  EFLAGS: 00010246
May 25 04:25:54 localhost kernel: [  461.525693] RAX: ffff880192ad2010 RBX: ffff880192ad5438 RCX: 0000000000000000
May 25 04:25:54 localhost kernel: [  461.525702] RDX: ffff880199034c60 RSI: ffff880192ad0018 RDI: ffff880192ad5438
May 25 04:25:54 localhost kernel: [  461.525711] RBP: ffff88019419bd10 R08: ffff880199034c60 R09: ffff880187c81980
May 25 04:25:54 localhost kernel: [  461.525720] R10: 0000000000000400 R11: 0000000000010140 R12: 0000000000000000
May 25 04:25:54 localhost kernel: [  461.525728] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880192ad5400
May 25 04:25:54 localhost kernel: [  461.525738] FS:  0000000000000000(0000) GS:ffff88019fc00000(0000) knlGS:0000000000000000
May 25 04:25:54 localhost kernel: [  461.525748] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 25 04:25:54 localhost kernel: [  461.525756] CR2: 0000000000000079 CR3: 0000000001c05000 CR4: 00000000000006f0
May 25 04:25:54 localhost kernel: [  461.525765] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 25 04:25:54 localhost kernel: [  461.525774] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 25 04:25:54 localhost kernel: [  461.525788] Process scsi_scan_12 (pid: 1341, threadinfo ffff88019419a000, task ffff880187ca9730)
May 25 04:25:54 localhost kernel: [  461.525796] mpt2sas0: sending diag reset !!
May 25 04:25:54 localhost kernel: [  461.525805] Stack:
May 25 04:25:54 localhost kernel: [  461.525810]  ffff88019419bd30 ffffffff81088c0e ffff88019419bd50 ffff880192ad5438
May 25 04:25:54 localhost kernel: [  461.525829]  ffff880192ad2010 0000000000000000 ffff88019419bd60 ffffffff812c2e6e
May 25 04:25:54 localhost kernel: [  461.526446]  0000000100027998 ffffffff81e487c0 ffff88019419bd40 ffff880192ad5438
May 25 04:25:54 localhost kernel: [  461.526992] Call Trace:
May 25 04:25:54 localhost kernel: [  461.527534]  [<ffffffff81088c0e>] ? try_to_wake_up+0x1be/0x2b0
May 25 04:25:54 localhost kernel: [  461.528075]  [<ffffffff812c2e6e>] kobject_add_internal+0xae/0x250
May 25 04:25:54 localhost kernel: [  461.528612]  [<ffffffff812c3417>] kobject_add+0x67/0xc0
May 25 04:25:54 localhost kernel: [  461.529150]  [<ffffffff8139eb32>] device_add+0x102/0x6c0
May 25 04:25:54 localhost kernel: [  461.529714]  [<ffffffff815f2a6b>] ? wait_for_common+0x3b/0x170
May 25 04:25:54 localhost kernel: [  461.530300]  [<ffffffff813c81e8>] scsi_sysfs_add_sdev+0x198/0x340
May 25 04:25:54 localhost kernel: [  461.530886]  [<ffffffff813c6aa4>] do_scan_async+0x84/0x160
May 25 04:25:54 localhost kernel: [  461.531473]  [<ffffffff813c6a20>] ? do_scsi_scan_host+0xa0/0xa0
May 25 04:25:54 localhost kernel: [  461.532063]  [<ffffffff81079c63>] kthread+0x93/0xa0
May 25 04:25:54 localhost kernel: [  461.532647]  [<ffffffff815fd124>] kernel_thread_helper+0x4/0x10
May 25 04:25:54 localhost kernel: [  461.533231]  [<ffffffff81079bd0>] ? kthread_freezable_should_stop+0x70/0x70
May 25 04:25:54 localhost kernel: [  461.533822]  [<ffffffff815fd120>] ? gs_change+0x13/0x13
May 25 04:25:54 localhost kernel: [  461.534409] Code: 83 ec 18 66 66 66 66 90 48 85 ff 48 89 fb 0f 84 98 00 00 00 48 8b 47 18 49 c7 c4 20 0e c5 81 48 85 c0 74 04 4c 8b 60 30 45 31 ed <41> 80 7c 24 79 00 75 5b 48 89 df e8 8b 2c 0d 00 48 85 c0 74 66 
May 25 04:25:54 localhost kernel: [  461.535150] RIP  [<ffffffff811f0c45>] sysfs_create_dir+0x35/0xc0
May 25 04:25:54 localhost kernel: [  461.535747]  RSP <ffff88019419bce0>
May 25 04:25:54 localhost kernel: [  461.536366] CR2: 0000000000000079
May 25 04:25:54 localhost kernel: [  461.537043] ---[ end trace 83bf7cc296e3a5d6 ]---
May 25 04:25:55 localhost kernel: [  462.585300] mpt2sas0: diag reset: SUCCESS


