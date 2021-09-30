Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A7AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E0D6162E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348948AbhI3IW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:46938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348945AbhI3IWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 04:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632990072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uxfPaknpe2KxTzyJEaURzSmdUt5gx45sGtlxMXU3sTg=;
        b=Mn98RHP55ICzanU3yukcaaTF/hreiPgxZTP2+3aYX4hgB49Ga4oCCdNOod996qdqrqpuNM
        6n4no5yaRktVHGj4pvCnDVxMj2kL8Q51gmASpEfOFgwO5GdjEpACG6YAgpweJGDl9+DM0j
        A8PNmBd3OVyLSo1/64d+foEBs2Wdkz8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-gWiLXD95PryQbz8XY-wHbg-1; Thu, 30 Sep 2021 04:21:10 -0400
X-MC-Unique: gWiLXD95PryQbz8XY-wHbg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1252802E3F;
        Thu, 30 Sep 2021 08:20:23 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BAC0560CD1;
        Thu, 30 Sep 2021 08:20:18 +0000 (UTC)
Date:   Thu, 30 Sep 2021 16:20:11 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH V2] scsi: core: put LLD module refcnt after SCSI device
 is released
Message-ID: <YVVzOzW/JFpVss+r@T590>
References: <20210930074026.1011114-1-ming.lei@redhat.com>
 <YVVwUCKbXHAbzguG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVVwUCKbXHAbzguG@kroah.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 10:07:44AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 30, 2021 at 03:40:26PM +0800, Ming Lei wrote:
> > SCSI host release is triggered when SCSI device is freed, and we have to
> > make sure that LLD module won't be unloaded before SCSI host instance is
> > released because shost->hostt is required in host release handler.
> > 
> > So put LLD module refcnt after SCSI device is released.
> > 
> > The real release handler can be run from wq context in case of
> > in_interrupt(), so add one atomic counter for serializing putting
> > module via current and wq context. This way is fine since we don't
> > call scsi_device_put() in fast IO path.
> > 
> > Reported-by: Changhui Zhong <czhong@redhat.com>
> > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> >  drivers/scsi/scsi.c        |  8 +++++++-
> >  drivers/scsi/scsi_sysfs.c  | 10 ++++++++++
> >  include/scsi/scsi_device.h |  2 ++
> >  3 files changed, 19 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index b241f9e3885c..b6612161587f 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -553,8 +553,14 @@ EXPORT_SYMBOL(scsi_device_get);
> >   */
> >  void scsi_device_put(struct scsi_device *sdev)
> >  {
> > -	module_put(sdev->host->hostt->module);
> > +	struct module *mod = sdev->host->hostt->module;
> > +
> > +	atomic_inc(&sdev->put_dev_cnt);
> 
> Ick, no!  Why are you making a new lock and reference count for no
> reason?

The reason is to make sure that the LLD module is only put from either
scsi_device_put() and scsi_device_dev_release_usercontext().

> 
> > +
> >  	put_device(&sdev->sdev_gendev);
> > +
> > +	if (atomic_dec_if_positive(&sdev->put_dev_cnt) >= 0)
> > +		module_put(mod);
> 
> How do you know if your module pointer is still valid here?

module refcnt is grabbed in scsi_device_get(), so it is valid.

> 
> Why do you care?
> 
> What problem are you trying to solve and why is it unique to scsi
> devices?

See it from the commit log:

	SCSI host release is triggered when SCSI device is freed, and we have to
	make sure that LLD module won't be unloaded before SCSI host instance is
	released because shost->hostt is required in host release handler.
	
	So put LLD module refcnt after SCSI device is released.

and the upstream report on the issue:

https://lore.kernel.org/linux-block/CAHj4cs8XNtkzbbiLnFmVu82wYeQpLkVp6_wCtrnbhODay+OP9w@mail.gmail.com/


Thanks,
Ming

