Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162A7C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5853611F0
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhDZCHw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 22:07:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231502AbhDZCHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 22:07:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619402831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=soanG+9qRJI3J9HhDX0QCMYbAkfnS1p7/A5cxZozGaU=;
        b=D7HHvAHpl78wNM+VJOO2eejFdWaXYQyIaBFRDTL8fMZXtKyP9JzV5Qj0pPXecpB8VZ4d8K
        Iy/YqTZpMlL6WII00qS4q16bjE4qaTYpg3EbOSIFY3zlicHvVFX5b6rcbbBaZoTR5l3T6H
        FK6l3dniKVz1oDu4B4t0tVgWeakfFRs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-hNEplzNfP-S6ZRygBUhJHw-1; Sun, 25 Apr 2021 22:07:09 -0400
X-MC-Unique: hNEplzNfP-S6ZRygBUhJHw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55984343A4;
        Mon, 26 Apr 2021 02:07:07 +0000 (UTC)
Received: from T590 (ovpn-12-48.pek2.redhat.com [10.72.12.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 172169CA0;
        Mon, 26 Apr 2021 02:06:57 +0000 (UTC)
Date:   Mon, 26 Apr 2021 10:07:03 +0800
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
Message-ID: <YIYgR65kR79ghol4@T590>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <20210425085753.2617424-9-ming.lei@redhat.com>
 <d3493eef-ff45-23a8-f12a-b7246ba9f3a2@acm.org>
 <YIYOLHaidxc5fBH2@T590>
 <69764ff2-f339-0dc0-aac0-a1f9f4b30d53@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69764ff2-f339-0dc0-aac0-a1f9f4b30d53@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Apr 25, 2021 at 06:50:48PM -0700, Bart Van Assche wrote:
> On 4/25/21 5:49 PM, Ming Lei wrote:
> > On Sun, Apr 25, 2021 at 01:42:59PM -0700, Bart Van Assche wrote:
> >> Using cmpxchg() on set->tags[] is only safe if all other set->tags[]
> >> accesses are changed into WRITE_ONCE() or READ_ONCE().
> > 
> > Why?
> > 
> > Semantic of cmpxchg() is to modify value pointed by the address if its
> > old value is same with passed 'rq'. That is exactly what we need.
> > 
> > writting 'void *' is always atomic. if someone has touched
> > '->rqs[tag]', cmpxchg() won't modify the value.
> 
> WRITE_ONCE() supports data types that have the same size as char, short,
> int, long and long long. That includes void *. If writes to these data
> types would always be atomic then we wouldn't need the WRITE_ONCE()
> macro.

OK, then we don't need WRITE_ONCE(), since WRITE on tags->rqs[i] is
always atomic.


Thanks, 
Ming

