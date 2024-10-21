Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD541E1A3F
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 08:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729498463; cv=none; b=gThQZ+embfXVsiTLoJdURxnfWw2fPhigzQK+zEjMDMUQJOVv8+Cio63dLJanUKS/yvpRZZzNkxe0oIYgsP726laUG8vy3GkLCebvVyA0+s2TSG4jTRxcbqqPZbRnLJEN7H03wdcuRrL0S0CACnfM2Gr9g+XiogjTNC/rM2yE3ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729498463; c=relaxed/simple;
	bh=r7vc9o8GcQ/edGaJNboVLi6L7avdWTp6PsYJaMGNJfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NrTTFDxWWzCOHDV9JWt9/SLYJLKHNb97WDzJyVc7jPPr0sSIRXR3wuWwOYH1ZJI23nwomqc2GVP4zB/Qph/WSRh7dr/GWbqx5BVs0HIiztPo0aMLgFXK8M1WyYKhVy8rqaXFhRsjUGTV5Lr7Qa/u0x2Ah/G9RiVDlP2LUPuFuL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TVpxhbAx; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TVpxhbAx"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4315839a7c9so45932855e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2024 01:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729498460; x=1730103260; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FEIzpifPtQaPk+xKggPjrZs6VU2v7jUOekftpAhP/xU=;
        b=TVpxhbAxjh8FAw5UY7gP13DrMaU39HEQK5XTd3xfIQnZz5mBb+XdIRf4Neajftm1wB
         bFv2Px4GNO+Ypej+In71MtIY+BALtcvlvqKrx0ipQrpAb28hCvPtztkofHGQ+2kB/xsB
         jAzG73JCOoZT8rFjy0O7YGyqs6tPHDrasbsmbBwFQZ4glmhBfrmhlPR1ACTLu7Mp+Fgn
         QXThmjN0NLIqlGOiRRgyBDi2rkV9dcS+MwiSmZuTL8OEohd+h/t9IIX8IgLR6tM7nua9
         z0gepecOrgRmyfZt3k2H/gXPoVThDJ4BZiU1rGYRBRC+USuzRo98yU4CylUx25fW/CnZ
         Urjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729498460; x=1730103260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FEIzpifPtQaPk+xKggPjrZs6VU2v7jUOekftpAhP/xU=;
        b=FvQukfNNRcInRprfFfBTn7utHTcaRPhr/0e7kLaWPOC9GgINIhXdui+sVg50NCauQm
         Jk9md7NF4AbswSEkw3MAzrv9BnA7ALqdhq/IrUYbQ2NzxC9GCTX6cSIRGDo47lcoUDeQ
         7o4D9BOSav0sepfhnxNlG6zqIJ73jwHkJRsS4Bq7n4S+olQkCWCmaZdB6erUHmQzbtP2
         j7T4dH0HdKBAcjOzm6QQvGkDmVpq67z/5AJv5nOVS9yz/UBpdnaIh4kgsxVQOhMSVljP
         g9lmrUs9BAGyk4sTJ/6xjpxqmPqvMUyUjs+4qthIHTENGIlxXY540vCo3r5vhVckCj9C
         iz4w==
X-Gm-Message-State: AOJu0YzVkHDTTAg1UwARSdQ6yR+JY3no8NRzCuzx4MHfzZjFdTuwMLQL
	5LVGmBoJjWWPJcwGrmL/UNu4vyVEibo0f6+0u5k+S5XXiEkJMdAphxtzQQ==
X-Google-Smtp-Source: AGHT+IGPPSAiQ/rtOEHivMg8m07gMEeUg9XCSXlBoHibtMxEvgfYkNVrEaPyOP4auTdAa1KDivxZXA==
X-Received: by 2002:a05:600c:4f8b:b0:431:46fe:4cad with SMTP id 5b1f17b1804b1-4316163bbe0mr90402815e9.9.1729498459834;
        Mon, 21 Oct 2024 01:14:19 -0700 (PDT)
Received: from [192.168.1.248] ([194.120.133.34])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4316f57112esm49246785e9.6.2024.10.21.01.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 01:14:19 -0700 (PDT)
Message-ID: <0aee8643-dff7-4627-9a18-bd74c8b6f60e@gmail.com>
Date: Mon, 21 Oct 2024 09:14:17 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: Fix do_device_access() handling of
 unexpected SG copy length
To: John Garry <john.g.garry@oracle.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, dan.carpenter@linaro.org
References: <20241018101655.4207-1-john.g.garry@oracle.com>
Content-Language: en-US
From: "Colin King (gmail)" <colin.i.king@gmail.com>
In-Reply-To: <20241018101655.4207-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/10/2024 11:16, John Garry wrote:
> If the sg_copy_buffer() call returns less than sdebug_sector_size, then we
> drop out of the copy loop. However, we still report that we copied the
> full expected amount, which is not proper.
> 
> Fix by keeping a running total and return that value.
> 
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Reported-by: Colin Ian King <colin.i.king@gmail.com>
> Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index d95f417e24c0..9be2a6a00530 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3651,7 +3651,7 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
>   	enum dma_data_direction dir;
>   	struct scsi_data_buffer *sdb = &scp->sdb;
>   	u8 *fsp;
> -	int i;
> +	int i, total = 0;
>   
>   	/*
>   	 * Even though reads are inherently atomic (in this driver), we expect
> @@ -3688,18 +3688,16 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
>   		   fsp + (block * sdebug_sector_size),
>   		   sdebug_sector_size, sg_skip, do_write);
>   		sdeb_data_sector_unlock(sip, do_write);
> -		if (ret != sdebug_sector_size) {
> -			ret += (i * sdebug_sector_size);
> +		total += ret;
> +		if (ret != sdebug_sector_size)
>   			break;
> -		}
>   		sg_skip += sdebug_sector_size;
>   		if (++block >= sdebug_store_sectors)
>   			block = 0;
>   	}
> -	ret = num * sdebug_sector_size;
>   	sdeb_data_unlock(sip, atomic);
>   
> -	return ret;
> +	return total;
>   }
>   
>   /* Returns number of bytes copied or -1 if error. */

Thank you for fixing this. It looks good to me.

Reviewed-by: Colin Ian King <colin.i.king@gmail.com>

Colin

