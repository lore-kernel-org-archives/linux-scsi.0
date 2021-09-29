Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57619C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 08:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E97560EBD
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 08:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244367AbhI2IG0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:06:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244345AbhI2IGX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 04:06:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632902683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E3crSTrUNdR0NaQQrRsu6FRgIiQrkJ+OMm9iOREuUAY=;
        b=U3CtFcooS/kbuc2x2RckKnH7hXjLZSnxx4PKdlsErxHAC9jtqaVceR+S+49uCaZZpUkk+N
        vHHp5rJjlR3Nkdy5SpDdn2U9BAl2Q6BqjPx/t5Pte0JlPOXdnuc7TFArgr2WaqpXLevZxp
        eYEP64DW+6LhzCGb4liYqZY4J1KmxQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-OMvHV8brMSiPaBwniWU4tw-1; Wed, 29 Sep 2021 04:04:39 -0400
X-MC-Unique: OMvHV8brMSiPaBwniWU4tw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5080D5074D;
        Wed, 29 Sep 2021 08:04:37 +0000 (UTC)
Received: from T590 (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4DE71007606;
        Wed, 29 Sep 2021 08:04:30 +0000 (UTC)
Date:   Wed, 29 Sep 2021 16:04:25 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-block@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: remove ->rq_disk
Message-ID: <YVQeCdF/kT46pkC5@T590>
References: <20210928052211.112801-1-hch@lst.de>
 <YVMnk/8HIR/yhWYr@T590>
 <20210929070733.GA31869@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929070733.GA31869@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 29, 2021 at 09:07:33AM +0200, Christoph Hellwig wrote:
> On Tue, Sep 28, 2021 at 10:32:51PM +0800, Ming Lei wrote:
> > Hello Christoph,
> > 
> > On Tue, Sep 28, 2021 at 07:22:06AM +0200, Christoph Hellwig wrote:
> > > Hi Jens,
> > > 
> > > this series removes the rq_disk field in struct request, which isn't
> > > needed now that we can get the disk from the request_queue.
> > 
> > Can we hold on this series until q->disk becomes really reliable[1][2]?
> 
> It's not like q->disk isn't reliable.  It is that we don't kill all bios

q->disk will be cleaned in gendisk's release handler, which may happen before
or after blk_cleanup_queue().

> when tearing down the gendisk, which is an old problem that got worse.

It is fine to not kill all bios when tearing down gendisk if BDI isn't
retrieved from q->disk->bdi since gendisk has same lifetime with bdev.

So what is the old problem?

> That being said I'm resending this again.

No, either your patch or mine can't fix the issue, and I will comment on
your resending.


Thanks, 
Ming

