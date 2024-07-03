Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802C216DEAC
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 12:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720011591; cv=none; b=P/sDRwA4zq9KfvvhIsHN/4sK5rINvNoTPa8LvaOvxykMMwzpqhPSCLmRZbjOUEekeoAVfQ0MgfTtlTR3AqsUlF3z5jx/IVWGcUK7NhuEx1vAcx+PLx1NT8k1Wz9Bsct3kavdO/SACfBI1iqY4WF5HsMYeuEVmZ8rKzfYtZWZBbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720011591; c=relaxed/simple;
	bh=3qVjwe8JSoBeQ62ic5/5AKhZAZV/LsICslUKQRvBIPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jK2XuoyrP2fdmNuwVqsMbRL7s02P7RcHEeWD42it7bK9ugMK7WBZ59+8/awqLz5ugO7+p3aUKO57Fmruf0zspliA+j6t00Mrmundu2gx3O3jAwyWqLiWU8qYE2YVOpDayS6KddRB1d43ynIZECMoE3AUc2jeJbmHR4Re6DSZgKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tMzS8c67; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tMzS8c67"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1fa07e4f44eso35320595ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jul 2024 05:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720011589; x=1720616389; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M/HUx2z68wHC+7+MGltuv0hwTRcQymV4Of6HlMwnIoA=;
        b=tMzS8c675lsErTlQFDI1aXm2/pgmxo1HBs0I92eR6IMUj2N7C4BMlGCgU/SJp7iltN
         sI9PWrkYJ4g8jtu0w66KzbLasKZF4giT1dqf5pMvmuu50/w94uUhrBidzYfPGij5Bqgt
         J//OOlF2UCIzBdtOcqaddR2E5MiNKFG0OaIJCcEGqKtoDCLqoz9eMo5O6lBIgvUN6c/1
         a40/Z1+8cwCKz4xYRkIcYozjtZfo9dmjOUDkgX/jzI9gNzVS/l6cwMqqdT9c3O+H0Irv
         eZQyBfmAVme//UkcFLdtlugSgWoa4P4WIbgpeurZsTtVXeTCh7yKF5JOu4p+ycjTs67y
         gqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720011589; x=1720616389;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M/HUx2z68wHC+7+MGltuv0hwTRcQymV4Of6HlMwnIoA=;
        b=GPu7mnm1co2iAdhjjCNeJBt5RJMFga9s4OuP68YwR6VUYazXtklsD/g537dBW2Ioko
         fChJ1Ns63+b/ehhKkZ7hkf+sKuK+aXUZ6a8zEzLcjtYaVxCJZ/hOyP1l70AuQR1lBTA0
         3BogyazlikvAOqxVCaH1QsNXblcknHLNE6yjQLS4AmvewPZrj4OSvoWpHS2m5t9tQv7j
         SX+S1uSLHLkOCwuk1WTsULaird/ANjPnPEidWtc9mRGFShg/+lkpxyPyFt44TUutddjW
         34inKgQLLcKx3+LJ5WkQSQ3zjMhU1QQD6JmDw08L+RUdZJmE1B2yIKUs5djq86z7NWFx
         CnlA==
X-Forwarded-Encrypted: i=1; AJvYcCXScvMqo0PYEWPl7AiQAJQg8msVNmstHmkfnLLsWLmR4lGGBJKQBdeYLwP5LAJ7sTf4MwSeSdL4dfDq9Y/DHnSLruV8HnHSTQn+zQ==
X-Gm-Message-State: AOJu0YzDfVdLXViG9AYbyU9EK264MteklzSs7oybeMjAbtAa8uywKfYZ
	B7SmvSRlg/7zvCvrIm/QH3J0+a0gx5/XEB27OCNCkP17op6pjCKisjxp1ghp1t8RaIaixRDhjqY
	=
X-Google-Smtp-Source: AGHT+IEi359puHY1EWphwUsnc2L0OZ1He8voWNeKGDxJSXllvm8HRgnPFSwoIXC3MkIO/dhD4BvZLw==
X-Received: by 2002:a17:902:b192:b0:1f6:fbde:9b96 with SMTP id d9443c01a7336-1fadbcfce9fmr79519715ad.59.1720011588811;
        Wed, 03 Jul 2024 05:59:48 -0700 (PDT)
Received: from thinkpad ([220.158.156.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fb01e36dbdsm29042275ad.203.2024.07.03.05.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 05:59:48 -0700 (PDT)
Date: Wed, 3 Jul 2024 18:29:43 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Peter Wang <peter.wang@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>
Subject: Re: [PATCH v4 4/9] scsi: ufs: Rename the
 MASK_TRANSFER_REQUESTS_SLOTS constant
Message-ID: <20240703125943.GA3498@thinkpad>
References: <20240702204020.2489324-1-bvanassche@acm.org>
 <20240702204020.2489324-5-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240702204020.2489324-5-bvanassche@acm.org>

On Tue, Jul 02, 2024 at 01:39:12PM -0700, Bart Van Assche wrote:
> Rename this constant to prepare for the introduction of the
> MASK_TRANSFER_REQUESTS_SLOTS_MCQ constant. The acronym "SDB" stands for
> "single doorbell" (mode).
> 
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

- Mani

> ---
>  drivers/ufs/core/ufshcd.c | 2 +-
>  include/ufs/ufshci.h      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 9a0697556953..2cbd0f91953b 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2401,7 +2401,7 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
>  		hba->capabilities &= ~MASK_64_ADDRESSING_SUPPORT;
>  
>  	/* nutrs and nutmrs are 0 based values */
> -	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
> +	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_SDB) + 1;
>  	hba->nutmrs =
>  	((hba->capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >> 16) + 1;
>  	hba->reserved_slot = hba->nutrs - 1;
> diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
> index c50f92bf2e1d..8d0cc73537c6 100644
> --- a/include/ufs/ufshci.h
> +++ b/include/ufs/ufshci.h
> @@ -67,7 +67,7 @@ enum {
>  
>  /* Controller capability masks */
>  enum {
> -	MASK_TRANSFER_REQUESTS_SLOTS		= 0x0000001F,
> +	MASK_TRANSFER_REQUESTS_SLOTS_SDB	= 0x0000001F,
>  	MASK_NUMBER_OUTSTANDING_RTT		= 0x0000FF00,
>  	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	= 0x00070000,
>  	MASK_EHSLUTRD_SUPPORTED			= 0x00400000,

-- 
மணிவண்ணன் சதாசிவம்
