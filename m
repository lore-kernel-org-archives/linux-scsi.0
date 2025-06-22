Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBCB156236
	for <linux-scsi@vger.kernel.org>; Sun, 22 Jun 2025 19:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750620224; cv=none; b=mx/QnA5EB9jzvSi70JPju+vPq8AoSYP49b5uiEsQ9AxvfcwdR9yl/YPYQnhJ6eAeFgN4PNnAzLnHnfUAm6BYnEHvZZx+ixYkh9jWfsqtLEnVgF+d6cZzRbgM5kIb5hRrKokeMqSHtRssuv3y71aDWFQzJU9BmKzMSRLZu+I10HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750620224; c=relaxed/simple;
	bh=IpckR9VGbq4LXi10n8/fWnZTnStHUdYYVsZXeq2sScM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQl7yk++JNIrp/Mpe9haDk775IZebdDKTogZH0rnJvMpYvo40AhbfjDJgywa1hFuClamHIu578pZ4xqnHm4HldOCu1d2D200Ez6elGIoqlDBp2WO7swRWcUhIQdxZPgIjfh4HI6+bgqj5gGYgmbhVVdAfsnCUAHksbkd3Tyec3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SRF/Qdwz; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SRF/Qdwz"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-607b59b447bso5381292a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 22 Jun 2025 12:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750620221; x=1751225021; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Br5VyEEaKP/ktAugIXCOxiXHE4k+9++aboaKBknJU3g=;
        b=SRF/Qdwzp/iQcqaKSYU3tzN0iv6Ago32NnmH22EnpDwiErBUzXQUDfqKIm0V47rY+H
         5or7iEOEWcf1y+v0ToyX4Jyn0CuxHl+dIASOFkn/NHORf+gq46iARdg+tK3NQqks4KWx
         plwftMcNBftYLiSapv8FiMia01C6CBxKgRWx4x9vSk3xLbjjpSCvkCN4XUcPIBbsE9oy
         9X6sBOKIw0gwPJGCSNF7yCJKwh6ETXfBI2Q4MaqZz4jV99U3MVZ/Gfx4IOlTrxMFYO21
         tSW37ro23IzSGv12Tx+rxrF2QcNEbPSYzKWxqcQAozSjWAAY8ECBLD2oR906sEUi2ldv
         KnzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750620221; x=1751225021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Br5VyEEaKP/ktAugIXCOxiXHE4k+9++aboaKBknJU3g=;
        b=ER+XfyFXvwaTHH3/+Hcb4nqRnGtn668duXb7PeIEWbBWGQACkwV2Oe0osBPpXaR9ti
         EgLI7RK3XD/hwZ2JZYpFemxKehZLSn5VF2vpPJStknro2CpairQkOv34ckysnRz9zuQI
         7LgyL5U5IvUHCsaLtTNYgCOKLZbsRJM7MAMxJDWeEZLdKSBEL67YDuPU8Pkm9Z2ldb9R
         IEGH0UoQCaoff4Ay6bThXs9SDrLmusrXmLe2EWNC2gCF6R0lFHlDzi9KKAO8XAzsEQZk
         16B8jxPZxyHswQSAszuQ8FiujPvJnocmnhUuUyFLUDMZ6xFeD/pbHLHXYVObU6cWYPnF
         /q7g==
X-Forwarded-Encrypted: i=1; AJvYcCXMYYRr+VGodAWdIUAU8ZyMIeN7bCwKLjq8GA5h/Szbq7jIAvCBs7QNeVbx+stwqyRdw15PkGw8L92i@vger.kernel.org
X-Gm-Message-State: AOJu0YxBes4urlsOJR8uvPwdJV+ONlxqenrYZiQwLQuy9J76wpaVSbxJ
	rA+yp+Q5FRluoUrDXKN7f6YehBXNi2DZfjWvfdR69Tur8dQyQKnuTi61vBbsbCQtUWM=
X-Gm-Gg: ASbGncu3rDUcBlTpF7x13wlnuFxBrIGnyx80RTilnnfsRBuYzMEviMqzurTrrvN3vNo
	rDpjNYAMm0z6j2T+0ZA0Q6VpUooeKiNtXJ+d4I36Q23U0ll8dyAXPgAZmW/8K9H+VVzq6AxP9Di
	HG5fLdzTsYsv7G2v5OSQGzzzVftEtULqUm1dpRr/2MvBLQumZGRQnnIUTt3e/L3NykZIjy/lGCc
	yG8i2WcKvHpNmzhMWR7oq1hgZbf7smEivRYdIFoGmXrktfkTbnW3o5ninxPYlpLQ0LtEPV0YGCh
	8aHrtwiO97PefJHubw+GeqiQJjVRmLT+vvYAywRuh8nDOwwbh3Skm1Ywbrs=
X-Google-Smtp-Source: AGHT+IE/CAE8fTyyaZhNwnHqQ6DluWGob1BPPepxXx61Kxfg9bpG3qc3aCqfgSMh1y8Qa1MPv/AJwg==
X-Received: by 2002:a17:907:3f1a:b0:ad8:8717:bf9c with SMTP id a640c23a62f3a-ae057ef753fmr1060205766b.32.1750620221305;
        Sun, 22 Jun 2025 12:23:41 -0700 (PDT)
Received: from linaro.org ([82.79.186.23])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae054209a2dsm587665566b.174.2025.06.22.12.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Jun 2025 12:23:39 -0700 (PDT)
Date: Sun, 22 Jun 2025 22:23:36 +0300
From: Abel Vesa <abel.vesa@linaro.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	bvanassche@acm.org, andersson@kernel.org, neil.armstrong@linaro.org,
	konrad.dybcio@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
	quic_rdwivedi@quicinc.com, quic_cang@quicinc.com,
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V6 01/10] scsi: ufs: qcom: Prevent calling phy_exit
 before phy_init
Message-ID: <aFhYOMPdCiCL2EV7@linaro.org>
References: <20250526153821.7918-1-quic_nitirawa@quicinc.com>
 <20250526153821.7918-2-quic_nitirawa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250526153821.7918-2-quic_nitirawa@quicinc.com>

On 25-05-26 21:08:12, Nitin Rawat wrote:
> Prevent calling phy_exit before phy_init to avoid abnormal power
> count and the following warning during boot up.
> 
> [5.146763] phy phy-1d80000.phy.0: phy_power_on was called before phy_init
> 
> Fixes: 7bac65687510 ("scsi: ufs: qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()")
> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
