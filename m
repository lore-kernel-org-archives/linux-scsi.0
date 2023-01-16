Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A2DC67871
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 15:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjAPPK6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 10:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjAPPKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 10:10:34 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D65D27D79;
        Mon, 16 Jan 2023 06:59:17 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30GEsZZU011573;
        Mon, 16 Jan 2023 14:59:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date : to :
 cc : from : subject : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=LfmRVAKrg1KKjTGOMnqqHEJUeK8cz5DecmLGkyoCUAM=;
 b=fg/uOrOzaDfKT0M7iqeylBi65rTtIVtdvXODNNTav6hnDdvOl1SXrsU3iBsRYMAd+8kV
 ++fpn6Bl1ShPF6Ybscj9meNu3MJfIYWFnWfPwhTfYpT9QhB9oggeDvg/QTddZxe1r20S
 Mg6XjJrXxgf4mK7R4pLqAGIGwkJGnq3M8lvquSytsT2LIfx3aKPiMBo7LU0F/xvaV3pY
 AOi9khGos6Pb1u9+NyGjf4TbqHGgcVfgkEEV9MSWQJPG6e1k1AFsQZOCNloSDGT5nM1z
 6kxHWn7CMrY73B/uGDcriC6VHfpW2pkdpFdHoCaIeAnTlrvgFFYw0oD3mKRc8wKp3cvi PA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3n58rk03cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 14:59:09 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30GD0W8b002192;
        Mon, 16 Jan 2023 14:59:08 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3n3knf9vx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 Jan 2023 14:59:07 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30GEx48a23855816
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Jan 2023 14:59:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 11BB62004B;
        Mon, 16 Jan 2023 14:59:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62ED920040;
        Mon, 16 Jan 2023 14:59:03 +0000 (GMT)
Received: from [9.179.29.96] (unknown [9.179.29.96])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 16 Jan 2023 14:59:03 +0000 (GMT)
Message-ID: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
Date:   Mon, 16 Jan 2023 15:59:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     linux-scsi <linux-scsi@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
From:   Steffen Maier <maier@linux.ibm.com>
Subject: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FslCIfZgy257hbHK1BNEtHwOwIaxjEEA
X-Proofpoint-ORIG-GUID: FslCIfZgy257hbHK1BNEtHwOwIaxjEEA
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-16_12,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1011
 phishscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301160109
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

since a few days/weeks, we sometimes see below alua and sleep related kernel 
BUG and WARNING (with panic_on_warn) in our CI.

It reminds me of
[PATCH 0/2] Rework how the ALUA driver calls scsi_device_put()
https://lore.kernel.org/linux-scsi/166986602290.2101055.17397734326843853911.b4-ty@oracle.com/

which I thought was the fix and went into 6.2-rc(1?) on 2022-12-14 with
[GIT PULL] first round of SCSI updates for the 6.1+ merge window
https://lore.kernel.org/linux-scsi/b2e824bbd1e40da64d2d01657f2f7a67b98919fb.camel@HansenPartnership.com/T/#u

Due to limited history, I cannot tell exactly when problems started and whether 
it really correlates to above.

Test workload are all kinds of coverage tests for zfcp recovery including scsi 
device removal and/or rescan.

[ 4569.045992] BUG: sleeping function called from invalid context at 
drivers/scsi/device_handler/scsi_dh_alua.c:992
[ 4569.046003] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: 
swapper/8
[ 4569.046013] preempt_count: 101, expected: 0
[ 4569.046023] RCU nest depth: 0, expected: 0
[ 4569.046033] no locks held by swapper/8/0.
[ 4569.046042] Preemption disabled at:
[ 4569.046046] [<000000017e27ce4e>] __slab_alloc.constprop.0+0x36/0xb8
[ 4569.046072] CPU: 8 PID: 0 Comm: swapper/8 Tainted: G        W 
6.2.0-20230114.rc3.git0.46e26dd43df0.300.fc37.s390x+debug #1
[ 4569.046084] Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
[ 4569.046094] Call Trace:
[ 4569.046102]  [<000000017ed21bcc>] dump_stack_lvl+0xac/0x100
[ 4569.046118]  [<000000017df9192c>] __might_resched+0x284/0x2c8
[ 4569.046131]  [<000003ff7fb9c874>] alua_rtpg_queue+0x3c/0x98 [scsi_dh_alua]
[ 4569.046146]  [<000003ff7fb9cfb2>] alua_check+0x122/0x250 [scsi_dh_alua]
[ 4569.046167]  [<000003ff7fb9d562>] alua_check_sense+0x172/0x228 [scsi_dh_alua]
[ 4569.046179]  [<000000017e96b3e2>] scsi_check_sense+0x8a/0x2e0
[ 4569.046191]  [<000000017e96e4b6>] scsi_decide_disposition+0x286/0x298
[ 4569.046201]  [<000000017e972bca>] scsi_complete+0x6a/0x108
[ 4569.046212]  [<000000017e746906>] blk_complete_reqs+0x6e/0x88
[ 4569.046227]  [<000000017ed3830e>] __do_softirq+0x13e/0x6b8
[ 4569.046238]  [<000000017df57902>] __irq_exit_rcu+0x14a/0x170
[ 4569.046264]  [<000000017df58472>] irq_exit_rcu+0x22/0x50
[ 4569.046275]  [<000000017ed2242a>] do_ext_irq+0x10a/0x1d0
[ 4569.046286]  [<000000017ed36156>] ext_int_handler+0xd6/0x110
[ 4569.046296]  [<000000017ed362e6>] psw_idle_exit+0x0/0xa
[ 4569.046307] ([<000000017defc5da>] arch_cpu_idle+0x52/0xe0)
[ 4569.046318]  [<000000017ed34744>] default_idle_call+0x84/0xd0
[ 4569.046329]  [<000000017dfbe4cc>] do_idle+0xfc/0x1b8
[ 4569.046340]  [<000000017dfbe80e>] cpu_startup_entry+0x36/0x40
[ 4569.046350]  [<000000017df11964>] smp_start_secondary+0x14c/0x160
[ 4569.046371]  [<000000017ed3658e>] restart_int_handler+0x6e/0x90
[ 4569.046381] no locks held by swapper/8/0.

Above occurs a few times until it finally ends with:

[ 4760.865496] device-mapper: multipath: 251:6: Reinstating path 8:176.
[ 4760.867398] sd 4:0:0:1083719810: Power-on or device reset occurred
[ 4760.867445] sd 4:0:0:1083719810: [sde] tag#1224 Done: ADD_TO_MLQUEUE Result: 
hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[ 4760.867469] sd 4:0:0:1083719810: [sde] tag#1224 CDB: Test Unit Ready 00 00 
00 00 00 00
[ 4760.867493] sd 4:0:0:1083719810: [sde] tag#1224 Sense Key : Unit Attention 
[current]
[ 4760.867515] sd 4:0:0:1083719810: [sde] tag#1224 Add. Sense: Power on, reset, 
or bus device reset occurred
[ 4760.878066] sd 4:0:0:1083719813: Power-on or device reset occurred
[ 4760.878096] ------------[ cut here ]------------
[ 4760.878107] do not call blocking ops when !TASK_RUNNING; state=2 set at 
[<000000017ed2c0fa>] __wait_for_common+0xa2/0x240
[ 4760.878132] WARNING: CPU: 3 PID: 165738 at kernel/sched/core.c:9908 
__might_sleep+0x7c/0x98
[ 4760.878147] Modules linked in: af_iucv kvm algif_hash af_alg nft_fib_inet 
nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 
nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 
nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc vfio_ccw mdev vfio_iommu_type1 
vfio sch_fq_codel ip6_tables ip_tables x_tables configfs dm_service_time 
ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 libdes sha512_s390 
sha256_s390 sha1_s390 sha_common zfcp scsi_transport_fc dm_mirror 
dm_region_hash dm_log scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey zcrypt 
rng_core dm_multipath autofs4
[ 4760.878456] CPU: 3 PID: 165738 Comm: kworker/3:0 Tainted: G        W 
  6.2.0-20230114.rc3.git0.46e26dd43df0.300.fc37.s390x+debug #1
[ 4760.878478] Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
[ 4760.878489] Workqueue: kaluad alua_rtpg_work [scsi_dh_alua]
[ 4760.878509] Krnl PSW : 0704d00180000000 000000017df919f0 
(__might_sleep+0x80/0x98)
[ 4760.878542]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 
RI:0 EA:3
[ 4760.878560] Krnl GPRS: c0000000ffffbfff 0000000080000101 000000000000006d 
000000017f198e94
[ 4760.878573]            00000380002739f8 00000380002739f0 0000000000000000 
000000017f7bca48
[ 4760.878586]            0000000000000001 0000000000000000 00000000000003e0 
000003ff7fb9f1bc
[ 4760.878599]            00000000827eb100 0000000000000101 000000017df919ec 
0000038000273b88
[ 4760.878620] Krnl Code: 000000017df919e0: c020008c1da3	larl	%r2,000000017f115526
                           000000017df919e6: c0e5006bb91d	brasl 
%r14,000000017ed08c20
                          #000000017df919ec: af000000		mc	0,0
                          >000000017df919f0: a7490000		lghi	%r4,0
                           000000017df919f4: b904003a		lgr	%r3,%r10
                           000000017df919f8: b904002b		lgr	%r2,%r11
                           000000017df919fc: ebaff0a00004	lmg	%r10,%r15,160(%r15)
                           000000017df91a02: c0f4fffffe53	brcl	15,000000017df916a8
[ 4760.878692] Call Trace:
[ 4760.878703]  [<000000017df919f0>] __might_sleep+0x80/0x98
[ 4760.878716] ([<000000017df919ec>] __might_sleep+0x7c/0x98)
[ 4760.878728]  [<000003ff7fb9c874>] alua_rtpg_queue+0x3c/0x98 [scsi_dh_alua]
[ 4760.878743]  [<000003ff7fb9cfb2>] alua_check+0x122/0x250 [scsi_dh_alua]
[ 4760.878761]  [<000003ff7fb9d562>] alua_check_sense+0x172/0x228 [scsi_dh_alua]
[ 4760.878775]  [<000000017e96b3e2>] scsi_check_sense+0x8a/0x2e0
[ 4760.878788]  [<000000017e96e4b6>] scsi_decide_disposition+0x286/0x298
[ 4760.878802]  [<000000017e972bca>] scsi_complete+0x6a/0x108
[ 4760.878815]  [<000000017e746906>] blk_complete_reqs+0x6e/0x88
[ 4760.878837]  [<000000017ed3830e>] __do_softirq+0x13e/0x6b8
[ 4760.878852]  [<000000017df57902>] __irq_exit_rcu+0x14a/0x170
[ 4760.878866]  [<000000017df58472>] irq_exit_rcu+0x22/0x50
[ 4760.878880]  [<000000017ed223da>] do_ext_irq+0xba/0x1d0
[ 4760.878896]  [<000000017ed36156>] ext_int_handler+0xd6/0x110
[ 4760.878909]  [<000000017ed34fbe>] _raw_spin_unlock_irqrestore+0x86/0xc0
[ 4760.878928] ([<000000017ed34fae>] _raw_spin_unlock_irqrestore+0x76/0xc0)
[ 4760.878941]  [<000000017e033e66>] __mod_timer+0x2d6/0x408
[ 4760.878955]  [<000000017ed33864>] schedule_timeout+0xc4/0x168
[ 4760.878969]  [<000000017ed2ac62>] io_schedule_timeout+0x5a/0x80
[ 4760.878983]  [<000000017ed2c12e>] __wait_for_common+0xd6/0x240
[ 4760.878997]  [<000000017e7479a6>] blk_execute_rq+0x126/0x1f8
[ 4760.879011]  [<000000017e970722>] __scsi_execute+0x112/0x260
[ 4760.879024]  [<000003ff7fb9d750>] alua_rtpg+0x138/0xb10 [scsi_dh_alua]
[ 4760.879038]  [<000003ff7fb9e3e4>] alua_rtpg_work+0x2bc/0x4e0 [scsi_dh_alua]
[ 4760.879053]  [<000000017df78300>] process_one_work+0x310/0x730
[ 4760.879069]  [<000000017df78782>] worker_thread+0x62/0x420
[ 4760.879109]  [<000000017df83bc4>] kthread+0x13c/0x150
[ 4760.879124]  [<000000017defb930>] __ret_from_fork+0x40/0x58
[ 4760.879138]  [<000000017ed35eda>] ret_from_fork+0xa/0x40
[ 4760.879152] 2 locks held by kworker/3:0/165738:
[ 4760.879165]  #0: 000000008c7b5948 ((wq_completion)kaluad){+.+.}-{0:0}, at: 
process_one_work+0x232/0x730
[ 4760.879210]  #1: 0000038001177dc8 
((work_completion)(&(&pg->rtpg_work)->work)){+.+.}-{0:0}, at: 
process_one_work+0x232/0x730
[ 4760.879249] Last Breaking-Event-Address:
[ 4760.879266]  [<000000017e8c6dd0>] __s390_indirect_jump_r14+0x0/0x10
[ 4760.879283] Kernel panic - not syncing: kernel: panic_on_warn set ...


-- 
Mit freundlichen Gruessen / Kind regards
Steffen Maier

Linux on IBM Z and LinuxONE

https://www.ibm.com/privacy/us/en/
IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschaeftsfuehrung: David Faller
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
