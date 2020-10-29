Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A884DC2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 21:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 418E520838
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 21:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zx7FgyTH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJ2VsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 17:48:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgJ2VsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Oct 2020 17:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604008087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C8IJKdjzJP+Bzd+JavwFMGhO/rLMWGB7CifWdQeTL5s=;
        b=Zx7FgyTHvw/rAtUY28zqKzq85zHFBfAXjjCxfvXZIuol8H1DHYAJoCOfJUciocO6hKyYYp
        Nit+aGYwNS6He2j2fIYV07iGVPV5oA+A+J1fn/4OTppzc47Cj2fcp08IHgUUFuNZvlaOTK
        VCOTrhq5Myqrg/KOgSQ3q98mT4R28QY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-eD9Yd2aPM-CvGXu9KnHc8A-1; Thu, 29 Oct 2020 17:48:03 -0400
X-MC-Unique: eD9Yd2aPM-CvGXu9KnHc8A-1
Received: by mail-wr1-f69.google.com with SMTP id v5so1823404wrq.6
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2020 14:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C8IJKdjzJP+Bzd+JavwFMGhO/rLMWGB7CifWdQeTL5s=;
        b=Ls95pC525/Ul+/rgStX8rr3AqfIcuzfH8jPpunzqXXL2cuupalosbHFhoyFC2b+LCo
         04X63qZC7J/I/LewSIv7rok10b1OE/03+7KXFK+NBPsQkEGEXkOJhCtbjhVg6pD/06EE
         CXP2A9jShPjXRcbIyPJwrdevjxFigXKR8uqAWw+W4da+lL6CwX2CM8XX/FH24j6pSHrN
         RfFLfkGHaw5TuPXUKoq2YBMtlPS1SfHByajUhZfi8eNFe4WW4PtLWzCN4WinkRqQkyDW
         3nE5/YiuCDxy7h6zkRxdA6WyzuzGhSMlA9G22JbV5UUI1/fOSvgh/I/tuTKV5XLaWokb
         6o4Q==
X-Gm-Message-State: AOAM531MlauMYAnCHCnB4fPbtPd3X1vSXtw4GHrI+Z5aAtZdBNPdsjmh
        sNhMe/ywb2uFQ/H6Woli0o3+NsZY+6/5+mXjNatt+8jB6beXe49NzVTFRc1MfHzHiouJpv18R88
        weg40hvlOYGL+IePzFyE9gw==
X-Received: by 2002:a05:600c:2942:: with SMTP id n2mr1314935wmd.101.1604008082648;
        Thu, 29 Oct 2020 14:48:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmu0E08+0xXvcCyh4rjZmuCm6ekREYSNVbN7A50ZEg8itLvFMCN+GkjqSlqVDyY3ajxG1dzg==
X-Received: by 2002:a05:600c:2942:: with SMTP id n2mr1314921wmd.101.1604008082448;
        Thu, 29 Oct 2020 14:48:02 -0700 (PDT)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id v67sm2001236wma.17.2020.10.29.14.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 14:48:01 -0700 (PDT)
Date:   Thu, 29 Oct 2020 17:47:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/17 V3] vhost: fix scsi cmd handling and cgroup support
Message-ID: <20201029174719-mutt-send-email-mst@kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 21, 2020 at 07:34:46PM -0500, Mike Christie wrote:
> In-Reply-To: 
> 
> The following patches were made over Michael's vhost branch here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost
> 
> They fix a couple issues with vhost-scsi when we hit the 256 cmd limit
> that result in the guest getting IO errors, add LUN reset support so
> devices are not offlined during transient errors, allow us to manage
> vhost scsi IO with cgroups, and imrpove IOPs up to 2X.
> 
> The following patches are a follow up to this post:
> https://patchwork.kernel.org/project/target-devel/cover/1600712588-9514-1-git-send-email-michael.christie@oracle.com/
> which originally was fixing how vhost-scsi handled cmds so we would
> not get IO errors when sending more than 256 cmds.
> 
> In that patchset I needed to detect if a vq was in use and for this
> patch:
> https://patchwork.kernel.org/project/target-devel/patch/1600712588-9514-3-git-send-email-michael.christie@oracle.com/
> It was suggested to add support for VHOST_RING_ENABLE. While doing
> that though I hit a couple problems:
> 
> 1. The patches moved how vhost-scsi allocated cmds from per lio
> session to per vhost vq. To support both VHOST_RING_ENABLE and
> where userspace didn't support it, I would have to keep around the
> old per session/device cmd allocator/completion and then also maintain
> the new code. Or, I would still have to use this patch
> patchwork.kernel.org/cover/11790763/ for the compat case so there
> adding the new ioctl would not help much.
> 
> 2. For vhost-scsi I also wanted to prevent where we allocate iovecs
> for 128 vqs even though we normally use a couple. To do this, I needed
> something similar to #1, but the problem is that the VHOST_RING_ENABLE
> call would come too late.
> 
> To try and balance #1 and #2, these patches just allow vhost-scsi
> to setup a vq when userspace starts to config it. This allows the
> driver to only fully setup (we still waste some memory to support older
> setups but do not have to preallocate everything like before) what
> is used plus I do not need to maintain 2 code paths.


OK, so could we get a patchset with just bugfixes for this release
please?
And features should go into next one ...

> V3:
> - fix compile errors
> - fix possible crash where cmd could be freed while adding it to
> completion list
> - fix issue where we added the worker thread to the blk cgroup but
> the blk IO was submitted by a driver workqueue.
> 
> V2:
> - fix use before set cpu var errors
> - drop vhost_vq_is_setup
> - include patches to do a worker thread per scsi IO vq
> 

