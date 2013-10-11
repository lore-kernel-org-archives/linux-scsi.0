From: Jason Seba <jason.seba42@gmail.com>
Subject: Possible locking bug in pm8xxx/pm8001
Date: Fri, 11 Oct 2013 16:32:09 -0400
Message-ID: <CAD0Z9TJpOZ6CEq5-x-TC5QSwqqtTUdojfwxO+x1X_kSvTCj9Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:56133 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3JKUcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Oct 2013 16:32:11 -0400
Received: by mail-oa0-f53.google.com with SMTP id i7so2832085oag.12
        for <linux-scsi@vger.kernel.org>; Fri, 11 Oct 2013 13:32:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The pm8xxx driver uses a per-adapter spinlock (pm8001_ha->lock) which
is usually acquired and released with the irqsave routines. However,
some functions which are called with the lock held
(mpi_sata_completion, mpi_sata_event, pm8001_chip_sata_req) will
temporary release the lock to complete a task. However, when releasing
and reacquiring the lock in this case, the irqsave routine are not
used; instead spin_unlock_irq/spin_lock_irq are used. As far as I can
tell, this is wrong and dangerous, and appears to result in the hard
lockup shown below.

It isn't obvious to me what the best way to fix this is. Suggestions?



[ 2048.017802] ------------[ cut here ]------------
[ 2048.022621] WARNING: CPU: 0 PID: 1606 at kernel/watchdog.c:245
watchdog_overflow_callback+0xac/0xd0()
[ 2048.031827] Watchdog detected hard LOCKUP on cpu 0
[ 2048.036439] Modules linked in: ses enclosure xt_CHECKSUM
iptable_mangle ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat bridge
sunrpc fcoe 8021q mrp garp libfcoe libfc scsi_transport_fc stp llc
scsi_tgt xt_physdev nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT
nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter
ip6_tables binfmt_misc uinput iTCO_wdt iTCO_vendor_support mgag200 ttm
drm_kms_helper drm i2c_algo_bit sysimgblt sysfillrect syscopyarea
pm80xx libsas scsi_transport_sas joydev dcdbas pcspkr i2c_i801
i2c_core lpc_ich mfd_core tg3 ptp pps_core [last unloaded:
speedstep_lib]
[ 2048.090159] CPU: 0 PID: 1606 Comm: libvirtd Not tainted 3.11.0-rc5+ #2
[ 2048.096682] Hardware name: Dell Inc. PowerEdge T110 II/015TH9, BIOS
2.0.5 03/13/2012
[ 2048.104410] 000000f5 f3401828 c1580fe3 c1710301 f3401858 c10418e4
c17061bc f3401884
[ 2048.112277] 00000646 c1710301 000000f5 c10c415c c10c415c f5822800
c10c40b0 00000000
[ 2048.120153] f3401870 c10419a3 00000009 f3401868 c17061bc f3401884
f3401888 c10c415c
[ 2048.128022] Call Trace:
[ 2048.130476] [<c1580fe3>] dump_stack+0x41/0x56
[ 2048.134921] [<c10418e4>] warn_slowpath_common+0x84/0xa0
[ 2048.140231] [<c10c415c>] ? watchdog_overflow_callback+0xac/0xd0
[ 2048.146236] [<c10c415c>] ? watchdog_overflow_callback+0xac/0xd0
[ 2048.152239] [<c10c40b0>] ? watchdog_cleanup+0x10/0x10
[ 2048.157369] [<c10419a3>] warn_slowpath_fmt+0x33/0x40
[ 2048.162420] [<c10c415c>] watchdog_overflow_callback+0xac/0xd0
[ 2048.168243] [<c10fbbef>] __perf_event_overflow+0xaf/0x280
[ 2048.173729] [<c101322a>] ? x86_perf_event_set_period+0x12a/0x1e0
[ 2048.179819] [<c10fc685>] perf_event_overflow+0x15/0x20
[ 2048.185043] [<c1019d9b>] intel_pmu_handle_irq+0x1bb/0x390
[ 2048.190519] [<c107019d>] ? sched_clock_cpu+0x11d/0x1a0
[ 2048.195744] [<c1586871>] perf_event_nmi_handler+0x31/0x50
[ 2048.201229] [<c1585f52>] nmi_handle+0x52/0x190
[ 2048.205762] [<c1342b60>] ? serial8250_modem_status+0xb0/0xb0
[ 2048.211504] [<c1586172>] do_nmi+0xe2/0x3d0
[ 2048.215681] [<c15856bb>] nmi_stack_correct+0x2f/0x34
[ 2048.220732] [<c15800d8>] ? __pci_bus_size_bridges+0x868/0x890
[ 2048.226563] [<c1584c12>] ? _raw_spin_lock_irqsave+0x22/0x30
[ 2048.232215] [<f80f018e>] process_oq+0x6ae/0x1820 [pm80xx]
[ 2048.237698] [<f80f1323>] pm8001_chip_isr+0x23/0x40 [pm80xx]
[ 2048.243356] [<f80e501f>] pm8001_tasklet+0x1f/0x30 [pm80xx]
[ 2048.248925] [<c10458de>] tasklet_action+0x8e/0xa0
[ 2048.253709] [<c104616f>] __do_softirq+0xaf/0x200
[ 2048.258406] [<c10463a5>] irq_exit+0xa5/0xb0
[ 2048.262676] [<c158c45b>] do_IRQ+0x4b/0xc0
[ 2048.266768] [<c105f67b>] ? add_wait_queue+0x3b/0x50
[ 2048.271730] [<c158c333>] common_interrupt+0x33/0x38
[ 2048.276687] [<c14800d8>] ? qi_flush_dev_iotlb+0x98/0xf0
[ 2048.282001] [<c1167fb1>] ? poll_schedule_timeout+0x1/0xb0
[ 2048.287483] [<c1168eed>] ? do_sys_poll+0x4ad/0x530
[ 2048.292352] [<c11681e0>] ? __pollwait+0xe0/0xe0
[ 2048.296962] [<c11681e0>] ? __pollwait+0xe0/0xe0
[ 2048.301581] [<c11681e0>] ? __pollwait+0xe0/0xe0
[ 2048.306197] [<c11681e0>] ? __pollwait+0xe0/0xe0
[ 2048.310808] [<c11681e0>] ? __pollwait+0xe0/0xe0
[ 2048.315416] [<c11681e0>] ? __pollwait+0xe0/0xe0
[ 2048.320026] [<c14c4ef4>] ? netlink_recvmsg+0x294/0x340
[ 2048.325244] [<c123827d>] ? selinux_socket_recvmsg+0x1d/0x20
[ 2048.330901] [<c148d5b0>] ? sock_recvmsg+0xc0/0xf0
[ 2048.335692] [<c10733c7>] ? update_curr+0x1e7/0x290
[ 2048.340572] [<c148b56d>] ? move_addr_to_user+0x7d/0xb0
[ 2048.345796] [<c148db52>] ? ___sys_recvmsg+0x142/0x1e0
[ 2048.350933] [<c148d4f0>] ? kernel_sendmsg+0x50/0x50
[ 2048.355898] [<c148de0f>] ? __sys_recvmsg+0x5f/0x70
[ 2048.360775] [<c148de36>] ? SyS_recvmsg+0x16/0x20
[ 2048.365473] [<c148e617>] ? SyS_socketcall+0x107/0x2e0
[ 2048.370609] [<c1168fca>] SyS_poll+0x5a/0xd0
[ 2048.374873] [<c158be81>] sysenter_do_call+0x12/0x22
[ 2048.379828] ---[ end trace 723e25b4ff5b3a4f ]---
