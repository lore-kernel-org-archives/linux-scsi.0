Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74C7C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 00:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B477B61153
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 00:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbhDPAqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 20:46:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30183 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234971AbhDPAqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 20:46:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618533981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=01LPAj7XxOOANKuCrrektCT/ftNV3bWQ3VJcfLmFrwc=;
        b=M/aY353wSw6MHv5s6PtGKqh/hlCZS7LCjAXaosSvRw7IaIE9e3snWxugSlEtrB73plh+W2
        fCwAF5bK1NxLiNrqaJ4y5jdK03PGX7H7Th1Q8OQlZjvWrU0+UoKPHjxOD2G1j1SnfX1ivY
        5tqh4OX15zTwgsmEa1hT0gUOdbDu/1w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-nIRONt64MA2CVxRIwnLCqQ-1; Thu, 15 Apr 2021 20:46:19 -0400
X-MC-Unique: nIRONt64MA2CVxRIwnLCqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A5FA801814;
        Fri, 16 Apr 2021 00:46:18 +0000 (UTC)
Received: from T590 (ovpn-12-36.pek2.redhat.com [10.72.12.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9DFB6A032;
        Fri, 16 Apr 2021 00:46:14 +0000 (UTC)
Date:   Fri, 16 Apr 2021 08:46:10 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [bug report] shared tags causes IO hang and performance drop
Message-ID: <YHjeUrCTbrSft18t@T590>
References: <YHaez6iN2HHYxYOh@T590>
 <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
 <cb326d404c6e0785d03a7dfadc42832c@mail.gmail.com>
 <YHbOOfGNHwO4SMS7@T590>
 <87ceccf2-287b-9bd1-899a-f15026c9e65b@huawei.com>
 <YHe3M62agQET6o6O@T590>
 <3e76ffc7-1d71-83b6-ef5b-3986e947e372@huawei.com>
 <YHgvMAHqIq9f6pQn@T590>
 <f66f9204-83ff-48d4-dbf4-4a5e1dc100b7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f66f9204-83ff-48d4-dbf4-4a5e1dc100b7@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 15, 2021 at 04:41:06PM +0100, John Garry wrote:
> On 15/04/2021 13:18, Ming Lei wrote:
> > On Thu, Apr 15, 2021 at 11:41:52AM +0100, John Garry wrote:
> > > Hi Ming,
> > > 
> > > I'll have a look.
> > > 
> > > BTW, are you intentionally using scsi_debug over null_blk? null_blk supports
> > > shared sbitmap as well, and performance figures there are generally higher
> > > than scsi_debug for similar fio settings.
> > I use both, but scsi_debug can cover scsi stack test.
> > 
> 
> Hi Ming,
> 
> I can't seem to recreate your same issue. Are you mainline defconfig, or a
> special disto config?

The config is rhel8 config.

As I mentioned, with deadline, IOPS drop is observed on one hardware(ibm-x3850x6)
which is exactly the machine Yanhui reported the cpu utilization issue.

On another machine(HP DL380G10), still 32cores, dual numa nodes, IOPS drop can't be
observed, but cpu utilization difference is still obserable.

I use scsi_debug just because it is hard to run the virt workloads on
that machine. And the reported issue is on megaraid_sas, which is a scsi
device, so null_blk isn't good to simulate here because it can't cover
scsi stack.


Thanks,
Ming

