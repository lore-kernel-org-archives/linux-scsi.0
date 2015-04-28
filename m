From: Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH kernel] commit 4fbdf9cb ("lpfc: Fix for lun discovery
 issue with saturn adapter.")
Date: Tue, 28 Apr 2015 20:36:05 +1000
Message-ID: <553F6295.7010501@ozlabs.ru>
References: <1430209582-23925-1-git-send-email-aik@ozlabs.ru> <20150428111811.0000556e@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33499 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbbD1KgP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Apr 2015 06:36:15 -0400
Received: by pdbnk13 with SMTP id nk13so159905191pdb.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2015 03:36:14 -0700 (PDT)
In-Reply-To: <20150428111811.0000556e@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linuxppc-dev@lists.ozlabs.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, James Smart <james.smart@emulex.com>, "James E . J . Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 04/28/2015 07:18 PM, Sebastian Herbszt wrote:
> Alexey Kardashevskiy wrote:
>> This reverts 4fbdf9cb is breaks LPFC on POWER7 machine, big endian kernel.
>>
>> This is the hardware used for verification:
>> 0005:01:00.0 Fibre Channel [0c04]: Emulex Corporation Saturn-X: LightPulse Fibre Channel Host Adapter [10df:f100] (rev 03)
>> 0005:01:00.1 Fibre Channel [0c04]: Emulex Corporation Saturn-X: LightPulse Fibre Channel Host Adapter [10df:f100] (rev 03)
>>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>
> This issue is not specific to POWER7. I hit it on x86 [1] and James
> promised to look at it.
>
> [1] http://marc.info/?l=linux-scsi&m=142938432414173
>
> Sebastian

Well, I hope so, I just wanted to be more specific and the fault looks much 
different (and much cooler! :) ) on my hardware (it actually enters an 
infinite loop of oops'es):



Welcome to Fedora 20 (Heisenbug)!

INFO: rcu_sched self-detected stall on CPU
INFO: rcu_sched self-detected stall on CPU
INFO: rcu_sched self-detected stall on CPU


         1: (2100 ticks this GP) idle=981/140000000000001/0 softirq=234/234 fqs
=2083
         2: (2100 ticks this GP) idle=c3d/140000000000001/0 softirq=259/259 fqs
=2083

          (t=2100 jiffies g=-7 c=-8 q=11820)
  (t=2100 jiffies g=-7 c=-8 q=11820)
Task dump for CPU 0:
kworker/u97:0   R  running task     8192     7      2 0x00000804
Workqueue: events_unbound .async_run_entry_fn
Call Trace:
[c000000ffa29ef80] [c000000ffa29f060] 0xc000000ffa29f060 (unreliable)
Task dump for CPU 1:
kworker/u97:2   R  running task    10304  1636      2 0x00000804
Workqueue: events_unbound .async_run_entry_fn
Call Trace:
[c000000ff2fd2f80] [c000000ff2fd3060] 0xc000000ff2fd3060 (unreliable)
Task dump for CPU 2:
kworker/u97:1   R  running task     8288  1633      2 0x00000804
Workqueue: events_unbound .async_run_entry_fn
Call Trace:
[c000000ff2f92eb0] [c0000000000cf610] .sched_show_task+0xf0/0x180 (unreliable)
[c000000ff2f92f30] [c0000000001041d8] .rcu_dump_cpu_stacks+0xd8/0x150
[c000000ff2f92fd0] [c000000000108794] .rcu_check_callbacks+0x674/0x990
[c000000ff2f93110] [c00000000010e994] .update_process_times+0x44/0x90
[c000000ff2f93190] [c0000000001223f0] .tick_sched_handle.isra.16+0x20/0xa0
[c000000ff2f93210] [c0000000001224cc] .tick_sched_timer+0x5c/0xb0
[c000000ff2f932b0] [c00000000010f108] .__run_hrtimer+0x98/0x260
[c000000ff2f93350] [c00000000010fff8] .hrtimer_interrupt+0x138/0x2f0
[c000000ff2f93460] [c00000000001be1c] .__timer_interrupt+0x8c/0x230
[c000000ff2f93500] [c00000000001c488] .timer_interrupt+0x98/0xd0
[c000000ff2f93580] [c0000000000025d0] decrementer_common+0x150/0x180
--- interrupt: 901 at .string_get_size+0x120/0x250
     LR = .sd_revalidate_disk+0x57c/0x1c10
[c000000ff2f93870] [c00000000048f84c] .string_get_size+0x18c/0x250 (unreliable
)
[c000000ff2f93940] [c0000000005e7c1c] .sd_revalidate_disk+0x57c/0x1c10
[c000000ff2f93a70] [c0000000005e951c] .sd_probe_async+0xac/0x230
[c000000ff2f93b00] [c0000000000c28ec] .async_run_entry_fn+0x6c/0x180
[c000000ff2f93ba0] [c0000000000b7b78] .process_one_work+0x1a8/0x4a0
[c000000ff2f93c40] [c0000000000b7ff0] .worker_thread+0x180/0x5a0
[c000000ff2f93d30] [c0000000000bee08] .kthread+0x108/0x130
[c000000ff2f93e30] [c000000000009590] .ret_from_kernel_thread+0x58/0xc8
Task dump for CPU 0:
kworker/u97:0   R  running task     8192     7      2 0x00000804
Workqueue: events_unbound .async_run_entry_fn
Call Trace:
[c000000ffa29ef80] [c000000ffa29f060] 0xc000000ffa29f060 (unreliable)
Task dump for CPU 1:
kworker/u97:2   R  running task     9488  1636      2 0x00000804
Workqueue: events_unbound .async_run_entry_fn
Call Trace:
[c000000ff2fd2eb0] [c0000000000cf610] .sched_show_task+0xf0/0x180 (unreliable)
[c000000ff2fd2f30] [c0000000001041d8] .rcu_dump_cpu_stacks+0xd8/0x150
[c000000ff2fd2fd0] [c000000000108794] .rcu_check_callbacks+0x674/0x990
[c000000ff2fd3110] [c00000000010e994] .update_process_times+0x44/0x90
[c000000ff2fd3190] [c0000000001223f0] .tick_sched_handle.isra.16+0x20/0xa0
[c000000ff2fd3210] [c0000000001224cc] .tick_sched_timer+0x5c/0xb0
[c000000ff2fd32b0] [c00000000010f108] .__run_hrtimer+0x98/0x260
[c000000ff2fd3350] [c00000000010fff8] .hrtimer_interrupt+0x138/0x2f0
[c000000ff2fd3460] [c00000000001be1c] .__timer_interrupt+0x8c/0x230
[c000000ff2fd3500] [c00000000001c488] .timer_interrupt+0x98/0xd0
[c000000ff2fd3580] [c0000000000025d0] decrementer_common+0x150/0x180
--- interrupt: 901 at .string_get_size+0x110/0x250
     LR = .sd_revalidate_disk+0x57c/0x1c10
[c000000ff2fd3870] [c00000000048f84c] .string_get_size+0x18c/0x250 (unreliable
)
[c000000ff2fd3940] [c0000000005e7c1c] .sd_revalidate_disk+0x57c/0x1c10
[c000000ff2fd3a70] [c0000000005e951c] .sd_probe_async+0xac/0x230
[c000000ff2fd3b00] [c0000000000c28ec] .async_run_entry_fn+0x6c/0x180
[c000000ff2fd3ba0] [c0000000000b7b78] .process_one_work+0x1a8/0x4a0
[c000000ff2fd3c40] [c0000000000b7ff0] .worker_thread+0x180/0x5a0
[c000000ff2fd3d30] [c0000000000bee08] .kthread+0x108/0x130
[c000000ff2fd3e30] [c000000000009590] .ret_from_kernel_thread+0x58/0xc8
Task dump for CPU 2:
kworker/u97:1   R  running task     8288  1633      2 0x00000804
Workqueue: events_unbound .async_run_entry_fn
Call Trace:
[c000000ff2f92f80] [c000000ff2f93060] 0xc000000ff2f93060 (unreliable)

         0: (2098 ticks this GP) idle=155/140000000000001/0 softirq=477/477 fqs
=2083
          (t=2100 jiffies g=-7 c=-8 q=11820)
Task dump for CPU 0:
kworker/u97:0   R  running task     8192     7      2 0x00000804
Workqueue: events_unbound .async_run_entry_fn
Call Trace:
[c000000ffa29eeb0] [c0000000000cf610] .sched_show_task+0xf0/0x180 (unreliable)
[c000000ffa29ef30] [c0000000001041d8] .rcu_dump_cpu_stacks+0xd8/0x150
[c000000ffa29efd0] [c000000000108794] .rcu_check_callbacks+0x674/0x990
[c000000ffa29f110] [c00000000010e994] .update_process_times+0x44/0x90
[c000000ffa29f190] [c0000000001223f0] .tick_sched_handle.isra.16+0x20/0xa0
[c000000ffa29f210] [c0000000001224cc] .tick_sched_timer+0x5c/0xb0
[c000000ffa29f2b0] [c00000000010f108] .__run_hrtimer+0x98/0x260
[c000000ffa29f350] [c00000000010fff8] .hrtimer_interrupt+0x138/0x2f0
[c000000ffa29f460] [c00000000001be1c] .__timer_interrupt+0x8c/0x230
[c000000ffa29f500] [c00000000001c488] .timer_interrupt+0x98/0xd0
[c000000ffa29f580] [c0000000000025d0] decrementer_common+0x150/0x180
--- interrupt: 901 at .string_get_size+0x118/0x250
     LR = .sd_revalidate_disk+0x57c/0x1c10
[c000000ffa29f870] [c00000000048f84c] .string_get_size+0x18c/0x250 (unreliable
)
[c000000ffa29f940] [c0000000005e7c1c] .sd_revalidate_disk+0x57c/0x1c10
[c000000ffa29fa70] [c0000000005e951c] .sd_probe_async+0xac/0x230
[c000000ffa29fb00] [c0000000000c28ec] .async_run_entry_fn+0x6c/0x180
[c000000ffa29fba0] [c0000000000b7b78] .process_one_work+0x1a8/0x4a0
[c000000ffa29fc40] [c0000000000b7ff0] .worker_thread+0x180/0x5a0
[c000000ffa29fd30] [c0000000000bee08] .kthread+0x108/0x130
[c000000ffa29fe30] [c000000000009590] .ret_from_kernel_thread+0x58/0xc8
Task dump for CPU 1:
kworker/u97:2   R  running task     9488  1636      2 0x00000804
Workqueue: events_unbound .async_run_entry_fn
Call Trace:
[c000000ff2fd2f80] [c000000ff2fd3060] 0xc000000ff2fd3060 (unreliable)
Task dump for CPU 2:
kworker/u97:1   R  running task     8288  1633      2 0x00000804
Workqueue: events_unbound .async_run_entry_fn
Call Trace:
[c000000ff2f92f80] [c000000ff2f93060] 0xc000000ff2f93060 (unreliable)
NMI watchdog: BUG: soft lockup - CPU#1 stuck for 23s! [kworker/u97:2:1636]
NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u97:0:7]
NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u97:1:1633]
Modules linked in:
Modules linked in: autofs4
  autofs4
  lpfc
  lpfc


CPU: 0 PID: 7 Comm: kworker/u97:0 Not tainted 4.1.0-rc1-be-aik #470
CPU: 2 PID: 1633 Comm: kworker/u97:1 Not tainted 4.1.0-rc1-be-aik #470
Workqueue: events_unbound .async_run_entry_fn
Workqueue: events_unbound .async_run_entry_fn


task: c000000ff3588f00 ti: c000000ffa29c000 task.ti: c000000ffa29c000
task: c000000ff2f56580 ti: c000000ff2f90000 task.ti: c000000ff2f90000
NIP: c00000000048f7e0 LR: c0000000005e7c1c CTR: 0000000000000000
NIP: c00000000048f7e0 LR: c0000000005e7c1c CTR: 0000000000000000
REGS: c000000ffa29f5f0 TRAP: 0901   Not tainted  (4.1.0-rc1-be-aik)
REGS: c000000ff2f935f0 TRAP: 0901   Not tainted  (4.1.0-rc1-be-aik)
MSR: 9000000000009032
MSR: 9000000000009032
<
<
SF
SF
,HV
,HV
,EE
,EE
,ME
,ME
,IR
,IR
,DR
,DR
,RI
,RI
 >
 >
   CR: 48008028  XER: 00000000
   CR: 48008028  XER: 00000000
CFAR: c00000000048f7e8
CFAR: c00000000048f7e8
SOFTE: 1
SOFTE: 1

GPR00:

GPR00:
c0000000005e7c1c
c0000000005e7c1c
c000000ffa29f870
c000000ff2f93870
c000000000e8c5a8
c000000000e8c5a8
0000000000000000
0000000000000000

GPR04:

GPR04:
0000000000000200
0000000000000200
0000000000000000
0000000000000000
0000000000000200
0000000000000200
000000000000000a
000000000000000a

GPR08:

GPR08:
0000000000000000
0000000000000000
00000000000003e8
00000000000003e8
0000000000000000
0000000000000000
000000002eb72fa3
ffffffffe5dd553e

GPR12:

GPR12:
0000000028008028
0000000028008028
c00000000fdc0000
c00000000fdc0900


NIP [c00000000048f7e0] .string_get_size+0x120/0x250
NIP [c00000000048f7e0] .string_get_size+0x120/0x250
LR [c0000000005e7c1c] .sd_revalidate_disk+0x57c/0x1c10
LR [c0000000005e7c1c] .sd_revalidate_disk+0x57c/0x1c10
Call Trace:
Call Trace:
[c000000ffa29f870] [c00000000048f84c] .string_get_size+0x18c/0x250
[c000000ff2f93870] [c00000000048f84c] .string_get_size+0x18c/0x250
  (unreliable)
  (unreliable)


[c000000ffa29f940] [c0000000005e7c1c] .sd_revalidate_disk+0x57c/0x1c10
[c000000ff2f93940] [c0000000005e7c1c] .sd_revalidate_disk+0x57c/0x1c10


[c000000ffa29fa70] [c0000000005e951c] .sd_probe_async+0xac/0x230
[c000000ff2f93a70] [c0000000005e951c] .sd_probe_async+0xac/0x230


[c000000ffa29fb00] [c0000000000c28ec] .async_run_entry_fn+0x6c/0x180
[c000000ff2f93b00] [c0000000000c28ec] .async_run_entry_fn+0x6c/0x180


[c000000ffa29fba0] [c0000000000b7b78] .process_one_work+0x1a8/0x4a0
[c000000ff2f93ba0] [c0000000000b7b78] .process_one_work+0x1a8/0x4a0


[c000000ffa29fc40] [c0000000000b7ff0] .worker_thread+0x180/0x5a0
[c000000ff2f93c40] [c0000000000b7ff0] .worker_thread+0x180/0x5a0


[c000000ffa29fd30] [c0000000000bee08] .kthread+0x108/0x130
[c000000ff2f93d30] [c0000000000bee08] .kthread+0x108/0x130


[c000000ffa29fe30] [c000000000009590] .ret_from_kernel_thread+0x58/0xc8
[c000000ff2f93e30] [c000000000009590] .ret_from_kernel_thread+0x58/0xc8

Instruction dump:
Instruction dump:


...
[snip]




-- 
Alexey
