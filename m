From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [lkp-robot] [rcu]  b332151a29: kernel_BUG_at_mm/slab.c
Date: Fri, 20 Jan 2017 17:01:23 +0100
Message-ID: <20170120160123.z4llgm4qaaemkp52@linutronix.de>
References: <20170119010216.GA8287@yexl-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170119010216.GA8287@yexl-desktop>
Sender: linux-block-owner@vger.kernel.org
To: kernel test robot <xiaolong.ye@intel.com>, Jens Axboe <axboe@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org, linux-scsi@vger.kernel.org, tglx@linutronix.de, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-01-19 09:02:16 [+0800], kernel test robot wrote:
> test-description: Trinity is a linux system call fuzz tester.

you don't even get to fire up trinity. With and without the patch you
crash very early.

> +-----------------------------------------------------+------------+------------+
> |                                                     | d5f6ab9c11 | b332151a29 |
> +-----------------------------------------------------+------------+------------+
> | boot_successes                                      | 0          | 0          |
> | boot_failures                                       | 6          | 8          |
> | WARNING:at_include/linux/kref.h:#kobject_get        | 6          | 8          |
> | WARNING:at_arch/x86/mm/dump_pagetables.c:#note_page | 2          | 2          |
> | kernel_BUG_at_mm/slab.c                             | 0          | 4          |
> | invalid_opcode:#[##]PREEMPT_SMP                     | 0          | 4          |
> | Kernel_panic-not_syncing:Fatal_exception            | 0          | 6          |
> | BUG:unable_to_handle_kernel                         | 0          | 2          |
> | Oops                                                | 0          | 2          |
> +-----------------------------------------------------+------------+------------+

There is no successful boot. The pattern changes with patch in question
applied.

> [    8.044624] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [    8.055721] slab: double free detected in cache 'kmalloc-32', objp 8af558c0
> [    8.057138] ------------[ cut here ]------------
> [    8.058085] kernel BUG at mm/slab.c:2624!
> [    8.059255] invalid opcode: 0000 [#1] PREEMPT SMP

yes. With and without the patch there is a lot of wrong stuff like
complains about a kobject initialized again. This leads to a double free
at some point.

What happens is the following: CONFIG_SCSI_DEBUG is enabled which adds a
dummy host controller with a dummy disk. This gets probed during boot.
Since you also enabled CONFIG_DEBUG_TEST_DRIVER_REMOVE it gets removed
and re-added. The request_queue in genhd disk is re-used while the disk
is added for the second time:

[    1.314404] scsi host0: scsi_debug: version 1.86 [20160430]
[    1.314404]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    1.315994] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[    1.351052] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    1.355916] sd 0:0:0:0: [sda] Write Protect is off
[    1.356838] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.364455] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.437642] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.438413] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[    1.445868] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[    1.450819] sd 0:0:0:0: [sda] Write Protect is off
[    1.451853] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[    1.459636] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    1.471446] kobject (beb87d44): tried to init an initialized object, something is seriously wrong.

Since you also need CONFIG_SCSI_MQ_DEFAULT enabled I assume the MQ block
code is buggy here.
But commit b332151a29 in Paul's tree innocent.

Sebastian
