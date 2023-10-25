Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3BFC25B6B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 23:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjJYXiw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjJYXiv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 19:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE160182
        for <linux-scsi@vger.kernel.org>; Wed, 25 Oct 2023 16:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698277087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/1ECK+sIckpLTVB9XtwPHYGwhamrPlJsgObLvY+fw0s=;
        b=eWlXaPfv+TuEq0uzmTDLqXDFBGTTi4BU5O0cLbaQ4aSD38YyOR0/AzjH3Jew5Z2ehOhBQH
        jmQugMIs6XdRMckeq+LXGxTr2XWsh9rRZmXrXC0HTQ7xz7Moxe47Kdmp+eJXx8eNyS6SL8
        T5UENWOlBwMs4vamvvHVrEwuQJ18zKY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-202-pOtxNkDCPvyuVogSIQ3s8Q-1; Wed, 25 Oct 2023 19:38:03 -0400
X-MC-Unique: pOtxNkDCPvyuVogSIQ3s8Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A291811E91;
        Wed, 25 Oct 2023 23:38:03 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FFE5492BFA;
        Wed, 25 Oct 2023 23:37:58 +0000 (UTC)
Date:   Thu, 26 Oct 2023 07:37:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, ming.lei@redhat.com
Subject: Re: [PATCH v4 0/3] Support disabling fair tag sharing
Message-ID: <ZTmm0kNdN2Eka6V6@fedora>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <ZTcr3AHr9l4sHRO2@fedora>
 <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
 <ZThwdPaeAFmhp58L@fedora>
 <faf6f9e4-e1fe-4934-8fdf-84383f51e740@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faf6f9e4-e1fe-4934-8fdf-84383f51e740@acm.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 25, 2023 at 12:01:33PM -0700, Bart Van Assche wrote:
> 
> On 10/24/23 18:33, Ming Lei wrote:
> > Yeah, performance does drop when queue depth is cut to half if queue
> > depth is low enough.
> > 
> > However, it isn't enough to just test perf over one LUN, what is the
> > perf effect when running IOs over the 2 or 5 data LUNs
> > concurrently?
> 
> I think that the results I shared are sufficient because these show the
> worst possible performance impact of fair tag sharing (two active
> logical units and much more activity on one logical unit than on the
> other).

You are talking about multi-lun case, and your change does affect
multi-lun code path, but your test result doesn't cover multi-lun,
is it enough?

At least your patch shouldn't cause performance regression on multi-lun IO
workloads, right?

> 
> > SATA should have similar issue too, and I think the improvement may be
> > more generic to bypass fair tag sharing in case of low queue depth
> > (such as < 32) if turns out the fair tag sharing doesn't work well in
> > case low queue depth.
> > 
> > Also the 'fairness' could be enhanced dynamically by scsi LUN's
> > queue depth, which can be adjusted dynamically.
> 
> Most SATA devices are hard disks. Hard disk IOPS are constrained by the
> speed with which the head of a hard disk can move. That speed hasn't
> changed much during the past 40 years. I'm not sure that hard disks are
> impacted as much as SSD devices by fair tag sharing.

What I meant is that SATA's queue depth is often 32 or 31, and still have
multi-lun cases.

At least from what you shared, the fair tag sharing doesn't work well
just because of low queue depth, nothing is actually related with UFS.

That is why I am wondering that why not force to disable fairing sharing
in case of low queue depth.

> 
> Any algorithm that is more complicated than what I posted probably would
> have a negative performance impact on storage devices that use NAND
> technology, e.g. UFS devices. So I prefer to proceed with this patch
> series and solve any issues with ATA devices separately. Once this patch
> series has been merged, it could be used as a basis for a solution for
> ATA devices. A solution for ATA devices does not have to be implemented
> in the block layer core - it could e.g. be implemented in the ATA subsystem.

I don't object to take the disabling fair sharing first, and I meant that
the fairness may be brought back by adjusting scsi_device's queue depth in
future.


Thanks,
Ming

