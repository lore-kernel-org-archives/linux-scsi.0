Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4944620E03C;
	Mon,  3 Mar 2025 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741011162; cv=none; b=P3/QSHMzWL9DBYtWgwsza74Rf2DqHFFdRHlPDBrlBrnN/nl5RxQrAPmTbrp1h4/niCKnibBwljMMjdy5uu9HHT+IPdWSpN6PR6Xh94nOsjSJ1BPL1gUeqMxJBaRp4NXxxPg6RBHXp9kn6Tqb9FFs0PrPE3VsFlYVb28cmU1IDR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741011162; c=relaxed/simple;
	bh=qQNrRd43JGK5k8mEPTU990AE8TuK5KRKLOf8ppbTrwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+fEmfjmk0wY95OSIrYkCtUk6m72xe6w2W0atOdQFHw0njXcN6dAJjhrEpej3CrUI5zDbsbYAgr+PIHeR4hB3EcaDFXdpdF6ex2uRFDNGws0MH1bwtmJAUfzQhDZzVddMYTCPVk8V10L3+WwV52GVyIRdlj2d660SXfxCvNURjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C891568CFE; Mon,  3 Mar 2025 15:12:36 +0100 (CET)
Date: Mon, 3 Mar 2025 15:12:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
	anuj1072538@gmail.com, nikh1092@linux.ibm.com,
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev,
	M Nikhil <nikhilm@linux.ibm.com>
Subject: Re: [PATCH v2 1/2] block: ensure correct integrity capability
 propagation in stacked devices
Message-ID: <20250303141236.GB16268@lst.de>
References: <20250226112035.2571-1-anuj20.g@samsung.com> <CGME20250226112857epcas5p1654e62b5fff4551926622f19269c6ff4@epcas5p1.samsung.com> <20250226112035.2571-2-anuj20.g@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226112035.2571-2-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 26, 2025 at 04:50:34PM +0530, Anuj Gupta wrote:
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index c44dadc35e1e..8bd0d0f1479c 100644
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

As mentioned last round this still does the wrong thing if the first
device(s) is/are not PI-capable but the next one(s) is/are.  Please
look into the pseudocode I posted in reply to the previous iteration
on how to fix it.

