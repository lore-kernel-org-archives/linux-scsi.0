From: Jesper Krogh <jesper@krogh.cc>
Subject: Re: Media autochanger driver changed behavior.
Date: Wed, 10 Sep 2008 13:10:55 +0200
Message-ID: <48C7AB3F.5020101@krogh.cc>
References: <487524B9.7000203@krogh.cc>	 <1215640274.3444.42.camel@localhost.localdomain>	 <4875342B.5060702@krogh.cc>	 <1215641850.3444.52.camel@localhost.localdomain>	 <4875A53E.4030909@krogh.cc> <1215698421.3353.15.camel@localhost.localdomain> <4877B146.3090503@krogh.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:33126 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbYIJLlp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2008 07:41:45 -0400
In-Reply-To: <4877B146.3090503@krogh.cc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>

Jesper Krogh wrote:
> James Bottomley wrote:
>> On Thu, 2008-07-10 at 07:59 +0200, Jesper Krogh wrote:
>>> James Bottomley wrote:
>>>> On Wed, 2008-07-09 at 23:56 +0200, Jesper Krogh wrote:
>>>>> James Bottomley wrote:
>>>>>> On Wed, 2008-07-09 at 22:51 +0200, Jesper Krogh wrote:
>>>>>>> Hi.
>>>>>>>
>>>>>>> Upgrading the OS from an quite old kernel to a newer (2.6.24) 
>>>>>>> changed
>>>>>>> the behavior of the "ch" driver. Now it does a inventory to the 
>>>>>>> changer
>>>>>>> on load. This command makes the barcode-reader scan the entire 
>>>>>>> library
>>>>>>> at driver load time.
>>>>>> Do I take it from this that your old kernel simply didn't auto 
>>>>>> load the
>>>>>> ch driver?  or that something has changed in the way the driver now
>>>>>> works?
>>>>> It sure did load the driver and it worked just fine. It just didnt 
>>>>> make the library unit force scan the barcodes. (the library do that 
>>>>> on bootup by itself, but it can be forced with mtx over the changer 
>>>>> device).
>>>>>
>>>>> mtx -f /dev/changer inventory => Force scans barcodes
>>>>> mtx -f /dev/changer status => Reads out the barcodes labels and slots
>>>>> from the changer device without forcing the library to scan.
>>>>> (note I dont know if it is library specific).
>>>> OK, so it's not the autoloading code which I thought it might be.
>>>>
>>>> Which is the latest version of the kernel that works? ... that will at
>>>> least give me the set of changes to look at.
>>> I cant give you that, since I havent testet all, but I'm quite sure 
>>> 2.6.20 worked,
>>> completely sure that 2.6.15 was Ok.
>>>
>>> I know this is a large timespan, sorry.
>>
>> It would be enormously helpful if you could boot 2.6.20 and confirm.
>> There are 3 changes to ch between 2.6.20 and 2.6.24.  There are 8
>> between 2.6.15 and 2.6.24.
> 
> I'll get it done and report but, but we're a bit behind on the 
> backup-schedules. So when the system has catched up I'll do some testing.
> 

It troubled med to get back to "that old" a kernel. I have a fresh dmesg 
  here from a 2.6.26.1 kernel. New stuff is that I get the 120 seconds 
message.

[   28.475059] ch0: type #1 (mt): 0x0+1 [medium transport]
[   28.475111] ch0: type #2 (st): 0x100+100 [storage]
[   28.475157] ch0: type #3 (ie): 0x500+0 [import/export]
[   28.475203] ch0: type #4 (dt): 0x80+1 [data transfer]
[   28.496792] ch0: dt 0x80: ID 3, LUN 0, name: HP       Ultrium 3-SCSI 
   G39Z
[   28.496812] ch0: INITIALIZE ELEMENT STATUS, may take some time ...
[   29.561479] e1000: eth0: e1000_watchdog: NIC Link is Up 1000 Mbps 
Full Duplex, Flow Control: RX
[   29.965913] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   30.009427] shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
[   30.009427] shpchp: shpc_init: cannot reserve MMIO region
[   30.009427] shpchp: HPC vendor_id 1022 device_id 7458 ss_vid 0 ss_did 0
[   30.009427] shpchp: shpc_init: cannot reserve MMIO region
[   30.013471] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   30.208019] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x6000
[   30.208096] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x6040
[   30.354692] input: Power Button (FF) as /class/input/input4
[   30.412413] input: PC Speaker as /class/input/input5
[   30.431263] ACPI: Power Button (FF) [PWRF]
[   30.431416] input: Power Button (CM) as /class/input/input6
[   30.497468] ACPI: Power Button (CM) [PWRB]
[   30.613129] NET: Registered protocol family 10
[   30.613706] lo: Disabled Privacy Extensions
[   31.140157] warning: `ntpd' uses 32-bit capabilities (legacy support 
in use)
[   41.121412] eth0: no IPv6 routers present
[  157.841224] INFO: task modprobe:3924 blocked for more than 120 seconds.
[  157.841280] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  157.841629] modprobe      D ffff810001044280     0  3924      1
[  157.842550]  ffff8102fe4a7918 0000000000000086 0000000000000000 
ffff8102fe4d2280
[  157.842711]  ffffffff8061e280 ffffffff8061e280 ffffffff8061a4e0 
ffffffff8061e280
[  157.842869]  ffff8102fb1b0dc8 ffff8102fe4a78e4 ffff8102fe4a78d8 
ffff8102fe4a78c8
[  157.842990] Call Trace:
[  157.843089]  [<ffffffffa01084eb>] :mptscsih:mptscsih_qcmd+0x22b/0x5c0
[  157.843146]  [<ffffffff8044d175>] schedule_timeout+0x95/0xd0
[  157.843198]  [<ffffffff8031fd8b>] elv_next_request+0x5b/0x250
[  157.843271]  [<ffffffffa006cf2f>] :scsi_mod:scsi_dispatch_cmd+0x12f/0x2e0
[  157.843323]  [<ffffffff8044cec5>] wait_for_common+0xa5/0x160
[  157.843374]  [<ffffffff8022a9b0>] default_wake_function+0x0/0x10
[  157.843428]  [<ffffffff8032553f>] blk_execute_rq+0x9f/0x110
[  157.843477]  [<ffffffff803227b1>] get_request_wait+0x21/0x180
[  157.843539]  [<ffffffffa007367c>] :scsi_mod:scsi_execute+0xec/0x150
[  157.843597]  [<ffffffffa0073771>] :scsi_mod:scsi_execute_req+0x91/0x100
[  157.843653]  [<ffffffffa01ad12b>] :ch:ch_do_scsi+0x7b/0x1b0
[  157.843705]  [<ffffffffa01ad425>] :ch:ch_read_element_status+0x135/0x1a0
[  157.843758]  [<ffffffffa01ad2a8>] :ch:ch_init_elem+0x48/0x90
[  157.843808]  [<ffffffffa01ae80c>] :ch:ch_probe+0x4bc/0x760
[  157.843864]  [<ffffffff803a0e56>] driver_probe_device+0x96/0x190
[  157.843915]  [<ffffffff803a0fd9>] __driver_attach+0x89/0x90
[  157.843964]  [<ffffffff803a0f50>] __driver_attach+0x0/0x90
[  157.844013]  [<ffffffff803a046d>] bus_for_each_dev+0x4d/0x80
[  157.844064]  [<ffffffff80293a15>] kmem_cache_alloc+0x65/0xa0
[  157.844114]  [<ffffffff803a0ab5>] bus_add_driver+0x1f5/0x270
[  157.844165]  [<ffffffff803a1265>] driver_register+0x55/0x140
[  157.844216]  [<ffffffffa005b05d>] :ch:init_ch_module+0x5d/0xa6
[  157.844266]  [<ffffffff80257a2a>] sys_init_module+0x17a/0x1d00
[  157.844333]  [<ffffffff8020c2ab>] system_call_after_swapgs+0x7b/0x80
[  157.844386]
[  157.844427] INFO: task modprobe:3939 blocked for more than 120 seconds.
[  157.844478] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  157.844544] modprobe      D ffff810001044280     0  3939   3938
[  157.844641]  ffff8105fb6bbbf8 0000000000000086 0000000000000000 
0000000000000000
[  157.844800]  ffffffff8061e280 ffffffff8061e280 ffffffff8061a4e0 
ffffffff8061e280
[  157.844956]  ffff8105fb4eef88 ffff8105fb6bbbc4 ffff8105fb6bbbb8 
ffff8105fb6bbba8
[  157.845078] Call Trace:
[  157.845164]  [<ffffffff802ef36b>] create_dir+0x6b/0xb0
[  157.845214]  [<ffffffff8044d175>] schedule_timeout+0x95/0xd0
[  157.845265]  [<ffffffff80331bcf>] kobject_add_internal+0xdf/0x1c0
[  157.846597]  [<ffffffff80331e3e>] kobject_init_and_add+0x6e/0x90
[  157.846647]  [<ffffffff8044da46>] __down+0x56/0x90
[  157.846696]  [<ffffffff8024cf07>] down+0x47/0x50
[  157.846744]  [<ffffffff803a0f80>] __driver_attach+0x30/0x90
[  157.846792]  [<ffffffff803a0f50>] __driver_attach+0x0/0x90
[  157.846841]  [<ffffffff803a046d>] bus_for_each_dev+0x4d/0x80
[  157.846891]  [<ffffffff80293a15>] kmem_cache_alloc+0x65/0xa0
[  157.846940]  [<ffffffff803a0ab5>] bus_add_driver+0x1f5/0x270
[  157.846991]  [<ffffffff803a1265>] driver_register+0x55/0x140
[  157.847044]  [<ffffffffa00610bc>] :st:init_st+0xbc/0x1be
[  157.847092]  [<ffffffff80257a2a>] sys_init_module+0x17a/0x1d00
[  157.847150]  [<ffffffff8028bb30>] alloc_pages_current+0x0/0xe0
[  157.847205]  [<ffffffff8020c2ab>] system_call_after_swapgs+0x7b/0x80
[  157.847258]
[  210.928038] loop: module loaded
[  210.985319] lp: driver loaded but no devices found
[  286.691381] INFO: task modprobe:3924 blocked for more than 120 seconds.
[  286.691436] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  286.692482] modprobe      D ffff810001044280     0  3924      1
[  286.692580]  ffff8102fe4a7918 0000000000000086 0000000000000000 
ffff8102fe4d2280
[  286.693507]  ffffffff8061e280 ffffffff8061e280 ffffffff8061a4e0 
ffffffff8061e280
[  286.693665]  ffff8102fb1b0dc8 ffff8102fe4a78e4 ffff8102fe4a78d8 
ffff8102fe4a78c8
[  286.693787] Call Trace:
[  286.693883]  [<ffffffffa01084eb>] :mptscsih:mptscsih_qcmd+0x22b/0x5c0
[  286.693939]  [<ffffffff8044d175>] schedule_timeout+0x95/0xd0
[  286.693991]  [<ffffffff8031fd8b>] elv_next_request+0x5b/0x250
[  286.694063]  [<ffffffffa006cf2f>] :scsi_mod:scsi_dispatch_cmd+0x12f/0x2e0
[  286.694116]  [<ffffffff8044cec5>] wait_for_common+0xa5/0x160
[  286.694167]  [<ffffffff8022a9b0>] default_wake_function+0x0/0x10
[  286.694220]  [<ffffffff8032553f>] blk_execute_rq+0x9f/0x110
[  286.694270]  [<ffffffff803227b1>] get_request_wait+0x21/0x180
[  286.694332]  [<ffffffffa007367c>] :scsi_mod:scsi_execute+0xec/0x150
[  286.694391]  [<ffffffffa0073771>] :scsi_mod:scsi_execute_req+0x91/0x100
[  286.694447]  [<ffffffffa01ad12b>] :ch:ch_do_scsi+0x7b/0x1b0
[  286.694498]  [<ffffffffa01ad425>] :ch:ch_read_element_status+0x135/0x1a0
[  286.694551]  [<ffffffffa01ad2a8>] :ch:ch_init_elem+0x48/0x90
[  286.694604]  [<ffffffffa01ae80c>] :ch:ch_probe+0x4bc/0x760
[  286.694660]  [<ffffffff803a0e56>] driver_probe_device+0x96/0x190
[  286.694712]  [<ffffffff803a0fd9>] __driver_attach+0x89/0x90
[  286.694761]  [<ffffffff803a0f50>] __driver_attach+0x0/0x90
[  286.694810]  [<ffffffff803a046d>] bus_for_each_dev+0x4d/0x80
[  286.694861]  [<ffffffff80293a15>] kmem_cache_alloc+0x65/0xa0
[  286.694913]  [<ffffffff803a0ab5>] bus_add_driver+0x1f5/0x270
[  286.694964]  [<ffffffff803a1265>] driver_register+0x55/0x140
[  286.695017]  [<ffffffffa005b05d>] :ch:init_ch_module+0x5d/0xa6
[  286.695067]  [<ffffffff80257a2a>] sys_init_module+0x17a/0x1d00
[  286.695135]  [<ffffffff8020c2ab>] system_call_after_swapgs+0x7b/0x80
[  286.695188]
[  286.695229] INFO: task modprobe:3939 blocked for more than 120 seconds.
[  286.695279] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
disables this message.
[  286.695345] modprobe      D ffff810001044280     0  3939   3938
[  286.695440]  ffff8105fb6bbbf8 0000000000000086 0000000000000000 
0000000000000000
[  286.695600]  ffffffff8061e280 ffffffff8061e280 ffffffff8061a4e0 
ffffffff8061e280
[  286.695759]  ffff8105fb4eef88 ffff8105fb6bbbc4 ffff8105fb6bbbb8 
ffff8105fb6bbba8
[  286.695880] Call Trace:
[  286.695966]  [<ffffffff802ef36b>] create_dir+0x6b/0xb0
[  286.696016]  [<ffffffff8044d175>] schedule_timeout+0x95/0xd0
[  286.696067]  [<ffffffff80331bcf>] kobject_add_internal+0xdf/0x1c0
[  286.696117]  [<ffffffff80331e3e>] kobject_init_and_add+0x6e/0x90
[  286.696168]  [<ffffffff8044da46>] __down+0x56/0x90
[  286.696218]  [<ffffffff8024cf07>] down+0x47/0x50
[  286.696266]  [<ffffffff803a0f80>] __driver_attach+0x30/0x90
[  286.696316]  [<ffffffff803a0f50>] __driver_attach+0x0/0x90
[  286.696364]  [<ffffffff803a046d>] bus_for_each_dev+0x4d/0x80
[  286.696413]  [<ffffffff80293a15>] kmem_cache_alloc+0x65/0xa0
[  286.696463]  [<ffffffff803a0ab5>] bus_add_driver+0x1f5/0x270
[  286.696514]  [<ffffffff803a1265>] driver_register+0x55/0x140
[  286.696567]  [<ffffffffa00610bc>] :st:init_st+0xbc/0x1be
[  286.696616]  [<ffffffff80257a2a>] sys_init_module+0x17a/0x1d00
[  286.696676]  [<ffffffff8028bb30>] alloc_pages_current+0x0/0xe0
[  286.696731]  [<ffffffff8020c2ab>] system_call_after_swapgs+0x7b/0x80
[  286.696784]
[  320.909411] ch0: ... finished
[  320.909411] ch 3:0:0:0: Attached scsi changer ch0
[  320.909858] st 3:0:3:0: Attached scsi tape st0
[  320.909905] st 3:0:3:0: st0: try direct i/o: yes (alignment 4 B)
[  321.183325] Adding 5831552k swap on /dev/sdc5.  Priority:-1 extents:1 
across:5831552k
[  321.352153] st0: Block limits 1 - 16777215 bytes.


I also get:

jk@bacula:~$ dmesg | grep bus_type
[   13.252144] Driver 'sd' needs updating - please use bus_type methods
[   13.253901] Driver 'sr' needs updating - please use bus_type methods
[   27.670335] Driver 'ch' needs updating - please use bus_type methods
[   27.680156] Driver 'st' needs updating - please use bus_type methods
jk@bacula:~$

Should I be worried about that?

-- 
Jesper

