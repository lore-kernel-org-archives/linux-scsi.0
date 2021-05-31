Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1514C4708F
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 09:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C918A606A5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 09:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbhEaJTk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 05:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229646AbhEaJTe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 May 2021 05:19:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622452675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oMCrl/sxWrR3LIJsiYUpsQEWSyTBjyGH6b5b1UjBVDI=;
        b=a9wzA+KDASj4ocnGz1u/Seam8/q/ye9+uz3P0Lg/wHpgvch1s7Wb6iEykhtJyC/+WlqRAe
        eocsqc9PJBkcElwgDfp4DL9zz2Vi0sFQil4wQ3FCkZP0FuPsymap+VQSxDYFYUcEYXWIxb
        Vuxe/CPiKMgxLSV1YX+9qFHNg2p62no=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-HwSP2wC_MD2HqdU7uyzeVQ-1; Mon, 31 May 2021 05:17:51 -0400
X-MC-Unique: HwSP2wC_MD2HqdU7uyzeVQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5F99107ACC7;
        Mon, 31 May 2021 09:17:49 +0000 (UTC)
Received: from T590 (ovpn-12-235.pek2.redhat.com [10.72.12.235])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ACF275D745;
        Mon, 31 May 2021 09:17:43 +0000 (UTC)
Date:   Mon, 31 May 2021 17:17:38 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH V3 3/3] scsi: core: put ->shost_gendev.parent in failure
 handling path
Message-ID: <YLSpst+BdewyYJXh@T590>
References: <20210531050727.2353973-1-ming.lei@redhat.com>
 <20210531050727.2353973-4-ming.lei@redhat.com>
 <2cbcfc4a-78ae-ddc9-1386-6008fcaecb0b@suse.de>
 <YLSWscVt74+2OO19@T590>
 <e010e535-7b8e-7e3c-141c-64da37370729@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e010e535-7b8e-7e3c-141c-64da37370729@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 31, 2021 at 10:23:43AM +0200, Hannes Reinecke wrote:
> On 5/31/21 9:56 AM, Ming Lei wrote:
> > On Mon, May 31, 2021 at 08:28:49AM +0200, Hannes Reinecke wrote:
> > > On 5/31/21 7:07 AM, Ming Lei wrote:
> > > > get_device(shost->shost_gendev.parent) is called in
> > > > scsi_add_host_with_dma(), but its counter pair isn't called in the failure
> > > > path, so fix it by calling put_device(shost->shost_gendev.parent) in its
> > > > failure path.
> > > > 
> > > > Reported-by: John Garry <john.garry@huawei.com>
> > > > Cc: Bart Van Assche <bvanassche@acm.org>
> > > > Cc: Hannes Reinecke <hare@suse.de>
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >    drivers/scsi/hosts.c | 1 +
> > > >    1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > > > index 6cbc3eb16525..6cc43c51b7b3 100644
> > > > --- a/drivers/scsi/hosts.c
> > > > +++ b/drivers/scsi/hosts.c
> > > > @@ -298,6 +298,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> > > >     out_del_dev:
> > > >    	device_del(&shost->shost_dev);
> > > >     out_del_gendev:
> > > > +	put_device(shost->shost_gendev.parent);
> > > >    	device_del(&shost->shost_gendev);
> > > >     out_disable_runtime_pm:
> > > >    	device_disable_async_suspend(&shost->shost_gendev);
> > > > 
> > > This really needs to be folded into the first patch as it's really a bugfix
> > > for that.
> > 
> > All three are bug fixes, and this one may leak .shost_gendev's parent,
> > but the 1st one leaks .shost_gendev->kobj.name, so we needn't to fold
> > the 3rd into the 1st one.
> > 
> I beg to disagree.
> The first patch removes the 'get_device()' from
> scsi_add_host_with_dma(), but does not remove the corresponding
> 'put_device()' in the error path.

There isn't such 'put_device' in the error path of scsi_add_host_with_dma(),
is there?

> So the first patch introduces a reference imbalance which is fixed by the
> third patch. Hence my suggestion to merge those two patches.

No, that isn't true, please look at current code of
scsi_add_host_with_dma().


Thanks, 
Ming

