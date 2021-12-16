Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E930BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Dec 2021 12:51:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhLPMvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Dec 2021 07:51:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234278AbhLPMvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Dec 2021 07:51:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639659063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nZIEkr4x9Crf7nZvoOLTBWMdyUgpD5lC8+V1nv4IiOE=;
        b=cuesjE4dSIxE6SWma10dyuzwyYwsavMwrXpuwb/xNr34hLCyxLvOlYdCjtM1hDyVgWOQDz
        FlPQ4zwrE3G0XtRgeGUUTwWFDtZ04aiYjS5m1yutLA7NLzCqBHgiQZesjFSnqKqLcWBBr0
        QY6c8s38ZsUefQ2LTB8DHA2rHeKD/lU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-529-67hpv0L5OhyXizkf6VX4-g-1; Thu, 16 Dec 2021 07:50:58 -0500
X-MC-Unique: 67hpv0L5OhyXizkf6VX4-g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3046D18C8C35;
        Thu, 16 Dec 2021 12:50:56 +0000 (UTC)
Received: from T590 (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D471F45D86;
        Thu, 16 Dec 2021 12:50:51 +0000 (UTC)
Date:   Thu, 16 Dec 2021 20:50:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     luojiaxing <luojiaxing@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] blk-mq: avoid to iterate over stale request
Message-ID: <Ybs2JooaoL0w0z/q@T590>
References: <20210906065003.439019-1-ming.lei@redhat.com>
 <0d8666c9983158a4954f30f6b429e797@mail.gmail.com>
 <YblitnLqJtkK/xBt@T590>
 <86f2fb27dd6bc53fec3d8677c078937e@mail.gmail.com>
 <YbmhDNrnVLcfbK/l@T590>
 <3065cf1a25a99a2dd89e9065d679410e@mail.gmail.com>
 <YbnmD6yW1v7YWizf@T590>
 <7518aac238de9a2c2ec3f857c43dd2e9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7518aac238de9a2c2ec3f857c43dd2e9@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 16, 2021 at 05:25:41PM +0530, Kashyap Desai wrote:
> > >
> > > I mean, shared bitmap in my whole discussion. Megaraid_sas driver use
> > > shared bitmap, so it is exposed and It is confirmed from this
> discussion.
> > > Do we still have exposure (if "blk-mq: avoid to iterate over stale
> > > request" is not part of kernel)  to mpi3mr type driver which does not
> > > use shared bitmap but has nr_hw_queues > 1. ?
> >
> > Not sure I understand your poing, but patch "blk-mq: avoid to iterate
> over
> > stale request" can cover both shared tags or not.
> 
> I agree with all above reply.
> 
> My query is for mpi3mr driver which is not calling "host->host_tagset =
> 1;", but nr_hw_queues are more than 1.
> Current <mpi3mr> driver is nvme style interface. nr_hw_queues  > 1 and
> host->host_tagset = 0.
> 
> Is this patch  "blk-mq: avoid to iterate over stale request" is applicable
> for <mpi3mr> driver ?

Yeah, this change covers both ->host_tagset and !->host_tagset, same
with the following words:

	scsi_host_check_in_flight() is used to counting scsi in-flight requests
	after scsi host is blocked, so no new scsi command can be marked as
	SCMD_STATE_INFLIGHT. However, driver tag allocation still can be run at
	that time by blk-mq core.
	
	The issue is in blk_mq_tagset_busy_iter(). One request is in-flight, but
	this request may be kept in another slot of ->rqs[], meantime the slot
	can be allocated out but ->rqs[] isn't updated yet. Then the in-flight
	request is counted twice as SCMD_STATE_INFLIGHT.



Thanks,
Ming

