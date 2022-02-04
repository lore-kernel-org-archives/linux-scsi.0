Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C37C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 08:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350991AbiBDIYt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Feb 2022 03:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346406AbiBDIYs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2022 03:24:48 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E49C061401
        for <linux-scsi@vger.kernel.org>; Fri,  4 Feb 2022 00:24:48 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ah7so16946103ejc.4
        for <linux-scsi@vger.kernel.org>; Fri, 04 Feb 2022 00:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+AJzw4pLVP6piQQ8DJ6FcW2rv83/BHBjZGX/F+I/5C4=;
        b=Be5ov5gRTokjg21xyNf+ohGtnsQqDmD5CpogVJAXrnVz7pcHBReU3EKuZVtKt4Tw/w
         RDcn4+ueTA4m3ociZUooQ/VSUz3b9a58vjo7nJ/Hli8DSbbZtEPUvDVwZH40LA/ByK1h
         mkWQHDVpTChQTI+dNdwTriPMcFCGtP4xz0vuE6s8JoGHah/8CmMO+m7uOrLICrWvo7I0
         G0FCSCS1JRJJr87Ow3i8npF6I4zG3xBdyz0bittGNIKmc8CnFGCEP83qtpr4iUUrGgFK
         skH8Hp0XEyEDf/nOhXwfNesNPqOB1Pp2msfiVJJq4EnftBMldbpnYneRb8cxXlSx8a/P
         UWKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+AJzw4pLVP6piQQ8DJ6FcW2rv83/BHBjZGX/F+I/5C4=;
        b=ZfeCFgsF2CcDL0JoChm14smLZ9u/WFW1N4KMihjSDjlmbaO+3Acj2JF+EkvFPfgRwk
         RdI+DVr3ksa0EKqUdLTgwHGAjeklGvlpCs2E3g6Ng2qmyN7blsUm4uXmBzf0b+y7R+EQ
         yTp/qwWsPTWWrlgn/DzfstBU5jD+PerEnlKzDWIuzTj0k+H8puF0Znx69Qpuyx+lP9ua
         dtvZ98p+PXLIsFtFupH8oPQ7KT7aunZLmZZyta2RUe/dNpvm6t5l/vb/tXctzcPwJLPK
         JOKPe8K+23Q4j0R7ZJnUgBIvd9kaKoc2Gn9+EPYA+8epmOvnN3e7TjSwk18GVpD3IqG0
         kEVA==
X-Gm-Message-State: AOAM5302CGbCnCciOBLlbUtoVj8VlAnACNLhzAmYMTCm5FZo2K8GmqAf
        mIoa9I7PGnR5lVMFmfKracePgg==
X-Google-Smtp-Source: ABdhPJyAfQjC4kR5eZYldFqWF50m/eUAUll5gwN5OdXOAvaJGO24XxVigDE5qacG6WGLefG1r9JSCg==
X-Received: by 2002:a17:906:9b8e:: with SMTP id dd14mr1449134ejc.6.1643963086917;
        Fri, 04 Feb 2022 00:24:46 -0800 (PST)
Received: from localhost (5.186.121.195.cgn.fibianet.dk. [5.186.121.195])
        by smtp.gmail.com with ESMTPSA id u3sm409447ejz.99.2022.02.04.00.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 00:24:46 -0800 (PST)
Date:   Fri, 4 Feb 2022 09:24:45 +0100
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com >> Martin K. Petersen" 
        <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "clm@fb.com" <clm@fb.com>, "dsterba@suse.com" <dsterba@suse.com>,
        "tytso@mit.edu" <tytso@mit.edu>, "jack@suse.com" <jack@suse.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [RFC PATCH 3/3] nvme: add the "debug" host driver
Message-ID: <20220204082445.hczdiy2uhxfi3x2g@ArmHalley.local>
References: <alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
 <270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
 <20220203153843.szbd4n65ru4fx5hx@garbanzo>
 <CGME20220203165248uscas1p1f0459e548743e6be26d13d3ed8aa4902@uscas1p1.samsung.com>
 <20220203165238.GA142129@dhcp-10-100-145-180.wdc.com>
 <20220203195155.GB249665@bgt-140510-bm01>
 <863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
 <2bbed027-b9a1-e5db-3a3d-90c40af49e09@opensource.wdc.com>
 <9d5d0b50-2936-eac3-12d3-a309389e03bf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <9d5d0b50-2936-eac3-12d3-a309389e03bf@nvidia.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04.02.2022 07:58, Chaitanya Kulkarni wrote:
>On 2/3/22 22:28, Damien Le Moal wrote:
>> On 2/4/22 12:12, Chaitanya Kulkarni wrote:
>>>
>>>>>> One can instantiate scsi devices with qemu by using fake scsi devices,
>>>>>> but one can also just use scsi_debug to do the same. I see both efforts
>>>>>> as desirable, so long as someone mantains this.
>>>>>>
>>>
>>> Why do you think both efforts are desirable ?
>>
>> When testing code using the functionality, it is far easier to get said
>> functionality doing a simple "modprobe" rather than having to setup a
>> VM. C.f. running blktests or fstests.
>>
>
>agree on simplicity but then why do we have QEMU implementations for
>the NVMe features (e.g. ZNS, NVMe Simple Copy) ? we can just build
>memoery backed NVMeOF test target for NVMe controller features.
>
>Also, recognizing the simplicity I proposed initially NVMe ZNS
>fabrics based emulation over QEMU (I think I still have initial state
>machine implementation code for ZNS somewhere), those were "nacked" for
>the right reason, since we've decided go with QEMU and use that as a
>primary platform for testing, so I failed to understand what has
>changed.. since given that QEMU already supports NVMe simple copy ...

I was not part of this conversation, but as I see it each approach give
a benefit. QEMU is fantastic for compliance testing and I am not sure
you get the same level of command analysis anywhere else; at least not
without writing dedicated code for this in a target.

This said, when we want to test for race conditions, QEMU is very slow.
For a software-only solution, we have experimented with something
similar to the nvme-debug code tha Mikulas is proposing. Adam pointed to
the nvme-loop target as an alternative and this seems to work pretty
nicely. I do not believe there should be many changes to support copy
offload using this.

So in my view having both is not replication and it gives more
flexibility for validation, which I believe it is always good.

>
>> So personally, I also think it would be great to have a kernel-based
>> emulation of copy offload. And that should be very easy to implement
>> with the fabric code. Then loopback onto a nullblk device and you get a
>> quick and easy to setup copy-offload device that can even be of the ZNS
>> variant if you want since nullblk supports zones.
>>
>
>One can do that with creating null_blk based NVMeOF target namespace,
>no need to emulate simple copy memory backed code in the fabrics
>with nvme-loop.. it is as simple as inserting module and configuring
>ns with nvmetcli once we have finalized the solution for copy offload.
>If you remember, I already have patches for that...
>
>>>
>>> NVMe ZNS QEMU implementation proved to be perfect and works just
>>> fine for testing, copy offload is not an exception.
>>>
>>>>>> For instance, blktests uses scsi_debug for simplicity.
>>>>>>
>>>>>> In the end you decide what you want to use.
>>>>>
>>>>> Can we use the nvme-loop target instead?
>>>>
>>>> I am advocating for this approach as well. It presentas a virtual nvme
>>>> controller already.
>>>>
>>>
>>> It does that assuming underlying block device such as null_blk or
>>> QEMU implementation supports required features not to bloat the the
>>> NVMeOF target.
>>>
>>> -ck
>>>
>
>-ck
>
