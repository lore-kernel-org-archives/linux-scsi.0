Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3058DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 03:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DCDE61075
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 03:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhJHDFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 23:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40607 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhJHDFg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 23:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633662221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gfe0lASrfBXIvcKETxg2cwYus4EpH+zGdzrlF4kDQok=;
        b=P0a5S1PZPDgzNWYmqb4jMZElFueycq9AiNSSn/xPWSB94jUAAJoRL6Kqc1gUVKfVp+yi4P
        U8xL8xp7SHXMceZ9OAo8qBUretdg+Gy28DeL8F4r56qVah95INS5/ywUZt2giZ1GxNvv/c
        zerDytTYhM4KFMwPMS9tUiKHeXMwRMA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-0cOAI88OO8mb7aG2ycvZWQ-1; Thu, 07 Oct 2021 23:03:40 -0400
X-MC-Unique: 0cOAI88OO8mb7aG2ycvZWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 745461084697;
        Fri,  8 Oct 2021 03:03:39 +0000 (UTC)
Received: from T590 (ovpn-8-29.pek2.redhat.com [10.72.8.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B4A35F4F3;
        Fri,  8 Oct 2021 03:03:23 +0000 (UTC)
Date:   Fri, 8 Oct 2021 11:03:18 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH V3] scsi: core: put LLD module refcnt after SCSI device
 is released
Message-ID: <YV+09ul6Ux2e2MTu@T590>
References: <20210930124415.1160754-1-ming.lei@redhat.com>
 <YVxUrIQw7ACcmSx2@kroah.com>
 <YV6d9OmLt1w5d9Qp@T590>
 <YV6ffTjVBJgDIgtG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV6ffTjVBJgDIgtG@kroah.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 07, 2021 at 09:19:25AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Oct 07, 2021 at 03:12:52PM +0800, Ming Lei wrote:
> > On Tue, Oct 05, 2021 at 03:35:40PM +0200, Greg Kroah-Hartman wrote:
> > > On Thu, Sep 30, 2021 at 08:44:15PM +0800, Ming Lei wrote:
> > > > SCSI host release is triggered when SCSI device is freed, and we have to
> > > > make sure that LLD module won't be unloaded before SCSI host instance is
> > > > released because shost->hostt is required in host release handler.
> > > > 
> > > > So make sure to put LLD module refcnt after SCSI device is released.
> > > 
> > > What is a "LLD"?
> > 
> > Lower level driver, which is used often as one scsi term.
> > 
> > > 
> > > > Fix one kernel panic of 'BUG: unable to handle page fault for address'
> > > > reported by Changhui and Yi.
> > > > 
> > > > Reported-by: Changhui Zhong <czhong@redhat.com>
> > > > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > > ---
> > > >  drivers/scsi/scsi.c        |  4 +++-
> > > >  drivers/scsi/scsi_sysfs.c  | 12 ++++++++++++
> > > >  include/scsi/scsi_device.h |  1 +
> > > >  3 files changed, 16 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > > > index b241f9e3885c..291ecc33b1fe 100644
> > > > --- a/drivers/scsi/scsi.c
> > > > +++ b/drivers/scsi/scsi.c
> > > > @@ -553,8 +553,10 @@ EXPORT_SYMBOL(scsi_device_get);
> > > >   */
> > > >  void scsi_device_put(struct scsi_device *sdev)
> > > >  {
> > > > -	module_put(sdev->host->hostt->module);
> > > > +	struct module *mod = sdev->host->hostt->module;
> > > > +
> > > >  	put_device(&sdev->sdev_gendev);
> > > > +	module_put(mod);
> > > >  }
> > > >  EXPORT_SYMBOL(scsi_device_put);
> > > >  
> > > > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > > > index 86793259e541..9ada26814011 100644
> > > > --- a/drivers/scsi/scsi_sysfs.c
> > > > +++ b/drivers/scsi/scsi_sysfs.c
> > > > @@ -449,9 +449,16 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
> > > >  	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
> > > >  	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
> > > >  	unsigned long flags;
> > > > +	struct module *mod;
> > > > +	bool put_mod = false;
> > > >  
> > > >  	sdev = container_of(work, struct scsi_device, ew.work);
> > > >  
> > > > +	if (sdev->put_lld_mod_ref) {
> > > 
> > > Why do you need this flag at all?
> > > 
> > > Shouldn't you just always grab/release the module?  Why would you not
> > > want to?
> > 
> > try_module_get() may fail in scsi_device_dev_release() in case that
> > unloading is started, then we don't need to put it in
> > scsi_device_dev_release_usercontext(), so this flag is required.
> 
> If grabing the module reference failed then you CAN NOT call into it so
> you have a problem here that you seem to be papering over.  Just set the
> module pointer to NULL and then you don't need to test it when calling
> module_put, right?

OK, sounds good, given the failure means that we shouldn't touch it any
more.


Thanks,
Ming

