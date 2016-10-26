From: TomK <tk@mdevsys.com>
Subject: Re: Kernel 4.8.4: INFO: task kworker/u16:8:289 blocked for more than
 120 seconds.
Date: Wed, 26 Oct 2016 08:08:38 -0400
Message-ID: <e1dc6704-e9f6-bb5c-108d-6f2c44501511@mdevsys.com>
References: <0f72bb4a-3cdf-ffd0-db75-5c8b303b921c@mdevsys.com>
 <64ef386e-8de2-0b1c-9322-f02530a3e783@mdevsys.com>
 <0851dba9-ad6c-c419-dc92-93c5d7d2f54a@mdevsys.com>
 <1477291017.19735.26.camel@haakon3.risingtidesystems.com>
 <b12c29d1-64a2-16dd-f38e-b4226e606df2@mdevsys.com>
 <58bfd43f-ff17-f724-9adf-ffd1f828a0e9@mdevsys.com>
 <1477466446.19735.113.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:60418 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753971AbcJZMI4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Oct 2016 08:08:56 -0400
In-Reply-To: <1477466446.19735.113.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, "Gurumurthy, Anil" <Anil.Gurumurthy@cavium.com>

On 10/26/2016 3:20 AM, Nicholas A. Bellinger wrote:
> Hello TomK & Co,
>
> Comments below.
>
> On Tue, 2016-10-25 at 22:05 -0400, TomK wrote:
>> On 10/25/2016 1:28 AM, TomK wrote:
>>> On 10/24/2016 2:36 AM, Nicholas A. Bellinger wrote:
>>>> Hi TomK,
>>>>
>>>> Thanks for reporting this bug.  Comments inline below.
>>>>
>>>> On Mon, 2016-10-24 at 00:45 -0400, TomK wrote:
>>>>> On 10/24/2016 12:32 AM, TomK wrote:
>>>>>> On 10/23/2016 10:03 PM, TomK wrote:
>
> <SNIP>
>
>>>>>> Including the full log:
>>>>>>
>>>>>> http://microdevsys.com/linux-lio/messages-mailing-list
>>>>>>
>>>>>
>>>>
>>>> Thanks for posting with qla2xxx verbose debug enabled on your setup.
>>>>
>>>>>
>>>>> When tryint to shut down target using /etc/init.d/target stop, the
>>>>> following is printed repeatedly:
>>>>>
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e837:20:
>>>>> ABTS_RECV_24XX: instance 0
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f811:20:
>>>>> qla_target(0): task abort (s_id=1:5:0, tag=1177068, param=0)
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f812:20:
>>>>> qla_target(0): task abort for non-existant session
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f80e:20:
>>>>> Scheduling work (type 1, prm ffff880093365680) to find session for param
>>>>> ffff88010f8c7680 (size 64, tgt ffff880111f06600)
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f800:20: Sess
>>>>> work (tgt ffff880111f06600)
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending
>>>>> task mgmt ABTS response (ha=ffff88010fae0000, atio=ffff880093365694,
>>>>> status=4
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e838:20:
>>>>> ABTS_RESP_24XX: compl_status 31
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e807:20: Sending
>>>>> retry TERM EXCH CTIO7 (ha=ffff88010fae0000)
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e806:20: Sending
>>>>> task mgmt ABTS response (ha=ffff88010fae0000, atio=ffff88010f8c76c0,
>>>>> status=0
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e838:20:
>>>>> ABTS_RESP_24XX: compl_status 0
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:20:
>>>>> qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 029c
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-3861:20: New
>>>>> command while device ffff880111f06600 is shutting down
>>>>> Oct 24 00:39:48 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e859:20:
>>>>> qla_target: Unable to send command to target for req, ignoring.
>>>>>
>>>>>
>>>>
>>>> At your earliest convenience, please verify the patch using v4.8.y with
>>>> the above ABORT_TASK + shutdown scenario.
>>>>
>>>> Also, it would be helpful to understand why this ESX FC host is
>>>> generating ABORT_TASKs.
>>>>
>>>> Eg: Is ABORT_TASK generated due to FC target response packet loss..?
>>>> Or due to target backend I/O latency, that ultimately triggers FC host
>>>> side timeouts...?
>>>>
>
> Ok, so the specific hung task warnings reported earlier above are
> ABORT_TASK due to the target-core backend md array holding onto
> outstanding I/O long enough, for ESX host side SCSI timeouts to begin to
> trigger.
>
>>>>>
>>>>> + when I disable the ports on the brocade switch that we're using then
>>>>> try to stop target, the following is printed:
>>>>>
>>>>>
>>>>>
>>>>> Oct 24 00:41:31 mbpc-pc kernel: qla2xxx [0000:04:00.1]-680a:21: Loop
>>>>> down - seconds remaining 231.
>>>>> Oct 24 00:41:32 mbpc-pc kernel: qla2xxx [0000:04:00.0]-680a:20: Loop
>>>>> down - seconds remaining 153.
>>>>> Oct 24 00:41:32 mbpc-pc kernel: ------------[ cut here ]------------
>>>>> Oct 24 00:41:32 mbpc-pc kernel: WARNING: CPU: 2 PID: 8615 at
>>>>> lib/list_debug.c:33 __list_add+0xbe/0xd0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: list_add corruption. prev->next should
>>>>> be next (ffff88009e83b330), but was ffff88011fc972a0.
>>>>> (prev=ffff880118ada4c0).
>>>>> Oct 24 00:41:32 mbpc-pc kernel: Modules linked in: tcm_qla2xxx tcm_fc
>>>>> tcm_loop target_core_file target_core_iblock target_core_pscsi
>>>>> target_core_mod configfs ip6table_filter ip6_tables ebtable_nat ebtables
>>>>> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_CHECKSUM
>>>>> iptable_mangle bridge nfsd lockd grace nfs_acl auth_rpcgss autofs4 it87
>>>>> hwmon_vid bnx2fc cnic uio fcoe libfcoe libfc 8021q garp stp llc ppdev
>>>>> parport_pc parport sunrpc cpufreq_ondemand bonding ipv6 crc_ccitt
>>>>> ipt_REJECT nf_reject_ipv4 xt_multiport iptable_filter ip_tables fuse
>>>>> vfat fat xfs vhost_net macvtap macvlan vhost tun uinput raid456
>>>>> async_raid6_recov async_pq async_xor xor async_memcpy async_tx raid6_pq
>>>>> libcrc32c joydev sg serio_raw e1000 kvm_amd kvm irqbypass r8169 mii
>>>>> pcspkr k10temp snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
>>>>> snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm
>>>>> snd_timer snd soundcore i2c_piix4 i2c_core wmi acpi_cpufreq shpchp ext4
>>>>> mbcache jbd2 qla2xxx scsi_transport_fc floppy firewire_ohci f
>>>>> Oct 24 00:41:32 mbpc-pc kernel: irewire_core crc_itu_t sd_mod pata_acpi
>>>>> ata_generic pata_jmicron ahci libahci usb_storage dm_mirror
>>>>> dm_region_hash dm_log dm_mod
>>>>> Oct 24 00:41:32 mbpc-pc kernel: CPU: 2 PID: 8615 Comm: kworker/2:3 Not
>>>>> tainted 4.8.4 #2
>>>>> Oct 24 00:41:32 mbpc-pc kernel: Hardware name: Gigabyte Technology Co.,
>>>>> Ltd. GA-890XA-UD3/GA-890XA-UD3, BIOS FC 08/02/2010
>>>>> Oct 24 00:41:32 mbpc-pc kernel: 0000000000000000 ffff880092b83b48
>>>>> ffffffff812e88e9 ffffffff8130753e
>>>>> Oct 24 00:41:32 mbpc-pc kernel: ffff880092b83ba8 ffff880092b83ba8
>>>>> 0000000000000000 ffff880092b83b98
>>>>> Oct 24 00:41:32 mbpc-pc kernel: ffffffff81066a7d ffff88000058f952
>>>>> 0000002100000046 ffffffff8101eae8
>>>>> Oct 24 00:41:32 mbpc-pc kernel: Call Trace:
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff812e88e9>]
>>>>> dump_stack+0x51/0x78
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8130753e>] ?
>>>>> __list_add+0xbe/0xd0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81066a7d>] __warn+0xfd/0x120
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8101eae8>] ?
>>>>> __switch_to+0x398/0x7e0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81066b59>]
>>>>> warn_slowpath_fmt+0x49/0x50
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8130753e>]
>>>>> __list_add+0xbe/0xd0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8107d0b2>]
>>>>> move_linked_works+0x62/0x90
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8108070c>]
>>>>> process_one_work+0x25c/0x4e0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162c040>] ?
>>>>> schedule+0x40/0xb0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8108150d>]
>>>>> worker_thread+0x16d/0x520
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162bb3d>] ?
>>>>> __schedule+0x2fd/0x6a0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810923f2>] ?
>>>>> default_wake_function+0x12/0x20
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810a6f06>] ?
>>>>> __wake_up_common+0x56/0x90
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810813a0>] ?
>>>>> maybe_create_worker+0x110/0x110
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162c040>] ?
>>>>> schedule+0x40/0xb0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810813a0>] ?
>>>>> maybe_create_worker+0x110/0x110
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8109130e>] ?
>>>>> schedule_tail+0x1e/0xc0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162f60f>]
>>>>> ret_from_fork+0x1f/0x40
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81085f20>] ?
>>>>> kthread_freezable_should_stop+0x70/0x70
>>>>> Oct 24 00:41:32 mbpc-pc kernel: ---[ end trace 713a9071c9f5f464 ]---
>>>>> Oct 24 00:41:32 mbpc-pc kernel: ------------[ cut here ]------------
>>>>> Oct 24 00:41:32 mbpc-pc kernel: WARNING: CPU: 2 PID: 8615 at
>>>>> lib/list_debug.c:36 __list_add+0x9c/0xd0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: list_add double add:
>>>>> new=ffff880118ada4c0, prev=ffff880118ada4c0, next=ffff88009e83b330.
>>>>> Oct 24 00:41:32 mbpc-pc kernel: Modules linked in: tcm_qla2xxx tcm_fc
>>>>> tcm_loop target_core_file target_core_iblock target_core_pscsi
>>>>> target_core_mod configfs ip6table_filter ip6_tables ebtable_nat ebtables
>>>>> nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_CHECKSUM
>>>>> iptable_mangle bridge nfsd lockd grace nfs_acl auth_rpcgss autofs4 it87
>>>>> hwmon_vid bnx2fc cnic uio fcoe libfcoe libfc 8021q garp stp llc ppdev
>>>>> parport_pc parport sunrpc cpufreq_ondemand bonding ipv6 crc_ccitt
>>>>> ipt_REJECT nf_reject_ipv4 xt_multiport iptable_filter ip_tables fuse
>>>>> vfat fat xfs vhost_net macvtap macvlan vhost tun uinput raid456
>>>>> async_raid6_recov async_pq async_xor xor async_memcpy async_tx raid6_pq
>>>>> libcrc32c joydev sg serio_raw e1000 kvm_amd kvm irqbypass r8169 mii
>>>>> pcspkr k10temp snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel
>>>>> snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm
>>>>> snd_timer snd soundcore i2c_piix4 i2c_core wmi acpi_cpufreq shpchp ext4
>>>>> mbcache jbd2 qla2xxx scsi_transport_fc floppy firewire_ohci f
>>>>> Oct 24 00:41:32 mbpc-pc kernel: irewire_core crc_itu_t sd_mod pata_acpi
>>>>> ata_generic pata_jmicron ahci libahci usb_storage dm_mirror
>>>>> dm_region_hash dm_log dm_mod
>>>>> Oct 24 00:41:32 mbpc-pc kernel: CPU: 2 PID: 8615 Comm: kworker/2:3
>>>>> Tainted: G        W       4.8.4 #2
>>>>> Oct 24 00:41:32 mbpc-pc kernel: Hardware name: Gigabyte Technology Co.,
>>>>> Ltd. GA-890XA-UD3/GA-890XA-UD3, BIOS FC 08/02/2010
>>>>> Oct 24 00:41:32 mbpc-pc kernel: 0000000000000000 ffff880092b83b48
>>>>> ffffffff812e88e9 ffffffff8130751c
>>>>> Oct 24 00:41:32 mbpc-pc kernel: ffff880092b83ba8 ffff880092b83ba8
>>>>> 0000000000000000 ffff880092b83b98
>>>>> Oct 24 00:41:32 mbpc-pc kernel: ffffffff81066a7d ffff88000058f952
>>>>> 0000002400000046 ffffffff8101eae8
>>>>> Oct 24 00:41:32 mbpc-pc kernel: Call Trace:
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff812e88e9>]
>>>>> dump_stack+0x51/0x78
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8130751c>] ?
>>>>> __list_add+0x9c/0xd0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81066a7d>] __warn+0xfd/0x120
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8101eae8>] ?
>>>>> __switch_to+0x398/0x7e0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81066b59>]
>>>>> warn_slowpath_fmt+0x49/0x50
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8130751c>]
>>>>> __list_add+0x9c/0xd0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8107d0b2>]
>>>>> move_linked_works+0x62/0x90
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8108070c>]
>>>>> process_one_work+0x25c/0x4e0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162c040>] ?
>>>>> schedule+0x40/0xb0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8108150d>]
>>>>> worker_thread+0x16d/0x520
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162bb3d>] ?
>>>>> __schedule+0x2fd/0x6a0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810923f2>] ?
>>>>> default_wake_function+0x12/0x20
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810a6f06>] ?
>>>>> __wake_up_common+0x56/0x90
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810813a0>] ?
>>>>> maybe_create_worker+0x110/0x110
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162c040>] ?
>>>>> schedule+0x40/0xb0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff810813a0>] ?
>>>>> maybe_create_worker+0x110/0x110
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8109130e>] ?
>>>>> schedule_tail+0x1e/0xc0
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff8162f60f>]
>>>>> ret_from_fork+0x1f/0x40
>>>>> Oct 24 00:41:32 mbpc-pc kernel: [<ffffffff81085f20>] ?
>>>>> kthread_freezable_should_stop+0x70/0x70
>>>>> Oct 24 00:41:32 mbpc-pc kernel: ---[ end trace 713a9071c9f5f465 ]---
>>>>> Oct 24 00:41:32 mbpc-pc kernel: qla2xxx [0000:04:00.1]-680a:21: Loop
>>>>> down - seconds remaining 230.
>>>>> Oct 24 00:41:33 mbpc-pc kernel: qla2xxx [0000:04:00.0]-680a:20: Loop
>>>>> down - seconds remaining 152.
>>>>>
>>>>>
>>>>
>>>> Mmmm.  Could be a side effect of the target-core regression, but not
>>>> completely sure..
>>>>
>>>> Adding QLOGIC folks CC'.
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>
> Adding Anil CC'
>
>>>
>>> Hey Nicholas,
>>>
>>>
>>>> At your earliest convenience, please verify the patch using v4.8.y with
>>>> the above ABORT_TASK + shutdown scenario.
>>>>
>>>> Also, it would be helpful to understand why this ESX FC host is
>>>> generating ABORT_TASKs.
>>>>
>>>> Eg: Is ABORT_TASK generated due to FC target response packet loss..?
>>>> Or due to target backend I/O latency, that ultimately triggers FC host
>>>> side timeouts...?
>>>
>>>
>>> Here is where it gets interesting and to your thought above.  Take for
>>> example this log snippet
>>> (http://microdevsys.com/linux-lio/messages-recent):
>>>
>>> Oct 23 22:12:51 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
>>> Jan  7 00:36:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
>>> successfully started
>>> Oct 23 22:14:14 mbpc-pc kernel: hpet1: lost 9599 rtc interrupts
>>> Oct 23 22:14:14 mbpc-pc kernel: hpet1: lost 1 rtc interrupts
>>> Oct 23 22:15:02 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
>>> Oct 23 22:15:41 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
>>> Jan  7 00:38:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
>>> successfully started
>>> Oct 23 22:16:29 mbpc-pc kernel: hpet1: lost 9599 rtc interrupts
>>> Oct 23 22:17:30 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
>>> Jan  7 00:40:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
>>> successfully started
>>> Oct 23 22:18:29 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx
>>> task_tag: 1195032
>>> Oct 23 22:18:33 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
>>> Oct 23 22:18:42 mbpc-pc kernel: ABORT_TASK: Sending
>>> TMR_FUNCTION_COMPLETE for ref_tag: 1195032
>>> Oct 23 22:18:42 mbpc-pc kernel: ABORT_TASK: Found referenced qla2xxx
>>> task_tag: 1122276
>>> Oct 23 22:19:35 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
>>> Jan  7 00:42:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
>>> successfully started
>>> Oct 23 22:20:41 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
>>> Oct 23 22:21:07 mbpc-pc kernel: INFO: task kworker/u16:8:308 blocked for
>>> more than 120 seconds.
>>> Oct 23 22:21:07 mbpc-pc kernel:      Not tainted 4.8.4 #2
>>> Oct 23 22:21:07 mbpc-pc kernel: "echo 0 >
>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> Oct 23 22:21:07 mbpc-pc kernel: kworker/u16:8   D ffff880111b8fa18     0
>>>   308      2 0x00000000
>>> Oct 23 22:21:07 mbpc-pc kernel: Workqueue: tmr-fileio target_tmr_work
>>> [target_core_mod]
>>> Oct 23 22:21:07 mbpc-pc kernel: ffff880111b8fa18 0000000000000400
>>> ffff880112180480 ffff880111b8f998
>>> Oct 23 22:21:07 mbpc-pc kernel: ffff88011107a380 ffffffff81f99ca0
>>> ffffffff81f998ef ffff880100000000
>>> Oct 23 22:21:07 mbpc-pc kernel: ffffffff812f27d9 0000000000000000
>>> ffffe8ffffcda000 ffff880000000000
>>> Oct 23 22:21:07 mbpc-pc kernel: Call Trace:
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff812f27d9>] ? number+0x2e9/0x310
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8162c040>] schedule+0x40/0xb0
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff81080169>] ?
>>> start_flush_work+0x49/0x180
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8162e7ec>]
>>> schedule_timeout+0x9c/0xe0
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff810802ba>] ? flush_work+0x1a/0x40
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff810bd15c>] ?
>>> console_unlock+0x35c/0x380
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8162cfa0>]
>>> wait_for_completion+0xc0/0xf0
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff810923e0>] ?
>>> try_to_wake_up+0x260/0x260
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffffa08f6f84>]
>>> __transport_wait_for_tasks+0xb4/0x1b0 [target_core_mod]
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff810bdd1f>] ?
>>> vprintk_default+0x1f/0x30
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8115cc5c>] ? printk+0x46/0x48
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffffa08f70c4>]
>>> transport_wait_for_tasks+0x44/0x60 [target_core_mod]
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffffa08f46e2>]
>>> core_tmr_abort_task+0xf2/0x160 [target_core_mod]
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffffa08f6aa4>]
>>> target_tmr_work+0x154/0x160 [target_core_mod]
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff81080639>]
>>> process_one_work+0x189/0x4e0
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff810d060c>] ?
>>> del_timer_sync+0x4c/0x60
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8108131e>] ?
>>> maybe_create_worker+0x8e/0x110
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8108150d>]
>>> worker_thread+0x16d/0x520
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff810923f2>] ?
>>> default_wake_function+0x12/0x20
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff810a6f06>] ?
>>> __wake_up_common+0x56/0x90
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff810813a0>] ?
>>> maybe_create_worker+0x110/0x110
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8162c040>] ? schedule+0x40/0xb0
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff810813a0>] ?
>>> maybe_create_worker+0x110/0x110
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff81085fec>] kthread+0xcc/0xf0
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8109130e>] ?
>>> schedule_tail+0x1e/0xc0
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff8162f60f>]
>>> ret_from_fork+0x1f/0x40
>>> Oct 23 22:21:07 mbpc-pc kernel: [<ffffffff81085f20>] ?
>>> kthread_freezable_should_stop+0x70/0x70
>>> Oct 23 22:21:52 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
>>> Jan  7 00:44:00 192.168.0.2 syslog: dhcpfwd : dhcp forwarder daemon
>>> successfully started
>>> Oct 23 22:23:03 mbpc-pc kernel: hpet1: lost 9600 rtc interrupts
>>>
>>>
>>> And compare it to the following snippet
>>> (http://microdevsys.com/linux-lio/iostat-tkx-interesting-bit.txt) taken
>>> from this bigger iostat session
>>> (http://microdevsys.com/linux-lio/iostat-tkx.txt):
>>>
>
> <SNIP>
>
>>>
>>>
>>> We can see that /dev/sdf ramps up to 100% starting at around (10/23/2016
>>> 10:18:18 PM) and stays that way till about the (10/23/2016 10:18:42 PM)
>>> mark when something occurs and it drops down to below 100% numbers.
>>>
>>> So I checked the array which shows all clean, even across reboots:
>>>
>>> [root@mbpc-pc ~]# cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4]
>>> md0 : active raid6 sdb[7] sdf[6] sdd[3] sda[5] sdc[1] sde[8]
>>>       3907045632 blocks super 1.2 level 6, 64k chunk, algorithm 2 [6/6]
>>> [UUUUUU]
>>>       bitmap: 1/8 pages [4KB], 65536KB chunk
>>>
>>> unused devices: <none>
>>> [root@mbpc-pc ~]#
>>>
>>>
>>> Then I run smartctl across all disks and sure enough /dev/sdf prints this:
>>>
>>> [root@mbpc-pc ~]# smartctl -A /dev/sdf
>>> smartctl 5.43 2012-06-30 r3573 [x86_64-linux-4.8.4] (local build)
>>> Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net
>>>
>>> Error SMART Values Read failed: scsi error badly formed scsi parameters
>>> Smartctl: SMART Read Values failed.
>>>
>>> === START OF READ SMART DATA SECTION ===
>>> [root@mbpc-pc ~]#
>>>
>>> So it would appear we found the root cause, a bad disk.  True the disk
>>> is bad and I'll be replacing it however, even with a degraded disk
>>> (checking now) the array functions just fine and I have no data loss.  I
>>> only lost 1.  I would have to loose 3 to get a catastrophic failure on
>>> this RAID6:
>>>
>>> [root@mbpc-pc ~]# cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4]
>>> md0 : active raid6 sdf[6](F) sda[5] sde[8] sdb[7] sdd[3] sdc[1]
>>>       3907045632 blocks super 1.2 level 6, 64k chunk, algorithm 2 [6/5]
>>> [UUUU_U]
>>>       bitmap: 6/8 pages [24KB], 65536KB chunk
>>>
>>> unused devices: <none>
>>> [root@mbpc-pc ~]# mdadm --detail /dev/md0
>>> /dev/md0:
>>>         Version : 1.2
>>>   Creation Time : Mon Mar 26 00:06:24 2012
>>>      Raid Level : raid6
>>>      Array Size : 3907045632 (3726.05 GiB 4000.81 GB)
>>>   Used Dev Size : 976761408 (931.51 GiB 1000.20 GB)
>>>    Raid Devices : 6
>>>   Total Devices : 6
>>>     Persistence : Superblock is persistent
>>>
>>>   Intent Bitmap : Internal
>>>
>>>     Update Time : Tue Oct 25 00:31:13 2016
>>>           State : clean, degraded
>>>  Active Devices : 5
>>> Working Devices : 5
>>>  Failed Devices : 1
>>>   Spare Devices : 0
>>>
>>>          Layout : left-symmetric
>>>      Chunk Size : 64K
>>>
>>>            Name : mbpc:0
>>>            UUID : 2f36ac48:5e3e4c54:72177c53:bea3e41e
>>>          Events : 118368
>>>
>>>     Number   Major   Minor   RaidDevice State
>>>        8       8       64        0      active sync   /dev/sde
>>>        1       8       32        1      active sync   /dev/sdc
>>>        7       8       16        2      active sync   /dev/sdb
>>>        3       8       48        3      active sync   /dev/sdd
>>>        8       0        0        8      removed
>>>        5       8        0        5      active sync   /dev/sda
>>>
>>>        6       8       80        -      faulty   /dev/sdf
>>> [root@mbpc-pc ~]#
>>>
>>> Last night I cut power to the /dev/sdf disk to spin it down the removed
>>> it and reinserted it.  The array resynced without issue however the
>>> smartctl -A command still failed on it. Today I check and bad blocks
>>> were recorded on the disk and the array has since removed /dev/sdf (per
>>> above).  Also I have to say that these ESXi hosts worked in this
>>> configuration, without any hickup, for about 4 months.  No LUN failure
>>> on the ESXi side.  I haven't changed the LUN in that time (had no reason
>>> to do so).
>>>
>>> So now here's the real question that I have.  Why would the array
>>> continue to function, as intended, with only one disk failure yet the
>>> QLogic / Target drivers stop and error out?  The RAID6 (software) array
>>> should care about the failure, and it should handle it.  QLogic / Target
>>> Drivers shouldn't really be too impacted (aside from read speed maybe)
>>> about a disk failing inside the array.  That would be my thinking.  The
>>> Target / QLogic software seems to have picked up on a failure ahead of
>>> the software RAID 6 detecting it.  I've had this RAID6 for over 6 years
>>> now.  Aside from the occassional disk replacement, quite rock solid.
>
> The earlier hung task warnings after ABORT_TASK w/ TMR_FUNCTION_COMPLETE
> and after explicit configfs shutdown are likely the missing SCF_ACK_KREF
> bit assignment.  Note the bug is specific to high backed I/O latency
> with v4.1+ code, so you'll want to include it for all future builds.
>
> AFAICT thus far the list corruption bug reported here and also from Anil
> & Co looks like a separate bug using tcm_qla2xxx ports.
>
>>>
>>> So anyway, I added the fix you pointed out to the 4.8.4 kernel and
>>> recompiled.  I restarted it, with the RAID6 degraded as it is.  All
>>> mounted fine and I checked the LUN's from the ESXi side:
>>>
>>> [root@mbpc-pc ~]# /etc/init.d/target start
>>> The Linux SCSI Target is already stopped                   [  OK  ]
>>> [info] The Linux SCSI Target looks properly installed.
>>> The configfs filesystem was not mounted, consider adding it[WARNING]
>>> [info] Loaded core module target_core_mod.
>>> [info] Loaded core module target_core_pscsi.
>>> [info] Loaded core module target_core_iblock.
>>> [info] Loaded core module target_core_file.
>>> Failed to load fabric module ib_srpt                       [WARNING]
>>> Failed to load fabric module tcm_usb_gadget                [WARNING]
>>> [info] Loaded fabric module tcm_loop.
>>> [info] Loaded fabric module tcm_fc.
>>> Failed to load fabric module vhost_scsi                    [WARNING]
>>> [info] Loaded fabric module tcm_qla2xxx.
>>> Failed to load fabric module iscsi_target_mod              [WARNING]
>>> [info] Loading config from /etc/target/scsi_target.lio, this may take
>>> several minutes for FC adapters.
>>> [info] Loaded /etc/target/scsi_target.lio.
>>> Started The Linux SCSI Target                              [  OK  ]
>>> [root@mbpc-pc ~]#
>>>
>>>
>>> Enabled the brocade ports:
>>>
>>>
>>>  18  18   011200   id    N4   No_Light    FC
>>>  19  19   011300   id    N4   No_Sync     FC  Disabled (Persistent)
>>>  20  20   011400   id    N4   No_Light    FC
>>>  21  21   011500   id    N4   No_Light    FC
>>>  22  22   011600   id    N4   No_Light    FC
>>>  23  23   011700   id    N4   No_Light    FC  Disabled (Persistent)
>>>  24  24   011800   --    N4   No_Module   FC  (No POD License) Disabled
>>>  25  25   011900   --    N4   No_Module   FC  (No POD License) Disabled
>>>  26  26   011a00   --    N4   No_Module   FC  (No POD License) Disabled
>>>  27  27   011b00   --    N4   No_Module   FC  (No POD License) Disabled
>>>  28  28   011c00   --    N4   No_Module   FC  (No POD License) Disabled
>>>  29  29   011d00   --    N4   No_Module   FC  (No POD License) Disabled
>>>  30  30   011e00   --    N4   No_Module   FC  (No POD License) Disabled
>>>  31  31   011f00   --    N4   No_Module   FC  (No POD License) Disabled
>>> sw0:admin> portcfgpersistentenable 19
>>> sw0:admin> portcfgpersistentenable 23
>>> sw0:admin> date
>>> Tue Oct 25 04:03:42 UTC 2016
>>> sw0:admin>
>>>
>>> And still after 30 minutes, there is no failure.  This run includes the
>>> fix you asked me to ass
>>> (https://github.com/torvalds/linux/commit/527268df31e57cf2b6d417198717c6d6afdb1e3e)
>>>  .  If everything works, I will revert the patch and see if I can
>>> reproduce the issue.  If I can reproduce it, then the disk might not
>>> have been it, but the patch was.  I'll keep you posted on that when I
>>> get a new disk tomorrow.
>>>
>>>
>>> Right now this is a POC setup so I have lots of room to experiment.
>>>
>>
>> Hey Nicholas,
>>
>> I've done some testing up till now.  With or without the patch above, as
>> long as the faulty disk is removed from the RAID 6 software array,
>> everything works fine with the Target Driver and ESXi hosts.
>
> Thanks again for the extra debug + feedback, and confirming the earlier
> hung task warnings with md disk failure.
>
>>   This is
>> even on a degraded array:
>>
>> [root@mbpc-pc ~]# cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active raid6 sdc[1] sda[5] sdd[3] sde[8] sdb[7]
>>        3907045632 blocks super 1.2 level 6, 64k chunk, algorithm 2 [6/5]
>> [UUUU_U]
>>        bitmap: 6/8 pages [24KB], 65536KB chunk
>>
>> unused devices: <none>
>> [root@mbpc-pc ~]#
>>
>> So at the moment, the data points to the single failed single disk (
>> /dev/sdf ) as causing the Target Drivers or QLogic cards to throw an
>> exception.
>>
>> Tomorrow I will insert the failed disk back in to see if the a) array
>> takes it back, b) it causes a failure with the patch applied.
>>
>> Looks like the failed disk /dev/sdf was limping along for months and
>> until I removed the power, it didn't collapse on itself.
>>
>
> AFAICT, the list corruption observed is a separate bug from the hung
> tasks during ABORT_TASK w/ TMR_COMPLETE_FUNCTION with explicit target
> shutdown.
>

Correct, I will be including the fix either way but will take some time 
to test out if I can reproduce the failure by reinserting this bad disk 
then a new disk.  I want to see if this hang will be reproduced by doing 
these actions to the RAID6 Software Raid to determine if this failure is 
isolated to a particularly bad disk or any sort of add or remove disk 
actions in a RAID6.

-- 
Cheers,
Tom K.
-------------------------------------------------------------------------------------

Living on earth is expensive, but it includes a free trip around the sun.

