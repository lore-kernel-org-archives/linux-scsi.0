Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A2D30F533;
	Fri, 21 Aug 2026 23:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787354950; cv=none; b=NsaSPH6rWlM/kmTeDiYQzNH9Meg+rwZ6wOFa02knP/x8qdBa/hloFAvetnQZiuJKu3WUShGNvN0JL3fOlNtRgvhigEVYUIfP399wo9eoSDupWqNOBiet3bjKPzSSMAOg7hqYSVGDpOcpeFSaEXoq8ZnPY1HseF0VGlIQ/WCAu34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787354950; c=relaxed/simple;
	bh=ZZFD7l2+9lS33vHjglqXnS6Sh8Xq4Gf37C5BphsOAXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PlcXPZGbN95qt33lWLnrwlcEViP2VLUVhGuOTUrvdMj6fbRYPn+hjVwfJtJ/kBppaVBXbFr+aVYs29P9kiS2lJ//0/NMnk3zeOZLBiRjkkY8W+euAhJJELFn2q+2qz9EMdoZkVYya7DtVygX0bEVvPpqwz1Mu02J8Vx/1f6ZyXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YaCyIJzW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YaCyIJzW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1A4321F000E9;
	Fri, 21 Aug 2026 23:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787354949;
	bh=uk+Rmzv5gBv8VWdlpVfDgYW9q/M/e2xLHfE+7/xMLTY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YaCyIJzWcg8yVMuOFbR4JefFv4/B/f5XDk4o5mOyTBhcoS4OgRbGYlDG01CFzXaQP
	 G2Jo+nQCbvkjkW41lpyAH9E1AKjB113RuONMFU87UQROAUBWge2xZSfnU+kIVgQGQX
	 U8u7mjrTStHFRQ2K2imf7MVkDKHWazRWszcybCVrw6o4aWtaX6/zFGmXsoCvNvZulo
	 yIrvnlwaTO/47JPf2HtbVYewyv8boT/wOs9OnvvRIde5QzS8b2dQg7KfD4QZDoSU9M
	 /Na8R0+He14Kyy8/Eusp2UIz3/cjysWj2PoRoqsF5NX34zDGzms8EeRv964LPJWRRC
	 LzSFQdlAYrpww==
Date: Fri, 21 Aug 2026 16:29:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/5] common: add a _sysfs_block_integrity_path helper
Message-ID: <20260821232908.GE839663@frogsfrogsfrogs>
References: <20260821051133.1817670-1-hch@lst.de>
 <20260821051133.1817670-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821051133.1817670-3-hch@lst.de>

On Fri, Aug 21, 2026 at 07:11:27AM +0200, Christoph Hellwig wrote:
> Add a helper function to find the sysfs integrity directory for a given
> block device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/rc | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 02bdb31a76a6..61a899da3bd7 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5257,6 +5257,31 @@ _sysfs_queue_path()
>  	fi
>  }
>  
> +# Get the sysfs block device integrity/ path for a block device, handling
> +# partitions correctly.
> +_sysfs_block_integrity_path()
> +{
> +	local dev parent
> +	dev=$(_short_dev "$1")
> +
> +	# For partitions, integrity details are in the parent device's sysfs dir
> +	if [ -e "/sys/class/block/$dev/partition" ]; then
> +		parent=$(basename "$(readlink -f /sys/class/block/$dev/..)")
> +	else
> +		parent="$dev"
> +	fi

I wonder if this part should get pulled out into a _sysfs_block_path
helper, since the code is already in _sysfs_queue_path?

--D

> +
> +	local integrity_path="/sys/block/$parent/integrity"
> +
> +	# Verify the path exists before returning
> +	if [ -e "$integrity_path" ]; then
> +		echo "$integrity_path"
> +		return 0
> +	fi
> +
> +	return 1
> +}
> +
>  # Get the minimum block size of a file.  Usually this is the
>  # minimum fs block size, but some filesystems (ocfs2) do block
>  # mappings in larger units.
> -- 
> 2.53.0
> 
> 
