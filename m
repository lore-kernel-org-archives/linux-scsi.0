Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13765C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 00:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAD91610E6
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 00:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhDZAui (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 20:50:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231390AbhDZAui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 20:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619398197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dwxmnzj2l32bEs+ERvIucHwyR58dm5h6uygjcfXO8BY=;
        b=LxVdelYXNS29RfxadqeYF9r3DBM/3dNtj6m2mFXgiBrVG14XaAyxLFmzop6Tp2tpHutQlT
        hUTE9U4x/s55bL+M9FyXqGZEZQcsepUbHlu1fMFBXt0VcTGZ/+pa9Rp0fqYpUVXEaE+hAz
        R9uHUDhxSbp/535Yu8FTQHJDyKjg9GI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-kCWv3Sh2OC-q5JtJmqHiXA-1; Sun, 25 Apr 2021 20:49:54 -0400
X-MC-Unique: kCWv3Sh2OC-q5JtJmqHiXA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5747343A5;
        Mon, 26 Apr 2021 00:49:52 +0000 (UTC)
Received: from T590 (ovpn-12-48.pek2.redhat.com [10.72.12.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AF7A5D9DC;
        Mon, 26 Apr 2021 00:49:43 +0000 (UTC)
Date:   Mon, 26 Apr 2021 08:49:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
Subject: Re: [PATCH 8/8] blk-mq: clear stale request in tags->rq[] before
 freeing one request pool
Message-ID: <YIYOLHaidxc5fBH2@T590>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <20210425085753.2617424-9-ming.lei@redhat.com>
 <d3493eef-ff45-23a8-f12a-b7246ba9f3a2@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3493eef-ff45-23a8-f12a-b7246ba9f3a2@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 25, 2021 at 01:42:59PM -0700, Bart Van Assche wrote:
> On 4/25/21 1:57 AM, Ming Lei wrote:
> > +	spin_lock_irqsave(&drv_tags->lock, flags);
> > +	list_for_each_entry(page, &tags->page_list, lru) {
> > +		unsigned long start = (unsigned long)page_address(page);
> > +		unsigned long end = start + order_to_size(page->private);
> > +		int i;
> > +
> > +		for (i = 0; i < set->queue_depth; i++) {
> > +			struct request *rq = drv_tags->rqs[i];
> > +			unsigned long rq_addr = (unsigned long)rq;
> > +
> > +			if (rq_addr >= start && rq_addr < end) {
> > +				WARN_ON_ONCE(refcount_read(&rq->ref) != 0);
> > +				cmpxchg(&drv_tags->rqs[i], rq, NULL);
> > +			}
> > +		}
> > +	}
> > +	spin_unlock_irqrestore(&drv_tags->lock, flags);
> 
> Using cmpxchg() on set->tags[] is only safe if all other set->tags[]
> accesses are changed into WRITE_ONCE() or READ_ONCE().

Why?

Semantic of cmpxchg() is to modify value pointed by the address if its
old value is same with passed 'rq'. That is exactly what we need.

writting 'void *' is always atomic. if someone has touched
'->rqs[tag]', cmpxchg() won't modify the value.



Thanks, 
Ming

