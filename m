Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F314524418F
	for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2025 23:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745018096; cv=none; b=jEz6pNOd0dr0EQj+Cb4j+sUzscFOOBX+Pu+0cjjXk7vgUut4Zu+EtzMpv4yj0sQh4j0EzghLaMupHxOXOxuc2DBQWqpTeShYgOioJXeCqjc4+hsHK5Gnj1mgaDgi+Mb45n4u2/SQV2g1wTzEZs8uQxNh0BptoJVqP2fZQcEasz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745018096; c=relaxed/simple;
	bh=M+yFcxgA5UoT4y3zPDlOIb+luoJpCnpooQU1OrR5U2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccmXy7Iv7PLO2te9jgJdxMXTK8S+YkYso7RRFvUthLRYSNahLuAXDg4bC8TZflWDOOQXHeTW+QxbFdbQMqaJbWdItQcnhKmn7T7FJWH11MltoJX1e8u7AQrENX/uGBY5egi6rI2xpoybZWmPNBDw9BP+DFFhhvfIEMHyUPfsVHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xHZBoIHr; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xHZBoIHr"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2240aad70f2so315245ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Apr 2025 16:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745018094; x=1745622894; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G8up+br7TxL1MAZrYi3mnJnaia6kOAmbO1PhE75M/CI=;
        b=xHZBoIHrmt0oe4r7Bia7uQmJjMAtpR2UtZVlFqA5gIyJ0aHdfo8sst2mZDdhj2z9jp
         0RTlZLgCTSAeRBsdnFnPUhJwKoh3m+bDDLEa/okC/oUZRx8nSwC2wyWOXDr/I23EYTFy
         R0Px6WgZh55Sq25xsOi7RRGTudC5AwP12DcVHElseM2/Bf2vb21cAcQFdPfQaTYeDgKj
         GIGATI9esizBqVR/pPAq8eKtGixZt4rz1PRt1Vr9Ay0oT9xTibSp3TuQ7H7VBOXCX4R3
         sKYRR/xvh9+UNrWapGtAvfVMheko55QXENhAPUxHZ+v2vliflSqp9Xzy/AUQIcNCIA1z
         QLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745018094; x=1745622894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8up+br7TxL1MAZrYi3mnJnaia6kOAmbO1PhE75M/CI=;
        b=ml+HBXv42upapOCmCTjZkmH/keyZwv70SA4HLM3KbRaJB9efxESck1UYoM7npqqY/s
         +BxBtWZURjodpob4oz4hxu4anqPcTPhTYT23ow2uqhFtgQoIVODjxyz8ojNc6Zg5y7Qy
         1rJCORDJhWwi/Lsx50NQvGhORuer9nKXCqdgCJJEOwtvSFmButOWh+PHzWKig0nR/4eV
         m9vU3akVKFcdd12xkDkuf7IhGTuea2duFCjOIOulghiTYeDELy/B6xSs2OXuSmzcRb0U
         0Pml+VAPOPtA0YPpzEbjrtMqpj2O6pT8lg9zSMSoU4xE4eg9uBWm8lyoe0FJdFhkAeup
         oodw==
X-Forwarded-Encrypted: i=1; AJvYcCUSi+glVJdLc6nQXVyM2Knxkyg6eEpxtlk41GXBLdvPh1VJ17bIe5sAWPocRSzob8KWPyp4c2yN+SWy@vger.kernel.org
X-Gm-Message-State: AOJu0YyDcV/iK6xYa4/ZHpu37cEvGuwGN5NKNLYDFBJidRYrI1hy8GFm
	LePkSxlAfA/ApfqEUDToqWzQ0ydJmrXj/AHeNMq4qBMehIbkqqsbB7dTYmx1hRcnr1yZ4JCFWXe
	aCw==
X-Gm-Gg: ASbGncs0sm5+edyoUEjpp32C8UZuVlXyujXd5GI96AsDPzqRudYYp6GQoJ2hI1lOzcf
	7tASKLSF7j+yPE0LCufnWP6s9Eb4VQRtvfLiIG8BxzmYy31GMlQ4Q44oz0rTJh72EGFUmRI44qv
	5njHN/T1nUqszFgofwhmKRxGL4NnJswyNYRJQiO7cUBKBCZxooL58QJNyzTCTgeUWxhzN11H+E/
	5Mf6Nh+9u/YGAGpH1hZ/LgXDEf5RktHjpoC2TY+21zpz6+IP4b7tUY0F9Dgk8CUOBdbmCMveSY2
	q/739TcSGmFbn644fF1dfB9LF6wYrPMb25uiUwjQz9SQNJG7a4hPMQgrCgV897RfH5LfsUKh3bs
	c
X-Google-Smtp-Source: AGHT+IGN4I/AGkBiqM6+mhRGskQgTUObnsjlgT9lAu72b7p03Ut83zAPXBy09Axdev+dLWLIfPzmAw==
X-Received: by 2002:a17:902:ccc6:b0:20c:f40e:6ec3 with SMTP id d9443c01a7336-22c52a93c7emr3910775ad.22.1745018093899;
        Fri, 18 Apr 2025 16:14:53 -0700 (PDT)
Received: from google.com (24.21.230.35.bc.googleusercontent.com. [35.230.21.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22c50ed0ed8sm22070875ad.200.2025.04.18.16.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Apr 2025 16:14:53 -0700 (PDT)
Date: Fri, 18 Apr 2025 16:14:48 -0700
From: Igor Pylypiv <ipylypiv@google.com>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 1/4] ata: libata-scsi: Fix
 ata_mselect_control_ata_feature() return type
Message-ID: <aALc6EzizWjKRduw@google.com>
References: <20250418230623.375686-1-dlemoal@kernel.org>
 <20250418230623.375686-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418230623.375686-2-dlemoal@kernel.org>

On Sat, Apr 19, 2025 at 08:06:20AM +0900, Damien Le Moal wrote:
> The function ata_mselect_control_ata_feature() has a return type defined
> as unsigned int but this function may return negative error codes, which
> are correctly propagated up the call chain as integers.
> 
> Fix ata_mselect_control_ata_feature() to have the correct int return
> type.
> 
> While at it, also fix a typo in this function description comment.
> 
> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Niklas Cassel <cassel@kernel.org>

Reviewed-by: Igor Pylypiv <ipylypiv@google.com>

Nice catch!

> ---
>  drivers/ata/libata-scsi.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2796c0da8257..24e662c837e3 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3886,12 +3886,11 @@ static int ata_mselect_control_spg0(struct ata_queued_cmd *qc,
>  }
>  
>  /*
> - * Translate MODE SELECT control mode page, sub-pages f2h (ATA feature mode
> + * Translate MODE SELECT control mode page, sub-page f2h (ATA feature mode
>   * page) into a SET FEATURES command.
>   */
> -static unsigned int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
> -						    const u8 *buf, int len,
> -						    u16 *fp)
> +static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
> +					   const u8 *buf, int len, u16 *fp)
>  {
>  	struct ata_device *dev = qc->dev;
>  	struct ata_taskfile *tf = &qc->tf;
> -- 
> 2.49.0
> 
> 
