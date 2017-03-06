From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] scsi: sr: fix oob access in get_capabilities
Date: Mon, 6 Mar 2017 15:26:46 +0800
Message-ID: <4d80c1cc-8116-b3c5-3025-f05e5c8fc23a@huawei.com>
References: <1488536272-10509-1-git-send-email-wangkefeng.wang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:3820 "EHLO
        dggrg01-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752557AbdCFHdm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2017 02:33:42 -0500
In-Reply-To: <1488536272-10509-1-git-send-email-wangkefeng.wang@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Hi all，

On 2017/3/3 18:17, Kefeng Wang wrote:
> 'n = header_length + block_descriptor_length' could be greater than 512,
> and will lead to oob access, so enlarge transfer buffer to fix it.

I am not familiar with scsi protocol，so the patch may be wrong.
Question, is it reasonable for block_descriptor_length = 512 when mode page = 0x2a?

The value shown below，

[    4.516108] get_capabilities, n = 520, head_len = 8, blk_des_len = 512

> 
> ===
> BUG: KASAN: slab-out-of-bounds in sr_probe+0x570/0xcc0 at addr ffff88000009020e
> Read of size 1 by task kworker/u48:2/188
and the kasan print,

[    4.516111] ==================================================================
[    4.516122] BUG: KASAN: slab-out-of-bounds in sr_probe+0x4a3/0xdc0 at addr ffff880000090210
[    4.516125] Read of size 1 by task kworker/u48:3/677
[    4.516131] CPU: 18 PID: 677 Comm: kworker/u48:3 Not tainted 4.10.0+ #9
[    4.516133] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
[    4.516143] Workqueue: events_unbound async_run_entry_fn
[    4.516146] Call Trace:
[    4.516156]  dump_stack+0x99/0xe4
[    4.516162]  ? _atomic_dec_and_lock+0x12c/0x12c
[    4.516166]  ? sr_probe+0x4a3/0xdc0
[    4.516172]  kasan_object_err+0x1c/0x80
[    4.516175]  kasan_report.part.0+0x2e4/0x830
[    4.516182]  ? vprintk_default+0x1a/0x20
[    4.516187]  ? printk+0x94/0xb0
[    4.516190]  ? sr_probe+0x4a3/0xdc0
[    4.516193]  kasan_report+0x44/0x70
[    4.516197]  __asan_load1+0x47/0x50
[    4.516199]  sr_probe+0x4a3/0xdc0
[    4.516204]  ? __kernfs_new_node+0x142/0x1c0
[    4.516207]  ? kernfs_next_descendant_post+0x84/0xe0
[    4.516211]  ? kernfs_activate+0xa7/0x150
[    4.516213]  ? sr_block_ioctl+0x130/0x130
[    4.516218]  ? sysfs_do_create_link_sd+0xdd/0x160
[    4.516224]  ? devices_kset_move_last+0x16a/0x220
[    4.516227]  ? device_remove_groups+0x10/0x10
[    4.516232]  ? mutex_lock+0xd/0x30
[    4.516236]  ? device_links_check_suppliers+0x123/0x220
[    4.516240]  ? driver_sysfs_add+0xf9/0x1b0
[    4.516244]  driver_probe_device+0x1bf/0x4f0
[    4.516249]  __device_attach_driver+0xf8/0x1b0
[    4.516253]  ? __driver_attach+0x120/0x120
[    4.516256]  bus_for_each_drv+0xfe/0x190
[    4.516260]  ? bus_rescan_devices+0x20/0x20
[    4.516263]  __device_attach+0x16e/0x200
[    4.516267]  ? device_bind_driver+0x90/0x90
[    4.516271]  ? kobject_uevent_env+0x1ae/0x890
[    4.516275]  device_initial_probe+0xe/0x10
[    4.516278]  bus_probe_device+0x124/0x190
[    4.516282]  device_add+0x883/0xb10
[    4.516285]  ? device_private_init+0x160/0x160
[    4.516289]  ? __pm_runtime_resume+0x4d/0xa0
[    4.516294]  scsi_sysfs_add_sdev+0xdb/0x450
[    4.516300]  scsi_probe_and_add_lun+0x13da/0x1630
[    4.516305]  ? scsi_free_host_dev+0x90/0x90
[    4.516308]  ? rpm_check_suspend_allowed+0x170/0x170
[    4.516313]  ? _raw_spin_unlock_bh+0xb0/0xb0
[    4.516316]  ? rpm_check_suspend_allowed+0x9c/0x170
[    4.516319]  ? __pm_runtime_resume+0x4d/0xa0
[    4.516323]  __scsi_add_device+0x1a1/0x1c0
[    4.516327]  ? scsi_target_reap+0x60/0x60
[    4.516332]  ? async_synchronize_cookie_domain+0xbe/0x1a0
[    4.516336]  ? kobject_put+0x16/0x60
[    4.516340]  ? ata_dev_next+0xe7/0x220
[    4.516345]  ata_scsi_scan_host+0x18f/0x2d0
[    4.516349]  async_port_probe+0x5b/0xa0
[    4.516353]  ? ata_port_probe+0x80/0x80
[    4.516357]  async_run_entry_fn+0xe1/0x3b0
[    4.516361]  ? current_is_async+0x70/0x70
[    4.516364]  ? __schedule+0x487/0xde0
[    4.516371]  ? pwq_dec_nr_in_flight+0xc9/0x1f0
[    4.516375]  process_one_work+0x46a/0xb40
[    4.516380]  ? cancel_delayed_work_sync+0x10/0x10
[    4.516384]  ? worker_enter_idle+0x256/0x4d0
[    4.516387]  ? pool_mayday_timeout+0x420/0x420
[    4.516391]  worker_thread+0x10d/0x930
[    4.516396]  ? process_one_work+0xb40/0xb40
[    4.516400]  ? _raw_spin_unlock_bh+0xb0/0xb0
[    4.516404]  ? __wake_up_common+0x90/0x140
[    4.516407]  kthread+0x1cf/0x2b0
[    4.516411]  ? process_one_work+0xb40/0xb40
[    4.516414]  ? kthread_create_on_node+0xa0/0xa0
[    4.516418]  ret_from_fork+0x29/0x40
[    4.516421] Object at ffff880000090000, in cache dma-kmalloc-512 size: 512
[    4.516421] Allocated:
[    4.516422] PID = 677
[    4.516426]  save_stack_trace+0x16/0x20
[    4.516429]  save_stack+0x46/0xd0
[    4.516432]  kasan_kmalloc+0xad/0xe0
[    4.516434]  __kmalloc+0x123/0x2f0
[    4.516437]  sr_probe+0x3a4/0xdc0
[    4.516441]  driver_probe_device+0x1bf/0x4f0
[    4.516444]  __device_attach_driver+0xf8/0x1b0
[    4.516448]  bus_for_each_drv+0xfe/0x190
[    4.516451]  __device_attach+0x16e/0x200
[    4.516454]  device_initial_probe+0xe/0x10
[    4.516458]  bus_probe_device+0x124/0x190
[    4.516461]  device_add+0x883/0xb10
[    4.516464]  scsi_sysfs_add_sdev+0xdb/0x450
[    4.516468]  scsi_probe_and_add_lun+0x13da/0x1630
[    4.516472]  __scsi_add_device+0x1a1/0x1c0
[    4.516474]  ata_scsi_scan_host+0x18f/0x2d0
[    4.516478]  async_port_probe+0x5b/0xa0
[    4.516482]  async_run_entry_fn+0xe1/0x3b0
[    4.516486]  process_one_work+0x46a/0xb40
[    4.516489]  worker_thread+0x10d/0x930
[    4.516492]  kthread+0x1cf/0x2b0
[    4.516495]  ret_from_fork+0x29/0x40
[    4.516495] Freed:
[    4.516496] PID = 0
[    4.516497] (stack is not available)
[    4.516497] Memory state around the buggy address:
[    4.516502]  ffff880000090100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    4.516505]  ffff880000090180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[    4.516508] >ffff880000090200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    4.516509]                          ^
[    4.516511]  ffff880000090280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[    4.516514]  ffff880000090300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc


[...]

> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  drivers/scsi/sr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 0b29b93..5a80aa6 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -852,7 +852,7 @@ static void get_capabilities(struct scsi_cd *cd)
>  
>  
>  	/* allocate transfer buffer */
> -	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> +	buffer = kmalloc(1024, GFP_KERNEL | GFP_DMA);
>  	if (!buffer) {
>  		sr_printk(KERN_ERR, cd, "out of memory.\n");
>  		return;
> 
