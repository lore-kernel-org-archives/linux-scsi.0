Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC62C388F9
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 15:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79C6D221F9
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 15:46:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I0gPGOsy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463560AbgJWPqW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 11:46:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28261 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S463538AbgJWPqV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Oct 2020 11:46:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603467980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pg4PolbChlXgMcboLrdK2mDe5zthtIw6r01+hUXbyGQ=;
        b=I0gPGOsybXcwx2siFSHZIeTeMj8rvbcywKOZoGUckpvkc+AgjQvjjFvK2WTfROR2zpDaof
        alB/JAyDvLRHSbCgtSdgCiOLP60d8OMeSKczjeVHB1gbJ+2IQLe5jQP/+x33XfArK/gbW7
        CbGUHxGf3BMa23MCO+AnRwqcZX9N9nc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-yIHxag6FPu-p4AJKr68Zsg-1; Fri, 23 Oct 2020 11:46:18 -0400
X-MC-Unique: yIHxag6FPu-p4AJKr68Zsg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F40C1891E82;
        Fri, 23 Oct 2020 15:46:17 +0000 (UTC)
Received: from redhat.com (ovpn-113-117.ams2.redhat.com [10.36.113.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C51C45D9CC;
        Fri, 23 Oct 2020 15:46:11 +0000 (UTC)
Date:   Fri, 23 Oct 2020 11:46:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/16 V2] vhost: fix scsi cmd handling and IOPs
Message-ID: <20201023114539-mutt-send-email-mst@kernel.org>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 07, 2020 at 03:54:45PM -0500, Mike Christie wrote:
> The following patches were made over Michael's vhost branch here:
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost
>  
> The patches also apply to Linus's or Martin's trees if you apply
> https://patchwork.kernel.org/patch/11790681/
> which was merged into mst's tree already.
> 
> The following patches are a follow up to this post:
> https://patchwork.kernel.org/cover/11790763/
> which originally was fixing how vhost-scsi handled cmds so we would
> not get IO errors when sending more than 256 cmds.
> 
> In that patchset I needed to detect if a vq was in use and for this
> patch:
> https://patchwork.kernel.org/patch/11790685/
> it was suggested to add support for VHOST_RING_ENABLE. While doing
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
> 
> Note that in this posting I am also including additional patches
> that create multiple vhost worker threads, because I wanted to see
> if people felt that maybe to support that and for this enablement
> issue we want a completely a new ioctl.
> 
> 
> V2:
> - fix use before set cpu var errors
> - drop vhost_vq_is_setup
> - include patches to do a worker thread per scsi IO vq

Stefan, Paolo, Jason any input?

-- 
MST

