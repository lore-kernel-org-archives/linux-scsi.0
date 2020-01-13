Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E292C3F68F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 17:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E325621569
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 17:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgAMRmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 12:42:24 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2262 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726109AbgAMRmY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 12:42:24 -0500
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id B1BE3156685E0162AFE2;
        Mon, 13 Jan 2020 17:42:21 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 Jan 2020 17:42:21 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 13 Jan
 2020 17:42:21 +0000
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
To:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        <linux-block@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
 <efe9c1e7-fa10-3bae-eacd-58d43295d6da@suse.de>
 <CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-L=g@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <11034edd-732a-3dd5-0bdc-891b9de05e56@huawei.com>
Date:   Mon, 13 Jan 2020 17:42:20 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-L=g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/01/2020 04:00, Sumit Saxena wrote:
> On Mon, Dec 9, 2019 at 4:32 PM Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 12/9/19 11:10 AM, Sumit Saxena wrote:
>>> On Mon, Dec 2, 2019 at 9:09 PM Hannes Reinecke <hare@suse.de> wrote:
>>>>
>>>> Fusion adapters can steer completions to individual queues, and
>>>> we now have support for shared host-wide tags.
>>>> So we can enable multiqueue support for fusion adapters and
>>>> drop the hand-crafted interrupt affinity settings.
>>>
>>> Hi Hannes,
>>>
>>> Ming Lei also proposed similar changes in megaraid_sas driver some
>>> time back and it had resulted in performance drop-
>>> https://patchwork.kernel.org/patch/10969511/
>>>
>>> So, we will do some performance tests with this patch and update you.
>>> Thank you.
>>
>> I'm aware of the results of Ming Leis work, but I do hope this patchset
>> performs better.
>>
>> And when you do performance measurements, can you please run with both,
>> 'none' I/O scheduler and 'mq-deadline' I/O scheduler?
>> I've measured quite a performance improvements when using mq-deadline,
>> up to the point where I've gotten on-par performance with the original,
>> non-mq, implementation.
>> (As a data point, on my setup I've measured about 270k IOPS and 1092
>> MB/s througput, running on just 2 SSDs).
>>asas_build_ldio_fusion
>> But thanks for doing a performance test here.
> 
> Hi Hannes,
> 
> Sorry for the delay in replying, I observed a few issues with this patchset:
> 
> 1. "blk_mq_unique_tag_to_hwq(tag)" does not return MSI-x vector to
> which IO submitter CPU is affined with. Due to this IO submission and
> completion CPUs are different which causes performance drop for low
> latency workloads.

Hi Sumit,

So the new code has:

megasas_build_ldio_fusion()
{

cmd->request_desc->SCSIIO.MSIxIndex =
blk_mq_unique_tag_to_hwq(tag);

}

So the value here is hw queue index from blk-mq point of view, and not 
megaraid_sas msix index, as you alluded to.

So we get 80 msix, 8 are reserved for low_latency_index_start (that's 
how it seems to me), and we report other 72 as #hw queues = 72 to SCSI 
midlayer.

So I think that this should be:

cmd->request_desc->SCSIIO.MSIxIndex =
blk_mq_unique_tag_to_hwq(tag) + low_latency_index_start;


> 
> lspcu:
> 
> # lscpu
> Architecture:          x86_64
> CPU op-mode(s):        32-bit, 64-bit
> Byte Order:            Little Endian
> CPU(s):                72
> On-line CPU(s) list:   0-71
> Thread(s) per core:    2
> Core(s) per socket:    18
> Socket(s):             2
> NUMA node(s):          2
> Vendor ID:             GenuineIntel
> CPU family:            6
> Model:                 85
> Model name:            Intel(R) Xeon(R) Gold 6150 CPU @ 2.70GHz
> Stepping:              4
> CPU MHz:               3204.246
> CPU max MHz:           3700.0000
> CPU min MHz:           1200.0000
> BogoMIPS:              5400.00
> Virtualization:        VT-x
> L1d cache:             32K
> L1i cache:             32K
> L2 cache:              1024K
> L3 cache:              25344K
> NUMA node0 CPU(s):     0-17,36-53
> NUMA node1 CPU(s):     18-35,54-71
> Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep
> mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht
> tm pbe s
> yscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts
> rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq
> dtes64 monitor
> ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1
> sse4_2 x2apic movbe popcnt tsc_deadline_timer xsave avx f16c rdrand
> lahf_lm abm
> 3dnowprefetch cpuid_fault epb cat_l3 cdp_l3 invpcid_single intel_ppin
> mba tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust
> bmi1 hle
> avx2 smep bmi2 erms invpcid rtm cqm mpx rdt_a avx512f avx512dq rdseed
> adx smap clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt
> xsavec
> xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_lo
> 
> 

[snip]

> 4. This patch removes below code from driver so what this piece of
> code does is broken-
> 
> 
> -                               if (instance->adapter_type >= INVADER_SERIES &&
> -                                   !instance->msix_combined) {
> -                                       instance->msix_load_balance = true;
> -                                       instance->smp_affinity_enable = false;
> -                               }

Does this code need to be re-added? Would this have affected your test?

Thanks,
John
