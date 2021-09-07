Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ECFFC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 01:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA1A60F43
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 01:14:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhIGBPV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 21:15:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30593 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229797AbhIGBPU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 21:15:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630977255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M9JOyRA2FSiuJQRIUX55NjLQ/Gj5l9knwfFPznPWnCE=;
        b=STmczQp1lEK6gKv2IBX++ppDYKp/b0Rr3OhUFYHRxsqnL0cRtaGRZ59x3Ft3yrXrg0uvKZ
        6hY/ajUuryW/mDQ4h4lUOR/cRT2t+9N5ix8xConUcEjEr4TiANJfhXZNr3sjCXiU4nnXBj
        ZN2a516hfzTg8hAVWS0rf5z0FTjKRTQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-hC7qCTiuP0-KYyWTmhYD-w-1; Mon, 06 Sep 2021 21:14:11 -0400
X-MC-Unique: hC7qCTiuP0-KYyWTmhYD-w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C965107ACC7;
        Tue,  7 Sep 2021 01:14:10 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 596D51970F;
        Tue,  7 Sep 2021 01:14:02 +0000 (UTC)
Date:   Tue, 7 Sep 2021 09:14:04 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        luojiaxing <luojiaxing@huawei.com>
Subject: Re: [PATCH] blk-mq: avoid to iterate over stale request
Message-ID: <YTa83Domqx8vWhwE@T590>
References: <20210906065003.439019-1-ming.lei@redhat.com>
 <5bf71295-b729-2ec7-3913-afad3c5d2ef7@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bf71295-b729-2ec7-3913-afad3c5d2ef7@acm.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 06, 2021 at 03:44:08PM -0700, Bart Van Assche wrote:
> On 9/5/21 23:50, Ming Lei wrote:
> > -	if (!rq || !refcount_inc_not_zero(&rq->ref))
> > +	if (!rq || rq->tag != bitnr || !refcount_inc_not_zero(&rq->ref))
> >   		rq = NULL;
> 
> Shouldn't the rq->tag != bitnr test happen after the refcount has been
> incremented since otherwise rq->tag can change after it has been read and
> before the refcount is incremented?

rq->tag can change too after its refcount is grabbed. If the rq is released
during the iterating, either SCMD_STATE_INFLIGHT is cleared or
refcount_inc_not_zero() fails. So this way works.

The use case for scsi_host_queue_ready() and scsi EH handling is a bit
special. For others, either the iterating needn't to be exact, or queue
is frozen.



Thanks,
Ming

