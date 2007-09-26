From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fix leftover from default sdev attribute switch
Date: Wed, 26 Sep 2007 13:23:59 -0500
Message-ID: <1190831039.3359.69.camel@localhost.localdomain>
References: <1190829289.3773.74.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59240 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761743AbXIZSYD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 14:24:03 -0400
In-Reply-To: <1190829289.3773.74.camel@lov.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2007-09-26 at 19:54 +0200, Kay Sievers wrote:
> Hi James,
> seems we miss the following fix in the current tree.
> 
> Thanks,
> Kay
> 
> 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: [SCSI] fix scsi_is_sdev_device() after switch to default sdev attributes
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 0088c4d..8e880ef 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -995,7 +995,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
>  
>  int scsi_is_sdev_device(const struct device *dev)
>  {
> -	return dev->release == scsi_device_dev_release;
> +	return dev->type == &scsi_dev_type;

This will make the check different from all the others in the
mid-layer ... is there any reason to change it?

James


