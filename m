Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F853183CC3;
	Wed, 20 Aug 2025 12:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755691362; cv=none; b=pXAos4DI2z0Xd/3m17+4cOMEMLBcXpr205lbt5cwTME4tKjGiANbZnry3zoYdDk0t/+6Pf287UCoruvWxWjv9EpWOztOpYc9JJd8ke4AqHsvuF/e3LY5/WVNkd9vaNqGAIfyojxNOBbSRQ0VS3sOM3QsH/AUB0vLoGKgRqez1AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755691362; c=relaxed/simple;
	bh=r9ToofhKIlGhprm7g+OOvtlUM68lKLTgnactfCPZM7s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QbRY7etatTxHqtvoyLHpziCI2JV3hNyyyuANr+v8K+R0/NDNYm8hy53nwW3LoKJbXRPHXoTgpL96zT1+tmuw6J7RQyKP9jOzvNYkgekdotXPxMddZ+6xUHR+PJgSyOwu1EZtnyAZkS9bJ4gtQU/5PFjc68YaE4q6fJijdTUmR/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ms4NMx0j; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ms4NMx0j"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45a1b00f23eso36038415e9.0;
        Wed, 20 Aug 2025 05:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755691359; x=1756296159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GI4cmyhGoZTapDNpDk+xp6yi7nQGTz7zZ/LLknFSC4g=;
        b=Ms4NMx0jATLUuV3HjughrYXuo06qEY9dSbkMt1NhVqaHSHs0EqpdotgdYvZHVA0oWD
         ndUPPjo0SKU9KVchOkYcS/XdJRBwqrkMUynbhunvFOEvLrG8VO6N594tf72Dl3QnmEMD
         ftiQjlPtD+/94eetSMUBOfRU6wM8j4LGTcCUVHj063RE3wzh1PjWGr/VCaqb4PKZog0a
         9/wE1JlndPC0EA4HKqXpxZEmhSSAZ1LsSdPod13iwcMo4BXPmwFwmG503Gn9sYvdVRCd
         uTGchpniimbWh1ryi1i2Nxx5wiLafrlALKup483xehzxi5IKAzFPpovrUCL8HDs1GMbQ
         FWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755691359; x=1756296159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GI4cmyhGoZTapDNpDk+xp6yi7nQGTz7zZ/LLknFSC4g=;
        b=HhRPn03g+wXMmH5MYAcqYok+ynQjlx8Cqqi6YQGmYCkb8B+oi/rJZjtBqt+nlUcc+m
         CwnnIxJKUl7KwD3kdcbPeqhsKQVUJy8bSIluj0FX2NLI9F80JiBuLyItK7yNYjZJNqI4
         /irE55oJWEBk9rsiZ+IfW+rqY7eH9iBu+YnrvUjFzYUEijI839AX/2EUeOEZuahWn8Ho
         hsKIlpH7gsCwCgf80SzHcRURAsrTMTxp9ju/8kPbSQrmiHZsFUJXBtY6Vgo2Qt13v+Wc
         cBGYUDexU3zHFVR297+qxQzFMihojJ6oSOGyVlhb9P/rNyU11dEEj1irQai7rzKkhyts
         Z5Ng==
X-Forwarded-Encrypted: i=1; AJvYcCXvtsU+pSSNwDq/0At5eEU54uYTzdeAAPRrXoZYrIumxmUOfvJ27SjACSIlvmuR138T80cJ48318KhZ6oI=@vger.kernel.org, AJvYcCXyXUlVYm2C/Cy/AIvgY70oCVWtjA0rF1/ucqWEpkzo6YJcPCU8sf8p1KQtg/X6DHRdXr5q6Fpmbsggaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLWDF5+ShAcFpFv27TnUh0N8G+PX/CxjQSBwT5tQ+gB7/6I3PI
	hVG25U5GAk0LFvE0XFfMt7l5pfhsSyPcirbi8Pxw9LagTuDOxZlFJGLM
X-Gm-Gg: ASbGncvyudNf5ghGAIr299Hbuj/Pu2Xp8SwgAMB1vvCPphDkNsD3x/CmFfd6d77PTof
	M3cPsw635JMmF+nqUFeEkNtoLiKqbRXqBmjOW2XAs8y+8tEqTbvuv3PYqOsXP8wNbXUlrUlPuNg
	p+8ctDpHozrF9oY33tDfIMvrdBzgqcG3ojZJjB8BXF+hP80qugEj+Rg40r8DyDwO9qGcvwaB/je
	3BH5gfZb6nimoT8EiPf+nJKustashvl05Hvxy2yoi7xKltPi0lKuwnx46cvwMkJqDNiy7N7oyya
	qKigo+e0CWpYeK6Uft26t3SaDdYHEhb91lgcU2Rw+MSsdkfHoFuTE/Kzv10v1Gyu8PpH7btY7Gl
	AaGCFJydS+zmAZ+hGnQQf0imQbrzfD5JOuVLsVtozsuHdzyVq2PRVHTiONl0bE8C8
X-Google-Smtp-Source: AGHT+IEwGehcNKoWmnzN1vlUchmjm7VumJiJT2xSRDa0Ox8JxTIJFDzHyc2MWVXuJj+CImwefaPXpg==
X-Received: by 2002:a05:6000:2913:b0:3b7:9ae1:eb9 with SMTP id ffacd0b85a97d-3c32ca06bc1mr1855975f8f.23.1755691358624;
        Wed, 20 Aug 2025 05:02:38 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c3e673ab01sm1003635f8f.18.2025.08.20.05.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 05:02:38 -0700 (PDT)
Date: Wed, 20 Aug 2025 13:02:37 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Qianfeng Rong <rongqianfeng@vivo.com>
Cc: Don Brace <don.brace@microchip.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, storagedev@microchip.com (open
 list:HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)),
 linux-scsi@vger.kernel.org (open list:HEWLETT-PACKARD SMART ARRAY RAID
 DRIVER (hpsa)), linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH 2/6] scsi: hpsa: use min()/min_t() to improve code
Message-ID: <20250820130237.111cc3a7@pumpkin>
In-Reply-To: <20250815121609.384914-3-rongqianfeng@vivo.com>
References: <20250815121609.384914-1-rongqianfeng@vivo.com>
	<20250815121609.384914-3-rongqianfeng@vivo.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 15 Aug 2025 20:16:04 +0800
Qianfeng Rong <rongqianfeng@vivo.com> wrote:

> Use min()/min_t() to reduce the code in complete_scsi_command() and
> hpsa_vpd_page_supported(), and improve readability.
> 
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> ---
>  drivers/scsi/hpsa.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index c73a71ac3c29..95dfcbac997f 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -2662,10 +2662,8 @@ static void complete_scsi_command(struct CommandList *cp)
>  	case CMD_TARGET_STATUS:
>  		cmd->result |= ei->ScsiStatus;
>  		/* copy the sense data */
> -		if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
> -			sense_data_size = SCSI_SENSE_BUFFERSIZE;
> -		else
> -			sense_data_size = sizeof(ei->SenseInfo);
> +		sense_data_size = min_t(unsigned long, SCSI_SENSE_BUFFERSIZE,
> +					sizeof(ei->SenseInfo));

Why min_t() ?
A plain min() should be fine.
If it isn't you should really need to justify why the type of one parameter
can't be changes before using min_t().

	David

>  		if (ei->SenseLen < sense_data_size)
>  			sense_data_size = ei->SenseLen;
>  		memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
> @@ -3628,10 +3626,7 @@ static bool hpsa_vpd_page_supported(struct ctlr_info *h,
>  	if (rc != 0)
>  		goto exit_unsupported;
>  	pages = buf[3];
> -	if ((pages + HPSA_VPD_HEADER_SZ) <= 255)
> -		bufsize = pages + HPSA_VPD_HEADER_SZ;
> -	else
> -		bufsize = 255;
> +	bufsize = min(pages + HPSA_VPD_HEADER_SZ, 255);
>  
>  	/* Get the whole VPD page list */
>  	rc = hpsa_scsi_do_inquiry(h, scsi3addr,

