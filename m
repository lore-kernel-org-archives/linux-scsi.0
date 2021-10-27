Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21246C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 084A6604E9
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:16:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbhJ0PS5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 11:18:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233314AbhJ0PSz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 11:18:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635347789;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5+fmxyQ0WwUF9xqHGuT6VF+PZciYbhCS+vALlCQyHQI=;
        b=JmcigP52hIepEkQZlPkkOCmHDrNR3K1pnODrEdgYP++3He3LiesuBByf5Ht6QobuGvDZHD
        XldsLCiqKZkygYJVZfMH98keocuwG7KL4J3o0gPgasijvZjcWu1Zvp4y3SldXshReTMR/K
        lt7E+VTBPGC/jIWz+e2lYDiuw6cY9GU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-xN8d3KjpPeWhYOhGpMssrw-1; Wed, 27 Oct 2021 11:16:27 -0400
X-MC-Unique: xN8d3KjpPeWhYOhGpMssrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EF2E80A5C0;
        Wed, 27 Oct 2021 15:16:25 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71F2360BF1;
        Wed, 27 Oct 2021 15:16:18 +0000 (UTC)
Date:   Wed, 27 Oct 2021 23:16:14 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <YXltPgRTxe+Xn66i@T590>
References: <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
 <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590>
 <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 27, 2021 at 09:06:05AM -0600, Jens Axboe wrote:
> On 10/27/21 9:03 AM, Ming Lei wrote:
> > On Wed, Oct 27, 2021 at 07:12:31AM -0700, Keith Busch wrote:
> >> On Wed, Oct 27, 2021 at 06:16:19AM -0700, Bart Van Assche wrote:
> >>> On 10/26/21 10:27 PM, Christoph Hellwig wrote:
> >>>> On Tue, Oct 26, 2021 at 01:10:47PM -0700, Bart Van Assche wrote:
> >>>>> If blk_insert_cloned_request() is moved into the device mapper then I
> >>>>> think that blk_mq_request_issue_directly() will need to be exported.
> >>>>
> >>>> Which is even worse.
> >>>>
> >>>>> How
> >>>>> about the (totally untested) patch below for removing the
> >>>>> blk_insert_cloned_request() call from the UFS-HPB code?
> >>>>
> >>>> Which again doesn't fix anything.  The problem is that it fans out one
> >>>> request into two on the same queue, not the specific interface used.
> >>>
> >>> That patch fixes the reported issue, namely removing the additional accounting
> >>> caused by calling blk_insert_cloned_request(). Please explain why it is
> >>> considered wrong to fan out one request into two. That code could be reworked
> >>> such that the block layer is not involved as Adrian Hunter explained. However,
> >>> before someone spends time on making these changes I think that someone should
> >>> provide more information about why it is considered wrong to fan out one request
> >>> into two.
> >>
> >> The original request consumes a tag from that queue's tagset. If the
> >> lifetime of that tag depends on that same queue having another free tag,
> >> you can deadlock.
> > 
> > Just take a quick look at the code, if the spawned request can't be allocated,
> > scsi will return BLK_STS_RESOURCE for the original scsi request which will be
> > retried later by blk-mq.
> > 
> > So if tag depth is > 1 and max allowed inflight write buffer command is limited
> > as 1, there shouldn't be the deadlock.
> > 
> > Or is it possible to reuse the original scsi request's tag for the
> > spawned request? Like the trick used in inserting flush request.
> 
> The flush approach did come to mind here as well, but honestly that one is
> very ugly and would never have been permitted if it wasn't excluded to be
> in the very core code already. But yes, reuse of the existing request is
> probably another potentially viable approach. My worry there is that
> inevitably you end up needing to stash a lot of data to restore the original,
> and we're certainly not adding anything to struct request for that.
> 
> Hence I think being able to find a new request reliably would be better.

request with scsi_cmnd may be allocated by the ufshpb driver, even it
should be fine to call ufshcd_queuecommand() directly for this driver
private IO, if the tag can be reused. One example is scsi_ioctl_reset().


Thanks,
Ming

