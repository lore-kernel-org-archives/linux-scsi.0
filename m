Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C408DC2C9;
	Tue, 19 Nov 2024 02:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731983024; cv=none; b=r9rZ2RWdvwTePgJa8eNoFM5wy9bep8BGOEbr+LMqEQU1+X/beX8j9NbFKW+DQqDMlk2Ii5p8Pflu7g8o6L2uVSBX34i/NU24oCgFA9uY0HQH4yCBvPUJUNjY/XgLSzP8QCvVVejOHzkKDPEEiQ4IHZTl/FoC2s+Ws1TxLxukkso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731983024; c=relaxed/simple;
	bh=gZMKghzDPgq8UUwsDt/un6wcLkrHziFKZRpYTBi5OPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Eehh0+9aZ01/V16VOIN5vKxyuCX7CdUYkdpfuiymW0Q2lrjwDilftG9hVcxjPLA4Qb6saownR9qWGXK4afC6soOpYh81KDqHsPKeuyuvrYG2dTi+1Zgo1PiKXsPbHI7Os60eqiDLszy1Ts3OWMYTPf1sFPqiNmNw6RlR2hr2f3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ck9IHnxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ck9IHnxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCC1C4CECC;
	Tue, 19 Nov 2024 02:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731983024;
	bh=gZMKghzDPgq8UUwsDt/un6wcLkrHziFKZRpYTBi5OPg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ck9IHnxf/IpGj+Cj4bp43EMit9IwLva60sT4Dr3fFkTS79VolkkEw22sCeFBT3JhY
	 KLSoYwiXelUSTxMMeBuU31cPcsSDcaZn1tfb+gh+6c+7ZH3iXJnPyKsVA5/GgyVDW5
	 UV+DXwsAdbc06/jHHrl7MG8hWHYTRRNSdV/NVGz01S4OHeBQOUQn3oE73XUGvE7M1Q
	 1rKrk37EjFg5GohOTVHhvN2WKUTv6utS/vHglsAD5VYZnJiFk53NWR7GSOEYCxvgcl
	 p8HbAEv/CuvdxuCdc2vJCXfjjxQsNILDt6+jF6giHd0mjJocx48TlZgq7GhE5GR/T6
	 +hYKiAnvko1Ow==
Message-ID: <67d3ec9a-8efd-41c6-8c35-1ba5631c2c9a@kernel.org>
Date: Tue, 19 Nov 2024 11:23:38 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 01/26] blk-zoned: Fix a reference count leak
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20241119002815.600608-1-bvanassche@acm.org>
 <20241119002815.600608-2-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20241119002815.600608-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/19/24 9:27 AM, Bart Van Assche wrote:
> Fix a reference count leak in disk_zone_wplug_handle_error()
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  block/blk-zoned.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 70211751df16..3346b8c53605 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -1337,6 +1337,8 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
>  
>  unlock:
>  	spin_unlock_irqrestore(&zwplug->lock, flags);
> +
> +	disk_put_zone_wplug(zwplug);

The zone wplug put call is right after the single call site to
disk_zone_wplug_handle_error(). The reason it is *not* in that function is that
the reference on the wplug for handling an error is taken when the wplug is
added to the error list. disk_zone_wplug_handle_error() does not itself take a
reference on the wplug.

So how did you come up with this ? What workload/operation did you run to find
an issue ?

>  }
>  
>  static void disk_zone_wplugs_work(struct work_struct *work)


-- 
Damien Le Moal
Western Digital Research
