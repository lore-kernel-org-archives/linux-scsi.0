Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE715C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 07:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B35E2610FB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 07:19:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbhJGHVV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 03:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232512AbhJGHVU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Oct 2021 03:21:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23AC96101E;
        Thu,  7 Oct 2021 07:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633591167;
        bh=KKqVxcZ+QAOzW+phGrvFAsuLInJucEfq92yEOpG6WQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qxd83c0Wg+rBywZnrCBO5uy9em4f0fxoiKZ+mHv9zmxhHisWiTt3dWjTw+09SyPdK
         h1Zymeuh9+XDc5nJy9lEjqUNKC0CkMgu4+TGpxmrA85P9YRiDk25SyIi/emGAsk2h/
         O+M4tV0u7XB03ShplumtC25duKm/GZQdVZwnLakY=
Date:   Thu, 7 Oct 2021 09:19:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH V3] scsi: core: put LLD module refcnt after SCSI device
 is released
Message-ID: <YV6ffTjVBJgDIgtG@kroah.com>
References: <20210930124415.1160754-1-ming.lei@redhat.com>
 <YVxUrIQw7ACcmSx2@kroah.com>
 <YV6d9OmLt1w5d9Qp@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV6d9OmLt1w5d9Qp@T590>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 07, 2021 at 03:12:52PM +0800, Ming Lei wrote:
> On Tue, Oct 05, 2021 at 03:35:40PM +0200, Greg Kroah-Hartman wrote:
> > On Thu, Sep 30, 2021 at 08:44:15PM +0800, Ming Lei wrote:
> > > SCSI host release is triggered when SCSI device is freed, and we have to
> > > make sure that LLD module won't be unloaded before SCSI host instance is
> > > released because shost->hostt is required in host release handler.
> > > 
> > > So make sure to put LLD module refcnt after SCSI device is released.
> > 
> > What is a "LLD"?
> 
> Lower level driver, which is used often as one scsi term.
> 
> > 
> > > Fix one kernel panic of 'BUG: unable to handle page fault for address'
> > > reported by Changhui and Yi.
> > > 
> > > Reported-by: Changhui Zhong <czhong@redhat.com>
> > > Reported-by: Yi Zhang <yi.zhang@redhat.com>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >  drivers/scsi/scsi.c        |  4 +++-
> > >  drivers/scsi/scsi_sysfs.c  | 12 ++++++++++++
> > >  include/scsi/scsi_device.h |  1 +
> > >  3 files changed, 16 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > > index b241f9e3885c..291ecc33b1fe 100644
> > > --- a/drivers/scsi/scsi.c
> > > +++ b/drivers/scsi/scsi.c
> > > @@ -553,8 +553,10 @@ EXPORT_SYMBOL(scsi_device_get);
> > >   */
> > >  void scsi_device_put(struct scsi_device *sdev)
> > >  {
> > > -	module_put(sdev->host->hostt->module);
> > > +	struct module *mod = sdev->host->hostt->module;
> > > +
> > >  	put_device(&sdev->sdev_gendev);
> > > +	module_put(mod);
> > >  }
> > >  EXPORT_SYMBOL(scsi_device_put);
> > >  
> > > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > > index 86793259e541..9ada26814011 100644
> > > --- a/drivers/scsi/scsi_sysfs.c
> > > +++ b/drivers/scsi/scsi_sysfs.c
> > > @@ -449,9 +449,16 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
> > >  	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
> > >  	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
> > >  	unsigned long flags;
> > > +	struct module *mod;
> > > +	bool put_mod = false;
> > >  
> > >  	sdev = container_of(work, struct scsi_device, ew.work);
> > >  
> > > +	if (sdev->put_lld_mod_ref) {
> > 
> > Why do you need this flag at all?
> > 
> > Shouldn't you just always grab/release the module?  Why would you not
> > want to?
> 
> try_module_get() may fail in scsi_device_dev_release() in case that
> unloading is started, then we don't need to put it in
> scsi_device_dev_release_usercontext(), so this flag is required.

If grabing the module reference failed then you CAN NOT call into it so
you have a problem here that you seem to be papering over.  Just set the
module pointer to NULL and then you don't need to test it when calling
module_put, right?

thanks,

greg k-h
