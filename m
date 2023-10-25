Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA746C25B48
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 01:34:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjJYBen (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 21:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJYBem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 21:34:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2423D186
        for <linux-scsi@vger.kernel.org>; Tue, 24 Oct 2023 18:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698197633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A3TQsqkRGlPNiZ+JZLFomByYV2iT/ADb69ZCQ3/IL3g=;
        b=fnQ/gbyAG7iZnkAbjhZ5ECvrrUsCuKVrCNKVJMayntml3E8vb2hS4Jl/x2UdGKJ4si9cgA
        VtoJdatIW6zCZqopYYS85zAcmgV/rUO7rrvhUijeFnu3puCTuEhbIojr2h3LWdSIvx/x0B
        eKAe5mYQSZzS/bAkk4ijuM5heBEmIBQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-0L4aYGwuPNyTVHZIvoQeWg-1; Tue, 24 Oct 2023 21:33:49 -0400
X-MC-Unique: 0L4aYGwuPNyTVHZIvoQeWg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89CC0828AC3;
        Wed, 25 Oct 2023 01:33:48 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9457E492BD9;
        Wed, 25 Oct 2023 01:33:44 +0000 (UTC)
Date:   Wed, 25 Oct 2023 09:33:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, ming.lei@redhat.com
Subject: Re: [PATCH v4 0/3] Support disabling fair tag sharing
Message-ID: <ZThwdPaeAFmhp58L@fedora>
References: <20231023203643.3209592-1-bvanassche@acm.org>
 <ZTcr3AHr9l4sHRO2@fedora>
 <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d37f5ed-130a-4e75-b9a7-f77aeb4c7c89@acm.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 24, 2023 at 09:41:50AM -0700, Bart Van Assche wrote:
> On 10/23/23 19:28, Ming Lei wrote:
> > On Mon, Oct 23, 2023 at 01:36:32PM -0700, Bart Van Assche wrote:
> > > Performance of UFS devices is reduced significantly by the fair tag sharing
> > > algorithm. This is because UFS devices have multiple logical units and a
> > > limited queue depth (32 for UFS 3.1 devices) and also because it takes time to
> > > give tags back after activity on a request queue has stopped. This patch series
> > > addresses this issue by introducing a flag that allows block drivers to
> > > disable fair sharing.
> > > 
> > > Please consider this patch series for the next merge window.
> > 
> > In previous post[1], you mentioned that the issue is caused by non-IO
> > queue of WLUN, but in this version, looks there isn't such story any more.
> > 
> > IMO, it isn't reasonable to account non-IO LUN for tag fairness, so
> > solution could be to not take non-IO queue into account for fair tag
> > sharing. But disabling fair tag sharing for this whole tagset could be
> > too over-kill.
> > 
> > And if you mean normal IO LUNs, can you share more details about the
> > performance drop? such as the test case, how many IO LUNs, and how to
> > observe performance drop, cause it isn't simple any more since multiple
> > LUN's perf has to be considered.
> > 
> > [1] https://lore.kernel.org/linux-block/20231018180056.2151711-1-bvanassche@acm.org/
> 
> Hi Ming,
> 
> Submitting I/O to a WLUN is only one example of a use case that
> activates the fair sharing algorithm for UFS devices. Another use
> case is simultaneous activity for multiple data LUNs. Conventional
> UFS devices typically have four data LUNs and zoned UFS devices
> typically have five data LUNs. From an Android device with a zoned UFS
> device:
> 
> $ adb shell ls /sys/class/scsi_device
> 0:0:0:0
> 0:0:0:1
> 0:0:0:2
> 0:0:0:3
> 0:0:0:4
> 0:0:0:49456
> 0:0:0:49476
> 0:0:0:49488
> 
> The first five are data logical units. The last three are WLUNs.
> 
> For a block size of 4 KiB, I see 144 K IOPS for queue depth 31 and
> 107 K IOPS for queue depth 15 (queue depth is reduced from 31 to 15
> if I/O is being submitted to two LUNs simultaneously). In other words,
> disabling fair sharing results in up to 35% higher IOPS for small reads
> and in case two logical units are active simultaneously. I think that's
> a very significant performance difference.

Yeah, performance does drop when queue depth is cut to half if queue
depth is low enough.

However, it isn't enough to just test perf over one LUN, what is the
perf effect when running IOs over the 2 or 5 data LUNs concurrently?

SATA should have similar issue too, and I think the improvement may be
more generic to bypass fair tag sharing in case of low queue depth
(such as < 32) if turns out the fair tag sharing doesn't work well
in case low queue depth.

Also the 'fairness' could be enhanced dynamically by scsi LUN's queue depth,
which can be adjusted dynamically.


Thanks, 
Ming

