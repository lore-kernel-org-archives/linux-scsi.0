Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DBCEC4;
	Fri,  2 May 2025 07:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746169380; cv=none; b=CGzLgRjP7kldFaYv8Ften4pILywIWsqz1oooRYkhpbKL8Y1fie/5tda96jWgs8WN/ZfefgTzJpUcXUfcF80gvkVtWeXKOx3QwX1Bct7PopsQSRS5fd8khba8vvJAz+w97/fPrqnjOb1YcGG9+J6p6uJy7fSrxG4dhJ5it+V2/8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746169380; c=relaxed/simple;
	bh=imq2Al4rJh9ulHm/zPY/w2S9+0BvBdWhHs5zM/0Klik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L94cWsIobjjD2+YnY4+ka2o5CaZHQUi1yiJqX07V2fGATOObKYM7+/0DiXJFsH9XwRuJWUnShJjyDt3ysxski0W6qWQMeyasiqBjjxu6+9spYhI7DGXG2JI4SZjOZe9XSwKffHnqPBmwvu2KbYy02S6QvK1y2L8f8Su7Wx1aRvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1P8mEo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1P8mEo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB224C4CEE4;
	Fri,  2 May 2025 07:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746169380;
	bh=imq2Al4rJh9ulHm/zPY/w2S9+0BvBdWhHs5zM/0Klik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o1P8mEo9sseKF/ocFZoKXCtI6pbHoRRiap+qnfhjBiMUUGzzXBnWs4P/3mtTfymQv
	 IA1AsW7D/AYNvxBQ3IMOjxyytuARUzALB391EDKilw7U9cwJUrbV+oJZOfUO7bUpC3
	 yZXtYoc3p7tw3RZfA+nXH3jbrZqHjLR+JRhrXRu4=
Date: Fri, 2 May 2025 09:02:57 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/7] usb-storage: reject probe of device one non-DMA HCDs
 when using highmem
Message-ID: <2025050258-afraid-outweigh-e36c@gregkh>
References: <20250502064930.2981820-1-hch@lst.de>
 <20250502064930.2981820-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502064930.2981820-5-hch@lst.de>

On Fri, May 02, 2025 at 07:49:21AM +0100, Christoph Hellwig wrote:
> usb-storage is the last user of the block layer bounce buffering now,
> and only uses it for HCDs that do not support DMA on highmem configs.
> 
> Remove this support and fail the probe so that the block layer bounce
> buffering can go away.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/usb/storage/usb.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index d36f3b6992bb..49bbfe4610d5 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -1057,12 +1057,15 @@ int usb_stor_probe1(struct us_data **pus,
>  
>  	/*
>  	 * Some USB host controllers can't do DMA; they have to use PIO.
> -	 * For such controllers we need to make sure the block layer sets
> -	 * up bounce buffers in addressable memory.
> +	 * We can't support these controllers on highmem systems as the
> +	 * usb-storage code lacks the code to kmap or bounce buffer.
>  	 */
> -	if (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
> -	    bus_to_hcd(us->pusb_dev->bus)->localmem_pool)
> -		host->no_highmem = true;
> +	if (IS_ENABLED(CONFIG_HIGHMEM) &&
> +	    (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
> +	     bus_to_hcd(us->pusb_dev->bus)->localmem_pool)) {
> +		dev_warn(&intf->dev, "USB Mass Storage device not support on this HCD\n");
> +		goto release;
> +	}
>  
>  	/* Get the unusual_devs entries and the descriptors */
>  	result = get_device_info(us, id, unusual_dev);
> @@ -1081,6 +1084,7 @@ int usb_stor_probe1(struct us_data **pus,
>  
>  BadDevice:
>  	usb_stor_dbg(us, "storage_probe() failed\n");
> +release:
>  	release_everything(us);
>  	return result;
>  }

Hopefully this pushes people to use UAS devices instead :)

Should be interesting to see the fall-out to see if there are actual
systems out there like this still.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
