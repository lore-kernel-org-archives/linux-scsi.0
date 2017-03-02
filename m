From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: SCSI regression in 4.11
Date: Wed, 1 Mar 2017 16:57:11 -0800
Message-ID: <20170301165711.4b27e89e@xeon-e3>
References: <20170228140812.GC20197@lst.de>
        <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk>
        <1488301573.3046.9.camel@linux.vnet.ibm.com>
        <20170228105741.6253bb8a@xeon-e3>
        <1488325732.11610.9.camel@linux.vnet.ibm.com>
        <20170228172532.280811ed@xeon-e3>
        <1488349258.20321.11.camel@linux.vnet.ibm.com>
        <20170228224845.1da358ee@xeon-e3>
        <20170301155057.GA13167@lst.de>
        <20170301075412.2e5f1e98@xeon-e3>
        <20170302000135.GA22886@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33998 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753448AbdCBB06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 20:26:58 -0500
Received: by mail-pg0-f46.google.com with SMTP id p5so26063122pga.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 17:26:57 -0800 (PST)
In-Reply-To: <20170302000135.GA22886@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Thu, 2 Mar 2017 01:01:35 +0100
Christoph Hellwig <hch@lst.de> wrote:

> On Wed, Mar 01, 2017 at 07:54:12AM -0800, Stephen Hemminger wrote:
> > > 	http://git.infradead.org/users/hch/block.git/commitdiff/148cff67b401e2229c076c0ea418712654be77e4  
> > 
> > It appears that is already in the code I am testing in linux-next...  
> 
> It's in -next now, but it wasn't at the time you reported the bug.
> 
> And it would sortof explain the bug if the INQUIRY data is correct
> in the scatterlist, but we ignore it, given that scsi_probe_lun
> ignores the result based on sense data.
> 
> Can you check what happens with the horrible hack below:
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6f7128f49c30..2f384ddb001a 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -603,7 +603,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
>  				"scsi scan: INQUIRY %s with code 0x%x\n",
>  				result ? "failed" : "successful", result));
> -
> +#if 0
>  		if (result) {
>  			/*
>  			 * not-ready to ready transition [asc/ascq=0x28/0x0]
> @@ -628,6 +628,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  			if (resid == try_inquiry_len)
>  				continue;
>  		}
> +#else
> +		if (result) {
> +			printk_ratelimited("got result %d:\n", result);
> +			result = 0;
> +		}
> +#endif
>  		break;
>  	}
>  

I tried that hack and the printk never hit. Could be related to error being masked
by storvsc driver workaround/hack.

Also let the system continue after going off in the weeds during SCSI scan.
After a long time we get stuck threads then EOM.


[  182.444084] hv_storvsc: INQUIRY cmd 0x12 0x1 0x83 scsi status 0x0 srb status 0x1 length 52
[  182.448080] hv_storvsc:  payload size 288 count 1 offset 0 len 254 pfn 0x1e3683
[  182.448080] hv_storvsc:  sg 0: phys 0x1e3683000 virt ffff885b63683000 offset 0x0 length 254
[  182.448080] data: 00000000: 00 83 00 30 01 01 00 18 4d 53 46 54 20 20 20 20  ...0....MSFT    
[  182.448080] data: 00000010: 43 77 cc 85 5f 19 c2 46 ac 48 c7 33 b9 dd 2d 2a  Cw.._..F.H.3..-*
[  182.448080] data: 00000020: 01 03 00 10 60 02 24 80 43 77 cc 85 5f 19 c7 33  ....`.$.Cw.._..3
[  182.448080] data: 00000030: b9 dd 2d 2a 00 00 00 00 00 00 00 00 00 00 00 00  ..-*............
[  182.448080] data: 00000040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 00000090: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 000000a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 000000b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 000000c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 000000d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 000000e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[  182.448080] data: 000000f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00        ..............
[  242.652032] INFO: task kworker/u480:0:5 blocked for more than 120 seconds.
[  242.655042]       Not tainted 4.10.0-next-20170228-next+ #4
[  242.656647] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.659539] kworker/u480:0  D    0     5      2 0x00000000
[  242.661100] Workqueue: events_unbound async_run_entry_fn
[  242.663105] Call Trace:
[  242.664209]  __schedule+0x27a/0x890
[  242.665179]  schedule+0x36/0x80
[  242.666520]  io_schedule+0x16/0x40
[  242.667933]  do_read_cache_page+0x400/0x550
[  242.669153]  ? blkdev_writepages+0x40/0x40
[  242.670775]  ? page_cache_tree_insert+0x120/0x120
[  242.672717]  read_cache_page+0x12/0x20
[  242.674592]  read_dev_sector+0x7d/0xe0
[  242.676457]  ? get_page_from_freelist+0x891/0xad0
[  242.679027]  read_lba+0x193/0x270
[  242.680421]  ? kmem_cache_alloc_trace+0x181/0x190
[  242.682573]  efi_partition+0xf6/0x840
[  242.684111]  ? string+0x59/0x80
[  242.685066]  ? snprintf+0x49/0x60
[  242.685904]  ? compare_gpts+0x280/0x280
[  242.688018]  check_partition+0x13d/0x210
[  242.689747]  rescan_partitions+0xb8/0x370
[  242.691810]  ? get_device+0x17/0x20
[  242.693415]  ? down_write+0x12/0x40
[  242.695383]  __blkdev_get+0x31f/0x440
[  242.697039]  blkdev_get+0x12a/0x330
[  242.698949]  ? unlock_new_inode+0x49/0x80
[  242.700687]  ? refcount_dec_and_test+0x11/0x20
[  242.703084]  ? kobject_put+0x1f/0x60
[  242.704304]  device_add_disk+0x415/0x4a0
[  242.704851]  ? update_autosuspend+0x51/0x60
[  242.705884]  ? __pm_runtime_use_autosuspend+0x54/0x70
[  242.707036]  sd_probe_async+0x10d/0x1c0
[  242.707943]  async_run_entry_fn+0x37/0x150
[  242.708510]  process_one_work+0x1fc/0x490
[  242.709388]  worker_thread+0x4b/0x500
[  242.710197]  kthread+0x101/0x140
[  242.710943]  ? process_one_work+0x490/0x490
[  242.711836]  ? kthread_create_on_node+0x60/0x60
[  242.712355]  ret_from_fork+0x2c/0x40
[  242.713177] INFO: task kworker/3:0:29 blocked for more than 120 seconds.
[  242.714447]       Not tainted 4.10.0-next-20170228-next+ #4
[  242.715562] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.716589] kworker/3:0     D    0    29      2 0x00000000
[  242.733696] Workqueue: events storvsc_remove_lun [hv_storvsc]
[  242.741567] Call Trace:
[  242.742437]  __schedule+0x27a/0x890
[  242.743475]  schedule+0x36/0x80
[  242.744602]  schedule_preempt_disabled+0xe/0x10
[  242.748609]  __mutex_lock.isra.5+0x25f/0x4e0
[  242.764302]  ? ttwu_do_wakeup+0x1e/0x150
[  242.767479]  ? refcount_inc+0x9/0x30
[  242.768992]  __mutex_lock_slowpath+0x13/0x20
[  242.770882]  mutex_lock+0x2f/0x40
[  242.772056]  scsi_remove_device+0x1e/0x40
[  242.773876]  storvsc_remove_lun+0x40/0x60 [hv_storvsc]
[  242.776040]  process_one_work+0x1fc/0x490
[  242.777362]  worker_thread+0x4b/0x500
[  242.779144]  kthread+0x101/0x140
[  242.784784]  ? process_one_work+0x490/0x490
[  242.804486]  ? kthread_create_on_node+0x60/0x60
[  242.806958]  ret_from_fork+0x2c/0x40
[  242.808224] INFO: task kworker/u480:1:59 blocked for more than 120 seconds.
[  242.810817]       Not tainted 4.10.0-next-20170228-next+ #4
[  242.829584] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.836883] kworker/u480:1  D    0    59      2 0x00000000
[  242.839253] Workqueue: events_unbound async_run_entry_fn
[  242.840995] Call Trace:
[  242.842259]  __schedule+0x27a/0x890
[  242.861480]  schedule+0x36/0x80
[  242.866611]  io_schedule+0x16/0x40
[  242.868177]  do_read_cache_page+0x400/0x550
[  242.870012]  ? blkdev_writepages+0x40/0x40
[  242.871621]  ? page_cache_tree_insert+0x120/0x120
[  242.872978]  read_cache_page+0x12/0x20
[  242.882635]  read_dev_sector+0x7d/0xe0
[  242.893398]  ? get_page_from_freelist+0x891/0xad0
[  242.895202]  read_lba+0x193/0x270
[  242.896256]  ? kmem_cache_alloc_trace+0x181/0x190
[  242.897996]  efi_partition+0xf6/0x840
[  242.899471]  ? string+0x59/0x80
[  242.900413]  ? snprintf+0x49/0x60
[  242.901831]  ? compare_gpts+0x280/0x280
[  242.903385]  check_partition+0x13d/0x210
[  242.904510]  rescan_partitions+0xb8/0x370
[  242.921040]  ? get_device+0x17/0x20
[  242.931024]  ? down_write+0x12/0x40
[  242.932395]  __blkdev_get+0x31f/0x440
[  242.933973]  blkdev_get+0x12a/0x330
[  242.935457]  ? unlock_new_inode+0x49/0x80
[  242.936613]  ? refcount_dec_and_test+0x11/0x20
[  242.938422]  ? kobject_put+0x1f/0x60
[  242.939910]  device_add_disk+0x415/0x4a0
[  242.941030]  ? update_autosuspend+0x51/0x60
[  242.942698]  ? __pm_runtime_use_autosuspend+0x54/0x70
[  242.944290]  sd_probe_async+0x10d/0x1c0
[  242.945856]  async_run_entry_fn+0x37/0x150
[  242.947503]  process_one_work+0x1fc/0x490
[  242.948645]  worker_thread+0x4b/0x500
[  242.950155]  kthread+0x101/0x140
[  242.951494]  ? process_one_work+0x490/0x490
[  242.959746]  ? kthread_create_on_node+0x60/0x60
[  242.971264]  ret_from_fork+0x2c/0x40
[  242.972731] INFO: task kworker/3:1:147 blocked for more than 120 seconds.
[  242.975571]       Not tainted 4.10.0-next-20170228-next+ #4
[  242.977499] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  242.980459] kworker/3:1     D    0   147      2 0x00000000
[  242.982852] Workqueue: events storvsc_remove_lun [hv_storvsc]
[  243.007498] Call Trace:
[  243.008589]  __schedule+0x27a/0x890
[  243.010330]  ? sched_clock_local+0x17/0x90
[  243.012217]  schedule+0x36/0x80
[  243.013227]  schedule_preempt_disabled+0xe/0x10
[  243.022267]  __mutex_lock.isra.5+0x25f/0x4e0
[  243.034018]  ? refcount_inc+0x9/0x30
[  243.035848]  __mutex_lock_slowpath+0x13/0x20
[  243.037509]  mutex_lock+0x2f/0x40
[  243.039161]  scsi_remove_device+0x1e/0x40
[  243.040721]  storvsc_remove_lun+0x40/0x60 [hv_storvsc]
[  243.043025]  process_one_work+0x1fc/0x490
[  243.044450]  worker_thread+0x4b/0x500
[  243.049993]  kthread+0x101/0x140
[  243.068204]  ? process_one_work+0x490/0x490
[  243.070474]  ? kthread_create_on_node+0x60/0x60
[  243.072247]  ret_from_fork+0x2c/0x40
[  243.073796] INFO: task systemd-udevd:211 blocked for more than 120 seconds.
[  243.076235]       Not tainted 4.10.0-next-20170228-next+ #4
[  243.088238] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.095559] systemd-udevd   D    0   211    183 0x00000004
[  243.096795] Call Trace:
[  243.097542]  __schedule+0x27a/0x890
[  243.098444]  ? kobject_uevent+0xb/0x10
[  243.099366]  ? mutex_lock+0x12/0x40
[  243.100459]  schedule+0x36/0x80
[  243.101817]  async_synchronize_cookie_domain+0xb5/0x150
[  243.103808]  ? wake_atomic_t_function+0x60/0x60
[  243.105077]  async_synchronize_full+0x17/0x20
[  243.106912]  do_init_module+0xc1/0x200
[  243.109350]  load_module+0x270f/0x2b20
[  243.130805]  ? __symbol_put+0x60/0x60
[  243.132612]  ? security_kernel_post_read_file+0x6b/0x80
[  243.135096]  SYSC_finit_module+0xdf/0x110
[  243.136353]  SyS_finit_module+0xe/0x10
[  243.137895]  entry_SYSCALL_64_fastpath+0x1e/0xad
[  243.139742] RIP: 0033:0x7f85a7efad29
[  243.157585] RSP: 002b:00007fff1b33bd58 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[  243.160930] RAX: ffffffffffffffda RBX: 0000564043826230 RCX: 00007f85a7efad29
[  243.163618] RDX: 0000000000000000 RSI: 00007f85a881ce23 RDI: 000000000000000c
[  243.165849] RBP: 00007f85a881ce23 R08: 0000000000000000 R09: 00007fff1b33c2d0
[  243.168367] R10: 000000000000000c R11: 0000000000000246 R12: 0000000000000000
[  243.182797] R13: 00005640438264b0 R14: 0000000000020000 R15: 00005640420a476c
[  243.197192] INFO: task kworker/3:2:330 blocked for more than 120 seconds.
[  243.200767]       Not tainted 4.10.0-next-20170228-next+ #4
[  243.211557] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.225018] kworker/3:2     D    0   330      2 0x00000000
[  243.227486] Workqueue: events storvsc_remove_lun [hv_storvsc]
[  243.229536] Call Trace:
[  243.230946]  __schedule+0x27a/0x890
[  243.232441]  schedule+0x36/0x80
[  243.242007]  schedule_preempt_disabled+0xe/0x10
[  243.256986]  __mutex_lock.isra.5+0x25f/0x4e0
[  243.259067]  ? ttwu_do_wakeup+0x1e/0x150
[  243.260506]  ? refcount_inc+0x9/0x30
[  243.262139]  __mutex_lock_slowpath+0x13/0x20
[  243.263996]  mutex_lock+0x2f/0x40
[  243.274173]  scsi_remove_device+0x1e/0x40
[  243.292525]  storvsc_remove_lun+0x40/0x60 [hv_storvsc]
[  243.294935]  process_one_work+0x1fc/0x490
[  243.307186]  worker_thread+0x4b/0x500
[  243.315333]  kthread+0x101/0x140
[  243.316704]  ? process_one_work+0x490/0x490
[  243.318487]  ? kthread_create_on_node+0x60/0x60
[  243.320348]  ret_from_fork+0x2c/0x40
[  243.321392] INFO: task kworker/3:3:332 blocked for more than 120 seconds.
[  243.324037]       Not tainted 4.10.0-next-20170228-next+ #4
[  243.325888] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.351220] kworker/3:3     D    0   332      2 0x00000000
[  243.352493] Workqueue: events storvsc_remove_lun [hv_storvsc]
[  243.354732] Call Trace:
[  243.356026]  __schedule+0x27a/0x890
[  243.357162]  ? set_next_entity+0xd9/0x220
[  243.367740]  schedule+0x36/0x80
[  243.377625]  schedule_preempt_disabled+0xe/0x10
[  243.378711]  __mutex_lock.isra.5+0x25f/0x4e0
[  243.379762]  ? __schedule+0x282/0x890
[  243.380418]  ? refcount_inc+0x9/0x30
[  243.382245]  __mutex_lock_slowpath+0x13/0x20
[  243.384329]  mutex_lock+0x2f/0x40
[  243.385475]  scsi_remove_device+0x1e/0x40
[  243.387391]  storvsc_remove_lun+0x40/0x60 [hv_storvsc]
[  243.389327]  process_one_work+0x1fc/0x490
[  243.401523]  worker_thread+0x4b/0x500
[  243.413317]  kthread+0x101/0x140
[  243.415295]  ? process_one_work+0x490/0x490
[  243.416763]  ? kthread_create_on_node+0x60/0x60
[  243.418599]  ret_from_fork+0x2c/0x40
[  243.420251] INFO: task kworker/3:4:333 blocked for more than 120 seconds.
[  243.443223]       Not tainted 4.10.0-next-20170228-next+ #4
[  243.445606] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.448643] kworker/3:4     D    0   333      2 0x00000000
[  243.451139] Workqueue: events storvsc_remove_lun [hv_storvsc]
[  243.474469] Call Trace:
[  243.478194]  __schedule+0x27a/0x890
[  243.479075]  schedule+0x36/0x80
[  243.479887]  schedule_preempt_disabled+0xe/0x10
[  243.480615]  __mutex_lock.isra.5+0x25f/0x4e0
[  243.481664]  ? ttwu_do_wakeup+0x1e/0x150
[  243.484694]  ? refcount_inc+0x9/0x30
[  243.501458]  __mutex_lock_slowpath+0x13/0x20
[  243.504011]  mutex_lock+0x2f/0x40
[  243.505043]  scsi_remove_device+0x1e/0x40
[  243.506673]  storvsc_remove_lun+0x40/0x60 [hv_storvsc]
[  243.508303]  process_one_work+0x1fc/0x490
[  243.510060]  worker_thread+0x4b/0x500
[  243.511644]  kthread+0x101/0x140
[  243.512602]  ? process_one_work+0x490/0x490
[  243.514385]  ? kthread_create_on_node+0x60/0x60
[  243.537616]  ret_from_fork+0x2c/0x40
[  243.539497] INFO: task kworker/u480:5:334 blocked for more than 120 seconds.
[  243.541721]       Not tainted 4.10.0-next-20170228-next+ #4
[  243.543885] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.563120] kworker/u480:5  D    0   334      2 0x00000000
[  243.565760] Workqueue: events_unbound async_run_entry_fn
[  243.568060] Call Trace:
[  243.568945]  __schedule+0x27a/0x890
[  243.570481]  schedule+0x36/0x80
[  243.571918]  io_schedule+0x16/0x40
[  243.573066]  do_read_cache_page+0x400/0x550
[  243.574919]  ? blkdev_writepages+0x40/0x40
[  243.576377]  ? page_cache_tree_insert+0x120/0x120
[  243.578329]  read_cache_page+0x12/0x20
[  243.579980]  read_dev_sector+0x7d/0xe0
[  243.581102]  ? get_page_from_freelist+0x891/0xad0
[  243.592370]  read_lba+0x193/0x270
[  243.605604]  ? kmem_cache_alloc_trace+0x181/0x190
[  243.608277]  efi_partition+0xf6/0x840
[  243.609370]  ? string+0x59/0x80
[  243.610686]  ? snprintf+0x49/0x60
[  243.612146]  ? compare_gpts+0x280/0x280
[  243.613318]  check_partition+0x13d/0x210
[  243.628468]  rescan_partitions+0xb8/0x370
[  243.634925]  ? get_device+0x17/0x20
[  243.636661]  ? down_write+0x12/0x40
[  243.638127]  __blkdev_get+0x31f/0x440
[  243.639533]  blkdev_get+0x12a/0x330
[  243.640455]  ? unlock_new_inode+0x49/0x80
[  243.642030]  ? refcount_dec_and_test+0x11/0x20
[  243.643734]  ? kobject_put+0x1f/0x60
[  243.644684]  device_add_disk+0x415/0x4a0
[  243.658639]  ? update_autosuspend+0x51/0x60
[  243.668143]  ? __pm_runtime_use_autosuspend+0x54/0x70
[  243.670071]  sd_probe_async+0x10d/0x1c0
[  243.671633]  async_run_entry_fn+0x37/0x150
[  243.672712]  process_one_work+0x1fc/0x490
[  243.674370]  worker_thread+0x4b/0x500
[  243.675961]  kthread+0x101/0x140
[  243.699980]  ? process_one_work+0x490/0x490
[  243.701822]  ? kthread_create_on_node+0x60/0x60
[  243.704162]  ret_from_fork+0x2c/0x40
[  243.706396] INFO: task kworker/3:5:335 blocked for more than 120 seconds.
[  243.725149]       Not tainted 4.10.0-next-20170228-next+ #4
[  243.729465] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  243.732155] kworker/3:5     D    0   335      2 0x00000000
[  243.734540] Workqueue: events storvsc_remove_lun [hv_storvsc]
[  243.736424] Call Trace:
[  243.737727]  __schedule+0x27a/0x890
[  243.739946]  schedule+0x36/0x80
[  243.762753]  schedule_preempt_disabled+0xe/0x10
[  243.764775]  __mutex_lock.isra.5+0x25f/0x4e0
[  243.766623]  ? ttwu_do_wakeup+0x1e/0x150
[  243.768224]  ? refcount_inc+0x9/0x30
[  243.769242]  __mutex_lock_slowpath+0x13/0x20
[  243.780479]  mutex_lock+0x2f/0x40
[  243.794561]  scsi_remove_device+0x1e/0x40
[  243.797476]  storvsc_remove_lun+0x40/0x60 [hv_storvsc]
[  243.799623]  process_one_work+0x1fc/0x490
[  243.815894]  worker_thread+0x4b/0x500
[  243.824624]  kthread+0x101/0x140
[  243.826247]  ? process_one_work+0x490/0x490
[  243.828039]  ? kthread_create_on_node+0x60/0x60
[  243.829398]  ret_from_fork+0x2c/0x40
Begin: Loading essential drivers ... done.
