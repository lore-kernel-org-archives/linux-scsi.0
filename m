From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [lkp-robot] [rcu] b332151a29: kernel_BUG_at_mm/slab.c
Date: Fri, 20 Jan 2017 18:09:08 +0100
Message-ID: <20170120170907.u7ekube62edg32qr@linutronix.de>
References: <20170119010216.GA8287@yexl-desktop>
 <20170120160123.z4llgm4qaaemkp52@linutronix.de>
 <32585b54-c2fd-66ea-e636-bdbd387133c1@kernel.dk>
 <20170120162354.776bf2j75o247mzu@linutronix.de>
 <daab32d4-6cbd-3217-df25-42ebf6f684ce@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <daab32d4-6cbd-3217-df25-42ebf6f684ce@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: kernel test robot <xiaolong.ye@intel.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org, linux-scsi@vger.kernel.org, tglx@linutronix.de, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-01-20 08:32:37 [-0800], Jens Axboe wrote:
> That's alright, sounds like it's not a -next regression, but rather something
> that is already broken. I can reproduce a lot of breakage if I enable
> CONFIG_DEBUG_TEST_DRIVER_REMOVE, in fact my system doesn't boot at all. This
> is the first bug:
> 
> [   18.247895] ------------[ cut here ]------------
> [   18.247907] WARNING: CPU: 21 PID: 2223 at drivers/ata/libata-core.c:6522 ata_host_detach+0x11b]
> [   18.247908] Modules linked in: igb(+) ahci(+) libahci i2c_algo_bit dca libata nvme(+) nvme_core
> [   18.247917] CPU: 21 PID: 2223 Comm: systemd-udevd Tainted: G        W       4.10.0-rc4+ #30
> [   18.247919] Hardware name: Dell Inc. PowerEdge T630/0NT78X, BIOS 2.3.4 11/09/2016
> [   18.247919] Call Trace:
> [   18.247928]  dump_stack+0x68/0x93
> [   18.247934]  __warn+0xc6/0xe0
> [   18.247937]  warn_slowpath_null+0x18/0x20
> [   18.247943]  ata_host_detach+0x11b/0x120 [libata]
…

> and it's even more downhill from there. That option is marked unstable, are we
> expecting it to work right now?

Well, as per 248ff0216543 ("driver core: Make Kconfig text for
DEBUG_TEST_DRIVER_REMOVE stronger"):

|   The current state of driver removal is not great.
|   CONFIG_DEBUG_TEST_DRIVER_REMOVE finds lots of errors. The help text
|   currently undersells exactly how many errors this option will find. Add
|   a bit more description to indicate this option shouldn't be turned on
|   unless you actually want to debug driver removal. The text can be
|   changed later when more drivers are fixed up.

so it looks like the option is working but it uncovers bugs. I've put
you in TO because the breakage in kvm test went away after I disabled
the MQ support in SCSI. So I *assumed* that MQ was not doing something
right in the removal path. I don't know if this libata-core backtrace is
a false positive or not.

Sebastian
