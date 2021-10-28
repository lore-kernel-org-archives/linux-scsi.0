Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC8F0C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 02:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD0B6610CF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 02:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhJ1CK1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 22:10:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54326 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhJ1CK0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 22:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635386880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DxCVVMv3l2GHtOcWuSw32BWDthcNJ1UrBbCzOlaAlo4=;
        b=LZRLWMdIq7IBUqUYpd/aybkvZ6fHJmMsX2IcjVWpJylUgg2agVwkgZpShZBB/H31OjP540
        iPYYk0Yi5Advee0+mRCbUPDiyQUxWK7XDmNR6/M0dPXMIP8Y4IlZRL4wF5c1RertUIwcNG
        HxTiWkIQB5oYawxasT9RPY76td/wjl8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-Gj358q2COVyJvuVg8xPKpw-1; Wed, 27 Oct 2021 22:07:54 -0400
X-MC-Unique: Gj358q2COVyJvuVg8xPKpw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9E3518125C4;
        Thu, 28 Oct 2021 02:07:52 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72CBC62A41;
        Thu, 28 Oct 2021 02:07:39 +0000 (UTC)
Date:   Thu, 28 Oct 2021 10:07:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     Keith Busch <kbusch@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <YXoF59XeZ5KS0jZj@T590>
References: <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590>
 <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
 <YXltPgRTxe+Xn66i@T590>
 <yq1wnlyzday.fsf@ca-mkp.ca.oracle.com>
 <YXl3H39vHAj2+SSL@T590>
 <20211027161632.GB2338303@dhcp-10-100-145-180.wdc.com>
 <CGME20211028004244epcas2p1f2212bf94ef861dfa6cd082c3cbb1803@epcms2p1>
 <20211028011022epcms2p1d2b2b1c56237c7cc1cca3a612f91b520@epcms2p1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028011022epcms2p1d2b2b1c56237c7cc1cca3a612f91b520@epcms2p1>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 28, 2021 at 10:10:22AM +0900, Daejun Park wrote:
> Hi Ming,
> 
> > On Wed, Oct 27, 2021 at 09:16:32AM -0700, Keith Busch wrote:
> > > On Wed, Oct 27, 2021 at 11:58:23PM +0800, Ming Lei wrote:
> > > > On Wed, Oct 27, 2021 at 11:44:04AM -0400, Martin K. Petersen wrote:
> > > > > 
> > > > > Ming,
> > > > > 
> > > > > > request with scsi_cmnd may be allocated by the ufshpb driver, even it
> > > > > > should be fine to call ufshcd_queuecommand() directly for this driver
> > > > > > private IO, if the tag can be reused. One example is scsi_ioctl_reset().
> > > > > 
> > > > > scsi_ioctl_reset() allocates a new request, though, so that doesn't
> > > > > solve the forward progress guarantee. Whereas eh puts the saved request
> > > > > on the stack.
> > > > 
> > > > What I meant is to use one totally ufshpb private command allocated from
> > > > private slab to replace the spawned request, which is sent to ufshcd_queuecommand()
> > > > directly, so forward progress is guaranteed if the blk-mq request's tag can be
> > > > reused for issuing this private command. This approach takes a bit effort,
> > > > but avoids tags reservation.
> > > > 
> > > > Yeah, it is cleaner to use reserved tag for the spawned request, but we
> > > > need to know:
> > > > 
> > > > 1) how many queue depth for the hba? If it is small, even 1 reservation
> > > > can affect performance.
> > > > 
> > > > 2) how many inflight write buffer commands are to be supported? Or how many
> > > > is enough for obtaining expected performance? If the number is big, reserved
> > > > tags can't work.
> > > 
> > > The original and clone are not dispatched to hardware concurrently, so I
> > > don't think the reserved_tags need to subtract from the generic ones.
> > > The original request already accounts for the hardware resource, so the
> > > clone doesn't need to consume another one.
> >  
> > Yeah, that is why I thought the tag could be reused for the spawned(cloned)
> > request, but it needs ufshpb developer to confirm, or at least
> > ufshcd_queuecommand() can handle this situation. If that is true, it isn't
> > necessary to use reserve tags, since the current blk-mq implementation
> > requires to reserve real hardware tags space, which has to take normal
> > tags.
> 
> It is true that pre-request can use the tag of READ request, but the READ
> request should wait to completion of the pre-request command. However, if
> the pre-request and the READ request are dispatched concurrently, it can
> save the time to completion of the pre-request.
> 
> So I implemented as allocating new request and it has limit time to getting
> pre-request, so it doesn't cause deadlock.

The WB pre-request and the READ IO should have been issued in single
command with same tag.

If they can't be done in single command, this sw/hw interface is really bad,
one way is to follow Jens's suggestion to reserve one tag for guaranteeing
forward progress, something like the following:

ufshpb_issue_pre_req()

        req = blk_get_request(cmd->device->request_queue,
                              REQ_OP_DRV_OUT | REQ_SYNC, BLK_MQ_REQ_NOWAIT);
        if (IS_ERR(req)) {
        	req = blk_get_request(cmd->device->request_queue,
                              REQ_OP_DRV_OUT | REQ_SYNC, BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED);
			if (IS_ERR(req))
                return -EAGAIN;
		}

But the above isn't what Christoph complained:

	The HPB support added this merge window is fundanetally flawed as it
	uses blk_insert_cloned_request to insert a cloned request onto the same
	queue as the one that the original request came from, leading to all
	kinds of issues in blk-mq accounting (in addition to this API being
	a special case for dm-mpath that should not see other users).

IMO, accounting seems fine since block layer always counts driver
private request.


thanks,
Ming

