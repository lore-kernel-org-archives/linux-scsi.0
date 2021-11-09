Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B01EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 03:22:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2766D6128B
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 03:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237366AbhKIDZe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 22:25:34 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:34242 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236036AbhKIDZe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 22:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636428168;
        bh=9dhlR2iR3q+QcK7cnucIpqkWdS2CeHR2weGgbkYNN2E=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=iraus9GSP/A/HcayzDVPLnWzpUVcjN9KsiTsXfmZMfHKUUgeFUpbTXXFERLKuQ3j9
         PzSLixK/txaJ1kDfTwPJ3HQmhSEq7lP1jVsG1+ggPUsaeBF3z1KsgJ2UgSXXxSXBBN
         nae/NnWbq6dUIJ3tEbLbwMPHGXqHPu2/ToYoc0s0=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D0B6C1280AB8;
        Mon,  8 Nov 2021 22:22:48 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YMnK7X4EzSLN; Mon,  8 Nov 2021 22:22:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1636428168;
        bh=9dhlR2iR3q+QcK7cnucIpqkWdS2CeHR2weGgbkYNN2E=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=iraus9GSP/A/HcayzDVPLnWzpUVcjN9KsiTsXfmZMfHKUUgeFUpbTXXFERLKuQ3j9
         PzSLixK/txaJ1kDfTwPJ3HQmhSEq7lP1jVsG1+ggPUsaeBF3z1KsgJ2UgSXXxSXBBN
         nae/NnWbq6dUIJ3tEbLbwMPHGXqHPu2/ToYoc0s0=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 95DB71280127;
        Mon,  8 Nov 2021 22:22:47 -0500 (EST)
Message-ID: <33b8edaa46a755caceac183390bb6fa8a82315bd.camel@HansenPartnership.com>
Subject: Re: [PATCH 3/4] scsi: make sure that request queue queiesce and
 unquiesce balanced
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 08 Nov 2021 22:22:46 -0500
In-Reply-To: <YYnooJNLvHIQA0Xk@T590>
References: <20211103034305.3691555-1-ming.lei@redhat.com>
         <20211103034305.3691555-4-ming.lei@redhat.com>
         <08f0e186093b0d5067347a1376228010cb4cc7f4.camel@HansenPartnership.com>
         <YYnEVuwp/jMngPYo@T590> <YYnooJNLvHIQA0Xk@T590>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-11-09 at 11:18 +0800, Ming Lei wrote:
> Hello James,
> 
> On Tue, Nov 09, 2021 at 08:44:06AM +0800, Ming Lei wrote:
> > Hello James,
> > 
> > On Mon, Nov 08, 2021 at 11:42:01AM -0500, James Bottomley wrote:
> > > On Wed, 2021-11-03 at 11:43 +0800, Ming Lei wrote:
> > > [...]
> > > > +void scsi_start_queue(struct scsi_device *sdev)
> > > > +{
> > > > +	if (cmpxchg(&sdev->queue_stopped, 1, 0))
> > > > +		blk_mq_unquiesce_queue(sdev->request_queue);
> > > > +}
> > > > +
> > > > +static void scsi_stop_queue(struct scsi_device *sdev, bool
> > > > nowait)
> > > > +{
> > > > +	if (!cmpxchg(&sdev->queue_stopped, 0, 1)) {
> > > > +		if (nowait)
> > > > +			blk_mq_quiesce_queue_nowait(sdev-
> > > > > request_queue);
> > > > +		else
> > > > +			blk_mq_quiesce_queue(sdev-
> > > > >request_queue);
> > > > +	} else {
> > > > +		if (!nowait)
> > > > +			blk_mq_wait_quiesce_done(sdev-
> > > > >request_queue);
> > > > +	}
> > > > +}
> > > 
> > > This looks counter intuitive.  I assume it's done so that if we
> > > call
> > > scsi_stop_queue when the queue has already been stopped, it waits
> > > until
> > 
> > The motivation is to balance
> > blk_mq_quiesce_queue_nowait()/blk_mq_quiesce_queue()
> > and blk_mq_unquiesce_queue().
> > 
> > That needs one extra mutex to cover the quiesce action and update
> > the flag, but we can't hold the mutex in
> > scsi_internal_device_block_nowait(),
> > so take this way with the atomic flag.
> > 
> > > the queue is actually quiesced before returning so the behaviour
> > > is the
> > > same in the !nowait case?  Some sort of comment explaining that
> > > would
> > > be useful.
> > 
> > I will add comment on the current usage.
> 
> Are you fine with the following comment?
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e8925a35cb3a..9e3bf028f95a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2661,6 +2661,13 @@ void scsi_start_queue(struct scsi_device
> *sdev)
>  
>  static void scsi_stop_queue(struct scsi_device *sdev, bool nowait)
>  {
> +	/*
> +	 * The atomic variable of ->queue_stopped covers that
> +	 * blk_mq_quiesce_queue* is balanced with
> blk_mq_unquiesce_queue.
> +	 *
> +	 * However, we still need to wait until quiesce is done
> +	 * in case that queue has been stopped.
> +	 */
>  	if (!cmpxchg(&sdev->queue_stopped, 0, 1)) {
>  		if (nowait)
>  			blk_mq_quiesce_queue_nowait(sdev-
> >request_queue);

Yes, that looks fine ... it will at least act as a caution for
maintainers who come after us.

James


