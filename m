Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335A1C4361B
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06BFC235FD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgLHMWE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727784AbgLHMWE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 07:22:04 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E70C061793
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 04:21:18 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id b9so13972116ejy.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 04:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=IAI5d5pS3efjsbXLYKh2mpe6utm2q/uw9y9/qssJFDE=;
        b=SWYPVvs1v5zMXa7VMWQMNpj3ZF+7g4QlHRba+Z1qnK+/erhw4fLhgQBPaqqnnlSoDf
         S976I6ob+lwEb5r2qXXsTcKvZsOXfm+evYsywKQr6G40vEA30YKzZhXfojwvQdkuJ3YQ
         Av2hiGFDRCZ3sLe+aXd+MSwMXm6VDhjk3xlBYdRSeN9bzQ+QV3x2JxBxKK2bzEpR6Ou1
         sNJg7yQohGgqCz62wGe35Kz1eyakKWEWGYWmFC+wBoM9GX/+WnNGAP3L55mqVAsu7yDV
         fHXMp841PHLXyped1FUxxpLKDzw2rDDwOdIiz/ZrD2LfTvtDb24UwhmCztFOPPNpTmCG
         NWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IAI5d5pS3efjsbXLYKh2mpe6utm2q/uw9y9/qssJFDE=;
        b=ms4culM9N5y7Ouo/VbxEIpYgPPHZ1B3P3yEQKh6nj2TWUVqMlQ8nbgVRlQ6hq4vwhB
         ffBIvn1JxIcls2Dmp4NyZEy9x9wtK9niwlYGD/drTCAyUFxDzng9TMnzpHTn71jaW5tL
         c3RHd12tq+NtOMnKd2Yu2/+Xous4Pcx3DtPB1BE4TcpDwB+jBaEFvKayQ2I3f4KzlGaG
         AZBA8b7E/vdymPLee+uA1DVIQdPyKNJH9KEJvfmLghEGgIeBnHayKAV9Xcq2b5DOXUYO
         LtKCSq4pHIfdBGxUJo6TZqb/INnZvN1/fxZQFanC3sOOwehv9w2fmiwcY5AmMSexO58D
         72wQ==
X-Gm-Message-State: AOAM530bCmmztY09A2PIIqN5Ica0J43KaaCTgsKOi7Dps32rGFrAMSui
        cf3gQb9LoI3xSN/ygkf6n3evxg==
X-Google-Smtp-Source: ABdhPJxhL6i6yFmZQunp7bazoVScU9q+jr5k0Xgzao5BDSe6y/H+nh7mEFR+wnSA5Kolq55NeVPyBQ==
X-Received: by 2002:a17:906:718b:: with SMTP id h11mr6669589ejk.241.1607430076628;
        Tue, 08 Dec 2020 04:21:16 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
        by smtp.gmail.com with ESMTPSA id e3sm15781214ejq.96.2020.12.08.04.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 04:21:15 -0800 (PST)
From:   "Javier =?utf-8?B?R29uesOhbGV6?=" <javier@javigon.com>
X-Google-Original-From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
Date:   Tue, 8 Dec 2020 13:21:15 +0100
To:     Hannes Reinecke <hare@suse.de>
Cc:     dgilbert@interlog.com, Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        linux-nvme@lists.infradead.org, kbusch@kernel.org, axboe@kernel.dk,
        damien.lemoal@wdc.com, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
Message-ID: <20201208122115.jy7s3w2wr3ysxvkk@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
 <20201204094659.12732-1-selvakuma.s1@samsung.com>
 <20201207141123.GC31159@lst.de>
 <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
 <194d7813-8c8c-85c8-e0c8-94aaab7c291e@interlog.com>
 <9b2f5ab2-3358-fcce-678f-982ef79c9252@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b2f5ab2-3358-fcce-678f-982ef79c9252@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08.12.2020 07:44, Hannes Reinecke wrote:
>On 12/7/20 11:12 PM, Douglas Gilbert wrote:
>>On 2020-12-07 9:56 a.m., Hannes Reinecke wrote:
>>>On 12/7/20 3:11 PM, Christoph Hellwig wrote:
>>>>So, I'm really worried about:
>>>>
>>>>  a) a good use case.  GC in f2fs or btrfs seem like good use cases, as
>>>>     does accelating dm-kcopyd.  I agree with Damien that 
>>>>lifting dm-kcopyd
>>>>     to common code would also be really nice.  I'm not 100% 
>>>>sure it should
>>>>     be a requirement, but it sure would be nice to have
>>>>     I don't think just adding an ioctl is enough of a use case 
>>>>for complex
>>>>     kernel infrastructure.
>>>>  b) We had a bunch of different attempts at SCSI XCOPY support 
>>>>form IIRC
>>>>     Martin, Bart and Mikulas.  I think we need to pull them into this
>>>>     discussion, and make sure whatever we do covers the SCSI needs.
>>>>
>>>And we shouldn't forget that the main issue which killed all 
>>>previous implementations was a missing QoS guarantee.
>>>It's nice to have simply copy, but if the implementation is 
>>>_slower_ than doing it by hand from the OS there is very little 
>>>point in even attempting to do so.
>>>I can't see any provisions for that in the TPAR, leading me to the 
>>>assumption that NVMe simple copy will suffer from the same issue.
>>>
>>>So if we can't address this I guess this attempt will fail, too.
>>
>>I have been doing quite a lot of work and testing in my sg driver rewrite
>>in the copy and compare area. The baselines for performance are dd and
>>io_uring-cp (in liburing). There are lots of ways to improve on them. Here
>>are some:
>>    - the user data need never pass through the user space (could
>>      mmap it out during the READ if there is a good reason). Only the
>>      metadata (e.g. NVMe or SCSI commands) needs to come from the user
>>      space and errors, if any, reported back to the user space.
>>    - break a large copy (or compare) into segments, with each segment
>>      a "comfortable" size for the OS to handle, say 256 KB
>>    - there is one constraint: the READ in each segment must complete
>>      before its paired WRITE can commence
>>      - extra constraint for some zoned disks: WRITEs must be
>>        issued in order (assuming they are applied in that order, if
>>        not, need to wait until each WRITE completes)
>>    - arrange for READ WRITE pair in each segment to share the same bio
>>    - have multiple slots each holding a segment (i.e. a bio and
>>      metadata to process a READ-WRITE pair)
>>    - re-use each slot's bio for the following READ-WRITE pair
>>    - issue the READs in each slot asynchronously and do an interleaved
>>      (io)poll for completion. Then issue the paired WRITE
>>      asynchronously
>>    - the above "slot" algorithm runs in one thread, so there can be
>>      multiple threads doing the same algorithm. Segment manager needs
>>      to be locked (or use an atomics) so that each segment (identified
>>      by its starting LBAs) is issued once and only once when the
>>      next thread wants a segment to copy
>>
>>Running multiple threads gives diminishing or even worsening returns.
>>Runtime metrics on lock contention and storage bus capacity may help
>>choosing the number of threads. A simpler approach might be add more
>>threads until the combined throughput increase is less than 10% say.
>>
>>
>>The 'compare' that I mention is based on the SCSI VERIFY(BYTCHK=1) command
>>(or NVMe NVM Compare command). Using dd logic, a disk to disk compare can
>>be implemented with not much more work than changing the WRITE to a VERIFY
>>command. This is a different approach to the Linux cmp utility which
>>READs in both sides and does a memcmp() type operation. Using ramdisks
>>(from the scsi_debug driver) the compare operation (max ~ 10 GB/s) was
>>actually faster than the copy (max ~ 7 GB/s). I put this down to WRITE
>>operations taking a write lock over the store while the VERIFY only
>>needs a read lock so many VERIFY operations can co-exist on the same
>>store. Unfortunately on real SAS and NVMe SSDs that I tested the
>>performance of the VERIFY and NVM Compare commands is underwhelming.
>>For comparison, using scsi_debug ramdisks, dd copy throughput was
>>< 1 GB/s and io_uring-cp was around 2-3 GB/s. The system was Ryzen
>>3600 based.
>>
>Which is precisely my concern.
>Simple copy might be efficient for one particular implementation, but 
>it might be completely off the board for others.
>But both will be claiming to support it, and us having no idea whether 
>choosing simple copy will speed up matters or not.
>Without having a programmatic way to figure out the speed of the 
>implementation we have to detect the performance ourselves, like the 
>benchmarking loop RAID5 does.
>I was hoping to avoid that, and just ask the device/controller; but 
>that turned out to be in vain.

I believe it makes sense to do extensive characterization to understand
how the host and device implementation behave. However, I do not believe
we will get far if the requirement is that any acceleration has to
outperform the legacy path under all circumstances and implementations.

At this moment in time, this is a feature very much targeted to
eliminating the extra read/write traffic generated by ZNS host GC.

This said, we do see the value in aligning with existing efforts to
offload copy under other use cases, so if you have a set of tests we can
run to speak the same language, we would be happy to take them and adapt
them to the fio extensions we have posted for testing this too.
