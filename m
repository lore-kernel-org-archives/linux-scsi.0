Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868F6C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 07:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6955161027
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 07:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238239AbhJMHXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 03:23:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238404AbhJMHVT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 03:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E570A60C4A;
        Wed, 13 Oct 2021 07:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634109556;
        bh=VrrVAOgymRJhFWMu8viSXQVX4HSPyOEGvFm+v0wGea4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UMa9h1DmW4KhWQxZ+xW31P02m1byPoJhlvqjS7BNlYRhdBf/Ow0/sSbOsgA6WflWV
         MA/wj/L47TwP9y6ByguH+5voks9NgMNxpJZZg3W3rezwicKW1Z4a/GWUO8vOoVmnSo
         +8RHKFnFJiwSCN7venDuIdTgdDIfUosJVCtEMwUY=
Date:   Wed, 13 Oct 2021 09:19:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: Re: [PATCH 5/5] scsi: ufs: Add a sysfs attribute for triggering the
 UFS EH
Message-ID: <YWaIcpHbK4e6ELih@kroah.com>
References: <20211012215433.3725777-1-bvanassche@acm.org>
 <20211012215433.3725777-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012215433.3725777-6-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 12, 2021 at 02:54:33PM -0700, Bart Van Assche wrote:
> Make it possible to test the impact of the UFS error handler on software
> that submits SCSI commands to the UFS driver.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  Documentation/ABI/testing/sysfs-driver-ufs | 10 ++++++
>  drivers/scsi/ufs/ufshcd.c                  | 37 ++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
> index ec3a7149ced5..2a46f91d3f1b 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -1534,3 +1534,13 @@ Contact:	Avri Altman <avri.altman@wdc.com>
>  Description:	In host control mode the host is the originator of map requests.
>  		To avoid flooding the device with map requests, use a simple throttling
>  		mechanism that limits the number of inflight map requests.
> +
> +What:		/sys/class/scsi_host/*/trigger_eh
> +Date:		October 2021
> +Contact:	Bart Van Assche <bvanassche@acm.org>
> +Description:	Writing into this sysfs attribute triggers the UFS error
> +		handler. This is useful for testing how the UFS error handler
> +		affects SCSI command processing. The supported values are as
> +		follows: "1" triggers the error handler without resetting the
> +		host controller and "2" starts the error handler and makes it
> +		reset the host interface.
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ecfe1f124f8a..30ff93979840 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -8144,6 +8144,42 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
>  	}
>  }
>  
> +static ssize_t trigger_eh_store(struct device *dev,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct Scsi_Host *host = class_to_shost(dev);
> +	struct ufs_hba *hba = shost_priv(host);
> +
> +	/*
> +	 * Using locking would be a better solution. However, this is a debug
> +	 * attribute so ufshcd_eh_in_progress() should be good enough.
> +	 */
> +	if (ufshcd_eh_in_progress(hba))
> +		return -EBUSY;
> +
> +	if (sysfs_streq(buf, "1")) {
> +		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
> +		hba->saved_err |= UIC_ERROR;
> +	} else if (sysfs_streq(buf, "2")) {
> +		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
> +		hba->saved_err |= UIC_ERROR;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	scsi_schedule_eh(hba->host);
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR_WO(trigger_eh);
> +
> +static struct device_attribute *ufshcd_shost_attrs[] = {
> +	&dev_attr_trigger_eh,
> +	NULL
> +};
> +
>  static const struct attribute_group *ufshcd_driver_groups[] = {
>  	&ufs_sysfs_unit_descriptor_group,
>  	&ufs_sysfs_lun_attributes_group,
> @@ -8183,6 +8219,7 @@ static struct scsi_host_template ufshcd_driver_template = {
>  	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
>  	.max_host_blocked	= 1,
>  	.track_queue_depth	= 1,
> +	.shost_attrs		= ufshcd_shost_attrs,

Why can't this get added to the sdev_groups list?

thanks,

greg k-h
