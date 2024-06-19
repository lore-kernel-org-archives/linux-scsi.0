Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E733371743
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 06:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718780315; cv=none; b=LZk8+PcfssfobmRFx0qGKmPWBEM9cNGDuTLr9/ZiM9tuQadyxP/mK7jyNzoAB13ZS7qU9ZMpUwtIzadCMO5YmraZqvq4tib1siLp7dw7861nxyiDsqw+Z7BtDwBHhnLgz4Lb298TgLe8CXrcX/Aj+AIYgL/VwQbTEpHoP2YNUbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718780315; c=relaxed/simple;
	bh=8yvCfwBsuwDJ0rhpwGRR+qQimLpv5t7ZkmXBPLD4UII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RAy4elnpgYAKDUZ6cR7f14Qbjj+CixBBhrjHvEP3TZx+X04IBe2zPWSIPMiivv15ewbSS59ch3fxLgGjeUejIGfDgtn/Bv/UaezMqaX0EfYbUhobx7WGSyzrElicv8kVasQS3YcONlRCZykDrE7DmbGtz0lafXPxlXu+G1mzEGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RthAXAf6; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RthAXAf6"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7062bf6d9a1so448714b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 23:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718780313; x=1719385113; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6zs1ABy/umnJR1EF9b+bZYKjRXsNkBF4CyBK54gWpLI=;
        b=RthAXAf6nXuw5O3MOPTyd5KuvVHoC7St2ew2cEAmEBfCEi7aC64qMOeSNAC61ZT037
         0id/S3Pho44agwZNFua4PORk+4/Vq7qSDC23N2OQG9DNp8U/YaZMfWSznPEZ2rQn1tSl
         rtgklViEKQWQsmpMxx87cKkmtw+1QM9wok0ytpvfShFfOQA4jqFN6jKMN3meCXEwAM37
         VMA6jugi/WxtIMO6qfAceJjMBEdYo4ohz8RBiVFf2beTL9SEo/plzB55TsagHkpQGRU4
         0q0CCLScjAJMja5U9iVeaaEUHiZ8jtkZcl88Ey53I1EBM3uHHOxmG3GeZoUwWEzOvdII
         96Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718780313; x=1719385113;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6zs1ABy/umnJR1EF9b+bZYKjRXsNkBF4CyBK54gWpLI=;
        b=dWApUqgReq/DmkfbMIsFR3OpFOwKfWqe7zhuv+xA49wgC2almHqc+f32Q3dyuzYQq6
         7sY5IV0gWZ6EMoqq1tl6q6ctJSm+TOzrpt8TKTn+8mzGXdSsCFXktJywzXRcoBDc9X9Q
         g+eZEqWq98fmXF8q60PuHedz+DYxxBHB/dS2k3WyqT7oBh8BIFTc7x1kkKlHGsDab+x2
         uCyYQSm94RerwhZrWiumSQ/VwkuPiYRUnqpc86cJVVo+vHc1VCMoj/8Eeph3H1mHumqG
         5TF5t6SU8U1FexWLNe5m1aDDbtWY7f7WRIO3/aGpixy02a0lbXB/YbcRa5XT/cwDiC8Y
         qRug==
X-Forwarded-Encrypted: i=1; AJvYcCVLwRKUiyg4KSgnOgKnPfzc1QvfESeU8jO6cspKrxv2awIl+tk1+xcLnZJ2p2BBfXckyvG2XRfObdj2bo8ISIpjCl6CwQelvrrZzA==
X-Gm-Message-State: AOJu0YyfUMXAQTG8oxyLJ/CUKIOJ7fGfIkBrwJbynxsTfpd4AW0Hh6Zt
	1b0lrp+2S7Ja9gDbY3pIeMon6hRvIKmcrmQwukT4M7MgoqnfGqmcYeI/1Z7Duw==
X-Google-Smtp-Source: AGHT+IEXVIPcjMsC5Pwm5OohaheA+a/iHOoPBvMCJwBpHoFzpSI1YaJwtEPIplVI37X9grYOtnrrhQ==
X-Received: by 2002:aa7:80ce:0:b0:705:d901:4e39 with SMTP id d2e1a72fcca58-70629cd0970mr1636771b3a.24.1718780313019;
        Tue, 18 Jun 2024 23:58:33 -0700 (PDT)
Received: from thinkpad ([120.60.70.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb6a6d2sm10305372b3a.142.2024.06.18.23.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 23:58:32 -0700 (PDT)
Date: Wed, 19 Jun 2024 12:28:22 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@wdc.com>,
	Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH 2/8] scsi: ufs: Remove two constants
Message-ID: <20240619065822.GC6056@thinkpad>
References: <20240617210844.337476-1-bvanassche@acm.org>
 <20240617210844.337476-3-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240617210844.337476-3-bvanassche@acm.org>

On Mon, Jun 17, 2024 at 02:07:41PM -0700, Bart Van Assche wrote:
> The SCSI host template members .cmd_per_lun and .can_queue are copied
> into the SCSI host data structure. Before these are used, these are
> overwritten by ufshcd_init(). Hence, this patch does not change any
> functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 5d784876513e..7761ccca2115 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -164,8 +164,6 @@ EXPORT_SYMBOL_GPL(ufshcd_dump_regs);
>  enum {
>  	UFSHCD_MAX_CHANNEL	= 0,
>  	UFSHCD_MAX_ID		= 1,
> -	UFSHCD_CMD_PER_LUN	= 32 - UFSHCD_NUM_RESERVED,
> -	UFSHCD_CAN_QUEUE	= 32 - UFSHCD_NUM_RESERVED,
>  };
>  
>  static const char *const ufshcd_state_name[] = {
> @@ -8959,8 +8957,6 @@ static const struct scsi_host_template ufshcd_driver_template = {
>  	.eh_timed_out		= ufshcd_eh_timed_out,
>  	.this_id		= -1,
>  	.sg_tablesize		= SG_ALL,
> -	.cmd_per_lun		= UFSHCD_CMD_PER_LUN,
> -	.can_queue		= UFSHCD_CAN_QUEUE,
>  	.max_segment_size	= PRDT_DATA_BYTE_COUNT_MAX,
>  	.max_sectors		= SZ_1M / SECTOR_SIZE,
>  	.max_host_blocked	= 1,

-- 
மணிவண்ணன் சதாசிவம்
