Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93EA6D1B4;
	Tue, 16 Jul 2024 22:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721170109; cv=none; b=SZ6lAHQsEbP4A4QSHmYZok/+ryIiQcnG4FItwHN7eQxOCt1Bg2SyJMyi8Qy0tqHeMO99dGzDjuu2TXb5j61n4dZfC1Z0PRY9tkmEHizp2GlLAAJHVXUx0veds+tIieNXXIA0s4xHngBZnVZv1DOh6DfKIaADYrILDaRf8f3zptk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721170109; c=relaxed/simple;
	bh=Bc4xTGNKVk7Hlv8gcknsmkXuaNvkoVNmZN1zbJzDlWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gC2M4cggomntCFQNCTP8tFBmeEWl1eQ/J/nV8edmid47lIExNQ9i2/tHKDWgmbCHttSZkBPnyK19IDtGHRfwESmd4qh4itxI/T0uMUbxH/p/87gC855OvWx7Dm8oS6Ke/ve7afqhOiON8BidsYBemdaWfOx68LiEtPATvtoYR/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBs/jGkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBs/jGkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76310C4AF09;
	Tue, 16 Jul 2024 22:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721170108;
	bh=Bc4xTGNKVk7Hlv8gcknsmkXuaNvkoVNmZN1zbJzDlWY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dBs/jGkF1za9BWqtguN1YGZERXq3FgP+0R9AlKLNiB4mkptN81MYpE7g5nDvw1Que
	 MFz0/UrmcFfTgAOJJppe7YhY5aq9EgsMegUd775my7c6a35gNURCh1NSXRu7FFMiNe
	 pLD6vs2P4VeoZOFmLUCUbaL0JsGHyQz3bqy6n7Nmf52mu4Uv4Ngyw88mHesf9fCq7f
	 WKHU83sAhZ3v9zElDIK3Xd1O+ah6B8gLNORw+oSTv++8zYJczbnMabU2aV7JpkQCoJ
	 9k4f23DKT1Ulc/y43pi+MF696K1nFgtVJ2XFhRDNawpLJrp+C26sZ6ws0cfr1KwwGd
	 i5mjlpmpSRNiQ==
Message-ID: <39143ca8-68e4-44eb-8619-0b935aa81603@kernel.org>
Date: Wed, 17 Jul 2024 07:48:26 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "scsi: sd: Do not repeat the starting disk
 message"
To: Johan Hovold <johan+linaro@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20240716161101.30692-1-johan+linaro@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240716161101.30692-1-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/17/24 01:11, Johan Hovold wrote:
> This reverts commit 7a6bbc2829d4ab592c7e440a6f6f5deb3cd95db4.
> 
> The offending commit tried to suppress a double "Starting disk" message
> for some drivers, but instead started spamming the log with bogus
> messages every five seconds:
> 
> 	[  311.798956] sd 0:0:0:0: [sda] Starting disk
> 	[  316.919103] sd 0:0:0:0: [sda] Starting disk
> 	[  322.040775] sd 0:0:0:0: [sda] Starting disk
> 	[  327.161140] sd 0:0:0:0: [sda] Starting disk
> 	[  332.281352] sd 0:0:0:0: [sda] Starting disk
> 	[  337.401878] sd 0:0:0:0: [sda] Starting disk
> 	[  342.521527] sd 0:0:0:0: [sda] Starting disk
> 	[  345.850401] sd 0:0:0:0: [sda] Starting disk
> 	[  350.967132] sd 0:0:0:0: [sda] Starting disk
> 	[  356.090454] sd 0:0:0:0: [sda] Starting disk
> 	...
> 
> on machines that do not actually stop the disk on runtime suspend (e.g.
> the Qualcomm sc8280xp CRD with UFS).

This is odd. If the disk is not being being suspended, why does the platform
even enable runtime PM for it ? Are you sure about this ? Or is it simply that
the runtime pm timer is set to a very low interval ?

It almost sound like what we need to do here is suppress this message for the
runtime resume case, so something like:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2e933fd1de70..4261128bf1f3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4220,7 +4220,8 @@ static int sd_resume_common(struct device *dev, bool runtime)
        if (!sdkp)      /* E.g.: runtime resume at the start of sd_probe() */
                return 0;

-       sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+       if (!runtime)
+               sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");

        if (!sd_do_start_stop(sdkp->device, runtime)) {
                sdkp->suspended = false;

However, I would like to make sure that this platform is not calling
sd_resume_runtime() for nothing every 5s. If that is the case, then there is a
more fundamental problem here and reverting this patch is only hiding that.

> 
> Let's just revert for now to address the regression.
> 
> Fixes: 7a6bbc2829d4 ("scsi: sd: Do not repeat the starting disk message")
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/scsi/sd.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> 
> Hi,
> 
> I just noticed this regression that snuck into 6.10-final and tracked it
> down to 7a6bbc2829d4 ("scsi: sd: Do not repeat the starting disk
> message").
> 
> I wanted to get this out ASAP to address the immediate regression while
> someone who cares enough can work out a proper fix for the double start
> message (which seems less annoying).
> 
> Note that the offending commit is marked for stable.
> 
> Johan
> 
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1b7561abe05d..6b64af7d4927 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4119,6 +4119,8 @@ static int sd_resume(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
>  
> +	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> +
>  	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
>  		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
>  		return -EIO;
> @@ -4135,13 +4137,12 @@ static int sd_resume_common(struct device *dev, bool runtime)
>  	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
>  		return 0;
>  
> -	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> -
>  	if (!sd_do_start_stop(sdkp->device, runtime)) {
>  		sdkp->suspended = false;
>  		return 0;
>  	}
>  
> +	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
>  	ret = sd_start_stop_device(sdkp, 1);
>  	if (!ret) {
>  		sd_resume(dev);

-- 
Damien Le Moal
Western Digital Research

