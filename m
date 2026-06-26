Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A3C3C0607
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 21:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782510888; cv=none; b=TwojrgC27ScWqKKq4OArr/QXkARzEQc+tuC+GqgwEscyzEVvbLQae9UGJjQ4RrC3KOWhh3TJAlqngQiNZJWYeRFdxMCGTs0hpcVRkfiU6orfFcy2QnUb3J7Efwgmwj7Bu+d+ZJkkVD1Aao7aUDxqHCTQsPFofpjDFKhJEQsQK6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782510888; c=relaxed/simple;
	bh=ZSdJCE65/lIgnK3M3RQ5KU1c+emxnvBHB9Y+a7G5XQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Chm+NakLiRNE5XXs7WClRL61H0wQVjLqpWBSVpYjgFkt5SQ7+wPZRrf9IkjRUhuIGmIQu5NVmgfyXWuyNyVmVDP92EbJhhpmdkujYPlCKHP53K4WCE7hvKfc466cwNN5dp1QAXTARlL2TACasw5INp4B4kpsowa9dN90M2z+VVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H2RrB684; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H2RrB684"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DFB1F000E9;
	Fri, 26 Jun 2026 21:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782510886;
	bh=n6dsK8tH8d6oALzidnn847Xz08tE83w41VxDaAbhwAs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H2RrB684IhyMURT70PvuXOcJEtqK9oqGAJhwbKbHDbu8LEF5UZ7uUhT6ftGjT9dja
	 auq7Fqf+cNR5UCwWksvgUhf5o5OYv/2VETd/w6+4uS9dch1Dac+i+4dee6RcLwQ4Iy
	 Zbcev4coNp+c7HPkgAZLLuhjItkpSNWrjTeahHETSODBwBvLl/Wjaba36oi3N3qlQR
	 4eYBslUEAkvJirCUTdEK/KcntvKw/zOXKGPEbxKczJNbRXnJjcMCB6miXk1dov/8h/
	 q4uxTcJL3nLU0BdL7X9DdfNR2czbmaUZoDWHU1U+v6Ayp6SGp6G5igZNDAO864FiZo
	 gGx+MX99Jwefg==
Message-ID: <00c16485-fc4b-43bd-a420-89b3b5eebaeb@kernel.org>
Date: Sat, 27 Jun 2026 06:54:44 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] scsi: sd: unify sd_probe() error cleanup through
 out_put
To: Yang Xiuwei <yangxiuwei@kylinos.cn>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com
Cc: hare@suse.de, tom.leiming@gmail.com, p.raghav@samsung.com,
 sw.prabhu6@gmail.com, linux-scsi@vger.kernel.org
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
 <20260623100159.4018066-3-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260623100159.4018066-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/23/26 19:01, Yang Xiuwei wrote:
> After put_device() or device_unregister() has released sdkp through
> scsi_disk_release(), set sdkp to NULL and fall through to out_put so
> put_disk() and kfree() are handled in one place.
> 
> Suggested-by: Ming Lei <tom.leiming@gmail.com>
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> ---
>  drivers/scsi/sd.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d18693d390b2..b096ea237f14 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4060,8 +4060,8 @@ static int sd_probe(struct scsi_device *sdp)
>  	error = device_add(&sdkp->disk_dev);
>  	if (error) {
>  		put_device(&sdkp->disk_dev);
> -		put_disk(gd);
> -		goto out;
> +		sdkp = NULL;
> +		goto out_put;
>  	}
>  
>  	dev_set_drvdata(dev, sdkp);
> @@ -4090,8 +4090,8 @@ static int sd_probe(struct scsi_device *sdp)
>  		if (sd_large_pool_create()) {
>  			error = -ENOMEM;
>  			device_unregister(&sdkp->disk_dev);
> -			put_disk(gd);
> -			goto out;
> +			sdkp = NULL;
> +			goto out_put;

device_unregister() is called here and in the next error path too. So what about
a "goto out_unregister;" to avoid repeating this pattern ?

>  		}
>  	}
>  
> @@ -4109,11 +4109,11 @@ static int sd_probe(struct scsi_device *sdp)
>  
>  	error = device_add_disk(dev, gd, NULL);
>  	if (error) {
> -		device_unregister(&sdkp->disk_dev);
> -		put_disk(gd);
>  		if (sdp->sector_size > PAGE_SIZE)
>  			sd_large_pool_destroy();
> -		goto out;
> +		device_unregister(&sdkp->disk_dev);
> +		sdkp = NULL;
> +		goto out_put;
>  	}
>  
>  	if (sdkp->security) {


-- 
Damien Le Moal
Western Digital Research
