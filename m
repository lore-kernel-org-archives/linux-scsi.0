From: "Qi, Yanling" <yanling.qi@lsil.com>
Subject: Help in finding system temporary hang problem
Date: Tue, 17 Feb 2004 16:15:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <53CF1076699CD711B7DD0002A51363F102AD7EBE@exw-ks.ks.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:2747 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266691AbUBQWRl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 17:17:41 -0500
Received: from new-mhbs.co.lsil.com (mhbs.lsil.com [172.21.20.49])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id i1HMEHDv016206
	for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2004 14:14:17 -0800 (PST)
Received: from exw-ks.ks.lsil.com (wic1.ks.lsil.com [153.79.12.11])
	by new-mhbs.co.lsil.com (8.12.11/8.12.10) with ESMTP id i1HMHbwX016548
	for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2004 15:17:38 -0700
List-Id: linux-scsi@vger.kernel.org
To: 'linux-scsi-reflector' <linux-scsi@vger.kernel.org>

Hi Everyone,

I have a SMP system (2 CPU with hyper-threading) connected to a SAN
environment. The FC HBA is qla2312. I observed that the system hangs for
about 20-40 seconds when a FC cable is pulled off from a switch or plugged
into a switch. 

The attached the "sysirq process-state traces" during system frozen time. I
realized that so many processes are in "D" state and wait for
"__wait_on_buffer".

Could someone tell what is going on?

Thanks,


Yanling


==============

#start

<6>SysRq : Show Regs

Process: 0, {             swapper}
Kernel 2.4.9-e.27smp
EIP: 0010:[<c010542e>] CPU: 0EIP is at default_idle [kernel] 0x2e
 EFLAGS: 00000246    Not tainted
EAX: 00000000 EBX: c0105400 ECX: c0310000 EDX: 00000000
ESI: c0310000 EDI: c0310000 EBP: c0105400 DS: 0018 ES: 0018
CR0: 8005003b CR2: 080ca1c0 CR3: 3142f000 CR4: 000006d0
Call Trace: scsi(3): fcport-0 - port retry count :14 remainning
scsi(3): fcport-1 - port retry count :14 remainning
scsi(3): fcport-2 - port retry count :14 remainning
scsi(3): fcport-3 - port retry count :14 remainning
[<c0105492>] cpu_idle [kernel] 0x32
[<c0105000>] stext [kernel] 0x0
[<c0244800>] .rodata.str1.32 [kernel] 0x560


<6>SysRq : Show State

                         free                        sibling
  task             PC    stack   pid father child younger older
init          S 00000000  2836     1      0  4383       4       (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01073c3>] system_call [kernel] 0x33

keventd       S 00000000  5772     2      1             3       (L-TLB)
Call Trace: [<c01297cc>] context_thread [kernel] 0x13c
[<c0105000>] stext [kernel] 0x0
[<c0105000>] stext [kernel] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c0129690>] context_thread [kernel] 0x0

keventd       S C3ABBF68  5964     3      1            11     2 (L-TLB)
Call Trace: [<c01297cc>] context_thread [kernel] 0x13c
[<c0107376>] ret_from_fork [kernel] 0x6
[<c0105000>] stext [kernel] 0x0
[<c0105000>] stext [kernel] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c0129690>] context_thread [kernel] 0x0

ksoftirqd_CPU S FFFFFFFE  4500     4      0             5     1 (L-TLB)
Call Trace: [<c012111f>] ksoftirqd [kernel] 0xaf
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c0121070>] ksoftirqd [kernel] 0x0

ksoftirqd_CPU S FFFFFFF6  4536     5      0             6     4 (L-TLB)
Call Trace: [<c012111f>] ksoftirqd [kernel] 0xaf
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c0121070>] ksoftirqd [kernel] 0x0

kswapd        R current   3832     6      0             7     5 (L-TLB)
Call Trace: [<c0239c7e>] stext_lock [kernel] 0x1c7e
[<c0119735>] schedule [kernel] 0x385
[<c013b239>] page_launder [kernel] 0x339
[<c0125260>] process_timeout [kernel] 0x0
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ca33>] kswapd [kernel] 0x103
[<c013c930>] kswapd [kernel] 0x0
[<c0105000>] stext [kernel] 0x0
[<c0105000>] stext [kernel] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c013c930>] kswapd [kernel] 0x0

kreclaimd     S 00000000  5620     7      0             8     6 (L-TLB)
Call Trace: [<c0119a61>] interruptible_sleep_on [kernel] 0x51
[<c013ce6a>] kreclaimd [kernel] 0x4a
[<c0105000>] stext [kernel] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c013ce20>] kreclaimd [kernel] 0x0

krefilld      S 00000000  4708     8      0             9     7 (L-TLB)
Call Trace: [<c0119a61>] interruptible_sleep_on [kernel] 0x51
[<c0266d26>] .rodata.str1.1 [kernel] 0x2cc1
[<c0266d26>] .rodata.str1.1 [kernel] 0x2cc1
[<c013cf1a>] krefilld [kernel] 0x4a
[<c0105000>] stext [kernel] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c013ced0>] krefilld [kernel] 0x0

bdflush       R C18CD910  3888     9      0            10     8 (L-TLB)
Call Trace: [<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c014399d>] alloc_bounce_page [kernel] 0x3d
[<c0199769>] req_new_io [kernel] 0x49
[<c0143b4c>] create_bounce [kernel] 0x2c
[<c0199a30>] __make_request [kernel] 0xb0
[<c0113aff>] smp_call_function_interrupt [kernel] 0x2f
[<c024663a>] call_call_function_interrupt [kernel] 0x5
[<c019a2fc>] generic_make_request [kernel] 0x17c
[<c024663a>] call_call_function_interrupt [kernel] 0x5
[<c019a369>] submit_bh [kernel] 0x59
[<c019a877>] ll_rw_block [kernel] 0x267
[<c0113aff>] smp_call_function_interrupt [kernel] 0x2f
[<c024663a>] call_call_function_interrupt [kernel] 0x5
[<c0113aff>] smp_call_function_interrupt [kernel] 0x2f
[<c024663a>] call_call_function_interrupt [kernel] 0x5
[<c014a9a0>] flush_dirty_buffers [kernel] 0xa0
[<c014ac26>] bdflush [kernel] 0x96
[<c0105000>] stext [kernel] 0x0
[<c0105000>] stext [kernel] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c014ab90>] bdflush [kernel] 0x0

kupdated      R C17B6430  5012    10      0                   9 (L-TLB)
Call Trace: [<c013a3da>] page_launder_zone [kernel] 0x8a
[<c013b239>] page_launder [kernel] 0x339
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c014399d>] alloc_bounce_page [kernel] 0x3d
[<c0199769>] req_new_io [kernel] 0x49
[<c0143b4c>] create_bounce [kernel] 0x2c
[<c0199a30>] __make_request [kernel] 0xb0
[<c019a2fc>] generic_make_request [kernel] 0x17c
[<c024663a>] call_call_function_interrupt [kernel] 0x5
[<c019a369>] submit_bh [kernel] 0x59
[<c019a877>] ll_rw_block [kernel] 0x267
[<c011ca38>] printk [kernel] 0xd8
[<c0119735>] schedule [kernel] 0x385
[<c014a9a0>] flush_dirty_buffers [kernel] 0xa0
[<c0267112>] .rodata.str1.1 [kernel] 0x30ad
[<c014aa90>] sync_old_buffers [kernel] 0x60
[<c014aca8>] do_io_postprocessing [kernel] 0x48
[<c014aded>] kupdate [kernel] 0x12d
[<c0105000>] stext [kernel] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c014acc0>] kupdate [kernel] 0x0

mdrecoveryd   S F7FFA000  6252    11      1            24     3 (L-TLB)
Call Trace: [<c01d3005>] md_thread [kernel] 0x125
[<c0107376>] ret_from_fork [kernel] 0x6
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<c01d2ee0>] md_thread [kernel] 0x0

qla2300_dpc2  S 00000000  5444    24      1            25    11 (L-TLB)
Call Trace: [<c01060d4>] __down_interruptible [kernel] 0x74
[<c01061bb>] __down_failed_interruptible [kernel] 0x7
[<f887dfa2>] .text.lock [qla2300] 0x582
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f886aaf0>] qla2x00_do_dpc [qla2300] 0x0

qla2300_dpc3  S 00000000  4968    25      1            27    24 (L-TLB)
Call Trace: [<c01060d4>] __down_interruptible [kernel] 0x74
[<c011ca38>] printk [kernel] 0xd8
[<c01061bb>] __down_failed_interruptible [kernel] 0x7
[<f887dfa2>] .text.lock [qla2300] 0x582
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f886aaf0>] qla2x00_do_dpc [qla2300] 0x0

scsi_eh_2     S 00000002  6080    26      1            29    27 (L-TLB)
Call Trace: [<c01060d4>] __down_interruptible [kernel] 0x74
[<f88a93e0>] driver_template [qla2300] 0x0
[<c01061bb>] __down_failed_interruptible [kernel] 0x7
[<f8816046>] .LC648 [scsi_mod] 0x136
[<f880c05b>] .text.lock [scsi_mod] 0x1db
[<c0107376>] ret_from_fork [kernel] 0x6
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f8806820>] scsi_error_handler [scsi_mod] 0x0

scsi_eh_3     S 00000003  6080    27      1            26    25 (L-TLB)
Call Trace: [<c01060d4>] __down_interruptible [kernel] 0x74
[<f88a93e0>] driver_template [qla2300] 0x0
[<c01061bb>] __down_failed_interruptible [kernel] 0x7
[<f8816046>] .LC648 [scsi_mod] 0x136
[<f880c05b>] .text.lock [scsi_mod] 0x1db
[<c0107376>] ret_from_fork [kernel] 0x6
[<f88a0018>] fw2300tp_code01 [qla2300] 0x10764
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f8806820>] scsi_error_handler [scsi_mod] 0x0

mpp_dpc       S 00000000  4108    29      1            30    26 (L-TLB)
Call Trace: [<f88b5e7c>] mppLnx_dpc_sem [mpp_Vhba] 0x0
[<c01060d4>] __down_interruptible [kernel] 0x74
[<f88b5e88>] mppLnx_dpc_sem [mpp_Vhba] 0xc
[<f88b5e88>] mppLnx_dpc_sem [mpp_Vhba] 0xc
[<f88bb390>] mppLnxDpcQueueContext [mpp_Vhba] 0x0
[<c01061bb>] __down_failed_interruptible [kernel] 0x7
[<f88b5e7c>] mppLnx_dpc_sem [mpp_Vhba] 0x0
[<f88b19b3>] .text.lock [mpp_Vhba] 0x133
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88afb20>] mppLnx_dpc_handler [mpp_Vhba] 0x0

mppFailback   S DDC2B7E0  5092    30      1            31    29 (L-TLB)
Call Trace: [<f88b5ea4>] mppLnx_failback_sem [mpp_Vhba] 0x0
[<c01060d4>] __down_interruptible [kernel] 0x74
[<f88b5eb0>] mppLnx_failback_sem [mpp_Vhba] 0xc
[<f88b5eb0>] mppLnx_failback_sem [mpp_Vhba] 0xc
[<c01061bb>] __down_failed_interruptible [kernel] 0x7
[<f88b5ea4>] mppLnx_failback_sem [mpp_Vhba] 0x0
[<f88bb3d0>] mppLnxFailbackScanContext [mpp_Vhba] 0x10
[<f88b1929>] .text.lock [mpp_Vhba] 0xa9
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88af380>] mppLnx_failback_handler [mpp_Vhba] 0x0

mppWorker     S 00000282  4308    31      1            32    30 (L-TLB)
Call Trace: [<f88b5eb8>] mppLnx_syncIOWorker_sem [mpp_Vhba] 0x0
[<c01060d4>] __down_interruptible [kernel] 0x74
[<f88b5ec4>] mppLnx_syncIOWorker_sem [mpp_Vhba] 0xc
[<f88b5ec4>] mppLnx_syncIOWorker_sem [mpp_Vhba] 0xc
[<f8804fc0>] scsi_times_out [scsi_mod] 0x0
[<c01061bb>] __down_failed_interruptible [kernel] 0x7
[<f88b5eb8>] mppLnx_syncIOWorker_sem [mpp_Vhba] 0x0
[<f88b1963>] .text.lock [mpp_Vhba] 0xe3
[<f8804fc0>] scsi_times_out [scsi_mod] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88af580>] mppLnx_worker_handler [mpp_Vhba] 0x0

scsi_eh_4     S 00000004  6080    32      1            35    31 (L-TLB)
Call Trace: [<c01060d4>] __down_interruptible [kernel] 0x74
[<f88b5ee0>] driver_template [mpp_Vhba] 0x0
[<c01061bb>] __down_failed_interruptible [kernel] 0x7
[<f8816046>] .LC648 [scsi_mod] 0x136
[<f880c05b>] .text.lock [scsi_mod] 0x1db
[<c0107376>] ret_from_fork [kernel] 0x6
[<f88a0018>] fw2300tp_code01 [qla2300] 0x10764
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f8806820>] scsi_error_handler [scsi_mod] 0x0

kjournald     S 00000000  3776    35      1            88    32 (L-TLB)
Call Trace: [<c0119a61>] interruptible_sleep_on [kernel] 0x51
[<f88c44ca>] kjournald [jbd] 0x16a
[<f88c4340>] commit_timeout [jbd] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88c4360>] kjournald [jbd] 0x0

khubd         S F3CD9400  6056    88      1           185    35 (L-TLB)
Call Trace: [<f89ed7c8>] khubd_wait [usbcore] 0x0
[<c0119a61>] interruptible_sleep_on [kernel] 0x51
[<f89ed7cc>] khubd_wait [usbcore] 0x4
[<f89ed7cc>] khubd_wait [usbcore] 0x4
[<f89e1820>] usb_hub_thread [usbcore] 0x0
[<f89e91f2>] .LC73 [usbcore] 0x64
[<f89e186f>] usb_hub_thread [usbcore] 0x4f
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f89e1820>] usb_hub_thread [usbcore] 0x0

kjournald     S 0000000A  5496   185      1           835    88 (L-TLB)
Call Trace: [<c0119a61>] interruptible_sleep_on [kernel] 0x51
[<f88c44ca>] kjournald [jbd] 0x16a
[<f88c4340>] commit_timeout [jbd] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88c4360>] kjournald [jbd] 0x0

syslogd       D F1B7C000  3664   835      1           840   185 (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c013b09f>] page_launder [kernel] 0x19f
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c01561d1>] __pollwait [kernel] 0x31
[<c01dc3f7>] datagram_poll [kernel] 0x27
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c0156479>] do_select [kernel] 0x139
[<c01568f9>] sys_select [kernel] 0x339
[<c01473b3>] sys_fsync [kernel] 0x83
[<c01073c3>] system_call [kernel] 0x33

klogd         S 00000001  4288   840      1           860   835 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c013825b>] kmalloc [kernel] 0x7b
[<c021c3ef>] unix_wait_for_peer [kernel] 0xaf
[<c021cec7>] unix_dgram_sendmsg [kernel] 0x337
[<f880052c>] scsi_release_command_Rsmp_f12100cc [scsi_mod] 0x11c
[<f8820d8f>] rw_intr [sd_mod] 0x20f
[<c01d676c>] sock_sendmsg [kernel] 0x6c
[<f8800edc>] scsi_bottom_half_handler [scsi_mod] 0xbc
[<c01d6997>] sock_write [kernel] 0xa7
[<c0145d26>] sys_write [kernel] 0x96
[<c0118a6b>] wake_up_process [kernel] 0xb
[<c0108eee>] do_IRQ [kernel] 0xfe
[<c01073c3>] system_call [kernel] 0x33

portmap       S C012EFB4  3352   860      1           888   840 (NOTLB)
Call Trace: [<c012efb4>] do_munmap [kernel] 0x64
[<c0125284>] schedule_timeout [kernel] 0x14
[<c0156a99>] do_pollfd [kernel] 0x59
[<c0156b46>] do_pollfd [kernel] 0x106
[<c0156b7e>] do_pollfd [kernel] 0x13e
[<c0156dd1>] sys_poll [kernel] 0x231
[<c01073c3>] system_call [kernel] 0x33

rpc.statd     S F2BC6C20  4656   888      1          1056   860 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01073c3>] system_call [kernel] 0x33

sshd          S F1DE64E0  4516  1056      1 12506    1089   888 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01073c3>] system_call [kernel] 0x33

xinetd        S F1862780  4356  1089      1          1130  1056 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01073c3>] system_call [kernel] 0x33

sendmail      D 64366330  4516  1130      1          1158  1089 (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c013da56>] _wrapped_alloc_pages [kernel] 0x76
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c013b09f>] page_launder [kernel] 0x19f
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c01561d1>] __pollwait [kernel] 0x31
[<c01f508e>] tcp_poll [kernel] 0x2e
[<c015b02a>] destroy_inode [kernel] 0x2a
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c0156479>] do_select [kernel] 0x139
[<c01568f9>] sys_select [kernel] 0x339
[<c01073c3>] system_call [kernel] 0x33

scsi_eh_5     S 00000005  4736  1158      1          1177  1130 (L-TLB)
Call Trace: [<c01060d4>] __down_interruptible [kernel] 0x74
[<f8a56d60>] iscsiDriverTemplate [iscsi] 0x0
[<c01061bb>] __down_failed_interruptible [kernel] 0x7
[<f8816046>] .LC648 [scsi_mod] 0x136
[<f880c05b>] .text.lock [scsi_mod] 0x1db
[<c0107376>] ret_from_fork [kernel] 0x6
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f8806820>] scsi_error_handler [scsi_mod] 0x0

gpm           D 00000282  3912  1177      1          1195  1158 (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c017eeaf>] init_dev [kernel] 0x36f
[<c013b239>] page_launder [kernel] 0x339
[<c0105b2d>] __switch_to [kernel] 0x3d
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c0137d1d>] kmem_cache_grow [kernel] 0xdd
[<c0119735>] schedule [kernel] 0x385
[<c01381c4>] kmem_cache_alloc [kernel] 0xf4
[<c01252fa>] schedule_timeout [kernel] 0x8a
[<c015092e>] getname [kernel] 0x1e
[<c014558e>] sys_open [kernel] 0xe
[<c01073c3>] system_call [kernel] 0x33

crond         D F14EA000  5208  1195      1          1261  1177 (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c015c7b2>] iget4 [kernel] 0x52
[<c013b239>] page_launder [kernel] 0x339
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c0137d1d>] kmem_cache_grow [kernel] 0xdd
[<c01381c4>] kmem_cache_alloc [kernel] 0xf4
[<c0106f8d>] handle_signal [kernel] 0x7d
[<c015092e>] getname [kernel] 0x1e
[<c0151d21>] __user_walk [kernel] 0x11
[<c014de74>] vfs_stat [kernel] 0x14
[<c014e411>] sys_stat64 [kernel] 0x11
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

xfs           S C013DD40  4276  1261      1          1297  1195 (NOTLB)
Call Trace: [<c013dd40>] __get_free_pages [kernel] 0x10
[<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c0118a6b>] wake_up_process [kernel] 0xb
[<c01073c3>] system_call [kernel] 0x33

atd           S 3FA687EF  4516  1297      1          1308  1261 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000001  3188  1308      1  1395    1379  1297 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

mingetty      S 00000008  4504  1379      1          1380  1308 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c01c4d02>] vgacon_cursor [kernel] 0x1b2
[<c0182864>] read_chan [kernel] 0x3a4
[<c0182e12>] write_chan [kernel] 0x1e2
[<c017e7c7>] tty_read [kernel] 0xd7
[<c0145c06>] sys_read [kernel] 0x96
[<c014571e>] filp_close [kernel] 0x9e
[<c012f223>] sys_munmap [kernel] 0x33
[<c01073c3>] system_call [kernel] 0x33

mingetty      S 00000008  4516  1380      1          1381  1379 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c012ae02>] __free_pte [kernel] 0x62
[<c0182864>] read_chan [kernel] 0x3a4
[<c0182e12>] write_chan [kernel] 0x1e2
[<c017e7c7>] tty_read [kernel] 0xd7
[<c0145c06>] sys_read [kernel] 0x96
[<c014571e>] filp_close [kernel] 0x9e
[<c012f223>] sys_munmap [kernel] 0x33
[<c01073c3>] system_call [kernel] 0x33

mingetty      S 00000008  4736  1381      1          1382  1380 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c012ae02>] __free_pte [kernel] 0x62
[<c0182864>] read_chan [kernel] 0x3a4
[<c0182e12>] write_chan [kernel] 0x1e2
[<c017e7c7>] tty_read [kernel] 0xd7
[<c0145c06>] sys_read [kernel] 0x96
[<c014571e>] filp_close [kernel] 0x9e
[<c012f223>] sys_munmap [kernel] 0x33
[<c01073c3>] system_call [kernel] 0x33

mingetty      S 00000008  4736  1382      1          1383  1381 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c012ae02>] __free_pte [kernel] 0x62
[<c0182864>] read_chan [kernel] 0x3a4
[<c0182e12>] write_chan [kernel] 0x1e2
[<c017e7c7>] tty_read [kernel] 0xd7
[<c0145c06>] sys_read [kernel] 0x96
[<c014571e>] filp_close [kernel] 0x9e
[<c012f223>] sys_munmap [kernel] 0x33
[<c01073c3>] system_call [kernel] 0x33

mingetty      S 00000008  4736  1383      1          1384  1382 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c012ae02>] __free_pte [kernel] 0x62
[<c0182864>] read_chan [kernel] 0x3a4
[<c0182e12>] write_chan [kernel] 0x1e2
[<c017e7c7>] tty_read [kernel] 0xd7
[<c0145c06>] sys_read [kernel] 0x96
[<c014571e>] filp_close [kernel] 0x9e
[<c012f223>] sys_munmap [kernel] 0x33
[<c01073c3>] system_call [kernel] 0x33

mingetty      S 00000008  4736  1384      1          1385  1383 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c012ae02>] __free_pte [kernel] 0x62
[<c0182864>] read_chan [kernel] 0x3a4
[<c0182e12>] write_chan [kernel] 0x1e2
[<c017e7c7>] tty_read [kernel] 0xd7
[<c0145c06>] sys_read [kernel] 0x96
[<c014571e>] filp_close [kernel] 0x9e
[<c012f223>] sys_munmap [kernel] 0x33
[<c01073c3>] system_call [kernel] 0x33

gdm           S F15F00C0  4216  1385      1  1399    1386  1384 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c0156a99>] do_pollfd [kernel] 0x59
[<c0156b46>] do_pollfd [kernel] 0x106
[<c0156b7e>] do_pollfd [kernel] 0x13e
[<c0156dd1>] sys_poll [kernel] 0x231
[<c01073c3>] system_call [kernel] 0x33

lk_logmgr     S 00000000  4584  1386      1          1415  1385 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c0156a99>] do_pollfd [kernel] 0x59
[<c0156b46>] do_pollfd [kernel] 0x106
[<c0156b7e>] do_pollfd [kernel] 0x13e
[<c0156dd1>] sys_poll [kernel] 0x231
[<c0145a3e>] sys_lseek [kernel] 0xbe
[<c01073c3>] system_call [kernel] 0x33

java          D F6847A00  5560  1395   1308  1413               (NOTLB)
Call Trace: [<f8807be4>] scsi_queue_next_request [scsi_mod] 0x64
[<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c013db04>] _wrapped_alloc_pages [kernel] 0x124
[<c013b239>] page_launder [kernel] 0x339
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c0156cca>] sys_poll [kernel] 0x12a
[<c01073c3>] system_call [kernel] 0x33

java          S 00000001  4932  1396   1395          1397       (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  5928  1397   1395          1398  1396 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  5932  1398   1395          1400  1397 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

gdm           S FFFF037F  4372  1399   1385  1725               (NOTLB)
Call Trace: [<c011fe18>] sys_wait4 [kernel] 0x3c8
[<c01073c3>] system_call [kernel] 0x33

java          S 00000001  4320  1400   1395          1402  1398 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

X             D F14E9DE8  4216  1401   1399          1725       (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c013b09f>] page_launder [kernel] 0x19f
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c01561d1>] __pollwait [kernel] 0x31
[<c01f508e>] tcp_poll [kernel] 0x2e
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c0156479>] do_select [kernel] 0x139
[<c01568f9>] sys_select [kernel] 0x339
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  5932  1402   1395          1403  1400 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  5932  1403   1395          1404  1402 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000000  5928  1404   1395          1405  1403 (NOTLB)
Call Trace: [<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000206  5932  1405   1395          1411  1404 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c013da56>] _wrapped_alloc_pages [kernel] 0x76
[<c01f98e6>] wait_for_connect [kernel] 0x126
[<c01f9a62>] tcp_accept [kernel] 0xb2
[<c0211cdb>] inet_accept [kernel] 0x2b
[<c01d73c3>] sys_accept [kernel] 0x63
[<c0117f80>] do_page_fault [kernel] 0x0
[<c0118126>] do_page_fault [kernel] 0x1a6
[<c01066f5>] restore_sigcontext [kernel] 0x115
[<c01d7e30>] sys_socketcall [kernel] 0xb0
[<c0117f80>] do_page_fault [kernel] 0x0
[<c01074c0>] error_code [kernel] 0x38
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  5932  1411   1395          1412  1405 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000001  5932  1412   1395          1413  1411 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000001  5208  1413   1395                1412 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

lcm           D 00000000  3564  1415      1          1416  1386 (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c01ef270>] ip_rcv_finish [kernel] 0x0
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c0120bab>] do_softirq [kernel] 0x7b
[<c013b09f>] page_launder [kernel] 0x19f
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c0156cca>] sys_poll [kernel] 0x12a
[<c01073c3>] system_call [kernel] 0x33

ttymonlcm     S 00000202  3984  1416      1          1417  1415 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012656d>] do_sigpending [kernel] 0x7d
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

lcd           S 00000000  4352  1417      1          1418  1416 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012656d>] do_sigpending [kernel] 0x7d
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

lkcheck       S F72CB800  4584  1418      1          1419  1417 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

lkscsid       S FFFFFFEA  4108  1419      1  2748    1420  1418 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

runGuiServer  S F1A159A0  4504  1420      1  1465    1421  1419 (NOTLB)
Call Trace: [<c011fe18>] sys_wait4 [kernel] 0x3c8
[<c01073c3>] system_call [kernel] 0x33

mhttpd        S 00000202  3864  1421      1          1922  1420 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c01f98e6>] wait_for_connect [kernel] 0x126
[<c01f9a62>] tcp_accept [kernel] 0xb2
[<c0211cdb>] inet_accept [kernel] 0x2b
[<c01d73c3>] sys_accept [kernel] 0x63
[<c01258f4>] dequeue_signal [kernel] 0x14
[<c0107086>] do_signal [kernel] 0x66
[<c012f1d4>] do_munmap [kernel] 0x284
[<c01d7e30>] sys_socketcall [kernel] 0xb0
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  4504  1465   1420  1494               (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S C0150229  4504  1494   1465 11116               (NOTLB)
Call Trace: [<c0150229>] pipe_poll [kernel] 0x29
[<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c0156b46>] do_pollfd [kernel] 0x106
[<c0156b7e>] do_pollfd [kernel] 0x13e
[<c0156dd1>] sys_poll [kernel] 0x231
[<c01073c3>] system_call [kernel] 0x33

java          S 00000000  4356  1495   1494          1496       (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  4736  1496   1494          1497  1495 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  5384  1497   1494          1498  1496 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000206  4392  1498   1494          1499  1497 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  5932  1499   1494          1500  1498 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  5932  1500   1494          1501  1499 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S F1CF5680  5348  1501   1494          1506  1500 (NOTLB)
Call Trace: [<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S C01EF270  4568  1506   1494          1508  1501 (NOTLB)
Call Trace: [<c01ef270>] ip_rcv_finish [kernel] 0x0
[<c01e45a3>] nf_hook_slow [kernel] 0xd3
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01f98e6>] wait_for_connect [kernel] 0x126
[<c01f9a62>] tcp_accept [kernel] 0xb2
[<c0211cdb>] inet_accept [kernel] 0x2b
[<c01d73c3>] sys_accept [kernel] 0x63
[<c01260bc>] kill_something_info [kernel] 0x10c
[<c01268f9>] sys_kill [kernel] 0x49
[<c01252fa>] schedule_timeout [kernel] 0x8a
[<c01d7e30>] sys_socketcall [kernel] 0xb0
[<c01073c3>] system_call [kernel] 0x33

java          S C01EF270  4560  1508   1494          1509  1506 (NOTLB)
Call Trace: [<c01ef270>] ip_rcv_finish [kernel] 0x0
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01f98e6>] wait_for_connect [kernel] 0x126
[<c01f9a62>] tcp_accept [kernel] 0xb2
[<c0211cdb>] inet_accept [kernel] 0x2b
[<c01d73c3>] sys_accept [kernel] 0x63
[<c01260bc>] kill_something_info [kernel] 0x10c
[<c01268f9>] sys_kill [kernel] 0x49
[<c0105b2d>] __switch_to [kernel] 0x3d
[<c0119735>] schedule [kernel] 0x385
[<c01d7e30>] sys_socketcall [kernel] 0xb0
[<c01073c3>] system_call [kernel] 0x33

java          S C01066F5  5932  1509   1494          1510  1508 (NOTLB)
Call Trace: [<c01066f5>] restore_sigcontext [kernel] 0x115
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S FFFFFFFF  5932  1510   1494          1591  1509 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000000  5932  1591   1494          1592  1510 (NOTLB)
Call Trace: [<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000000  4684  1592   1494          1698  1591 (NOTLB)
Call Trace: [<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000001  4504  1698   1494          1700  1592 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S FFFFFFFF  3288  1700   1494          1702  1698 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000000  5932  1702   1494          1705  1700 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<f8a463c4>] aarp_timer [appletalk] 0x0
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000001  4496  1705   1494         11112  1702 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

startkde      S F1A155E0  4504  1725   1399  1960          1401 (NOTLB)
Call Trace: [<c011fe18>] sys_wait4 [kernel] 0x3c8
[<c0145840>] generic_file_llseek [kernel] 0x0
[<c01073c3>] system_call [kernel] 0x33

kdeinit       S F0E2DF4C  4912  1919      1  1991    1966  1955 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01073c3>] system_call [kernel] 0x33

kdeinit       S F0E0DF4C  4516  1922      1          1925  1421 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c0154f6a>] do_fcntl [kernel] 0x18a
[<c015517d>] sys_fcntl64 [kernel] 0x8d
[<c01073c3>] system_call [kernel] 0x33

kdeinit       S F0DF3F4C  4652  1925      1          1928  1922 (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c0145c7e>] sys_read [kernel] 0x10e
[<c01073c3>] system_call [kernel] 0x33

kdeinit       D F3CE5C00  3296  1928      1          1955  1925 (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c013810c>] kmem_cache_alloc [kernel] 0x3c
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c013b239>] page_launder [kernel] 0x339
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c01561d1>] __pollwait [kernel] 0x31
[<c021db26>] unix_poll [kernel] 0x26
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c0156479>] do_select [kernel] 0x139
[<c01568f9>] sys_select [kernel] 0x339
[<c01d6ba0>] sock_ioctl [kernel] 0x50
[<c01073c3>] system_call [kernel] 0x33

artsd         D 18A1E794  4216  1942   1919          1961       (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c01197c2>] __wake_up [kernel] 0x42
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c013b239>] page_launder [kernel] 0x339
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c01561d1>] __pollwait [kernel] 0x31
[<c0150229>] pipe_poll [kernel] 0x29
[<c0156479>] do_select [kernel] 0x139
[<c01568f9>] sys_select [kernel] 0x339
[<c01073c3>] system_call [kernel] 0x33

kdeinit       S C01561D1  5040  1955      1          1919  1928 (NOTLB)
Call Trace: [<c01561d1>] __pollwait [kernel] 0x31
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01d6ba0>] sock_ioctl [kernel] 0x50
[<c01073c3>] system_call [kernel] 0x33

ksmserver     S C01561D1  4216  1960   1725                     (NOTLB)
Call Trace: [<c01561d1>] __pollwait [kernel] 0x31
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01d6ba0>] sock_ioctl [kernel] 0x50
[<c01073c3>] system_call [kernel] 0x33

kdeinit       S C01561D1  4156  1961   1919          1991  1942 (NOTLB)
Call Trace: [<c01561d1>] __pollwait [kernel] 0x31
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c0145c7e>] sys_read [kernel] 0x10e
[<c01073c3>] system_call [kernel] 0x33

kdeinit       S C01561D1  3296  1966      1 14274    1968  1919 (NOTLB)
Call Trace: [<c01561d1>] __pollwait [kernel] 0x31
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c0145c7e>] sys_read [kernel] 0x10e
[<c01073c3>] system_call [kernel] 0x33

kdeinit       D 00000246  4496  1968      1          1977  1966 (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c0138318>] kmalloc [kernel] 0x138
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c013b239>] page_launder [kernel] 0x339
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c01561d1>] __pollwait [kernel] 0x31
[<c021db26>] unix_poll [kernel] 0x26
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c0156479>] do_select [kernel] 0x139
[<c01568f9>] sys_select [kernel] 0x339
[<c01d6ba0>] sock_ioctl [kernel] 0x50
[<c01073c3>] system_call [kernel] 0x33

kdeinit       S C013DD40  4496  1977      1          1979  1968 (NOTLB)
Call Trace: [<c013dd40>] __get_free_pages [kernel] 0x10
[<c01561d1>] __pollwait [kernel] 0x31
[<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01d6ba0>] sock_ioctl [kernel] 0x50
[<c01073c3>] system_call [kernel] 0x33

kdeinit       S C01561D1  5208  1979      1  1981    1980  1977 (NOTLB)
Call Trace: [<c01561d1>] __pollwait [kernel] 0x31
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01d6ba0>] sock_ioctl [kernel] 0x50
[<c01073c3>] system_call [kernel] 0x33

alarmd        S C01561D1  5308  1980      1          2872  1979 (NOTLB)
Call Trace: [<c01561d1>] __pollwait [kernel] 0x31
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01d6ba0>] sock_ioctl [kernel] 0x50
[<c01073c3>] system_call [kernel] 0x33

cat           S F0A7BEC0  4736  1981   1979                     (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c012d596>] handle_mm_fault [kernel] 0x96
[<c0182864>] read_chan [kernel] 0x3a4
[<f88d4909>] ext3_dirty_inode [ext3] 0xa9
[<c017e7c7>] tty_read [kernel] 0xd7
[<c0145c06>] sys_read [kernel] 0x96
[<c01073c3>] system_call [kernel] 0x33

kdeinit       S C01561D1  4516  1991   1919  1992          1961 (NOTLB)
Call Trace: [<c01561d1>] __pollwait [kernel] 0x31
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c01d6ba0>] sock_ioctl [kernel] 0x50
[<c01073c3>] system_call [kernel] 0x33

bash          S 00002DC2  4736  1992   1991 11714               (NOTLB)
Call Trace: [<c011fe18>] sys_wait4 [kernel] 0x3c8
[<c01073c3>] system_call [kernel] 0x33

lkscsid       D F09EBDB4  4496  2748   1419  4125               (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<f88ad6c0>] mppLnx_queuecommand [mpp_Vhba] 0x0
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c013b239>] page_launder [kernel] 0x339
[<c013cc3e>] wakeup_kswapd [kernel] 0x15e
[<c012105d>] __run_task_queue [kernel] 0x5d
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c01561d1>] __pollwait [kernel] 0x31
[<c0150229>] pipe_poll [kernel] 0x29
[<c0156a85>] do_pollfd [kernel] 0x45
[<c0156b46>] do_pollfd [kernel] 0x106
[<c0156dd1>] sys_poll [kernel] 0x231
[<c01073c3>] system_call [kernel] 0x33

lkscsid       D 00000000  3824  2749   2748          2948       (NOTLB)
Call Trace: [<c01199d0>] wait_for_completion [kernel] 0xa0
[<c011ca38>] printk [kernel] 0xd8
[<f88007fb>] scsi_wait_req_Rsmp_b234b1fc [scsi_mod] 0x7b
[<f8814193>] .LC33 [scsi_mod] 0x0
[<f88000c0>] scsi_wait_done [scsi_mod] 0x0
[<f88038f7>] scsi_ioctl_send_command_Rsmp_0e6a1369 [scsi_mod] 0x287
[<c013da56>] _wrapped_alloc_pages [kernel] 0x76
[<f8826c56>] sg_ioctl [sg] 0xbd6
[<c013dd40>] __get_free_pages [kernel] 0x10
[<f8829251>] sg_low_malloc [sg] 0x131
[<f8829326>] sg_malloc [sg] 0x66
[<f8827d32>] sg_build_indi [sg] 0x82
[<f88289a1>] sg_build_reserve [sg] 0x51
[<f8828eca>] sg_add_sfp [sg] 0xfa
[<f88252b6>] sg_open [sg] 0x256
[<c01464ae>] get_chrfops [kernel] 0x4e
[<c0152245>] open_namei [kernel] 0x335
[<c0146799>] chrdev_open [kernel] 0x59
[<c01453a3>] dentry_open [kernel] 0xc3
[<c01452cd>] filp_open [kernel] 0x4d
[<c0155887>] sys_ioctl [kernel] 0x257
[<c01073c3>] system_call [kernel] 0x33

kjournald     D F09E9DE4  3580  2872      1          3104  1980 (L-TLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<f88c1e5c>] journal_commit_transaction [jbd] 0x95c
[<f8870b17>] qla2x00_isr [qla2300] 0x8c7
[<f8804f7f>] scsi_delete_timer_Rsmp_c6cde1f3 [scsi_mod] 0xf
[<c01851e3>] batch_entropy_process [kernel] 0xb3
[<c0105b2d>] __switch_to [kernel] 0x3d
[<c0119735>] schedule [kernel] 0x385
[<f88c44a6>] kjournald [jbd] 0x146
[<f88c4340>] commit_timeout [jbd] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88c4360>] kjournald [jbd] 0x0

lkscsid       D 00000000  4124  2948   2748          3268  2749 (NOTLB)
Call Trace: [<c01199d0>] wait_for_completion [kernel] 0xa0
[<c011ca38>] printk [kernel] 0xd8
[<f88007fb>] scsi_wait_req_Rsmp_b234b1fc [scsi_mod] 0x7b
[<f8814193>] .LC33 [scsi_mod] 0x0
[<f88000c0>] scsi_wait_done [scsi_mod] 0x0
[<f88038f7>] scsi_ioctl_send_command_Rsmp_0e6a1369 [scsi_mod] 0x287
[<c013da56>] _wrapped_alloc_pages [kernel] 0x76
[<f8826c56>] sg_ioctl [sg] 0xbd6
[<c013dd40>] __get_free_pages [kernel] 0x10
[<f8829251>] sg_low_malloc [sg] 0x131
[<f8829326>] sg_malloc [sg] 0x66
[<f8827d32>] sg_build_indi [sg] 0x82
[<f88289a1>] sg_build_reserve [sg] 0x51
[<f8828eca>] sg_add_sfp [sg] 0xfa
[<f88252b6>] sg_open [sg] 0x256
[<c01464ae>] get_chrfops [kernel] 0x4e
[<c0152245>] open_namei [kernel] 0x335
[<c0146799>] chrdev_open [kernel] 0x59
[<c01453a3>] dentry_open [kernel] 0xc3
[<c01452cd>] filp_open [kernel] 0x4d
[<c0155887>] sys_ioctl [kernel] 0x257
[<c01073c3>] system_call [kernel] 0x33

kjournald     D 00000001  3588  3104      1          3181  2872 (L-TLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<f88c1e5c>] journal_commit_transaction [jbd] 0x95c
[<f8870b17>] qla2x00_isr [qla2300] 0x8c7
[<f8804f7f>] scsi_delete_timer_Rsmp_c6cde1f3 [scsi_mod] 0xf
[<f8800d5b>] scsi_done [scsi_mod] 0xb
[<f887d87c>] qla2x00_callback [qla2300] 0x12c
[<c0119735>] schedule [kernel] 0x385
[<f88c44a6>] kjournald [jbd] 0x146
[<f88c4340>] commit_timeout [jbd] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88c4360>] kjournald [jbd] 0x0

copycomp.sh   S C02F83B4  4372  3181      1 18105    3414  3104 (NOTLB)
Call Trace: [<c014fcac>] pipe_wait [kernel] 0x8c
[<c014fd94>] pipe_read [kernel] 0xb4
[<c0145c06>] sys_read [kernel] 0x96
[<c014571e>] filp_close [kernel] 0x9e
[<c01073c3>] system_call [kernel] 0x33

lkscsid       D F8823580     0  3268   2748          3484  2948 (NOTLB)
Call Trace: [<f8823580>] sd_template [sd_mod] 0x0
[<c01199d0>] wait_for_completion [kernel] 0xa0
[<c011ca38>] printk [kernel] 0xd8
[<f88007fb>] scsi_wait_req_Rsmp_b234b1fc [scsi_mod] 0x7b
[<f8814193>] .LC33 [scsi_mod] 0x0
[<f88000c0>] scsi_wait_done [scsi_mod] 0x0
[<f88038f7>] scsi_ioctl_send_command_Rsmp_0e6a1369 [scsi_mod] 0x287
[<c013da56>] _wrapped_alloc_pages [kernel] 0x76
[<f8826c56>] sg_ioctl [sg] 0xbd6
[<c013dd40>] __get_free_pages [kernel] 0x10
[<f8829251>] sg_low_malloc [sg] 0x131
[<f8829326>] sg_malloc [sg] 0x66
[<f8827d32>] sg_build_indi [sg] 0x82
[<f88289a1>] sg_build_reserve [sg] 0x51
[<f8828eca>] sg_add_sfp [sg] 0xfa
[<f88252b6>] sg_open [sg] 0x256
[<c01464ae>] get_chrfops [kernel] 0x4e
[<c0152245>] open_namei [kernel] 0x335
[<c0146799>] chrdev_open [kernel] 0x59
[<c01453a3>] dentry_open [kernel] 0xc3
[<c01452cd>] filp_open [kernel] 0x4d
[<c0155887>] sys_ioctl [kernel] 0x257
[<c01073c3>] system_call [kernel] 0x33

kjournald     D 00000000  3352  3414      1          3644  3181 (L-TLB)
Call Trace: [<c0106004>] __down [kernel] 0x74
[<c01061a4>] __down_failed [kernel] 0x8
[<f88c6461>] .text.lock [jbd] 0x261
[<f880052c>] scsi_release_command_Rsmp_f12100cc [scsi_mod] 0x11c
[<f8804f7f>] scsi_delete_timer_Rsmp_c6cde1f3 [scsi_mod] 0xf
[<f8800d5b>] scsi_done [scsi_mod] 0xb
[<f887d87c>] qla2x00_callback [qla2300] 0x12c
[<c0119735>] schedule [kernel] 0x385
[<f88c44a6>] kjournald [jbd] 0x146
[<f88c4340>] commit_timeout [jbd] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88c4360>] kjournald [jbd] 0x0

lkscsid       D 00000000     0  3484   2748          3841  3268 (NOTLB)
Call Trace: [<c01199d0>] wait_for_completion [kernel] 0xa0
[<c011ca38>] printk [kernel] 0xd8
[<f88007fb>] scsi_wait_req_Rsmp_b234b1fc [scsi_mod] 0x7b
[<f8814193>] .LC33 [scsi_mod] 0x0
[<f88000c0>] scsi_wait_done [scsi_mod] 0x0
[<f88038f7>] scsi_ioctl_send_command_Rsmp_0e6a1369 [scsi_mod] 0x287
[<c013da56>] _wrapped_alloc_pages [kernel] 0x76
[<f8826c56>] sg_ioctl [sg] 0xbd6
[<c013dd40>] __get_free_pages [kernel] 0x10
[<f8829251>] sg_low_malloc [sg] 0x131
[<f8829326>] sg_malloc [sg] 0x66
[<f8827d32>] sg_build_indi [sg] 0x82
[<f88289a1>] sg_build_reserve [sg] 0x51
[<f8828eca>] sg_add_sfp [sg] 0xfa
[<f88252b6>] sg_open [sg] 0x256
[<c01464ae>] get_chrfops [kernel] 0x4e
[<c0152245>] open_namei [kernel] 0x335
[<c0146799>] chrdev_open [kernel] 0x59
[<c01453a3>] dentry_open [kernel] 0xc3
[<c01452cd>] filp_open [kernel] 0x4d
[<c0155887>] sys_ioctl [kernel] 0x257
[<c01073c3>] system_call [kernel] 0x33

kjournald     D E950DDE4     0  3644      1          3718  3414 (L-TLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<f88c1e5c>] journal_commit_transaction [jbd] 0x95c
[<f880116b>] scsi_finish_command [scsi_mod] 0xab
[<f8800edc>] scsi_bottom_half_handler [scsi_mod] 0xbc
[<c0119735>] schedule [kernel] 0x385
[<f88c44a6>] kjournald [jbd] 0x146
[<f88c4340>] commit_timeout [jbd] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88c4360>] kjournald [jbd] 0x0

copycomp.sh   S F0F750E0     0  3718      1 18117    4023  3644 (NOTLB)
Call Trace: [<c011fe18>] sys_wait4 [kernel] 0x3c8
[<c01073c3>] system_call [kernel] 0x33

lkscsid       D 00000000     0  3841   2748          4125  3484 (NOTLB)
Call Trace: [<c01199d0>] wait_for_completion [kernel] 0xa0
[<c011ca38>] printk [kernel] 0xd8
[<f88007fb>] scsi_wait_req_Rsmp_b234b1fc [scsi_mod] 0x7b
[<f8814193>] .LC33 [scsi_mod] 0x0
[<f88000c0>] scsi_wait_done [scsi_mod] 0x0
[<f88038f7>] scsi_ioctl_send_command_Rsmp_0e6a1369 [scsi_mod] 0x287
[<c013da56>] _wrapped_alloc_pages [kernel] 0x76
[<f8826c56>] sg_ioctl [sg] 0xbd6
[<c013dd40>] __get_free_pages [kernel] 0x10
[<f8829251>] sg_low_malloc [sg] 0x131
[<f8829326>] sg_malloc [sg] 0x66
[<f8827d32>] sg_build_indi [sg] 0x82
[<f88289a1>] sg_build_reserve [sg] 0x51
[<f8828eca>] sg_add_sfp [sg] 0xfa
[<f88252b6>] sg_open [sg] 0x256
[<c01464ae>] get_chrfops [kernel] 0x4e
[<c0152245>] open_namei [kernel] 0x335
[<c0146799>] chrdev_open [kernel] 0x59
[<c01453a3>] dentry_open [kernel] 0xc3
[<c01452cd>] filp_open [kernel] 0x4d
[<c0155887>] sys_ioctl [kernel] 0x257
[<c01073c3>] system_call [kernel] 0x33

kjournald     D C038E1C0     0  4023      1          4302  3718 (L-TLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<f88c1977>] journal_commit_transaction [jbd] 0x477
[<f8870b17>] qla2x00_isr [qla2300] 0x8c7
[<f8804f7f>] scsi_delete_timer_Rsmp_c6cde1f3 [scsi_mod] 0xf
[<f8800d5b>] scsi_done [scsi_mod] 0xb
[<f887d87c>] qla2x00_callback [qla2300] 0x12c
[<f88c44a6>] kjournald [jbd] 0x146
[<f88c4340>] commit_timeout [jbd] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88c4360>] kjournald [jbd] 0x0

lkscsid       D F8823580  1376  4125   2748                3841 (NOTLB)
Call Trace: [<f8823580>] sd_template [sd_mod] 0x0
[<c01199d0>] wait_for_completion [kernel] 0xa0
[<c011ca38>] printk [kernel] 0xd8
[<f88007fb>] scsi_wait_req_Rsmp_b234b1fc [scsi_mod] 0x7b
[<f8814193>] .LC33 [scsi_mod] 0x0
[<f88000c0>] scsi_wait_done [scsi_mod] 0x0
[<f88038f7>] scsi_ioctl_send_command_Rsmp_0e6a1369 [scsi_mod] 0x287
[<c013da56>] _wrapped_alloc_pages [kernel] 0x76
[<f8826c56>] sg_ioctl [sg] 0xbd6
[<c013dd40>] __get_free_pages [kernel] 0x10
[<f8829251>] sg_low_malloc [sg] 0x131
[<f8829326>] sg_malloc [sg] 0x66
[<f8827d32>] sg_build_indi [sg] 0x82
[<f88289a1>] sg_build_reserve [sg] 0x51
[<f8828eca>] sg_add_sfp [sg] 0xfa
[<f88252b6>] sg_open [sg] 0x256
[<c01464ae>] get_chrfops [kernel] 0x4e
[<c0152245>] open_namei [kernel] 0x335
[<c0146799>] chrdev_open [kernel] 0x59
[<c01453a3>] dentry_open [kernel] 0xc3
[<c01452cd>] filp_open [kernel] 0x4d
[<c0155887>] sys_ioctl [kernel] 0x257
[<c01073c3>] system_call [kernel] 0x33

kjournald     D 00000000     0  4302      1          4383  4023 (L-TLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<f88c1977>] journal_commit_transaction [jbd] 0x477
[<f880052c>] scsi_release_command_Rsmp_f12100cc [scsi_mod] 0x11c
[<f8820d8f>] rw_intr [sd_mod] 0x20f
[<f88c44a6>] kjournald [jbd] 0x146
[<f88c4340>] commit_timeout [jbd] 0x0
[<c0105836>] arch_kernel_thread [kernel] 0x26
[<f88c4360>] kjournald [jbd] 0x0

copycomp.sh   S C02F83B4     0  4383      1 18135          4302 (NOTLB)
Call Trace: [<c014fcac>] pipe_wait [kernel] 0x8c
[<c014fd94>] pipe_read [kernel] 0xb4
[<c0145c06>] sys_read [kernel] 0x96
[<c014571e>] filp_close [kernel] 0x9e
[<c01073c3>] system_call [kernel] 0x33

java          S 00000202     0 11112   1494         11113  1705 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c0156b46>] do_pollfd [kernel] 0x106
[<c0156b7e>] do_pollfd [kernel] 0x13e
[<c0156dd1>] sys_poll [kernel] 0x231
[<c01073c3>] system_call [kernel] 0x33

java          S 00000000     0 11113   1494         11114 11112 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000001     0 11114   1494         11116 11113 (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

java          S 00000800     0 11116   1494               11114 (NOTLB)
Call Trace: [<c0145c7e>] sys_read [kernel] 0x10e
[<c010649b>] sys_rt_sigsuspend [kernel] 0x10b
[<c01073c3>] system_call [kernel] 0x33

play          S F1357B40     0 11714   1992 11989               (NOTLB)
Call Trace: [<c011fe18>] sys_wait4 [kernel] 0x3c8
[<c0145840>] generic_file_llseek [kernel] 0x0
[<c01073c3>] system_call [kernel] 0x33

lk_log        S F3CE5C00     0 11987  11714         11988       (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<f88d47a1>] ext3_reserve_inode_write [ext3] 0x31
[<c021d505>] unix_stream_data_wait [kernel] 0xd5
[<f88d4735>] ext3_mark_iloc_dirty [ext3] 0x25
[<c021d700>] unix_stream_recvmsg [kernel] 0x1b0
[<c01d67c1>] sock_recvmsg [kernel] 0x31
[<c0133df6>] generic_file_write [kernel] 0x566
[<c01d68d8>] sock_read [kernel] 0x88
[<c0145c06>] sys_read [kernel] 0x96
[<c0125014>] run_local_timers [kernel] 0x94
[<c0114228>] smp_apic_timer_interrupt [kernel] 0xb8
[<c01073c3>] system_call [kernel] 0x33

hostResponse. D 00000001     0 11988  11714         11989 11987 (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<c01852c1>] add_timer_randomness [kernel] 0xd1
[<c014a5d1>] sync_page_buffers [kernel] 0x31
[<c014a75c>] try_to_free_buffers [kernel] 0x15c
[<c014890a>] try_to_release_page [kernel] 0x3a
[<c013a89e>] page_launder_zone [kernel] 0x54e
[<c012c612>] do_wp_page [kernel] 0x172
[<c013b239>] page_launder [kernel] 0x339
[<c0119735>] schedule [kernel] 0x385
[<c013c8b2>] do_try_to_free_pages [kernel] 0x12
[<c013ce05>] try_to_free_pages [kernel] 0x35
[<c013dbb1>] _wrapped_alloc_pages [kernel] 0x1d1
[<c013dc9f>] __alloc_pages [kernel] 0xf
[<c013dd40>] __get_free_pages [kernel] 0x10
[<c011acdc>] mm_init [kernel] 0x8c
[<c011aedd>] copy_mm [kernel] 0xbd
[<c011ba3b>] do_fork [kernel] 0x4ab
[<c0105c05>] sys_fork [kernel] 0x15
[<c01073c3>] system_call [kernel] 0x33

monitorHier.s S E1B5FE00     0 11989  11714 17891         11988 (NOTLB)
Call Trace: [<c011fe18>] sys_wait4 [kernel] 0x3c8
[<c01073c3>] system_call [kernel] 0x33

sshd          S F0B3BEC0  4660 12506   1056 12656               (NOTLB)
Call Trace: [<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c0145d9e>] sys_write [kernel] 0x10e
[<c01073c3>] system_call [kernel] 0x33

bash          S 000031E6     0 12656  12506 12774               (NOTLB)
Call Trace: [<c011fe18>] sys_wait4 [kernel] 0x3c8
[<c01073c3>] system_call [kernel] 0x33

tail          S 00000000     0 12774  12656                     (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

kslideshow.ks S C01561D1     0 14274   1966                     (NOTLB)
Call Trace: [<c01561d1>] __pollwait [kernel] 0x31
[<c0125284>] schedule_timeout [kernel] 0x14
[<c01d6bef>] sock_poll [kernel] 0x1f
[<c015654e>] do_select [kernel] 0x20e
[<c01568f9>] sys_select [kernel] 0x339
[<c0145c7e>] sys_read [kernel] 0x10e
[<c01073c3>] system_call [kernel] 0x33

sleep         S 00000001     8 17891  11989                     (NOTLB)
Call Trace: [<c01252f4>] schedule_timeout [kernel] 0x84
[<c0125260>] process_timeout [kernel] 0x0
[<c012543b>] sys_nanosleep [kernel] 0x11b
[<c01073c3>] system_call [kernel] 0x33

diff          D C139EF80     0 18105   3181                     (NOTLB)
Call Trace: [<c0130ca1>] __lock_page [kernel] 0x91
[<c0131696>] do_generic_file_read [kernel] 0x336
[<f8870c37>] qla2x00_process_response_queue [qla2300] 0x87
[<f8870b17>] qla2x00_isr [qla2300] 0x8c7
[<f8804f7f>] scsi_delete_timer_Rsmp_c6cde1f3 [scsi_mod] 0xf
[<c0131b77>] generic_file_new_read [kernel] 0x67
[<c01319f0>] file_read_actor [kernel] 0x0
[<c0131b0b>] generic_file_read [kernel] 0x1b
[<c0145c06>] sys_read [kernel] 0x96
[<c0119735>] schedule [kernel] 0x385
[<c01073c3>] system_call [kernel] 0x33

cp            D F7F3FE00     0 18117   3718                     (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<f88c10c6>] journal_flushpage_Rsmp_b574e15a [jbd] 0xa6
[<f88d2db2>] ext3_flushpage [ext3] 0x22
[<c012fe79>] do_flushpage [kernel] 0x19
[<c012fea4>] truncate_complete_page [kernel] 0x14
[<c0130089>] truncate_list_pages [kernel] 0x1b9
[<f88bff4f>] journal_get_write_access_Rsmp_d105b7ee [jbd] 0x3f
[<c013018e>] truncate_inode_pages [kernel] 0x5e
[<c012c9f4>] vmtruncate [kernel] 0xb4
[<c015d166>] inode_setattr [kernel] 0x26
[<f88d464a>] ext3_setattr [ext3] 0x21a
[<c0151783>] path_walk [kernel] 0x8c3
[<c015d311>] notify_change [kernel] 0x81
[<c014428d>] do_truncate [kernel] 0x6d
[<c01523e4>] open_namei [kernel] 0x4d4
[<c01453a3>] dentry_open [kernel] 0xc3
[<c01452b6>] filp_open [kernel] 0x36
[<c015096e>] getname [kernel] 0x5e
[<c01455b6>] sys_open [kernel] 0x36
[<c01073c3>] system_call [kernel] 0x33

diff          D 00000010     0 18135   4383                     (NOTLB)
Call Trace: [<c0146dd6>] __wait_on_buffer [kernel] 0x76
[<f88d5067>] ext3_find_entry [ext3] 0x157
[<c015c5a0>] get_new_inode [kernel] 0x110
[<c015c849>] iget4 [kernel] 0xe9
[<f88bfeed>] do_get_write_access [jbd] 0x66d
[<f88d5289>] ext3_lookup [ext3] 0x29
[<c015a4e9>] d_alloc [kernel] 0x19
[<c0150ce3>] real_lookup [kernel] 0x73
[<c01515d8>] path_walk [kernel] 0x718
[<c012d596>] handle_mm_fault [kernel] 0x96
[<f88d4909>] ext3_dirty_inode [ext3] 0xa9
[<c0151d4a>] __user_walk [kernel] 0x3a
[<c014de74>] vfs_stat [kernel] 0x14
[<c014e411>] sys_stat64 [kernel] 0x11
[<c014571e>] filp_close [kernel] 0x9e
[<c0117f80>] do_page_fault [kernel] 0x0
[<c01074c0>] error_code [kernel] 0x38
[<c01073c3>] system_call [kernel] 0x33

 Yanling Qi
 Software Engineer
 9020-I Capital of TX Hwy, Ste150
 Austin, TX 78759
 512-794-3713 phone
 512-794-3702 fax
 yanling.qi@lsil.com
 www.lsilogicstorage.com

 LSI Logic Storage Systems
 AT THE HEART OF INFORMATION
