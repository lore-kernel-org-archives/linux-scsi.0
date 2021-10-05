Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B8BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 13:35:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E2BD613AC
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 13:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbhJENhd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 09:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234170AbhJENhc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Oct 2021 09:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A3461373;
        Tue,  5 Oct 2021 13:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633440942;
        bh=rmiNW24/FYEIfXM5I6t4acvrWgnU8hlztAf4CfxGHdw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QvX/svW3718K8DxSSqNursVFPuWYzbbpBOhvWl1fm03YrqXamEV9oI6/3q7lSf7WJ
         lfmljhkzMWRNND5DXr3JVdPWMW0Nf+P35ScDeGdXvJTpj5/J3LMtedczUqSknj1nja
         fFAEKrWiFFM8PrjQWvapq8cKe0Uidg0ouI8W+xp4=
Date:   Tue, 5 Oct 2021 15:35:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Changhui Zhong <czhong@redhat.com>,
        Yi Zhang <yi.zhang@redhat.com>
Subject: Re: [PATCH V3] scsi: core: put LLD module refcnt after SCSI device
 is released
Message-ID: <YVxUrIQw7ACcmSx2@kroah.com>
References: <20210930124415.1160754-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930124415.1160754-1-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 08:44:15PM +0800, Ming Lei wrote:
> SCSI host release is triggered when SCSI device is freed, and we have to
> make sure that LLD module won't be unloaded before SCSI host instance is
> released because shost->hostt is required in host release handler.
> 
> So make sure to put LLD module refcnt after SCSI device is released.

What is a "LLD"?

> Fix one kernel panic of 'BUG: unable to handle page fault for address'
> reported by Changhui and Yi.
> 
> Reported-by: Changhui Zhong <czhong@redhat.com>
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi.c        |  4 +++-
>  drivers/scsi/scsi_sysfs.c  | 12 ++++++++++++
>  include/scsi/scsi_device.h |  1 +
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index b241f9e3885c..291ecc33b1fe 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -553,8 +553,10 @@ EXPORT_SYMBOL(scsi_device_get);
>   */
>  void scsi_device_put(struct scsi_device *sdev)
>  {
> -	module_put(sdev->host->hostt->module);
> +	struct module *mod = sdev->host->hostt->module;
> +
>  	put_device(&sdev->sdev_gendev);
> +	module_put(mod);
>  }
>  EXPORT_SYMBOL(scsi_device_put);
>  
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 86793259e541..9ada26814011 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -449,9 +449,16 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
>  	struct scsi_vpd *vpd_pg0 = NULL, *vpd_pg89 = NULL;
>  	unsigned long flags;
> +	struct module *mod;
> +	bool put_mod = false;
>  
>  	sdev = container_of(work, struct scsi_device, ew.work);
>  
> +	if (sdev->put_lld_mod_ref) {

Why do you need this flag at all?

Shouldn't you just always grab/release the module?  Why would you not
want to?

thanks,

greg k-h
