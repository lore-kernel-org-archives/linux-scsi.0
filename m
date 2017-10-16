From: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
Subject: Re: system hung up when offlining CPUs
Date: Mon, 16 Oct 2017 14:59:15 -0400
Message-ID: <857c813c-29cd-6e9f-5cde-52421d4d8429@gmail.com>
References: <c55a33b4-a886-8882-dd8d-5c488f94ee06@gmail.com>
 <20170809124213.0d9518bb@why.wild-wind.fr.eu.org>
 <cd524af7-1f20-1956-1e44-92a451053387@gmail.com>
 <c1c7e0d6-d908-b511-8418-bca288a0d20a@arm.com>
 <20170821131809.GA17564@lst.de>
 <fce0ad52-8739-09c8-ec9d-a23eb92cec5a@arm.com>
 <8e0d76cd-7cd4-3a98-12ba-815f00d4d772@gmail.com>
 <2f2ae1bc-4093-d083-6a18-96b9aaa090c9@gmail.com>
 <b3e88f4d-8ca4-e265-5e09-437285cb18f5@suse.de>
 <8cb26204cb5402824496bbb6b636e0af@mail.gmail.com>
 <alpine.DEB.2.20.1709131529400.1874@nanos>
 <3ce6837a-9aba-0ff4-64b9-7ebca5afca13@gmail.com>
 <alpine.DEB.2.20.1709161212160.2105@nanos>
 <alpine.DEB.2.20.1709161630580.2105@nanos>
 <78ce7246-c567-3f5f-b168-9bcfc659d4bd@gmail.com>
 <alpine.DEB.2.20.1710032328280.2278@nanos>
 <alpine.DEB.2.20.1710042208400.2406@nanos>
 <3d93387d-30eb-0434-2216-0e6435c633f8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3d93387d-30eb-0434-2216-0e6435c633f8@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Hannes Reinecke <hare@suse.de>, Marc Zyngier <marc.zyngier@arm.com>, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, mpe@ellerman.id.au, keith.busch@intel.com, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, yasu.isimatu@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hi Thomas,

> Can you please apply the patch below on top of Linus tree and retest?
>
> Please send me the outputs I asked you to provide last time in any case
> (success or fail).

The issue still occurs even if I applied your patch to linux 4.14.0-rc4.

---
[ ...] INFO: task setroubleshootd:4972 blocked for more than 120 seconds.
[ ...]       Not tainted 4.14.0-rc4.thomas.with.irqdebug+ #6
[ ...] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ ...] setroubleshootd D    0  4972      1 0x00000080
[ ...] Call Trace:
[ ...]  __schedule+0x28d/0x890
[ ...]  ? release_pages+0x16f/0x3f0
[ ...]  schedule+0x36/0x80
[ ...]  io_schedule+0x16/0x40
[ ...]  wait_on_page_bit+0x107/0x150
[ ...]  ? page_cache_tree_insert+0xb0/0xb0
[ ...]  truncate_inode_pages_range+0x3dd/0x7d0
[ ...]  ? schedule_hrtimeout_range_clock+0xad/0x140
[ ...]  ? remove_wait_queue+0x59/0x60
[ ...]  ? down_write+0x12/0x40
[ ...]  ? unmap_mapping_range+0x75/0x130
[ ...]  truncate_pagecache+0x47/0x60
[ ...]  truncate_setsize+0x32/0x40
[ ...]  xfs_setattr_size+0x100/0x300 [xfs]
[ ...]  xfs_vn_setattr_size+0x40/0x90 [xfs]
[ ...]  xfs_vn_setattr+0x87/0xa0 [xfs]
[ ...]  notify_change+0x266/0x440
[ ...]  do_truncate+0x75/0xc0
[ ...]  path_openat+0xaba/0x13b0
[ ...]  ? mem_cgroup_commit_charge+0x31/0x130
[ ...]  do_filp_open+0x91/0x100
[ ...]  ? __alloc_fd+0x46/0x170
[ ...]  do_sys_open+0x124/0x210
[ ...]  SyS_open+0x1e/0x20
[ ...]  do_syscall_64+0x67/0x1b0
[ ...]  entry_SYSCALL64_slow_path+0x25/0x25
[ ...] RIP: 0033:0x7f275e2365bd
[ ...] RSP: 002b:00007ffe29337da0 EFLAGS: 00000293 ORIG_RAX: 0000000000000002
[ ...] RAX: ffffffffffffffda RBX: 00000000040aea00 RCX: 00007f275e2365bd
[ ...] RDX: 00000000000001b6 RSI: 0000000000000241 RDI: 00000000040ae840
[ ...] RBP: 00007ffe29337e00 R08: 00000000040aea06 R09: 0000000000000240
[ ...] R10: 0000000000000024 R11: 0000000000000293 R12: 00000000040eb660
[ ...] R13: 0000000000000004 R14: 00000000040ae840 R15: 000000000186a0a0
[ ...] sd 0:2:0:0: [sda] tag#0 task abort called for scmd(ffff9b4bf2306160)
[ ...] sd 0:2:0:0: [sda] tag#0 CDB: Write(10) 2a 00 0b 3a 82 a0 00 00 20 00
[ ...] sd 0:2:0:0: task abort: FAILED scmd(ffff9b4bf2306160)
[ ...] sd 0:2:0:0: target reset called for scmd(ffff9b4bf2306160)
[ ...] sd 0:2:0:0: [sda] tag#0 megasas: target reset FAILED!!
[ ...] sd 0:2:0:0: [sda] tag#0 Controller reset is requested due to IO timeout
[ ...] SCSI command pointer: (ffff9b4bf2306160)  SCSI host state: 5      SCSI
---

I could not prepare the same environment I reported. So I reproduced
the issue on the following megasas environment.

---
IRQ affinity_list IRQ_TYPE
 34        0-1    IR-PCI-MSI 1048576-edge megasas
 35        2-3    IR-PCI-MSI 1048577-edge megasas
 36        4-5    IR-PCI-MSI 1048578-edge megasas
 37        6-7    IR-PCI-MSI 1048579-edge megasas
 38        8-9    IR-PCI-MSI 1048580-edge megasas
 39      10-11    IR-PCI-MSI 1048581-edge megasas
 40      12-13    IR-PCI-MSI 1048582-edge megasas
 41      14-15    IR-PCI-MSI 1048583-edge megasas
 42      16-17    IR-PCI-MSI 1048584-edge megasas
 43      18-19    IR-PCI-MSI 1048585-edge megasas
 44      20-21    IR-PCI-MSI 1048586-edge megasas
 45      22-23    IR-PCI-MSI 1048587-edge megasas
 46      24-25    IR-PCI-MSI 1048588-edge megasas
 47      26-27    IR-PCI-MSI 1048589-edge megasas
 48      28-29    IR-PCI-MSI 1048590-edge megasas
 49      30-31    IR-PCI-MSI 1048591-edge megasas
 50      32-33    IR-PCI-MSI 1048592-edge megasas
 51      34-35    IR-PCI-MSI 1048593-edge megasas
 52      36-37    IR-PCI-MSI 1048594-edge megasas
 53      38-39    IR-PCI-MSI 1048595-edge megasas
 54      40-41    IR-PCI-MSI 1048596-edge megasas
 55      42-43    IR-PCI-MSI 1048597-edge megasas
 56      44-45    IR-PCI-MSI 1048598-edge megasas
 57      46-47    IR-PCI-MSI 1048599-edge megasas
 58      48-49    IR-PCI-MSI 1048600-edge megasas
 59      50-51    IR-PCI-MSI 1048601-edge megasas
 60      52-53    IR-PCI-MSI 1048602-edge megasas
 61      54-55    IR-PCI-MSI 1048603-edge megasas
 62      56-57    IR-PCI-MSI 1048604-edge megasas
 63      58-59    IR-PCI-MSI 1048605-edge megasas
 64      60-61    IR-PCI-MSI 1048606-edge megasas
 65      62-63    IR-PCI-MSI 1048607-edge megasas
 66      64-65    IR-PCI-MSI 1048608-edge megasas
 67      66-67    IR-PCI-MSI 1048609-edge megasas
 68      68-69    IR-PCI-MSI 1048610-edge megasas
 69      70-71    IR-PCI-MSI 1048611-edge megasas
 70      72-73    IR-PCI-MSI 1048612-edge megasas
 71      74-75    IR-PCI-MSI 1048613-edge megasas
 72      76-77    IR-PCI-MSI 1048614-edge megasas
 73      78-79    IR-PCI-MSI 1048615-edge megasas
 74      80-81    IR-PCI-MSI 1048616-edge megasas
 75      82-83    IR-PCI-MSI 1048617-edge megasas
 76      84-85    IR-PCI-MSI 1048618-edge megasas
 77      86-87    IR-PCI-MSI 1048619-edge megasas
 78      88-89    IR-PCI-MSI 1048620-edge megasas
 79      90-91    IR-PCI-MSI 1048621-edge megasas
 80      92-93    IR-PCI-MSI 1048622-edge megasas
 81      94-95    IR-PCI-MSI 1048623-edge megasas
 82      96-97    IR-PCI-MSI 1048624-edge megasas
 83      98-99    IR-PCI-MSI 1048625-edge megasas
 84    100-101    IR-PCI-MSI 1048626-edge megasas
 85    102-103    IR-PCI-MSI 1048627-edge megasas
 86    104-105    IR-PCI-MSI 1048628-edge megasas
 87    106-107    IR-PCI-MSI 1048629-edge megasas
 88    108-109    IR-PCI-MSI 1048630-edge megasas
 89    110-111    IR-PCI-MSI 1048631-edge megasas
 90    112-113    IR-PCI-MSI 1048632-edge megasas
 91    114-115    IR-PCI-MSI 1048633-edge megasas
 92    116-117    IR-PCI-MSI 1048634-edge megasas
 93    118-119    IR-PCI-MSI 1048635-edge megasas
 94    120-121    IR-PCI-MSI 1048636-edge megasas
 95    122-123    IR-PCI-MSI 1048637-edge megasas
 96    124-125    IR-PCI-MSI 1048638-edge megasas
 97    126-127    IR-PCI-MSI 1048639-edge megasas
 98    128-129    IR-PCI-MSI 1048640-edge megasas
 99    130-131    IR-PCI-MSI 1048641-edge megasas
100    132-133    IR-PCI-MSI 1048642-edge megasas
101    134-135    IR-PCI-MSI 1048643-edge megasas
102    136-137    IR-PCI-MSI 1048644-edge megasas
103    138-139    IR-PCI-MSI 1048645-edge megasas
104    140-141    IR-PCI-MSI 1048646-edge megasas
105    142-143    IR-PCI-MSI 1048647-edge megasas
106    144-145    IR-PCI-MSI 1048648-edge megasas
107    146-147    IR-PCI-MSI 1048649-edge megasas
108    148-149    IR-PCI-MSI 1048650-edge megasas
109    150-151    IR-PCI-MSI 1048651-edge megasas
110    152-153    IR-PCI-MSI 1048652-edge megasas
111    154-155    IR-PCI-MSI 1048653-edge megasas
112    156-157    IR-PCI-MSI 1048654-edge megasas
113    158-159    IR-PCI-MSI 1048655-edge megasas
114    160-161    IR-PCI-MSI 1048656-edge megasas
115    162-163    IR-PCI-MSI 1048657-edge megasas
116    164-165    IR-PCI-MSI 1048658-edge megasas
117    166-167    IR-PCI-MSI 1048659-edge megasas
118    168-169    IR-PCI-MSI 1048660-edge megasas
119    170-171    IR-PCI-MSI 1048661-edge megasas
120    172-173    IR-PCI-MSI 1048662-edge megasas
121    174-175    IR-PCI-MSI 1048663-edge megasas
122    176-177    IR-PCI-MSI 1048664-edge megasas
123    178-179    IR-PCI-MSI 1048665-edge megasas
124    180-181    IR-PCI-MSI 1048666-edge megasas
125    182-183    IR-PCI-MSI 1048667-edge megasas
126    184-185    IR-PCI-MSI 1048668-edge megasas
127    186-187    IR-PCI-MSI 1048669-edge megasas
128    188-189    IR-PCI-MSI 1048670-edge megasas
129    190-191    IR-PCI-MSI 1048671-edge megasas
---

Here are trace log that I offlined CPU 186-191 in descending order.
When I offlined CPU 186, the issue occurred.

---
# tracer: nop
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
         systemd-1     [000] d...     0.427765: irq_do_set_affinity: irq: 24 ret 0 mask: 0-23 eff: 0
         systemd-1     [029] d...    16.745803: irq_do_set_affinity: irq: 9 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    21.850146: irq_do_set_affinity: irq: 25 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    21.856549: irq_do_set_affinity: irq: 26 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    21.862920: irq_do_set_affinity: irq: 27 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    21.869300: irq_do_set_affinity: irq: 28 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    21.875685: irq_do_set_affinity: irq: 29 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    21.897267: irq_do_set_affinity: irq: 30 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    23.983226: irq_do_set_affinity: irq: 31 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    23.998459: irq_do_set_affinity: irq: 32 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    26.095152: irq_do_set_affinity: irq: 33 ret 2 mask: 0-23 eff: 0-5
     kworker/0:3-1458  [000] d...    28.497033: irq_do_set_affinity: irq: 16 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    28.715688: irq_do_set_affinity: irq: 8 ret 2 mask: 0-23 eff: 0-5
         systemd-1     [120] d...    29.163740: irq_do_set_affinity: irq: 4 ret 2 mask: 0-23 eff: 0-5
     kworker/0:1-134   [000] d...    30.625367: irq_do_set_affinity: irq: 34 ret 2 mask: 0-1 eff: 0-1
     kworker/0:1-134   [000] d...    30.625400: irq_do_set_affinity: irq: 35 ret 2 mask: 2-3 eff: 2-3
     kworker/0:1-134   [000] d...    30.625442: irq_do_set_affinity: irq: 36 ret 2 mask: 4-5 eff: 4-5
     kworker/0:1-134   [000] d...    30.625474: irq_do_set_affinity: irq: 37 ret 2 mask: 6-7 eff: 6-7
     kworker/0:1-134   [000] d...    30.625513: irq_do_set_affinity: irq: 38 ret 2 mask: 8-9 eff: 8-9
     kworker/0:1-134   [000] d...    30.625549: irq_do_set_affinity: irq: 39 ret 2 mask: 10-11 eff: 10-11
     kworker/0:1-134   [000] d...    30.625585: irq_do_set_affinity: irq: 40 ret 2 mask: 12-13 eff: 12-13
     kworker/0:1-134   [000] d...    30.625621: irq_do_set_affinity: irq: 41 ret 2 mask: 14-15 eff: 14-15
     kworker/0:1-134   [000] d...    30.625656: irq_do_set_affinity: irq: 42 ret 2 mask: 16-17 eff: 16-17
     kworker/0:1-134   [000] d...    30.625692: irq_do_set_affinity: irq: 43 ret 2 mask: 18-19 eff: 18-19
     kworker/0:1-134   [000] d...    30.625732: irq_do_set_affinity: irq: 44 ret 2 mask: 20-21 eff: 20-21
     kworker/0:1-134   [000] d...    30.625768: irq_do_set_affinity: irq: 45 ret 2 mask: 22-23 eff: 22-23
     kworker/0:1-134   [000] d...    30.625801: irq_do_set_affinity: irq: 46 ret 2 mask: 24-25 eff: 24-25
     kworker/0:1-134   [000] d...    30.625818: irq_do_set_affinity: irq: 47 ret 2 mask: 26-27 eff: 26-27
     kworker/0:1-134   [000] d...    30.625843: irq_do_set_affinity: irq: 48 ret 2 mask: 28-29 eff: 28-29
     kworker/0:1-134   [000] d...    30.625869: irq_do_set_affinity: irq: 49 ret 2 mask: 30-31 eff: 30-31
     kworker/0:1-134   [000] d...    30.625897: irq_do_set_affinity: irq: 50 ret 2 mask: 32-33 eff: 32-33
     kworker/0:1-134   [000] d...    30.625922: irq_do_set_affinity: irq: 51 ret 2 mask: 34-35 eff: 34-35
     kworker/0:1-134   [000] d...    30.625947: irq_do_set_affinity: irq: 52 ret 2 mask: 36-37 eff: 36-37
     kworker/0:1-134   [000] d...    30.625969: irq_do_set_affinity: irq: 53 ret 2 mask: 38-39 eff: 38-39
     kworker/0:1-134   [000] d...    30.625992: irq_do_set_affinity: irq: 54 ret 2 mask: 40-41 eff: 40-41
     kworker/0:1-134   [000] d...    30.626012: irq_do_set_affinity: irq: 55 ret 2 mask: 42-43 eff: 42-43
     kworker/0:1-134   [000] d...    30.626032: irq_do_set_affinity: irq: 56 ret 2 mask: 44-45 eff: 44-45
     kworker/0:1-134   [000] d...    30.626052: irq_do_set_affinity: irq: 57 ret 2 mask: 46-47 eff: 46-47
     kworker/0:1-134   [000] d...    30.626088: irq_do_set_affinity: irq: 58 ret 2 mask: 48-49 eff: 48-49
     kworker/0:1-134   [000] d...    30.626105: irq_do_set_affinity: irq: 59 ret 2 mask: 50-51 eff: 50-51
     kworker/0:1-134   [000] d...    30.626118: irq_do_set_affinity: irq: 60 ret 2 mask: 52-53 eff: 52-53
     kworker/0:1-134   [000] d...    30.626157: irq_do_set_affinity: irq: 61 ret 2 mask: 54-55 eff: 54-55
     kworker/0:1-134   [000] d...    30.626185: irq_do_set_affinity: irq: 62 ret 2 mask: 56-57 eff: 56-57
     kworker/0:1-134   [000] d...    30.626217: irq_do_set_affinity: irq: 63 ret 2 mask: 58-59 eff: 58-59
     kworker/0:1-134   [000] d...    30.626243: irq_do_set_affinity: irq: 64 ret 2 mask: 60-61 eff: 60-61
     kworker/0:1-134   [000] d...    30.626269: irq_do_set_affinity: irq: 65 ret 2 mask: 62-63 eff: 62-63
     kworker/0:1-134   [000] d...    30.626299: irq_do_set_affinity: irq: 66 ret 2 mask: 64-65 eff: 64-65
     kworker/0:1-134   [000] d...    30.626322: irq_do_set_affinity: irq: 67 ret 2 mask: 66-67 eff: 66-67
     kworker/0:1-134   [000] d...    30.626346: irq_do_set_affinity: irq: 68 ret 2 mask: 68-69 eff: 68-69
     kworker/0:1-134   [000] d...    30.626368: irq_do_set_affinity: irq: 69 ret 2 mask: 70-71 eff: 70-71
     kworker/0:1-134   [000] d...    30.626390: irq_do_set_affinity: irq: 70 ret 2 mask: 72-73 eff: 72-73
     kworker/0:1-134   [000] d...    30.626405: irq_do_set_affinity: irq: 71 ret 2 mask: 74-75 eff: 74-75
     kworker/0:1-134   [000] d...    30.626417: irq_do_set_affinity: irq: 72 ret 2 mask: 76-77 eff: 76-77
     kworker/0:1-134   [000] d...    30.626455: irq_do_set_affinity: irq: 73 ret 2 mask: 78-79 eff: 78-79
     kworker/0:1-134   [000] d...    30.626483: irq_do_set_affinity: irq: 74 ret 2 mask: 80-81 eff: 80-81
     kworker/0:1-134   [000] d...    30.626510: irq_do_set_affinity: irq: 75 ret 2 mask: 82-83 eff: 82-83
     kworker/0:1-134   [000] d...    30.626535: irq_do_set_affinity: irq: 76 ret 2 mask: 84-85 eff: 84-85
     kworker/0:1-134   [000] d...    30.626563: irq_do_set_affinity: irq: 77 ret 2 mask: 86-87 eff: 86-87
     kworker/0:1-134   [000] d...    30.626585: irq_do_set_affinity: irq: 78 ret 2 mask: 88-89 eff: 88-89
     kworker/0:1-134   [000] d...    30.626604: irq_do_set_affinity: irq: 79 ret 2 mask: 90-91 eff: 90-91
     kworker/0:1-134   [000] d...    30.626624: irq_do_set_affinity: irq: 80 ret 2 mask: 92-93 eff: 92-93
     kworker/0:1-134   [000] d...    30.626644: irq_do_set_affinity: irq: 81 ret 2 mask: 94-95 eff: 94-95
     kworker/0:1-134   [000] d...    30.626665: irq_do_set_affinity: irq: 82 ret 2 mask: 96-97 eff: 96-97
     kworker/0:1-134   [000] d...    30.626679: irq_do_set_affinity: irq: 83 ret 2 mask: 98-99 eff: 98-99
     kworker/0:1-134   [000] d...    30.626693: irq_do_set_affinity: irq: 84 ret 2 mask: 100-101 eff: 100-101
     kworker/0:1-134   [000] d...    30.626708: irq_do_set_affinity: irq: 85 ret 2 mask: 102-103 eff: 102-103
     kworker/0:1-134   [000] d...    30.626750: irq_do_set_affinity: irq: 86 ret 2 mask: 104-105 eff: 104-105
     kworker/0:1-134   [000] d...    30.626784: irq_do_set_affinity: irq: 87 ret 2 mask: 106-107 eff: 106-107
     kworker/0:1-134   [000] d...    30.626814: irq_do_set_affinity: irq: 88 ret 2 mask: 108-109 eff: 108-109
     kworker/0:1-134   [000] d...    30.626844: irq_do_set_affinity: irq: 89 ret 2 mask: 110-111 eff: 110-111
     kworker/0:1-134   [000] d...    30.626872: irq_do_set_affinity: irq: 90 ret 2 mask: 112-113 eff: 112-113
     kworker/0:1-134   [000] d...    30.626896: irq_do_set_affinity: irq: 91 ret 2 mask: 114-115 eff: 114-115
     kworker/0:1-134   [000] d...    30.626928: irq_do_set_affinity: irq: 92 ret 2 mask: 116-117 eff: 116-117
     kworker/0:1-134   [000] d...    30.626954: irq_do_set_affinity: irq: 93 ret 2 mask: 118-119 eff: 118-119
     kworker/0:1-134   [000] d...    30.626975: irq_do_set_affinity: irq: 94 ret 2 mask: 120-121 eff: 120-121
     kworker/0:1-134   [000] d...    30.626996: irq_do_set_affinity: irq: 95 ret 2 mask: 122-123 eff: 122-123
     kworker/0:1-134   [000] d...    30.627022: irq_do_set_affinity: irq: 96 ret 2 mask: 124-125 eff: 124-125
     kworker/0:1-134   [000] d...    30.627050: irq_do_set_affinity: irq: 97 ret 2 mask: 126-127 eff: 126-127
     kworker/0:1-134   [000] d...    30.627081: irq_do_set_affinity: irq: 98 ret 2 mask: 128-129 eff: 128-129
     kworker/0:1-134   [000] d...    30.627110: irq_do_set_affinity: irq: 99 ret 2 mask: 130-131 eff: 130-131
     kworker/0:1-134   [000] d...    30.627137: irq_do_set_affinity: irq: 100 ret 2 mask: 132-133 eff: 132-133
     kworker/0:1-134   [000] d...    30.627164: irq_do_set_affinity: irq: 101 ret 2 mask: 134-135 eff: 134-135
     kworker/0:1-134   [000] d...    30.627191: irq_do_set_affinity: irq: 102 ret 2 mask: 136-137 eff: 136-137
     kworker/0:1-134   [000] d...    30.627214: irq_do_set_affinity: irq: 103 ret 2 mask: 138-139 eff: 138-139
     kworker/0:1-134   [000] d...    30.627238: irq_do_set_affinity: irq: 104 ret 2 mask: 140-141 eff: 140-141
     kworker/0:1-134   [000] d...    30.627263: irq_do_set_affinity: irq: 105 ret 2 mask: 142-143 eff: 142-143
     kworker/0:1-134   [000] d...    30.627283: irq_do_set_affinity: irq: 106 ret 2 mask: 144-145 eff: 144-145
     kworker/0:1-134   [000] d...    30.627296: irq_do_set_affinity: irq: 107 ret 2 mask: 146-147 eff: 146-147
     kworker/0:1-134   [000] d...    30.627311: irq_do_set_affinity: irq: 108 ret 2 mask: 148-149 eff: 148-149
     kworker/0:1-134   [000] d...    30.627344: irq_do_set_affinity: irq: 109 ret 2 mask: 150-151 eff: 150-151
     kworker/0:1-134   [000] d...    30.627377: irq_do_set_affinity: irq: 110 ret 2 mask: 152-153 eff: 152-153
     kworker/0:1-134   [000] d...    30.627410: irq_do_set_affinity: irq: 111 ret 2 mask: 154-155 eff: 154-155
     kworker/0:1-134   [000] d...    30.627437: irq_do_set_affinity: irq: 112 ret 2 mask: 156-157 eff: 156-157
     kworker/0:1-134   [000] d...    30.627467: irq_do_set_affinity: irq: 113 ret 2 mask: 158-159 eff: 158-159
     kworker/0:1-134   [000] d...    30.627494: irq_do_set_affinity: irq: 114 ret 2 mask: 160-161 eff: 160-161
     kworker/0:1-134   [000] d...    30.627519: irq_do_set_affinity: irq: 115 ret 2 mask: 162-163 eff: 162-163
     kworker/0:1-134   [000] d...    30.627545: irq_do_set_affinity: irq: 116 ret 2 mask: 164-165 eff: 164-165
     kworker/0:1-134   [000] d...    30.627569: irq_do_set_affinity: irq: 117 ret 2 mask: 166-167 eff: 166-167
     kworker/0:1-134   [000] d...    30.627589: irq_do_set_affinity: irq: 118 ret 2 mask: 168-169 eff: 168-169
     kworker/0:1-134   [000] d...    30.627607: irq_do_set_affinity: irq: 119 ret 2 mask: 170-171 eff: 170-171
     kworker/0:1-134   [000] d...    30.627639: irq_do_set_affinity: irq: 120 ret 2 mask: 172-173 eff: 172-173
     kworker/0:1-134   [000] d...    30.627666: irq_do_set_affinity: irq: 121 ret 2 mask: 174-175 eff: 174-175
     kworker/0:1-134   [000] d...    30.627691: irq_do_set_affinity: irq: 122 ret 2 mask: 176-177 eff: 176-177
     kworker/0:1-134   [000] d...    30.627721: irq_do_set_affinity: irq: 123 ret 2 mask: 178-179 eff: 178-179
     kworker/0:1-134   [000] d...    30.627748: irq_do_set_affinity: irq: 124 ret 2 mask: 180-181 eff: 180-181
     kworker/0:1-134   [000] d...    30.627774: irq_do_set_affinity: irq: 125 ret 2 mask: 182-183 eff: 182-183
     kworker/0:1-134   [000] d...    30.627799: irq_do_set_affinity: irq: 126 ret 2 mask: 184-185 eff: 184-185
     kworker/0:1-134   [000] d...    30.627828: irq_do_set_affinity: irq: 127 ret 2 mask: 186-187 eff: 186
     kworker/0:1-134   [000] d...    30.627850: irq_do_set_affinity: irq: 128 ret 2 mask: 188-189 eff: 188
     kworker/0:1-134   [000] d...    30.627875: irq_do_set_affinity: irq: 129 ret 2 mask: 190-191 eff: 190
     kworker/0:0-3     [000] d...    38.217213: irq_do_set_affinity: irq: 18 ret 2 mask: 0-23 eff: 0-5
   systemd-udevd-2007  [129] d...    38.510108: irq_do_set_affinity: irq: 3 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.732162: irq_do_set_affinity: irq: 131 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.732195: irq_do_set_affinity: irq: 132 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.732214: irq_do_set_affinity: irq: 133 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.732229: irq_do_set_affinity: irq: 134 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.732246: irq_do_set_affinity: irq: 135 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.732261: irq_do_set_affinity: irq: 136 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.732276: irq_do_set_affinity: irq: 137 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.732292: irq_do_set_affinity: irq: 138 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.732308: irq_do_set_affinity: irq: 139 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.865529: irq_do_set_affinity: irq: 140 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.865557: irq_do_set_affinity: irq: 141 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.865575: irq_do_set_affinity: irq: 142 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.865591: irq_do_set_affinity: irq: 143 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.865607: irq_do_set_affinity: irq: 144 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.865621: irq_do_set_affinity: irq: 145 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.865635: irq_do_set_affinity: irq: 146 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.865650: irq_do_set_affinity: irq: 147 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    44.865664: irq_do_set_affinity: irq: 148 ret 2 mask: 0-23 eff: 0-5
  NetworkManager-2628  [135] d...    45.041598: irq_do_set_affinity: irq: 130 ret 2 mask: 0-23 eff: 6-9,11,16,18-19,21-23,26-28,31,34-35,38,40-43,47-63
  NetworkManager-2628  [135] d...    45.042054: irq_do_set_affinity: irq: 130 ret 2 mask: 0-23 eff: 6-8,10-11,16,18-19,21-23,26-28,31,34-35,38,40-43,47-63
  NetworkManager-2628  [135] d...    45.150285: irq_do_set_affinity: irq: 130 ret 2 mask: 0-23 eff: 0-5
        (agetty)-3134  [049] d...    55.930794: irq_do_set_affinity: irq: 4 ret 2 mask: 0-23 eff: 0-5
           <...>-1346  [191] d..1   100.473714: irq_do_set_affinity: irq: 129 ret 2 mask: 190-191 eff: 190
           <...>-1346  [191] d..1   100.473722: <stack trace>
 => native_cpu_disable
 => take_cpu_down
 => multi_cpu_stop
 => cpu_stopper_thread
 => smpboot_thread_fn
 => kthread
 => ret_from_fork
           <...>-1334  [189] d..1   700.567235: irq_do_set_affinity: irq: 128 ret 2 mask: 188-189 eff: 188
           <...>-1334  [189] d..1   700.567243: <stack trace>
 => native_cpu_disable
 => take_cpu_down
 => multi_cpu_stop
 => cpu_stopper_thread
 => smpboot_thread_fn
 => kthread
 => ret_from_fork
           <...>-1322  [187] d..1  1300.660985: irq_do_set_affinity: irq: 127 ret 2 mask: 186-187 eff: 186
           <...>-1322  [187] d..1  1300.660993: <stack trace>
 => native_cpu_disable
 => take_cpu_down
 => multi_cpu_stop
 => cpu_stopper_thread
 => smpboot_thread_fn
 => kthread
 => ret_from_fork
---

Thanks,
Yasuaki Ishimatsu

On 10/10/2017 12:30 PM, YASUAKI ISHIMATSU wrote:
> Hi Thomas,
> 
> Sorry for the late reply.
> 
> I'll apply the patches and retest in this week.
> Please wait a while.
> 
> Thanks,
> Yasuaki Ishimatsu
> 
> On 10/04/2017 05:04 PM, Thomas Gleixner wrote:
>> On Tue, 3 Oct 2017, Thomas Gleixner wrote:
>>> Can you please apply the debug patch below.
>>
>> I found an issue with managed interrupts when the affinity mask of an
>> managed interrupt spawns multiple CPUs. Explanation in the changelog
>> below. I'm not sure that this cures the problems you have, but at least I
>> could prove that it's not doing what it should do. The failure I'm seing is
>> fixed, but I can't test that megasas driver due to -ENOHARDWARE.
>>
>> Can you please apply the patch below on top of Linus tree and retest?
>>
>> Please send me the outputs I asked you to provide last time in any case
>> (success or fail).
>>
>> @block/scsi folks: Can you please run that through your tests as well?
>>
>> Thanks,
>>
>> 	tglx
>>
>> 8<-----------------------
>> Subject: genirq/cpuhotplug: Enforce affinity setting on startup of managed irqs
>> From: Thomas Gleixner <tglx@linutronix.de>
>> Date: Wed, 04 Oct 2017 21:07:38 +0200
>>
>> Managed interrupts can end up in a stale state on CPU hotplug. If the
>> interrupt is not targeting a single CPU, i.e. the affinity mask spawns
>> multiple CPUs then the following can happen:
>>
>> After boot:
>>
>> dstate:   0x01601200
>>             IRQD_ACTIVATED
>>             IRQD_IRQ_STARTED
>>             IRQD_SINGLE_TARGET
>>             IRQD_AFFINITY_SET
>>             IRQD_AFFINITY_MANAGED
>> node:     0
>> affinity: 24-31
>> effectiv: 24
>> pending:  0
>>
>> After offlining CPU 31 - 24
>>
>> dstate:   0x01a31000
>>             IRQD_IRQ_DISABLED
>>             IRQD_IRQ_MASKED
>>             IRQD_SINGLE_TARGET
>>             IRQD_AFFINITY_SET
>>             IRQD_AFFINITY_MANAGED
>>             IRQD_MANAGED_SHUTDOWN
>> node:     0
>> affinity: 24-31
>> effectiv: 24
>> pending:  0
>>
>> Now CPU 25 gets onlined again, so it should get the effective interrupt
>> affinity for this interruopt, but due to the x86 interrupt affinity setter
>> restrictions this ends up after restarting the interrupt with:
>>
>> dstate:   0x01601300
>>             IRQD_ACTIVATED
>>             IRQD_IRQ_STARTED
>>             IRQD_SINGLE_TARGET
>>             IRQD_AFFINITY_SET
>>             IRQD_SETAFFINITY_PENDING
>>             IRQD_AFFINITY_MANAGED
>> node:     0
>> affinity: 24-31
>> effectiv: 24
>> pending:  24-31
>>
>> So the interrupt is still affine to CPU 24, which was the last CPU to go
>> offline of that affinity set and the move to an online CPU within 24-31,
>> in this case 25, is pending. This mechanism is x86/ia64 specific as those
>> architectures cannot move interrupts from thread context and do this when
>> an interrupt is actually handled. So the move is set to pending.
>>
>> Whats worse is that offlining CPU 25 again results in:
>>
>> dstate:   0x01601300
>>             IRQD_ACTIVATED
>>             IRQD_IRQ_STARTED
>>             IRQD_SINGLE_TARGET
>>             IRQD_AFFINITY_SET
>>             IRQD_SETAFFINITY_PENDING
>>             IRQD_AFFINITY_MANAGED
>> node:     0
>> affinity: 24-31
>> effectiv: 24
>> pending:  24-31
>>
>> This means the interrupt has not been shut down, because the outgoing CPU
>> is not in the effective affinity mask, but of course nothing notices that
>> the effective affinity mask is pointing at an offline CPU.
>>
>> In the case of restarting a managed interrupt the move restriction does not
>> apply, so the affinity setting can be made unconditional. This needs to be
>> done _before_ the interrupt is started up as otherwise the condition for
>> moving it from thread context would not longer be fulfilled.
>>
>> With that change applied onlining CPU 25 after offlining 31-24 results in:
>>
>> dstate:   0x01600200
>>             IRQD_ACTIVATED
>>             IRQD_IRQ_STARTED
>>             IRQD_SINGLE_TARGET
>>             IRQD_AFFINITY_MANAGED
>> node:     0
>> affinity: 24-31
>> effectiv: 25
>> pending:  
>>
>> And after offlining CPU 25:
>>
>> dstate:   0x01a30000
>>             IRQD_IRQ_DISABLED
>>             IRQD_IRQ_MASKED
>>             IRQD_SINGLE_TARGET
>>             IRQD_AFFINITY_MANAGED
>>             IRQD_MANAGED_SHUTDOWN
>> node:     0
>> affinity: 24-31
>> effectiv: 25
>> pending:  
>>
>> which is the correct and expected result.
>>
>> To complete that, add some debug code to catch this kind of situation in
>> the cpu offline code and warn about interrupt chips which allow affinity
>> setting and do not update the effective affinity mask if that feature is
>> enabled.
>>
>> Reported-by: YASUAKI ISHIMATSU <yasu.isimatu@gmail.com>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>>
>> ---
>>  kernel/irq/chip.c       |    2 +-
>>  kernel/irq/cpuhotplug.c |   28 +++++++++++++++++++++++++++-
>>  kernel/irq/manage.c     |   17 +++++++++++++++++
>>  3 files changed, 45 insertions(+), 2 deletions(-)
>>
>> --- a/kernel/irq/chip.c
>> +++ b/kernel/irq/chip.c
>> @@ -265,8 +265,8 @@ int irq_startup(struct irq_desc *desc, b
>>  			irq_setup_affinity(desc);
>>  			break;
>>  		case IRQ_STARTUP_MANAGED:
>> +			irq_do_set_affinity(d, aff, false);
>>  			ret = __irq_startup(desc);
>> -			irq_set_affinity_locked(d, aff, false);
>>  			break;
>>  		case IRQ_STARTUP_ABORT:
>>  			return 0;
>> --- a/kernel/irq/cpuhotplug.c
>> +++ b/kernel/irq/cpuhotplug.c
>> @@ -18,8 +18,34 @@
>>  static inline bool irq_needs_fixup(struct irq_data *d)
>>  {
>>  	const struct cpumask *m = irq_data_get_effective_affinity_mask(d);
>> +	unsigned int cpu = smp_processor_id();
>>  
>> -	return cpumask_test_cpu(smp_processor_id(), m);
>> +#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
>> +	/*
>> +	 * The cpumask_empty() check is a workaround for interrupt chips,
>> +	 * which do not implement effective affinity, but the architecture has
>> +	 * enabled the config switch. Use the general affinity mask instead.
>> +	 */
>> +	if (cpumask_empty(m))
>> +		m = irq_data_get_affinity_mask(d);
>> +
>> +	/*
>> +	 * Sanity check. If the mask is not empty when excluding the outgoing
>> +	 * CPU then it must contain at least one online CPU. The outgoing CPU
>> +	 * has been removed from the online mask already.
>> +	 */
>> +	if (cpumask_any_but(m, cpu) < nr_cpu_ids &&
>> +	    cpumask_any_and(m, cpu_online_mask) >= nr_cpu_ids) {
>> +		/*
>> +		 * If this happens then there was a missed IRQ fixup at some
>> +		 * point. Warn about it and enforce fixup.
>> +		 */
>> +		pr_warn("Eff. affinity %*pbl of IRQ %u contains only offline CPUs after offlining CPU %u\n",
>> +			cpumask_pr_args(m), d->irq, cpu);
>> +		return true;
>> +	}
>> +#endif
>> +	return cpumask_test_cpu(cpu, m);
>>  }
>>  
>>  static bool migrate_one_irq(struct irq_desc *desc)
>> --- a/kernel/irq/manage.c
>> +++ b/kernel/irq/manage.c
>> @@ -168,6 +168,19 @@ void irq_set_thread_affinity(struct irq_
>>  			set_bit(IRQTF_AFFINITY, &action->thread_flags);
>>  }
>>  
>> +static void irq_validate_effective_affinity(struct irq_data *data)
>> +{
>> +#ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
>> +	const struct cpumask *m = irq_data_get_effective_affinity_mask(data);
>> +	struct irq_chip *chip = irq_data_get_irq_chip(data);
>> +
>> +	if (!cpumask_empty(m))
>> +		return;
>> +	pr_warn_once("irq_chip %s did not update eff. affinity mask of irq %u\n",
>> +		     chip->name, data->irq);
>> +#endif
>> +}
>> +
>>  int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
>>  			bool force)
>>  {
>> @@ -175,12 +188,16 @@ int irq_do_set_affinity(struct irq_data
>>  	struct irq_chip *chip = irq_data_get_irq_chip(data);
>>  	int ret;
>>  
>> +	if (!chip || !chip->irq_set_affinity)
>> +		return -EINVAL;
>> +
>>  	ret = chip->irq_set_affinity(data, mask, force);
>>  	switch (ret) {
>>  	case IRQ_SET_MASK_OK:
>>  	case IRQ_SET_MASK_OK_DONE:
>>  		cpumask_copy(desc->irq_common_data.affinity, mask);
>>  	case IRQ_SET_MASK_OK_NOCOPY:
>> +		irq_validate_effective_affinity(data);
>>  		irq_set_thread_affinity(desc);
>>  		ret = 0;
>>  	}
>>
