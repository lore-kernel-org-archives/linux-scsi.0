Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969EAC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 05:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B3FF60F6B
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 05:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243836AbhJIF52 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 01:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232529AbhJIF51 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Oct 2021 01:57:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E594460F5B;
        Sat,  9 Oct 2021 05:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633758931;
        bh=mPhmaqXT3YwhW1qk+dR/jLrHHuwFCaDQvu5go+GQ558=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2MvMxhEUYWlrYT6c+r2pprDAQh31UAE2Vyb6mgIC4pwmFqVkO7KUIDtM/bChnwXS4
         QJhxCdqNvooY4ZbFMXJvTUjveVAMZxdamuhdvFgmWc49Ly1o6tAAUMj7oiRKVsDfRD
         1KUrKYXkxqwG3r3/GhG++ZXjBp2c6PGWp+3WxH9I=
Date:   Sat, 9 Oct 2021 07:55:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 45/46] scsi: usb: Switch to attribute groups
Message-ID: <YWEu0Ko7TaaLuaVy@kroah.com>
References: <20211008202353.1448570-1-bvanassche@acm.org>
 <20211008202353.1448570-46-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008202353.1448570-46-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 08, 2021 at 01:23:52PM -0700, Bart Van Assche wrote:
> struct device supports attribute groups directly but does not support
> struct device_attribute directly. Hence switch to attribute groups.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/usb/storage/scsiglue.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index e5a971b83e3f..4e5a928f0368 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -588,11 +588,13 @@ static ssize_t max_sectors_store(struct device *dev, struct device_attribute *at
>  }
>  static DEVICE_ATTR_RW(max_sectors);
>  
> -static struct device_attribute *sysfs_device_attr_list[] = {
> -	&dev_attr_max_sectors,
> +static struct attribute *usb_sdev_attrs[] = {
> +	&dev_attr_max_sectors.attr,
>  	NULL,
>  };
>  
> +ATTRIBUTE_GROUPS(usb_sdev);
> +
>  /*
>   * this defines our host template, with which we'll allocate hosts
>   */
> @@ -653,7 +655,7 @@ static const struct scsi_host_template usb_stor_host_template = {
>  	.skip_settle_delay =		1,
>  
>  	/* sysfs device attributes */
> -	.sdev_attrs =			sysfs_device_attr_list,
> +	.sdev_groups =			usb_sdev_groups,
>  
>  	/* module management */
>  	.module =			THIS_MODULE


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
