Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C8F8C3F68F
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 11:41:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E707321582
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 11:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="J6ieimEA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgAQLlW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 06:41:22 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41544 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgAQLlW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 06:41:22 -0500
Received: by mail-oi1-f196.google.com with SMTP id i1so21887816oie.8
        for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2020 03:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m9tAk/vstMKxuXcoj1wTHlsQe5jbJdQXyGqYu5AEc7E=;
        b=J6ieimEAWcnG5Ov5KWJoyyAUccaKRv0FLXoO8ZH2wRpNFVDXgwhm5a8oUBkpQCv1Eb
         M8RO4iqVkqnCOEQa+H/jGbAVXT0z+8htzmzzPku0KcewZD4TDd/hln0gce76dqXH7iHI
         YkrDF8rifx+eVaygwXkuf+zEdeg85fRVtZxJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m9tAk/vstMKxuXcoj1wTHlsQe5jbJdQXyGqYu5AEc7E=;
        b=sxEbVepuR87QqokHUPynuspWM6vsdcWADhTq4W7tv/GAyQz360BCSchfFvwXt8Z6oh
         xNssCGXVR3vNkYFVspStVGK5IH/aLkaV4ZGBmwthAXrI44YSj5ELo6fFSeJsRcrq5bxP
         M7w9AEqL/tC4o1GwOB76WUBcA6CbJymFcxbO16cDnD0Yluj6Cjqmbc5fO3ydr++iH5en
         6P9bRauUX0M6f7flj+163nBP2mR3r/qoDmisCpU0n2UHAPaYOWOco9K1+TmXcbhR8EsD
         V5mWrA7kgWP6QPTtfY3a8xxd+bRJMGYbUFTtJo6OtalCTJwe0UO6psKKgPbPwPLLBzzk
         34tA==
X-Gm-Message-State: APjAAAV3GWaXdOQHTR5LtJLtXX59SiktSljhGJ0Jcx+b3JqEypXV5IAn
        3ylTpR3gzfunY1Ol+Ex0ukrevkahLXJfPK0rCpv3Ww==
X-Google-Smtp-Source: APXvYqyp3W2/TTkGSBaOm7lrUVGCauAHu85T/opteccF5Rl6g4yrW9FqAcJdYPMR6O0nENi0PyNmT+OxLXXZaDYE/Os=
X-Received: by 2002:aca:889:: with SMTP id 131mr2944535oii.3.1579261280643;
 Fri, 17 Jan 2020 03:41:20 -0800 (PST)
MIME-Version: 1.0
References: <20191202153914.84722-1-hare@suse.de> <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
 <efe9c1e7-fa10-3bae-eacd-58d43295d6da@suse.de> <CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-L=g@mail.gmail.com>
 <11034edd-732a-3dd5-0bdc-891b9de05e56@huawei.com> <661fd3db-0254-c209-8fb3-f3aa35bac431@suse.de>
In-Reply-To: <661fd3db-0254-c209-8fb3-f3aa35bac431@suse.de>
From:   Sumit Saxena <sumit.saxena@broadcom.com>
Date:   Fri, 17 Jan 2020 17:10:53 +0530
Message-ID: <CAL2rwxomOp-S0TAYhnwJXVs=hEyUv9mYJ1cO0=NdGMo0hTAYcQ@mail.gmail.com>
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
To:     Hannes Reinecke <hare@suse.de>
Cc:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 14, 2020 at 12:35 PM Hannes Reinecke <hare@suse.de> wrote:
>
> On 1/13/20 6:42 PM, John Garry wrote:
> > On 10/01/2020 04:00, Sumit Saxena wrote:
> >> On Mon, Dec 9, 2019 at 4:32 PM Hannes Reinecke <hare@suse.de> wrote:
> >>>
> >>> On 12/9/19 11:10 AM, Sumit Saxena wrote:
> >>>> On Mon, Dec 2, 2019 at 9:09 PM Hannes Reinecke <hare@suse.de> wrote:
> >>>>>
> >>>>> Fusion adapters can steer completions to individual queues, and
> >>>>> we now have support for shared host-wide tags.
> >>>>> So we can enable multiqueue support for fusion adapters and
> >>>>> drop the hand-crafted interrupt affinity settings.
> >>>>
> >>>> Hi Hannes,
> >>>>
> >>>> Ming Lei also proposed similar changes in megaraid_sas driver some
> >>>> time back and it had resulted in performance drop-
> >>>> https://patchwork.kernel.org/patch/10969511/
> >>>>
> >>>> So, we will do some performance tests with this patch and update you=
.
> >>>> Thank you.
> >>>
> >>> I'm aware of the results of Ming Leis work, but I do hope this patchs=
et
> >>> performs better.
> >>>
> >>> And when you do performance measurements, can you please run with bot=
h,
> >>> 'none' I/O scheduler and 'mq-deadline' I/O scheduler?
> >>> I've measured quite a performance improvements when using mq-deadline=
,
> >>> up to the point where I've gotten on-par performance with the origina=
l,
> >>> non-mq, implementation.
> >>> (As a data point, on my setup I've measured about 270k IOPS and 1092
> >>> MB/s througput, running on just 2 SSDs).
> >>> asas_build_ldio_fusion
> >>> But thanks for doing a performance test here.
> >>
> >> Hi Hannes,
> >>
> >> Sorry for the delay in replying, I observed a few issues with this
> >> patchset:
> >>
> >> 1. "blk_mq_unique_tag_to_hwq(tag)" does not return MSI-x vector to
> >> which IO submitter CPU is affined with. Due to this IO submission and
> >> completion CPUs are different which causes performance drop for low
> >> latency workloads.
> >
> > Hi Sumit,
> >
> > So the new code has:
> >
> > megasas_build_ldio_fusion()
> > {
> >
> > cmd->request_desc->SCSIIO.MSIxIndex =3D
> > blk_mq_unique_tag_to_hwq(tag);
> >
> > }
> >
> > So the value here is hw queue index from blk-mq point of view, and not
> > megaraid_sas msix index, as you alluded to.
> >
> > So we get 80 msix, 8 are reserved for low_latency_index_start (that's
> > how it seems to me), and we report other 72 as #hw queues =3D 72 to SCS=
I
> > midlayer.
> >
> > So I think that this should be:
> >
> > cmd->request_desc->SCSIIO.MSIxIndex =3D
> > blk_mq_unique_tag_to_hwq(tag) + low_latency_index_start;
> >
> >
> Indeed, that sounds reasonable.
> (The whole queue mapping stuff isn't exactly well documented :-( )
>
> I'll be updating the patch.
>
> >>
> >> lspcu:
> >>
> >> # lscpu
> >> Architecture:          x86_64
> >> CPU op-mode(s):        32-bit, 64-bit
> >> Byte Order:            Little Endian
> >> CPU(s):                72
> >> On-line CPU(s) list:   0-71
> >> Thread(s) per core:    2
> >> Core(s) per socket:    18
> >> Socket(s):             2
> >> NUMA node(s):          2
> >> Vendor ID:             GenuineIntel
> >> CPU family:            6
> >> Model:                 85
> >> Model name:            Intel(R) Xeon(R) Gold 6150 CPU @ 2.70GHz
> >> Stepping:              4
> >> CPU MHz:               3204.246
> >> CPU max MHz:           3700.0000
> >> CPU min MHz:           1200.0000
> >> BogoMIPS:              5400.00
> >> Virtualization:        VT-x
> >> L1d cache:             32K
> >> L1i cache:             32K
> >> L2 cache:              1024K
> >> L3 cache:              25344K
> >> NUMA node0 CPU(s):     0-17,36-53
> >> NUMA node1 CPU(s):     18-35,54-71
> >> Flags:                 fpu vme de pse tsc msr pae mce cx8 apic sep
> >> mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht
> >> tm pbe s
> >> yscall nx pdpe1gb rdtscp lm constant_tsc art arch_perfmon pebs bts
> >> rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni pclmulqdq
> >> dtes64 monitor
> >> ds_cpl vmx smx est tm2 ssse3 sdbg fma cx16 xtpr pdcm pcid dca sse4_1
> >> sse4_2 x2apic movbe popcnt tsc_deadline_timer xsave avx f16c rdrand
> >> lahf_lm abm
> >> 3dnowprefetch cpuid_fault epb cat_l3 cdp_l3 invpcid_single intel_ppin
> >> mba tpr_shadow vnmi flexpriority ept vpid ept_ad fsgsbase tsc_adjust
> >> bmi1 hle
> >> avx2 smep bmi2 erms invpcid rtm cqm mpx rdt_a avx512f avx512dq rdseed
> >> adx smap clflushopt clwb intel_pt avx512cd avx512bw avx512vl xsaveopt
> >> xsavec
> >> xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_lo
> >>
> >>
> >
> > [snip]
> >
> >> 4. This patch removes below code from driver so what this piece of
> >> code does is broken-
> >>
> >>
> >> -                               if (instance->adapter_type >=3D
> >> INVADER_SERIES &&
> >> -                                   !instance->msix_combined) {
> >> -                                       instance->msix_load_balance =
=3D
> >> true;
> >> -                                       instance->smp_affinity_enable
> >> =3D false;
> >> -                               }
> >
> > Does this code need to be re-added? Would this have affected your test?
> > Primarily this patch was required to enable interrupt affinity on my
> machine (Lenovo RAID 930-8i).
> Can you give me some information why the code is present in the first
> place? Some hardware limitation, maybe?

Hi Hannes,
This code is for specific family of megaraid_sas adapters and Lenovo
RAID 930-8i belongs to them. For those adapters, we want to use
available HW queues in round robin fashion instead of using interrupt
affinity. It helps to improve performance and fixes soft lockups.
For interrupt affinity test purpose on Lenovo RAID 930-8i, you can
disable this code to use affinity. But in the final patch, this code
has to be present. This code was added through below commit:

commit 1d15d9098ad12b0021ac5a6b851f26d1ab021e5a
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Date:   Tue May 7 10:05:36 2019 -0700

    scsi: megaraid_sas: Load balance completions across all MSI-X

    Driver will use "reply descriptor post queues" in round robin fashion w=
hen
    the combined MSI-X mode is not enabled. With this IO completions are
    distributed and load balanced across all the available reply descriptor
    post queues equally.

    This is enabled only if combined MSI-X mode is not enabled in firmware.
    This improves performance and also fixes soft lockups.

    When load balancing is enabled, IRQ affinity from driver needs to be
    disabled.

    Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
    Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>


Thanks,
Sumit

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   Teamlead Storage & Networking
> hare@suse.de                                      +49 911 74053 688
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), GF: Felix Imend=C3=B6rffer
