Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8456AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 02:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64E77208C7
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 02:56:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E+qIwZ2n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHEC4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 22:56:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49007 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbgHEC4x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 22:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596596212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=egbsM223iiOHwDOy9D74thjIIiHZTEb/E17U4bOYCko=;
        b=E+qIwZ2n9U+qTashYAZRvpZjPjzqB2/5UlhSfMy+pYgam+aZfSG39KfW8ZYLyLPAlHXyOx
        qzhiVkkWGj9dzRCn7tozOR4SRqjL5r7kqe2bOsfmeMy38r46bwBmSWD4Dxs9cG2X7ap1SB
        f3YJA72oBp8gh/Zcv5RNb1pRgfoh2Z0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-Ahhzw8BKOKyTCy6bFqaUXQ-1; Tue, 04 Aug 2020 22:56:50 -0400
X-MC-Unique: Ahhzw8BKOKyTCy6bFqaUXQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E30D618FF665;
        Wed,  5 Aug 2020 02:56:47 +0000 (UTC)
Received: from T590 (ovpn-13-169.pek2.redhat.com [10.72.13.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9398B10013D0;
        Wed,  5 Aug 2020 02:56:37 +0000 (UTC)
Date:   Wed, 5 Aug 2020 10:56:32 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
Message-ID: <20200805025632.GC1981569@T590>
References: <20200722041201.GA912316@T590>
 <f6f05483491c391ce79486b8fb78cb2e@mail.gmail.com>
 <20200722080409.GB912316@T590>
 <fe7a7acf-d62b-d541-4203-29c1d0403c2a@huawei.com>
 <20200723140758.GA957464@T590>
 <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590>
 <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
 <20200728084511.GA1326626@T590>
 <0610dce9-a5d0-ebb8-757f-0c7026891e25@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0610dce9-a5d0-ebb8-757f-0c7026891e25@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 04, 2020 at 06:00:52PM +0100, John Garry wrote:
> On 28/07/2020 09:45, Ming Lei wrote:
> > > OK, so dynamically allocating the sbitmap could be good. I was thinking
> > > previously that we still allocate for nr_cpus size, and search a limited
> > > range - but this would have heavier runtime overhead.
> > > 
> > > So if you really think that this may have some value, then let me know, so
> > > we can look to take it forward.
> 
> Hi Ming,
> 
> > Forget to mention, the in-tree code has been this shape for long
> > time, please see sbitmap_resize() called from blk_mq_map_swqueue().
> 
> So after the resize, even if we are only checking a single word and a few
> bits within that word, we still need 2x 64b loads - 1x for .word and 1x for
> .cleared. Seems a bit inefficient for caching when we have a 1:1 mapping or
> similar. For 1:1 case only, how about a ctx_map per queue for all hctx, with
> a single bit per hctx? I do realize that it makes the code more complicated,
> but it could be more efficient.

IMO, the cost for accessing one bit and one word is basically same.

> 
> Another thing to consider is that for ctx_map, we don't do deferred bit
> clear, so we don't ever really need to check .cleared there. I think.

That looks true.

However, in case of MQ, the normal code path is direct issue, not sure if
we need this kind of optimization.

BTW, no matter if hostwide tags is used or not, the problem is in always
run-queue from scsi_end_request(). As we discussed, the re-run queue is
only needed in case of budget contention.


Thanks,
Ming

