Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB2E1D63FE
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 08:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729155439; cv=none; b=JaOr9rgEReH01/V7jRPgrP4Af7aFAlYpETEaaxBnpNxPm4BGd6eu+bXdlntIUF1d1RkKoE2um93HwtsodnaeNze5Y46rsmdFcpJ3lpZoJ1FldcI5uqkrL+fdS6A2RLXJsPQW+w7xsDwR23SkAQzINi+GZdYThgIpK7w0ZJK02k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729155439; c=relaxed/simple;
	bh=iFSLKi+JqbE5QIXS1t+TmqgxzgU2rhTSmgEUGjgHdvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UsOWiyxWGCdaJovTDD3URCJhN6PDayh1nKHinOkh1k/BN9UQ5ZbosgrgqBWLHDhrcqx98TapHltq0Xtr70X/OxpH8uDG33pvI1nUIwoKUHrzBB8suhSS3UxDEQCJi+KIlUV4F65OJJqUCGWZSme2bNjjJZkoDgxN6BmMPj9HI38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CVuJiih0; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CVuJiih0"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a99f629a7aaso117456466b.1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 01:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729155435; x=1729760235; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=71u/2ImVUSG6tRSALKKCPqTPCxFY1jTTM2tTLu1wUA0=;
        b=CVuJiih0AV+QNOg20M84HWc1D6Qg8Qbp6RnfLwcnNyCCnml700FIog2+QQxmVLA9A1
         RQnpEf5aQukcTvuEKCTCBm+pOqDnaLJVnxE3Bsui/OCpBRXW9Hu+caQdbcn3d4K5YNUM
         hUVD58XxbwBt5V2Phkgv5bTX72ADoqe0ZuYogtT/C11dmRcFoiYhJgrAYhglLkd4pDEs
         OO+exGwF19yxR0G7QRKtTCQGGTUVGuHcyuxPX2W3XOHVPpTHLDtfhU7UWAdAy/1EfG1u
         JqZAYlutiouwgOV2Kgyu+ETmFwdPFXfdpDJyDWmIBiFrgTTWPTTudPaYzdyXlIHjsLaN
         4lfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729155435; x=1729760235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=71u/2ImVUSG6tRSALKKCPqTPCxFY1jTTM2tTLu1wUA0=;
        b=JuSKLirvVQY/0mwfhrLTp9LOpcgA3i6tT2++tVUnRvw/xs6mQsnv7Sd0xLqXs6Job4
         52Guob1uFSbeK4AgltlqaiDrB6XGVA7ZooG2BgbOLMNJLexXLFC0/N+2AQK3jAXSt8/F
         rltIv00DkTwHslsf6sy31oKVAvSaTylOn09SiNNa5t9MEkCN6yjF5yFSZfyJa+g2ZRPJ
         +6d4LxWPBOLmVMWqYyhIZDOrYDGlRuaAVWxp0zIpSlpSVwMygUWAlKgHSQupK5fND3/B
         py7d0UTfT6vxPlE/EcCZPrHsxTU9pWwyjEkGNyZlzDqND7RYn5JIEME32CO9g3+QMCr0
         KpUw==
X-Forwarded-Encrypted: i=1; AJvYcCWPvWLcz8bbs4Gi90ywh3GhedFOxwMVWnIWvcu1+F8Ii3+sjMhhK7mpEGXDRHC+813/XrXAd5ajpful@vger.kernel.org
X-Gm-Message-State: AOJu0YybzfP9ryBRSBahlbU7Ap/IYGAWEAFv4/VfX2egdg+hLFUH7wd2
	jSWV4xs28Bz7xDr23/m9jMZMCUMJn+Re18Y/oOkWT/PNxa+j22CRPWHASFZfU6U=
X-Google-Smtp-Source: AGHT+IGYYEqktdQg4/62lwG+WcVcV3tKvLYkXGKPRL6l8VihPBEL2cH/36Xj6ngD8Ie71PGXZIKeJQ==
X-Received: by 2002:a17:907:3fa5:b0:a99:fcbe:c96b with SMTP id a640c23a62f3a-a9a4cc3aaacmr224024166b.25.1729155434615;
        Thu, 17 Oct 2024 01:57:14 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a298173c8sm268786266b.123.2024.10.17.01.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 01:57:13 -0700 (PDT)
Date: Thu, 17 Oct 2024 11:57:10 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: John Garry <john.g.garry@oracle.com>
Cc: Colin Ian King <colin.i.king@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: scsi_debug: remove a redundant assignment to
 variable ret
Message-ID: <a2515a3d-1dbb-48b6-a489-25aba3358068@stanley.mountain>
References: <20241002135043.942327-1-colin.i.king@gmail.com>
 <2be706cc-0944-4413-b1b0-52d34fbdadf8@stanley.mountain>
 <9151ca6d-7153-4a97-aaa2-7277fc5ffa84@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9151ca6d-7153-4a97-aaa2-7277fc5ffa84@oracle.com>

On Wed, Oct 16, 2024 at 08:16:16AM +0100, John Garry wrote:
> On 02/10/2024 16:10, Dan Carpenter wrote:
> > On Wed, Oct 02, 2024 at 02:50:43PM +0100, Colin Ian King wrote:
> > > The variable ret is being assigned a value that is never read, the
> > > following break statement exits the loop where ret is being re-assigned
> > > a new value. Remove the redundant assignment.
> > > 
> > > Signed-off-by: Colin Ian King<colin.i.king@gmail.com>
> > > ---
> > >   drivers/scsi/scsi_debug.c | 4 +---
> > >   1 file changed, 1 insertion(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> > > index d95f417e24c0..7c60f5acc4a3 100644
> > > --- a/drivers/scsi/scsi_debug.c
> > > +++ b/drivers/scsi/scsi_debug.c
> > > @@ -3686,14 +3686,12 @@ static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
> > >   		sdeb_data_sector_lock(sip, do_write);
> > >   		ret = sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
> > You would think there would be a:
> > 
> > 	total += ret;
> > 
> > here.
> > 
> > >   		   fsp + (block * sdebug_sector_size),
> > >   		   sdebug_sector_size, sg_skip, do_write);T
> > >   		sdeb_data_sector_unlock(sip, do_write);
> > > -		if (ret != sdebug_sector_size) {
> > > -			ret += (i * sdebug_sector_size);
> > > +		if (ret != sdebug_sector_size)
> > >   			break;
> > > -		}
> > >   		sg_skip += sdebug_sector_size;
> > >   		if (++block >= sdebug_store_sectors)
> > >   			block = 0;
> > >   	}
> > >   	ret = num * sdebug_sector_size;
> >          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > And that this would be a "return total;"
> 
> Right, the function is currently a little messy as there is no variable for
> "total", and we re-assign ret per loop.
> 
> So I think that we can either:
> a. introduce a variable to hold "total"
> b. this change:
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index af5e3a7f47a9..39218ffc6a31 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3690,13 +3690,14 @@ static int do_device_access(struct
> sdeb_store_info *sip, struct scsi_cmnd *scp,
>                sdeb_data_sector_unlock(sip, do_write);
>                if (ret != sdebug_sector_size) {
>                        ret += (i * sdebug_sector_size);
> -                       break;
> +                       goto out_unlock;
>                }
>                sg_skip += sdebug_sector_size;
>                if (++block >= sdebug_store_sectors)
>                        block = 0;
>        }
>        ret = num * sdebug_sector_size;
> +out_unlock:
>        sdeb_data_unlock(sip, atomic);
> 
> 
> Maybe a. is better, as b. is maintaining some messiness.
> 

I'm happy with option a.

regards,
dan carpenter

