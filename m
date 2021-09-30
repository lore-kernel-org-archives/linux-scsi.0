Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E799DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B541861875
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 05:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348162AbhI3F7f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 01:59:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348054AbhI3F7e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 01:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FC6661152;
        Thu, 30 Sep 2021 05:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632981472;
        bh=cHI+A6gWItcKl8S7wlbHfgAOUQDGvwT7rOAnVOuQdZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1E5LHfS+W04KdzhJbAryOJ6aSF15dqa6lndcHhoTAohB1FIlOOkWYX9T2LGGWeijd
         b6RcbtspdCcReU7f7004s+7wF2SHuGWt0div0UGiWkR9v0FX0MqooPFsyWcYWMtHC6
         J7TY7OMFDBPqZetZ+CNdsXUdRWtEwnOEp5rlbYkI=
Date:   Thu, 30 Sep 2021 07:57:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH 2/2] scsi: core: put LLD module refcnt after SCSI device
 is released
Message-ID: <YVVR20qW6i6eT0rg@kroah.com>
References: <20210930052028.934747-1-ming.lei@redhat.com>
 <20210930052028.934747-3-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930052028.934747-3-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 01:20:28PM +0800, Ming Lei wrote:
> SCSI host release is triggered when SCSI device is released, and we have to
> make sure that LLD module won't be unloaded before SCSI host instance is
> released.
> 
> So put LLD module refcnt after SCSI device is released.
> 
> SCSI device release may be moved into workqueue context if scsi_device_put
> is called in interrupt context, and handle this case by piggybacking
> putting LLD module refcnt into SCSI device release handler.
> 
> Reported-by: Changhui Zhong <czhong@redhat.com>
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi.c        | 14 ++++++++++++--
>  drivers/scsi/scsi_sysfs.c  |  8 ++++++++
>  include/scsi/scsi_device.h |  1 +
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index b241f9e3885c..7cad256ba895 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -553,8 +553,18 @@ EXPORT_SYMBOL(scsi_device_get);
>   */
>  void scsi_device_put(struct scsi_device *sdev)
>  {
> -	module_put(sdev->host->hostt->module);
> -	put_device(&sdev->sdev_gendev);
> +	struct module *mod = sdev->host->hostt->module;
> +	/*
> +	 * sdev->sdev_gendev's real release handler will be scheduled into
> +	 * user context if we are in interrupt context, and we have to put
> +	 * LLD module refcnt after the device is really released.
> +	 */
> +	preempt_disable();
> +	if (put_device(&sdev->sdev_gendev) && in_interrupt())

Why does in_interrupt() matter here?  And is this even set if you have
threaded interrupts?

This feels very wrong as you are doing something different if this is
called depending on the context and you really do not have control over
the context of when this is called at all.

What problem is this solving?  How is a host controller driver being
unloaded before the children it controls are removed?  Who is holding a
reference on them and why is this happening only now?

And who cares about unloading the kernel module in this fashion?

thanks,

greg k-h
