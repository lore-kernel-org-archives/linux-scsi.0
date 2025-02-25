Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514F721ABBD;
	Tue, 25 Feb 2025 15:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740496003; cv=none; b=U5jAgp5PUbiXI+juarkOX8wqybs5kzhjKoXMtyHFdFiaxhDLRO4Wj2ATfJw2+/z2GoEkBgbulwDXwlBbsWqnliolPrJfMV03LUlqu/LOO7HYz1aU8QnYTPgWsM3gIWp3xnwXKhBHBgM7egI+BwpeKsuSkCxbPaC0nRlD4R4jYBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740496003; c=relaxed/simple;
	bh=wxCjwY2IPeYFCaeJ3Ei+L8XPqFtp766dRGefmJ2mAF4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WzemHfdwn4Z/MZeEdGcDuizo0oyZUiZo9JCmSW5rZqwhhoJS/p4ELZN+xmcJxl/ij2qjUADb25LfNjNqj9w5g2EA+d92Iz0Y3moD0/RPYDUBx0qfgfZ8ayIBxCliTESLjNPn31K03qQk4g9bO6P4+CgDYYWspZOYU1k0AWaj3B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 15B3268D07; Tue, 25 Feb 2025 16:06:27 +0100 (CET)
Date: Tue, 25 Feb 2025 16:06:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
	martin.petersen@oracle.com, anuj1072538@gmail.com,
	nikh1092@linux.ibm.com, linux-nvme@lists.infradead.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	dm-devel@lists.linux.dev, M Nikhil <nikhilm@linux.ibm.com>
Subject: Re: [PATCH v1 1/3] block: Fix incorrect integrity sysfs reporting
 for DM devices
Message-ID: <20250225150626.GA6099@lst.de>
References: <20250225044653.6867-1-anuj20.g@samsung.com> <CGME20250225045514epcas5p10d06ab361a4125a94933fa8235fe3fa8@epcas5p1.samsung.com> <20250225044653.6867-2-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225044653.6867-2-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 25, 2025 at 10:16:51AM +0530, Anuj Gupta wrote:
> The integrity stacking logic in device-mapper currently does not
> explicitly mark the device with BLK_INTEGRITY_NOGENERATE and
> BLK_INTEGRITY_NOVERIFY when the underlying device(s) do not support
> integrity. This can lead to incorrect sysfs reporting of integrity
> attributes.
> 
> Additionally, queue_limits_stack_integrity() incorrectly sets
> BLK_INTEGRITY_DEVICE_CAPABLE for a DM device even when none of its
> underlying devices support integrity. This happens because the flag is
> blindly inherited from the first base device, even if it lacks integrity
> support.
> 
> This patch ensures:
> 1. BLK_INTEGRITY_NOGENERATE and BLK_INTEGRITY_NOVERIFY are set correctly:
>    - When the underlying device does not support integrity.
>    - When integrity stacking fails due to incompatible profiles.
> 2. device_is_integrity_capable is correctly propagated to reflect the
> actual capability of the stacked device.
> 
> Reported-by: M Nikhil <nikhilm@linux.ibm.com>
> Link: https://lore.kernel.org/linux-block/f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com/
> Fixes: c6e56cf6b2e7 ("block: move integrity information into queue_limits")
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  block/blk-settings.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index c44dadc35e1e..c32517c8bc2e 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -861,7 +861,8 @@ bool queue_limits_stack_integrity(struct queue_limits *t,
>  
>  	if (!ti->tuple_size) {
>  		/* inherit the settings from the first underlying device */
> -		if (!(ti->flags & BLK_INTEGRITY_STACKED)) {
> +		if (!(ti->flags & BLK_INTEGRITY_STACKED) &&
> +		    (bi->flags & BLK_INTEGRITY_DEVICE_CAPABLE)) {
>  			ti->flags = BLK_INTEGRITY_DEVICE_CAPABLE |
>  				(bi->flags & BLK_INTEGRITY_REF_TAG);
>  			ti->csum_type = bi->csum_type;

Hmm.  I wonder if this is the correct logic.  Basically we do not want to
allow mixing integrity capable and not integrity devices, do we?

So maybe the logic should be more something like:

	if (!IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY))
		return true;

	if (ti->flags & BLK_INTEGRITY_STACKED) {
		/* check blk_integrity compatibility */
	} else {
		ti->flags = BLK_INTEGRITY_STACKED;
		/* inherit blk_integrity, including the empty one  */
	}

