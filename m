Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3F6181BB8;
	Mon,  6 Oct 2025 00:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759712300; cv=none; b=Mekjk3AePtpe4MZcJrh7VrIheKH5SAqOfLaheLO0TPhpyB8itw9bYsgiHmBsT693ZbKylr7vswSoWMqPOZt7+Z5FMFWNKt7Z1RfyD5OWkwkbIPRM0cgy7Dr2jx2jXP9eiusHFvI3oAP3VSnfM9jhJjCQqrxh10m+EdrdeegT0BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759712300; c=relaxed/simple;
	bh=EcMDDLdW7ZJUGptFXlXKYTC6Z5rOAWfwRAkcrxXK2kA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rkVjHd9t+Wtb07jppbBxr06X7f2Qogxj8qV+jvBiDhOPX2hFaJjEmhbcDvcMRvan1awKOZD6q2+xeKqjD+8U8OHLemUCA6uXD+z9HlwxZJjPGEQIa4E9p6sUZzfuuKc8CxN0LofC2R47FFGehAduid733IZckbQ4oQLKQYLi0RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZbyDNjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZbyDNjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF87C4CEF4;
	Mon,  6 Oct 2025 00:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759712300;
	bh=EcMDDLdW7ZJUGptFXlXKYTC6Z5rOAWfwRAkcrxXK2kA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YZbyDNjmmCtMsu/JP1EcJrFJAGo1+z8fHFHFptutLOH4+1xvin8C5nAKZVe7RxUCW
	 v641GOQFoBs+A3hN+O0nF9JEf2z7QFGXDh6nvpTJg8MHxX/pPT+Ewj7F12JY7y7Lsb
	 HP9TIVL3kw+LlkUM43DSC24LcsweqSRBFc9bnSn99Tpi808gMqcUEGccPT8tLFYipI
	 F7MFMnZAcQsTiYx8Qm9wWIZTYRVBQEQVnQ3YZhTF245nzMgGBhjDzfczg8qu5wmbd/
	 1yVuVm8T0cc/dguVADTN29H6Lqj3uwDvV6BGKwLSdE4VGnVxbhSixRHzHf6aXHMOb7
	 dWmYokK8o7w6Q==
Message-ID: <524f67bf-f4df-41bf-bf1b-5cd0a79649eb@kernel.org>
Date: Mon, 6 Oct 2025 09:58:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] Add manage_restart device attribute to scsi_disk
To: Markus Probst <markus.probst@posteo.de>, Niklas Cassel
 <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <8c3cb28c57462f9665b08fdaa022e6abc57fcd9e.camel@posteo.de>
 <20251005190559.1472308-1-markus.probst@posteo.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251005190559.1472308-1-markus.probst@posteo.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/6/25 04:06, Markus Probst wrote:
> there is already manage_shutdown, manage_system_start_stop and
> manage_runtime_start_stop device attributes that allows the high-level
> device driver (sd) manage the device power state, expect for the
> system_state SYSTEM_RESTART. With this device attribute, it is possible to
> let the high-level device driver (sd) manage the device power state for
> SYSTEM_RESTART too.
> 
> Signed-off-by: Markus Probst <markus.probst@posteo.de>
> ---
>  drivers/scsi/sd.c          | 35 ++++++++++++++++++++++++++++++++++-
>  include/scsi/scsi_device.h |  6 ++++++
>  2 files changed, 40 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5b8668accf8e..a3e9c2e9d9f4 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -318,6 +318,36 @@ static ssize_t manage_shutdown_store(struct device *dev,
>  }
>  static DEVICE_ATTR_RW(manage_shutdown);
>  
> +static ssize_t manage_restart_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +	struct scsi_device *sdp = sdkp->device;

sdp is not really needed.

> +
> +	return sysfs_emit(buf, "%u\n", sdp->manage_restart);
> +}
> +
> +
> +static ssize_t manage_restart_store(struct device *dev,
> +				    struct device_attribute *attr,
> +				    const char *buf, size_t count)
> +{
> +	struct scsi_disk *sdkp = to_scsi_disk(dev);
> +	struct scsi_device *sdp = sdkp->device;

Same here.

> +	bool v;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	if (kstrtobool(buf, &v))
> +		return -EINVAL;
> +
> +	sdp->manage_restart = v;
> +
> +	return count;
> +}
> +static DEVICE_ATTR_RW(manage_restart);
> +
>  static ssize_t
>  allow_restart_show(struct device *dev, struct device_attribute *attr, char *buf)
>  {
> @@ -654,6 +684,7 @@ static struct attribute *sd_disk_attrs[] = {
>  	&dev_attr_manage_system_start_stop.attr,
>  	&dev_attr_manage_runtime_start_stop.attr,
>  	&dev_attr_manage_shutdown.attr,
> +	&dev_attr_manage_restart.attr,
>  	&dev_attr_protection_type.attr,
>  	&dev_attr_protection_mode.attr,
>  	&dev_attr_app_tag_own.attr,
> @@ -4175,7 +4206,9 @@ static void sd_shutdown(struct device *dev)
>  	    (system_state == SYSTEM_POWER_OFF &&
>  	     sdkp->device->manage_shutdown) ||
>  	    (system_state == SYSTEM_RUNNING &&
> -	     sdkp->device->manage_runtime_start_stop)) {
> +	     sdkp->device->manage_runtime_start_stop) ||
> +	    (system_state == SYSTEM_RESTART &&
> +	     sdkp->device->manage_restart)) {
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 6d6500148c4b..c7e657ac8b6d 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -178,6 +178,12 @@ struct scsi_device {
>  	 */
>  	unsigned manage_shutdown:1;
>  
> +	/*
> +	 * If true, let the high-level device driver (sd) manage the device
> +	 * power state for system restart (reboot) operations.

What about cold boot ? Same is needed, no ? The name "manage_restart" is a bit
confusing since we already have manage_system_start_stop,
manage_runtime_start_stop and manage_shutdown. I do not have a better suggestion
though.

> +	 */
> +	unsigned manage_restart:1;
> +
>  	/*
>  	 * If set and if the device is runtime suspended, ask the high-level
>  	 * device driver (sd) to force a runtime resume of the device.


-- 
Damien Le Moal
Western Digital Research
