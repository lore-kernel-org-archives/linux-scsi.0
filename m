Return-Path: <SRS0=9eMh=27=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A278C32771
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 02:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C31F2064C
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jan 2020 02:00:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fn6VlKK3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbgAJCA7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 21:00:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43525 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730359AbgAJCA6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2020 21:00:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578621657;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TIpC/krxLydDnHVW/RNCGJrbKjBHiQ/9nuaNV71WzMg=;
        b=fn6VlKK326yL3AQdehoZKHQxh6rb3VC9/32G+c8iFrphi5UhOIkpO6Ghu3LIDXIGWIL8DL
        9Begjm+iHjvyBIrJo5USgZXwpR3DKsKWSidzd45SmdjGRZJzn1w5PzCJG1RrlrON3OiiHx
        HkB61u58FHl0YGBOplOtUEEKACWISK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-2IjvPvvuNNqdHnpMOhEJtA-1; Thu, 09 Jan 2020 21:00:53 -0500
X-MC-Unique: 2IjvPvvuNNqdHnpMOhEJtA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1565B1800D4E;
        Fri, 10 Jan 2020 02:00:51 +0000 (UTC)
Received: from ming.t460p (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8ADE486CA7;
        Fri, 10 Jan 2020 02:00:42 +0000 (UTC)
Date:   Fri, 10 Jan 2020 10:00:38 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 09/11] megaraid_sas: switch fusion adapters to MQ
Message-ID: <20200110020038.GB4501@ming.t460p>
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-10-hare@suse.de>
 <CAL2rwxqjiRTuZ0ntfaHHzG7z-VmxRQCXYyxZeX9eDMrmX+dbGg@mail.gmail.com>
 <339f089f-26aa-1cbe-416b-67809ea6791f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <339f089f-26aa-1cbe-416b-67809ea6791f@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 09, 2020 at 11:55:12AM +0000, John Garry wrote:
> On 09/12/2019 10:10, Sumit Saxena wrote:
> > On Mon, Dec 2, 2019 at 9:09 PM Hannes Reinecke <hare@suse.de> wrote:
> > > 
> > > Fusion adapters can steer completions to individual queues, and
> > > we now have support for shared host-wide tags.
> > > So we can enable multiqueue support for fusion adapters and
> > > drop the hand-crafted interrupt affinity settings.
> > 
> > Hi Hannes,
> > 
> > Ming Lei also proposed similar changes in megaraid_sas driver some
> > time back and it had resulted in performance drop-
> > https://patchwork.kernel.org/patch/10969511/
> > 
> > So, we will do some performance tests with this patch and update you.
> > 
> 
> Hi Sumit,
> 
> I was wondering if you had a chance to do this test yet?
> 
> It would be good to know, so we can try to progress this work.

Looks most of the comment in the following link isn't addressed:

https://lore.kernel.org/linux-block/20191129002540.GA1829@ming.t460p/

> Firstly too much((nr_hw_queues - 1) times) memory is wasted. Secondly IO
> latency could be increased by too deep scheduler queue depth. Finally CPU
> could be wasted in the retrying of running busy hw queue.
> 
> Wrt. driver tags, this patch may be worse, given the average limit for
> each LUN is reduced by (nr_hw_queues) times, see hctx_may_queue().
> 
> Another change is bt_wait_ptr(). Before your patches, there is single
> .wait_index, now the number of .wait_index is changed to nr_hw_queues.
> 
> Also the run queue number is increased a lot in SCSI's IO completion, see
> scsi_end_request().

I guess memory waste won't be a blocker.

But it may not be one accepted behavior to reduce average active queue
depth for each LUN by nr_hw_queues times, meantime scheduler queue depth
is increased by nr_hw_queues times, compared with single queue.

thanks,
Ming

