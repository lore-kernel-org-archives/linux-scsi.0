Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57339C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 00:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F71D60F9B
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 00:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhJ1ApG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 20:45:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37932 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229437AbhJ1ApG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 20:45:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635381759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fghCXlqFJqhbevuBMyBOvHVtTIBGNx/lQY5qSJ6s38o=;
        b=Lq/o9CgCWsXe+mq3Znf/DR2kxwuzOs6yTNfkdLhaQf9jWpznEvnhCsTyP6Esf9wWhteXVW
        HJPzb9dJWyV1ca+iPSPTHTgbBPWW5dSqPowX+iJp6QwwXCZxP5nBeRNq28sf5xF3uOkbhS
        nGl0levJb0CFrO9gPEFzvJZdWfX4q+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-9WvrQj6JPgaXxotGUun5xQ-1; Wed, 27 Oct 2021 20:42:36 -0400
X-MC-Unique: 9WvrQj6JPgaXxotGUun5xQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5517818414A0;
        Thu, 28 Oct 2021 00:42:34 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C87C71A26A;
        Thu, 28 Oct 2021 00:42:24 +0000 (UTC)
Date:   Thu, 28 Oct 2021 08:42:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <YXnx7EIFMTH8czLa@T590>
References: <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
 <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590>
 <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
 <YXltPgRTxe+Xn66i@T590>
 <yq1wnlyzday.fsf@ca-mkp.ca.oracle.com>
 <YXl3H39vHAj2+SSL@T590>
 <20211027161632.GB2338303@dhcp-10-100-145-180.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027161632.GB2338303@dhcp-10-100-145-180.wdc.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 27, 2021 at 09:16:32AM -0700, Keith Busch wrote:
> On Wed, Oct 27, 2021 at 11:58:23PM +0800, Ming Lei wrote:
> > On Wed, Oct 27, 2021 at 11:44:04AM -0400, Martin K. Petersen wrote:
> > > 
> > > Ming,
> > > 
> > > > request with scsi_cmnd may be allocated by the ufshpb driver, even it
> > > > should be fine to call ufshcd_queuecommand() directly for this driver
> > > > private IO, if the tag can be reused. One example is scsi_ioctl_reset().
> > > 
> > > scsi_ioctl_reset() allocates a new request, though, so that doesn't
> > > solve the forward progress guarantee. Whereas eh puts the saved request
> > > on the stack.
> > 
> > What I meant is to use one totally ufshpb private command allocated from
> > private slab to replace the spawned request, which is sent to ufshcd_queuecommand()
> > directly, so forward progress is guaranteed if the blk-mq request's tag can be
> > reused for issuing this private command. This approach takes a bit effort,
> > but avoids tags reservation.
> > 
> > Yeah, it is cleaner to use reserved tag for the spawned request, but we
> > need to know:
> > 
> > 1) how many queue depth for the hba? If it is small, even 1 reservation
> > can affect performance.
> > 
> > 2) how many inflight write buffer commands are to be supported? Or how many
> > is enough for obtaining expected performance? If the number is big, reserved
> > tags can't work.
> 
> The original and clone are not dispatched to hardware concurrently, so I
> don't think the reserved_tags need to subtract from the generic ones.
> The original request already accounts for the hardware resource, so the
> clone doesn't need to consume another one.

Yeah, that is why I thought the tag could be reused for the spawned(cloned)
request, but it needs ufshpb developer to confirm, or at least
ufshcd_queuecommand() can handle this situation. If that is true, it isn't
necessary to use reserve tags, since the current blk-mq implementation
requires to reserve real hardware tags space, which has to take normal
tags.


thanks,
Ming

