Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904B5C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 10:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79138611AD
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 10:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbhKJKsy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 05:48:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:37858 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231174AbhKJKsx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Nov 2021 05:48:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636541165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eqCttD3Xd5hwRL+t63xG9x7gvxrIP+8WdXxav6/uzGQ=;
        b=dNV+lAx9O58dlRi9AD1xRLmeVlv8dTnK8pwDwNqGaQtJsa92PGnHjN319firljtGddy4Bz
        OUdy6hqXC2xJvf4c9ozUsXZpJTH/C3HV20EFkMyIMguGFr3XStY+yZ1q4kIBQrPP5aHL0M
        Pi/gjLbTl8JZi40ID1gynhGc3VEhP/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-7ug1M-ffNG6h2smBDU4Y7Q-1; Wed, 10 Nov 2021 05:46:02 -0500
X-MC-Unique: 7ug1M-ffNG6h2smBDU4Y7Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD6CE871803;
        Wed, 10 Nov 2021 10:46:00 +0000 (UTC)
Received: from T590 (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 34E4410074E0;
        Wed, 10 Nov 2021 10:45:56 +0000 (UTC)
Date:   Wed, 10 Nov 2021 18:45:52 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: sorting out the freeze / quiesce mess
Message-ID: <YYui4DJeeKyq0HI8@T590>
References: <20211110091407.GA8396@lst.de>
 <477f3098-39be-ad07-e2fb-3ef3309c4dce@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477f3098-39be-ad07-e2fb-3ef3309c4dce@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 10, 2021 at 11:22:05AM +0100, Hannes Reinecke wrote:
> On 11/10/21 10:14 AM, Christoph Hellwig wrote:
> > Hi Jens and Ming,
> > 
> > I've been looking into properly supporting queue freezing for bio based
> > drivers (that is only release q_usage_counter on bio completion for them).
> > And the deeper I look into the code the more I'm confused by us having
> > the blk_mq_quiesce* interface in addition to blk_freeze_queue.  What
> > is a good reason to do a quiesce separately from a freeze?
> > 
> IIRC the 'quiesce' interface was an abstraction from the SCSI 'quiesce'
> operation, where we had to stop all I/O except for TMFs and scanning.
> And 'freeze' was designed fro stopping all I/O.
> 
> But I'm not sure if that ever was the distinction, or if it still
> applies today.
> 
> And yeah, I've been wondering myself.
> 
> Probably we should just kill the 'quiesce' stuff and see where we end up :-)

In case of EH, no queued requests can be completed, however driver still
needs to stop queue and reset hardware, then how can you use freeze to stop
queue? See nvme_dev_disable().

Freeze can stop to allocate new request and drain all queued requests, but
it can't prevent IO from being queued to LLD. On the contrary,
blk_mq_freeze_queue_wait() requires LLD to handle IO for moving on,
otherwise it will wait forever.

Thanks,
Ming

