Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC7CC47083
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B539613C9
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 03:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFCDai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 23:30:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55990 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229758AbhFCD0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 23:26:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622690587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hJddlx7honz6mKn/y/fYftuPNX5yH4s+TxbtFJjjdCY=;
        b=AdBuEQves0wrywRuJsfjpTyN3q8q7ajKYuSo4ewjXsaWRajlvFgmS7dlD6Wy1hurZJZos4
        OEV5fN2RyLsNtNnBdoP8JL/FEdo8HZ1qNOkmCr2qAvcGro78o3X/NYxNZMeKNSFJaZ2izU
        ZfUa1QhnVEmz9Xuf6rWjeVmyB0pLono=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-prKhzu4MMF6tkaGgHeaKmA-1; Wed, 02 Jun 2021 23:23:04 -0400
X-MC-Unique: prKhzu4MMF6tkaGgHeaKmA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB1FE101371B;
        Thu,  3 Jun 2021 03:23:02 +0000 (UTC)
Received: from T590 (ovpn-12-17.pek2.redhat.com [10.72.12.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 763501037E8B;
        Thu,  3 Jun 2021 03:22:53 +0000 (UTC)
Date:   Thu, 3 Jun 2021 11:22:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi: core: put .shost_dev in failure path if host
 state becomes running
Message-ID: <YLhLCDqv7KWNELXl@T590>
References: <20210602133029.2864069-1-ming.lei@redhat.com>
 <20210602133029.2864069-4-ming.lei@redhat.com>
 <d2ddd0a4-db61-a966-0e27-313e59cfd7e7@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2ddd0a4-db61-a966-0e27-313e59cfd7e7@acm.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 02, 2021 at 08:06:31PM -0700, Bart Van Assche wrote:
> On 6/2/21 6:30 AM, Ming Lei wrote:
> > scsi_host_dev_release() only works around for us by freeing
> > dev_name(&shost->shost_dev) when host state is SHOST_CREATED. After host
> > state is changed to SHOST_RUNNING, scsi_host_dev_release() doesn't do
> > that any more.
> > 
> > So fix the issue by put .shost_dev in failure path if host state becomes
> > running, meantime move get_device(&shost->shost_gendev) before
> > device_add(&shost->shost_dev), so that scsi_host_cls_release() can put
> > this reference.
> > 
> > Reported-by: John Garry <john.garry@huawei.com>
> > Cc: Bart Van Assche <bvanassche@acm.org>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/hosts.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > index 796736e47764..7049844adb6b 100644
> > --- a/drivers/scsi/hosts.c
> > +++ b/drivers/scsi/hosts.c
> > @@ -257,12 +257,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> >  
> >  	device_enable_async_suspend(&shost->shost_dev);
> >  
> > +	get_device(&shost->shost_gendev);
> >  	error = device_add(&shost->shost_dev);
> >  	if (error)
> >  		goto out_del_gendev;
> >  
> > -	get_device(&shost->shost_gendev);
> > -
> >  	if (shost->transportt->host_size) {
> >  		shost->shost_data = kzalloc(shost->transportt->host_size,
> >  					 GFP_KERNEL);
> > @@ -300,6 +299,11 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
> >   out_del_dev:
> >  	device_del(&shost->shost_dev);
> >   out_del_gendev:
> > +	/*
> > +	 * host state has become SHOST_RUNNING, so we have to release
> > +	 * ->shost_dev explicitly
> > +	 */
> > +	put_device(&shost->shost_dev);
> >  	device_del(&shost->shost_gendev);
> >   out_disable_runtime_pm:
> >  	device_disable_async_suspend(&shost->shost_gendev);
> 
> Shouldn't this change be merged into patch 2/4 since both patches touch
> the same function? Anyway, this patch also looks good to me.

2/4 address double-free, this one fixes memory leak. Not mention this
one isn't trivial to find & figuring out, so it will be easier to review by
splitting them out.
 

Thanks,
Ming

