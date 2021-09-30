Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E976C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF2661881
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348202AbhI3Iqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:46:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27430 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236162AbhI3Iqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 04:46:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632991487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hAEsquyz26onX2/vvgyZI/ICtj1bT3QmHISVR7dkRXM=;
        b=MUVnSWHlPIVP6RAJr93GuxjCQhE+R3JeY9PI5uHrImb3jdWumU62nubWZpjl0uCK+QM1U3
        2dLhmqH80UOcFZjg1eofOkYWebRmmI3GovU2yanNoSU43PS1KVPH7S/oCYXshSzkldDIBl
        zmNDekytBzWduZfG3pRPfb80ZwO1N+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-s3ESDwZENbS3EjCBIlUB7Q-1; Thu, 30 Sep 2021 04:44:33 -0400
X-MC-Unique: s3ESDwZENbS3EjCBIlUB7Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76D18100D06D;
        Thu, 30 Sep 2021 08:44:29 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A2A16B54A;
        Thu, 30 Sep 2021 08:44:13 +0000 (UTC)
Date:   Thu, 30 Sep 2021 16:44:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH V2] scsi: core: put LLD module refcnt after SCSI device
 is released
Message-ID: <YVV411YJfMcnk38b@T590>
References: <20210930074026.1011114-1-ming.lei@redhat.com>
 <YVVwUCKbXHAbzguG@kroah.com>
 <YVVzOzW/JFpVss+r@T590>
 <YVV1ZAjLAAIG0gqN@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVV1ZAjLAAIG0gqN@kroah.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 10:29:24AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 30, 2021 at 04:20:11PM +0800, Ming Lei wrote:
> > On Thu, Sep 30, 2021 at 10:07:44AM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Sep 30, 2021 at 03:40:26PM +0800, Ming Lei wrote:
> > > > SCSI host release is triggered when SCSI device is freed, and we have to
> > > > make sure that LLD module won't be unloaded before SCSI host instance is
> > > > released because shost->hostt is required in host release handler.
> > > > 
> > > > So put LLD module refcnt after SCSI device is released.
> > > > 
> > > > The real release handler can be run from wq context in case of
> > > > in_interrupt(), so add one atomic counter for serializing putting
> > > > module via current and wq context. This way is fine since we don't
> > > > call scsi_device_put() in fast IO path.
> > > > 
> > > > Reported-by: Changhui Zhong <czhong@redhat.com>
> > > > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >  drivers/scsi/scsi.c        |  8 +++++++-
> > > >  drivers/scsi/scsi_sysfs.c  | 10 ++++++++++
> > > >  include/scsi/scsi_device.h |  2 ++
> > > >  3 files changed, 19 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > > > index b241f9e3885c..b6612161587f 100644
> > > > --- a/drivers/scsi/scsi.c
> > > > +++ b/drivers/scsi/scsi.c
> > > > @@ -553,8 +553,14 @@ EXPORT_SYMBOL(scsi_device_get);
> > > >   */
> > > >  void scsi_device_put(struct scsi_device *sdev)
> > > >  {
> > > > -	module_put(sdev->host->hostt->module);
> > > > +	struct module *mod = sdev->host->hostt->module;
> > > > +
> > > > +	atomic_inc(&sdev->put_dev_cnt);
> > > 
> > > Ick, no!  Why are you making a new lock and reference count for no
> > > reason?
> > 
> > The reason is to make sure that the LLD module is only put from either
> > scsi_device_put() and scsi_device_dev_release_usercontext().
> > 
> > > 
> > > > +
> > > >  	put_device(&sdev->sdev_gendev);
> > > > +
> > > > +	if (atomic_dec_if_positive(&sdev->put_dev_cnt) >= 0)
> > > > +		module_put(mod);
> > > 
> > > How do you know if your module pointer is still valid here?
> > 
> > module refcnt is grabbed in scsi_device_get(), so it is valid.
> 
> Then you don't need the extra atomic variable.
> 
> > > 
> > > Why do you care?
> > > 
> > > What problem are you trying to solve and why is it unique to scsi
> > > devices?
> > 
> > See it from the commit log:
> > 
> > 	SCSI host release is triggered when SCSI device is freed, and we have to
> > 	make sure that LLD module won't be unloaded before SCSI host instance is
> > 	released because shost->hostt is required in host release handler.
> 
> What is "hostt"?

hostt is 'struct scsi_host_template' which is defined in LLD module, and
often allocated as static global variable, that is what try_get_module()
tries to protect.

> 
> > 	
> > 	So put LLD module refcnt after SCSI device is released.
> 
> Why not just drop it explicitly when you drop the reference count of the
> device object?  Like you tried to do here, but no need for the extra
> atomic variable.

scsi_device_dev_release_usercontext() may be scheduled via schedule_work from
the device object's release handler for releasing the scsi_device, which may
trigger scsi host's release handler in which hostt is required.

If we simply call module_put() after put_device() simply, the module
refcnt may be dropped earlier than running
scsi_device_dev_release_usercontext(), then the kernel panic still can't
be addressed.


Thanks,
Ming

