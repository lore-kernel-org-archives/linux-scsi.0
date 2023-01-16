Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CBDC46467
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 17:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbjAPRRj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 12:17:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbjAPRQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 12:16:39 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B683A873;
        Mon, 16 Jan 2023 08:57:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 19024378E6;
        Mon, 16 Jan 2023 16:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673888235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hyL94r1kRc1GoFfYOy3vvUHBqhsOjxm/0iLpRWKnQXY=;
        b=TnSlv4JQuGKsICH8pNsJeqOeq5jDapO3A6sFohPTo4iukUP9dOQ+tKt2sCU9XFyi0FhoRc
        Tj56dfAL4vgKAnlCwpv0V433t+NBfyQlbeYyzZ9qqzXCfR9GDAfF+xE+m3gV9IG/6dBieP
        alwSEpIq+Wgq0d03gVx4WusiPZ9wTvM=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C052D138FA;
        Mon, 16 Jan 2023 16:57:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /V9tLeqBxWNrPgAAMHmgww
        (envelope-from <mwilck@suse.com>); Mon, 16 Jan 2023 16:57:14 +0000
Message-ID: <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
From:   Martin Wilck <mwilck@suse.com>
To:     Steffen Maier <maier@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Date:   Mon, 16 Jan 2023 17:57:13 +0100
In-Reply-To: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2023-01-16 at 15:59 +0100, Steffen Maier wrote:
> Hi all,
>=20
> since a few days/weeks, we sometimes see below alua and sleep related
> kernel=20
> BUG and WARNING (with panic_on_warn) in our CI.
>=20
> It reminds me of
> [PATCH 0/2] Rework how the ALUA driver calls scsi_device_put()
> https://lore.kernel.org/linux-scsi/166986602290.2101055.17397734326843853=
911.b4-ty@oracle.com/
>=20
> which I thought was the fix and went into 6.2-rc(1?) on 2022-12-14
> with
> [GIT PULL] first round of SCSI updates for the 6.1+ merge window
> https://lore.kernel.org/linux-scsi/b2e824bbd1e40da64d2d01657f2f7a67b98919=
fb.camel@HansenPartnership.com/T/#u
>=20

That was the fix for the code path alua_check_vpd()->alua_rtpg_queue()
->scsi_device_put(), where alua_rtpg_queue() was called while obviously
holding a lock. The call chain in your case is different.

But AFAICS Bart's original fix for the BUG, "scsi: alua: Fix alua_rtpg_queu=
e()"
(https://lore.kernel.org/linux-scsi/20221115224903.2325529-1-bvanassche@acm=
.org/)
would also not solve your issue, because it simply moves the scsi_device_pu=
t()=A0
to the caller, alua_check(), which can't sleep, either.

[ 4569.046131]  [<000003ff7fb9c874>] alua_rtpg_queue+0x3c/0x98 [scsi_dh_alu=
a]
[ 4569.046146]  [<000003ff7fb9cfb2>] alua_check+0x122/0x250 [scsi_dh_alua]
[ 4569.046167]  [<000003ff7fb9d562>] alua_check_sense+0x172/0x228 [scsi_dh_=
alua]
[ 4569.046179]  [<000000017e96b3e2>] scsi_check_sense+0x8a/0x2e0
[ 4569.046191]  [<000000017e96e4b6>] scsi_decide_disposition+0x286/0x298
[ 4569.046201]  [<000000017e972bca>] scsi_complete+0x6a/0x108
[ 4569.046212]  [<000000017e746906>] blk_complete_reqs+0x6e/0x88
[ 4569.046227]  [<000000017ed3830e>] __do_softirq+0x13e/0x6b8

AFAICS, it comes down to the fact that the assertion in the commit message =
of=A0
f93ed747e2c7 ("scsi: core: Release SCSI devices synchronously"):
"All upstream scsi_device_put() calls happen from thread context."=A0
turns out to be false for the alua code.

Can we simply defer the scsi_device_put() to a workqueue?

Regards,
Martin





> Due to limited history, I cannot tell exactly when problems started
> and whether=20
> it really correlates to above.
>=20
> Test workload are all kinds of coverage tests for zfcp recovery
> including scsi=20
> device removal and/or rescan.
>=20
> [ 4569.045992] BUG: sleeping function called from invalid context at=20
> drivers/scsi/device_handler/scsi_dh_alua.c:992
> [ 4569.046003] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid:
> 0, name:=20
> swapper/8
> [ 4569.046013] preempt_count: 101, expected: 0
> [ 4569.046023] RCU nest depth: 0, expected: 0
> [ 4569.046033] no locks held by swapper/8/0.
> [ 4569.046042] Preemption disabled at:
> [ 4569.046046] [<000000017e27ce4e>]
> __slab_alloc.constprop.0+0x36/0xb8
> [ 4569.046072] CPU: 8 PID: 0 Comm: swapper/8 Tainted: G=A0=A0=A0=A0=A0=A0=
=A0 W=20
> 6.2.0-20230114.rc3.git0.46e26dd43df0.300.fc37.s390x+debug #1
> [ 4569.046084] Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
> [ 4569.046094] Call Trace:
> [ 4569.046102]=A0 [<000000017ed21bcc>] dump_stack_lvl+0xac/0x100
> [ 4569.046118]=A0 [<000000017df9192c>] __might_resched+0x284/0x2c8
> [ 4569.046131]=A0 [<000003ff7fb9c874>] alua_rtpg_queue+0x3c/0x98
> [scsi_dh_alua]
> [ 4569.046146]=A0 [<000003ff7fb9cfb2>] alua_check+0x122/0x250
> [scsi_dh_alua]
> [ 4569.046167]=A0 [<000003ff7fb9d562>] alua_check_sense+0x172/0x228
> [scsi_dh_alua]
> [ 4569.046179]=A0 [<000000017e96b3e2>] scsi_check_sense+0x8a/0x2e0
> [ 4569.046191]=A0 [<000000017e96e4b6>]
> scsi_decide_disposition+0x286/0x298
> [ 4569.046201]=A0 [<000000017e972bca>] scsi_complete+0x6a/0x108
> [ 4569.046212]=A0 [<000000017e746906>] blk_complete_reqs+0x6e/0x88
> [ 4569.046227]=A0 [<000000017ed3830e>] __do_softirq+0x13e/0x6b8
> [ 4569.046238]=A0 [<000000017df57902>] __irq_exit_rcu+0x14a/0x170
> [ 4569.046264]=A0 [<000000017df58472>] irq_exit_rcu+0x22/0x50
> [ 4569.046275]=A0 [<000000017ed2242a>] do_ext_irq+0x10a/0x1d0
> [ 4569.046286]=A0 [<000000017ed36156>] ext_int_handler+0xd6/0x110
> [ 4569.046296]=A0 [<000000017ed362e6>] psw_idle_exit+0x0/0xa
> [ 4569.046307] ([<000000017defc5da>] arch_cpu_idle+0x52/0xe0)
> [ 4569.046318]=A0 [<000000017ed34744>] default_idle_call+0x84/0xd0
> [ 4569.046329]=A0 [<000000017dfbe4cc>] do_idle+0xfc/0x1b8
> [ 4569.046340]=A0 [<000000017dfbe80e>] cpu_startup_entry+0x36/0x40
> [ 4569.046350]=A0 [<000000017df11964>] smp_start_secondary+0x14c/0x160
> [ 4569.046371]=A0 [<000000017ed3658e>] restart_int_handler+0x6e/0x90
> [ 4569.046381] no locks held by swapper/8/0.
>=20
> Above occurs a few times until it finally ends with:
>=20
> [ 4760.865496] device-mapper: multipath: 251:6: Reinstating path
> 8:176.
> [ 4760.867398] sd 4:0:0:1083719810: Power-on or device reset occurred
> [ 4760.867445] sd 4:0:0:1083719810: [sde] tag#1224 Done:
> ADD_TO_MLQUEUE Result:=20
> hostbyte=3DDID_OK driverbyte=3DDRIVER_OK cmd_age=3D0s
> [ 4760.867469] sd 4:0:0:1083719810: [sde] tag#1224 CDB: Test Unit
> Ready 00 00=20
> 00 00 00 00
> [ 4760.867493] sd 4:0:0:1083719810: [sde] tag#1224 Sense Key : Unit
> Attention=20
> [current]
> [ 4760.867515] sd 4:0:0:1083719810: [sde] tag#1224 Add. Sense: Power
> on, reset,=20
> or bus device reset occurred
> [ 4760.878066] sd 4:0:0:1083719813: Power-on or device reset occurred
> [ 4760.878096] ------------[ cut here ]------------
> [ 4760.878107] do not call blocking ops when !TASK_RUNNING; state=3D2
> set at=20
> [<000000017ed2c0fa>] __wait_for_common+0xa2/0x240
> [ 4760.878132] WARNING: CPU: 3 PID: 165738 at
> kernel/sched/core.c:9908=20
> __might_sleep+0x7c/0x98
> [ 4760.878147] Modules linked in: af_iucv kvm algif_hash af_alg
> nft_fib_inet=20
> nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4
> nf_reject_ipv6=20
> nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6=20
> nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc vfio_ccw mdev
> vfio_iommu_type1=20
> vfio sch_fq_codel ip6_tables ip_tables x_tables configfs
> dm_service_time=20
> ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 libdes
> sha512_s390=20
> sha256_s390 sha1_s390 sha_common zfcp scsi_transport_fc dm_mirror=20
> dm_region_hash dm_log scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey
> zcrypt=20
> rng_core dm_multipath autofs4
> [ 4760.878456] CPU: 3 PID: 165738 Comm: kworker/3:0 Tainted: G=A0=A0=A0=
=A0=A0=A0=A0
> W=20
> =A0 6.2.0-20230114.rc3.git0.46e26dd43df0.300.fc37.s390x+debug #1
> [ 4760.878478] Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
> [ 4760.878489] Workqueue: kaluad alua_rtpg_work [scsi_dh_alua]
> [ 4760.878509] Krnl PSW : 0704d00180000000 000000017df919f0=20
> (__might_sleep+0x80/0x98)
> [ 4760.878542]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 R:0 T:1 IO:1 EX:1 Key:0 M=
:1 W:0 P:0 AS:3
> CC:1 PM:0=20
> RI:0 EA:3
> [ 4760.878560] Krnl GPRS: c0000000ffffbfff 0000000080000101
> 000000000000006d=20
> 000000017f198e94
> [ 4760.878573]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 00000380002739f8 00000380=
002739f0
> 0000000000000000=20
> 000000017f7bca48
> [ 4760.878586]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0000000000000001 00000000=
00000000
> 00000000000003e0=20
> 000003ff7fb9f1bc
> [ 4760.878599]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 00000000827eb100 00000000=
00000101
> 000000017df919ec=20
> 0000038000273b88
> [ 4760.878620] Krnl Code: 000000017df919e0:
> c020008c1da3=A0=A0=A0=A0=A0=A0=A0=A0larl=A0=A0=A0=A0%r2,000000017f115526
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 000000017df919e6: c0e5006bb91d=A0=A0=A0=A0=A0=A0=A0brasl
> %r14,000000017ed08c20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 #000000017df919ec:
> af000000=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mc=A0=A0=A0=A0=A0=A00,0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 >000000017df919f0:
> a7490000=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lghi=A0=A0=A0=A0%r4,0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 000000017df919f4:
> b904003a=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lgr=A0=A0=A0=A0=A0%r3,%r10
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 000000017df919f8:
> b904002b=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lgr=A0=A0=A0=A0=A0%r2,%r11
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 000000017df919fc:
> ebaff0a00004=A0=A0=A0=A0=A0=A0=A0lmg=A0=A0=A0=A0=A0%r10,%r15,160(%r15)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 000000017df91a02:
> c0f4fffffe53=A0=A0=A0=A0=A0=A0=A0brcl=A0=A0=A0=A015,000000017df916a8
> [ 4760.878692] Call Trace:
> [ 4760.878703]=A0 [<000000017df919f0>] __might_sleep+0x80/0x98
> [ 4760.878716] ([<000000017df919ec>] __might_sleep+0x7c/0x98)
> [ 4760.878728]=A0 [<000003ff7fb9c874>] alua_rtpg_queue+0x3c/0x98
> [scsi_dh_alua]
> [ 4760.878743]=A0 [<000003ff7fb9cfb2>] alua_check+0x122/0x250
> [scsi_dh_alua]
> [ 4760.878761]=A0 [<000003ff7fb9d562>] alua_check_sense+0x172/0x228
> [scsi_dh_alua]
> [ 4760.878775]=A0 [<000000017e96b3e2>] scsi_check_sense+0x8a/0x2e0
> [ 4760.878788]=A0 [<000000017e96e4b6>]
> scsi_decide_disposition+0x286/0x298
> [ 4760.878802]=A0 [<000000017e972bca>] scsi_complete+0x6a/0x108
> [ 4760.878815]=A0 [<000000017e746906>] blk_complete_reqs+0x6e/0x88
> [ 4760.878837]=A0 [<000000017ed3830e>] __do_softirq+0x13e/0x6b8
> [ 4760.878852]=A0 [<000000017df57902>] __irq_exit_rcu+0x14a/0x170
> [ 4760.878866]=A0 [<000000017df58472>] irq_exit_rcu+0x22/0x50
> [ 4760.878880]=A0 [<000000017ed223da>] do_ext_irq+0xba/0x1d0
> [ 4760.878896]=A0 [<000000017ed36156>] ext_int_handler+0xd6/0x110
> [ 4760.878909]=A0 [<000000017ed34fbe>]
> _raw_spin_unlock_irqrestore+0x86/0xc0
> [ 4760.878928] ([<000000017ed34fae>]
> _raw_spin_unlock_irqrestore+0x76/0xc0)
> [ 4760.878941]=A0 [<000000017e033e66>] __mod_timer+0x2d6/0x408
> [ 4760.878955]=A0 [<000000017ed33864>] schedule_timeout+0xc4/0x168
> [ 4760.878969]=A0 [<000000017ed2ac62>] io_schedule_timeout+0x5a/0x80
> [ 4760.878983]=A0 [<000000017ed2c12e>] __wait_for_common+0xd6/0x240
> [ 4760.878997]=A0 [<000000017e7479a6>] blk_execute_rq+0x126/0x1f8
> [ 4760.879011]=A0 [<000000017e970722>] __scsi_execute+0x112/0x260
> [ 4760.879024]=A0 [<000003ff7fb9d750>] alua_rtpg+0x138/0xb10
> [scsi_dh_alua]
> [ 4760.879038]=A0 [<000003ff7fb9e3e4>] alua_rtpg_work+0x2bc/0x4e0
> [scsi_dh_alua]
> [ 4760.879053]=A0 [<000000017df78300>] process_one_work+0x310/0x730
> [ 4760.879069]=A0 [<000000017df78782>] worker_thread+0x62/0x420
> [ 4760.879109]=A0 [<000000017df83bc4>] kthread+0x13c/0x150
> [ 4760.879124]=A0 [<000000017defb930>] __ret_from_fork+0x40/0x58
> [ 4760.879138]=A0 [<000000017ed35eda>] ret_from_fork+0xa/0x40
> [ 4760.879152] 2 locks held by kworker/3:0/165738:
> [ 4760.879165]=A0 #0: 000000008c7b5948 ((wq_completion)kaluad){+.+.}-
> {0:0}, at:=20
> process_one_work+0x232/0x730
> [ 4760.879210]=A0 #1: 0000038001177dc8=20
> ((work_completion)(&(&pg->rtpg_work)->work)){+.+.}-{0:0}, at:=20
> process_one_work+0x232/0x730
> [ 4760.879249] Last Breaking-Event-Address:
> [ 4760.879266]=A0 [<000000017e8c6dd0>]
> __s390_indirect_jump_r14+0x0/0x10
> [ 4760.879283] Kernel panic - not syncing: kernel: panic_on_warn set
> ...
>=20
>=20

