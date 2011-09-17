From: Chris Boot <bootc@bootc.net>
Subject: Re: iommu_iova leak [inside 3w-9xxx]
Date: Sat, 17 Sep 2011 15:29:56 +0100
Message-ID: <3A4FADE6-3653-46C5-B225-8200F9DCE35B@bootc.net>
References: <4E734467.3040703@bootc.net> <1316256305.24257.25.camel@shinybook.infradead.org> <AD4B8103-C98F-4BC5-9F7F-496D220781F3@bootc.net>
Mime-Version: 1.0 (Apple Message framework v1250.3)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yuna.grokhost.net ([87.117.228.63]:33694 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab1IQOx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Sep 2011 10:53:56 -0400
In-Reply-To: <AD4B8103-C98F-4BC5-9F7F-496D220781F3@bootc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Woodhouse, David" <david.woodhouse@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Adam Radford <linuxraid@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

On 17 Sep 2011, at 12:57, Chris Boot wrote:
> On 17 Sep 2011, at 11:45, Woodhouse, David wrote:
>> On Fri, 2011-09-16 at 13:43 +0100, Chris Boot wrote:
>>> In the very short term the number is up and down by a few hundred 
>>> objects but the general trend is constantly upwards. After about 5 days' 
>>> uptime I have some very serious IO slowdowns (narrowed down by a friend 
>>> to SCSI command queueing) with a lot of time spent in
>>> alloc_iova() and rb_prev() according to 'perf top'. Eventually these 
>>> translate into softlockups and the machine becomes almost unusable.
>> 
>> If you're seeing it spend ages in rb_prev() that implies that the
>> mappings are still *active* and in the rbtree, rather than just the the
>> iommu_iova data structure has been leaked.
>> 
>> I suppose it's vaguely possible that we're leaking them in such a way
>> that they remain on the rbtree, perhaps if the deferred unmap is never
>> actually happening... but I think it's a whole lot more likely that the
>> PCI driver is just never bothering to unmap the pages it maps.
>> 
>> If you boot with 'intel_iommu=strict' that will avoid the deferred unmap
>> which is the only likely culprit in the IOMMU code...
> 
> 
> Booting with intel_iommu=on,strict still shows the iommu_iova on a constant increase, so I don't think it's that.
> 
> I've bodged the following patch to see if it catches anything obvious. We'll see if anything useful comes of it. Sorry, my mail client kills whitespace.


[patch snipped, it's at http://lkml.org/lkml/2011/9/17/23]

David,

With a modified version of the patch (as discussed on IRC) which also takes into account mapping of sg lists, I see that the cause of the spurious mappings is the 3ware-9xxx driver (CCs added). The raw WARNING is below. I get a very large number of these one after the other as well, all nearly identical and within the 3w-9xxx driver.

twa_scsiop_execute_scsi+0x141 is actually twa_map_scsi_sg_data() which has been inlined.

Sep 17 13:40:30 tarquin kernel: [ 1447.334024] ------------[ cut here ]------------
Sep 17 13:40:30 tarquin kernel: [ 1447.347585] WARNING: at drivers/iommu/intel-iommu.c:3088 intel_map_sg+0x1db/0x221()
Sep 17 13:40:30 tarquin kernel: [ 1447.364894] Hardware name: S1200BTL
Sep 17 13:40:30 tarquin kernel: [ 1447.377545] Modules linked in: tun ip6table_mangle iptable_mangle xt_DSCP xt_owner iscsi_target_mod target_core_pscsi target_core_file target_core_iblock target_core_mod configfs ip6table_filter ip6_tables iptable_filter ip_tables ebtable_nat ebtables x_tables cpufreq_stats cpufreq_userspace cpufreq_conservative cpufreq_powersave ipmi_watchdog microcode nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc bridge stp ext4 jbd2 crc16 dm_snapshot ipmi_si ipmi_devintf ipmi_msghandler acpi_cpufreq mperf coretemp fuse crc32c_intel aesni_intel cryptd aes_x86_64 aes_generic dm_crypt kvm_intel kvm i2c_i801 snd_pcm snd_timer snd soundcore i2c_core snd_page_alloc joydev ftdi_sio usbserial evdev pcspkr processor video button ext3 jbd mbcache btrfs zlib_deflate crc32c li
 bcrc32c dm_mod sg sd_mod crc_t10dif usbhid hid ahci libahci 3w_9xxx thermal libata ehci_hcd fan thermal_sys scsi_mod usbcore e1000e [last unloaded: scsi_wait_scan]
Sep 17 13:40:30 tarquin kernel: [ 1447.552657] Pid: 0, comm: swapper Not tainted 3.1.0-rc6+ #3
Sep 17 13:40:30 tarquin kernel: [ 1447.569884] Call Trace:
Sep 17 13:40:30 tarquin kernel: [ 1447.583468]  <IRQ>  [<ffffffff81047f62>] warn_slowpath_common+0x7e/0x96
Sep 17 13:40:30 tarquin kernel: [ 1447.602095]  [<ffffffff81047f8f>] warn_slowpath_null+0x15/0x17
Sep 17 13:40:30 tarquin kernel: [ 1447.619837]  [<ffffffff812756cb>] intel_map_sg+0x1db/0x221
Sep 17 13:40:30 tarquin kernel: [ 1447.637110]  [<ffffffffa00650c0>] scsi_dma_map+0x80/0x99 [scsi_mod]
Sep 17 13:40:30 tarquin kernel: [ 1447.655291]  [<ffffffffa00e4675>] twa_scsiop_execute_scsi+0x141/0x3a5 [3w_9xxx]
Sep 17 13:40:30 tarquin kernel: [ 1447.674875]  [<ffffffffa00e4ded>] twa_scsi_queue+0xd6/0x16a [3w_9xxx]
Sep 17 13:40:30 tarquin kernel: [ 1447.693424]  [<ffffffffa005d488>] ? scsi_finish_command+0xe8/0xe8 [scsi_mod]
Sep 17 13:40:30 tarquin kernel: [ 1447.712660]  [<ffffffffa005e620>] scsi_dispatch_cmd+0x192/0x236 [scsi_mod]
Sep 17 13:40:30 tarquin kernel: [ 1447.731711]  [<ffffffffa0064235>] scsi_request_fn+0x3f5/0x421 [scsi_mod]
Sep 17 13:40:30 tarquin kernel: [ 1447.750511]  [<ffffffff81194a3f>] __blk_run_queue+0x16/0x18
Sep 17 13:40:30 tarquin kernel: [ 1447.767974]  [<ffffffffa006388a>] scsi_run_queue+0x1b5/0x21e [scsi_mod]
Sep 17 13:40:30 tarquin kernel: [ 1447.786632]  [<ffffffffa006494e>] scsi_next_command+0x34/0x45 [scsi_mod]
Sep 17 13:40:30 tarquin kernel: [ 1447.805337]  [<ffffffffa0064e01>] scsi_io_completion+0x458/0x4d2 [scsi_mod]
Sep 17 13:40:30 tarquin kernel: [ 1447.824467]  [<ffffffff8127248f>] ? __free_iova+0x71/0x79
Sep 17 13:40:30 tarquin kernel: [ 1447.841928]  [<ffffffff8134f36b>] ? _raw_spin_unlock_irqrestore+0x12/0x14
Sep 17 13:40:30 tarquin kernel: [ 1447.860901]  [<ffffffffa005d47f>] scsi_finish_command+0xdf/0xe8 [scsi_mod]
Sep 17 13:40:30 tarquin kernel: [ 1447.879789]  [<ffffffffa00648ff>] scsi_softirq_done+0x104/0x10d [scsi_mod]
Sep 17 13:40:30 tarquin kernel: [ 1447.898445]  [<ffffffff8119d5a7>] blk_done_softirq+0x69/0x79
Sep 17 13:40:30 tarquin kernel: [ 1447.915703]  [<ffffffff810748d7>] ? arch_local_irq_save+0x15/0x1b
Sep 17 13:40:30 tarquin kernel: [ 1447.933430]  [<ffffffff8104d877>] __do_softirq+0xc2/0x182
Sep 17 13:40:30 tarquin kernel: [ 1447.950234]  [<ffffffff8134f36b>] ? _raw_spin_unlock_irqrestore+0x12/0x14
Sep 17 13:40:30 tarquin kernel: [ 1447.968574]  [<ffffffff813568ec>] call_softirq+0x1c/0x30
Sep 17 13:40:30 tarquin kernel: [ 1447.985226]  [<ffffffff8100fa12>] do_softirq+0x41/0x7f
Sep 17 13:40:30 tarquin kernel: [ 1448.001673]  [<ffffffff8104dae3>] irq_exit+0x3f/0x9c
Sep 17 13:40:30 tarquin kernel: [ 1448.017782]  [<ffffffff8100f720>] do_IRQ+0x89/0xa0
Sep 17 13:40:30 tarquin kernel: [ 1448.033770]  [<ffffffff8134f6ae>] common_interrupt+0x6e/0x6e
Sep 17 13:40:30 tarquin kernel: [ 1448.050658]  <EOI>  [<ffffffff8100d03a>] ? load_TLS+0xb/0xf
Sep 17 13:40:30 tarquin kernel: [ 1448.067500]  [<ffffffffa01f6426>] ? arch_local_irq_enable+0x8/0xd [processor]
Sep 17 13:40:30 tarquin kernel: [ 1448.086229]  [<ffffffffa01f6dad>] acpi_idle_enter_c1+0x88/0xa6 [processor]
Sep 17 13:40:30 tarquin kernel: [ 1448.104583]  [<ffffffff8126b6c9>] cpuidle_idle_call+0xf9/0x185
Sep 17 13:40:30 tarquin kernel: [ 1448.121632]  [<ffffffff8100d29d>] cpu_idle+0x9f/0xe3
Sep 17 13:40:30 tarquin kernel: [ 1448.137603]  [<ffffffff8133255e>] rest_init+0x72/0x74
Sep 17 13:40:30 tarquin kernel: [ 1448.153605]  [<ffffffff816a5b81>] start_kernel+0x3c0/0x3cb
Sep 17 13:40:30 tarquin kernel: [ 1448.170074]  [<ffffffff816a52c4>] x86_64_start_reservations+0xaf/0xb3
Sep 17 13:40:30 tarquin kernel: [ 1448.187796]  [<ffffffff816a5140>] ? early_idt_handlers+0x140/0x140
Sep 17 13:40:30 tarquin kernel: [ 1448.205156]  [<ffffffff816a53ca>] x86_64_start_kernel+0x102/0x111
Sep 17 13:40:30 tarquin kernel: [ 1448.222302] ---[ end trace a812f71b71702674 ]---

-- 
Chris Boot
bootc@bootc.net

