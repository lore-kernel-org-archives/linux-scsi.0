Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2FB3016F5;
	Sun, 13 Sep 2026 12:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789304119; cv=none; b=i7qIeVOu6M34gttO/i5ct8csMtGLj0vf8RgWNBg89HE4MbsLnhCv8ufgbfl8tGUGQckxIcyPXK/23X9itEweRRs15VpsMLi3U2y3nVfYlgfOYs0K6YQZH/EGFy1TaiklCNtkS+ASMbYspfmQPG1aY3E1EVrhZgDqK8o9mHr6dwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789304119; c=relaxed/simple;
	bh=HSJRb8JfSizoHWOHRKKd8rUhu6RlBApMJU9w0p8oBlQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SUlKbonQdFIZfiI6xU+jnNti4oC7WHuA5uyXd0IYqyLhlMHejSNomtqCb7Ry7mbapG4EKbybtQSAZtYzirXTAkgml70P2EWB3YZ6s92veNnm3g+vi5PLsOAezYSiEgyVIXIXjomcvayBM3ACXED5ksYyh8zQDqGRAgGWbJ6BLT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQOXF0BL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQOXF0BL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0F41F000FF;
	Sun, 13 Sep 2026 12:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789304117;
	bh=RIjU+VdGMHIaGTXB0kTIlm9CeG9FJvJChOCZHsDdMlQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQOXF0BLSZnGCaBix1IjDNLzebSbGmO3LtUHCKxY5t9iIIc5fkz20DpkpeZ1MsohI
	 DKFMmZBOwrkCIah7AAZZug3tLh8lGA3hTc/qvlr0SLsoZNZsXA5ooU+swEmaGKrDwa
	 VaVcc/xOuf4kmUmEhor27p9PP4HpCfRoe8L3EL3nhvrKkbR18+TuLQfARBhSWCDxK5
	 HmHYN5M2xF8HEHyoR50/fl0DfErk+sfKQ0rOp/fyqoOut1YJnfdnSV9WLnUCaV0QJv
	 1C3PFaAIbNuuvqz96WerzVRz/9gFJd1X8CxIJXlTvD2gD7OHhO3qXHwdCEbTknpk+e
	 vDgvJOyq2LUQg==
Date: Sun, 13 Sep 2026 20:55:10 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, John Garry <john.g.garry@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/6] common: factor out a _bdev_disk_name helper
Message-ID: <aqadFscVWs2U_mvr@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, John Garry <john.g.garry@oracle.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-scsi@vger.kernel.org
References: <20260911070831.1760646-1-hch@lst.de>
 <20260911070831.1760646-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911070831.1760646-3-hch@lst.de>

On Fri, Sep 11, 2026 at 09:08:20AM +0200, Christoph Hellwig wrote:
> This will be reused to look for the integrity subdirectory soon.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Good to me,

Reviewed-by: Zorro Lang <zlang@kernel.org>

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
