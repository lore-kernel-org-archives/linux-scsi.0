Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42746C38142
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 11:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbjAXLQp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 06:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbjAXLQk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 06:16:40 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5E743440;
        Tue, 24 Jan 2023 03:16:38 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O8g8pf000611;
        Tue, 24 Jan 2023 11:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=rpolTQuwHV1lS3BxGOgvqmpk76zJd3hh4zwl41iU98o=;
 b=mGE5/iZDV05YkUXRrDqhxK3Fpb4EFPDJJbZE+KVIHCxX6HyFEoUFmTw2LSxbL+P0J2JK
 wxCS7wShcMtQi/deVWGvi96TFFtuSQ7gfcoq9jPnvhK/C1qOm/B67sEVBKHhFhCguiAI
 drJaSWl6+tM23qwVhyMXtY4vzoSpOy/dxzW0TsX3Yavns5wXNBn+hlx/1slfeXFZZbQ8
 I9cGw6BAetJr6Yg1iNoizRawaCsoA9ih9IK2J0svTmjVQiX2SWyDxfznowdHcw8EDmy/
 B9+1tCUNcqR7Qc8Yaps2+thOrAmBjypC8QpGJc5b8+3y0RXKl4RuGBgCvXJ2VYc/eqQZ Ow== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nac1yucfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 11:16:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30O9kJpV014950;
        Tue, 24 Jan 2023 11:16:25 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3n87afbq58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Jan 2023 11:16:25 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30OBGLpm21299528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 11:16:21 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE23B2004D;
        Tue, 24 Jan 2023 11:16:21 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A49120040;
        Tue, 24 Jan 2023 11:16:21 +0000 (GMT)
Received: from [9.152.212.243] (unknown [9.152.212.243])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 24 Jan 2023 11:16:21 +0000 (GMT)
Message-ID: <55c35e64-a7d4-9072-46fd-e8eae6a90e96@linux.ibm.com>
Date:   Tue, 24 Jan 2023 12:16:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
Content-Language: en-US
From:   Steffen Maier <maier@linux.ibm.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
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
In-Reply-To: <f39fb7d2-f0ec-ea53-a3a9-eb86b8367e82@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 49VS29CHpqpgyYwu9n9qEDWWraxmMPkM
X-Proofpoint-ORIG-GUID: 49VS29CHpqpgyYwu9n9qEDWWraxmMPkM
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240101
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/18/23 17:17, Steffen Maier wrote:
> On 1/18/23 01:29, Bart Van Assche wrote:
>> On 1/17/23 14:03, Martin Wilck wrote:
>>> On Tue, 2023-01-17 at 13:52 -0800, Bart Van Assche wrote:
>>>> On 1/17/23 13:48, Martin Wilck wrote:
>>>>> Yes, that was my suggestion. Just defer the scsi_device_put() call
>>>>> in
>>>>> alua_rtpg_queue() in the case where the actual RTPG handler is not
>>>>> queued. I won't have time for that before next week though.

>> [PATCH] scsi: device_handler: alua: Remove a might_sleep() annotation
>>
>> The might_sleep() annotation in alua_rtpg_queue() is not correct since the
>> command completion code may call this function from atomic context.
>> Calling alua_rtpg_queue() from atomic context in the command completion
>> path is fine since request submitters must hold an sdev reference until
>> command execution has completed. This patch fixes the following kernel
>> warning:
>>
>> BUG: sleeping function called from invalid context at 
>> drivers/scsi/device_handler/scsi_dh_alua.c:992
>> Call Trace:
>>   dump_stack_lvl+0xac/0x100
>>   __might_resched+0x284/0x2c8
>>   alua_rtpg_queue+0x3c/0x98 [scsi_dh_alua]
>>   alua_check+0x122/0x250 [scsi_dh_alua]
>>   alua_check_sense+0x172/0x228 [scsi_dh_alua]
>>   scsi_check_sense+0x8a/0x2e0
>>   scsi_decide_disposition+0x286/0x298
>>   scsi_complete+0x6a/0x108
>>   blk_complete_reqs+0x6e/0x88
>>   __do_softirq+0x13e/0x6b8
>>   __irq_exit_rcu+0x14a/0x170
>>   irq_exit_rcu+0x22/0x50
>>   do_ext_irq+0x10a/0x1d0
>>
>> Reported-by: Steffen Maier <maier@linux.ibm.com>
>> Cc: Steffen Maier <maier@linux.ibm.com>
>> Cc: Martin Wilck <mwilck@suse.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c 
>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 55a5073248f8..362fa631f39b 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -987,6 +987,9 @@ static void alua_rtpg_work(struct work_struct *work)
>>    *
>>    * Returns true if and only if alua_rtpg_work() will be called asynchronously.
>>    * That function is responsible for calling @qdata->fn().
>> + *
>> + * Context: may be called from atomic context (alua_check()) only if the caller
>> + *    holds an sdev reference.
>>    */
>>   static bool alua_rtpg_queue(struct alua_port_group *pg,
>>                   struct scsi_device *sdev,
>> @@ -995,8 +998,6 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
>>       int start_queue = 0;
>>       unsigned long flags;
>>
>> -    might_sleep();
>> -
> 
> I had removed those two lines yesterday for our CI kernel build.
> Tonight's run obviously no longer had any related BUG or WARNING.
> I checked all dumps from that run to see if anything stalled and whether it was 
> related to ALUA, but I think we're good.
> 
> Tested-by: Steffen Maier <maier@linux.ibm.com>

I'm afraid, that might have been too early.
Today, I got BUG/WARNING with a slightly different stack trace where 
alua_rtpg_queue calls scsi_device_put(), which in turn contains a might_sleep 
but seems called in atomic context:

> [ 2517.231562] sd 13:0:0:1073823768: Power-on or device reset occurred
> [ 2517.231582] sd 13:0:0:1073823768: [sdax] tag#2787 Done: ADD_TO_MLQUEUE Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
> [ 2517.231590] sd 13:0:0:1073823768: [sdax] tag#2787 CDB: Test Unit Ready 00 00 00 00 00 00
> [ 2517.231598] sd 13:0:0:1073823768: [sdax] tag#2787 Sense Key : Unit Attention [current] 
> [ 2517.231605] sd 13:0:0:1073823768: [sdax] tag#2787 Add. Sense: Power on, reset, or bus device reset occurred
> [ 2517.236104] sd 13:0:0:1074348056: Power-on or device reset occurred
> [ 2517.236124] BUG: sleeping function called from invalid context at drivers/scsi/scsi.c:591
> [ 2517.236130] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 166768, name: systemd-udevd
> [ 2517.236137] preempt_count: 100, expected: 0
> [ 2517.236143] RCU nest depth: 0, expected: 0
> [ 2517.236148] no locks held by systemd-udevd/166768.
> [ 2517.236154] Preemption disabled at:
> [ 2517.236157] [<000000019704d22e>] __do_softirq+0x5e/0x6b8
> [ 2517.236177] CPU: 2 PID: 166768 Comm: systemd-udevd Tainted: G              K    6.2.0-20230123.rc5.git2.9dea08313ff5.300.fc37.s390x+debug #1
> [ 2517.236185] Hardware name: IBM 8561 T01 703 (z/VM 7.3.0)
> [ 2517.236190] Call Trace:
> [ 2517.236195]  [<00000001970367cc>] dump_stack_lvl+0xac/0x100 
> [ 2517.236203]  [<00000001962a590c>] __might_resched+0x284/0x2c8 
> [ 2517.236213]  [<0000000196c7b34a>] scsi_device_put+0x42/0x60 
> [ 2517.236224]  [<000003ff7fb9c57e>] alua_rtpg_queue.part.0+0xce/0x348 [scsi_dh_alua] 
> [ 2517.236234]  [<000003ff7fb9d20a>] alua_check+0x132/0x260 [scsi_dh_alua] 
> [ 2517.236241]  [<000003ff7fb9d4aa>] alua_check_sense+0x172/0x228 [scsi_dh_alua] 
> [ 2517.236248]  [<0000000196c7fd0e>] scsi_check_sense+0x86/0x2e0 
> [ 2517.236256]  [<0000000196c82cc6>] scsi_decide_disposition+0x286/0x298 
> [ 2517.236262]  [<0000000196c873da>] scsi_complete+0x6a/0x108 
> [ 2517.236269]  [<0000000196a5aeea>] blk_complete_reqs+0x6a/0x88 
> [ 2517.236281]  [<000000019704d30a>] __do_softirq+0x13a/0x6b8 
> [ 2517.236287]  [<000000019626b802>] __irq_exit_rcu+0x14a/0x170 
> [ 2517.236297]  [<000000019626c372>] irq_exit_rcu+0x22/0x50 
> [ 2517.236303]  [<0000000197036fda>] do_ext_irq+0xba/0x1d0 
> [ 2517.236309]  [<000000019704ad06>] ext_int_handler+0xd6/0x110 
> [ 2517.236315]  [<00000001963accd2>] seccomp_run_filters+0x9a/0x198 
> [ 2517.236328]  [<00000001963ad5bc>] __seccomp_filter+0x4c/0x3b8 
> [ 2517.236334]  [<0000000196335f1a>] syscall_trace_enter.constprop.0+0xda/0x310 
> [ 2517.236345]  [<0000000197036bf0>] __do_syscall+0xf0/0x208 
> [ 2517.236350]  [<000000019704aa52>] system_call+0x82/0xb0 
> [ 2517.236356] no locks held by systemd-udevd/166768.

The same can also happen outside of process context, where it happened to run 
alua_rtpg() before an IRQ happened for :

> [ 2517.249685] ------------[ cut here ]------------
> [ 2517.249691] do not call blocking ops when !TASK_RUNNING; state=2 set at [<0000000197040cb2>] __wait_for_common+0xa2/0x240
> [ 2517.249710] WARNING: CPU: 0 PID: 121221 at kernel/sched/core.c:9959 __might_sleep+0x7c/0x98
> [ 2517.249719] Modules linked in: kvm af_iucv algif_hash af_alg nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink dm_service_time sunrpc zfcp scsi_transport_fc s390_trng vfio_ccw mdev vfio_iommu_type1 vfio sch_fq_codel ip6_tables ip_tables x_tables configfs ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 nvme sha512_s390 sha256_s390 sha1_s390 sha_common nvme_core scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey zcrypt rng_core dm_multipath autofs4
> [ 2517.249869] Unloaded tainted modules: test_klp_state3(K):1 test_klp_state2(K):4 test_klp_state(K):3 test_klp_callbacks_demo2(K):2 test_klp_callbacks_demo(K):12 test_klp_atomic_replace(K):2 test_klp_livepatch(K):6 [last unloaded: test_klp_callbacks_demo(K)]
> [ 2517.249907] CPU: 0 PID: 121221 Comm: kworker/0:1 Tainted: G        W     K    6.2.0-20230123.rc5.git2.9dea08313ff5.300.fc37.s390x+debug #1
> [ 2517.249915] Hardware name: IBM 8561 T01 703 (z/VM 7.3.0)
> [ 2517.249921] Workqueue: kaluad alua_rtpg_work [scsi_dh_alua]
> [ 2517.249931] Krnl PSW : 0704d00180000000 00000001962a59d0 (__might_sleep+0x80/0x98)
> [ 2517.249944]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
> [ 2517.249953] Krnl GPRS: c0000000ffffbfff 0000000080000101 000000000000006d 00000001974ae114
> [ 2517.249960]            0000037ffff339a0 0000037ffff33998 0000000000000000 0000000000000001
> [ 2517.249966]            0700037ffff33b50 00000000be69c000 000000000000024f 00000001974cb458
> [ 2517.249973]            00000000a4080100 00000000a5344220 00000001962a59cc 0000037ffff33b30
> [ 2517.249985] Krnl Code: 00000001962a59c0: c020008c269f	larl	%r2,000000019742a6fe
>                           00000001962a59c6: c0e5006bbf19	brasl	%r14,000000019701d7f8
>                          #00000001962a59cc: af000000		mc	0,0
>                          >00000001962a59d0: a7490000		lghi	%r4,0
>                           00000001962a59d4: b904003a		lgr	%r3,%r10
>                           00000001962a59d8: b904002b		lgr	%r2,%r11
>                           00000001962a59dc: ebaff0a00004	lmg	%r10,%r15,160(%r15)
>                           00000001962a59e2: c0f4fffffe53	brcl	15,00000001962a5688
> [ 2517.250023] Call Trace:
> [ 2517.250028]  [<00000001962a59d0>] __might_sleep+0x80/0x98 
> [ 2517.250036] ([<00000001962a59cc>] __might_sleep+0x7c/0x98)
> [ 2517.250043]  [<0000000196c7b34a>] scsi_device_put+0x42/0x60 
> [ 2517.250050]  [<000003ff7fb9c57e>] alua_rtpg_queue.part.0+0xce/0x348 [scsi_dh_alua] 
> [ 2517.250058]  [<000003ff7fb9d20a>] alua_check+0x132/0x260 [scsi_dh_alua] 
> [ 2517.250066]  [<000003ff7fb9d4aa>] alua_check_sense+0x172/0x228 [scsi_dh_alua] 
> [ 2517.250073]  [<0000000196c7fd0e>] scsi_check_sense+0x86/0x2e0 
> [ 2517.250080]  [<0000000196c82cc6>] scsi_decide_disposition+0x286/0x298 
> [ 2517.250087]  [<0000000196c873da>] scsi_complete+0x6a/0x108 
> [ 2517.250095]  [<0000000196a5aeea>] blk_complete_reqs+0x6a/0x88 
> [ 2517.250102]  [<000000019704d30a>] __do_softirq+0x13a/0x6b8 
> [ 2517.250109]  [<000000019626b802>] __irq_exit_rcu+0x14a/0x170 
> [ 2517.250116]  [<000000019626c372>] irq_exit_rcu+0x22/0x50 
> [ 2517.250123]  [<0000000197036fda>] do_ext_irq+0xba/0x1d0 
> [ 2517.250130]  [<000000019704ad06>] ext_int_handler+0xd6/0x110 
> [ 2517.250136]  [<0000000197049ac2>] _raw_spin_unlock_irq+0x42/0x70 
> [ 2517.250143] ([<0000000197049abe>] _raw_spin_unlock_irq+0x3e/0x70)
> [ 2517.250150]  [<0000000197040cdc>] __wait_for_common+0xcc/0x240 
> [ 2517.250157]  [<0000000196a5bf8e>] blk_execute_rq+0x126/0x1f8 
> [ 2517.250165]  [<0000000196c84f32>] __scsi_execute+0x112/0x260 
> [ 2517.250172]  [<000003ff7fb9d698>] alua_rtpg+0x138/0xb10 [scsi_dh_alua] 
> [ 2517.250179]  [<000003ff7fb9e32c>] alua_rtpg_work+0x2bc/0x4e0 [scsi_dh_alua] 
> [ 2517.250186]  [<000000019628c244>] process_one_work+0x30c/0x730 
> [ 2517.250197]  [<000000019628c6ca>] worker_thread+0x62/0x420 
> [ 2517.250205]  [<0000000196297b08>] kthread+0x138/0x150 
> [ 2517.250214]  [<000000019620f92c>] __ret_from_fork+0x3c/0x58 
> [ 2517.250222]  [<000000019704aa8a>] ret_from_fork+0xa/0x40 
> [ 2517.250229] 2 locks held by kworker/0:1/121221:
> [ 2517.250235]  #0: 000000008ba79148 ((wq_completion)kaluad){+.+.}-{0:0}, at: process_one_work+0x232/0x730
> [ 2517.250256]  #1: 000003800695fdc8 ((work_completion)(&(&pg->rtpg_work)->work)){+.+.}-{0:0}, at: process_one_work+0x232/0x730
> [ 2517.250276] Last Breaking-Event-Address:
> [ 2517.250281]  [<000000019701d85e>] __warn_printk+0x66/0x70
> [ 2517.250291] Kernel panic - not syncing: kernel: panic_on_warn set ...



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

