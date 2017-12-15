From: Hannes Reinecke <hare@suse.de>
Subject: Re: [mainline] rcu stalls on CPU when unbinding mpt3sas driver
Date: Fri, 15 Dec 2017 13:12:07 +0100
Message-ID: <8a07d687-3c42-dda3-3b36-dec1fe16805e@suse.de>
References: <1513075128.13113.36.camel@abdul>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1513075128.13113.36.camel@abdul>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next <linux-next@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel <linux-kernel@vger.kernel.org>, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, mpe <mpe@ellerman.id.au>, Stephen Rothwell <sfr@canb.auug.org.au>, sachinp <sachinp@linux.vnet.ibm.com>, sim@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 12/12/2017 11:38 AM, Abdul Haleem wrote:
> Hi,
> 
> Off late we are seeing cpu stalls messages while mpt3sas driver unbind
> on powerpc machine for both mainline and linux-next kernels
> 
> Machine Type: Power 8 Bare-metal
> Kernel version: 4.15.0-rc2
> config: attached.
> test: driver unbind
> 
> $ echo -n 0001:03:00.0 > /sys/bus/pci/drivers/mpt3sas/unbind
> mpt3sas_cm0: removing handle(0x000a), sas_addr(0x500304801f080d00)
> mpt3sas_cm0: removing : enclosure logical id(0x500304801f080d3f), slot(0)
> mpt3sas_cm0: removing enclosure level(0x0000), connector name(     )
> mpt3sas_cm0: removing handle(0x000b), sas_addr(0x500304801f080d01)
> mpt3sas_cm0: removing : enclosure logical id(0x500304801f080d3f), slot(1)
> mpt3sas_cm0: removing enclosure level(0x0000), connector name(     )
> mpt3sas_cm0: removing handle(0x000c), sas_addr(0x500304801f080d02)
> mpt3sas_cm0: removing : enclosure logical id(0x500304801f080d3f), slot(2)
> mpt3sas_cm0: removing enclosure level(0x0000), connector name(     )
> mpt3sas_cm0: removing handle(0x000d), sas_addr(0x500304801f080d03)
> mpt3sas_cm0: removing : enclosure logical id(0x500304801f080d3f), slot(3)
> mpt3sas_cm0: removing enclosure level(0x0000), connector name(     )
> mpt3sas_cm0: removing handle(0x000e), sas_addr(0x500304801f080d04)
> mpt3sas_cm0: removing : enclosure logical id(0x500304801f080d3f), slot(4)
> mpt3sas_cm0: removing enclosure level(0x0000), connector name(     )
> mpt3sas_cm0: removing handle(0x000f), sas_addr(0x500304801f080d3d)
> mpt3sas_cm0: removing : enclosure logical id(0x500304801f080d3f), slot(12)
> mpt3sas_cm0: removing enclosure level(0x0000), connector name(     )
> sd 16:0:0:0: [sdb] Synchronizing SCSI cache
> sd 16:0:0:0: [sdb] Synchronize Cache(10) failed: Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> sd 16:0:1:0: [sdc] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> sd 16:0:1:0: [sdc] tag#0 CDB: ATA command pass through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> sd 16:0:2:0: [sdd] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> sd 16:0:2:0: [sdd] tag#0 CDB: ATA command pass through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> sd 16:0:3:0: [sde] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> sd 16:0:3:0: [sde] tag#0 CDB: ATA command pass through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> sd 16:0:4:0: [sdf] tag#0 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> sd 16:0:4:0: [sdf] tag#0 CDB: ATA command pass through(16) 85 06 2c 00 00 00 00 00 00 00 00 00 00 00 e5 00
> 
> few minutes after above command was executed, machine is flooded with rcu stalls messages.
> 
> INFO: rcu_sched detected expedited stalls on CPUs/tasks: { 86-... } 44191221 jiffies s: 3445 root: 0x20/.
> blocking rcu_node structures: l=1:80-95:0x40/.
> Task dump for CPU 86:
> sh              R  running task    10384 18136      1 0x00042086
> Call Trace:
> [c000007792d47370] [c000007933667200] 0xc000007933667200 (unreliable)
> INFO: rcu_sched self-detected stall on CPU
> 	86-....: (50420459 ticks this GP) idle=0ae/140000000000001/0 softirq=11962/11962 fqs=24724293 
> 	 (t=50420460 jiffies g=80217 c=80216 q=36817447)
> NMI backtrace for cpu 86
> CPU: 86 PID: 18136 Comm: sh Not tainted 4.15.0-rc2-autotest #1
> Call Trace:
> [c000007792d46f20] [c00000000099b83c] dump_stack+0xb0/0xf4 (unreliable)
> [c000007792d46f60] [c0000000009a43e4] nmi_cpu_backtrace+0x1a4/0x210
> [c000007792d46ff0] [c0000000009a462c] nmi_trigger_cpumask_backtrace+0x1dc/0x220
> [c000007792d47090] [c00000000002c7d0] arch_trigger_cpumask_backtrace+0x20/0x40
> [c000007792d470b0] [c00000000017496c] rcu_dump_cpu_stacks+0xf4/0x158
> [c000007792d47100] [c000000000173cb0] rcu_check_callbacks+0x8f0/0xb00
> [c000007792d47230] [c00000000017c25c] update_process_times+0x3c/0x90
> [c000007792d47260] [c0000000001921e4] tick_sched_handle.isra.13+0x44/0x80
> [c000007792d47280] [c000000000192278] tick_sched_timer+0x58/0xb0
> [c000007792d472c0] [c00000000017cd58] __hrtimer_run_queues+0xf8/0x330
> [c000007792d47340] [c00000000017da74] hrtimer_interrupt+0xe4/0x280
> [c000007792d47400] [c000000000022660] __timer_interrupt+0x90/0x270
> [c000007792d47450] [c000000000022d30] timer_interrupt+0xa0/0xe0
> [c000007792d47480] [c000000000009238] decrementer_common+0x158/0x160
> --- interrupt: 901 at replay_interrupt_return+0x0/0x4
>     LR = arch_local_irq_restore+0x74/0x90
> [c000007792d47770] [c000003fb3185000] 0xc000003fb3185000 (unreliable)
> [c000007792d47790] [c0000000009bb658] _raw_spin_unlock_irqrestore+0x38/0x60
> [c000007792d477b0] [c00000000066f274] scsi_remove_target+0x204/0x270
> [c000007792d47820] [d00000000fc72604] sas_rphy_remove+0x94/0xa0 [scsi_transport_sas]
> [c000007792d47850] [d00000000fc745bc] sas_port_delete+0x4c/0x238 [scsi_transport_sas]
> [c000007792d478b0] [d000000010e82990] mpt3sas_transport_port_remove+0x2d0/0x310 [mpt3sas]
> [c000007792d47950] [d000000010e71ba0] _scsih_remove_device+0x100/0x2a0 [mpt3sas]
> [c000007792d47a10] [d000000010e774d4] mpt3sas_device_remove_by_sas_address.part.44+0xb4/0x160 [mpt3sas]
> [c000007792d47a70] [d000000010e77614] _scsih_expander_node_remove+0x94/0x170 [mpt3sas]
> [c000007792d47af0] [d000000010e77a88] mpt3sas_expander_remove.part.46+0x398/0xe70 [mpt3sas]
> [c000007792d47b90] [c00000000056a9c4] pci_device_remove+0x64/0x110
> [c000007792d47bd0] [c00000000060fa74] device_release_driver_internal+0x1e4/0x2c0
> [c000007792d47c20] [c00000000060d260] unbind_store+0x110/0x140
> [c000007792d47c70] [c00000000060c2fc] drv_attr_store+0x3c/0x60
> [c000007792d47c90] [c0000000003a03c4] sysfs_kf_write+0x64/0xa0
> [c000007792d47cb0] [c00000000039f1b0] kernfs_fop_write+0x170/0x250
> [c000007792d47d00] [c0000000002fd370] __vfs_write+0x40/0x200
> [c000007792d47d90] [c0000000002fd748] vfs_write+0xc8/0x240
> [c000007792d47de0] [c0000000002fda80] SyS_write+0x60/0x110
> [c000007792d47e30] [c00000000000b8e0] system_call+0x58/0x6c
> 
This is probably the same issue as discussed in threads "[PATCH] scsi:
check for device state in __scsi_remove_target()" and "[PATCH] scsi: fix
race condition when removing target".

Please test with a patch from there.

Cheers,

Hannes

-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
