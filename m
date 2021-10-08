Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C06C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 05:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01964610CE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 05:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhJHFlL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 01:41:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59239 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229511AbhJHFlJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Oct 2021 01:41:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CA7A610A1;
        Fri,  8 Oct 2021 05:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633671554;
        bh=7j0x8aKPf68TZO3NomYBhDMBQIejs7OG3WjMiGQiF3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IUJ84gzDLIe2xqzqWheqgcT7ZUP010pL0nesg6y7rbU/zAxpy+L1a4AjKyzfKsJ6U
         PK2L0lzHlqyDYFcBs1SIykWu/l6SipoqXNTb8n26hiLFmTMS2VjOLN1WBqmLKVDG7P
         2LeNS1xW+2xJs3sBauO/fQ/YvHcqwjhlEjQUXh4c=
Date:   Fri, 8 Oct 2021 07:39:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 45/46] scsi: usb: Switch to attribute groups
Message-ID: <YV/Zf9kTcPbxzOXP@kroah.com>
References: <20211007211852.256007-1-bvanassche@acm.org>
 <20211007211852.256007-46-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007211852.256007-46-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 07, 2021 at 02:18:51PM -0700, Bart Van Assche wrote:
> struct device supports attribute groups directly but does not support
> struct device_attribute directly. Hence switch to attribute groups.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/usb/storage/scsiglue.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index e5a971b83e3f..123273c52fc8 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -588,11 +588,20 @@ static ssize_t max_sectors_store(struct device *dev, struct device_attribute *at
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
> +static const struct attribute_group usb_sdev_attr_group = {
> +	.attrs = usb_sdev_attrs
> +};
> +
> +static const struct attribute_group *usb_sdev_attr_groups[] = {
> +	&usb_sdev_attr_group,
> +	NULL
> +};

ATTRIBUTE_GROUPS()?

