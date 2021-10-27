Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B48FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A0BE610A0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235373AbhJ0PGc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 11:06:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237644AbhJ0PGb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 11:06:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635347045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UwtorSjj/1Fa2hgOt/yGBK0ucEnfbyQ1pqENTbjDNS4=;
        b=OZeA4rnrauzTL7FFa+Wy/C4FH9qbJGXaxToyvYx16arPWnLMuZOvkEL/Lk6UBct94BevpO
        Rbg/0l0NQzlt6fwafyuJ7H9BoHTu9E9/79P3TRf1BTE41e1G/it5cOhSlfxq8s4+dCGxNW
        NFND0QQtmbwhfz4Fl4eieslEBdB6f1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-YQEyFuFiPEGwm1vKYJbHwg-1; Wed, 27 Oct 2021 11:04:04 -0400
X-MC-Unique: YQEyFuFiPEGwm1vKYJbHwg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D3E61006AA3;
        Wed, 27 Oct 2021 15:04:02 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A2BFB5D740;
        Wed, 27 Oct 2021 15:03:42 +0000 (UTC)
Date:   Wed, 27 Oct 2021 23:03:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk@kernel.org>,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <YXlqSRLHuIFiMLY7@T590>
References: <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
 <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 27, 2021 at 07:12:31AM -0700, Keith Busch wrote:
> On Wed, Oct 27, 2021 at 06:16:19AM -0700, Bart Van Assche wrote:
> > On 10/26/21 10:27 PM, Christoph Hellwig wrote:
> > > On Tue, Oct 26, 2021 at 01:10:47PM -0700, Bart Van Assche wrote:
> > > > If blk_insert_cloned_request() is moved into the device mapper then I
> > > > think that blk_mq_request_issue_directly() will need to be exported.
> > > 
> > > Which is even worse.
> > > 
> > > > How
> > > > about the (totally untested) patch below for removing the
> > > > blk_insert_cloned_request() call from the UFS-HPB code?
> > > 
> > > Which again doesn't fix anything.  The problem is that it fans out one
> > > request into two on the same queue, not the specific interface used.
> > 
> > That patch fixes the reported issue, namely removing the additional accounting
> > caused by calling blk_insert_cloned_request(). Please explain why it is
> > considered wrong to fan out one request into two. That code could be reworked
> > such that the block layer is not involved as Adrian Hunter explained. However,
> > before someone spends time on making these changes I think that someone should
> > provide more information about why it is considered wrong to fan out one request
> > into two.
> 
> The original request consumes a tag from that queue's tagset. If the
> lifetime of that tag depends on that same queue having another free tag,
> you can deadlock.

Just take a quick look at the code, if the spawned request can't be allocated,
scsi will return BLK_STS_RESOURCE for the original scsi request which will be
retried later by blk-mq.

So if tag depth is > 1 and max allowed inflight write buffer command is limited
as 1, there shouldn't be the deadlock.

Or is it possible to reuse the original scsi request's tag for the
spawned request? Like the trick used in inserting flush request.


Thanks,
Ming

