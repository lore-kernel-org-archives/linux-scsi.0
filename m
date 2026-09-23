Received: from mta1.migadu.com (out-120.mta1.migadu.com [95.215.58.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEC4443C3F
	for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790149027; cv=none; b=nv7DjTWne5W5krFqyHFRsOkQsZBSMmt9sRoRXrW5P5Wm4uZEYjwlxLq46niwkYbqE53rr2Oi/f1KP4Q+geAD0K6HG26yijg7V99GcLh047/MEtOrHQShCwEcBtJZ2Unbt61af5aMDV2EZItWUf5pU3jSaF3BXEI3ciTZDrheYvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790149027; c=relaxed/simple;
	bh=cRLJqWAEQ/P/QXmiB5vPJntgH6//je6mB8ECd9bVsH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ynmr5EaLuOz+l58/eeM0zTO7cFWqm+xFHbZcfhQsS/ujjFVTPhp/MhyJVi2Y/78EeeBTK25rHphSdzZib0NLglw9OSKiv2h02/ahub08TlZSf5rpm5g6RTzNdkttqutBM89d3qaXCebONNtDqVvi4U1/p+EbxeIdK8AKtN6hQX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ogLAjtis; arc=none smtp.client-ip=95.215.58.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ogLAjtis"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cRLJqWAEQ/P/QXmiB5vPJntgH6//je6mB8ECd9bVsH0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790149022; v=1; x=1790753822;
 b=ogLAjtisp0aTEUkvyj2pPC+xHfPknsVZbqI6ip2hhqjdmBi+DfP2q4DnnCdEBM5wwJ+8ItSz
 teOXBUR9Qz5wOQDmTW6UPnqJedjfzyIxhfp9MoqoPRKg0+HGRbNt8q3Nr2mXx5wsSVfNN+qGZXu
 k0NFknIEKvDE1kiRmcvQBMoo=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 4a19d38fe2efdfaf;
	Wed, 23 Sep 2026 07:37:02 +0000
X-Mizu-Trace-ID: 4a19d38fe2efdfaf
X-Migadu-Flow: FLOW_OUT
Message-ID: <41890e94-10da-4b99-af6d-35106b88f026@linux.dev>
Date: Wed, 23 Sep 2026 08:37:01 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] scsi: scsi_debug: Fix a locking bug in
 resp_write_same()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <cover.1790119506.git.bvanassche@acm.org>
 <295c14b6d2d011597284f09f7a3de42a49e08863.1790119506.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <295c14b6d2d011597284f09f7a3de42a49e08863.1790119506.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/26 00:26, Bart Van Assche wrote:
> If fetch_to_dev_buffer() fails in resp_write_same(), the function jumps
> to 'out' without releasing the data write lock acquired earlier via
> sdeb_data_write_lock(). Jump to 'unlock' instead so that
> sdeb_data_write_unlock() is called on the error path. This bug has been
> discovered by building the scsi_debug driver with Clang and modified
> lock context annotations. The modified lock context annotations are
> available in patch "scsi: scsi_debug: Improve lock context annotations".
> 
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_debug.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 6941809dfdb7..b854102e6caa 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5402,7 +5402,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>   
>   	if (-1 == ret) {
>   		ret = DID_ERROR << 16;
> -		goto out;
> +		goto unlock;

at @unlock we lose the error code in ret - is that intentional?

>   	} else if (sdebug_verbose && !ndob && (ret < lb_size))
>   		sdev_printk(KERN_INFO, scp->device,
>   			    "%s: %s: lb size=%u, IO sent=%d bytes\n",
> @@ -5419,6 +5419,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>   	/* If ZBC zone then bump its write pointer */
>   	if (sdebug_dev_is_zoned(devip))
>   		zbc_inc_wp(devip, lba, num);
> +unlock:
>   	sdeb_data_write_unlock(sip);
>   	ret = 0;
>   out:

