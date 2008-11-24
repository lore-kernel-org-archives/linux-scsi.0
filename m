From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: next-20081119: general protection fault:
 get_next_timer_interrupt()
Date: Mon, 24 Nov 2008 18:43:28 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0811241816120.3301@localhost.localdomain>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com>  <alpine.LFD.2.00.0811191308030.3119@localhost.localdomain> <a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

Alexander,

On Fri, 21 Nov 2008, Alexander Beregalov wrote:

> 2008/11/20 Thomas Gleixner <tglx@linutronix.de>:
> > Alexander,
> >
> > On Wed, 19 Nov 2008, Alexander Beregalov wrote:
> >>
> >> It is 4way X86_64
> >> The kernel does not boot.
> >
> >> RIP: 0010:[<ffffffff80240061>]  [<ffffffff80240061>]
> >> get_next_timer_interrupt+0x11b/0x1f0
> >
> > Can you please enable:
> >
> > CONFIG_DEBUG_OBJECTS=y
> > CONFIG_DEBUG_OBJECTS_FREE=y
> > CONFIG_DEBUG_OBJECTS_TIMERS=Y
> >
> > and add "debug_objects" to the kernel command line ?
> 
> I added these options:

Thanks.
 
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> hpet0: 3 comparators, 64-bit 14.318180 MHz counter
> ODEBUG: object is on stack, but not annotated

ok, that's homework for me.

> scsi0 : LSI SAS based MegaRAID driver
> Driver 'sd' needs updating - please use bus_type methods
> scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HE160HJ  0-24 PQ: 0 ANSI: 5
> ------------[ cut here ]------------
> WARNING: at lib/debugobjects.c:215 debug_print_object+0x4f/0x57()
> ODEBUG: free active object type: timer_list

That's the cause for your boot crash. The scsi/blk code is freeing a
page which contains an active timer, so the timer code references gone
memory. You triggered it because DEBUG_PAGEALLOC unmaps the page when
it's freed.

James, or other scsi experts please.

> Modules linked in:
> Pid: 580, comm: scsi_scan_0 Tainted: G        W  2.6.28-rc5-next-20081119 #9
> Call Trace:
>  [<ffffffff80236b28>] warn_slowpath+0xae/0xd5
>  [<ffffffff8037f9e8>] ? debug_check_no_obj_freed+0x75/0x1c8
>  [<ffffffff8037f8b1>] debug_print_object+0x4f/0x57
>  [<ffffffff8037fa0f>] debug_check_no_obj_freed+0x9c/0x1c8
>  [<ffffffff8029c7b2>] kmem_cache_free+0x64/0xc0
>  [<ffffffff8036a6e0>] ? blk_release_queue+0x61/0x66
>  [<ffffffff8036a6e0>] blk_release_queue+0x61/0x66
>  [<ffffffff803760f2>] kobject_release+0x52/0x68
>  [<ffffffff803760a0>] ? kobject_release+0x0/0x68
>  [<ffffffff80376ec5>] kref_put+0x43/0x4f
>  [<ffffffff80375ffa>] kobject_put+0x47/0x4b
>  [<ffffffff80368c53>] blk_cleanup_queue+0x57/0x5c
>  [<ffffffff803f8729>] scsi_free_queue+0x9/0xb
>  [<ffffffff803fd3c7>] scsi_device_dev_release_usercontext+0xdc/0x127
>  [<ffffffff803fd2eb>] ? scsi_device_dev_release_usercontext+0x0/0x127
>  [<ffffffff802472a8>] execute_in_process_context+0x2a/0x70
>  [<ffffffff803fd2e9>] scsi_device_dev_release+0x17/0x19
>  [<ffffffff803e03e0>] device_release+0x43/0x68
>  [<ffffffff803760f2>] kobject_release+0x52/0x68
>  [<ffffffff803760a0>] ? kobject_release+0x0/0x68
>  [<ffffffff80376ec5>] kref_put+0x43/0x4f
>  [<ffffffff80375ffa>] kobject_put+0x47/0x4b
>  [<ffffffff803dfd36>] put_device+0x15/0x17
>  [<ffffffff803fa772>] scsi_destroy_sdev+0x48/0x4c
>  [<ffffffff803fba05>] scsi_probe_and_add_lun+0xb5d/0xb81
>  [<ffffffff803faaba>] ? scsi_alloc_target+0x22b/0x267
>  [<ffffffff803fbcb0>] __scsi_scan_target+0x9d/0x598
>  [<ffffffff8025767c>] ? trace_hardirqs_on_caller+0x1f/0x153
>  [<ffffffff804e39a9>] ? __mutex_lock_common+0x371/0x3be
>  [<ffffffff803fc2d9>] ? scsi_scan_host_selected+0xb6/0x133
>  [<ffffffff8025767c>] ? trace_hardirqs_on_caller+0x1f/0x153
>  [<ffffffff803fc2d9>] ? scsi_scan_host_selected+0xb6/0x133
>  [<ffffffff803fc1fd>] scsi_scan_channel+0x52/0x78
>  [<ffffffff803fc314>] scsi_scan_host_selected+0xf1/0x133
>  [<ffffffff803fc3c6>] ? do_scan_async+0x0/0x127
>  [<ffffffff803fc3c1>] do_scsi_scan_host+0x6b/0x70
>  [<ffffffff803fc3c6>] ? do_scan_async+0x0/0x127
>  [<ffffffff803fc3dd>] do_scan_async+0x17/0x127
>  [<ffffffff803fc3c6>] ? do_scan_async+0x0/0x127
>  [<ffffffff80249d5d>] kthread+0x49/0x76
>  [<ffffffff8020c899>] child_rip+0xa/0x11
>  [<ffffffff8020bd88>] ? restore_args+0x0/0x30
>  [<ffffffff80249d14>] ? kthread+0x0/0x76
>  [<ffffffff8020c88f>] ? child_rip+0x0/0x11
> ---[ end trace 4eaa2a86a8e2da22 ]---
> <...>
> ata2: port disabled. ignoring.
> scsi: waiting for bus probes to complete ...
> WARNING: at lib/debugobjects.c:215 debug_print_object+0x4f/0x57()
> ODEBUG: free active object type: timer_list

Same as above.

> BUG: using smp_processor_id() in preemptible [00000000] code: init-early.sh/741
> caller is sock_prot_inuse_add+0x24/0x42
> Pid: 741, comm: init-early.sh Tainted: G        W  2.6.28-rc5-next-20081119 #9
> Call Trace:
>  [<ffffffff8037f622>] debug_smp_processor_id+0xca/0xe0
>  [<ffffffff8046ab5b>] sock_prot_inuse_add+0x24/0x42
>  [<ffffffff804bb124>] unix_create1+0x161/0x176
>  [<ffffffff804bb196>] unix_create+0x5d/0x68
>  [<ffffffff80469368>] __sock_create+0x114/0x17e
>  [<ffffffff80469420>] sock_create+0x2d/0x2f
>  [<ffffffff80469623>] sys_socket+0x29/0x5c
>  [<ffffffff8020b74b>] system_call_fastpath+0x16/0x1b

Dave ???

Thanks,

	tglx
