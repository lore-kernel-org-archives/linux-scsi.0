Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60729C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A8AA617E5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348219AbhI3IbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:31:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348109AbhI3IbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 04:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6E37615E5;
        Thu, 30 Sep 2021 08:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632990567;
        bh=FVLfk2TyZpg3IbRANbbu4601KDzK72V02wniJI68T18=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oMptmm/XNVMQtLx1oGTA4L1IX8+sthUh8kcUIfwiEEEySmorI19qZpPnYhhjfejYb
         77vE4mCZO5mWrLgQyePL+hGsWsTfUPLdZq3FKUF6hNWQ71QYAy3j4amLsWs+KPS33h
         RsNkqraROVsHCZ9rixrdXSrT5VBMZSkDW19nL/1k=
Date:   Thu, 30 Sep 2021 10:29:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH V2] scsi: core: put LLD module refcnt after SCSI device
 is released
Message-ID: <YVV1ZAjLAAIG0gqN@kroah.com>
References: <20210930074026.1011114-1-ming.lei@redhat.com>
 <YVVwUCKbXHAbzguG@kroah.com>
 <YVVzOzW/JFpVss+r@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVVzOzW/JFpVss+r@T590>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 04:20:11PM +0800, Ming Lei wrote:
> On Thu, Sep 30, 2021 at 10:07:44AM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Sep 30, 2021 at 03:40:26PM +0800, Ming Lei wrote:
> > > SCSI host release is triggered when SCSI device is freed, and we have to
> > > make sure that LLD module won't be unloaded before SCSI host instance is
> > > released because shost->hostt is required in host release handler.
> > > 
> > > So put LLD module refcnt after SCSI device is released.
> > > 
> > > The real release handler can be run from wq context in case of
> > > in_interrupt(), so add one atomic counter for serializing putting
> > > module via current and wq context. This way is fine since we don't
> > > call scsi_device_put() in fast IO path.
> > > 
> > > Reported-by: Changhui Zhong <czhong@redhat.com>
> > > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  drivers/scsi/scsi.c        |  8 +++++++-
> > >  drivers/scsi/scsi_sysfs.c  | 10 ++++++++++
> > >  include/scsi/scsi_device.h |  2 ++
> > >  3 files changed, 19 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > > index b241f9e3885c..b6612161587f 100644
> > > --- a/drivers/scsi/scsi.c
> > > +++ b/drivers/scsi/scsi.c
> > > @@ -553,8 +553,14 @@ EXPORT_SYMBOL(scsi_device_get);
> > >   */
> > >  void scsi_device_put(struct scsi_device *sdev)
> > >  {
> > > -	module_put(sdev->host->hostt->module);
> > > +	struct module *mod = sdev->host->hostt->module;
> > > +
> > > +	atomic_inc(&sdev->put_dev_cnt);
> > 
> > Ick, no!  Why are you making a new lock and reference count for no
> > reason?
> 
> The reason is to make sure that the LLD module is only put from either
> scsi_device_put() and scsi_device_dev_release_usercontext().
> 
> > 
> > > +
> > >  	put_device(&sdev->sdev_gendev);
> > > +
> > > +	if (atomic_dec_if_positive(&sdev->put_dev_cnt) >= 0)
> > > +		module_put(mod);
> > 
> > How do you know if your module pointer is still valid here?
> 
> module refcnt is grabbed in scsi_device_get(), so it is valid.

Then you don't need the extra atomic variable.

> > 
> > Why do you care?
> > 
> > What problem are you trying to solve and why is it unique to scsi
> > devices?
> 
> See it from the commit log:
> 
> 	SCSI host release is triggered when SCSI device is freed, and we have to
> 	make sure that LLD module won't be unloaded before SCSI host instance is
> 	released because shost->hostt is required in host release handler.

What is "hostt"?

> 	
> 	So put LLD module refcnt after SCSI device is released.

Why not just drop it explicitly when you drop the reference count of the
device object?  Like you tried to do here, but no need for the extra
atomic variable.

thanks,

greg k-h
