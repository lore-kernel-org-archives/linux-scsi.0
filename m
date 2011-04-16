From: Chris Ball <cjb@laptop.org>
Subject: Re: 2.6.38.3 ss boot problem and crash
Date: Sat, 16 Apr 2011 18:05:07 -0400
Message-ID: <m38vv9svho.fsf@pullcord.laptop.org>
References: <web-506418104@zbackend1.aha.ru>
	<20110416213927.GA23518@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20110416213927.GA23518@mtj.dyndns.org> (Tejun Heo's message of
	"Sun, 17 Apr 2011 06:39:27 +0900")
Sender: linux-mmc-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: werner <w.landgraf@ru.ru>, James.Bottomley@HansenPartnership.com, mingo@elte.hu, Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de, randy.dunlap@oracle.com, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-mmc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Marek Szyprowski <m.szyprowski@samsung.com>
List-Id: linux-scsi@vger.kernel.org

Hi Werner,

(adding Marek and Linus W)

On Sat, Apr 16 2011, Tejun Heo wrote:
> Duplicate sysfs creation from mmc code.  Cc'ing linux-mmc and quoting
> whole body.
>
> On Sat, Apr 16, 2011 at 03:11:02PM -0400, werner wrote:
>> sdhci: Secure Digital Host Controller Interface driver
>> sdhci: Copyright(c) Pierre Ossman
>> sdhci-pci 0000:02:0b.4: SDHCI controller found [104c:8034] (rev 0)
>> sdhci-pci 0000:02:0b.4: enabling device (0000 -> 0002)
>> sdhci-pci 0000:02:0b.4: PCI INT D -> Link[LNKD] -> GSI 11 (level,
>> low) -> IRQ 11
>> _regulator_get: 0000:02:0b.4 supply vmmc not found, using dummy
>> regulator
>> Registered led device: mmc0::
>> mmc0: SDHCI controller on PCI [0000:02:0b.4] using DMA
>> _regulator_get: 0000:02:0b.4 supply vmmc not found, using dummy
>> regulator
>> ------------[ cut here ]------------
>> WARNING: at fs/sysfs/dir.c:455 sysfs_add_one+0x83/0x95()
>> Hardware name: Qosmio E10
>> sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1e.0/0000:02:0b.4/microamps_requested_vmmc'
>> Modules linked in:
>> Pid: 1, comm: swapper Not tainted 2.6.38.3 #1
>> Call Trace:
>>  [<c111ff03>] ? sysfs_add_one+0x83/0x95
>>  [<c103cfc7>] ? warn_slowpath_common+0x7a/0x8f
>>  [<c111ff03>] ? sysfs_add_one+0x83/0x95
>>  [<c103d067>] ? warn_slowpath_fmt+0x33/0x35
>>  [<c111ff03>] ? sysfs_add_one+0x83/0x95
>>  [<c111f903>] ? sysfs_add_file_mode+0x4a/0x72
>>  [<c111f943>] ? sysfs_add_file+0x18/0x1c
>>  [<c111f9de>] ? sysfs_create_file+0x25/0x27
>>  [<c1753adb>] ? device_create_file+0x18/0x1a
>>  [<c165b957>] ? _regulator_get+0x224/0x3b7
>>  [<c107a02f>] ? request_threaded_irq+0xb9/0xe5
>>  [<c165bb0d>] ? regulator_get+0xf/0x11
>>  [<c1c39b53>] ? sdhci_add_host+0x580/0x6cb
>>  [<c156d3ec>] ? pci_ioremap_bar+0x5b/0x5f
>>  [<c1da4754>] ? sdhci_pci_probe+0x339/0x3e2
>>  [<c156d609>] ? local_pci_probe+0x41/0x85
>>  [<c156e17e>] ? pci_device_probe+0x48/0x6b
>>  [<c1755c6c>] ? driver_probe_device+0x9c/0x145
>>  [<c156d5a3>] ? pci_match_device+0x96/0x9c
>>  [<c1dbab2a>] ? _cond_resched+0x8/0x47
>>  [<c1755d5d>] ? __driver_attach+0x48/0x64
>>  [<c17555ad>] ? bus_for_each_dev+0x42/0x6c
>>  [<c1755af5>] ? driver_attach+0x1e/0x20
>>  [<c1755d15>] ? __driver_attach+0x0/0x64
>>  [<c1754fc2>] ? bus_add_driver+0xc6/0x20a
>>  [<c1755fef>] ? driver_register+0x98/0xf8
>>  [<c1755fef>] ? driver_register+0x98/0xf8
>>  [<c165d19a>] ? tty_register_driver+0x15e/0x1e2
>>  [<c156e36b>] ? __pci_register_driver+0x3d/0x96
>>  [<c1dba0d5>] ? printk+0x1d/0x1f
>>  [<c23255b7>] ? sdhci_drv_init+0x14/0x16
>>  [<c100117e>] ? do_one_initcall+0x8c/0x142
>>  [<c1079038>] ? irq_to_desc+0x8/0x1e
>>  [<c23255a3>] ? sdhci_drv_init+0x0/0x16
>>  [<c22c4380>] ? kernel_init+0x101/0x19a
>>  [<c22c427f>] ? kernel_init+0x0/0x19a
>>  [<c1003b46>] ? kernel_thread_helper+0x6/0x10
>> ---[ end trace 120ecbe82d809816 ]---
>> create_regulator: dummy: could not add regulator_dev requested
>> microamps sysfs entry

Looks like you have CONFIG_REGULATOR_DUMMY=y turned on.  Could you try
booting without it?

Perhaps we have a problem with regulator handling when the vmmc is a
dummy regulator?  I'll try this out locally.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
