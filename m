Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2680CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 11:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358341AbiBDLe1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Feb 2022 06:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358418AbiBDLe1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2022 06:34:27 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6B4C06173E
        for <linux-scsi@vger.kernel.org>; Fri,  4 Feb 2022 03:34:26 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id n10so12525926edv.2
        for <linux-scsi@vger.kernel.org>; Fri, 04 Feb 2022 03:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TQF1/AEnbtmUHa3FAuw6nQDJrxJFCv8yYCIQAgYMNR0=;
        b=0ajy+8v/jsBfgGk6bMpBUIYinieWtgCd8llUbf5/SfFTr0L10wjL33Esd6+WVS2q2E
         xqEgoNZe7p3DDKol3CMhwf6WG1KmRbyJSWkBOeMknNl1IAqw9zmfsPqxwZTokejNvsaj
         zdGTtDXMNUShvYojokoJIIsbJr7NlUheT5MdHDTN78S9Ni0fp/PrLAyDtP4PDwuqrShn
         5EhDoOXXJRrQzt9eDOHS8+XTN9x+8QFTmbmumY1rXqKeQxIRyNW3KKZbTdh2twSt76Kw
         X+vs/lT5ri3RBBbCqns98AWJt8C/8UJqJgAsRxcw8Y2AxPDbi7jLb7/51n6gXs8g6W8N
         8K1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TQF1/AEnbtmUHa3FAuw6nQDJrxJFCv8yYCIQAgYMNR0=;
        b=6k+hZnHESTsWLq9J5qSZfbV4p15155rUKMNwK0+8WPDXchQMkbmJwYPiyHcfTegGJN
         J4ORWXPUtw2GobWVD4mjM1AL6QVYyGwA05Ze96x4NB7mvcVvkxtTqdk/QEPetFKuK67F
         /yJwVAV5IprT98P7c/+P2IhP16a316C1slF3+ieaPae2dJprzXGQSY7E6GbNqIG8r6ao
         oXLjkWBt7a8/WW8/iUzwsv489aHiFPPF/OJxDnRIQTdxkSTb3QYAosi9CbSaUwOTNQyT
         /XGQiaBDoZ0jXGgHAr7DOFRCil1KhMAFIxzssn2L4jZVA1dWUSO2Q7+PZb2ouHhhRuXD
         Ekcw==
X-Gm-Message-State: AOAM532wqe4cJRE1Jd43LCksIetKf2NDltXJz0KFYW3qijaurVwoynrb
        b0cBsr0rt0WdDsR4x/Apkgr3EQ==
X-Google-Smtp-Source: ABdhPJyHnNd9ApX9T3hNeWQ8SqCfGSdnwH7VDzen0VyUwGIsxdXYZM95bCYkUb7xHMbslFw5zjsfww==
X-Received: by 2002:a05:6402:2691:: with SMTP id w17mr2622163edd.126.1643974464821;
        Fri, 04 Feb 2022 03:34:24 -0800 (PST)
Received: from localhost (5.186.121.195.cgn.fibianet.dk. [5.186.121.195])
        by smtp.gmail.com with ESMTPSA id z8sm556366ejc.151.2022.02.04.03.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 03:34:24 -0800 (PST)
Date:   Fri, 4 Feb 2022 12:34:23 +0100
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
Message-ID: <20220204113423.jmynvz4w5u6wdban@ArmHalley.local>
References: <270f30df-f14c-b9e4-253f-bff047d32ff0@nvidia.com>
 <20220203153843.szbd4n65ru4fx5hx@garbanzo>
 <CGME20220203165248uscas1p1f0459e548743e6be26d13d3ed8aa4902@uscas1p1.samsung.com>
 <20220203165238.GA142129@dhcp-10-100-145-180.wdc.com>
 <20220203195155.GB249665@bgt-140510-bm01>
 <863d85e3-9a93-4d8c-cf04-88090eb4cc02@nvidia.com>
 <2bbed027-b9a1-e5db-3a3d-90c40af49e09@opensource.wdc.com>
 <9d5d0b50-2936-eac3-12d3-a309389e03bf@nvidia.com>
 <20220204082445.hczdiy2uhxfi3x2g@ArmHalley.local>
 <4d5410a5-93c3-d73c-6aeb-2c1c7f940963@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4d5410a5-93c3-d73c-6aeb-2c1c7f940963@nvidia.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04.02.2022 09:58, Chaitanya Kulkarni wrote:
>On 2/4/22 12:24 AM, Javier González wrote:
>> On 04.02.2022 07:58, Chaitanya Kulkarni wrote:
>>> On 2/3/22 22:28, Damien Le Moal wrote:
>>>> On 2/4/22 12:12, Chaitanya Kulkarni wrote:
>>>>>
>>>>>>>> One can instantiate scsi devices with qemu by using fake scsi
>>>>>>>> devices,
>>>>>>>> but one can also just use scsi_debug to do the same. I see both
>>>>>>>> efforts
>>>>>>>> as desirable, so long as someone mantains this.
>>>>>>>>
>>>>>
>>>>> Why do you think both efforts are desirable ?
>>>>
>>>> When testing code using the functionality, it is far easier to get said
>>>> functionality doing a simple "modprobe" rather than having to setup a
>>>> VM. C.f. running blktests or fstests.
>>>>
>>>
>>> agree on simplicity but then why do we have QEMU implementations for
>>> the NVMe features (e.g. ZNS, NVMe Simple Copy) ? we can just build
>>> memoery backed NVMeOF test target for NVMe controller features.
>>>
>>> Also, recognizing the simplicity I proposed initially NVMe ZNS
>>> fabrics based emulation over QEMU (I think I still have initial state
>>> machine implementation code for ZNS somewhere), those were "nacked" for
>>> the right reason, since we've decided go with QEMU and use that as a
>>> primary platform for testing, so I failed to understand what has
>>> changed.. since given that QEMU already supports NVMe simple copy ...
>>
>> I was not part of this conversation, but as I see it each approach give
>> a benefit. QEMU is fantastic for compliance testing and I am not sure
>> you get the same level of command analysis anywhere else; at least not
>> without writing dedicated code for this in a target.
>>
>> This said, when we want to test for race conditions, QEMU is very slow.
>
>Can you please elaborate the scenario and numbers for slowness of QEMU?

QEMU is an emulator, not a simulator. So we will not be able to stress
the host stack in the same way the null_blk device does. If we want to
test code in the NVMe driver then we need a way to have the equivalent
to the null_blk in NVMe. It seems like the nvme-loop target can achieve
this.

Does this answer your concern?

>
>For race conditions testing we can build error injection framework
>around the code implementation which present in kernel everywhere.

True. This is also a good way to do this.


>
>> For a software-only solution, we have experimented with something
>> similar to the nvme-debug code tha Mikulas is proposing. Adam pointed to
>> the nvme-loop target as an alternative and this seems to work pretty
>> nicely. I do not believe there should be many changes to support copy
>> offload using this.
>>
>
>If QEMU is so incompetent then we need to add every big feature into
>the NVMeOF test target so that we can test it better ? is that what
>you are proposing ? since if we implement one feature, it will be
>hard to nack any new features that ppl will come up with
>same rationale "with QEMU being slow and hard to test race
>conditions etc .."

In my opinion, if people want this and is willing to maintain it, there
is a case for it.

>
>and if that is the case why we don't have ZNS NVMeOF target
>memory backed emulation ? Isn't that a bigger and more
>complicated feature than Simple Copy where controller states
>are involved with AENs ?

I think this is a good idea.

>
>ZNS kernel code testing is also done on QEMU, I've also fixed
>bugs in the ZNS kernel code which are discovered on QEMU and I've not
>seen any issues with that. Given that simple copy feature is way smaller
>than ZNS it will less likely to suffer from slowness and etc (listed
>above) in QEMU.

QEMU is super useful: it is easy and it help identifying many issues.
But it is for compliance, not for performance. There was an effort to
make FEMU, but this seems to be an abandoned project.

>
>my point is if we allow one, we will be opening floodgates and we need
>to be careful not to bloat the code unless it is _absolutely
>necessary_ which I don't think it is based on the simple copy
>specification.

I understand, and this is a very valid point. It seems like the
nvme-loop device can give a lot of what we need; all the necessary extra
logic can go into the null_blk and then we do not need NVMe specific
code.

Do you see any inconvenient with this approach?


>
>> So in my view having both is not replication and it gives more
>> flexibility for validation, which I believe it is always good.
>>
>
