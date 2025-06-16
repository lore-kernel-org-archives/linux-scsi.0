Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD08289823;
	Mon, 16 Jun 2025 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750099864; cv=none; b=OtOyP84tZsVz5olDo/vrSHoZFefq2JjdcIOio2VCcCgjn45rxkXmLyCJemYNuYA+YAqdpd0JsnHnU4q4qfOUdruT9t+aDDBvfy8+DgwW0PpBeLX7onPBGhumEVnes9tEMO9wenKYXGBxehUnBpZH4XltP5RZhQuX7I538bCM/2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750099864; c=relaxed/simple;
	bh=8wghCO4r7fnvpFiM5aq9yvS0ZtWR6lPlpDQQigjf2co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e08n0C5kS/X1wzT6S2YkqqnX6ZTwziGsFJ4fXljZAWf3uKKVc1OdkL56OPgvS41+vxl5Z2WORISvy8blJHf8roHWsXnpLrVab2LPDcTOEqcPqmLZC3d987EAnzEb+hoJL2B3exc+ZCgy60Jb9T6Jcv7s1qKfRAAk6aZsKjP588k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vREtwtgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vREtwtgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6832C4CEEA;
	Mon, 16 Jun 2025 18:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750099864;
	bh=8wghCO4r7fnvpFiM5aq9yvS0ZtWR6lPlpDQQigjf2co=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vREtwtgHsAEPM516KcWzq1lxJXshLZ/RirxKwYrulWVFedQRGkR0WpakC4C7GHYog
	 PhT1BItS0JEdDPeO0YP83jUo7nQCm1VXb+ChqiHxrKXP/YAI60G5kBIBnRt6/phHGv
	 mHFIwqCxXK3/5qfTjeOjogEtQbq1Xf/pLRAVqygnBGzyDHjrxB1Q2a+JHhJlzPe47T
	 KMd4JtAmGfeFs40CbQF9yTy1srDhPCgClSC5sN6tG8ozkIKAUubANMohaTOxEQ0f3T
	 jF1wBH43U1x8EVYQe9B8HrL2z5pY0j+OBHNfx94b/p/UlpCexNbt1zjNUciSBAyw22
	 htFu0WcQNMaMg==
Date: Mon, 16 Jun 2025 18:51:02 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Laurence Oberman <loberman@redhat.com>, longli@microsoft.com
Subject: Re: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX
 explicitly
Message-ID: <aFBnlgBpPVT7Grnu@liuwe-devbox-ubuntu-v2.lamzopl0uupeniq2etz1fddiyg.xx.internal.cloudapp.net>
References: <20250616160509.52491-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616160509.52491-1-ming.lei@redhat.com>

+Long for reviewing this patch.

On Tue, Jun 17, 2025 at 12:05:09AM +0800, Ming Lei wrote:
> Set max_segment_size as UINT_MAX explicitly:
> 
> - storvrc uses virt_boundary to define `segment`
> 
> - strovrc does not define max_segment_size
> 

Typo here. It should be storvsc, not storvrc.

> So define max_segment_size as UINT_MAX, otherwise __blk_rq_map_sg() takes
> default 64K max segment size and splits one virtual segment into two parts,
> then breaks virt_boundary limit.
> 
> Before commit ec84ca4025c0 ("scsi: block: Remove now unused queue limits helpers"),
> max segment size is set as UINT_MAX in case that virt_boundary is
> defined.
> 
> Cc: "K. Y. Srinivasan" <kys@microsoft.com>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: Wei Liu <wei.liu@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Laurence Oberman <loberman@redhat.com>
> Fixes: ec84ca4025c0 ("scsi: block: Remove now unused queue limits helpers")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/storvsc_drv.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 2e6b2412d2c9..1e7ad85f4ba3 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1897,6 +1897,7 @@ static struct scsi_host_template scsi_driver = {
>  	.no_write_same =	1,
>  	.track_queue_depth =	1,
>  	.change_queue_depth =	storvsc_change_queue_depth,
> +	.max_segment_size   = 0xffffffff,
>  };
>  
>  enum {
> -- 
> 2.47.0
> 
