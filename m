Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC3CC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44E3423130
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 16:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbhALQl7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 11:41:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33250 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728027AbhALQl7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 11:41:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610469632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CMPLqqO5+8otcSsas1DR1OrCy7UxZHsLRVzPUhUH/Po=;
        b=CCDNZp8Kf9X+/DopODu1doyPmu5oOSlWu87yYi1nnky65KFqlwGLOE9veKLmCrjyUEs6IL
        TwrOk4Tax2Jqbo6MhPZ8qQOv80RyUqCbwtb7WQrCosCpWXyIlPssBM3V/2E8M1aT8aJ3sC
        EwjZvx1FO/F7CcCoWFc9XiYfhGRJRQQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-psrIOTY1N0ukxeQy7nkD8g-1; Tue, 12 Jan 2021 11:40:28 -0500
X-MC-Unique: psrIOTY1N0ukxeQy7nkD8g-1
Received: by mail-wr1-f69.google.com with SMTP id o17so1398013wra.8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 08:40:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMPLqqO5+8otcSsas1DR1OrCy7UxZHsLRVzPUhUH/Po=;
        b=drLnnilridakxNzdwkL8Eg4xBXTLT+wgK5+4GRMLHItOQgePtcMtFZdkcN/C2TGEr5
         4m4BpCMqy0VeCkJzjYTiZPXgXnRq5MOky8dqxaZ2aAObcClzLuq6+EiL/689Wyw2TFvD
         lZwtzeX0nRuCKaKJwQScq8urUOC1wWlHaFNeSBAfmVO8VCJ0yOV8DLSBF4ctwOIXYP5w
         6yj08+1AdNXQMRsPhKfmurwTpn2FIkM2LBPATQ9HjMJWoU2CkjZGATN2BZD1T+UizN2a
         bowtEP2YJWRYbrKnc74XZ/xHMZtOmBZqePy5iv156y7kY+uGU0JQ+WN1edA3DvQd6MFX
         65qw==
X-Gm-Message-State: AOAM5313OZqRe81XvINrqGxrNhiGjOb5PRgiZFf3UuCg371dfSrO4MJI
        xsJN27B7NGK0s8oQnJ7wg+mvg9iEO5XedBbzM/81rYCK37WDl2FzJAgkGchxQ/MrHx5Z0sh1OeF
        PV/g6z1aJj3xAhe1YcWlLLS2YyekIBeGOdpiXrg==
X-Received: by 2002:a5d:4e86:: with SMTP id e6mr5347893wru.33.1610469627537;
        Tue, 12 Jan 2021 08:40:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzO+O0tCocFsvy6/VO7OpBQc+6MT8x8lJjkcxGG9dBCoPQdcl0BOks7QmR3r35rn8W6PCicM14ap0HMQWbKvuc=
X-Received: by 2002:a5d:4e86:: with SMTP id e6mr5347871wru.33.1610469627340;
 Tue, 12 Jan 2021 08:40:27 -0800 (PST)
MIME-Version: 1.0
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
 <b51fc658-b28a-d627-a2a3-b2835132ab13@huawei.com> <62b562eae9830830d87ea9f92dcc0018a1935583.camel@linux.ibm.com>
 <571e3700-2850-3a5d-8fd0-91425a4f810a@huawei.com>
In-Reply-To: <571e3700-2850-3a5d-8fd0-91425a4f810a@huawei.com>
From:   Bryan Gurney <bgurney@redhat.com>
Date:   Tue, 12 Jan 2021 11:40:15 -0500
Message-ID: <CAHhmqcQH1vs1nV7gU9irxzj5LM41pjAY8Y4SWMkyJOsTA4EHfg@mail.gmail.com>
Subject: Re: About scsi device queue depth
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        chenxiang <chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 12, 2021 at 5:31 AM John Garry <john.garry@huawei.com> wrote:
>
> >>
> >> For this case, it seems the opposite - less is more. And I seem to
> >> be hitting closer to the sweet spot there, with more merges.
> >
> > I think cheaper SSDs have a write latency problem due to erase block
> > issues.  I suspect all SSDs have a channel problem in that there's a
> > certain number of parallel channels and once you go over that number
> > they can't actually work on any more operations even if they can queue
> > them.  For cheaper (as in fewer channels, and less spare erased block
> > capacity) SSDs there will be a benefit to reducing the depth to some
> > multiplier of the channels (I'd guess 2-4 as the multiplier).  When
> > SSDs become write throttled, there may be less benefit to us queueing
> > in the block layer (merging produces bigger packets with lower
> > overhead, but the erase block consumption will remain the same).
> >
> > For the record, the internet thinks that cheap SSDs have 2-4 channels,
> > so that would argue a tag depth somewhere from 4-16
>
> I have seen upto 10-channel devices mentioned being "high end" - this
> would mean upto 40 queue depth using on 4x multiplier; so, based on
> that, the current value of 254 for that driver seems way off.
>
> >
> >>> SSDs have a peculiar lifetime problem in that when they get
> >>> erase block starved they start behaving more like spinning rust in
> >>> that they reach a processing limit but only for writes, so lowering
> >>> the write queue depth (which we don't even have a knob for) might
> >>> be a good solution.  Trying to track the erase block problem has
> >>> been a constant bugbear.
> >>
> >> I am only doing read performance test here, and the disks are SAS3.0
> >> SSDs HUSMM1640ASS204, so not exactly slow.
> >
> > Possibly ... the stats on most manufacturer SSDs don't give you
> > information about the channels or spare erase blocks.
>
> For my particular disk, this is the datasheet/manual:
> https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-sas-series/data-sheet-ultrastar-ssd1600ms.pdf
>
> https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-sas-series/product-manual-ultrastar-ssd1600mr-1-92tb.pdf
>
> And I didn't see explicit info regarding channels or spare erase blocks,
> as you expect.
>

John,

In that datasheet, I see the model number designator "MR", which
stands for "Multi level cell, read-intensive (2 drive writes per
day)".

Compare that to the 1600MM drive: "Multi level cell, mainstream
endurance (10 drive writes per day)":
https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-sas-series/data-sheet-ultrastar-ssd1600mm.pdf

Also, note that the quoted "Write IOPS (max IOPS, random 4k)" on the
datasheet is 30,000 for the 1600MR drive, and 100,000 IOPS for the
1600MM drive.


Thanks,

Bryan

> >
> >>> I'm assuming you're using spinning rust in the above, so it sounds
> >>> like the firmware in the card might be eating the queue full
> >>> returns.  Icould see this happening in RAID mode, but it shouldn't
> >>> happen in jbod mode.
> >>
> >> Not sure on that, but I didn't check too much. I did try to increase
> >> fio queue depth and sdev queue depth to be very large to clobber the
> >> disks, but still nothing.
> >
> > If it's an SSD it's likely not giving the queue full you'd need to get
> > the mid-layer to throttle automatically.
> >
>
> So it seems that the queue depth we select should depend on class of
> device, but then the value can also affect write performance.
>
> As for my issue today, I can propose a smaller value for the mpt3sas
> driver based on my limited tests, and see how the driver maintainers
> feel about it.
>
> I just wonder what intelligence we can add for this. And whether LLDDs
> should be selecting this (queue depth) at all, unless they (the HBA)
> have some limits themselves.
>
> You did mention maybe a separate write queue depth - could this be a
> solution?
>
> Thanks,
> John
>

