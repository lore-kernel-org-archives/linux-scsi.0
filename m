From: Hannes Reinecke <hare@suse.de>
Subject: Re: question on block-layer timeout change
Date: Thu, 11 Dec 2008 12:03:03 +0100
Message-ID: <4940F367.506@suse.de>
References: <3568BBCB98C00041A9E622952FD5F24EA11C9F3A@cosmail03.lsi.com> <20081112072919.GB12192@linux.vnet.ibm.com> <3568BBCB98C00041A9E622952FD5F24EA1226673@cosmail03.lsi.com> <20081114171823.GA16575@us.ibm.com> <3568BBCB98C00041A9E622952FD5F24EA135D754@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54223 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYLKLDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Dec 2008 06:03:07 -0500
In-Reply-To: <3568BBCB98C00041A9E622952FD5F24EA135D754@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Shi, Harris" <Harris.Shi@lsi.com>
Cc: "malahal@us.ibm.com" <malahal@us.ibm.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Hi Harris,

Shi, Harris wrote:
> Mike,
>=20
> Your suggestion on MPP driver is working pretty good on FC config in =
term of failover and failback. However, recently when we switched over =
to iscsi config on SLES11beta6 (2.6.27.7-4-default, SLES11 kernel did n=
ot sync up with current upstream one, all of timeout management patch h=
as been pulled in), we were consistently hit by the following panic whe=
n we tried to do failover via controller sysReboot or placed offline. I=
s it something related to the recent timeout management patch introduce=
d into the kernel?
>=20
> BUG: unable to handle kernel NULL pointer dereference at 000000000000=
00ba
> IP: [<ffffffff80222047>] __ticket_spin_lock+0x5/0x1b
> PGD 196cf6067 PUD 196c4f067 PMD 0
> Oops: 0002 [1] SMP
> last sysfs file: /sys/devices/system/cpu/cpu3/cache/index1/shared_cpu=
_map
> CPU 2
> Modules linked in: radeon drm crc32c libcrc32c ib_iser rdma_cm ib_cm =
iw_cm ib_sa ib_mad ib_core d
> Supported: Yes, External
> Pid: 0, comm: swapper Tainted: G          2.6.27.7-4-default #1
> RIP: 0010:[<ffffffff80222047>]  [<ffffffff80222047>] __ticket_spin_lo=
ck+0x5/0x1b
> RSP: 0018:ffff88019f187e20  EFLAGS: 00010086
> RAX: 0000000000010000 RBX: 0000000000000002 RCX: ffff88019d8c3218
> RDX: ffff88019cd3d000 RSI: 0000000000002007 RDI: 00000000000000ba
> RBP: ffff880194940918 R08: ffff880194940c78 R09: 0000000000000000
> R10: ffffffff80a65b80 R11: ffffffff8021c6ed R12: 0000000000000000
> R13: ffff880194940b50 R14: ffff88019f187ed0 R15: ffff880194940c90
> FS:  0000000000000000(0000) GS:ffff88019f157ec0(0000) knlGS:000000000=
0000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 00000000000000ba CR3: 0000000196cc7000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffff88019f180000, task ffff88019f=
17e280)
> Stack:  ffffffff804aabe2 ffffffffa0321734 0000000000000000 ffff88018f=
c97c80
>  ffff880194940918 ffffffffa0004f35 ffff88019d8c30d8 ffffffff8034b954
>  ffff88019d8c30d8 ffffffff8034ba23 0000000000000282 0000000000000100
> Call Trace:
>  [<ffffffff804aabe2>] _spin_lock+0x13/0x15
>  [<ffffffffa0321734>] iscsi_eh_cmd_timed_out+0x27/0xc0 [libiscsi]
>  [<ffffffffa0004f35>] scsi_times_out+0x46/0x72 [scsi_mod]
>  [<ffffffff8034b954>] blk_rq_timed_out+0xe/0x4a
>  [<ffffffff8034ba23>] blk_rq_timed_out_timer+0x93/0x116
>  [<ffffffff8024a5f5>] run_timer_softirq+0x19a/0x228
>  [<ffffffff8024696d>] __do_softirq+0x84/0x115
>  [<ffffffff8020ddac>] call_softirq+0x1c/0x28
>  [<ffffffff8020f177>] do_softirq+0x3c/0x81
>  [<ffffffff80246684>] irq_exit+0x3f/0x83
>  [<ffffffff8021cf73>] smp_apic_timer_interrupt+0x95/0xae
>  [<ffffffff8020d523>] apic_timer_interrupt+0x83/0x90
>  [<ffffffff802134f4>] mwait_idle+0x3c/0x46
>  [<ffffffff8020b3b5>] cpu_idle+0xa9/0xf1
>=20
>=20
> Code: ff 00 00 c1 ea 10 39 c2 0f 95 c0 0f b6 c0 c3 8b 17 89 d0 c1 f8 =
10 29 d0 25 ff ff 00 00 ff
> RIP  [<ffffffff80222047>] __ticket_spin_lock+0x5/0x1b
>  RSP <ffff88019f187e20>
> ---------------------------------------------------------------------=
-------
>=20
> Your comment is very much appreciated.
>=20
Please try the latest SLES11 Beta/RC kernel. This bug is due to an inco=
mplete patchset from
mainline and should be resolved now.

If not please do open a Novell bugzilla for it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
