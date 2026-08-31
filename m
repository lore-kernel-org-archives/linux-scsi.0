Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4AA45C6E9;
	Mon, 31 Aug 2026 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788195819; cv=none; b=OzjcyhqWCXUbw0ODhEMBLAH0dam2rU1NLoDOc0esjOAjuMkSFuRe8mBNuOPVFXOocoPNK17zpZcQqdQxqXU94pQJj8/UtUdi+97J2FNjo3DbtDhcA4bdGSmYGQbDf+YoMHw7ob5+LvssyRI2+sv0/xZJ5d3gyHRxyarT+5e17b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788195819; c=relaxed/simple;
	bh=WhXvhLvCYXq3gpn8etdGGnJ5D8EEDOOQI1Dk7+EMr0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uj/h93H1P9vtBPGbq/wisYos2dMAgqTWQAxGysudbJUreq1DHa2Alyb+FxrmAhlz2gX4mUMJ5JMOnJC6Ngv+qUlx+T2PXorOIVPLtAt6jwptORpB7zN3f3ThVh4cTZ7bjGqb/2/2EVwh5QQkstWA5cQ+ZSL3dD2xWGhKro9K4hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYT6a3qT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYT6a3qT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8F9741F000E9;
	Mon, 31 Aug 2026 17:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788195818;
	bh=ZUwdEUywFfqiyBmn4YTr1ijPkfwObC0/H5O3Qs1N5JU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eYT6a3qTc/nmx5xlFjv3jRY5i1vW7vo25LVdkfA6g9+cd01TzyfG9g6hPC/aARRSI
	 gmrIqD4uQ6UrY/+JXHVB7kTT3v8pDRlF+8XYm2rFzCaJgoC+Q8VkoQcCValO34reUP
	 YWEPVX2yL6THGaBuzmZ3pMbI6y+3p9OFcCWaP1gIA7AKzdvVdOcxGGC5IxMu6E6IFo
	 1dhQ6Elo6k1+qXfMkdAUm1plW41iLhA9FE1RvQsPX3MqLYfGyb5x/teWHz8n2H1Cnw
	 c9/SZljMAYN7y+l/FrRafXp/nB4WCBQOd8D34MsMVvaawZEspFZb3IkXNIAPy0R6Z2
	 74wwuC0QZFEeA==
Date: Mon, 31 Aug 2026 10:03:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/6] common: add a _sysfs_block_integrity_path helper
Message-ID: <20260831170338.GA839663@frogsfrogsfrogs>
References: <20260831064557.2577241-1-hch@lst.de>
 <20260831064557.2577241-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064557.2577241-4-hch@lst.de>

On Mon, Aug 31, 2026 at 09:45:47AM +0300, Christoph Hellwig wrote:
> Add a helper function to find the sysfs integrity directory for a given
> block device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  common/rc | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 2fa7ddebd8fd..5e709dd79993 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5264,6 +5264,21 @@ _sysfs_queue_path()
>  	return 1
>  }
>  
> +# Get the sysfs block device integrity/ path for a block device, handling
> +# partitions correctly.
> +_sysfs_block_integrity_path()
> +{
> +	local disk=$(_bdev_disk_name "$1")
> +	local integrity_path="/sys/block/$disk/integrity"
> +
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
