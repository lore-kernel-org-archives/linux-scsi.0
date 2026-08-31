Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C1F4582E1;
	Mon, 31 Aug 2026 17:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195807; cv=none; b=cHVBG9QnwIseaLcik9S1fT4McVw1xEu/DauwJFGPtbdBRH/NmiglS7a8ECqW9+R7uT50W0DGB/EeudKVoGq1V5KjZ7+n72Fh2QwDMNuSopaxBSYI35Zda+QulCTPvBL3ZjlCf0W6PgYwnvJGFMn0l+Ha6/jzPrHK4ri2GfOr8ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195807; c=relaxed/simple;
	bh=N4a3IGBIgWo3xSn0pDfyojf4j06Ir+jekNevnk4j4c4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnfXanz9r+MDGayNg2S/aGm2gHJzqXiLc+q2cbrM+LjTT2AUHQXgTtYrUOZ5/tAbCYfjFyY3DRysE64dr6dOhgSHhpTqPRsRtuaQ7FQZTN7DQnu+jWlx4/WVviFR/gjkirHP+hj3vZQwWSFwQHSd64VF2LK9j/919C7M33XFkZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SwG6UrdK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SwG6UrdK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 88E971F000E9;
	Mon, 31 Aug 2026 17:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788195805;
	bh=h4hiZqyRUrpSjQM/JiE2djp6K/bUQsz3EWD+p8v8e7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SwG6UrdKob4QTNhmah1DrfLrAyZ0ytoZWjc+yrEr+eYqdxRuMTw5G8k4Wzcjwnk6g
	 mfUE36d9qsEcOTXYMbO2kU3oqUKxZXRnQQNJGPX9u4wB/6RBspo+yxvlcZkVlsk3+m
	 QxVVvWuZ6FBa/pIWs5coKdzX0For71BHIRyt2mCLL/15P1bJlMJS/3d5a7/PJCuz0E
	 B2MXT7umSWpWxr1WllTzM6HvDNzCxbOcP4YvKf6JXDXtmrydACFDFsMZrtiRYaVJFe
	 COPHnzBe4l3t6o3T47L71pwxksd7/z1no2ChRa8u+obN9a4rFkS/4iKkRCpwcXuR5u
	 MqftoPE/QJn0Q==
Date: Mon, 31 Aug 2026 10:03:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/6] common: factor out a _bdev_disk_name helper
Message-ID: <20260831170324.GZ839663@frogsfrogsfrogs>
References: <20260831064557.2577241-1-hch@lst.de>
 <20260831064557.2577241-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064557.2577241-3-hch@lst.de>

On Mon, Aug 31, 2026 at 09:45:46AM +0300, Christoph Hellwig wrote:
> This will be reused to look for the integrity subdirectory soon.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me, thanks for refactoring this!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/rc | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index 8add0eedf942..2fa7ddebd8fd 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5233,28 +5233,35 @@ _sysfs_dev()
>  	echo /sys/dev/block/$maj:$min
>  }
>  
> -# Get the sysfs queue path for a block device, handling partitions correctly.
> -_sysfs_queue_path()
> +#
> +# Get the name for the main disk block device given an arbitrary blockdevice
> +# /dev/ entry
> +#
> +_bdev_disk_name()
>  {
> -	local dev parent
> -	dev=$(_short_dev "$1")
> +	local dev=$(_short_dev "$1")
>  
>  	# For partitions, queue details are in the parent device's sysfs dir
>  	if [ -e "/sys/class/block/$dev/partition" ]; then
> -		parent=$(basename "$(readlink -f /sys/class/block/$dev/..)")
> -	else
> -		parent="$dev"
> +		dev=$(basename "$(readlink -f /sys/class/block/$dev/..)")
>  	fi
>  
> -	local queue_path="/sys/block/$parent/queue"
> +	echo "$dev"
> +}
> +
> +# Get the sysfs queue path for a block device, handling partitions correctly.
> +_sysfs_queue_path()
> +{
> +	local disk=$(_bdev_disk_name "$1")
> +	local queue_path="/sys/block/$disk/queue"
>  
>  	# Verify the path exists before returning
>  	if [ -e "$queue_path" ]; then
>  		echo "$queue_path"
>  		return 0
> -	else
> -		return 1
>  	fi
> +
> +	return 1
>  }
>  
>  # Get the minimum block size of a file.  Usually this is the
> -- 
> 2.53.0
> 
> 
