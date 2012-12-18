From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: remove device when state is changed to deleted
 thru sysfs
Date: Tue, 18 Dec 2012 08:51:49 +0100
Message-ID: <50D02095.2080505@acm.org>
References: <1355786812-17908-1-git-send-email-dmilburn@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:46641 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab2LRHvy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Dec 2012 02:51:54 -0500
In-Reply-To: <1355786812-17908-1-git-send-email-dmilburn@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com

On 12/18/12 00:26, David Milburn wrote:
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index ce5224c..6d72abb 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -596,7 +596,7 @@ static ssize_t
>   store_state_field(struct device *dev, struct device_attribute *attr,
>   		  const char *buf, size_t count)
>   {
> -	int i;
> +	int i, rc;
>   	struct scsi_device *sdev = to_scsi_device(dev);
>   	enum scsi_device_state state = 0;
>
> @@ -611,7 +611,11 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>   	if (!state)
>   		return -EINVAL;
>
> -	if (scsi_device_set_state(sdev, state))
> +	if (state == SDEV_DEL) {
> +		rc = device_schedule_callback(dev, sdev_store_delete_callback);
> +		if (rc)
> +			count = rc;
> +	} else if (scsi_device_set_state(sdev, state))
>   		return -EINVAL;
>   	return count;
>   }

Hello David,

And what about the "cancel" state ? I guess this means that you have 
missed patch http://marc.info/?l=linux-scsi&m=135480941801843 ?

Bart.
