From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [lkp-robot] [rcu] b332151a29: kernel_BUG_at_mm/slab.c
Date: Fri, 20 Jan 2017 08:32:37 -0800
Message-ID: <daab32d4-6cbd-3217-df25-42ebf6f684ce@kernel.dk>
References: <20170119010216.GA8287@yexl-desktop>
 <20170120160123.z4llgm4qaaemkp52@linutronix.de>
 <32585b54-c2fd-66ea-e636-bdbd387133c1@kernel.dk>
 <20170120162354.776bf2j75o247mzu@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170120162354.776bf2j75o247mzu@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: kernel test robot <xiaolong.ye@intel.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org, linux-scsi@vger.kernel.org, tglx@linutronix.de, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/20/2017 08:23 AM, Sebastian Andrzej Siewior wrote:
>>> yes. With and without the patch there is a lot of wrong stuff like
>>> complains about a kobject initialized again. This leads to a double free
>>> at some point.
>>
>> And what patch are we talking about? I don't mind being CC'ed into a thread,
>> but some context and background would be immensely helpful here...
> 
> The patch is irrelevant. lkp-robot found a bug which was there before
> the patch in question but the pattern changed so it blamed the Author.
> It triggers even v4.9 with
>   CONFIG_SCSI_DEBUG
>   CONFIG_DEBUG_TEST_DRIVER_REMOVE
>   CONFIG_SCSI_MQ_DEFAULT
> enabled and CONFIG_SCSI_DEBUG is simply a SCSI host controller which is
> always there. I can send you a complete config against current HEAD
> which boots in kvm if you want.

That's alright, sounds like it's not a -next regression, but rather something
that is already broken. I can reproduce a lot of breakage if I enable
CONFIG_DEBUG_TEST_DRIVER_REMOVE, in fact my system doesn't boot at all. This
is the first bug:

[   18.247895] ------------[ cut here ]------------
[   18.247907] WARNING: CPU: 21 PID: 2223 at drivers/ata/libata-core.c:6522 ata_host_detach+0x11b]
[   18.247908] Modules linked in: igb(+) ahci(+) libahci i2c_algo_bit dca libata nvme(+) nvme_core
[   18.247917] CPU: 21 PID: 2223 Comm: systemd-udevd Tainted: G        W       4.10.0-rc4+ #30
[   18.247919] Hardware name: Dell Inc. PowerEdge T630/0NT78X, BIOS 2.3.4 11/09/2016
[   18.247919] Call Trace:
[   18.247928]  dump_stack+0x68/0x93
[   18.247934]  __warn+0xc6/0xe0
[   18.247937]  warn_slowpath_null+0x18/0x20
[   18.247943]  ata_host_detach+0x11b/0x120 [libata]
[   18.247950]  ata_pci_remove_one+0x10/0x20 [libata]
[   18.247955]  ahci_remove_one+0x10/0x20 [ahci]
[   18.247958]  pci_device_remove+0x34/0xb0
[   18.247966]  driver_probe_device+0xd0/0x370
[   18.247969]  __driver_attach+0x9a/0xa0
[   18.247971]  ? driver_probe_device+0x370/0x370
[   18.247973]  bus_for_each_dev+0x5d/0x90
[   18.247975]  driver_attach+0x19/0x20
[   18.247977]  bus_add_driver+0x11f/0x220
[   18.247980]  driver_register+0x5b/0xd0
[   18.247982]  __pci_register_driver+0x58/0x60
[   18.247984]  ? 0xffffffffa00d9000
[   18.247988]  ahci_pci_driver_init+0x1e/0x20 [ahci]
[   18.247992]  do_one_initcall+0x3e/0x170
[   18.247997]  ? rcu_read_lock_sched_held+0x45/0x80
[   18.248001]  ? kmem_cache_alloc_trace+0x22e/0x290
[   18.248004]  do_init_module+0x5a/0x1cb
[   18.248007]  load_module+0x1e60/0x2570
[   18.248008]  ? __symbol_put+0x70/0x70
[   18.248010]  ? show_coresize+0x30/0x30
[   18.248013]  ? kernel_read_file+0x19e/0x1c0
[   18.248015]  ? kernel_read_file_from_fd+0x44/0x70
[   18.248016]  SYSC_finit_module+0xba/0xc0
[   18.248018]  SyS_finit_module+0x9/0x10
[   18.248021]  entry_SYSCALL_64_fastpath+0x18/0xad
[   18.248022] RIP: 0033:0x7f49c5a645b9
[   18.248023] RSP: 002b:00007ffccf512658 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   18.248025] RAX: ffffffffffffffda RBX: 00007f49c61659dd RCX: 00007f49c5a645b9
[   18.248026] RDX: 0000000000000000 RSI: 00007f49c53152c7 RDI: 0000000000000009
[   18.248026] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000000000000000
[   18.248027] R10: 0000000000000009 R11: 0000000000000246 R12: 0000555737e82b30
[   18.248028] R13: 0000555737e71200 R14: 0000555737e82b30 R15: 0000000000000000
[   18.248030] ---[ end trace b0ae5eae3430d5d6 ]---

and it's even more downhill from there. That option is marked unstable, are we
expecting it to work right now?

-- 
Jens Axboe
