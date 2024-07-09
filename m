Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A1F1E898
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jul 2024 05:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720501688; cv=none; b=ByWWnLRhIYZgiE/XKVr6HdZa35Xzzc52O+xFFkQEwhBUV48Wy5oIrAUd8njbxkrXYspDx/A2RoXJ0zOKaRmgX8hzKQmNPZXByG2IOg6fv0dUnwV+f/PrO1ve0xXRGQ4jNaJHCMfYP4ynsfArAvTxS91I4KQoVCPE4RIhxmKyxpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720501688; c=relaxed/simple;
	bh=ApC5z3fDNtzYvtwTjXKZQrYPA8uzz5yywh0NaoYVEiA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZi9oDbRzx82rv6qGEphhOmQwBQ4sDZt3VZLfVG4ja5VqpEicksBT0v6C14+IFEk1fvQ51f2Aiz7Y4+SX3TjOpeiB73b75i7pQmZHbSy8c5TGX5vB+990wLkyX9cbwHPZGHR2194deROowQlhDHXprOw6qny+AEAz7lXlrWVjXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i1Vu3eN0; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i1Vu3eN0"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1fb3cf78fa6so26026085ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jul 2024 22:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720501686; x=1721106486; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tApfYRnFc6oWMYy4cDT4/D594xVOMhzh4xHghdd57FM=;
        b=i1Vu3eN0Kh0K7JvD7GXrX6xzQviPmQZCKWrycAzXkFSipBkY2BGX4xtW7sbQnQYcUy
         OjFjSX5BWHEbk4qxaYvTmjCknddS2uQw5TT7ZIBxTqvYXOxB2zEIXV4yA9kyIZvIkYt4
         KQQC56yPUgW9lod1CbrOmzDM5eX2+WAQqs+p+ADCZegV5+8BCv3k93Z6YoV+FERBU1Ts
         offdOQ4cODBQM+MvxG9L/w5a0mCILRiyenPKIs19QvcQqbgi961uDHztVkFc66uz2+Sr
         Spcyk9anY/NmIX21HUO1s+jcLwx8cWz+rffX5Jt2sBZEXqOzgY/2bsHmHRtmAXGx/VNH
         +ziw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720501686; x=1721106486;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tApfYRnFc6oWMYy4cDT4/D594xVOMhzh4xHghdd57FM=;
        b=TNe6kD71RmEauxWt5T2VgrTB/1jj5Fluj4TDXGUnNHhit3bX3kwkQybGSEPrh6wBEo
         MGxllW9R4ADKNugB2k5yl7t3kdVE/sFF3Q8CEuc1Q8U6uOyVZ2SPkippeAQoQVOZf79c
         d1csdexS3gbGXmPsISR3pSDoDLZjwjXI3IMM05RGrEqUo+091b2q00C0drGeO14sPakk
         HBkIs9lybvRkOr2sSQvhliWkP4KuVSy1KYtK6RdGs66lNKyhTWgbBmCDpyKLRT9TXnIU
         jfhkfrp/b0S+tLzE2EKCf+ruBuestD3p1RKQJUFzsJ1MRlRTN920NTQn2SBqxz5Iz7uD
         tJmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsdvlI+Jn+XZRM8lgQeholJmZ5OMAnVHfu+GJ8FCZgyGhkFFU4nmpkNql8kwwH9Qv0nAo9pza2hoDmNZjJcDQ13Hutox/F8A4C1Q==
X-Gm-Message-State: AOJu0YzJWABiwfOJJpFW4xM0DRWVM7YmSMlGLL6vJExlkfDBdna5nRZk
	/Sfgqm8SFD55ROD4hNmh1th8cvY+yZoXxHS8ZGU7R64zcRvbRM8DfyvhoiRT3w==
X-Google-Smtp-Source: AGHT+IFx8/PMVrR5H09qZyGJTAM6QfW6IIkpUdghL0cXd5OHvIUnDHh5Xj/jrcLlEfgdnQPXdjRl4Q==
X-Received: by 2002:a17:902:d50c:b0:1fb:5f82:6a5d with SMTP id d9443c01a7336-1fbb6d44060mr15967965ad.21.1720501686360;
        Mon, 08 Jul 2024 22:08:06 -0700 (PDT)
Received: from thinkpad ([117.193.209.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6ad5172sm6977365ad.285.2024.07.08.22.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jul 2024 22:08:05 -0700 (PDT)
Date: Tue, 9 Jul 2024 10:37:53 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, peter.wang@mediatek.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Rohit Ner <rohitner@google.com>, Naomi Chu <naomi.chu@mediatek.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v5 07/10] scsi: ufs: Move the "hba->mcq_enabled = true"
 assignment
Message-ID: <20240709050753.GC3820@thinkpad>
References: <20240708211716.2827751-1-bvanassche@acm.org>
 <20240708211716.2827751-8-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240708211716.2827751-8-bvanassche@acm.org>

On Mon, Jul 08, 2024 at 02:16:02PM -0700, Bart Van Assche wrote:
> Move the "hba->mcq_enabled = true" assignment to prevent that it gets
> duplicated by a later patch that will introduce more ufshcd_mcq_enable() calls.
> No functionality is changed by this patch.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufs-mcq.c | 1 +
>  drivers/ufs/core/ufshcd.c  | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 4bcae410c268..0a9597a6d059 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -416,6 +416,7 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_enable_esi);
>  void ufshcd_mcq_enable(struct ufs_hba *hba)
>  {
>  	ufshcd_rmwl(hba, MCQ_MODE_SELECT, MCQ_MODE_SELECT, REG_UFS_MEM_CFG);
> +	hba->mcq_enabled = true;
>  }
>  EXPORT_SYMBOL_GPL(ufshcd_mcq_enable);
>  
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 255d55e15b73..7647d8969001 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -8704,7 +8704,6 @@ static void ufshcd_config_mcq(struct ufs_hba *hba)
>  	ufshcd_mcq_config_mac(hba, hba->nutrs);
>  
>  	ufshcd_mcq_enable(hba);
> -	hba->mcq_enabled = true;
>  
>  	dev_info(hba->dev, "MCQ configured, nr_queues=%d, io_queues=%d, read_queue=%d, poll_queues=%d, queue_depth=%d\n",
>  		 hba->nr_hw_queues, hba->nr_queues[HCTX_TYPE_DEFAULT],

-- 
மணிவண்ணன் சதாசிவம்
