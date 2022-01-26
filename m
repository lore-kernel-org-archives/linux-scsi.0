Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1DCC2BA4C
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 08:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbiAZIeI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 03:34:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238516AbiAZIeG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jan 2022 03:34:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643186046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zhld679OtRHf8+7VQTmFxSv+4G0lijmMBnc3vJ5uEPc=;
        b=ew9fiX0JMU+WcJFzVoZ3ML6SliLbO5DdYEiT842VJWRYk2xpCzfDk1Tq6IbGVodrhefKwO
        rWIQvPar0U4pQ/jsux69UXcZM8ILkUgNanSX42r5iG6L18XRdgESZRgQqJTYNE/ZOcyAKv
        vCRN+W24CeOMr6xBnnn0IrFIy3gKmU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-lfgIWFVTNhyTV7iEVOOU9Q-1; Wed, 26 Jan 2022 03:34:04 -0500
X-MC-Unique: lfgIWFVTNhyTV7iEVOOU9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7CC201083F60;
        Wed, 26 Jan 2022 08:34:03 +0000 (UTC)
Received: from T590 (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B52337A226;
        Wed, 26 Jan 2022 08:33:59 +0000 (UTC)
Date:   Wed, 26 Jan 2022 16:33:54 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <YfEHcs6psrBqFu3l@T590>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-6-ming.lei@redhat.com>
 <20220124130555.GD27269@lst.de>
 <Ye8xleeYZfmwA3D7@T590>
 <20220125061634.GA26495@lst.de>
 <20220125071906.GA27674@lst.de>
 <Ye++VmBkg0I8Lq8+@T590>
 <20220126055003.GA21089@lst.de>
 <YfD2YNRf+lhe5BcU@T590>
 <20220126081052.GA23154@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126081052.GA23154@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 26, 2022 at 09:10:52AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 26, 2022 at 03:21:04PM +0800, Ming Lei wrote:
> > > I think the right way would be to just remove this branch entirely.
> > > This means we only account bios with a block_device, which implies
> > > they have a gendisk.
> > 
> > That will not account userspace IO, and people may complain.
> > 
> > We can just account passthrough request from userspace by the patch
> > in my last email.
> 
> Let's take a step back:  what I/O do we want to account, and how
> do we want to archive that?

FS IO, and passthrough IO from userspace at least, since
that is what user cares.

Also the bdev/disk is guaranteed to be live when this userspace
passthrough IO is inflight.

> 
> Assuming accounting is enabled:
> 
>  - current mainline accounts all I/O one queues that have a gendisk
>  - your original patch accounts file system I/O and some passthrough I/O
>    that has a special flag set

The special flag is just for recognizing userspace passthrough IO.

> 
> Dropping the conditional to grab a bdev from the queue leaves us with
> the following rule:
> 
>  - all I/O that has a bio and bdev is accounted.  This requires
>    passthrough I/O to explicitly set the bdev in case we haven't
>    done so, and it requires them to have a bio at all

That is basically to make bio->bi_bdev points to part0, and the
problem is that you have to make sure that part0 won't be released
when this request is inflight.

> 
> I guess you are worried about the latter conditionin that we stop
> accounting for no data transfer passthrough commands?

No, I meant that bio->bi_bdev isn't setup yet for passthrough request,
and not sure that can be done easily.


Thanks,
Ming

