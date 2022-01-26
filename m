Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D368BC28CF5
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 09:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbiAZJ7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:59:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:60316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239488AbiAZJ7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jan 2022 04:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643191176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zMHF6f0MT3+XJF4o6Gm2OrzeZ0dXQYMGKwzgfSSU6fw=;
        b=LcIEhCT+6AMCIak1+ddrKru67ekjutd3IzDcnESTACqozQdaLs7LOWbQ/luM9IIATHDtPv
        4CpkOgEs4A7ILcx985WfNBclo128fejAwK9RLsLy9LxHgZa+Tgo3czY0uZPH8ec1po4iYl
        PoaVBGX80jiQdFW5QZ7ycZzI06jwZX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-6Qau-70pOiqE3W5BYG2Naw-1; Wed, 26 Jan 2022 04:59:34 -0500
X-MC-Unique: 6Qau-70pOiqE3W5BYG2Naw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9978B51082;
        Wed, 26 Jan 2022 09:59:33 +0000 (UTC)
Received: from T590 (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C96E6128B;
        Wed, 26 Jan 2022 09:59:13 +0000 (UTC)
Date:   Wed, 26 Jan 2022 17:59:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <YfEbbPr1Q5Ci48cg@T590>
References: <20220124130555.GD27269@lst.de>
 <Ye8xleeYZfmwA3D7@T590>
 <20220125061634.GA26495@lst.de>
 <20220125071906.GA27674@lst.de>
 <Ye++VmBkg0I8Lq8+@T590>
 <20220126055003.GA21089@lst.de>
 <YfD2YNRf+lhe5BcU@T590>
 <20220126081052.GA23154@lst.de>
 <YfEHcs6psrBqFu3l@T590>
 <20220126084950.GA23957@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126084950.GA23957@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 26, 2022 at 09:49:50AM +0100, Christoph Hellwig wrote:
> On Wed, Jan 26, 2022 at 04:33:54PM +0800, Ming Lei wrote:
> > > I guess you are worried about the latter conditionin that we stop
> > > accounting for no data transfer passthrough commands?
> > 
> > No, I meant that bio->bi_bdev isn't setup yet for passthrough request,
> > and not sure that can be done easily.
> 
> Take a look at e.g. nvme_submit_user_cmd and iblock_get_bio.

nvme just sets part0 to rq->bio, which is fine since nvme doesn't
support partial completion.

The simplest way could be to assign bio->bi_bdev with q->disk->part0 in both
bio_copy_user_iov() and bio_map_user_iov(), which should cover most of cases.
Given user io is always on device instead of partition even though the
command is sent via partition bdev.


Thanks,
Ming

