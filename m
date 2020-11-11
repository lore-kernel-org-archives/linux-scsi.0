Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C77F4C5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 15:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68311207BB
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 15:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQXUZKrz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgKKPEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 10:04:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726702AbgKKPEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Nov 2020 10:04:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605107090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pdnxDrJbnGriYJu6lUmTawYA8DwyKEDmav8yDLXk2oY=;
        b=CQXUZKrzwFtrNEJkajR7SD/hrXoZ5MK3MvXF1aJ+Fd07+MetzQB8j2SELtzcbVOO7h5YbD
        dqhBixEMTuxRsMMljq+16WIPdAHbzNypBcMFI+NDF93nyk62Bu6wsvB8gYwH2beXANRzi7
        N4YzKjimt9g2oDdzZ2Xd8nNBNHYyCvs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-oUWQ_G-SPlSh4zZtW33d7Q-1; Wed, 11 Nov 2020 10:04:46 -0500
X-MC-Unique: oUWQ_G-SPlSh4zZtW33d7Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C37971074661;
        Wed, 11 Nov 2020 15:04:41 +0000 (UTC)
Received: from T590 (ovpn-12-145.pek2.redhat.com [10.72.12.145])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E73046EF7F;
        Wed, 11 Nov 2020 15:04:25 +0000 (UTC)
Date:   Wed, 11 Nov 2020 23:04:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Qian Cai <cai@redhat.com>
Cc:     Sumit Saxena <sumit.saxena@broadcom.com>,
        John Garry <john.garry@huawei.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        don.brace@microsemi.com, Bart Van Assche <bvanassche@acm.org>,
        dgilbert@interlog.com, paolo.valente@linaro.org,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        esc.storagedev@microsemi.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>,
        chenxiang66@hisilicon.com, luojiaxing@huawei.com,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH v8 17/18] scsi: megaraid_sas: Added support for shared
 host tagset for cpuhotplug
Message-ID: <20201111150421.GA611503@T590>
References: <d1040c06-74ea-7016-d259-195fa52196a9@huawei.com>
 <CAL2rwxoAAGQDud1djb3_LNvBw95YoYUGhe22FwE=hYhy7XOLSw@mail.gmail.com>
 <aaf849d38ca3cdd45151ffae9b6a99fe6f6ea280.camel@redhat.com>
 <0c75b881-3096-12cf-07cc-1119ca6a453e@huawei.com>
 <06a1a6bde51a66461d7b3135349641856315401d.camel@redhat.com>
 <db92d37c-28fd-4f81-7b59-8f19e9178543@huawei.com>
 <8043d516-c041-c94b-a7d9-61bdbfef0d7e@huawei.com>
 <CAL2rwxpQt-w2Re8ttu0=6Yzb7ibX3_FB6j-kd_cbtrWxzc7chw@mail.gmail.com>
 <20201111092743.GC545929@T590>
 <b6bfe375866a061c1207ada5eeb6029176cf3521.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6bfe375866a061c1207ada5eeb6029176cf3521.camel@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 11, 2020 at 09:42:17AM -0500, Qian Cai wrote:
> On Wed, 2020-11-11 at 17:27 +0800, Ming Lei wrote:
> > Can this issue disappear by applying the following change?
> 
> This makes the system boot again as well.

OK, actually it isn't necessary to register one new lock key for each
hctx(blk_flush_queue) instance, and the current way is really over-kill
because there can be lots of hw queues in one system.

The original lockdep warning can be avoided by setting one nvme_loop
specific lock class simply. If nvme_loop is backed against another nvme_loop,
we still can avoid the warning by killing the direct end io chain, or
assign another lock class.

Will prepare one formal patch tomorrow.

Thanks,
Ming

