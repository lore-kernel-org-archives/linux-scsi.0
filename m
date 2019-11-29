Return-Path: <SRS0=Uo2m=ZV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C787C432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 00:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015DE21774
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Nov 2019 00:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fZVtPNid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfK2A0B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 19:26:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45400 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726610AbfK2A0A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 19:26:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574987158;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P07r2iHQlRL7YpE8GyJm4hL/1kEs3SHdvQU2XugBgys=;
        b=fZVtPNidQzqlJY0JOZ2k2+gMOCOnN2bwJU2pctlRbkZmuVkzdZsQhBhlZo2B1vfgp/0F4P
        E4LCzsx4JpjrefUZQzUXQXFnRZ3utFWq8TCPuW8qtd7K46qkN/YsW8Jqg4hXrf0oWJqCFd
        2dCIn4jjQLbpNdljMTBFKLni7nA/st0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-ajoAp75nOeaYXd9gMFLSOA-1; Thu, 28 Nov 2019 19:25:55 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E67721803818;
        Fri, 29 Nov 2019 00:25:53 +0000 (UTC)
Received: from ming.t460p (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BAAB5D717;
        Fri, 29 Nov 2019 00:25:44 +0000 (UTC)
Date:   Fri, 29 Nov 2019 08:25:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>
Subject: Re: [PATCH 4/8] blk-mq: Facilitate a shared sbitmap per tagset
Message-ID: <20191129002540.GA1829@ming.t460p>
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-5-hare@suse.de>
 <20191126110527.GE32135@ming.t460p>
 <8a10e2f0-bbdc-8b47-a118-0fd7837ef44e@suse.de>
 <20191126155445.GB17602@ming.t460p>
 <5561a568-a559-fee8-83aa-449befedae47@suse.de>
MIME-Version: 1.0
In-Reply-To: <5561a568-a559-fee8-83aa-449befedae47@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ajoAp75nOeaYXd9gMFLSOA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 27, 2019 at 06:02:54PM +0100, Hannes Reinecke wrote:
> On 11/26/19 4:54 PM, Ming Lei wrote:
> > On Tue, Nov 26, 2019 at 12:27:50PM +0100, Hannes Reinecke wrote:
> > > On 11/26/19 12:05 PM, Ming Lei wrote:
> [ .. ]
> > > >  From performance viewpoint, all hctx belonging to this request que=
ue should
> > > > share one scheduler tagset in case of BLK_MQ_F_TAG_HCTX_SHARED, cau=
se
> > > > driver tag queue depth isn't changed.
> > > >=20
> > > Hmm. Now you get me confused.
> > > In an earlier mail you said:
> > >=20
> > > > This kind of sharing is wrong, sched tags should be request
> > > > queue wide instead of tagset wide, and each request queue has
> > > > its own & independent scheduler queue.
> > >=20
> > > as in v2 we _had_ shared scheduler tags, too.
> > > Did I misread your comment above?
> >=20
> > Yes, what I meant is that we can't share sched tags in tagset wide.
> >=20
> > Now I mean we should share sched tags among all hctxs in same request
> > queue, and I believe I have described it clearly.
> >=20
> I wonder if this makes a big difference; in the end, scheduler tags are
> primarily there to allow the scheduler to queue more requests, and
> potentially merge them. These tags are later converted into 'real' ones v=
ia
> blk_mq_get_driver_tag(), and only then the resource limitation takes hold=
.
> Wouldn't it be sufficient to look at the number of outstanding commands p=
er
> queue when getting a scheduler tag, and not having to implement yet anoth=
er
> bitmap?

Firstly too much((nr_hw_queues - 1) times) memory is wasted. Secondly IO
latency could be increased by too deep scheduler queue depth. Finally CPU
could be wasted in the retrying of running busy hw queue.

Wrt. driver tags, this patch may be worse, given the average limit for
each LUN is reduced by (nr_hw_queues) times, see hctx_may_queue().

Another change is bt_wait_ptr(). Before your patches, there is single
.wait_index, now the number of .wait_index is changed to nr_hw_queues.

Also the run queue number is increased a lot in SCSI's IO completion, see
scsi_end_request().

Kashyap Desai has performance benchmark on fast megaraid SSD, and you can
ask him to provide performance data for this patches.

Thanks,
Ming

