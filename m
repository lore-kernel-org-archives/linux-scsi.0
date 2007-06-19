From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: strange queue_if_no_path behavior
Date: Tue, 19 Jun 2007 16:15:53 +0200
Message-ID: <181454722.20070619161553@netvision.net.il>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxout4.netvision.net.il ([194.90.9.27]:29391 "EHLO
	mxout4.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbXFSOIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 10:08:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dm-devel@redhat.com, malahal@us.ibm.com

Hi!
I have a question regarding queue_if_no_path behavior.
I tried Red Hat 5.0 2.6.18-8.el5 kernel and more or less recent multipath-tools.
Set no_path_retry queue in multipath.conf and tried losing all paths
to a SAN device, while I'm dd-ing from /dev/zero to /dev/mapper/...

What's strange is that not only ios to that device got blocked, but
also ios to /tmp and /var/log/messages etc that reside on local drive.
When I return some paths to the SAN device, all ios resume, both ios
to that device and those unexpectedly blocked.

Please tell me if this is an expected behavior and if not, how could
we find a source of the problem and fix it?

# ps aux | grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      2872  0.0  0.0  10064   748 ?        Ds   21:58   0:00 syslogd -m 0
root      3800 24.9  0.0  63300  1592 ttyS0    D    22:01   0:22 dd if
/dev/zero of /dev/mapper/...
root      3990  0.0  0.0  58020   476 ttyS0    D    22:02   0:00 tail -f /var/log/messages

Thanks much,

Maxim.

Please see below sysrq output.
Sometimes (maybe it depends if root is on lvm or not) it tells
BUG: soft lockup detected on CPU#3!
BUG: soft lockup detected on CPU#0!
BUG: soft lockup detected on CPU#1!
BUG: soft lockup detected on CPU#2!

But I always see
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff80060d55>] io_schedule_timeout+0x4b/0x79
 [<ffffffff8003a9c4>] blk_congestion_wait+0x66/0x80
 for all processes in D state.

 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

aio/2         S ffff81007f569e70     0   255     35           256   254 (L-TLB)
 ffff81007f569e70 0000000000000000 0000000000000000 0000000000000001
 ffff810037e31040 ffff81007fd28080 00000018d1df692a 0000000000000aeb
 ffff810037e31228 ffffffff00000002 ffff810002c46478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

aio/3         S ffff81007f56be70     0   256     35           401   255 (L-TLB)
 ffff81007f56be70 0000000000000000 0000000000000000 0000000000000001
 ffff810037e327e0 ffff810037d1b100 00000018d28df153 0000000000000913
 ffff810037e329c8 ffffffff00000003 ffff810002c4e478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

kpsmoused     S ffff81007f585e70     0   401     35           449   256 (L-TLB)
 ffff81007f585e70 0000000000000000 0000000000000000 0000000000000008
 ffff810037fe3040 ffffffff802d1ae0 000000193a2fe27f 0000000000000f3e
 ffff810037fe3228 ffffffff00000000 ffff810002c36478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

ata/0         S ffff81007e913e70     0   449     35           450   401 (L-TLB)
 ffff81007e913e70 0000000000000000 0000000000000000 0000000000000003
 ffff81007fb38040 ffffffff802d1ae0 00000019779f7f7f 0000000000000a69
 ffff81007fb38228 ffff810000000000 ffff810002c36d58 fffffffffffffffb
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

ata/1         S ffff81007e915e70     0   450     35           451   449 (L-TLB)
 ffff81007e915e70 ffff810002c36400 ffff81007fb3d860 0000000000000003
 ffff810037e0e0c0 ffff81007fd19100 00000019779fdb63 0000000000001352
 ffff810037e0e2a8 ffff810000000001 ffff810002c3e478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

ata/2         S ffff81007e917e70     0   451     35           452   450 (L-TLB)
 ffff81007e917e70 0000000000000000 0000000000000000 0000000000000003
 ffff810037e257a0 ffff810037e1b0c0 0000001977a0315f 000000000000091d
 ffff810037e25988 0000000000000002 ffff810002c46d58 ffff810002c46400
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff800862c5>] task_rq_lock+0x3d/0x6f
 [<ffffffff80028850>] do_sigaction+0x153/0x19e
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

ata/3         S ffff81007e91be70     0   452     35           453   451 (L-TLB)
 ffff81007e91be70 0000000000000000 0000000000000000 0000000000000002
 ffff810037e297a0 ffff810037d1b100 0000001977a0886d 0000000000001079
 ffff810037e29988 ffff810000000003 ffff810002c4e478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

ata_aux       S ffff81007e91de70     0   453     35           459   452 (L-TLB)
 ffff81007e91de70 0000000000000000 0000000000000000 0000000000000003
 ffff810037e28100 ffffffff802d1ae0 0000001977a0dbe5 00000000000006c8
 ffff810037e282e8 ffff810000000000 ffff810002c36478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_eh_0     S ffff81007e887e70     0   459     35           485   453 (L-TLB)
 ffff81007e887e70 ffff81007e887df0 ffffffff8009b66f 000000000000000a
 ffff810037e24100 ffffffff802d1ae0 00000019b8a89c23 00000000002d6d91
 ffff810037e242e8 0000000000000000 0000000000000003 ffffffffffffffff
Call Trace:
 [<ffffffff8009b66f>] autoremove_wake_function+0x9/0x2e
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8807783a>] :scsi_mod:scsi_error_handler+0x6e/0xa81
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_eh_1     S ffff81007e955e70     0   485     35           486   459 (L-TLB)
 ffff81007e955e70 0000000000000000 0000000000000000 0000000000000004
 ffff81007f8d4820 ffffffff802d1ae0 00000019c7b8476e 0000000000000ae6
 ffff81007f8d4a08 ffff810000000000 ffff810002c36478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8807783a>] :scsi_mod:scsi_error_handler+0x6e/0xa81
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

lpfc_worker_0 S ffff81007ea5be50     0   486     35           487   485 (L-TLB)
 ffff81007ea5be50 ffff81007e98c9f8 00000000ffffffff 000000000000000a
 ffff810037fe00c0 ffff810037d1b100 0000001bd00605f7 0000000000000fa2
 ffff810037fe02a8 ffff810000000003 ffff810037d1b100 ffffffffffffffff
Call Trace:
 [<ffffffff881372cb>] :lpfc:lpfc_do_work+0xd0/0x933
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff881371fb>] :lpfc:lpfc_do_work+0x0/0x933
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_wq_1     S ffff81007ea5fe70     0   487     35           488   486 (L-TLB)
 ffff81007ea5fe70 0000000000000000 0000000000000000 0000000000000003
 ffff81007f8d40c0 ffffffff802d1ae0 00000019c7fcf37d 0000000000000c98
 ffff81007f8d42a8 ffff810000000000 ffff810002c36478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_wq_1       S ffff81007ea61e70     0   488     35           489   487 (L-TLB)
 ffff81007ea61e70 0000000000000000 0000000000000000 0000000000000002
 ffff810037e2d860 ffff81007fd28080 00000019c7fe0f7c 0000000000000b45
 ffff810037e2da48 ffff810000000002 ffff810002c46d58 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_dl_1       S ffff81007ea83e70     0   489     35           490   488 (L-TLB)
 ffff81007ea83e70 0000000000000000 0000000000000000 0000000000000001
 ffff810037e1b0c0 ffffffff802d1ae0 00000019c7fe7a5b 0000000000000909
 ffff810037e1b2a8 ffff810000000000 ffff810002c36478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_eh_2     S ffff81007f777e70     0   490     35           491   489 (L-TLB)
 ffff81007f777e70 0000000000000000 0000000000000000 0000000000000008
 ffff81007fb37080 ffff81007fd28080 0000001e24415670 00000000000009ab
 ffff81007fb37268 ffff810000000002 ffff810002c46d58 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8807783a>] :scsi_mod:scsi_error_handler+0x6e/0xa81
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

lpfc_worker_1 S ffff81007eac3e50     0   491     35           492   490 (L-TLB)
 ffff81007eac3e50 ffff81007ea3c9f8 00000000ffffffff 000000000000000a
 ffff810037e24860 ffff810037d1b100 000000202c9e1a7a 0000000000000f26
 ffff810037e24a48 ffff810000000003 ffff810037d1b100 ffffffffffffffff
Call Trace:
 [<ffffffff881372cb>] :lpfc:lpfc_do_work+0xd0/0x933
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff881371fb>] :lpfc:lpfc_do_work+0x0/0x933
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_wq_2     S ffff81007eac7e70     0   492     35           493   491 (L-TLB)
 ffff81007eac7e70 0000000000000000 0000000000000000 0000000000000008
 ffff81007fb36820 ffff81007fd28080 0000001e24874a7f 0000000000000b08
 ffff81007fb36a08 ffff810000000002 ffff810002c46d58 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_wq_2       S ffff81007ead3e70     0   493     35           494   492 (L-TLB)
 ffff81007ead3e70 0000000000000000 0000000000000000 0000000000000007
 ffff81007fb3d100 ffffffff802d1ae0 0000001e24884fb0 0000000000000977
 ffff81007fb3d2e8 ffff810000000000 ffff810002c36478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_dl_2       S ffff81007ead5e70     0   494     35           505   493 (L-TLB)
 ffff81007ead5e70 0000000000000000 0000000000000000 0000000000000007
 ffff81007fb307e0 ffff81007fd28080 0000001e2488b9e7 00000000000008ca
 ffff81007fb309c8 ffff810000000002 ffff810002c46d58 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

kmirrord      S ffff81007eb01e70     0   505     35           516   494 (L-TLB)
 ffff81007eb01e70 0000000000000000 0000000000000000 0000000000000007
 ffff81007eda87a0 ffffffff802d1ae0 00000022813be73b 0000000000001d65
 ffff81007eda8988 ffff810000000000 ffff810002c36478 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

ksnapd        S ffff81007eb17e70     0   516     35           519   505 (L-TLB)
 ffff81007eb17e70 0000000000000000 0000000000000000 0000000000000005
 ffff81007eda30c0 ffffffff802d1ae0 0000002281893b3f 000000000000191e
 ffff81007eda32a8 ffff810000000000 ffff810002c36d58 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

kjournald     S ffff81007eda5e70     0   519     35           542   516 (L-TLB)
 ffff81007eda5e70 ffff81007c2ee8b0 ffff81007e11894c 000000000000000a
 ffff810037e2d100 ffff81007fbe5080 0000006b6211b763 00000000000043ae
 ffff810037e2d2e8 0000000000000003 0000000037d1b100 00000f6400000000
Call Trace:
 [<ffffffff880384df>] :jbd:kjournald+0x192/0x213
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8803834d>] :jbd:kjournald+0x0/0x213
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

kauditd       S ffff81007dd3fea0     0   542     35          1230   519 (L-TLB)
 ffff81007dd3fea0 0000000000000001 0000000000000000 000000000000000a
 ffff81007eefd040 ffff81007fd28080 00000044c1f7d832 000000000000223f
 ffff81007eefd228 0000000000000002 0000000000000001 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff800ae37e>] kauditd_thread+0x0/0x12f
 [<ffffffff800ae489>] kauditd_thread+0x10b/0x12f
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

udevd         S ffff81007e009a18     0   571      1         15287    35 (NOTLB)
 ffff81007e009a18 ffff81007e009a48 00000001800857f7 0000000000000001
 ffff810037fee0c0 ffff810037d1b100 0000002e0315cae5 000000000001122b
 ffff810037fee2a8 0000000000000003 ffff81007c58e040 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80061622>] mutex_lock+0xd/0x1d
 [<ffffffff800e6418>] inotify_poll+0x49/0x50
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
Jun 19 13:58:49 multipath last message repeated 3 times
 [<ffffffff8000a778>] get_page_from_freelist+0x35d/0x3cf
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff8000ce95>] dput+0x2c/0x113
 [<ffffffff8001908f>] __follow_mount+0x26/0x7f
 [<ffffffff8000c99a>] do_lookup+0x65/0x1c3
 [<ffffffff8002c649>] mntput_no_expire+0x19/0x89
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8000d3f9>] permission+0x8d/0xc8
 [<ffffffff8004b12a>] shrink_dcache_parent+0x2e/0xe1
 [<ffffffff80015f5e>] sys_select+0xc1/0x17c
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b14e>] system_call+0x7e/0x83

kedac         S ffff81007cfe9e70     0  1230     35          1355   542 (L-TLB)
 ffff81007cfe9e70 ffffffffffffff10 0000000000000246 000000000000000a
 ffff81007d364080 ffff81007f8317a0 0000006b5bece0c2 00000000000017d5
 ffff81007d364268 0000000000000000 ffff810037fef7a0 00000000ffffffff
Call Trace:
 [<ffffffff8824294f>] :edac_mc:edac_kernel_thread+0x0/0xeb
 [<ffffffff8003d058>] lock_timer_base+0x1b/0x3c
 [<ffffffff8001c21e>] __mod_timer+0xb0/0xbe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8824294f>] :edac_mc:edac_kernel_thread+0x0/0xeb
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff88242a12>] :edac_mc:edac_kernel_thread+0xc3/0xeb
 [<ffffffff8824294f>] :edac_mc:edac_kernel_thread+0x0/0xeb
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_eh_3     S ffff81007bd83e70     0  1355     35          1468  1230 (L-TLB)
 ffff81007bd83e70 ffff810002c36400 ffff81007fb3d860 0000000000000004
 ffff81007bad97e0 ffff81007da2b040 000000242cb47e9b 00000000000006d0
 ffff81007bad99c8 0000000000000000 ffff810002c36478 ffff810002c36400
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8807783a>] :scsi_mod:scsi_error_handler+0x6e/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

qla2xxx_3_dpc S ffff81007b909eb0     0  1468     35          1469  1355 (L-TLB)
 ffff81007b909eb0 ffff81007be420c0 ffff810002c36478 000000000000000a
 ffff810037e197e0 ffff810037e30100 0000005f80d105ed 00000000000009f1
 ffff810037e199c8 0000000000000000 ffffffff802d1ae0 ffff81007b909e70
Call Trace:
 [<ffffffff800861f1>] set_load_weight+0x98/0xb2
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff8001140b>] set_user_nice+0x101/0x10d
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8827e2be>] :qla2xxx:qla2x00_do_dpc+0x0/0x441
 [<ffffffff8827e2f7>] :qla2xxx:qla2x00_do_dpc+0x39/0x441
 [<ffffffff8827e2be>] :qla2xxx:qla2x00_do_dpc+0x0/0x441
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_wq_3     S ffff81007bcdbe70     0  1469     35          1470  1468 (L-TLB)
 ffff81007bcdbe70 ffff810002c36400 ffff81007fb3d860 0000000000000005
 ffff81007c5e5860 ffff810037fee0c0 0000002440878462 0000000000000a78
 ffff81007c5e5a48 0000000000000002 ffff810002c46d58 ffff810002c46400
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff80028850>] do_sigaction+0x153/0x19e
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_wq_3       S ffff81007cb91e70     0  1470     35          1471  1469 (L-TLB)
 ffff81007cb91e70 ffff810002c36400 ffff81007fb3d860 0000000000000006
 ffff81007b6097e0 ffff81007da2b040 000000244088717a 00000000000008c1
 ffff81007b6099c8 0000000000000000 ffff810002c36478 ffff810002c36400
Call Trace:
 [<ffffffff801a6405>] transport_setup_classdev+0x0/0x1a
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff80028850>] do_sigaction+0x153/0x19e
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_dl_3       S ffff81007c6ede70     0  1471     35          1533  1470 (L-TLB)
 ffff81007c6ede70 ffff810002c36400 ffff81007fb3d860 0000000000000006
 ffff81007d6d0860 ffff81007da2b040 000000244088f001 00000000000007d1
 ffff81007d6d0a48 0000000000000000 ffff810002c36478 ffff810002c36400
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff80028850>] do_sigaction+0x153/0x19e
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_eh_4     S ffff81007df21e70     0  1533     35          1867  1471 (L-TLB)
 ffff81007df21e70 ffff810002c36400 ffff81007fb3d860 0000000000000006
 ffff81007cd837e0 ffff81007da2b040 00000024437e73c2 00000000000007fe
 ffff81007cd839c8 0000000000000000 ffff810002c36478 ffff810002c36400
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8807783a>] :scsi_mod:scsi_error_handler+0x6e/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

qla2xxx_4_dpc S ffff81007f803eb0     0  1867     35          1868  1533 (L-TLB)
 ffff81007f803eb0 ffff81007d83aac0 ffff810002c36478 000000000000000a
 ffff81007c14f040 ffff810002fbb860 0000005f915aa81f 0000000000000899
 ffff81007c14f228 0000000000000000 ffffffff802d1ae0 ffff81007f803e70
Call Trace:
 [<ffffffff800861f1>] set_load_weight+0x98/0xb2
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff8001140b>] set_user_nice+0x101/0x10d
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8827e2be>] :qla2xxx:qla2x00_do_dpc+0x0/0x441
 [<ffffffff8827e2f7>] :qla2xxx:qla2x00_do_dpc+0x39/0x441
 [<ffffffff8827e2be>] :qla2xxx:qla2x00_do_dpc+0x0/0x441
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_wq_4     S ffff81007d815e70     0  1868     35          1869  1867 (L-TLB)
 ffff81007d815e70 ffff810002c36400 ffff81007fb3d860 0000000000000008
 ffff81007c44b7e0 ffff81007da2b040 000000245103150a 0000000000000bf6
 ffff81007c44b9c8 0000000000000000 ffff810002c36d58 ffff810002c36400
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff80028850>] do_sigaction+0x153/0x19e
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_wq_4       S ffff81007cccde70     0  1869     35          1870  1868 (L-TLB)
 ffff81007cccde70 ffff810002c36400 ffff81007fb3d860 0000000000000008
 ffff81007b9b57e0 ffff81007da2b040 000000245103f917 00000000000007ef
 ffff81007b9b59c8 0000000000000000 ffff810002c36d58 ffff810002c36400
Call Trace:
 [<ffffffff801a6405>] transport_setup_classdev+0x0/0x1a
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff80028850>] do_sigaction+0x153/0x19e
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_dl_4       S ffff81007cd81e70     0  1870     35          1912  1869 (L-TLB)
 ffff81007cd81e70 ffff810002c36400 ffff81007fb3d860 0000000000000008
 ffff81007c30a080 ffff81007da2b040 0000002451048016 0000000000000805
 ffff81007c30a268 0000000000000000 ffff810002c36d58 ffff810002c36400
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff80028850>] do_sigaction+0x153/0x19e
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_eh_5     S ffff81007b7c1e70     0  1912     35          7894  1870 (L-TLB)
 ffff81007b7c1e70 ffff810002c36400 ffff81007fb3d860 0000000000000008
 ffff81007bd1c040 ffff81007da2b040 0000002453e8c8ae 0000000000000de1
 ffff81007bd1c228 0000000000000000 ffff810002c36478 ffff810002c36400
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8807783a>] :scsi_mod:scsi_error_handler+0x6e/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

qla2xxx_5_dpc S ffff81007ccb9eb0     0  7894     35          7895  1912 (L-TLB)
 ffff81007ccb9eb0 ffff81007ccb9df0 ffff000000034000 000000000000000a
 ffff81007b450820 ffff81007fd1c7a0 0000006929aa1a10 00000000223c9457
 ffff81007b450a08 ffff810000000002 ffff81007b8844f8 00000000040000a0
Call Trace:
 [<ffffffff88280081>] :qla2xxx:qla2xxx_eh_device_reset+0xca/0x205
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8827e2be>] :qla2xxx:qla2x00_do_dpc+0x0/0x441
 [<ffffffff8827e2f7>] :qla2xxx:qla2x00_do_dpc+0x39/0x441
 [<ffffffff8827e2be>] :qla2xxx:qla2x00_do_dpc+0x0/0x441
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_wq_5     S ffff81007b429e70     0  7895     35          7896  7894 (L-TLB)
 ffff81007b429e70 0000000000000000 ffff81007b884000 000000000000000a
 ffff81007c83d860 ffff81007cf950c0 00000025c75d044f 0000000000046623
 ffff81007c83da48 0000000000000000 0000000000000003 ffff81007b429e30
Call Trace:
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff880f981e>] :scsi_transport_fc:fc_scsi_scan_rport+0x0/0x75
 [<ffffffff8004b2da>] run_workqueue+0xba/0xe5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_wq_5       S ffff81007c3abe70     0  7896     35          7897  7895 (L-TLB)
 ffff81007c3abe70 0000000000000000 0000000000000000 000000000000000a
 ffff81007bcd60c0 ffff81007fd28080 00000069d79bc2da 0000000000000e51
 ffff81007bcd62a8 0000000000000002 0000000000000003 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_dl_5       S ffff81007cff7e70     0  7897     35          7964  7896 (L-TLB)
 ffff81007cff7e70 0000000000000000 0000000000000001 000000000000000a
 ffff81007c773080 ffffffff802d1ae0 00000069d79bb769 000000000053e7df
 ffff81007c773268 0000000000000000 0000000000000003 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_eh_6     S ffff81007bcf1e70     0  7964     35          8228  7897 (L-TLB)
 ffff81007bcf1e70 ffff810002c46400 ffff81007fb3d860 0000000000000009
 ffff81007f831040 ffff81007da2b040 000000254ddad728 0000000000000b31
 ffff81007f831228 0000000000000002 ffff810002c46478 ffff810002c46400
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8807783a>] :scsi_mod:scsi_error_handler+0x6e/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff880777cc>] :scsi_mod:scsi_error_handler+0x0/0xa81
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

qla2xxx_6_dpc S ffff81007cfa5eb0     0  8228     35          8229  7964 (L-TLB)
 ffff81007cfa5eb0 ffff81007cfa5df0 ffff000000034000 000000000000000a
 ffff81007fac67a0 ffff81007fd19100 0000006882f2ebb9 0000000000003434
 ffff81007fac6988 ffff810000000001 ffff81007c0d44f8 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8827e2be>] :qla2xxx:qla2x00_do_dpc+0x0/0x441
 [<ffffffff8827e2f7>] :qla2xxx:qla2x00_do_dpc+0x39/0x441
 [<ffffffff8827e2be>] :qla2xxx:qla2x00_do_dpc+0x0/0x441
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

scsi_wq_6     S ffff81007bf67e70     0  8229     35          8230  8228 (L-TLB)
 ffff81007bf67e70 ffff810002c46400 ffff81007c0d4000 000000000000000a
 ffff81007c548860 ffff81007b699860 00000025e6af7703 00000000000388d2
 ffff81007c548a48 0000000000000000 0000000000000003 ffff81007bf67e30
Call Trace:
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff880f981e>] :scsi_transport_fc:fc_scsi_scan_rport+0x0/0x75
 [<ffffffff8004b2da>] run_workqueue+0xba/0xe5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_wq_6       S ffff81007c273e70     0  8230     35          8231  8229 (L-TLB)
 ffff81007c273e70 ffff810002c46400 ffff81007fb3d860 000000000000000a
 ffff81007ddcd860 ffff81007fd28080 00000069e4d839d6 0000000000000b36
 ffff81007ddcda48 0000000000000002 0000000000000003 fffffffffffffffe
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

fc_dl_6       S ffff81007ccb5e70     0  8231     35         14768  8230 (L-TLB)
 ffff81007ccb5e70 0000000000000000 0000000000000001 000000000000000a
 ffff81007cefe820 ffff81007ddcd860 00000069e4d82ea0 0000000000005aef
 ffff81007cefea08 0000000000000002 0000000000000003 ffff81007ccb5e30
Call Trace:
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff880faf34>] :scsi_transport_fc:fc_timeout_deleted_rport+0x0/0x21f
 [<ffffffff8004b2da>] run_workqueue+0xba/0xe5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

kmpathd/0     S ffff81007f7dfe70     0 14768     35         14769  8231 (L-TLB)
 ffff81007f7dfe70 0000000000000000 ffff81007e2a5ed8 000000000000000a
 ffff81007d577820 ffff81007fdb77e0 00000069e9d663d1 0000000000000711
 ffff81007d577a08 0000000000000000 0000000000000003 ffff81007f7dfe30
Call Trace:
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff88340247>] :dm_multipath:process_queued_ios+0x0/0x153
 [<ffffffff8004b2da>] run_workqueue+0xba/0xe5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

kmpathd/1     S ffff81007c875e70     0 14769     35         14770 14768 (L-TLB)
 ffff81007c875e70 0000000000000001 ffff81007e2a5dd8 000000000000000a
 ffff81007d720080 ffff81007fd19100 000000694205bc3f 00000000000005d6
 ffff81007d720268 0000000000000001 0000000000000003 ffffffffffffffff
Call Trace:
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

kmpathd/2     S ffff81007e135e70     0 14770     35         14771 14769 (L-TLB)
 ffff81007e135e70 0000000000000002 ffff81007c39e5d8 000000000000000a
 ffff81007c9b8040 ffff81007d6bb040 0000006964b2a432 0000000000000532
 ffff81007c9b8228 0000000000000002 0000000000000003 ffff81007e135e30
Call Trace:
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff88340247>] :dm_multipath:process_queued_ios+0x0/0x153
 [<ffffffff8004b2da>] run_workqueue+0xba/0xe5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

kmpathd/3     S ffff81007c031e70     0 14771     35         14827 14770 (L-TLB)
 ffff81007c031e70 ffff81007cb05ce8 ffffffff800850dd 000000000000000a
 ffff81007cc0c0c0 ffff81007fd2b0c0 0000006b6a380cb9 0000000000000862
 ffff81007cc0c2a8 0000000000000003 0000000000000003 ffff81007c031e30
Call Trace:
 [<ffffffff800850dd>] __wake_up_common+0x3e/0x68
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff8834023b>] :dm_multipath:trigger_event+0x0/0xc
 [<ffffffff8004b2da>] run_workqueue+0xba/0xe5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80047c13>] worker_thread+0x0/0x122
 [<ffffffff80047cd3>] worker_thread+0xc0/0x122
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

kjournald     S ffff81007f835e70     0 14827     35         16322 14771 (L-TLB)
 ffff81007f835e70 ffff81007f835db0 0000000000000086 0000000000000006
 ffff81007d6ec080 ffff81007fd28080 00000026df0b90a2 0000000000002c51
 ffff81007d6ec268 ffff810000000002 ffffffff8009b66f ffffffffffffffff
Call Trace:
 [<ffffffff8009b66f>] autoremove_wake_function+0x9/0x2e
 [<ffffffff880384df>] :jbd:kjournald+0x192/0x213
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8803834d>] :jbd:kjournald+0x0/0x213
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

dhclient      S ffff8100770c5a18     0 15287      1         15379   571 (NOTLB)
 ffff8100770c5a18 0000000000000031 0000000000000001 0000000000000004
 ffff81007bcb07a0 ffff810037d1b100 00000028581b62b9 0000000000008177
 ffff81007bcb0988 0000000000000003 ffff810037d1b100 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8000fd2b>] generic_file_buffered_write+0x666/0x6d8
 [<ffffffff80045495>] skb_dequeue+0x48/0x50
 [<ffffffff8003f052>] memcpy_toiovec+0x36/0x66
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff8000ee4e>] __alloc_pages+0x65/0x2b2
 [<ffffffff8002ac97>] flush_tlb_page+0xac/0xda
 [<ffffffff8003aa3e>] activate_page+0x60/0x8f
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80015ff0>] sys_select+0x153/0x17c
 [<ffffffff8005b14e>] system_call+0x7e/0x83

auditd        S ffff810076529a18     0 15379      1 15381   15380 15287 (NOTLB)
 ffff810076529a18 0000000000000005 0000000100000000 000000000000000a
 ffff81007bc44080 ffff81007fd28080 000000679cd18d2b 0000000000005516
 ffff81007bc44268 0000000000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff800127fd>] sock_def_readable+0x34/0x5f
 [<ffffffff800483a6>] unix_stream_sendmsg+0x25d/0x30e
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff800864bc>] __activate_task+0x27/0x39
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff800850dd>] __wake_up_common+0x3e/0x68
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff800d1068>] do_readv_writev+0x272/0x295
 [<ffffffff80015ff0>] sys_select+0x153/0x17c
 [<ffffffff8005b14e>] system_call+0x7e/0x83

auditd        S ffff81007652bd48     0 15380      1         15395 15379 (NOTLB)
 ffff81007652bd48 ffff81007ade0cf0 ffffffff8000dd98 0000000000000007
 ffff81007eda8040 ffffffff802d1ae0 00000044c1f9b75b 00000000000187b6
 ffff81007eda8228 0000000000000000 00000000000d7f88 ffffffffffffffff
Call Trace:
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8003d7be>] do_futex+0x1da/0xbc7
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800d089a>] sys_fstatfs+0x57/0x68
 [<ffffffff8009eb55>] sys_futex+0x101/0x123
 [<ffffffff8005b14e>] system_call+0x7e/0x83

python        S ffff81007652da18     0 15381  15379                     (NOTLB)
 ffff81007652da18 ffff81000000fc10 000280d200000000 0000000000000007
 ffff81007cc0c820 ffff81007fd28080 00000044c1f9af49 000000000001a57a
 ffff81007cc0ca08 0000000000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff88051ac0>] :ext3:add_dirent_to_buf+0x275/0x2b8
 [<ffffffff8000af70>] __find_get_block+0x15c/0x16c
 [<ffffffff8004886f>] unix_stream_recvmsg+0x418/0x54b
 [<ffffffff8000a778>] get_page_from_freelist+0x35d/0x3cf
 [<ffffffff80043a1c>] do_sock_read+0xc0/0xcb
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff8000c8f8>] do_sync_read+0xc7/0x104
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80015ff0>] sys_select+0x153/0x17c
 [<ffffffff8005b14e>] system_call+0x7e/0x83

syslogd       D ffff810075f779c8     0 15395      1         15398 15380 (NOTLB)
 ffff810075f779c8 ffff8100022c7750 ffff810002667068 0000000000000009
 ffff81007fbe5080 ffff810037d1b100 0000006b91ee3bd1 00000000000014f4
 ffff81007fbe5268 0000000000000003 ffff810037d1b100 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff80060d55>] io_schedule_timeout+0x4b/0x79
 [<ffffffff8003a9c4>] blk_congestion_wait+0x66/0x80
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8004ece5>] writeback_inodes+0xa8/0xd8
 [<ffffffff800bc61b>] balance_dirty_pages_ratelimited_nr+0x183/0x1fa
 [<ffffffff8000fc69>] generic_file_buffered_write+0x5a4/0x6d8
 [<ffffffff80030dd5>] skb_copy_datagram_iovec+0x4f/0x237
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff80251b9e>] unix_dgram_recvmsg+0x240/0x25e
 [<ffffffff80015d10>] __generic_file_aio_write_nolock+0x36d/0x3b8
 [<ffffffff800b9744>] __generic_file_write_nolock+0x8f/0xa8
 [<ffffffff800d8408>] core_sys_select+0x1f9/0x265
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80061622>] mutex_lock+0xd/0x1d
 [<ffffffff800b97a5>] generic_file_writev+0x48/0xa2
 [<ffffffff8001770b>] do_sync_write+0x0/0x104
 [<ffffffff800d0f6c>] do_readv_writev+0x176/0x295
 [<ffffffff8001770b>] do_sync_write+0x0/0x104
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff800d1115>] sys_writev+0x45/0x93
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

klogd         S ffff8100757e5be8     0 15398      1         15410 15395 (NOTLB)
 ffff8100757e5be8 ffff81007fbe5080 ffffffff80086480 000000000000000a
 ffff810037fe37a0 ffff81007c30a7e0 000000690912dbde 000000000003fc7a
 ffff810037fe3988 0000000000000000 ffffffff80044d16 fffffffffffffffe
Call Trace:
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff8005a534>] cache_alloc_refill+0x106/0x186
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80045be5>] prepare_to_wait_exclusive+0x38/0x61
 [<ffffffff80250e8f>] unix_wait_for_peer+0x90/0xac
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80251422>] unix_dgram_sendmsg+0x3de/0x4cf
 [<ffffffff80037264>] do_sock_write+0xc4/0xce
 [<ffffffff8004543e>] sock_aio_write+0x4f/0x5e
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff800177d2>] do_sync_write+0xc7/0x104
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80016134>] vfs_write+0xe1/0x174
 [<ffffffff800169b2>] sys_write+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

irqbalance    S ffff810074c05eb8     0 15410      1         15432 15398 (NOTLB)
 ffff810074c05eb8 ffff810074c05e58 ffff810074c05e58 0000000000000007
 ffff81007d6bb7a0 ffffffff802d1ae0 0000006b8b7abaa3 000000000007f864
 ffff81007d6bb988 ffff810000000000 ffff810002c384e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074031d48     0 15432      1         15436 15410 (NOTLB)
 ffff810074031d48 ffff810075f5c140 fffffffffffffff0 0000000000000001
 ffff81007dbd2080 ffff810037fe9080 000000290837b6b9 0000000000091d38
 ffff81007dbd2268 ffff810000000000 0000004400000000 ffff81000000fc10
Call Trace:
 [<ffffffff800baea2>] __rmqueue+0x4c/0xe1
 [<ffffffff80035295>] find_extend_vma+0x16/0x59
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8003d7be>] do_futex+0x1da/0xbc7
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800336bb>] wake_up_new_task+0x231/0x240
 [<ffffffff8009eb55>] sys_futex+0x101/0x123
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074063b68     0 15436      1         15456 15432 (NOTLB)
 ffff810074063b68 ffff81007fbe5080 ffffffff80086480 000000000000000a
 ffff81007fb2a7a0 ffffffff802d1ae0 00000069091b6af3 000000000000de22
 ffff81007fb2a988 0000000000000000 ffffffff80044d16 ffffffffffffffff
Call Trace:
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80045be5>] prepare_to_wait_exclusive+0x38/0x61
 [<ffffffff80250e8f>] unix_wait_for_peer+0x90/0xac
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80251422>] unix_dgram_sendmsg+0x3de/0x4cf
 [<ffffffff80052bee>] sock_sendmsg+0xf3/0x110
 [<ffffffff8000e5d0>] link_path_walk+0xd3/0xe5
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8000c172>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8002c649>] mntput_no_expire+0x19/0x89
 [<ffffffff8020079d>] sys_sendto+0x11c/0x14f
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff81007464beb8     0 15472      1         15473 15456 (NOTLB)
 ffff81007464beb8 ffff81007464be58 ffff81007464be58 0000000000000001
 ffff81007c2bd040 ffffffff802d1ae0 0000006b6a8a5c09 0000000000062de2
 ffff81007c2bd228 ffff810000000000 ffff810002c384e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074647cd8     0 15473      1         15475 15472 (NOTLB)
 ffff810074647cd8 0000000000000000 ffffffff800765f4 0000000000000001
 ffff810037fe9080 ffff81007fd19100 00000069653ee680 00000000000126da
 ffff810037fe9268 0000000000000001 0000004400000000 ffffffffffffffff
Call Trace:
 [<ffffffff800765f4>] physflat_send_IPI_allbutself+0x41/0x46
 [<ffffffff88164ffb>] :dm_mod:dev_wait+0x0/0x83
 [<ffffffff881622eb>] :dm_mod:dm_wait_event+0x92/0xb0
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff881645b3>] :dm_mod:find_device+0x7c/0x84
 [<ffffffff8816502e>] :dm_mod:dev_wait+0x33/0x83
 [<ffffffff881659d8>] :dm_mod:ctl_ioctl+0x20d/0x258
 [<ffffffff8003fc73>] do_ioctl+0x55/0x6b
 [<ffffffff8002fa45>] vfs_ioctl+0x248/0x261
 [<ffffffff8004a24b>] sys_ioctl+0x59/0x78
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff81007465fcd8     0 15475      1         15476 15473 (NOTLB)
 ffff81007465fcd8 0000000000000000 ffffffff800765f4 0000000000000001
 ffff81007bae97a0 ffff81007c9f17e0 00000029083cfff6 000000000003b5ff
 ffff81007bae9988 0000000000000000 0000004400000000 ffff81000000fc10
Call Trace:
 [<ffffffff800765f4>] physflat_send_IPI_allbutself+0x41/0x46
 [<ffffffff800728c3>] do_flush_tlb_all+0x0/0x6a
 [<ffffffff88164ffb>] :dm_mod:dev_wait+0x0/0x83
 [<ffffffff881622eb>] :dm_mod:dm_wait_event+0x92/0xb0
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff881645b3>] :dm_mod:find_device+0x7c/0x84
 [<ffffffff8816502e>] :dm_mod:dev_wait+0x33/0x83
 [<ffffffff881659d8>] :dm_mod:ctl_ioctl+0x20d/0x258
 [<ffffffff8003fc73>] do_ioctl+0x55/0x6b
 [<ffffffff8002fa45>] vfs_ioctl+0x248/0x261
 [<ffffffff8004a24b>] sys_ioctl+0x59/0x78
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff81007409beb8     0 15476      1         15477 15475 (NOTLB)
 ffff81007409beb8 ffff81007409be58 ffff81007409be58 0000000000000001
 ffff81007c9f17e0 ffff810037d1b100 0000006b6a8448b9 00000000000164ba
 ffff81007c9f19c8 ffff810000000003 ffff810002c504e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074085b58     0 15477      1         15478 15476 (NOTLB)
 ffff810074085b58 0000000000000000 0000000000000000 0000000000000001
 ffff81007bae9040 ffff81007c14f7a0 0000002dfbb7b3a5 0000000000002bd9
 ffff81007bae9228 0000000100000000 ffff81007fb32040 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80045be5>] prepare_to_wait_exclusive+0x38/0x61
 [<ffffffff80053232>] skb_recv_datagram+0x160/0x1e3
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff802519c8>] unix_dgram_recvmsg+0x6a/0x25e
 [<ffffffff800864bc>] __activate_task+0x27/0x39
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff8002fdc0>] sock_recvmsg+0x101/0x120
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff8003dd7f>] do_futex+0x79b/0xbc7
 [<ffffffff8004fed1>] unix_bind+0x23b/0x29b
 [<ffffffff8002b2c7>] sys_recvfrom+0xd4/0x137
 [<ffffffff80032e9b>] lock_sock+0xa7/0xb2
 [<ffffffff8003058f>] release_sock+0x13/0xaa
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff81007414bb38     0 15478      1         15479 15477 (NOTLB)
 ffff81007414bb38 ffff81007e6b2c70 ffff81007e6b2c70 0000000000000001
 ffff81007da2b040 ffffffff802d1ae0 0000006b5bdbbbea 0000000000002ab1
 ffff81007da2b228 0000000000000000 ffffffff802d1ae0 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8001910d>] __getblk+0x25/0x22c
 [<ffffffff880327af>] :jbd:journal_stop+0x1f3/0x1ff
 [<ffffffff8805586b>] :ext3:__ext3_journal_stop+0x1f/0x3d
 [<ffffffff8000ce95>] dput+0x2c/0x113
 [<ffffffff8004fed1>] unix_bind+0x23b/0x29b
 [<ffffffff80200919>] sys_bind+0x90/0xa6
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

multipathd    S ffff810074157d48     0 15479      1         15494 15478 (NOTLB)
 ffff810074157d48 0000000000000000 0000000000000000 0000000000000001
 ffff81007c14f7a0 ffff81007fb32040 0000002dfbb7ca33 000000000000168e
 ffff81007c14f988 0000000000000000 ffff81007bae9040 ffffffffffffffff
Call Trace:
 [<ffffffff80035295>] find_extend_vma+0x16/0x59
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8003d7be>] do_futex+0x1da/0xbc7
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009eb55>] sys_futex+0x101/0x123
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

portmap       S ffff8100740d5b38     0 15456      1         15472 15436 (NOTLB)
 ffff8100740d5b38 ffffffff80303080 ffffffff8002b43b 0000000000000001
 ffff81007c62c040 ffffffff802d1ae0 000000290d7b77a5 000000000000a5ed
 ffff81007c62c228 ffff810000000000 ffff810078b86980 ffffffffffffffff
Call Trace:
 [<ffffffff8002b43b>] local_bh_enable+0x90/0xa1
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff800132a4>] tcp_poll+0x1c/0x12f
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff8000a778>] get_page_from_freelist+0x35d/0x3cf
 [<ffffffff8000ee4e>] __alloc_pages+0x65/0x2b2
 [<ffffffff802001a1>] sys_sendmsg+0x217/0x28a
 [<ffffffff80032e9b>] lock_sock+0xa7/0xb2
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

rpc.statd     S ffff810074071a18     0 15494      1         15530 15479 (NOTLB)
 ffff810074071a18 0000000000000000 ffffffff8013b2ed 0000000000000001
 ffff810037e1b820 ffff81007fd28080 000000290d9441bb 0000000000004a20
 ffff810037e1ba08 ffff810000000002 ffffffff800857f7 ffffffffffffffff
Call Trace:
 [<ffffffff8013b2ed>] __next_cpu+0x19/0x28
 [<ffffffff800857f7>] find_busiest_group+0x20d/0x621
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff800132a4>] tcp_poll+0x1c/0x12f
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
Jun 19 13:58:52 multipath last message repeated 2 times
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800532cc>] skb_queue_tail+0x17/0x3e
 [<ffffffff800127d9>] sock_def_readable+0x10/0x5f
 [<ffffffff80251481>] unix_dgram_sendmsg+0x43d/0x4cf
 [<ffffffff80052bee>] sock_sendmsg+0xf3/0x110
 [<ffffffff8000e5d0>] link_path_walk+0xd3/0xe5
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff8000c172>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8002c649>] mntput_no_expire+0x19/0x89
 [<ffffffff8020079d>] sys_sendto+0x11c/0x14f
 [<ffffffff80015f5e>] sys_select+0xc1/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

rpc.idmapd    S ffff8100743a3e78     0 15530      1         15549 15494 (NOTLB)
 ffff8100743a3e78 ffff81007ed58e00 ffff81007d968ef8 0000000000000007
 ffff81007c450100 ffffffff802d1ae0 0000006b5bed5a08 00000000000054f1
 ffff81007c4502e8 0000000000000000 ffff81007f8317a0 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800e6a24>] sys_epoll_wait+0x184/0x3f9
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

dbus-daemon   S ffff810073c5db38     0 15549      1         15560 15530 (NOTLB)
 ffff810073c5db38 ffff810037e2b7e0 ffffffff80086480 000000000000000a
 ffff81007bcee860 ffff81007fd28080 0000002da77b724e 0000000000001152
 ffff81007bceea48 0000000000000002 ffff810037e2b7e0 ffffffffffffffff
Call Trace:
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
Jun 19 13:58:52 multipath last message repeated 7 times
 [<ffffffff80008ac9>] __handle_mm_fault+0x4e1/0xdf2
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

hcid          S ffff810073cbdb38     0 15560      1         15566 15549 (NOTLB)
 ffff810073cbdb38 ffff810037fe5c00 ffff810002c36400 0000000000000001
 ffff81007c032860 ffff81007fd28080 000000292cb77681 00000000000173e6
 ffff81007c032a48 0000000000000002 ffff81007c032860 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80052bee>] sock_sendmsg+0xf3/0x110
 [<ffffffff8000e5d0>] link_path_walk+0xd3/0xe5
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff80013040>] filemap_nopage+0x188/0x322
 [<ffffffff80008ac9>] __handle_mm_fault+0x4e1/0xdf2
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff883ef4e5>] :bluetooth:hci_get_dev_list+0xd8/0xee
 [<ffffffff801ffcf6>] sock_ioctl+0x1c1/0x1e5
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

sdpd          S ffff810073d259c8     0 15566      1         15595 15560 (NOTLB)
 ffff810073d259c8 0000000000000000 0000000000000000 0000000000000001
 ffff81007bb697a0 ffff81007fd19100 000000292f612393 0000000000009049
 ffff81007bb69988 0000000000000001 0000004400000000 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80045be5>] prepare_to_wait_exclusive+0x38/0x61
 [<ffffffff80250ea1>] unix_wait_for_peer+0xa2/0xac
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800532cc>] skb_queue_tail+0x17/0x3e
 [<ffffffff800127d9>] sock_def_readable+0x10/0x5f
 [<ffffffff80251481>] unix_dgram_sendmsg+0x43d/0x4cf
 [<ffffffff80052bee>] sock_sendmsg+0xf3/0x110
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff80008ac9>] __handle_mm_fault+0x4e1/0xdf2
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff800d8588>] sys_pselect7+0x114/0x210
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff800d86d8>] sys_pselect6+0x54/0x61
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

krfcommd      S ffff810073e83e40     0 15595      1         15636 15566 (L-TLB)
 ffff810073e83e40 0000000000000000 ffffffff8840c693 0000000000000005
 ffff810037e0e820 ffffffff802d1ae0 000000292f780474 0000000000003a08
 ffff810037e0ea08 ffff810000000000 ffffffff80032e9b ffffffffffffffff
Call Trace:
 [<ffffffff8840c693>] :l2cap:l2cap_sock_alloc+0x9a/0xa2
 [<ffffffff80032e9b>] lock_sock+0xa7/0xb2
 [<ffffffff88423f33>] :rfcomm:rfcomm_run+0x1a0/0x1207
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff88423d93>] :rfcomm:rfcomm_run+0x0/0x1207
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

pcscd         S ffff810073d3ba18     0 15636      1         15647 15595 (NOTLB)
 ffff810073d3ba18 ffff81000000fc10 000280d200000000 0000000000000007
 ffff81007cdf77a0 ffff81007f8317a0 0000002dff59d976 000000000001455c
 ffff81007cdf7988 0000000000000000 ffffffff802d1ae0 ffff81007cdf77a0
Call Trace:
 [<ffffffff8000ee4e>] __alloc_pages+0x65/0x2b2
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff88033e58>] :jbd:journal_dirty_metadata+0x1b5/0x1e3
 [<ffffffff8002c058>] dummy_inode_permission+0x0/0x3
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff80031c41>] blockable_page_cache_readahead+0x53/0xb2
 [<ffffffff8000b4b5>] touch_atime+0x67/0xaa
 [<ffffffff8000bf3c>] do_generic_mapping_read+0x3b6/0x3f8
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff8000a778>] get_page_from_freelist+0x35d/0x3cf
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff800baea2>] __rmqueue+0x4c/0xe1
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff800990b0>] attach_pid+0x8c/0xb9
 [<ffffffff8001f817>] copy_process+0x131e/0x155d
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff800864bc>] __activate_task+0x27/0x39
 [<ffffffff800336bb>] wake_up_new_task+0x231/0x240
 [<ffffffff80015f5e>] sys_select+0xc1/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

pcscd         S ffff810073835eb8     0 15647      1         15655 15636 (NOTLB)
 ffff810073835eb8 ffff810073835e58 ffff810073835e58 000000000000000a
 ffff81007edaf7e0 ffffffff802d1ae0 0000006b8c1ec72c 0000000000048565
 ffff81007edaf9c8 ffff810000000000 ffff810002c384e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

pcscd         S ffff810065661a18     0 16254      1         16256 16163 (NOTLB)
 ffff810065661a18 362e6f732e636269 0000000000000000 000000000000000a
 ffff81007f8317a0 ffff81007c450100 0000006b5bed0517 0000000000002455
 ffff81007f831988 0000000000000000 ffff81007d364080 ffffffffffffffff
Call Trace:
 [<ffffffff8003d058>] lock_timer_base+0x1b/0x3c
 [<ffffffff8001c21e>] __mod_timer+0xb0/0xbe
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff8020192e>] sock_alloc_send_skb+0x74/0x1d8
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff800850dd>] __wake_up_common+0x3e/0x68
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff800127fd>] sock_def_readable+0x34/0x5f
 [<ffffffff800483a6>] unix_stream_sendmsg+0x25d/0x30e
 [<ffffffff80037264>] do_sock_write+0xc4/0xce
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff8000c172>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff800177d2>] do_sync_write+0xc7/0x104
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8002fb50>] unix_poll+0x0/0x96
 [<ffffffff80015ff0>] sys_select+0x153/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

hidd          S ffff8100738bfad8     0 15655      1         15677 15647 (NOTLB)
 ffff8100738bfad8 0000000000000000 0000000100000000 0000000000000001
 ffff81007bf1c860 ffffffff802d1ae0 0000002944a673c9 000000000000ed16
 ffff81007bf1ca48 ffff810000000000 ffffffff8008630f ffffffffffffffff
Call Trace:
 [<ffffffff8008630f>] dequeue_task+0x18/0x37
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800532cc>] skb_queue_tail+0x17/0x3e
 [<ffffffff800127d9>] sock_def_readable+0x10/0x5f
 [<ffffffff80251481>] unix_dgram_sendmsg+0x43d/0x4cf
 [<ffffffff80052bee>] sock_sendmsg+0xf3/0x110
 [<ffffffff8000e5d0>] link_path_walk+0xd3/0xe5
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff80013040>] filemap_nopage+0x188/0x322
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff800d87d6>] sys_ppoll+0xf1/0x1f2
 [<ffffffff8005b261>] tracesys+0x71/0xdc
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

automount     S ffff81007394de58     0 15677      1         15678 15655 (NOTLB)
 ffff81007394de58 000055555c7ec580 00000000ffffffda 0000000000000001
 ffff81007d124080 ffff81007fd28080 000000295333db98 000000000000a142
 ffff81007d124268 0000000000000002 0000000000000000 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80094f7f>] dequeue_signal+0x3c/0xbc
 [<ffffffff80095629>] sys_rt_sigtimedwait+0x1ce/0x2b4
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8005b261>] tracesys+0x71/0xdc
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

automount     S ffff8100739c9d48     0 15678      1         15679 15677 (NOTLB)
 ffff8100739c9d48 ffffffff80060ab8 ffff8100739c9d58 0000000000000007
 ffff810037fe97e0 ffffffff802d1ae0 0000006b0a4d113d 00000000000077ad
 ffff810037fe99c8 0000000000000000 ffffffff802d1ae0 ffffffffffffffff
Call Trace:
 [<ffffffff80060ab8>] thread_return+0x0/0xea
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8003d7be>] do_futex+0x1da/0xbc7
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8002983a>] pipe_writev+0x448/0x4b0
 [<ffffffff8009eb55>] sys_futex+0x101/0x123
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

automount     S ffff8100739cbd48     0 15679      1         15682 15678 (NOTLB)
 ffff8100739cbd48 0000000000000000 0000000000000000 000000000000000a
 ffff81007c620040 ffff81007fd19100 0000006b5ca191a3 0000000000002864
 ffff81007c620228 0000000000000001 ffff81007fd19100 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8003d7be>] do_futex+0x1da/0xbc7
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800336bb>] wake_up_new_task+0x231/0x240
 [<ffffffff8013b2ed>] __next_cpu+0x19/0x28
 [<ffffffff8009eb55>] sys_futex+0x101/0x123
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

automount     S ffff810073a39b38     0 15682      1         15685 15679 (NOTLB)
 ffff810073a39b38 ffff8100739f0910 ffff8100738af9f8 000000000000000a
 ffff81007bfa17e0 ffff81007fd28080 0000006b0a51e54c 00000000000043ae
 ffff81007bfa19c8 0000000000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002d64e>] pipe_poll+0x2d/0x90
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800864bc>] __activate_task+0x27/0x39
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff800850dd>] __wake_up_common+0x3e/0x68
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff8003dd7f>] do_futex+0x79b/0xbc7
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff8002e79a>] pipe_readv+0x38e/0x3a2
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

automount     S ffff81007380fb38     0 15685      1         15696 15682 (NOTLB)
 ffff81007380fb38 ffff8100739f0790 ffff8100738afcf0 000000000000000a
 ffff81007c9b87a0 ffff81007c620040 0000005a4eece402 0000000000003ee7
 ffff81007c9b8988 0000000000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002d64e>] pipe_poll+0x2d/0x90
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800864bc>] __activate_task+0x27/0x39
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff800850dd>] __wake_up_common+0x3e/0x68
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff8003dd7f>] do_futex+0x79b/0xbc7
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff8002e79a>] pipe_readv+0x38e/0x3a2
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

acpid         S ffff810073a17b38     0 15696      1         15707 15685 (NOTLB)
 ffff810073a17b38 ffff810073a17ab8 ffff81007c6ad858 0000000000000007
 ffff81007c43f860 ffffffff802d1ae0 0000002e02d62d6a 000000000001e885
 ffff81007c43fa48 0000000000000000 0000000000000001 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff880327af>] :jbd:journal_stop+0x1f3/0x1ff
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff80015d10>] __generic_file_aio_write_nolock+0x36d/0x3b8
 [<ffffffff8002119c>] generic_file_aio_write+0x70/0xc1
 [<ffffffff8804c192>] :ext3:ext3_file_write+0x16/0x91
 [<ffffffff800177d2>] do_sync_write+0xc7/0x104
 [<ffffffff80202b12>] sock_getsockopt+0x30e/0x330
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80200cbd>] sys_accept+0x1a4/0x1ea
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

hpiod         S ffff810073463db8     0 15707      1         15712 15696 (NOTLB)
 ffff810073463db8 00000000ffffffff 0000000000000000 0000000000000001
 ffff81007cf8b0c0 ffffffff802d1ae0 000000295d54bab4 000000000000c62b
 ffff81007cf8b2a8 ffffffff00000000 0000000000000002 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80062639>] _spin_lock_bh+0x9/0x14
 [<ffffffff8003058f>] release_sock+0x13/0xaa
 [<ffffffff80229350>] inet_csk_accept+0xab/0x230
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8020043a>] sock_attach_fd+0x8f/0xfd
 [<ffffffff80239d96>] inet_accept+0x25/0xcb
 [<ffffffff80200c35>] sys_accept+0x11c/0x1ea
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

python        S ffff810072d35a18     0 15712      1         15724 15707 (NOTLB)
 ffff810072d35a18 0000000000001000 0000000000000001 0000000000000007
 ffff810002fbb100 ffff81007d6bb040 0000006a964d0334 00000000000138fe
 ffff810002fbb2e8 0000000000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff8003d058>] lock_timer_base+0x1b/0x3c
 [<ffffffff8001c21e>] __mod_timer+0xb0/0xbe
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8000fd2b>] generic_file_buffered_write+0x666/0x6d8
 [<ffffffff800baea2>] __rmqueue+0x4c/0xe1
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff8000ee4e>] __alloc_pages+0x65/0x2b2
 [<ffffffff8002ac97>] flush_tlb_page+0xac/0xda
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff80013288>] tcp_poll+0x0/0x12f
 [<ffffffff80015ff0>] sys_select+0x153/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

cupsd         S ffff810072a69a18     0 15724      1         15738 15712 (NOTLB)
 ffff810072a69a18 ffff810072a699b8 0000000000000001 0000000000000007
 ffff810037fe6820 ffff81007fd28080 00000029cc71b5d6 0000000000007661
 ffff810037fe6a08 ffff810000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002d64e>] pipe_poll+0x2d/0x90
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
Jun 19 13:58:52 multipath last message repeated 3 times
 [<ffffffff8000af70>] __find_get_block+0x15c/0x16c
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff80015d10>] __generic_file_aio_write_nolock+0x36d/0x3b8
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80094a79>] kill_proc_info+0x48/0x61
 [<ffffffff80015f5e>] sys_select+0xc1/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

sshd          S ffff810072d03a18     0 15738      1         15750 15724 (NOTLB)
 ffff810072d03a18 ffff81000000fc10 000280d200000001 0000000000000007
 ffff81007e4b5100 ffff810037d1b100 000000299544d1c4 00000000000471e9
 ffff81007e4b52e8 ffff810000000003 ffffffff8000af70 ffffffffffffffff
Call Trace:
 [<ffffffff8000af70>] __find_get_block+0x15c/0x16c
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff800132a4>] tcp_poll+0x1c/0x12f
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80013672>] __pagevec_lru_add+0xae/0xbe
 [<ffffffff8000fd2b>] generic_file_buffered_write+0x666/0x6d8
 [<ffffffff8000af70>] __find_get_block+0x15c/0x16c
 [<ffffffff88032cab>] :jbd:do_get_write_access+0x4f0/0x527
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff80015d10>] __generic_file_aio_write_nolock+0x36d/0x3b8
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff8000dee8>] free_pages_and_swap_cache+0x73/0x8f
 [<ffffffff80015f5e>] sys_select+0xc1/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

xinetd        S ffff8100734b7a18     0 15750      1         15770 15738 (NOTLB)
 ffff8100734b7a18 ffff81007e94b680 00000001734b7a98 0000000000000001
 ffff81007bd06100 ffff81007fd28080 00000029a060da88 00000000000a6521
 ffff81007bd062e8 ffff810000000002 ffffffff800857f7 ffffffffffffffff
Call Trace:
 [<ffffffff800857f7>] find_busiest_group+0x20d/0x621
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002d64e>] pipe_poll+0x2d/0x90
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8002dc9c>] __alloc_skb+0x77/0x123
 [<ffffffff8020192e>] sock_alloc_send_skb+0x74/0x1d8
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff80055623>] memcpy_fromiovec+0x36/0x66
 [<ffffffff800532cc>] skb_queue_tail+0x17/0x3e
 [<ffffffff800127d9>] sock_def_readable+0x10/0x5f
 [<ffffffff80251481>] unix_dgram_sendmsg+0x43d/0x4cf
 [<ffffffff80052bee>] sock_sendmsg+0xf3/0x110
 [<ffffffff8000e5d0>] link_path_walk+0xd3/0xe5
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff80015f5e>] sys_select+0xc1/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

sendmail      S ffff810072e99a18     0 15770      1         15778 15750 (NOTLB)
 ffff810072e99a18 ffff810072e99a48 ffffffff800857f7 0000000000000007
 ffff81007d7a0820 ffff810037d1b100 0000006b5a41439f 000000000001730f
 ffff81007d7a0a08 ffff810000000003 ffff810037d1b100 ffffffffffffffff
Call Trace:
 [<ffffffff800857f7>] find_busiest_group+0x20d/0x621
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800f3bb6>] proc_alloc_inode+0x40/0x66
 [<ffffffff8002521f>] alloc_inode+0xeb/0x192
 [<ffffffff80022d9a>] iget_locked+0xc5/0x149
 [<ffffffff8002cc08>] wake_up_bit+0x11/0x22
 [<ffffffff800e5fa7>] inotify_d_instantiate+0x46/0x70
 [<ffffffff8003a629>] d_instantiate+0x4a/0x82
 [<ffffffff8003fb1c>] d_rehash+0x21/0x34
 [<ffffffff8002723c>] proc_lookup+0x8d/0xcc
 [<ffffffff80053f87>] proc_root_lookup+0x12/0x30
 [<ffffffff8000c99a>] do_lookup+0x65/0x1c3
 [<ffffffff8000ce95>] dput+0x2c/0x113
 [<ffffffff8000a2d1>] __link_path_walk+0xdf8/0xf42
 [<ffffffff80019cc8>] vsnprintf+0x559/0x59e
 [<ffffffff800453ab>] sprintf+0x51/0x59
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff800f6e10>] loadavg_read_proc+0xae/0xda
 [<ffffffff8006278d>] lock_kernel+0x1b/0x32
 [<ffffffff800f3ae5>] de_put+0xe/0x63
 [<ffffffff80015ff0>] sys_select+0x153/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

sendmail      S ffff810072895f68     0 15778      1         15790 15770 (NOTLB)
 ffff810072895f68 0000000000010246 ffff810072895eb8 0000000000000001
 ffff81007c06b820 ffff81007fd28080 00000029a42976ad 000000000000b95f
 ffff81007c06ba08 0000000000000002 0000000000000000 ffffffffffffffff
Call Trace:
 [<ffffffff80039e64>] sys_pause+0x19/0x23
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

gpm           S ffff810072be1a18     0 15790      1         15807 15778 (NOTLB)
 ffff810072be1a18 ffff81000000fc31 000280d200000000 000000000000000a
 ffff81007cdc47a0 ffff81007fd19100 0000002e8effb8d2 0000000000001157
 ffff81007cdc4988 ffff810000000001 ffff81007fd19100 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80019cc8>] vsnprintf+0x559/0x59e
 [<ffffffff80019aaa>] vsnprintf+0x33b/0x59e
 [<ffffffff800453ab>] sprintf+0x51/0x59
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff80061622>] mutex_lock+0xd/0x1d
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff800850dd>] __wake_up_common+0x3e/0x68
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff800622b0>] __up_wakeup+0x35/0x67
 [<ffffffff801e9561>] mousedev_read+0x153/0x188
 [<ffffffff80015ff0>] sys_select+0x153/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

crond         S ffff810072f37eb8     0 15807      1         15848 15790 (NOTLB)
 ffff810072f37eb8 ffff810072f37e58 ffff810072f37e58 0000000000000007
 ffff81007bf3e080 ffff810037d1b100 0000006b0e6c0b6a 00000000000094b2
 ffff81007bf3e268 ffff810000000003 ffff810002c504e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

xfs           S ffff8100726e3a18     0 15848      1         15869 15807 (NOTLB)
 ffff8100726e3a18 ffff81000260fa60 0000000000000002 0000000000000008
 ffff81007e7e6080 ffff81007fd28080 0000002e8fda120b 0000000000001056
 ffff81007e7e6268 0000000000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff800127fd>] sock_def_readable+0x34/0x5f
 [<ffffffff800483a6>] unix_stream_sendmsg+0x25d/0x30e
 [<ffffffff80045495>] skb_dequeue+0x48/0x50
 [<ffffffff80037264>] do_sock_write+0xc4/0xce
 [<ffffffff80200fd7>] sock_writev+0xb7/0xd1
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff8000c8f8>] do_sync_read+0xc7/0x104
 [<ffffffff800d1068>] do_readv_writev+0x272/0x295
 [<ffffffff80015ff0>] sys_select+0x153/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

atd           S ffff810072543eb8     0 15869      1         15901 15848 (NOTLB)
 ffff810072543eb8 ffff810072543e58 ffff810072543e58 0000000000000001
 ffff81007c44b080 ffffffff802d1ae0 00000029b7f6365b 0000000000018fa1
 ffff81007c44b268 ffff810000000000 ffff810002c384e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

yum-updatesd  S ffff81006e913b38     0 15901      1         15913 15869 (NOTLB)
 ffff81006e913b38 000000017bcee860 00000000ffffffff 000000000000000a
 ffff81007e5427a0 ffff81007fd19100 0000006b9035388d 0000000000004664
 ffff81007e542988 0000000000000001 ffff81007fd19100 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80058bd5>] getnstimeofday+0x10/0x28
 [<ffffffff8009d61c>] ktime_get_ts+0x1a/0x4e
 [<ffffffff8003527f>] find_extend_vma+0x0/0x59
 [<ffffffff80035295>] find_extend_vma+0x16/0x59
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff8009df11>] futex_wake+0xc6/0xd5
 [<ffffffff8003d825>] do_futex+0x241/0xbc7
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff8002fb50>] unix_poll+0x0/0x96
 [<ffffffff8002fb50>] unix_poll+0x0/0x96
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

avahi-daemon  S ffff81006e137b38     0 15913      1 15914   15925 15901 (NOTLB)
 ffff81006e137b38 000005d000000000 ffff81006e137a58 000000000000000a
 ffff810037e2b7e0 ffffffff802d1ae0 0000006b545cfe94 0000000000004eb7
 ffff810037e2b9c8 0000000000000000 ffffffff802d1ae0 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
Jun 19 13:58:53 multipath last message repeated 8 times
 [<ffffffff8000dd98>] current_fs_time+0x3b/0x40
 [<ffffffff8002dd80>] __wake_up+0x38/0x4f
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

avahi-daemon  S ffff81006e9d9be8     0 15914  15913                     (NOTLB)
 ffff81006e9d9be8 0000000000000000 0000000000000001 0000000000000001
 ffff81007ba08820 ffff81007fd28080 0000002aa2d2d63b 0000000000001f60
 ffff81007ba08a08 ffff810000000002 0000000000000001 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff8003a2a7>] prepare_to_wait+0x34/0x5d
 [<ffffffff8004868b>] unix_stream_recvmsg+0x234/0x54b
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8002c649>] mntput_no_expire+0x19/0x89
 [<ffffffff80043a1c>] do_sock_read+0xc0/0xcb
 [<ffffffff801ffac6>] sock_aio_read+0x4f/0x5e
 [<ffffffff8000c8f8>] do_sync_read+0xc7/0x104
 [<ffffffff80011ce8>] may_open+0x58/0x21e
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80026f20>] do_filp_open+0x2a/0x38
 [<ffffffff8000c172>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8000b225>] vfs_read+0xde/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

hald          S ffff81006de43b38     0 15925      1 15926   16011 15913 (NOTLB)
 ffff81006de43b38 ffff81007bcee860 ffffffff80086480 000000000000000a
 ffff81007e4b5860 ffffffff802d1ae0 0000006993d8880b 000000000006690c
 ffff81007e4b5a48 0000000000000000 ffffffff802d1ae0 ffffffffffffffff
Call Trace:
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
Jun 19 13:58:53 multipath last message repeated 9 times
 [<ffffffff8002c649>] mntput_no_expire+0x19/0x89
 [<ffffffff800d6185>] sys_readlinkat+0x98/0xa9
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

hald-runner   S ffff81006de83b38     0 15926  15925 15932               (NOTLB)
 ffff81006de83b38 ffff81007e4b5860 ffffffff80086480 0000000000000008
 ffff81007d7de0c0 ffff81007fd19100 0000002d4df7b05c 000000000001e3b4
 ffff81007d7de2a8 0000000000000001 ffffffff80044d16 ffffffffffffffff
Call Trace:
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff80044d16>] try_to_wake_up+0x407/0x418
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800857f7>] find_busiest_group+0x20d/0x621
 [<ffffffff80037264>] do_sock_write+0xc4/0xce
 [<ffffffff80200fd7>] sock_writev+0xb7/0xd1
 [<ffffffff8002ac97>] flush_tlb_page+0xac/0xda
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80010a71>] do_wp_page+0x246/0x67d
 [<ffffffff80059701>] do_notify_resume+0x696/0x7a9
 [<ffffffff800d1068>] do_readv_writev+0x272/0x295
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

hald-addon-ac S ffff81006cfbbbe8     0 15932  15926         15937       (NOTLB)
 ffff81006cfbbbe8 0000000000001000 ffff81007e4dc9f8 0000000000000007
 ffff81007dc287a0 ffff810037d1b100 0000002aff99893d 00000000000614a6
 ffff81007dc28988 ffff810000000003 ffff81007c6ad6a8 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff8003a2a7>] prepare_to_wait+0x34/0x5d
 [<ffffffff8004868b>] unix_stream_recvmsg+0x234/0x54b
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80086480>] enqueue_task+0x41/0x56
 [<ffffffff80043a1c>] do_sock_read+0xc0/0xcb
 [<ffffffff801ffac6>] sock_aio_read+0x4f/0x5e
 [<ffffffff8000c8f8>] do_sync_read+0xc7/0x104
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8000dbf2>] do_mmap_pgoff+0x63a/0x7a5
 [<ffffffff8000b225>] vfs_read+0xde/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

hald-addon-ke S ffff8100698ebea8     0 15937  15926         15956 15932 (NOTLB)
 ffff8100698ebea8 00002aaaaaaac000 0000000000000018 0000000000000007
 ffff81007d7de820 ffff81007fd28080 0000002e1a40bda7 000000000000689a
 ffff81007d7dea08 0000000000000002 0000000000000008 ffffffffffffffff
Call Trace:
 [<ffffffff801ea526>] evdev_read+0x112/0x247
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8000b212>] vfs_read+0xcb/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

hald-addon-st S ffff810068a97eb8     0 15956  15926               15937 (NOTLB)
 ffff810068a97eb8 ffff810068a97e58 ffff810068a97e58 0000000000000009
 ffff81007d1247e0 ffff81007fd28080 0000006b931f2562 0000000000002bc8
 ffff81007d1249c8 ffff810000000002 ffff810002c484e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

modclusterd   S ffff810066e45b38     0 16011      1         16012 15925 (NOTLB)
 ffff810066e45b38 ffff810066e45ab8 ffff81007c6ad6d8 000000000000000a
 ffff81007c58e7a0 ffff81007fd19100 0000006b791100be 000000000000249f
 ffff81007c58e988 0000000000000001 ffff81007fd19100 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8000af70>] __find_get_block+0x15c/0x16c
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff8000ee4e>] __alloc_pages+0x65/0x2b2
 [<ffffffff800baea2>] __rmqueue+0x4c/0xe1
 [<ffffffff8003aa3e>] activate_page+0x60/0x8f
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff80013040>] filemap_nopage+0x188/0x322
 [<ffffffff80008ac9>] __handle_mm_fault+0x4e1/0xdf2
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

modclusterd   S ffff810065b4fb38     0 16012      1         16013 16011 (NOTLB)
 ffff810065b4fb38 ffff810065b4fac8 ffffffff80061552 000000000000000a
 ffff81007c0767a0 ffff81007fd19100 0000006b782c8aee 0000000000001b72
 ffff81007c076988 0000000000000001 ffff81007fd19100 ffffffffffffffff
Call Trace:
 [<ffffffff80061552>] __wait_on_bit+0x60/0x6f
 [<ffffffff8001c170>] __mod_timer+0x2/0xbe
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff8804da77>] :ext3:__ext3_get_inode_loc+0x12f/0x2e4
 [<ffffffff8003a629>] d_instantiate+0x4a/0x82
 [<ffffffff8003fb1c>] d_rehash+0x21/0x34
 [<ffffffff80030431>] d_splice_alias+0xf3/0xfb
 [<ffffffff8000948a>] __d_lookup+0xb0/0xff
 [<ffffffff8000c172>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff8002c649>] mntput_no_expire+0x19/0x89
 [<ffffffff8000a3f7>] __link_path_walk+0xf1e/0xf42
 [<ffffffff8002c649>] mntput_no_expire+0x19/0x89
 [<ffffffff8000e5d0>] link_path_walk+0xd3/0xe5
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff80023328>] __user_walk_fd+0x41/0x4c
 [<ffffffff80031e5d>] sys_faccessat+0xe4/0x18d
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

modclusterd   S ffff810066339b38     0 16013      1         16067 16012 (NOTLB)
 ffff810066339b38 000000000000000e 0013000100000264 000000000000000a
 ffff81007c30a7e0 ffff81007fd28080 0000006b79d6c4c8 0000000000001dd0
 ffff81007c30a9c8 0000000000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff8000a778>] get_page_from_freelist+0x35d/0x3cf
 [<ffffffff8003aa3e>] activate_page+0x60/0x8f
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff80013040>] filemap_nopage+0x188/0x322
 [<ffffffff80008ac9>] __handle_mm_fault+0x4e1/0xdf2
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff8013b2ed>] __next_cpu+0x19/0x28
 [<ffffffff80060675>] __sched_text_start+0x6d5/0xb18
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

oddjobd       S ffff810066341a18     0 16067      1         16098 16013 (NOTLB)
 ffff810066341a18 0000000000001000 0000000000000001 0000000000000001
 ffff81007bb69040 ffff81007bc447e0 0000002d637266ca 0000000000043f8a
 ffff81007bb69228 0000000000000001 ffffffff8000af70 ffff81007d8eb9d0
Call Trace:
 [<ffffffff8000af70>] __find_get_block+0x15c/0x16c
 [<ffffffff88032cab>] :jbd:do_get_write_access+0x4f0/0x527
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80013672>] __pagevec_lru_add+0xae/0xbe
 [<ffffffff8000fd2b>] generic_file_buffered_write+0x666/0x6d8
 [<ffffffff800bea3c>] zone_statistics+0x3e/0x6d
 [<ffffffff8000ee4e>] __alloc_pages+0x65/0x2b2
 [<ffffffff8002ac97>] flush_tlb_page+0xac/0xda
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff8000dee8>] free_pages_and_swap_cache+0x73/0x8f
 [<ffffffff80015f5e>] sys_select+0xc1/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

saslauthd     S ffff8100654cbea8     0 16098      1 16099   16110 16067 (NOTLB)
 ffff8100654cbea8 0000000000614130 ffff81007c9f27c0 0000000000000001
 ffff81007dc28040 ffff810037d1b100 0000002d6aa120eb 000000000000607e
 ffff81007dc28228 ffff810000000003 0000000000000246 ffffffffffffffff
Call Trace:
 [<ffffffff800394c3>] fcntl_setlk+0x1c5/0x25c
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8002e049>] sys_fcntl+0x269/0x2dc
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

saslauthd     S ffff81006551dd98     0 16099  16098         16100       (NOTLB)
 ffff81006551dd98 ffff81007d5770c0 ffff81006551dd68 0000000000000001
 ffff81007d5770c0 ffff81007dc28040 0000002d6a931193 0000000000023022
 ffff81007d5772a8 0000000000000003 000000000000006c 000000007fffffff
Call Trace:
 [<ffffffff800453ab>] sprintf+0x51/0x59
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80045be5>] prepare_to_wait_exclusive+0x38/0x61
 [<ffffffff80053232>] skb_recv_datagram+0x160/0x1e3
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8003fb1c>] d_rehash+0x21/0x34
 [<ffffffff802516c3>] unix_accept+0x54/0x104
 [<ffffffff80200c35>] sys_accept+0x11c/0x1ea
 [<ffffffff8003952d>] fcntl_setlk+0x22f/0x25c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

saslauthd     S ffff81006553fea8     0 16100  16098         16101 16099 (NOTLB)
 ffff81006553fea8 0000003aebcbff10 ffff81007d2b0ac0 0000000000000001
 ffff81007c7737e0 ffff81007dc28040 0000002d6a97ad01 00000000000177ab
 ffff81007c7739c8 0000000000000003 0000000000000246 ffff810074281768
Call Trace:
 [<ffffffff800d999f>] __posix_lock_file_conf+0x376/0x3be
 [<ffffffff800394c3>] fcntl_setlk+0x1c5/0x25c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8002e049>] sys_fcntl+0x269/0x2dc
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

saslauthd     S ffff81006555fea8     0 16101  16098         16102 16100 (NOTLB)
 ffff81006555fea8 0000003aebcbff10 ffff81007c94a080 0000000000000001
 ffff81007d7a00c0 ffff81007dc28040 0000002d6a9c3a1c 0000000000017399
 ffff81007d7a02a8 0000000000000003 0000000000000246 ffff810074281978
Call Trace:
 [<ffffffff800d999f>] __posix_lock_file_conf+0x376/0x3be
 [<ffffffff800394c3>] fcntl_setlk+0x1c5/0x25c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8002e049>] sys_fcntl+0x269/0x2dc
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

saslauthd     S ffff81006559fea8     0 16102  16098               16101 (NOTLB)
 ffff81006559fea8 0000003aebcbff10 ffff81007df228c0 0000000000000001
 ffff81007ce60820 ffff81007dc28040 0000002d6aa0c06d 0000000000015957
 ffff81007ce60a08 0000000000000003 0000000000000246 ffff810074281a28
Call Trace:
 [<ffffffff800d999f>] __posix_lock_file_conf+0x376/0x3be
 [<ffffffff800394c3>] fcntl_setlk+0x1c5/0x25c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8002e049>] sys_fcntl+0x269/0x2dc
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

ricci         S ffff810065b6bb38     0 16110      1         16145 16098 (NOTLB)
 ffff810065b6bb38 ffff81007c7131c0 ffff81007c7131c0 000000000000000a
 ffff81007c43f100 ffff81007fd19100 0000006b7878b37e 0000000000001cf0
 ffff81007c43f2e8 ffffffff00000001 ffff81007fd19100 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8804eb23>] :ext3:ext3_getblk+0x101/0x262
 [<ffffffff8000ce95>] dput+0x2c/0x113
 [<ffffffff8000a2d1>] __link_path_walk+0xdf8/0xf42
 [<ffffffff800129e9>] rb_insert_color+0xb2/0xda
 [<ffffffff8000af70>] __find_get_block+0x15c/0x16c
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff8001081f>] __find_get_block_slow+0xeb/0xf7
 [<ffffffff8000768c>] find_get_page+0x21/0x47
 [<ffffffff80013040>] filemap_nopage+0x188/0x322
 [<ffffffff80008ac9>] __handle_mm_fault+0x4e1/0xdf2
 [<ffffffff80021b6e>] __up_read+0x19/0x7f
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

smartd        S ffff810065019eb8     0 16145      1         16152 16110 (NOTLB)
 ffff810065019eb8 ffff810065019e58 ffff810065019e58 0000000000000005
 ffff81007fbe57e0 ffff81007fd19100 0000002debd65606 000000000014ae1d
 ffff81007fbe59c8 ffff810000000001 ffff810002c404e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

login         S ffff8100657d7ee8     0 16152      1 16288   16153 16145 (NOTLB)
 ffff8100657d7ee8 ffff81007fb260c0 ffffffff8001f817 0000000000000008
 ffff81007cd83080 ffff81007fd19100 00000044c25afcbe 0000000000005f7f
 ffff81007cd83268 0000000000000001 ffffffff800645d8 ffffffffffffffff
Call Trace:
 [<ffffffff8001f817>] copy_process+0x131e/0x155d
 [<ffffffff800645d8>] do_page_fault+0x4eb/0x81d
 [<ffffffff80027c2e>] do_wait+0x936/0xa0a
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

mingetty      S ffff8100657d1dc8     0 16153      1         16154 16152 (NOTLB)
 ffff8100657d1dc8 0000000000000003 0000000000000001 0000000000000007
 ffff81007fac6040 ffff81007dbd27e0 0000002dee1a105d 00000000000e9a54
 ffff81007fac6228 0000000000000003 0000000000000000 ffff810002c36400
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002916d>] read_chan+0x3a4/0x629
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80031d12>] tty_read+0x72/0xc7
 [<ffffffff8000b212>] vfs_read+0xcb/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

mingetty      S ffff810065515dc8     0 16154      1         16155 16153 (NOTLB)
 ffff810065515dc8 0000000000000000 0000000000000000 0000000000000007
 ffff81007dbd27e0 ffff810037d1b100 0000002dee29fc03 00000000000386ec
 ffff81007dbd29c8 0000000000000003 ffffffff80016919 ffffffffffffffff
Call Trace:
 [<ffffffff80016919>] release_console_sem+0x1ba/0x20e
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002916d>] read_chan+0x3a4/0x629
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80031d12>] tty_read+0x72/0xc7
 [<ffffffff8000b212>] vfs_read+0xcb/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

mingetty      S ffff8100655bddc8     0 16155      1         16157 16154 (NOTLB)
 ffff8100655bddc8 0000000000000000 0000000000000000 0000000000000007
 ffff81007ce600c0 ffff81007bfa1080 0000002dee3a8823 000000000006246c
 ffff81007ce602a8 0000000000000001 ffffffff80016919 0000000000000000
Call Trace:
 [<ffffffff80016919>] release_console_sem+0x1ba/0x20e
 [<ffffffff80190303>] do_con_write+0x1694/0x16c8
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002916d>] read_chan+0x3a4/0x629
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80031d12>] tty_read+0x72/0xc7
 [<ffffffff8000b212>] vfs_read+0xcb/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

mingetty      S ffff810065417dc8     0 16157      1         16159 16155 (NOTLB)
 ffff810065417dc8 0000000000000000 0000000000000000 0000000000000007
 ffff81007bfa1080 ffff81007fd19100 0000002dee48d20e 0000000000054f23
 ffff81007bfa1268 0000000000000001 ffffffff80016919 ffffffffffffffff
Call Trace:
 [<ffffffff80016919>] release_console_sem+0x1ba/0x20e
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002916d>] read_chan+0x3a4/0x629
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80031d12>] tty_read+0x72/0xc7
 [<ffffffff8000b212>] vfs_read+0xcb/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

mingetty      S ffff810065401dc8     0 16159      1         16160 16157 (NOTLB)
 ffff810065401dc8 0000000000000000 0000000000000000 0000000000000007
 ffff81007c450860 ffff810037d1b100 0000002dee5d89c2 000000000002a58d
 ffff81007c450a48 0000000000000003 ffffffff80016919 ffffffffffffffff
Call Trace:
 [<ffffffff80016919>] release_console_sem+0x1ba/0x20e
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002916d>] read_chan+0x3a4/0x629
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80031d12>] tty_read+0x72/0xc7
 [<ffffffff8000b212>] vfs_read+0xcb/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

mingetty      S ffff8100656b3dc8     0 16160      1         16163 16159 (NOTLB)
 ffff8100656b3dc8 0000000000000000 0000000000000000 0000000000000007
 ffff810037fe60c0 ffff81007c450860 0000002dee5554fa 00000000000610fc
 ffff810037fe62a8 0000000000000003 ffffffff80016919 0000000000000000
Call Trace:
 [<ffffffff80016919>] release_console_sem+0x1ba/0x20e
 [<ffffffff80190303>] do_con_write+0x1694/0x16c8
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002916d>] read_chan+0x3a4/0x629
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
 [<ffffffff80031d12>] tty_read+0x72/0xc7
 [<ffffffff8000b212>] vfs_read+0xcb/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

gdm-binary    S ffff81007e1bbb38     0 16163      1 16240   16254 16160 (NOTLB)
 ffff81007e1bbb38 ffff810072ea0d90 ffff810000000002 0000000000000009
 ffff81007bddc080 ffff810037d1b100 0000002e96c66713 0000000000009780
 ffff81007bddc268 ffff810000000003 ffff810037d1b100 ffffffffffffffff
Call Trace:
 [<ffffffff8006135b>] schedule_timeout+0x1e/0xad
 [<ffffffff80047701>] add_wait_queue+0x24/0x34
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
Jun 19 13:58:54 multipath last message repeated 3 times
 [<ffffffff80043a1c>] do_sock_read+0xc0/0xcb
 [<ffffffff801ffac6>] sock_aio_read+0x4f/0x5e
 [<ffffffff8000c8f8>] do_sync_read+0xc7/0x104
 [<ffffffff80023328>] __user_walk_fd+0x41/0x4c
 [<ffffffff80201b55>] sk_free+0xc3/0x106
 [<ffffffff8004fb25>] unix_release_sock+0x1dc/0x1fa
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

gdm-binary    S ffff8100652b9df8     0 16240  16163 16257               (NOTLB)
 ffff8100652b9df8 0000000000000012 800000006568e067 0000000000000007
 ffff81007bcd6820 ffff81007fd19100 0000002eb8ae48bd 00000000000008d3
 ffff81007bcd6a08 8000000000000001 ffff8100652b9e24 ffffffffffffffff
Call Trace:
 [<ffffffff80045c77>] pipe_wait+0x69/0x93
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff80061622>] mutex_lock+0xd/0x1d
 [<ffffffff8002e729>] pipe_readv+0x31d/0x3a2
 [<ffffffff800d6fcc>] pipe_read+0x1a/0x1f
 [<ffffffff8000b212>] vfs_read+0xcb/0x171
 [<ffffffff8001145c>] sys_read+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

gdm-binary    S ffff8100657a1eb8     0 16256      1               16254 (NOTLB)
 ffff8100657a1eb8 ffff8100657a1e58 ffff8100657a1e58 000000000000000a
 ffff81007d6d0100 ffff81007fd19100 0000006b8b82077b 0000000000002c9f
 ffff81007d6d02e8 ffff810000000001 ffff810002c404e0 ffffffffffffffff
Call Trace:
 [<ffffffff80061804>] do_nanosleep+0x3f/0x70
 [<ffffffff800587ce>] hrtimer_nanosleep+0x58/0x118
 [<ffffffff8009d5e0>] hrtimer_wakeup+0x0/0x22
 [<ffffffff800526e5>] sys_nanosleep+0x4c/0x62
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

Xorg          S ffff810065375a18     0 16257  16240         16287       (NOTLB)
 ffff810065375a18 ffff81000000fc10 000280d200000000 000000000000000a
 ffff81007c06b0c0 ffff81007fd28080 0000006ac04be3a8 00000000000058cd
 ffff81007c06b2a8 0000000000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff800112a6>] do_select+0x3fe/0x462
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
Jun 19 13:58:54 multipath last message repeated 7 times
 [<ffffffff800d83cb>] core_sys_select+0x1bc/0x265
 [<ffffffff80069670>] math_state_restore+0x23/0x4c
 [<ffffffff8005be1d>] error_exit+0x0/0x84
 [<ffffffff800415c5>] sys_rt_sigreturn+0x283/0x356
 [<ffffffff80041665>] sys_rt_sigreturn+0x323/0x356
 [<ffffffff80015ff0>] sys_select+0x153/0x17c
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

gdmgreeter    S ffff810064d45b38     0 16287  16240               16257 (NOTLB)
 ffff810064d45b38 0000000000000286 0000000000000286 0000000000000009
 ffff81007c62c7a0 ffffffff802d1ae0 0000006abf083b06 00000000000014c0
 ffff81007c62c988 ffff810000000000 ffffffff802d1ae0 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff8002f135>] do_sys_poll+0x277/0x35e
 [<ffffffff8001e043>] __pollwait+0x0/0xe2
 [<ffffffff80086c5f>] default_wake_function+0x0/0xe
Jun 19 13:58:54 multipath last message repeated 2 times
 [<ffffffff800127fd>] sock_def_readable+0x34/0x5f
 [<ffffffff800483a6>] unix_stream_sendmsg+0x25d/0x30e
 [<ffffffff80037264>] do_sock_write+0xc4/0xce
 [<ffffffff8004543e>] sock_aio_write+0x4f/0x5e
 [<ffffffff8000c172>] _atomic_dec_and_lock+0x39/0x57
 [<ffffffff800177d2>] do_sync_write+0xc7/0x104
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8025183a>] unix_ioctl+0xc7/0xcf
 [<ffffffff801ffcf6>] sock_ioctl+0x1c1/0x1e5
 [<ffffffff800b1cca>] audit_syscall_entry+0x14d/0x180
 [<ffffffff8004a000>] sys_poll+0x2c/0x33
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

bash          R  running task       0 16288  16152 16320               (NOTLB)
dd            D ffff8100648dba68     0 16320  16288                     (NOTLB)
 ffff8100648dba68 ffff8100022886a8 ffff8100022886e0 0000000000000007
 ffff81007d6bb040 ffff81007fd28080 0000006b91ee7d94 00000000000015a9
 ffff81007d6bb228 ffff810000000002 ffff81007fd28080 ffffffffffffffff
Call Trace:
 [<ffffffff800613c7>] schedule_timeout+0x8a/0xad
 [<ffffffff80092de7>] process_timeout+0x0/0x5
 [<ffffffff80060d55>] io_schedule_timeout+0x4b/0x79
 [<ffffffff8003a9c4>] blk_congestion_wait+0x66/0x80
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8004ece5>] writeback_inodes+0xa8/0xd8
 [<ffffffff800bc61b>] balance_dirty_pages_ratelimited_nr+0x183/0x1fa
 [<ffffffff8000fc69>] generic_file_buffered_write+0x5a4/0x6d8
 [<ffffffff800133d9>] __mark_inode_dirty+0x22/0x16e
 [<ffffffff80015d10>] __generic_file_aio_write_nolock+0x36d/0x3b8
 [<ffffffff800b981f>] generic_file_aio_write_nolock+0x20/0x6c
 [<ffffffff800b9be9>] generic_file_write_nolock+0x8f/0xa8
 [<ffffffff8009b666>] autoremove_wake_function+0x0/0x2e
 [<ffffffff8002e8df>] __clear_user+0x12/0x50
 [<ffffffff801836d9>] read_zero+0x1cc/0x225
 [<ffffffff800d491e>] blkdev_file_write+0x1a/0x1f
 [<ffffffff80016121>] vfs_write+0xce/0x174
 [<ffffffff800169b2>] sys_write+0x45/0x6e
 [<ffffffff8005b2c1>] tracesys+0xd1/0xdc

pdflush       S ffff81005af5be70     0 16322     35         16323 14827 (L-TLB)
 ffff81005af5be70 0000000000000286 ffffffff8003d058 000000000000000a
 ffff81007c2bd7a0 ffffffff802d1ae0 0000006944863b91 0000000000001b32
 ffff81007c2bd988 0000000000000000 000000010000cec0 ffffffffffffffff
Call Trace:
 [<ffffffff8003d058>] lock_timer_base+0x1b/0x3c
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff800544fe>] pdflush+0x0/0x1fb
 [<ffffffff800545eb>] pdflush+0xed/0x1fb
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

pdflush       S ffff810041aafe70     0 16323     35         16324 16322 (L-TLB)
 ffff810041aafe70 0000000000000400 ffffffff802f1c78 000000000000000a
 ffff81007cdc4040 ffff810037e28860 000000691381c155 00000000000016a4
 ffff81007cdc4228 ffff810000000001 ffffffff8004ece5 0000000000000400
Call Trace:
 [<ffffffff8004ece5>] writeback_inodes+0xa8/0xd8
 [<ffffffff800bc735>] background_writeout+0xa3/0xb5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff800544fe>] pdflush+0x0/0x1fb
 [<ffffffff800545eb>] pdflush+0xed/0x1fb
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

pdflush       S ffff81001ada3e70     0 16324     35         16325 16323 (L-TLB)
 ffff81001ada3e70 0000000000000400 ffffffff802f1c78 000000000000000a
 ffff810037e28860 ffff81007fb387a0 000000691381cb82 0000000000000a2d
 ffff810037e28a48 ffff810000000001 ffffffff8004ece5 0000000000000400
Call Trace:
 [<ffffffff8004ece5>] writeback_inodes+0xa8/0xd8
 [<ffffffff800bc735>] background_writeout+0xa3/0xb5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff800544fe>] pdflush+0x0/0x1fb
 [<ffffffff800545eb>] pdflush+0xed/0x1fb
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

pdflush       S ffff810078e95e70     0 16325     35         16326 16324 (L-TLB)
 ffff810078e95e70 0000000000000400 ffffffff802f1c78 000000000000000a
 ffff81007b4500c0 ffff81007fb2d0c0 000000690f0b2c62 0000000000000679
 ffff81007b4502a8 ffff810000000000 ffffffff8004ece5 0000000000000400
Call Trace:
 [<ffffffff8004ece5>] writeback_inodes+0xa8/0xd8
 [<ffffffff800bc735>] background_writeout+0xa3/0xb5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff800544fe>] pdflush+0x0/0x1fb
 [<ffffffff800545eb>] pdflush+0xed/0x1fb
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

pdflush       S ffff8100261a9e70     0 16326     35         16327 16325 (L-TLB)
 ffff8100261a9e70 0000000000000400 ffffffff802f1c78 000000000000000a
 ffff81007fb387a0 ffff81007c2bd7a0 000000691381d329 00000000000007a7
 ffff81007fb38988 ffff810000000001 ffffffff8004ece5 0000000000000400
Call Trace:
 [<ffffffff8004ece5>] writeback_inodes+0xa8/0xd8
 [<ffffffff800bc735>] background_writeout+0xa3/0xb5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff800544fe>] pdflush+0x0/0x1fb
 [<ffffffff800545eb>] pdflush+0xed/0x1fb
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

pdflush       S ffff810070279e70     0 16327     35               16326 (L-TLB)
 ffff810070279e70 0000000000000400 ffffffff802f1c78 000000000000000a
 ffff810002fbb860 ffff81007b4500c0 000000690f0b25e9 0000000000000ce5
 ffff810002fbba48 ffff810000000000 ffffffff8004ece5 0000000000000400
Call Trace:
 [<ffffffff8004ece5>] writeback_inodes+0xa8/0xd8
 [<ffffffff800bc735>] background_writeout+0xa3/0xb5
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff800544fe>] pdflush+0x0/0x1fb
 [<ffffffff800545eb>] pdflush+0xed/0x1fb
 [<ffffffff8003216e>] kthread+0xfe/0x132
 [<ffffffff8005bfe5>] child_rip+0xa/0x11
 [<ffffffff8009b4a3>] keventd_create_kthread+0x0/0x61
 [<ffffffff80032070>] kthread+0x0/0x132
 [<ffffffff8005bfdb>] child_rip+0x0/0x11

BUG: soft lockup detected on CPU#3!

Call Trace:
 <IRQ>  [<ffffffff800b2c85>] softlockup_tick+0xdb/0xed
 [<ffffffff800933d1>] update_process_times+0x42/0x68
 [<ffffffff80073d97>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074459>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80054f13>] mwait_idle+0x0/0x4a
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80054f49>] mwait_idle+0x36/0x4a
 [<ffffffff80046f9c>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb5>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#0!

Call Trace:
 <IRQ>  [<ffffffff800b2c85>] softlockup_tick+0xdb/0xed
 [<ffffffff800933d1>] update_process_times+0x42/0x68
 [<ffffffff80073d97>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074459>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80054f13>] mwait_idle+0x0/0x4a
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80054f49>] mwait_idle+0x36/0x4a
 [<ffffffff80046f9c>] cpu_idle+0x95/0xb8
 [<ffffffff803c57f6>] start_kernel+0x220/0x225
 [<ffffffff803c5237>] _sinittext+0x237/0x23e

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff800b2c85>] softlockup_tick+0xdb/0xed
 [<ffffffff800933d1>] update_process_times+0x42/0x68
 [<ffffffff80073d97>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074459>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80054f13>] mwait_idle+0x0/0x4a
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80054f49>] mwait_idle+0x36/0x4a
 [<ffffffff80046f9c>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb5>] start_secondary+0x45a/0x469

BUG: soft lockup detected on CPU#2!

Call Trace:
 <IRQ>  [<ffffffff800b2c85>] softlockup_tick+0xdb/0xed
 [<ffffffff800933d1>] update_process_times+0x42/0x68
 [<ffffffff80073d97>] smp_local_timer_interrupt+0x23/0x47
 [<ffffffff80074459>] smp_apic_timer_interrupt+0x41/0x47
 [<ffffffff80054f13>] mwait_idle+0x0/0x4a
 [<ffffffff8005bcc2>] apic_timer_interrupt+0x66/0x6c
 <EOI>  [<ffffffff80054f49>] mwait_idle+0x36/0x4a
 [<ffffffff80046f9c>] cpu_idle+0x95/0xb8
 [<ffffffff80073bb5>] start_secondary+0x45a/0x469 

