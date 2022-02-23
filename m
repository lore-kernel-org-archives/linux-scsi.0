Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD650C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 07:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238545AbiBWHDG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 02:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiBWHDB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 02:03:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9036A69289
        for <linux-scsi@vger.kernel.org>; Tue, 22 Feb 2022 23:02:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645599753;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Owek6fCckOub97SDubtb8UQJDZRBFEMxcdm9T4nzMw=;
        b=FpUv50eImM2LoJxDnXMgF5wBK1H230bG591ZNx0Wzj5Zls9NJ8Q6uB11ocZCCLV+0SO9Mf
        waEJVCJ5iM56urAWS2kYUYEVYwzehm1IFOyI542V44CpaGNdcHikfJozWeInpeE9xGYNk6
        JRrDC1kjLRMpcDBoAqXaK3Xoo8Y4NKg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-lepDuOmINk6ARxHtsqn0ug-1; Wed, 23 Feb 2022 02:02:29 -0500
X-MC-Unique: lepDuOmINk6ARxHtsqn0ug-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A412FC85;
        Wed, 23 Feb 2022 07:02:28 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F2386646A9;
        Wed, 23 Feb 2022 07:02:13 +0000 (UTC)
Date:   Wed, 23 Feb 2022 15:02:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/12] blk-mq: do not include passthrough requests in I/O
 accounting
Message-ID: <YhXb8CrfBqQZhYyZ@T590>
References: <20220222141450.591193-1-hch@lst.de>
 <20220222141450.591193-2-hch@lst.de>
 <YhWXFMhdms1QO1dL@T590>
 <20220223064226.GA31307@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223064226.GA31307@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 23, 2022 at 07:42:26AM +0100, Christoph Hellwig wrote:
> On Wed, Feb 23, 2022 at 10:08:20AM +0800, Ming Lei wrote:
> > > -	return (rq->rq_flags & RQF_IO_STAT) && rq->q->disk;
> > > +	return (rq->rq_flags & RQF_IO_STAT) && !blk_rq_is_passthrough(rq);
> > 
> > I guess this way may cause regression for workloads with lots of userspace IO
> > from user viewpoint?
> 
> I'd say it fixes it as the accounting right now is completely bogus.

There are small amount of in-kernel passthrough requests(admin, or driver
private) which shouldn't be accounted, but passthrough RW IO requests from
userspace can be lots of, and user may rely on diskstat to account them.


Thanks,
Ming

