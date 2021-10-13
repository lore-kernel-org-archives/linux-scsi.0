Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBCAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B35B60FDA
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbhJMILm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:11:42 -0400
Received: from mga17.intel.com ([192.55.52.151]:35397 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238688AbhJMILh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 04:11:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="208176652"
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="208176652"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 01:09:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="480696907"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by orsmga007.jf.intel.com with ESMTP; 13 Oct 2021 01:09:30 -0700
Subject: Re: [PATCH 5/5] scsi: ufs: Add a sysfs attribute for triggering the
 UFS EH
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211012215433.3725777-1-bvanassche@acm.org>
 <20211012215433.3725777-6-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <cd4b5103-e0fd-feed-2663-b505bcf019d8@intel.com>
Date:   Wed, 13 Oct 2021 11:09:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211012215433.3725777-6-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/10/2021 00:54, Bart Van Assche wrote:
> Make it possible to test the impact of the UFS error handler on software
> that submits SCSI commands to the UFS driver.

Are you sure this isn't better suited to debugfs?

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

Does it matter if ufshcd_eh_in_progress()?

> +
> +	if (sysfs_streq(buf, "1")) {
> +		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;

Shouldn't overwrite UFSHCD_STATE_ERROR

> +		hba->saved_err |= UIC_ERROR;

ufshcd_err_handler() still behaves differently depending on
hba->saved_uic_err

> +	} else if (sysfs_streq(buf, "2")) {
> +		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
> +		hba->saved_err |= UIC_ERROR;

In addition, a fatal error must be set to get fatal error behaviour from
ufshcd_err_handler.

> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	scsi_schedule_eh(hba->host);

Probably should be:

	queue_work(hba->eh_wq, &hba->eh_work);

However, it might be simpler to replace everything with:

	spin_lock(hba->host->host_lock);
	hba->saved_err |= <something>;
	hba->saved_uic_err |= <something else>;
	ufshcd_schedule_eh_work(hba);
	spin_unlock(hba->host->host_lock);

Perhaps letting the user specify values to determine <something>
and <something else>

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
>  	.sdev_groups		= ufshcd_driver_groups,
>  	.dma_boundary		= PAGE_SIZE - 1,
>  	.rpm_autosuspend_delay	= RPM_AUTOSUSPEND_DELAY_MS,
> 

