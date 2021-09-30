Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9B00C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A8BF615E0
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 08:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349028AbhI3IJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 04:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348885AbhI3IJ3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 04:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06A70615E0;
        Thu, 30 Sep 2021 08:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632989267;
        bh=WFjd+VMQ0w8W4XQGSGG6EaiEb5Pch8uG40+sKi0/fGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MQCn/U8L681vOjTpGIlM85mYw+D0g8tXJdcHcoqNGltr1ktSQ592y3WMSpy7msZ2U
         PGDkSVvsIux9RERvLLKkVQhV+kKN/Dkgfy4/c8a7CBQl3CIr7XRy62i2s2iGro+0Uq
         7Vd6qQwu5kwlPodiJl0TIfRIxQA6dwPmEolzVVe8=
Date:   Thu, 30 Sep 2021 10:07:44 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH V2] scsi: core: put LLD module refcnt after SCSI device
 is released
Message-ID: <YVVwUCKbXHAbzguG@kroah.com>
References: <20210930074026.1011114-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930074026.1011114-1-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 03:40:26PM +0800, Ming Lei wrote:
> SCSI host release is triggered when SCSI device is freed, and we have to
> make sure that LLD module won't be unloaded before SCSI host instance is
> released because shost->hostt is required in host release handler.
> 
> So put LLD module refcnt after SCSI device is released.
> 
> The real release handler can be run from wq context in case of
> in_interrupt(), so add one atomic counter for serializing putting
> module via current and wq context. This way is fine since we don't
> call scsi_device_put() in fast IO path.
> 
> Reported-by: Changhui Zhong <czhong@redhat.com>
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi.c        |  8 +++++++-
>  drivers/scsi/scsi_sysfs.c  | 10 ++++++++++
>  include/scsi/scsi_device.h |  2 ++
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index b241f9e3885c..b6612161587f 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -553,8 +553,14 @@ EXPORT_SYMBOL(scsi_device_get);
>   */
>  void scsi_device_put(struct scsi_device *sdev)
>  {
> -	module_put(sdev->host->hostt->module);
> +	struct module *mod = sdev->host->hostt->module;
> +
> +	atomic_inc(&sdev->put_dev_cnt);

Ick, no!  Why are you making a new lock and reference count for no
reason?

> +
>  	put_device(&sdev->sdev_gendev);
> +
> +	if (atomic_dec_if_positive(&sdev->put_dev_cnt) >= 0)
> +		module_put(mod);

How do you know if your module pointer is still valid here?

Why do you care?

What problem are you trying to solve and why is it unique to scsi
devices?

thanks,

greg k-h
