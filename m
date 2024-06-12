Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 686D684A27
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2024 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.131.102.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718221433; cv=none; b=TYATHIdFRyf36piFnnfI+XYoVNXa10axM55jgTZw1ji0GxtQKN8hL9Zz98vAfjSS37xYxHBL9mBKZgbYUsRechzavCFBqX1EpBkjo/2riyvMRYorV1xFmz02wOvE+Mi/MIb+E4S7UAMeKrxwX4LQHN2NTyIhVXR0ChentFZ0+GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718221433; c=relaxed/simple;
	bh=K6wo7Y8jf68McAtHAhMQrqrLVekb1F1m3zziWZI0S3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRVW2WYVYmUxXgHhlRVxKvCEk2dJ+8mT3N/gZv5XFebQCXFmL1JOvwg//NcARYXIT1AMlWNMMvx9eHmU2KLLlfuVZUTMiZMNHR1qwdwcVo7EZiqy63ZMiwlHaMysYTB8MlMNIgMdIQ129PkrLvUMNhnKh2dt2VKoGm/v4PCs9yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu; spf=pass smtp.mailfrom=netrider.rowland.org; arc=none smtp.client-ip=192.131.102.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrider.rowland.org
Received: (qmail 235323 invoked by uid 1000); 12 Jun 2024 15:43:50 -0400
Date: Wed, 12 Jun 2024 15:43:50 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
  Joao Machado <jocrismachado@gmail.com>,
  Andy Shevchenko <andy.shevchenko@gmail.com>,
  Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] scsi: core: Do not query IO hints for USB devices
Message-ID: <c0cabdc2-0dcf-4c53-8bd8-c9ce02be0316@rowland.harvard.edu>
References: <20240612165249.2671204-1-bvanassche@acm.org>
 <20240612165249.2671204-3-bvanassche@acm.org>
 <de4492b5-a681-42bf-99d7-e9ba30dabeb2@rowland.harvard.edu>
 <a7ac0431-2b30-43bf-bb90-1476e33aa6cd@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7ac0431-2b30-43bf-bb90-1476e33aa6cd@acm.org>

On Wed, Jun 12, 2024 at 12:30:34PM -0700, Bart Van Assche wrote:
> On 6/12/24 11:08 AM, Alan Stern wrote:
> > You might want to do the same thing in uas.c.  I don't know if UAS
> > devices suffer from the same problem, but it wouldn't be surprising if
> > they do.
> 
> Hi Alan,
> 
> How about replacing patch 2/2 from this series with the patch below?

That's better, thanks.

Alan Stern

> 
> Thanks,
> 
> Bart.
> 
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index b31464740f6c..b4cf0349fd0d 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -79,6 +79,12 @@ static int slave_alloc (struct scsi_device *sdev)
>  	if (us->protocol == USB_PR_BULK && us->max_lun > 0)
>  		sdev->sdev_bflags |= BLIST_FORCELUN;
> 
> +	/*
> +	 * Some USB storage devices reset if the IO hints VPD page is queried.
> +	 * Hence skip that VPD page.
> +	 */
> +	sdev->sdev_bflags |= BLIST_SKIP_IO_HINTS;
> +
>  	return 0;
>  }
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index a48870a87a29..bb75901b53e3 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -820,6 +820,12 @@ static int uas_slave_alloc(struct scsi_device *sdev)
>  	struct uas_dev_info *devinfo =
>  		(struct uas_dev_info *)sdev->host->hostdata;
> 
> +	/*
> +	 * Some USB storage devices reset if the IO hints VPD page is queried.
> +	 * Hence skip that VPD page.
> +	 */
> +	sdev->sdev_bflags |= BLIST_SKIP_IO_HINTS;
> +
>  	sdev->hostdata = devinfo;
>  	return 0;
>  }
> 
