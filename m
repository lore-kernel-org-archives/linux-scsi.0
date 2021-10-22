Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B666C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 09:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10B3A60F46
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 09:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhJVJuo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 05:50:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231992AbhJVJun (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Oct 2021 05:50:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634896106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W9T8B018h78tAIOUbGw7DY/sbBrHy3hSwuPRlF8fWKY=;
        b=hmednXfqlYx50/lvfqcblUswjvqnLBXHtGoF6n6I1DaMLMjUJ9qMYseosGrHBA37X4DXcn
        xLL0AtowL09cNU3Oq3N758gTgaqOEjL8QdgoV6ImdYq1wRRacr6/eVjxPEeilL68nxPPUD
        lmrBe8DKwUsDw25W71joEbC5vEyDYD4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-oQ343KurMfW5XwwN-BpeTQ-1; Fri, 22 Oct 2021 05:48:24 -0400
X-MC-Unique: oQ343KurMfW5XwwN-BpeTQ-1
Received: by mail-wr1-f69.google.com with SMTP id n14-20020a5d420e000000b00167c303d862so796351wrq.9
        for <linux-scsi@vger.kernel.org>; Fri, 22 Oct 2021 02:48:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W9T8B018h78tAIOUbGw7DY/sbBrHy3hSwuPRlF8fWKY=;
        b=RiJeM4jMS9MynPFgi6TiNXEhK59gO1hce+yLcaQQZm9oDUyrcdmdDF0dVwJKRIkAd5
         IJeo8D3p2YLs24q90kPMp9Xvz8gkLd4g9x+TH6nKqVb9D2ZT0xjFg5pBUDsGfUR2Xmxn
         UZJxjEnQHhbXsOCVk65NY62i/El7iBqqHQo+IIO2fFcepjlMMx6wUXmV+zoDRCDF8SeD
         KNamVsPRnWPniO3b8hlTHhJEIw6pyzQj1CojhBDYU62nWd+ciulQglNibFaavjq2MCcX
         uPkxjIyxEabK9zgEyXBPoyP/P8SgLZdKpZV1+JTP7HQw4kWa2OOqgYUQzey+W7uELC5V
         7fqw==
X-Gm-Message-State: AOAM5328a8x/0y4NffmKFF/D/61h+dQw4o6Ip1a0ztaHqk+OisajIYx/
        HDt2Ti8z6wZ9qjJNDiLQ4lkIY+w0JOBsO2iWIc6DnKxmm+2Jbn9w3Y+4hWDKzFbyxudktlpuUtJ
        0j5ewIMYWVQ6QG1ANLe/V7w==
X-Received: by 2002:a5d:64af:: with SMTP id m15mr13896846wrp.117.1634896103279;
        Fri, 22 Oct 2021 02:48:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLnEzXyZnIH2I896CP+ucefqoe5BtlT1z2DOdAq4RH4UEuXUz/gmRg1JCXs+m4D8ZaqZDE3g==
X-Received: by 2002:a5d:64af:: with SMTP id m15mr13896831wrp.117.1634896103097;
        Fri, 22 Oct 2021 02:48:23 -0700 (PDT)
Received: from redhat.com ([2.55.24.172])
        by smtp.gmail.com with ESMTPSA id 186sm10973877wmc.20.2021.10.22.02.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 02:48:22 -0700 (PDT)
Date:   Fri, 22 Oct 2021 05:48:18 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 00/11] vhost: multiple worker support
Message-ID: <20211022054625-mutt-send-email-mst@kernel.org>
References: <20211022051911.108383-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022051911.108383-1-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 22, 2021 at 12:18:59AM -0500, Mike Christie wrote:
> The following patches apply over linus's tree and this patchset
> 
> https://lore.kernel.org/all/20211007214448.6282-1-michael.christie@oracle.com/
> 
> which allows us to check the vhost owner thread's RLIMITs:


Unfortunately that patchset in turn triggers kbuild warnings.
I was hoping you would address them, I don't think
merging that patchset before kbuild issues are addressed
is possible.

It also doesn't have lots of acks, I'm a bit apprehensive
of merging core changes like this through the vhost tree.
Try to CC more widely/ping people?

> It looks like that patchset has been ok'd by all the major parties
> and just needs a small cleanup to apply to Jens and Paul trees, so I
> wanted to post my threading patches based over it for review.
> 
> The following patches allow us to support multiple vhost workers per
> device. I ended up just doing Stefan's original idea where userspace has
> the kernel create a worker and we pass back the pid. This has the benefit
> over the workqueue and userspace thread approach where we only have
> one'ish code path in the kernel during setup to detect old tools. The
> main IO paths and device/vq setup/teardown paths all use common code.
> 
> I've also included a patch for qemu so you can get an idea of how it
> works. If we are ok with the kernel code then I'll break that up into
> a patchset and send to qemu-devel for review.
> 
> Results:
> --------
> 
> fio jobs        1       2       4       8       12      16
> ----------------------------------------------------------
> 1 worker        84k    492k    510k    -       -       -
> worker per vq   184k   380k    744k    1422k   2256k   2434k
> 
> Notes:
> 0. This used a simple fio command:
> 
> fio --filename=/dev/sdb  --direct=1 --rw=randrw --bs=4k \
> --ioengine=libaio --iodepth=128  --numjobs=$JOBS_ABOVE
> 
> and I used a VM with 16 vCPUs and 16 virtqueues.
> 
> 1. The patches were tested with emulate_pr=0 and these patches:
> 
> https://lore.kernel.org/all/yq1tuhge4bg.fsf@ca-mkp.ca.oracle.com/t/
> 
> which are in mkp's scsi branches for the next kernel. They fix the perf
> issues where IOPs dropped at 12 vqs/jobs.
> 
> 2. Because we have a hard limit of 1024 cmds, if the num jobs * iodepth
> was greater than 1024, I would decrease iodepth. So 12 jobs used 85 cmds,
> and 16 used 64.
> 
> 3. The perf issue above at 2 jobs is because when we only have 1 worker
> we execute more cmds per vhost_work due to all vqs funneling to one worker.
> This results in less context switches and better batching without having to
> tweak any settings. I'm working on patches to add back batching during lio
> completion and do polling on the submission side.
> 
> We will still want the threading patches, because if we batch at the fio
> level plus use the vhost theading patches, we can see a big boost like
> below. So hopefully doing it at the kernel will allow apps to just work
> without having to be smart like fio.
> 
> fio using io_uring and batching with the iodepth_batch* settings:
> 
> fio jobs        1       2       4       8       12      16
> -------------------------------------------------------------
> 1 worker        494k    520k    -       -       -       -
> worker per vq   496k    878k    1542k   2436k   2304k   2590k
> 
> V3:
> - fully convert vhost code to use vq based APIs instead of leaving it
> half per dev and half per vq.
> - rebase against kernel worker API.
> - Drop delayed worker creation. We always create the default worker at
> VHOST_SET_OWNER time. Userspace can create and bind workers after that.
> 
> v2:
> - change loop that we take a refcount to the worker in
> - replaced pid == -1 with define.
> - fixed tabbing/spacing coding style issue
> - use hash instead of list to lookup workers.
> - I dropped the patch that added an ioctl cmd to get a vq's worker's
> pid. I saw we might do a generic netlink interface instead.
> 
> 
> 

