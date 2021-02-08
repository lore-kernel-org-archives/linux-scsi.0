Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED6BC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 12:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48DBC64E8A
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 12:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233426AbhBHMEe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 07:04:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32544 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233570AbhBHMC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 07:02:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612785690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PTlcoT+IigUWQzE/5Lb/sZFJTttDVxoCx4ggLUb2mzc=;
        b=Blw9yFoEvaa3Sdy1kZOkx1K2QQN7KMNj77LTZUztX8xI3IgtZ0tj3v9p9CF6Tr7+Cus/Iy
        MUhnoAfGPqDv8cpKdlOvzPLfsdpPsQ9eT+u2tSvUUhVXLWuDZmg53uvJehGaZC6tYDkAx4
        5DcRT/pL4/bPU2e0o10yX0szbDeSaJM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-104-qiIGaivGOl2ETUnwsREHtA-1; Mon, 08 Feb 2021 07:01:29 -0500
X-MC-Unique: qiIGaivGOl2ETUnwsREHtA-1
Received: by mail-ed1-f69.google.com with SMTP id ay16so13090874edb.2
        for <linux-scsi@vger.kernel.org>; Mon, 08 Feb 2021 04:01:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PTlcoT+IigUWQzE/5Lb/sZFJTttDVxoCx4ggLUb2mzc=;
        b=OirjyQhxbNKCl9Gq1tO1mGOepIPn5bljTbNnR+0cjcndM7R9DsCNZ/Rf0FLsDBSsZV
         1qkhSqExMeFpxGiz00xJ+nngKlpymFeya158LRCA8EwuCG2DgVM6g8C8l9Agtiz58eTw
         kVae8MrKIC/nUjS6PrKufvp43POQ1cyF+9X+Q/GVbEYYk1pI4kU77GnGjkxr/k7NvaTP
         W2tev7SUSeOcOI9QLJweP1tF3ZkD+Ysw8nvLwv+RIOx6RlFWfI+bQwylcuLREBXBFwJM
         zxtV+2oZ+gSUWP3zD5lY0D+B1+T7EZOscvL0Begb+lw7lstOBBqo5AA25AAUIJ+mw5C8
         ftyw==
X-Gm-Message-State: AOAM531i9aKPDalhbp7bWJm+Ol385mAEmRqwpCxL9AUHshzsNy+VgPR9
        IJFqgd5tXnv7oNE9LR/UnBw8QFUITKQpUpT19Qtta6N2V74+KlC+8LLNuwZTyb539R+zrxzI0jO
        SOJrhc7zFwitr0I6S5u4HFw==
X-Received: by 2002:a05:6402:1914:: with SMTP id e20mr16757907edz.89.1612785687644;
        Mon, 08 Feb 2021 04:01:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6KUrSSLZ/WJvZD7GSCwfBw66PX8V89QFLyOzcHizAKpcWVSLgUjhtBHtAVbQuSaC5ixXRIw==
X-Received: by 2002:a05:6402:1914:: with SMTP id e20mr16757890edz.89.1612785687468;
        Mon, 08 Feb 2021 04:01:27 -0800 (PST)
Received: from redhat.com (bzq-79-180-2-31.red.bezeqint.net. [79.180.2.31])
        by smtp.gmail.com with ESMTPSA id h25sm8481385ejy.7.2021.02.08.04.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 04:01:26 -0800 (PST)
Date:   Mon, 8 Feb 2021 07:01:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/11] target: fix cmd plugging and completion
Message-ID: <20210208070050-mutt-send-email-mst@kernel.org>
References: <20210204113513.93204-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210204113513.93204-1-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 04, 2021 at 05:35:02AM -0600, Mike Christie wrote:
> The following patches made over Martin's 5.12 branches fix two
> issues:
> 
> 1. target_core_iblock plugs and unplugs the queue for every
> command. To handle this issue and handle an issue that
> vhost-scsi and loop were avoiding by adding their own workqueue,
> I added a new submission workqueue to LIO. Drivers can pass cmds
> to it, and we can then submit batches of cmds.
> 
> 2. vhost-scsi and loop on the submission side were doing a work
> per cmd and on the lio completion side it was doing a work per
> cmd. The cap on running works is 512 (max_active) and so we can
> end up end up using a lot of threads when submissions start blocking
> because they hit the block tag limit or the completion side blocks
> trying to send the cmd. In this patchset I just use a cmd list
> per session to avoid abusing the workueue layer.
> 
> The combined patchset fixes a major perf issue we've been hitting
> where IOPs is stuck at 230K when running:
> 
>     fio --filename=/dev/sda  --direct=1 --rw=randrw --bs=4k
>     --ioengine=libaio --iodepth=128  --numjobs=8 --time_based
>     --group_reporting --runtime=60
> 
> The patches in this set get me to 350K when using devices that
> have native IOPs of around 400-500K.
> 
> Note that 5.12 has some interrupt changes that my patches
> collide with. Martin's 5.12 branches had the changes so I
> based my patches on that.
> 

OK so feel free to merge through that branch.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

-- 
MST

