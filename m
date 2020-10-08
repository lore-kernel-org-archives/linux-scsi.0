Return-Path: <SRS0=XwCY=DP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B15BC433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC59F2222C
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Oct 2020 20:27:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RG7U9gUp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgJHU1A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Oct 2020 16:27:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40743 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728725AbgJHU1A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Oct 2020 16:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602188818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=twVz8zn39JFNygX3N+DpgBYsBehN6K5Zd/Llqp3b+sk=;
        b=RG7U9gUpDFn1E80s8YPI3yxgju33yHzxae/uBhbIhfa2kU1qCA9UiZrulN5NHvTCONoK6P
        LVRYjlZZLfF4r3/GxLKPu9CXe5WWHeblSeLjFhoyos5sPjv6PtDEQ8JG0b46nuwnNDoOSc
        Ure/DqLhPGQ6ebmB3EnAzg0olMbuNQs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-ylp4GpxoOn2JdCor5kQirQ-1; Thu, 08 Oct 2020 16:26:56 -0400
X-MC-Unique: ylp4GpxoOn2JdCor5kQirQ-1
Received: by mail-wm1-f69.google.com with SMTP id 73so3491941wma.5
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2020 13:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=twVz8zn39JFNygX3N+DpgBYsBehN6K5Zd/Llqp3b+sk=;
        b=HeLoyTkhfqhyNJb1X1XyqHUYnM7VP+B1PpLzHJVSWoxu9tQICewDCiyEHGO2lMgdzT
         LM4/MyAt5mbLTHnV/Zq3t++rinklMgNszItvfQV2nYSBa7GjKir4iOKuU8RoVO4KTIEe
         ssrZrMagYJxBMM/UQVJZqukGv8Dzt3qKnWwqEgDq4+4BmhmSvYOEia2dIqkh+K4g0TFm
         hQGdDvqLSvjwGu8tfLMeTfzQhFfs6s3ZmuN8sDFvmRgYJyU4yYN3rxED3gwKVXpR0Din
         3z2QTJlY0ngf44H3cABlT9Z54biot/fcH/kDscR4NfY8M7Kwp0j1a0Ii3gnEG3bXFQHN
         Va5A==
X-Gm-Message-State: AOAM5307CzS4xv/z4SIoxg1OCf7SK7+F9Nk+PKFuLhybexbkTGZBpCeB
        oeC3fVlQTug8HqDoa8IuAoO93oNs0o5ES5/jiOOEPkKuRz+9KhB5fSo31jKxMtFIsBtETZ8Qgxv
        +lSVUsO8EyBazP1IB7qJT5Q==
X-Received: by 2002:a7b:cc17:: with SMTP id f23mr9940717wmh.166.1602188815246;
        Thu, 08 Oct 2020 13:26:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3KfXXvkMS5m5z/HtHdSxRswCK5ykunjW1kWHIj15VRre8iCzBqPKFXNiyvij71iupd9gn4A==
X-Received: by 2002:a7b:cc17:: with SMTP id f23mr9940704wmh.166.1602188815005;
        Thu, 08 Oct 2020 13:26:55 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id a199sm8942819wmd.8.2020.10.08.13.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 13:26:54 -0700 (PDT)
Date:   Thu, 8 Oct 2020 16:26:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 12/16] vhost: support multiple worker threads
Message-ID: <20201008162523-mutt-send-email-mst@kernel.org>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
 <1602104101-5592-13-git-send-email-michael.christie@oracle.com>
 <da6f25b4-7a98-9294-a987-43d100625499@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da6f25b4-7a98-9294-a987-43d100625499@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 08, 2020 at 12:56:53PM -0500, Mike Christie wrote:
> On 10/7/20 3:54 PM, Mike Christie wrote:
> > This is a prep patch to support multiple vhost worker threads per vhost
> > dev. This patch converts the code that had assumed a single worker
> > thread by:
> > 
> > 1. Moving worker related fields to a new struct vhost_worker.
> > 2. Converting vhost.c code to use the new struct and assume we will
> > have an array of workers.
> > 3. It also exports a helper function that will be used in the last
> > patch when vhost-scsi is converted to use this new functionality.
> > 
> 
> Oh yeah I also wanted to bring up this patch:
> 
> https://www.spinics.net/lists/netdev/msg192548.html
> 
> The problem with my multi-threading patches is that I was focused on
> the cgroup support parts and that lead to some gross decisions.
> 
> 1. I kept the cgroup support, but as a result I do not have control
> over the threading affinity and making sure cmds are executed on a
> optimal CPU like the above patches do.
> 
> When I drop the cgroup support and make sure threads are bound to
> specific CPUs and then make sure IO is run on the CPU it came in on
> then IOPs jumps from 600K to 800K for vhost-scsi.
> 
> 2. I can possible create a lot of threads.
> 
> So a couple open issues are:
> 
> 1. Can we do a thread per cpu that is shared across all vhost devices?
> That would lead to dropping the cgroup vhost worker support.
> 
> 2. Can we just use the kernel's workqueues then?


Problem is, we are talking about *lots* of CPU, IO etc and ATM cgroups
is how people expect to account for that overhead.

