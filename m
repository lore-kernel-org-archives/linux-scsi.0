From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iscsi_trx going into D state
Date: Thu, 15 Dec 2016 13:38:30 -0700
Message-ID: <CAANLjFon+re7eMriFjnFfR-4SnzxR4LLSb2qcwhfkb7ODbuTwg@mail.gmail.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com>
 <880e374c-cf8b-f276-e930-57b09fe1a686@suse.com> <CAANLjFobXiBO2tXxTBB-8BQjM8FC0wmxdxQvEd6Rp=1LZkrvpA@mail.gmail.com>
 <CAANLjFoh+C8QE=qcPKqUUG3SnH2EMmS7DWZ5D4AD7yWMxoK0Zw@mail.gmail.com>
 <4fc72e32-26fb-96bd-8a0d-814eef712b43@suse.com> <CAANLjFpx1MRNiu2388pY+U0O5z9gw+OJBtpOof47Lb_DxaJSBQ@mail.gmail.com>
 <1476774332.8490.43.camel@haakon3.risingtidesystems.com> <CAANLjFqXt5r=c9F75vjeK=_zLa8zCS1priLuZo=A1ZSHKZ=1Bw@mail.gmail.com>
 <1476858359.8490.97.camel@haakon3.risingtidesystems.com> <CAANLjFoGEi29goybqsvEg6trystEkurVz52P8SwqGUSNV1jdSw@mail.gmail.com>
 <1477780190.22703.47.camel@haakon3.risingtidesystems.com> <CAANLjFpkEVmO83r5YWh=hCnN=AUf9bvrrCyVJHc-=CRpc3P0vQ@mail.gmail.com>
 <CAANLjFqoHuSq2SsNZ4J2uvAQGPg0F1tpxeJuAQT1oM1hXQ0wew@mail.gmail.com> <CAANLjFpYT62G86w-r00+shJUyrPd68BS64y8f9OZemz_5kojzg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFpYT62G86w-r00+shJUyrPd68BS64y8f9OZemz_5kojzg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Zhu Lingshan <lszhu-IBi9RG/b67k@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Nicholas,

I've found that the kernels I used were not able to be inspected using
crash and I could not build the debug info for them. So I built a new
4.9 kernel and verified that I could inspect the crash. It is located
at [1].

[1] http://mirrors.betterservers.com/trace/crash2.tar.xz
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Mon, Dec 12, 2016 at 4:57 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> Nicholas,
>
> After lots of set backs and having to give up trying to get kernel
> dumps on our "production" systems, I've been able to work out the
> issues we had with kdump and replicate the issue on my dev boxes. I
> have dumps from 4.4.30 and 4.9-rc8 (makedumpfile would not dump, so it
> is a straight copy of /proc/vmcore from the crash kernel). In each
> crash directory, I put a details.txt file that has the process IDs
> that were having problems and a brief description of the set-up at the
> time. This was mostly replicated by starting fio and pulling the
> Infiniband cable until fio gave up. This hardware also has Mellanox
> ConnectX4-LX cards and I also replicated the issue over RoCE using 4.9
> since it has the drivers in-box. Please let me know if you need more
> info, I can test much faster now. The cores/kernels/modules are
> located at [1].
>
> [1] http://mirrors.betterservers.com/trace/crash.tar.xz
>
> Thanks,
> Robert
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>
>
> On Fri, Nov 4, 2016 at 3:57 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>> We hit this yesterday, this time it was on the tx thread (the other
>> ones before seem to be on the rx thread). We weren't able to get a
>> kernel dump on this. We'll try to get one next time.
>>
>> # ps axuw | grep "D.*iscs[i]"
>> root     12383  0.0  0.0      0     0 ?        D    Nov03   0:04 [iscsi_np]
>> root     23016  0.0  0.0      0     0 ?        D    Nov03   0:00 [iscsi_ttx]
>> root     23018  0.0  0.0      0     0 ?        D    Nov03   0:00 [iscsi_ttx]
>> # cat /proc/12383/stack
>> [<ffffffff814f24af>] iscsit_stop_session+0x19f/0x1d0
>> [<ffffffff814e3c66>] iscsi_check_for_session_reinstatement+0x1e6/0x270
>> [<ffffffff814e6620>] iscsi_target_check_for_existing_instances+0x30/0x40
>> [<ffffffff814e6770>] iscsi_target_do_login+0x140/0x640
>> [<ffffffff814e7b0c>] iscsi_target_start_negotiation+0x1c/0xb0
>> [<ffffffff814e585b>] iscsi_target_login_thread+0xa9b/0xfc0
>> [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>> [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>> [<ffffffffffffffff>] 0xffffffffffffffff
>> # cat /proc/23016/stack
>> [<ffffffff814ce0d9>] target_wait_for_sess_cmds+0x49/0x1a0
>> [<ffffffffa058b92b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>> [<ffffffff814f2642>] iscsit_close_connection+0x162/0x870
>> [<ffffffff814e110f>] iscsit_take_action_for_connection_exit+0x7f/0x100
>> [<ffffffff814f122a>] iscsi_target_tx_thread+0x1aa/0x1d0
>> [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>> [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>> [<ffffffffffffffff>] 0xffffffffffffffff
>> # cat /proc/23018/stack
>> [<ffffffff814ce0d9>] target_wait_for_sess_cmds+0x49/0x1a0
>> [<ffffffffa058b92b>] isert_wait_conn+0x1ab/0x2f0 [ib_isert]
>> [<ffffffff814f2642>] iscsit_close_connection+0x162/0x870
>> [<ffffffff814e110f>] iscsit_take_action_for_connection_exit+0x7f/0x100
>> [<ffffffff814f122a>] iscsi_target_tx_thread+0x1aa/0x1d0
>> [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>> [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>> [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> From dmesg:
>> [  394.476332] INFO: rcu_sched self-detected stall on CPU
>> [  394.476334]  20-...: (23976 ticks this GP)
>> idle=edd/140000000000001/0 softirq=292/292 fqs=18788
>> [  394.476336]   (t=24003 jiffies g=3146 c=3145 q=0)
>> [  394.476337] Task dump for CPU 20:
>> [  394.476338] kworker/u68:2   R  running task        0 12906      2 0x00000008
>> [  394.476345] Workqueue: isert_comp_wq isert_cq_work [ib_isert]
>> [  394.476346]  ffff883f2fe38000 00000000f805705e ffff883f7fd03da8
>> ffffffff810ac8ff
>> [  394.476347]  0000000000000014 ffffffff81adb680 ffff883f7fd03dc0
>> ffffffff810af239
>> [  394.476348]  0000000000000015 ffff883f7fd03df0 ffffffff810e1cd0
>> ffff883f7fd17b80
>> [  394.476348] Call Trace:
>> [  394.476354]  <IRQ>  [<ffffffff810ac8ff>] sched_show_task+0xaf/0x110
>> [  394.476355]  [<ffffffff810af239>] dump_cpu_task+0x39/0x40
>> [  394.476357]  [<ffffffff810e1cd0>] rcu_dump_cpu_stacks+0x80/0xb0
>> [  394.476359]  [<ffffffff810e6100>] rcu_check_callbacks+0x540/0x820
>> [  394.476360]  [<ffffffff810afe11>] ? account_system_time+0x81/0x110
>> [  394.476363]  [<ffffffff810faa60>] ? tick_sched_do_timer+0x50/0x50
>> [  394.476364]  [<ffffffff810eb599>] update_process_times+0x39/0x60
>> [  394.476365]  [<ffffffff810fa815>] tick_sched_handle.isra.17+0x25/0x60
>> [  394.476366]  [<ffffffff810faa9d>] tick_sched_timer+0x3d/0x70
>> [  394.476368]  [<ffffffff810ec182>] __hrtimer_run_queues+0x102/0x290
>> [  394.476369]  [<ffffffff810ec668>] hrtimer_interrupt+0xa8/0x1a0
>> [  394.476372]  [<ffffffff81052c65>] local_apic_timer_interrupt+0x35/0x60
>> [  394.476374]  [<ffffffff8172423d>] smp_apic_timer_interrupt+0x3d/0x50
>> [  394.476376]  [<ffffffff817224f7>] apic_timer_interrupt+0x87/0x90
>> [  394.476379]  <EOI>  [<ffffffff810d71be>] ? console_unlock+0x41e/0x4e0
>> [  394.476380]  [<ffffffff810d757c>] vprintk_emit+0x2fc/0x500
>> [  394.476382]  [<ffffffff810d78ff>] vprintk_default+0x1f/0x30
>> [  394.476384]  [<ffffffff81174dde>] printk+0x5d/0x74
>> [  394.476388]  [<ffffffff814bce21>] transport_lookup_cmd_lun+0x1d1/0x200
>> [  394.476390]  [<ffffffff814ee8c0>] iscsit_setup_scsi_cmd+0x230/0x540
>> [  394.476392]  [<ffffffffa058dbf3>] isert_rx_do_work+0x3f3/0x7f0 [ib_isert]
>> [  394.476394]  [<ffffffffa058e174>] isert_cq_work+0x184/0x770 [ib_isert]
>> [  394.476396]  [<ffffffff8109740f>] process_one_work+0x14f/0x400
>> [  394.476397]  [<ffffffff81097c84>] worker_thread+0x114/0x470
>> [  394.476398]  [<ffffffff8171d32a>] ? __schedule+0x34a/0x7f0
>> [  394.476399]  [<ffffffff81097b70>] ? rescuer_thread+0x310/0x310
>> [  394.476400]  [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>> [  394.476402]  [<ffffffff8109d6f0>] ? kthread_park+0x60/0x60
>> [  394.476403]  [<ffffffff81721a8f>] ret_from_fork+0x3f/0x70
>> [  394.476404]  [<ffffffff8109d6f0>] ? kthread_park+0x60/0x60
>> [  405.716632] Unexpected ret: -104 send data 360
>> [  405.721711] tx_data returned -32, expecting 360.
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>
>>
>> On Mon, Oct 31, 2016 at 10:34 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>> Nicholas,
>>>
>>> Thanks for following up on this. We have been chasing other bugs in
>>> our provisioning and as such has reduced our load on the boxes. We are
>>> hoping to get that all straightened out this week and do some more
>>> testing. So far we have not had any iSCSI in D state since the patch,
>>> be we haven't been able to test it well either. We will keep you
>>> updated.
>>>
>>> Thank you,
>>> Robert LeBlanc
>>> ----------------
>>> Robert LeBlanc
>>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>>
>>>
>>> On Sat, Oct 29, 2016 at 4:29 PM, Nicholas A. Bellinger
>>> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>>>> Hi Robert,
>>>>
>>>> On Wed, 2016-10-19 at 10:41 -0600, Robert LeBlanc wrote:
>>>>> Nicholas,
>>>>>
>>>>> I didn't have high hopes for the patch because we were not seeing
>>>>> TMR_ABORT_TASK (or 'abort') in dmesg or /var/log/messages, but it
>>>>> seemed to help regardless. Our clients finally OOMed from the hung
>>>>> sessions, so we are having to reboot them and we will do some more
>>>>> testing. We haven't put the updated kernel on our clients yet. Our
>>>>> clients have iSCSI root disks so I'm not sure if we can get a vmcore
>>>>> on those, but we will do what we can to get you a vmcore from the
>>>>> target if it happens again.
>>>>>
>>>>
>>>> Just checking in to see if you've observed further issues with
>>>> iser-target ports, and/or able to generate a crashdump with v4.4.y..?
>>>>
>>>>> As far as our configuration: It is a superMicro box with 6 SAMSUNG
>>>>> MZ7LM3T8HCJM-00005 SSDs. Two are for root and four are in mdadm
>>>>> RAID-10 for exporting via iSCSI/iSER. We have ZFS on top of the
>>>>> RAID-10 for checksum and snapshots only and we export ZVols to the
>>>>> clients (one or more per VM on the client). We do not persist the
>>>>> export info (targetcli saveconfig), but regenerate it from scripts.
>>>>> The client receives two or more of these exports and puts them in a
>>>>> RAID-1 device. The exports are served by iSER one one port and also by
>>>>> normal iSCSI on a different port for compatibility, but not normally
>>>>> used. If you need more info about the config, please let me know. It
>>>>> was kind of a vague request so I'm not sure what exactly is important
>>>>> to you.
>>>>
>>>> Thanks for the extra details of your hardware + user-space
>>>> configuration.
>>>>
>>>>> Thanks for helping us with this,
>>>>> Robert LeBlanc
>>>>>
>>>>> When we have problems, we usually see this in the logs:
>>>>> Oct 17 08:57:50 prv-0-12-sanstack kernel: iSCSI Login timeout on
>>>>> Network Portal 0.0.0.0:3260
>>>>> Oct 17 08:57:50 prv-0-12-sanstack kernel: Unexpected ret: -104 send data 48
>>>>> Oct 17 08:57:50 prv-0-12-sanstack kernel: tx_data returned -32, expecting 48.
>>>>> Oct 17 08:57:50 prv-0-12-sanstack kernel: iSCSI Login negotiation failed.
>>>>>
>>>>> I found some backtraces in the logs, not sure if this is helpful, this
>>>>> is before your patch (your patch booted at Oct 18 10:36:59):
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: INFO: rcu_sched
>>>>> self-detected stall on CPU
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: #0115-...: (41725 ticks this
>>>>> GP) idle=b59/140000000000001/0 softirq=535/535 fqs=30992
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: #011 (t=42006 jiffies g=1550
>>>>> c=1549 q=0)
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: Task dump for CPU 5:
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: kworker/u68:2   R  running
>>>>> task        0 17967      2 0x00000008
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: Workqueue: isert_comp_wq
>>>>> isert_cq_work [ib_isert]
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: ffff883f4c0dca80
>>>>> 00000000af8ca7a4 ffff883f7fb43da8 ffffffff810ac83f
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: 0000000000000005
>>>>> ffffffff81adb680 ffff883f7fb43dc0 ffffffff810af179
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: 0000000000000006
>>>>> ffff883f7fb43df0 ffffffff810e1c10 ffff883f7fb57b80
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: Call Trace:
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: <IRQ>  [<ffffffff810ac83f>]
>>>>> sched_show_task+0xaf/0x110
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810af179>]
>>>>> dump_cpu_task+0x39/0x40
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810e1c10>]
>>>>> rcu_dump_cpu_stacks+0x80/0xb0
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810e6040>]
>>>>> rcu_check_callbacks+0x540/0x820
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810afd51>] ?
>>>>> account_system_time+0x81/0x110
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810fa9a0>] ?
>>>>> tick_sched_do_timer+0x50/0x50
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810eb4d9>]
>>>>> update_process_times+0x39/0x60
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810fa755>]
>>>>> tick_sched_handle.isra.17+0x25/0x60
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810fa9dd>]
>>>>> tick_sched_timer+0x3d/0x70
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810ec0c2>]
>>>>> __hrtimer_run_queues+0x102/0x290
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810ec5a8>]
>>>>> hrtimer_interrupt+0xa8/0x1a0
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff81052c65>]
>>>>> local_apic_timer_interrupt+0x35/0x60
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff8172343d>]
>>>>> smp_apic_timer_interrupt+0x3d/0x50
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff817216f7>]
>>>>> apic_timer_interrupt+0x87/0x90
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: <EOI>  [<ffffffff810d70fe>]
>>>>> ? console_unlock+0x41e/0x4e0
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810d74bc>]
>>>>> vprintk_emit+0x2fc/0x500
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff810d783f>]
>>>>> vprintk_default+0x1f/0x30
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff81174c2a>] printk+0x5d/0x74
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff814bc351>]
>>>>> transport_lookup_cmd_lun+0x1d1/0x200
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff814edcf0>]
>>>>> iscsit_setup_scsi_cmd+0x230/0x540
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffffa0890bf3>]
>>>>> isert_rx_do_work+0x3f3/0x7f0 [ib_isert]
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffffa0891174>]
>>>>> isert_cq_work+0x184/0x770 [ib_isert]
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff8109734f>]
>>>>> process_one_work+0x14f/0x400
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff81097bc4>]
>>>>> worker_thread+0x114/0x470
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff8171c55a>] ?
>>>>> __schedule+0x34a/0x7f0
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff81097ab0>] ?
>>>>> rescuer_thread+0x310/0x310
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff8109d708>] kthread+0xd8/0xf0
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff8109d630>] ?
>>>>> kthread_park+0x60/0x60
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff81720c8f>]
>>>>> ret_from_fork+0x3f/0x70
>>>>> Oct 17 15:43:12 prv-0-12-sanstack kernel: [<ffffffff8109d630>] ?
>>>>> kthread_park+0x60/0x60
>>>>>
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: INFO: rcu_sched
>>>>> self-detected stall on CPU
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: #01128-...: (5999 ticks this
>>>>> GP) idle=2f9/140000000000001/0 softirq=457/457 fqs=4830
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: #011 (t=6000 jiffies g=3546
>>>>> c=3545 q=0)
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: Task dump for CPU 28:
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: iscsi_np        R  running
>>>>> task        0 16597      2 0x0000000c
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: ffff887f40350000
>>>>> 00000000b98a67bb ffff887f7f503da8 ffffffff810ac8ff
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: 000000000000001c
>>>>> ffffffff81adb680 ffff887f7f503dc0 ffffffff810af239
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: 000000000000001d
>>>>> ffff887f7f503df0 ffffffff810e1cd0 ffff887f7f517b80
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: Call Trace:
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: <IRQ>  [<ffffffff810ac8ff>]
>>>>> sched_show_task+0xaf/0x110
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810af239>]
>>>>> dump_cpu_task+0x39/0x40
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810e1cd0>]
>>>>> rcu_dump_cpu_stacks+0x80/0xb0
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810e6100>]
>>>>> rcu_check_callbacks+0x540/0x820
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810afe11>] ?
>>>>> account_system_time+0x81/0x110
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810faa60>] ?
>>>>> tick_sched_do_timer+0x50/0x50
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810eb599>]
>>>>> update_process_times+0x39/0x60
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810fa815>]
>>>>> tick_sched_handle.isra.17+0x25/0x60
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810faa9d>]
>>>>> tick_sched_timer+0x3d/0x70
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810ec182>]
>>>>> __hrtimer_run_queues+0x102/0x290
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810ec668>]
>>>>> hrtimer_interrupt+0xa8/0x1a0
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff81052c65>]
>>>>> local_apic_timer_interrupt+0x35/0x60
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff81723cbd>]
>>>>> smp_apic_timer_interrupt+0x3d/0x50
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff81721f77>]
>>>>> apic_timer_interrupt+0x87/0x90
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: <EOI>  [<ffffffff810d71be>]
>>>>> ? console_unlock+0x41e/0x4e0
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810d757c>]
>>>>> vprintk_emit+0x2fc/0x500
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff810d78ff>]
>>>>> vprintk_default+0x1f/0x30
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff81174dde>] printk+0x5d/0x74
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff814e71ad>]
>>>>> iscsi_target_locate_portal+0x62d/0x6f0
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff814e5100>]
>>>>> iscsi_target_login_thread+0x6f0/0xfc0
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff814e4a10>] ?
>>>>> iscsi_target_login_sess_out+0x250/0x250
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff8109d6f0>] ?
>>>>> kthread_park+0x60/0x60
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff8172150f>]
>>>>> ret_from_fork+0x3f/0x70
>>>>> Oct 17 16:34:03 prv-0-12-sanstack kernel: [<ffffffff8109d6f0>] ?
>>>>> kthread_park+0x60/0x60
>>>>>
>>>>> I don't think this one is related, but it happened a couple of times:
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: INFO: rcu_sched
>>>>> self-detected stall on CPU
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: #01119-...: (5999 ticks this
>>>>> GP) idle=727/140000000000001/0 softirq=1346/1346 fqs=4990
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: #011 (t=6000 jiffies g=4295
>>>>> c=4294 q=0)
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: Task dump for CPU 19:
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: kworker/19:1    R  running
>>>>> task        0   301      2 0x00000008
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: Workqueue:
>>>>> events_power_efficient fb_flashcursor
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: ffff883f6009ca80
>>>>> 00000000010a7cdd ffff883f7fcc3da8 ffffffff810ac8ff
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: 0000000000000013
>>>>> ffffffff81adb680 ffff883f7fcc3dc0 ffffffff810af239
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: 0000000000000014
>>>>> ffff883f7fcc3df0 ffffffff810e1cd0 ffff883f7fcd7b80
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: Call Trace:
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: <IRQ>  [<ffffffff810ac8ff>]
>>>>> sched_show_task+0xaf/0x110
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810af239>]
>>>>> dump_cpu_task+0x39/0x40
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810e1cd0>]
>>>>> rcu_dump_cpu_stacks+0x80/0xb0
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810e6100>]
>>>>> rcu_check_callbacks+0x540/0x820
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810afe11>] ?
>>>>> account_system_time+0x81/0x110
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810faa60>] ?
>>>>> tick_sched_do_timer+0x50/0x50
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810eb599>]
>>>>> update_process_times+0x39/0x60
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810fa815>]
>>>>> tick_sched_handle.isra.17+0x25/0x60
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810faa9d>]
>>>>> tick_sched_timer+0x3d/0x70
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810ec182>]
>>>>> __hrtimer_run_queues+0x102/0x290
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff810ec668>]
>>>>> hrtimer_interrupt+0xa8/0x1a0
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff81052c65>]
>>>>> local_apic_timer_interrupt+0x35/0x60
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff81723cbd>]
>>>>> smp_apic_timer_interrupt+0x3d/0x50
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff81721f77>]
>>>>> apic_timer_interrupt+0x87/0x90
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: <EOI>  [<ffffffff810d71be>]
>>>>> ? console_unlock+0x41e/0x4e0
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff813866ad>]
>>>>> fb_flashcursor+0x5d/0x140
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff8138bc00>] ?
>>>>> bit_clear+0x110/0x110
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff8109740f>]
>>>>> process_one_work+0x14f/0x400
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff81097c84>]
>>>>> worker_thread+0x114/0x470
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff8171cdda>] ?
>>>>> __schedule+0x34a/0x7f0
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff81097b70>] ?
>>>>> rescuer_thread+0x310/0x310
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff8109d7c8>] kthread+0xd8/0xf0
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff8109d6f0>] ?
>>>>> kthread_park+0x60/0x60
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff8172150f>]
>>>>> ret_from_fork+0x3f/0x70
>>>>> Oct 17 11:46:52 prv-0-12-sanstack kernel: [<ffffffff8109d6f0>] ?
>>>>> kthread_park+0x60/0x60
>>>>
>>>> RCU self-detected schedule stalls typically mean some code is
>>>> monopolizing execution on a specific CPU for an extended period of time
>>>> (eg: endless loop), preventing normal RCU grace-period callbacks from
>>>> running in a timely manner.
>>>>
>>>> It's hard to tell without more log context and/or crashdump what was
>>>> going on here.
>>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
