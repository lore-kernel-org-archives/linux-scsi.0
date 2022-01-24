Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B16C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 00:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358922AbiAYAbC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 19:31:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1839095AbiAXXJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Jan 2022 18:09:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643065775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sbJA2xuz3URkRYCZHu8yHlPerUmywWzM55rS4FYvDFo=;
        b=bzxYf9GMbvL5WuyiaAB3uEdX5XPuG5YTAlA345jrUTh6NbJ3dhIxu0kZAUst65oOYNAS9r
        x0kzLCPx+AWbzkqshDq/QGpI4W1qDPZvpNPUftk9AE3hM7XaYgIiDcMuVZnQYE+v+5v12p
        1AX6qYBiaaSuQQ7ohcjwOpmymNQykAE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333--DPA2fEiNG2r-rihv1RRCg-1; Mon, 24 Jan 2022 18:09:32 -0500
X-MC-Unique: -DPA2fEiNG2r-rihv1RRCg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF8AF1B18BC0;
        Mon, 24 Jan 2022 23:09:30 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D98845ED44;
        Mon, 24 Jan 2022 23:09:14 +0000 (UTC)
Date:   Tue, 25 Jan 2022 07:09:09 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <Ye8xleeYZfmwA3D7@T590>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-6-ming.lei@redhat.com>
 <20220124130555.GD27269@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124130555.GD27269@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 24, 2022 at 02:05:55PM +0100, Christoph Hellwig wrote:
> On Sat, Jan 22, 2022 at 07:10:46PM +0800, Ming Lei wrote:
> > Passthrough request from userspace has one active block_device/disk
> > associated, so they can be accounted via rq->q->disk. For other
> > passthrough request, there may not be disk/block_device for the queue,
> > since either the queue has not a disk or the disk may be deleted
> > already.
> > 
> > Add flag of BLK_MQ_REQ_USER_IO for only accounting passthrough request
> > from userspace.
> 
> Please explain why you want to change this.

Please see the following code:

        /* passthrough requests can hold bios that do not have ->bi_bdev set */
        if (rq->bio && rq->bio->bi_bdev)
                rq->part = rq->bio->bi_bdev;
        else if (rq->q->disk)
                rq->part = rq->q->disk->part0;

q->disk can be cleared by disk_release() just when referring the above line, then
NULL ptr reference is caused, and similar issue with any reference to rq->part for
passthrough request sent not from userspace.

> 
> Also this is missing I/O from /dev/sg, CDROM CDDA BPC reading, the tape
> drivers and bsg-lib.

Except for CDROM CDDA BPC reading, the others don't have gendisk associated,
so they needn't such change. And it looks easy to do that for CDROM CDDA BPC
reading.


Thanks,
Ming

