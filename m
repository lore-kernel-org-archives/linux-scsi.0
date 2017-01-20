From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [lkp-robot] [rcu] b332151a29: kernel_BUG_at_mm/slab.c
Date: Fri, 20 Jan 2017 08:09:36 -0800
Message-ID: <32585b54-c2fd-66ea-e636-bdbd387133c1@kernel.dk>
References: <20170119010216.GA8287@yexl-desktop>
 <20170120160123.z4llgm4qaaemkp52@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170120160123.z4llgm4qaaemkp52@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, kernel test robot <xiaolong.ye@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org, linux-scsi@vger.kernel.org, tglx@linutronix.de, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/20/2017 08:01 AM, Sebastian Andrzej Siewior wrote:
> On 2017-01-19 09:02:16 [+0800], kernel test robot wrote:
>> test-description: Trinity is a linux system call fuzz tester.
> 
> you don't even get to fire up trinity. With and without the patch you
> crash very early.
> 
>> +-----------------------------------------------------+------------+------------+
>> |                                                     | d5f6ab9c11 | b332151a29 |
>> +-----------------------------------------------------+------------+------------+
>> | boot_successes                                      | 0          | 0          |
>> | boot_failures                                       | 6          | 8          |
>> | WARNING:at_include/linux/kref.h:#kobject_get        | 6          | 8          |
>> | WARNING:at_arch/x86/mm/dump_pagetables.c:#note_page | 2          | 2          |
>> | kernel_BUG_at_mm/slab.c                             | 0          | 4          |
>> | invalid_opcode:#[##]PREEMPT_SMP                     | 0          | 4          |
>> | Kernel_panic-not_syncing:Fatal_exception            | 0          | 6          |
>> | BUG:unable_to_handle_kernel                         | 0          | 2          |
>> | Oops                                                | 0          | 2          |
>> +-----------------------------------------------------+------------+------------+
> 
> There is no successful boot. The pattern changes with patch in question
> applied.
> 
>> [    8.044624] sd 0:0:0:0: [sda] Synchronizing SCSI cache
>> [    8.055721] slab: double free detected in cache 'kmalloc-32', objp 8af558c0
>> [    8.057138] ------------[ cut here ]------------
>> [    8.058085] kernel BUG at mm/slab.c:2624!
>> [    8.059255] invalid opcode: 0000 [#1] PREEMPT SMP

Is there a full trace of this?

> yes. With and without the patch there is a lot of wrong stuff like
> complains about a kobject initialized again. This leads to a double free
> at some point.

And what patch are we talking about? I don't mind being CC'ed into a thread,
but some context and background would be immensely helpful here...

-- 
Jens Axboe
