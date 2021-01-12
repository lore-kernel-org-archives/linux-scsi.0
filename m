Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6550DC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1996B23121
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:22:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392489AbhALRWP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:22:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58104 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391359AbhALRWP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 12:22:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610472047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jbG76o7xyzrJuFoiJ2brVlfCSbE49TRCVPHQC41GI/M=;
        b=JoZ8W4z46ypuzRgSkteUq1W35u7ZUz/G6k1bommmQDyqjKfGdQyGb7yf9thdb/4KfjNDml
        qGf5BUBDj3bS+SqH0nqst3+p9RGGetf3GSPbVVvnr/Oyr8hcjvAsnXrRLjTSmhzKMk1Dvb
        W9bse6XWa+FlyJx+9XMAmv7zN3WsNko=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-CdgLPixVO4WILGxulJZAfA-1; Tue, 12 Jan 2021 12:20:44 -0500
X-MC-Unique: CdgLPixVO4WILGxulJZAfA-1
Received: by mail-wr1-f71.google.com with SMTP id u14so1442004wrr.15
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 09:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jbG76o7xyzrJuFoiJ2brVlfCSbE49TRCVPHQC41GI/M=;
        b=Vi9OByIeIBiSJs+4Bo4jPQ7lXe2ms84nPGNFMaUNK7zIWtXZ+eeeEb9nCVBplxvwGA
         RRECcavcwdhD/kgjgpxztA7xUaUqsvYLGUPt6JQm389fK4yVta7SWO4aLzGqPude8FSu
         n0g0e7zcQGa9AhrVxHjfYMlQb2v1Z2vgpCYH+X5nNWaWr2G+UJToejqPhZmd+NOywKdp
         CGJ3dl4jmuCyYWemro9vcay2PBf0UAYxuoHtg+B5ywkSChNdVFqqIOeLyE/22DgNxiIR
         7isB5iZmn0dAWO8QmCM0AXhtoV6pK4Trgq9aF7kaUHJMFltPZuy7D3lEGZ8sAmKQQPCt
         eIRQ==
X-Gm-Message-State: AOAM532emH0s06ViwKDqFD+LS1oNp3z/AUlIuvLdwWsWr821OZ+42Og7
        GLdvkWJiUf6M3HZbFTCorQPQsT5B6AEpnO3iKXnxg5PoK43QKpwrA6UWorC0ujgeh1+ZohnWu0O
        e+MnK93Ldgxcsv6QpU/+jXGJIpquBJeBaWx+K4Q==
X-Received: by 2002:adf:eac7:: with SMTP id o7mr5439810wrn.23.1610472043285;
        Tue, 12 Jan 2021 09:20:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5OZEVcmw6Utsw0EsmAL7mz8YKAQzbJmVY12GWAiyYSzwXJwq6Cz8i79IXvjYUaSxI3Skkrtx8khTRzSLCaAQ=
X-Received: by 2002:adf:eac7:: with SMTP id o7mr5439785wrn.23.1610472042994;
 Tue, 12 Jan 2021 09:20:42 -0800 (PST)
MIME-Version: 1.0
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
 <d784f7ff4f61a81c4c9df96decc6b7f6d884c616.camel@linux.ibm.com>
 <b51fc658-b28a-d627-a2a3-b2835132ab13@huawei.com> <62b562eae9830830d87ea9f92dcc0018a1935583.camel@linux.ibm.com>
 <571e3700-2850-3a5d-8fd0-91425a4f810a@huawei.com> <3e3f929559a9581d17d055966416b827d4c0219b.camel@linux.ibm.com>
In-Reply-To: <3e3f929559a9581d17d055966416b827d4c0219b.camel@linux.ibm.com>
From:   Bryan Gurney <bgurney@redhat.com>
Date:   Tue, 12 Jan 2021 12:20:31 -0500
Message-ID: <CAHhmqcQjy8AieJ3V+bP3HVPoPOW3sbUMPuABOPFgWGsNAp_z_A@mail.gmail.com>
Subject: Re: About scsi device queue depth
To:     jejb@linux.ibm.com
Cc:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
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

On Tue, Jan 12, 2021 at 11:49 AM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Tue, 2021-01-12 at 10:27 +0000, John Garry wrote:
> > > > For this case, it seems the opposite - less is more. And I seem
> > > > to be hitting closer to the sweet spot there, with more merges.
> > >
> > > I think cheaper SSDs have a write latency problem due to erase
> > > block issues.  I suspect all SSDs have a channel problem in that
> > > there's a certain number of parallel channels and once you go over
> > > that number they can't actually work on any more operations even if
> > > they can queue them.  For cheaper (as in fewer channels, and less
> > > spare erased block capacity) SSDs there will be a benefit to
> > > reducing the depth to some multiplier of the channels (I'd guess 2-
> > > 4 as the multiplier).  When SSDs become write throttled, there may
> > > be less benefit to us queueing in the block layer (merging produces
> > > bigger packets with lower overhead, but the erase block consumption
> > > will remain the same).
> > >
> > > For the record, the internet thinks that cheap SSDs have 2-4
> > > channels, so that would argue a tag depth somewhere from 4-16
> >
> > I have seen upto 10-channel devices mentioned being "high end" -
> > this would mean upto 40 queue depth using on 4x multiplier; so, based
> > on that, the current value of 254 for that driver seems way off.
>
> SSD manufacturers don't want us second guessing their device internals
> which is why the mostly don't publish the details.  They want to move
> us to a place where we don't do any merging at all and just spray all
> the I/O packets at the device and let it handle them.
>
> Your study argues they still aren't actually in a place where reality
> matches their rhetoric but it you code latency heuristics based on my
> guesses they'll likely be wrong for the next generation of devices.
>
> > > > > SSDs have a peculiar lifetime problem in that when they get
> > > > > erase block starved they start behaving more like spinning rust
> > > > > in that they reach a processing limit but only for writes, so
> > > > > lowering the write queue depth (which we don't even have a knob
> > > > > for) might be a good solution.  Trying to track the erase block
> > > > > problem hasbeen a constant bugbear.
> > > >
> > > > I am only doing read performance test here, and the disks are
> > > > SAS3.0 SSDs HUSMM1640ASS204, so not exactly slow.
> > >
> > > Possibly ... the stats on most manufacturer SSDs don't give you
> > > information about the channels or spare erase blocks.
> >
> > For my particular disk, this is the datasheet/manual:
> > https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-sas-series/data-sheet-ultrastar-ssd1600ms.pdf
> >
> > https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/product/data-center-drives/ultrastar-sas-series/product-manual-ultrastar-ssd1600mr-1-92tb.pdf
> >
> > And I didn't see explicit info regarding channels or spare erase
> > blocks, as you expect.
>
> Right, manufacturers simply aren't going to give us that information.
> I also suspect the device won't return queue full usefully either so we
> can't track that meaningfully either.

There is a convention of SSD manufacturers quoting a "drive writes per
day" rating for their drives, especially if they will offer a product
line with a "read-intensive" model for mostly-read workloads, and then
charge more for a model that has a higher "drive writes per day"
rating, and maximum IOPS rating.

(I found a "mainstream endurance" model variant for the Ultrastar
SSD1600 series, the SSD1600MM.  There are more details in an email
that I sent a little earlier in this thread.)

>
> Remember also that all SSDs have a flash translation layer which
> transforms our continuous I/O into a scatter/gather list.  This does
> argue there are diminishing returns from merging I/Os anyway and
> supports the manufacturer argument that we shouldn't be doing merging.
>
> I think the question for us is: if we do discover additional latency in
> an SSD read/write queue what do we do with it?  For spinning rust,
> using spare latency to merge requests is a definite win because the
> drive machinery is way more efficient with contiguous reads/writes,
> what would be a similar win with SSDs?

We have to remember that hard disk drives and SSDs have different
mechanisms, therefore they have different behaviors in reaction to the
host commands.

A hard disk drive usually has one mechanical arm that moves read-write
heads across a platter.  To reduce the amount of "chasing back and
forth" that the drive head needs to do, there are strategies like
merging requests into larger sequential requests, and using a cache
somewhere (on the drive, or on the controller, or in the operating
system).

When an SSD encounters the "write cliff", where its flash translation
layer is busy with its tasks that are internal to the firmware, what
else can the host do to "make things easier" for the FTL, and
eventually recover to full write performance?

Right now, it seems like the best way to recover that performance is
to "stop performing sustained random writes so often," but that seems
counter to the goal of using the drive to its fullest performance
potential.

Other medium types may not have this problem.  For example, the Intel
Optane 800P that was released a few years ago uses 3D XPoint instead
of NAND, and it does not have a "write cliff" at all.  In fact, you
have the opposite problem, in that case: you have to start worrying
about potentially exceeding the drive-writes-per-day rating (which I
believe Intel quoted at hundreds of terabytes written over the 5-year
warranty period).


Thanks,

Bryan

>
> > > > > I'm assuming you're using spinning rust in the above, so it
> > > > > sounds like the firmware in the card might be eating the queue
> > > > > full returns.  Icould see this happening in RAID mode, but it
> > > > > shouldn't happen in jbod mode.
> > > >
> > > > Not sure on that, but I didn't check too much. I did try to
> > > > increase fio queue depth and sdev queue depth to be very large to
> > > > clobber the disks, but still nothing.
> > >
> > > If it's an SSD it's likely not giving the queue full you'd need to
> > > get the mid-layer to throttle automatically.
> > >
> >
> > So it seems that the queue depth we select should depend on class of
> > device, but then the value can also affect write performance.
>
> Well, it does today.  queue full works for most non SSD devices and it
> allows us to set a useful queue depth.  We also have the norotational
> flag in block to help.
>
> > As for my issue today, I can propose a smaller value for the mpt3sas
> > driver based on my limited tests, and see how the driver maintainers
> > feel about it.
>
> It will run counter to the SSD manufacturers "just give us all your
> packets ASAP" mantra so most commercial driver vendors won't want it
> changed.
>
> > I just wonder what intelligence we can add for this. And whether
> > LLDDs should be selecting this (queue depth) at all, unless they (the
> > HBA) have some limits themselves.
>
> I suspect it's not in the block layer at all.  I'd guess the best thing
> we can do is report on read and write latency and let something in
> userspace see if it wants to adjust the queue depth.
>
> > You did mention maybe a separate write queue depth - could this be a
> > solution?
>
> I was observing that the gating factors for the read and write latency
> characteristics are radically different for SSDs, so I would really
> expect optimal queue depths to be different on read and write requests.
> Now whether there's a benefit to using that latency is a different
> question.  If we had a read and a write queue depth, what would we do
> with the latency in the write queue?  The problem on writes is the
> device erasing blocks ... merging requests doesn't do anything to help
> with that problem, so there may be no real benefit to reducing the
> write queue depth.
>
> James
>
>

