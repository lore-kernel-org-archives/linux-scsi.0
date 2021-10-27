Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39ED5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB4D610A0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 15:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhJ0QBP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 12:01:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30126 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237613AbhJ0QBO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 12:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635350328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ioaTgiOBkHVF6tc3oLKdRmClYuVdXj9TyVMa0MHMXSI=;
        b=f2Ktkxx/h/LzMVESxIWC6T/VSRZPIhX9mooeEBxDl587uS1/DVOya1t1zXFXwANYSycUxL
        T7Xrgheb7wYKrG24oIW5JswXaSO3y22WO3vJwlOadd9pSFy9qJC0n/LF72w0rb4cbi492v
        EsKwGPgEz+6q2mPGLK7eRiQPyFws2Vg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-H1coyCjYMcS_VAKP3I8WOQ-1; Wed, 27 Oct 2021 11:58:42 -0400
X-MC-Unique: H1coyCjYMcS_VAKP3I8WOQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD09A101B4A8;
        Wed, 27 Oct 2021 15:58:40 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 16EF25F4EE;
        Wed, 27 Oct 2021 15:58:27 +0000 (UTC)
Date:   Wed, 27 Oct 2021 23:58:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <YXl3H39vHAj2+SSL@T590>
References: <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
 <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590>
 <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
 <YXltPgRTxe+Xn66i@T590>
 <yq1wnlyzday.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1wnlyzday.fsf@ca-mkp.ca.oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 27, 2021 at 11:44:04AM -0400, Martin K. Petersen wrote:
> 
> Ming,
> 
> > request with scsi_cmnd may be allocated by the ufshpb driver, even it
> > should be fine to call ufshcd_queuecommand() directly for this driver
> > private IO, if the tag can be reused. One example is scsi_ioctl_reset().
> 
> scsi_ioctl_reset() allocates a new request, though, so that doesn't
> solve the forward progress guarantee. Whereas eh puts the saved request
> on the stack.

What I meant is to use one totally ufshpb private command allocated from
private slab to replace the spawned request, which is sent to ufshcd_queuecommand()
directly, so forward progress is guaranteed if the blk-mq request's tag can be
reused for issuing this private command. This approach takes a bit effort,
but avoids tags reservation.

Yeah, it is cleaner to use reserved tag for the spawned request, but we
need to know:

1) how many queue depth for the hba? If it is small, even 1 reservation
can affect performance.

2) how many inflight write buffer commands are to be supported? Or how many
is enough for obtaining expected performance? If the number is big, reserved
tags can't work.



Thanks,
Ming

