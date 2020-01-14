Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB9EC33CAE
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 07:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9CF2222C4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 07:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgANHFj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 02:05:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:53700 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbgANHFi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 02:05:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00923AEB1;
        Tue, 14 Jan 2020 07:05:34 +0000 (UTC)
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
To:     John Garry <john.garry@huawei.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
 <efe9c1e7-fa10-3bae-eacd-58d43295d6da@suse.de>
 <CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-L=g@mail.gmail.com>
 <11034edd-732a-3dd5-0bdc-891b9de05e56@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <661fd3db-0254-c209-8fb3-f3aa35bac431@suse.de>
Date:   Tue, 14 Jan 2020 08:05:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <11034edd-732a-3dd5-0bdc-891b9de05e56@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/13/20 6:42 PM, John Garry wrote:
> On 10/01/2020 04:00, Sumit Saxena wrote:
>> On Mon, Dec 9, 2019 at 4:32 PM Hannes Reinecke <hare@suse.de> wrote:
>>>
>>> On 12/9/19 11:10 AM, Sumit Saxena wrote:
>>>> On Mon, Dec 2, 2019 at 9:09 PM Hannes Reinecke <hare@suse.de> wrote:
>>>>>
>>>>> Fusion adapters can steer completions to individual queues, and
>>>>> we now have support for shared host-wide tags.
>>>>> So we can enable multiqueue support for fusion adapters and
>>>>> drop the hand-crafted interrupt affinity settings.
>>>>
>>>> Hi Hannes,
>>>>
>>>> Ming Lei also proposed similar changes in megaraid_sas driver some
>>>> time back and it had resulted in performance drop-
>>>> https://patchwork.kernel.org/patch/10969511/
>>>>
>>>> So, we will do some performance tests with this patch and update you.
>>>> Thank you.
>>>
>>> I'm aware of the results of Ming Leis work, but I do hope this patchset
>>> performs better.
>>>
>>> And when you do performance measurements, can you please run with both,
>>> 'none' I/O scheduler and 'mq-deadline' I/O scheduler?
>>> I've measured quite a performance improvements when using mq-deadline,
>>> up to the point where I've gotten on-par performance with the original,
>>> non-mq, implementation.
>>> (As a data point, on my setup I've measured about 270k IOPS and 1092
>>> MB/s througput, running on just 2 SSDs).
>>> asas_build_ldio_fusion
>>> But thanks for doing a performance test here.
>>
>> Hi Hannes,
>>
>> Sorry for the delay in replying, I observed a few issues with this
>> patchset:
>>
>> 1. "blk_mq_unique_tag_to_hwq(tag)" does not return MSI-x vector to
>> which IO submitter CPU is affined with. Due to this IO submission and
>> completion CPUs are different which causes performance drop for low
>> latency workloads.
> 
> Hi Sumit,
> 
> So the new code has:
> 
> megasas_build_ldio_fusion()
> {
> 
> cmd->request_desc->SCSIIO.MSIxIndex =
> blk_mq_unique_tag_to_hwq(tag);
> 
> }
> 
> So the value here is hw queue index from blk-mq point of view, and not
> megaraid_sas msix index, as you alluded to.
> 
> So we get 80 msix, 8 are reserved for low_latency_index_start (that's
> how it seems to me), and we report other 72 as #hw queues = 72 to SCSI
> midlayer.
> 
> So I think that this should be:
> 
> cmd->request_desc->SCSIIO.MSIxIndex =
> blk_mq_unique_tag_to_hwq(tag) + low_latency_index_start;
> 
> 
Indeed, that sounds reasonable.
(The whole queue mapping stuff isn't exactly well documented :-( )

I'll be updating the patch.

>>
>> lspcu:
>>
>> # lscpu
>> Architecture:          x86_64
>> CPU op-mode(s):        32-bit, 64-bit
>> Byte Order:            Little Endian
>> CPU(s):                72
>> On-line CPU(s) list:   0-71
>> Thread(s) per core:    2
>> Core(s) per socket:    18
>> Socket(s):             2
>> NUMA node(s):          2
>> Vendor ID:             GenuineIntel
>> CPU family:            6
>> Model:                 85
>> Model name:            Intel(R) Xeon(R) Gold 6150 CPU @ 2.70GHz
>> Stepping:              4
>> CPU MHz:               3204.246
>> CPU max MHz:           3700.0000
>> CPU min MHz:           1200.0000
>> BogoMIPS:              5400.00
>> Virtualization:        VT-x
>> L1d cache:             32K
>> L1i cache:             32K
>> L2 cache:              1024K
>> L3 cache:              25344K
>> NUMA node0 CPU(s):     0-17,36-53
>> NUMA node1 CPU(s):     18-35,54-71
>> Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep
>> mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht
>> tm pbe s
>> yscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts
>> rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq
>> dtes64 monitor
>> ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1
>> sse4_2 x2apic movbe popcnt tsc_deadline_timer xsave avx f16c rdrand
>> lahf_lm abm
>> 3dnowprefetch cpuid_fault epb cat_l3 cdp_l3 invpcid_single intel_ppin
>> mba tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust
>> bmi1 hle
>> avx2 smep bmi2 erms invpcid rtm cqm mpx rdt_a avx512f avx512dq rdseed
>> adx smap clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt
>> xsavec
>> xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_lo
>>
>>
> 
> [snip]
> 
>> 4. This patch removes below code from driver so what this piece of
>> code does is broken-
>>
>>
>> -                               if (instance->adapter_type >=
>> INVADER_SERIES &&
>> -                                   !instance->msix_combined) {
>> -                                       instance->msix_load_balance =
>> true;
>> -                                       instance->smp_affinity_enable
>> = false;
>> -                               }
> 
> Does this code need to be re-added? Would this have affected your test?
> Primarily this patch was required to enable interrupt affinity on my
machine (Lenovo RAID 930-8i).
Can you give me some information why the code is present in the first
place? Some hardware limitation, maybe?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
