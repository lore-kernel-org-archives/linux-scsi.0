Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC9D7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jan 2022 09:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349164AbiAYJT6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jan 2022 04:19:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1456220AbiAYJKD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jan 2022 04:10:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643101800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xIYDHT/wi2RbZuBVptrIISb//TVLfsExKGTY/EiU5iA=;
        b=f3ujSgXHvQXKMS0tjr+UorXcm+VIAnMCRustvfrmat3jbrkI0aC8h9lTXR3YQvwOyZkmv2
        owOcBb5addlUv4WSZQhrl6wcyL/Ji0vU30CccBj1pjaneSRWU7V20bCxTv4WkeodzKDHNE
        /sY39Zo5t9iWOdflwO76vDkXlFGRSZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-_N3xcEKzNiyevSWK1dOi3g-1; Tue, 25 Jan 2022 04:09:57 -0500
X-MC-Unique: _N3xcEKzNiyevSWK1dOi3g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 494E52F25;
        Tue, 25 Jan 2022 09:09:56 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01EEE1F2E7;
        Tue, 25 Jan 2022 09:09:47 +0000 (UTC)
Date:   Tue, 25 Jan 2022 17:09:42 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2 05/13] block: only account passthrough IO from
 userspace
Message-ID: <Ye++VmBkg0I8Lq8+@T590>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-6-ming.lei@redhat.com>
 <20220124130555.GD27269@lst.de>
 <Ye8xleeYZfmwA3D7@T590>
 <20220125061634.GA26495@lst.de>
 <20220125071906.GA27674@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125071906.GA27674@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 08:19:06AM +0100, Christoph Hellwig wrote:
> On Tue, Jan 25, 2022 at 07:16:34AM +0100, Christoph Hellwig wrote:
> > So why not key off accouning off "rq->bio && rq->bio->bi_bdev"
> > and remove the need for the flag and the second half of the assignment
> > above?  That is much less error probe and removes code size.
> 
> Something like this, lightly tested:
> 

Follows another simple way by accounting all request with bio attached,
except for requests with kernel buffer.


diff --git a/block/blk-map.c b/block/blk-map.c
index 4526adde0156..1210b51c62ae 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -630,6 +630,8 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	struct bio *bio;
 	int ret;
 
+	rq->rq_flags &= ~RQF_IO_STAT;
+
 	if (len > (queue_max_hw_sectors(q) << 9))
 		return -EINVAL;
 	if (!len || !kbuf)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 72ae9955cf27..eac589d2c340 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -903,7 +903,7 @@ static void __blk_account_io_start(struct request *rq)
 	/* passthrough requests can hold bios that do not have ->bi_bdev set */
 	if (rq->bio && rq->bio->bi_bdev)
 		rq->part = rq->bio->bi_bdev;
-	else if (rq->q->disk)
+	else if (rq->q->disk && rq->bio)
 		rq->part = rq->q->disk->part0;
 
 	part_stat_lock();


Thanks,
Ming

