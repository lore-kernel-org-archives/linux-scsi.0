Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F37C6C25B4E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 11:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbjAXLgr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 06:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234170AbjAXLgl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 06:36:41 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305792ED47;
        Tue, 24 Jan 2023 03:36:34 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DC8B2211F0;
        Tue, 24 Jan 2023 11:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674560192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uMkixkJE6OjcNVAPe8THy81gSASqgKCmd6I1DYDYw7M=;
        b=opBSr/jDujqZGeAtacq62pQU1ifBeoZFxrnpKt5Ry37TbYMvRt+S6gGwJ+ESGE4AWcU9d1
        j1xb2e4hc18VrblwFjrRg8sYlpNfAtka04Q0i7h8iQZRpVgwKyFhlG6M7GMGiuPd2OALq3
        NLb2Mw+fVD5aFLDMgIoK6sXapKNC8xs=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 808FA13487;
        Tue, 24 Jan 2023 11:36:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9atqHcDCz2PcHgAAMHmgww
        (envelope-from <mwilck@suse.com>); Tue, 24 Jan 2023 11:36:32 +0000
Message-ID: <1bfa83faef0a97de93c69013831b0df9b821f916.camel@suse.com>
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
From:   Martin Wilck <mwilck@suse.com>
To:     Steffen Maier <maier@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Date:   Tue, 24 Jan 2023 12:36:31 +0100
In-Reply-To: <55c35e64-a7d4-9072-46fd-e8eae6a90e96@linux.ibm.com>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
         <017b6c73f56505e63519e4b79fe69d66abddf810.camel@suse.com>
         <a9da2b27-882f-bc8e-3400-cb53440e2159@acm.org>
         <125f247806396f19fd27dcfa71f530b5b4a529a6.camel@suse.com>
         <c23a6bf4-0b6e-0bbb-b74d-af69756bcf9a@acm.org>
         <ab7d61dd7f7c0289114e36fef6e9f282ad5c976b.camel@suse.com>
         <2bea9c3e-2a61-a51e-c13b-796adabe6f71@acm.org>
         <983f47533ee56b2a954de97dc7e02cbcbc4f9841.camel@suse.com>
         <08e7e15e-37e0-0d45-9332-fe4b6e896cb2@acm.org>
         <f39fb7d2-f0ec-ea53-a3a9-eb86b8367e82@linux.ibm.com>
         <55c35e64-a7d4-9072-46fd-e8eae6a90e96@linux.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2023-01-24 at 12:16 +0100, Steffen Maier wrote:
> On 1/18/23 17:17, Steffen Maier wrote:
>=20
> >=20
> > I had removed those two lines yesterday for our CI kernel build.
> > Tonight's run obviously no longer had any related BUG or WARNING.
> > I checked all dumps from that run to see if anything stalled and
> > whether it was=20
> > related to ALUA, but I think we're good.
> >=20
> > Tested-by: Steffen Maier <maier@linux.ibm.com>
>=20
> I'm afraid, that might have been too early.
> Today, I got BUG/WARNING with a slightly different stack trace where=20
> alua_rtpg_queue calls scsi_device_put(), which in turn contains a
> might_sleep=20
> but seems called in atomic context:
>=20
> > [ 2517.231562] sd 13:0:0:1073823768: Power-on or device reset
> > occurred
> > [ 2517.231582] sd 13:0:0:1073823768: [sdax] tag#2787 Done:
> > ADD_TO_MLQUEUE Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK
> > cmd_age=3D0s
> > [ 2517.231590] sd 13:0:0:1073823768: [sdax] tag#2787 CDB: Test Unit
> > Ready 00 00 00 00 00 00
> > [ 2517.231598] sd 13:0:0:1073823768: [sdax] tag#2787 Sense Key :
> > Unit Attention [current]=20
> > [ 2517.231605] sd 13:0:0:1073823768: [sdax] tag#2787 Add. Sense:
> > Power on, reset, or bus device reset occurred
> > [ 2517.236104] sd 13:0:0:1074348056: Power-on or device reset
> > occurred
> > [ 2517.236124] BUG: sleeping function called from invalid context
> > at drivers/scsi/scsi.c:591
> > [ 2517.236130] in_atomic(): 1, irqs_disabled(): 0, non_block: 0,
> > pid: 166768, name: systemd-udevd
> > [ 2517.236137] preempt_count: 100, expected: 0
> > [ 2517.236143] RCU nest depth: 0, expected: 0
> > [ 2517.236148] no locks held by systemd-udevd/166768.
> > [ 2517.236154] Preemption disabled at:
> > [ 2517.236157] [<000000019704d22e>] __do_softirq+0x5e/0x6b8
> > [ 2517.236177] CPU: 2 PID: 166768 Comm: systemd-udevd Tainted:
> > G=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 K=A0=A0=A0 6.2.0-
> > 20230123.rc5.git2.9dea08313ff5.300.fc37.s390x+debug #1
> > [ 2517.236185] Hardware name: IBM 8561 T01 703 (z/VM 7.3.0)
> > [ 2517.236190] Call Trace:
> > [ 2517.236195]=A0 [<00000001970367cc>] dump_stack_lvl+0xac/0x100=20
> > [ 2517.236203]=A0 [<00000001962a590c>] __might_resched+0x284/0x2c8=20
> > [ 2517.236213]=A0 [<0000000196c7b34a>] scsi_device_put+0x42/0x60=20
> > [ 2517.236224]=A0 [<000003ff7fb9c57e>]
> > alua_rtpg_queue.part.0+0xce/0x348 [scsi_dh_alua]=20
> > [ 2517.236234]=A0 [<000003ff7fb9d20a>] alua_check+0x132/0x260
> > [scsi_dh_alua]=20
> > [ 2517.236241]=A0 [<000003ff7fb9d4aa>] alua_check_sense+0x172/0x228
> > [scsi_dh_alua]=20
> > [ 2517.236248]=A0 [<0000000196c7fd0e>] scsi_check_sense+0x86/0x2e0=20
> > [ 2517.236256]=A0 [<0000000196c82cc6>]
> > scsi_decide_disposition+0x286/0x298=20
> > [ 2517.236262]=A0 [<0000000196c873da>] scsi_complete+0x6a/0x108=20
> > [ 2517.236269]=A0 [<0000000196a5aeea>] blk_complete_reqs+0x6a/0x88=20
> > [ 2517.236281]=A0 [<000000019704d30a>] __do_softirq+0x13a/0x6b8=20
> > [ 2517.236287]=A0 [<000000019626b802>] __irq_exit_rcu+0x14a/0x170=20
> > [ 2517.236297]=A0 [<000000019626c372>] irq_exit_rcu+0x22/0x50=20
> > [ 2517.236303]=A0 [<0000000197036fda>] do_ext_irq+0xba/0x1d0=20
> > [ 2517.236309]=A0 [<000000019704ad06>] ext_int_handler+0xd6/0x110=20
> > [ 2517.236315]=A0 [<00000001963accd2>] seccomp_run_filters+0x9a/0x198
> > [ 2517.236328]=A0 [<00000001963ad5bc>] __seccomp_filter+0x4c/0x3b8=20
> > [ 2517.236334]=A0 [<0000000196335f1a>]
> > syscall_trace_enter.constprop.0+0xda/0x310=20
> > [ 2517.236345]=A0 [<0000000197036bf0>] __do_syscall+0xf0/0x208=20
> > [ 2517.236350]=A0 [<000000019704aa52>] system_call+0x82/0xb0=20
> > [ 2517.236356] no locks held by systemd-udevd/166768.
>=20
> The same can also happen outside of process context, where it
> happened to run=20
> alua_rtpg() before an IRQ happened for :
>=20
> > [ 2517.249685] ------------[ cut here ]------------
> > [ 2517.249691] do not call blocking ops when !TASK_RUNNING; state=3D2
> > set at [<0000000197040cb2>] __wait_for_common+0xa2/0x240
> > [ 2517.249710] WARNING: CPU: 0 PID: 121221 at
> > kernel/sched/core.c:9959 __might_sleep+0x7c/0x98
> > [ 2517.249719] Modules linked in: kvm af_iucv algif_hash af_alg
> > nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet
> > nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat
> > nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables
> > nfnetlink dm_service_time sunrpc zfcp scsi_transport_fc s390_trng
> > vfio_ccw mdev vfio_iommu_type1 vfio sch_fq_codel ip6_tables
> > ip_tables x_tables configfs ghash_s390 prng chacha_s390 libchacha
> > aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 nvme
> > sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core scsi_dh_rdac
> > scsi_dh_emc scsi_dh_alua pkey zcrypt rng_core dm_multipath autofs4
> > [ 2517.249869] Unloaded tainted modules: test_klp_state3(K):1
> > test_klp_state2(K):4 test_klp_state(K):3
> > test_klp_callbacks_demo2(K):2 test_klp_callbacks_demo(K):12
> > test_klp_atomic_replace(K):2 test_klp_livepatch(K):6 [last
> > unloaded: test_klp_callbacks_demo(K)]
> > [ 2517.249907] CPU: 0 PID: 121221 Comm: kworker/0:1 Tainted:
> > G=A0=A0=A0=A0=A0=A0=A0 W=A0=A0=A0=A0 K=A0=A0=A0 6.2.0-
> > 20230123.rc5.git2.9dea08313ff5.300.fc37.s390x+debug #1
> > [ 2517.249915] Hardware name: IBM 8561 T01 703 (z/VM 7.3.0)
> > [ 2517.249921] Workqueue: kaluad alua_rtpg_work [scsi_dh_alua]
> > [ 2517.249931] Krnl PSW : 0704d00180000000 00000001962a59d0
> > (__might_sleep+0x80/0x98)
> > [ 2517.249944]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 R:0 T:1 IO:1 EX:1 Key:0=
 M:1 W:0 P:0 AS:3
> > CC:1 PM:0 RI:0 EA:3
> > [ 2517.249953] Krnl GPRS: c0000000ffffbfff 0000000080000101
> > 000000000000006d 00000001974ae114
> > [ 2517.249960]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0000037ffff339a0 000003=
7ffff33998
> > 0000000000000000 0000000000000001
> > [ 2517.249966]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 0700037ffff33b50 000000=
00be69c000
> > 000000000000024f 00000001974cb458
> > [ 2517.249973]=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 00000000a4080100 000000=
00a5344220
> > 00000001962a59cc 0000037ffff33b30
> > [ 2517.249985] Krnl Code: 00000001962a59c0:
> > c020008c269f=A0=A0=A0=A0=A0=A0=A0=A0larl=A0=A0=A0=A0%r2,000000019742a6f=
e
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 00000001962a59c6:
> > c0e5006bbf19=A0=A0=A0=A0=A0=A0=A0=A0brasl=A0=A0=A0%r14,000000019701d7f8
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 #00000001962a59cc:
> > af000000=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mc=A0=A0=A0=A0=A0=A00,0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 >00000001962a59d0:
> > a7490000=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lghi=A0=A0=A0=A0%r4,0
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 00000001962a59d4:
> > b904003a=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lgr=A0=A0=A0=A0=A0%r3,%r10
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 00000001962a59d8:
> > b904002b=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lgr=A0=A0=A0=A0=A0%r2,%r11
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 00000001962a59dc:
> > ebaff0a00004=A0=A0=A0=A0=A0=A0=A0=A0lmg=A0=A0=A0=A0=A0%r10,%r15,160(%r1=
5)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 00000001962a59e2:
> > c0f4fffffe53=A0=A0=A0=A0=A0=A0=A0=A0brcl=A0=A0=A0=A015,00000001962a5688
> > [ 2517.250023] Call Trace:
> > [ 2517.250028]=A0 [<00000001962a59d0>] __might_sleep+0x80/0x98=20
> > [ 2517.250036] ([<00000001962a59cc>] __might_sleep+0x7c/0x98)
> > [ 2517.250043]=A0 [<0000000196c7b34a>] scsi_device_put+0x42/0x60=20
> > [ 2517.250050]=A0 [<000003ff7fb9c57e>]
> > alua_rtpg_queue.part.0+0xce/0x348 [scsi_dh_alua]=20
> > [ 2517.250058]=A0 [<000003ff7fb9d20a>] alua_check+0x132/0x260
> > [scsi_dh_alua]=20
> > [ 2517.250066]=A0 [<000003ff7fb9d4aa>] alua_check_sense+0x172/0x228
> > [scsi_dh_alua]=20
> > [ 2517.250073]=A0 [<0000000196c7fd0e>] scsi_check_sense+0x86/0x2e0=20
> > [ 2517.250080]=A0 [<0000000196c82cc6>]
> > scsi_decide_disposition+0x286/0x298=20
> > [ 2517.250087]=A0 [<0000000196c873da>] scsi_complete+0x6a/0x108=20
> > [ 2517.250095]=A0 [<0000000196a5aeea>] blk_complete_reqs+0x6a/0x88=20
> > [ 2517.250102]=A0 [<000000019704d30a>] __do_softirq+0x13a/0x6b8=20
> > [ 2517.250109]=A0 [<000000019626b802>] __irq_exit_rcu+0x14a/0x170=20
> > [ 2517.250116]=A0 [<000000019626c372>] irq_exit_rcu+0x22/0x50=20
> > [ 2517.250123]=A0 [<0000000197036fda>] do_ext_irq+0xba/0x1d0=20
> > [ 2517.250130]=A0 [<000000019704ad06>] ext_int_handler+0xd6/0x110=20
> > [ 2517.250136]=A0 [<0000000197049ac2>] _raw_spin_unlock_irq+0x42/0x70
> > [ 2517.250143] ([<0000000197049abe>]
> > _raw_spin_unlock_irq+0x3e/0x70)
> > [ 2517.250150]=A0 [<0000000197040cdc>] __wait_for_common+0xcc/0x240=20
> > [ 2517.250157]=A0 [<0000000196a5bf8e>] blk_execute_rq+0x126/0x1f8=20
> > [ 2517.250165]=A0 [<0000000196c84f32>] __scsi_execute+0x112/0x260=20
> > [ 2517.250172]=A0 [<000003ff7fb9d698>] alua_rtpg+0x138/0xb10
> > [scsi_dh_alua]=20
> > [ 2517.250179]=A0 [<000003ff7fb9e32c>] alua_rtpg_work+0x2bc/0x4e0
> > [scsi_dh_alua]=20
> > [ 2517.250186]=A0 [<000000019628c244>] process_one_work+0x30c/0x730=20
> > [ 2517.250197]=A0 [<000000019628c6ca>] worker_thread+0x62/0x420=20
> > [ 2517.250205]=A0 [<0000000196297b08>] kthread+0x138/0x150=20
> > [ 2517.250214]=A0 [<000000019620f92c>] __ret_from_fork+0x3c/0x58=20
> > [ 2517.250222]=A0 [<000000019704aa8a>] ret_from_fork+0xa/0x40=20
> > [ 2517.250229] 2 locks held by kworker/0:1/121221:
> > [ 2517.250235]=A0 #0: 000000008ba79148 ((wq_completion)kaluad){+.+.}-
> > {0:0}, at: process_one_work+0x232/0x730
> > [ 2517.250256]=A0 #1: 000003800695fdc8 ((work_completion)(&(&pg-
> > >rtpg_work)->work)){+.+.}-{0:0}, at: process_one_work+0x232/0x730
> > [ 2517.250276] Last Breaking-Event-Address:
> > [ 2517.250281]=A0 [<000000019701d85e>] __warn_printk+0x66/0x70
> > [ 2517.250291] Kernel panic - not syncing: kernel: panic_on_warn
> > set ...
>=20

I assume that Bart's previous reasoning applies here, too.
scsi_device_put() sleeps only if it releases the last reference to the
device. The calling stack, working on an I/O if the device in question,
must hold another reference to the scsi_device, so the ref being put
by alua_check->alua_rtpg_queue() can't be the last one.

Consequently, following this line of reasoning, we could remove the
might_sleep() in scsi_device_put(), too, eliminating this issue. But
that would mean that we couldn't detect possible other, actually broken
callers of scsi_device_put() any more, neither now nor in the future.

Perhaps we should introduce something like scsi_device_put_safe(),=20
to be called only from contexts where we are certain that another
reference must exists? It's the only possibility I see, but it doesn't
feel quite right.

Regards
Martin

