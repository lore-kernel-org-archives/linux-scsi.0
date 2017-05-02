From: Scott Bauer <scott.bauer@intel.com>
Subject: Re: [PATCH] Avoid that scsi_exit_rq() triggers a use-after-free
Date: Tue, 2 May 2017 17:00:35 -0600
Message-ID: <20170502230034.GA29151@sbauer-Z170X-UD5>
References: <20170502174330.13146-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170502174330.13146-1-bart.vanassche@sandisk.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 02, 2017 at 10:43:30AM -0700, Bart Van Assche wrote:
> This patch fixes the following KASAN complaint:
> 
> ==================================================================
> BUG: KASAN: use-after-free in scsi_exit_rq+0xf3/0x120 at addr ffff8802b7fedf00
> Read of size 1 by task rcuos/5/53
> CPU: 7 PID: 53 Comm: rcuos/6 Not tainted 4.11.0-rc5+ #13
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0 ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> Call Trace:
>  dump_stack+0x63/0x8f
>  kasan_object_err+0x21/0x70
>  kasan_report.part.1+0x231/0x500
>  __asan_report_load1_noabort+0x2e/0x30
>  scsi_exit_rq+0xf3/0x120
>  free_request_size+0x44/0x60
>  mempool_destroy.part.6+0x9b/0x150
>  mempool_destroy+0x13/0x20
>  blk_exit_rl+0x36/0x40
>  blkg_free+0x146/0x200
>  __blkg_release_rcu+0x121/0x220
>  rcu_nocb_kthread+0x61f/0xca0
>  kthread+0x298/0x390
>  ret_from_fork+0x2c/0x40
> Object at ffff8802b7fedd80, in cache kmalloc-2048 size: 2048
> Allocated:
> PID = 3992
>  save_stack_trace+0x1b/0x20
>  save_stack+0x46/0xd0
>  kasan_kmalloc+0xad/0xe0
>  __kmalloc+0x134/0x220
>  scsi_host_alloc+0x6b/0x11c0
>  0xffffffffc101d94a
>  driver_probe_device+0x49e/0xc60
>  __device_attach_driver+0x1d3/0x2a0
>  bus_for_each_drv+0x11a/0x1d0
>  __device_attach+0x1e1/0x2c0
>  device_initial_probe+0x13/0x20
>  bus_probe_device+0x19b/0x240
>  device_add+0x86d/0x1450
>  device_register+0x1a/0x20
>  0xffffffffc10270ce
>  0xffffffffc1048a62
>  do_one_initcall+0xa7/0x250
>  do_init_module+0x1d0/0x55d
>  load_module+0x7c9f/0x9850
>  SYSC_finit_module+0x189/0x1c0
>  SyS_finit_module+0xe/0x10
>  entry_SYSCALL_64_fastpath+0x1a/0xa9
> Freed:
> PID = 4128
>  save_stack_trace+0x1b/0x20
>  save_stack+0x46/0xd0
>  kasan_slab_free+0x71/0xb0
>  kfree+0x8d/0x1b0
>  scsi_host_dev_release+0x2cb/0x430
>  device_release+0x76/0x1e0
>  kobject_release+0x107/0x370
>  kobject_put+0x56/0xb0
>  put_device+0x17/0x20
>  scsi_host_put+0x15/0x20
>  0xffffffffc101fcd7
>  device_release_driver_internal+0x26a/0x4e0
>  device_release_driver+0x12/0x20
>  bus_remove_device+0x2d0/0x590
>  device_del+0x55b/0x920
>  device_unregister+0x1a/0xa0
>  0xffffffffc101e0ca
>  0xffffffffc102fccc
>  SyS_delete_module+0x334/0x3e0
>  entry_SYSCALL_64_fastpath+0x1a/0xa9
> Memory state around the buggy address:
>  ffff8802b7fede00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8802b7fede80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff8802b7fedf00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                    ^
>  ffff8802b7fedf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8802b7fee000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
> 
> Reported-by: Scott Bauer <scott.bauer@intel.com>
> Fixes: e9c787e65c0c ("scsi: allocate scsi_cmnd structures as part of struct request")
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Scott Bauer <scott.bauer@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/scsi_lib.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 15c9fe766071..d698364df072 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2095,11 +2095,14 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
>  	struct Scsi_Host *shost = q->rq_alloc_data;
>  	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
>  
> +	if (!scsi_host_get(shost))
> +		goto fail;
> +
>  	memset(cmd, 0, sizeof(*cmd));
>  
>  	cmd->sense_buffer = scsi_alloc_sense_buffer(shost, gfp, NUMA_NO_NODE);
>  	if (!cmd->sense_buffer)
> -		goto fail;
> +		goto put;
>  	cmd->req.sense = cmd->sense_buffer;
>  
>  	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
> @@ -2112,6 +2115,8 @@ static int scsi_init_rq(struct request_queue *q, struct request *rq, gfp_t gfp)
>  
>  fail_free_sense:
>  	scsi_free_sense_buffer(shost, cmd->sense_buffer);
> +put:
> +	scsi_host_put(shost);
>  fail:
>  	return -ENOMEM;
>  }
> @@ -2124,6 +2129,7 @@ static void scsi_exit_rq(struct request_queue *q, struct request *rq)
>  	if (cmd->prot_sdb)
>  		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
>  	scsi_free_sense_buffer(shost, cmd->sense_buffer);
> +	scsi_host_put(shost);
>  }
>  
>  struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
> -- 
> 2.12.2
> 


I've applied this on-top of Jens' For-Linus and re-ran the test. I get the following scheduling
while atomic BUG() splat:

[   30.686851] run fstests generic/108 at 2017-05-02 16:56:42
[   30.953920] XFS (nvme1n1): Unmounting Filesystem
[   31.020543] scsi host2: scsi_debug: version 1.86 [20160430]
[   31.020543]   dev_size_mb=128, opts=0x0, submit_queues=1, statistics=0
[   31.022341] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[   31.074668] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   31.083077] sd 2:0:0:0: [sda] 262144 512-byte logical blocks: (134 MB/128 MiB)
[   31.088168] sd 2:0:0:0: [sda] Write Protect is off
[   31.088829] sd 2:0:0:0: [sda] Mode Sense: 73 00 10 08
[   31.097875] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[   31.195672] sd 2:0:0:0: [sda] Attached SCSI disk
[   34.039198] XFS (dm-0): Mounting V5 Filesystem
[   34.066635] XFS (dm-0): Ending clean mount
[   34.244127] sd 2:0:0:0: rejecting I/O to offline device
[   34.244530] sd 2:0:0:0: rejecting I/O to offline device
[   34.244991] sd 2:0:0:0: rejecting I/O to offline device
[   34.245363] sd 2:0:0:0: rejecting I/O to offline device
[   34.246094] sd 2:0:0:0: rejecting I/O to offline device
[   34.246711] sd 2:0:0:0: rejecting I/O to offline device
[   34.247336] sd 2:0:0:0: rejecting I/O to offline device
[   34.247705] sd 2:0:0:0: rejecting I/O to offline device
[   34.249195] sd 2:0:0:0: rejecting I/O to offline device
[   34.249561] blk_update_request: I/O error, dev sda, sector 0
[   34.286197] XFS (dm-0): Unmounting Filesystem
[   35.672931] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[   35.753764] BUG: scheduling while atomic: swapper/0/0/0x00000100
[   35.754333] Modules linked in: xfs binfmt_misc ppdev joydev input_leds serio_raw i2c_piix4 parport_pc parport mac_hid ib_iser rdma_cm iw_cm ib_cm ib_core configfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 btrfs raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear psmouse nvme nvme_core pata_acpi floppy [last unloaded: scsi_debug]
[   35.757226] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.11.0+ #1
[   35.757708] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
[   35.758462] Call Trace:
[   35.758630]  <IRQ>
[   35.758783]  dump_stack+0x63/0x82
[   35.759017]  __schedule_bug+0xe9/0x120
[   35.759278]  __schedule+0x126b/0x1c50
[   35.759534]  ? save_stack+0xb5/0xd0
[   35.759772]  ? pci_mmcfg_check_reserved+0x110/0x110
[   35.760107]  ? scsi_host_dev_release+0xb4/0x430
[   35.760419]  ? device_release+0x76/0x1e0
[   35.760685]  ? kobject_put+0x56/0xb0
[   35.760930]  ? scsi_host_put+0x15/0x20
[   35.761185]  ? scsi_exit_rq+0xe9/0x120
[   35.761444]  schedule+0x8d/0x1a0
[   35.761675]  schedule_timeout+0x557/0x8a0
[   35.761958]  ? flush_workqueue_prep_pwqs+0x2e8/0x400
[   35.762303]  ? cpu_startup_entry+0xcf/0xe0
[   35.762587]  ? usleep_range+0x120/0x120
[   35.762862]  ? kvm_sched_clock_read+0x1e/0x30
[   35.763174]  ? sched_clock+0x9/0x10
[   35.763426]  ? __x2apic_send_IPI_dest.constprop.4+0x31/0x40
[   35.763820]  ? x2apic_send_IPI+0x72/0xa0
[   35.764097]  wait_for_completion+0x1ae/0x310
[   35.764396]  ? wait_for_completion+0x1ae/0x310
[   35.764707]  ? bit_wait_io_timeout+0x130/0x130
[   35.765018]  ? wake_up_q+0xe0/0xe0
[   35.765264]  kthread_stop+0xa1/0x300
[   35.765522]  destroy_workqueue+0x2db/0x560
[   35.765844]  scsi_host_dev_release+0xe7/0x430
[   35.766155]  device_release+0x76/0x1e0
[   35.766425]  kobject_release+0x107/0x370
[   35.766706]  kobject_put+0x56/0xb0
[   35.766962]  put_device+0x17/0x20
[   35.767201]  scsi_host_put+0x15/0x20
[   35.767457]  scsi_exit_rq+0xe9/0x120
[   35.767720]  free_request_size+0x44/0x60
[   35.768008]  mempool_destroy.part.6+0x9b/0x150
[   35.768326]  ? kasan_slab_free+0x87/0xb0
[   35.768607]  mempool_destroy+0x13/0x20
[   35.768879]  blk_exit_rl+0x36/0x40
[   35.769121]  blkg_free+0xcd/0x190
[   35.769349]  __blkg_release_rcu+0x121/0x220
[   35.769636]  rcu_process_callbacks+0x831/0xfb0
[   35.769947]  __do_softirq+0x1a9/0x558
[   35.770199]  irq_exit+0x14e/0x180
[   35.770424]  smp_apic_timer_interrupt+0x7b/0xa0
[   35.770732]  apic_timer_interrupt+0x89/0x90
[   35.771021] RIP: 0010:native_safe_halt+0x6/0x10
[   35.771328] RSP: 0018:ffffffffa7407d08 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
[   35.771843] RAX: 0000000000000000 RBX: ffffffffa7416d80 RCX: 0000000000000000
[   35.772342] RDX: 1ffffffff4e82db0 RSI: 0000000000000000 RDI: 0000000000000000
[   35.772832] RBP: ffffffffa7407d08 R08: 000000084fa5bc00 R09: 00000000fffefde4
[   35.773306] R10: ffff880333fec010 R11: 000005e17de691b5 R12: ffffffffa7416d80
[   35.773793] R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
[   35.774287]  </IRQ>
[   35.774484]  default_idle+0x22/0x210
[   35.774738]  arch_cpu_idle+0xf/0x20
[   35.774992]  default_idle_call+0x3b/0x60
[   35.775273]  do_idle+0x1fd/0x2d0
[   35.775515]  cpu_startup_entry+0xcf/0xe0
[   35.775798]  ? cpu_in_idle+0x20/0x20
[   35.776056]  rest_init+0x9e/0xb0
[   35.776300]  start_kernel+0x691/0x6cd
[   35.776564]  ? thread_stack_cache_init+0x6/0x6
[   35.776881]  ? early_idt_handler_array+0x120/0x120
[   35.777222]  x86_64_start_reservations+0x24/0x26
[   35.777551]  x86_64_start_kernel+0x148/0x16b
[   35.777866]  start_cpu+0x14/0x14
[   35.778259] bad: scheduling from the idle thread!
[   35.778852] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.11.0+ #1
[   35.779622] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
[   35.780437] Call Trace:
[   35.780658]  <IRQ>
[   35.780847]  dump_stack+0x63/0x82
[   35.781143]  dequeue_task_idle+0x2c/0x40
[   35.781516]  deactivate_task+0x125/0x2e0
[   35.781936]  __schedule+0x9d4/0x1c50
[   35.782214]  ? pci_mmcfg_check_reserved+0x110/0x110
[   35.782652]  ? __switch_to+0x639/0xd30
[   35.782984]  schedule+0x8d/0x1a0
[   35.783236]  schedule_timeout+0x557/0x8a0
[   35.783620]  ? usleep_range+0x120/0x120
[   35.783937]  ? pci_mmcfg_check_reserved+0x110/0x110
[   35.784345]  ? sched_clock+0x9/0x10
[   35.784638]  ? x2apic_send_IPI+0x72/0xa0
[   35.785147]  wait_for_completion+0x1ae/0x310
[   35.785876]  ? wait_for_completion+0x1ae/0x310
[   35.786314]  ? bit_wait_io_timeout+0x130/0x130
[   35.786641]  ? wake_up_q+0xe0/0xe0
[   35.786900]  ? put_pwq+0xa6/0xf0
[   35.787141]  kthread_stop+0xa1/0x300
[   35.787405]  scsi_host_dev_release+0x114/0x430
[   35.787729]  device_release+0x76/0x1e0
[   35.788004]  kobject_release+0x107/0x370
[   35.788291]  kobject_put+0x56/0xb0
[   35.788540]  put_device+0x17/0x20
[   35.788786]  scsi_host_put+0x15/0x20
[   35.789048]  scsi_exit_rq+0xe9/0x120
[   35.789311]  free_request_size+0x44/0x60
[   35.789598]  mempool_destroy.part.6+0x9b/0x150
[   35.789945]  ? kasan_slab_free+0x87/0xb0
[   35.790237]  mempool_destroy+0x13/0x20
[   35.790515]  blk_exit_rl+0x36/0x40
[   35.790763]  blkg_free+0xcd/0x190
[   35.791011]  __blkg_release_rcu+0x121/0x220
[   35.791412]  rcu_process_callbacks+0x831/0xfb0
[   35.791997]  __do_softirq+0x1a9/0x558
[   35.792551]  irq_exit+0x14e/0x180
[   35.793006]  smp_apic_timer_interrupt+0x7b/0xa0
[   35.793655]  apic_timer_interrupt+0x89/0x90
[   35.794128] RIP: 0010:native_safe_halt+0x6/0x10
[   35.794461] RSP: 0018:ffffffffa7407d08 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
[   35.795015] RAX: 0000000000000000 RBX: ffffffffa7416d80 RCX: 0000000000000000
[   35.795525] RDX: 1ffffffff4e82db0 RSI: 0000000000000000 RDI: 0000000000000000
[   35.796036] RBP: ffffffffa7407d08 R08: 000000084fa5bc00 R09: 00000000fffefde4
[   35.796549] R10: ffff880333fec010 R11: 000005e17de691b5 R12: ffffffffa7416d80
[   35.797060] R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
[   35.797573]  </IRQ>
[   35.797766]  default_idle+0x22/0x210
[   35.798027]  arch_cpu_idle+0xf/0x20
[   35.798278]  default_idle_call+0x3b/0x60
[   35.798560]  do_idle+0x1fd/0x2d0
[   35.798798]  cpu_startup_entry+0xcf/0xe0
[   35.799076]  ? cpu_in_idle+0x20/0x20
[   35.799335]  rest_init+0x9e/0xb0
[   35.799586]  start_kernel+0x691/0x6cd
[   35.799865]  ? thread_stack_cache_init+0x6/0x6
[   35.800221]  ? early_idt_handler_array+0x120/0x120
[   35.800601]  x86_64_start_reservations+0x24/0x26
[   35.800939]  x86_64_start_kernel+0x148/0x16b
[   35.801259]  start_cpu+0x14/0x14
[   35.801634] softirq: huh, entered softirq 9 RCU ffffffffa52a7600 with preempt_count 00000100, exited with 00000000?
[   35.802651] ------------[ cut here ]------------
