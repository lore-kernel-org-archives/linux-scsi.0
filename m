Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A875EC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 16:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EE37610A3
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 16:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238146AbhJ0QTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 12:19:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhJ0QTC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Oct 2021 12:19:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 778EF60F38;
        Wed, 27 Oct 2021 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635351396;
        bh=Ogt82C1O4jkG8UCwaYYVQYH+ZPYfFRKUobDxmh+AOME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=efZmmTwUHQbgtWBryUM5vrIqAhDc+1bmqNc2CSCjccjYpDpXHmTPPzFX1Xs6wO78u
         km3aEMM5LZ2jBXrZy5pYEJ0e0bokVv8cRI9WD2aoGAPHgTm0A6sQTmsjufrK+juxVc
         +W3F0WsRXAfLRqw+qjAKpX4Qr4dnhjC4oQzhJNDCoD6wqsZnKhDalDUTRKyC7TN7va
         V9GzGrAiu/hCgysu4rU+e+dqHCttDCdoNEaQXSKAUwBrWxBVAyLISjUxie21gqZk7C
         FAfdv6guW9Rko3k9lT9S3xtDEAV7KNVD55Xhq8jvWj/gfW5GVlivXhMQI0Iv/MnqDG
         RhoevI1l/EyXw==
Date:   Wed, 27 Oct 2021 09:16:32 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
Message-ID: <20211027161632.GB2338303@dhcp-10-100-145-180.wdc.com>
References: <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org>
 <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
 <YXlqSRLHuIFiMLY7@T590>
 <3f43feaa-5c3a-9e4c-ebc1-c982b0723e7e@kernel.dk>
 <YXltPgRTxe+Xn66i@T590>
 <yq1wnlyzday.fsf@ca-mkp.ca.oracle.com>
 <YXl3H39vHAj2+SSL@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXl3H39vHAj2+SSL@T590>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 27, 2021 at 11:58:23PM +0800, Ming Lei wrote:
> On Wed, Oct 27, 2021 at 11:44:04AM -0400, Martin K. Petersen wrote:
> > 
> > Ming,
> > 
> > > request with scsi_cmnd may be allocated by the ufshpb driver, even it
> > > should be fine to call ufshcd_queuecommand() directly for this driver
> > > private IO, if the tag can be reused. One example is scsi_ioctl_reset().
> > 
> > scsi_ioctl_reset() allocates a new request, though, so that doesn't
> > solve the forward progress guarantee. Whereas eh puts the saved request
> > on the stack.
> 
> What I meant is to use one totally ufshpb private command allocated from
> private slab to replace the spawned request, which is sent to ufshcd_queuecommand()
> directly, so forward progress is guaranteed if the blk-mq request's tag can be
> reused for issuing this private command. This approach takes a bit effort,
> but avoids tags reservation.
> 
> Yeah, it is cleaner to use reserved tag for the spawned request, but we
> need to know:
> 
> 1) how many queue depth for the hba? If it is small, even 1 reservation
> can affect performance.
> 
> 2) how many inflight write buffer commands are to be supported? Or how many
> is enough for obtaining expected performance? If the number is big, reserved
> tags can't work.

The original and clone are not dispatched to hardware concurrently, so I
don't think the reserved_tags need to subtract from the generic ones.
The original request already accounts for the hardware resource, so the
clone doesn't need to consume another one.
