Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 3274B1822DD
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2024 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.131.102.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718215741; cv=none; b=tnqhWsWn60VC/BOFv9PEfmfHbHNfzQ1HOm8E72pE13lIxvpAR8tBO7XZ+sEFMk1aMcSuDeXpBOPT58l3b+F1gHxqfFzOgxg+7c4mwoXP8JHO216lnlGvSYBaVXUINCGA6mJ+zdUcIFDxAAGQ3bcSDYLut1PaH5NXKFRi0RT/iy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718215741; c=relaxed/simple;
	bh=kJwyERfwNOZD+GZqO0LbVnEX+kZVoxa44FxB3xy8SFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UN3ovY6gt63n9+uv53oKbCy8xz/N25OpK2k7ciggR6aW/iFO6eW2xRg0Pcpyq9hLDGuVQ7Ki1WoY324OGNVKHOA28Ph0jtAtT1Q181AvYA8m5cAif9bGIU92Zm6dbjr4DnHhsTgnzDO8WWyHISN77H0xoEgOpsKBeWNWCqev32I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu; spf=pass smtp.mailfrom=netrider.rowland.org; arc=none smtp.client-ip=192.131.102.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrider.rowland.org
Received: (qmail 232593 invoked by uid 1000); 12 Jun 2024 14:08:50 -0400
Date: Wed, 12 Jun 2024 14:08:50 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
  Joao Machado <jocrismachado@gmail.com>,
  Andy Shevchenko <andy.shevchenko@gmail.com>,
  Christian Heusel <christian@heusel.eu>, stable@vger.kernel.org,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] scsi: core: Do not query IO hints for USB devices
Message-ID: <de4492b5-a681-42bf-99d7-e9ba30dabeb2@rowland.harvard.edu>
References: <20240612165249.2671204-1-bvanassche@acm.org>
 <20240612165249.2671204-3-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612165249.2671204-3-bvanassche@acm.org>

On Wed, Jun 12, 2024 at 09:52:49AM -0700, Bart Van Assche wrote:
> Recently it was reported that the following USB storage devices are unusable
> with Linux kernel 6.9:
> * Kingston DataTraveler G2
> * Garmin FR35
> 
> This is because attempting to read the IO hint VPD page causes these devices
> to reset. Hence do not read the IO hint VPD page from USB storage devices.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: linux-usb@vger.kernel.org
> Cc: Joao Machado <jocrismachado@gmail.com>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Christian Heusel <christian@heusel.eu>
> Cc: stable@vger.kernel.org
> Fixes: 4f53138fffc2 ("scsi: sd: Translate data lifetime information")
> Reported-by: Joao Machado <jocrismachado@gmail.com>
> Closes: https://lore.kernel.org/linux-scsi/20240130214911.1863909-1-bvanassche@acm.org/T/#mf4e3410d8f210454d7e4c3d1fb5c0f41e651b85f
> Tested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Bisected-by: Christian Heusel <christian@heusel.eu>
> Reported-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Closes: https://lore.kernel.org/linux-scsi/CACLx9VdpUanftfPo2jVAqXdcWe8Y43MsDeZmMPooTzVaVJAh2w@mail.gmail.com/
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/usb/storage/scsiglue.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index b31464740f6c..9a7185c68872 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -79,6 +79,8 @@ static int slave_alloc (struct scsi_device *sdev)
>  	if (us->protocol == USB_PR_BULK && us->max_lun > 0)
>  		sdev->sdev_bflags |= BLIST_FORCELUN;
>  
> +	sdev->sdev_bflags |= BLIST_SKIP_IO_HINTS;
> +
>  	return 0;
>  }

You might want to do the same thing in uas.c.  I don't know if UAS 
devices suffer from the same problem, but it wouldn't be surprising if 
they do.

Alan Stern
