Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913BC340A6F;
	Sun, 13 Sep 2026 12:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789302225; cv=none; b=ijvXAizCPLYhfUb5MAFx+9gvP3uyvpHFzptYGXeorI+/bwmAtkcSzjIl+ej2a8SmmFHlnVIxL4v4wwLX/KUC3TOILPjROiMxrGpPALYOvB+wBS42yUeF2Z7jx+wsmRJCakZ7ys/s4JY3J4M1BdmnP+HTnvh6zI0Rs4QgAuwTQPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789302225; c=relaxed/simple;
	bh=IUsTkp6R/lIDoLolOR9bw/dplukHMn4IZHpCV5ypD0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u8f/akbd5PJ9VDhqQAyZC9Bd2U8aDfNyjBYQjnnuuD/MYtGolmVl8WI2jGzMlAu1NYaeuSpq4O0sdZq6QRPCUzl9K5NFqCmt1injCszP95kCpt+4hs24YofvPE+SZu9IftNgAhvOlt3ZB1DyVE0D03rGspvbWBF7qOck5bq68/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CFqv15Nb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CFqv15Nb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E131F000FF;
	Sun, 13 Sep 2026 12:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789302224;
	bh=q3iW2d+dNDfH8/204Oq28laQUREzLslBtoZT6sWn1G0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CFqv15Nb0ybB1W8rMJiwnFpQHjsvsZ3T6q6pjwD15IpZkdOtlnEpS3yvgTMuUqyj1
	 ojtPwfRt7BF7TYGFUlt/JRuSJ2quE7BLQuLWJwt8dCSq41WzyaO9YU6OIpcw4egaBM
	 jvllP+vU17rzqgFNUp/RgAkwX+Kp+mf/26ydHp4WhGwkDigBi0JatLWyM9LwXM2VzI
	 FyxN7I8Lq9nPFNUX92tELKwDT3qNlPMHp6c2vQgON+Ki9g890CvC7srV1AuZj2vaaP
	 SywimIsmSi4rgWMLkYD9w7cpNiPV8LUKffCv1M9/Om6aeAUFMGhEiMViYhJxSSfSmE
	 TPb66LtsQINGA==
Date: Sun, 13 Sep 2026 20:23:35 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, John Garry <john.g.garry@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/6] common/scsi_debug: don't slow down I/O
Message-ID: <aqaVf-R3D9KhxCYG@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, John Garry <john.g.garry@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
References: <20260911070831.1760646-1-hch@lst.de>
 <20260911070831.1760646-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911070831.1760646-2-hch@lst.de>

On Fri, Sep 11, 2026 at 09:08:19AM +0200, Christoph Hellwig wrote:
> scsi_debug by defaults delays I/O and doesn't support multi-page I/O.
> Flipping these defaults speed up each test using scsi_debug by more than
> an order of magnitute on my test systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/scsi_debug | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/common/scsi_debug b/common/scsi_debug
> index c3fe7be623fa..af51905dc4ba 100644
> --- a/common/scsi_debug
> +++ b/common/scsi_debug
> @@ -59,9 +59,19 @@ _get_scsi_debug_dev()
>  		let physical=physical/2
>  		let phys_exp=phys_exp+1
>  	done
> -	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size $@"
> -	echo "scsi_debug options $opts" >> $seqres.full
> -	modprobe scsi_debug $opts
> +
> +	local opts=(
> +		"sector_size=$logical"
> +		"physblk_exp=$phys_exp"
> +		"lowest_aligned=$unaligned"
> +		"dev_size_mb=$size"
> +		"delay=0"
> +		"clustering=1"
> +	)
> +	opts+=("$@")
> +
> +	echo "scsi_debug options ${opts[*]}" >> $seqres.full
> +	modprobe scsi_debug "${opts[@]}"

Thanks Christoph, this version is good to me now.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
>  	$UDEV_SETTLE_PROG
>  	device=`grep -wl scsi_debug /sys/block/sd*/device/model | awk -F / '{print $4}'`
> -- 
> 2.53.0
> 
