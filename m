Received: from mta0.migadu.com (out-49.mta0.migadu.com [91.218.175.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9DA175A8D
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 08:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790325797; cv=none; b=NRdjdX6256LLZcREiDe5aK+oy7vqOW6F/XAiaCz/JErL2ixmc9w1c+UKZz0yX/80JgRRvrqxdwGxRjRNsmxOCD21oVt/36aqo0lNdvSLQD/Qx8XmW0cc5/QRhQsX52yYInw57E1oqiwXs4dQBjVF56bwG+pmz5Vk9o3XY55FJkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790325797; c=relaxed/simple;
	bh=TSOQxF9UIavGfuqUy8Jyvf965KY+HewDjGXmb6+U/ow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GSEqC1KzZ8kpu+50BYrfXw4Pm0wnuxlgOP0U5QRTbdsNw9L9k+Krmj6gDINGuR2KDmjQg3KXLMFnJhc2r7Ff6+DM54igBtYrdnD40L/nqJmqZ7zsE7P4/7VdBkYOaUNIzyoKJizuFSuIJ2UyXu5cWexgfoZb43b7gfGnQmqwYjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N6HNgqaP; arc=none smtp.client-ip=91.218.175.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N6HNgqaP"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=TSOQxF9UIavGfuqUy8Jyvf965KY+HewDjGXmb6+U/ow=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790325793; v=1; x=1790930593;
 b=N6HNgqaPoTfecJaRfGjFQmiT3DpK+fps1T0F7l7YjcsaCcFufvm7JX2ukdyDN5LDeH017Chd
 ON3kmyQRa0NDvtlMgIRLDRn2JReFcn+H87IubRVyDIJuHwPCTjJ223e0amAH9epAYJf5gqw1ba2
 x7djmj+Zjm21FOsa4iSlI0WU=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id d68f26c7aaeb57fb;
	Fri, 25 Sep 2026 08:43:13 +0000
X-Mizu-Trace-ID: d68f26c7aaeb57fb
X-Migadu-Flow: FLOW_OUT
Message-ID: <b6ba9c00-e3c5-4534-be92-dd2d5ceb9cf4@linux.dev>
Date: Fri, 25 Sep 2026 09:43:12 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] scsi: scsi_debug: Fix a locking bug in
 resp_write_same()
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 Christoph Hellwig <hch@lst.de>
References: <cover.1790290089.git.bvanassche@acm.org>
 <f3cedcaf09495936f46898a4242cd83da9145989.1790290090.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <f3cedcaf09495936f46898a4242cd83da9145989.1790290090.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/26 23:54, Bart Van Assche wrote:
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

Reviewed-by: John Garry <john.garry@linux.dev>

> ---
>   drivers/scsi/scsi_debug.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 6941809dfdb7..ed8d69f305f8 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5402,7 +5402,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>   
>   	if (-1 == ret) {
>   		ret = DID_ERROR << 16;
> -		goto out;
> +		goto unlock;
>   	} else if (sdebug_verbose && !ndob && (ret < lb_size))
>   		sdev_printk(KERN_INFO, scp->device,
>   			    "%s: %s: lb size=%u, IO sent=%d bytes\n",
> @@ -5419,8 +5419,9 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
>   	/* If ZBC zone then bump its write pointer */
>   	if (sdebug_dev_is_zoned(devip))
>   		zbc_inc_wp(devip, lba, num);
> -	sdeb_data_write_unlock(sip);
>   	ret = 0;
> +unlock:
> +	sdeb_data_write_unlock(sip);
>   out:
>   	if (meta_data_locked)
>   		sdeb_meta_write_unlock(sip);

