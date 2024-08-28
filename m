Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA7D173328
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 13:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724851900; cv=none; b=QSBWxtEauPJp2T8VWbLq0w9ZeywkNam0MHx2kcIx3020NndSRqf2yXeiACO0D3WI93+x5vZ/EvPb3u3nHQi4UOIFSfTzi5593eIKORU88965cOZ+RASxik6q0lKwTkeRIpg/4/O6e80FN8Pnahd52GMyvcjbIGAZhQID1Gw9LFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724851900; c=relaxed/simple;
	bh=aFunOdE2IWWGEtEGitXEh2j1fwzDFTJ8EAELatQZE60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tTgw5volyMJofPO+419IxmgKyA5lJ7q0K2xZtAA8ACmzzNTiz7FbMU28+J857ffGwVLrJeGjjAq6yspAKyzpRq0xjnPPTOJRBFBIylpbfTctNUSK0noLg4MW/1JezMf649NMMc6PDVA+GD2tyFvjQTNL/eyuJDEZK2SC/o7eWUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FhQyBlfB; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FhQyBlfB"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71430e7eaf8so5409094b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 06:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1724851898; x=1725456698; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ooxQLoKfDn6EQlD0rIDPMhXYCiCug8IilBfMsi5Lan0=;
        b=FhQyBlfBWoSppDFD4YNSBTqpYsxopU57NUtDNrrc5MzqPoECOvN1Tjx6Yx0QKsEhma
         Y39nhL9aLi76Tw44SV0mqUJpZ+GB0PM7lfxA90gGqz8V2L6+XbCYSlRJ5yw99PdYm+Rq
         f7peM0Mtu0A8GMXHkRjDAgayUQsSZltK2AfPZ7daeedAz9rp36IeXSHdhpVZECpISX/A
         OLW2PoXpOaoJbqsGyiqkEPEDOC0yPKjPNen88GU8LoZLYsLINOy9B0cOWHguqUmhJu10
         aZTVkmgvKj0pezUIVFvpr2uKeyX8Co7+fID4YMW3HHZGj2SSz6LqpeWEequH2N/cSmc1
         1IOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724851898; x=1725456698;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ooxQLoKfDn6EQlD0rIDPMhXYCiCug8IilBfMsi5Lan0=;
        b=Sz6ZNOPuFroREleiODr6t17MLn8IoQCR6i2WF/OW4Rnyu4/58hUJO2cRplbABsRy9J
         FUaVjq6NN2p+PDUO3a4iU6v161j9X6XJt3xUXoVFEthIU+WIf6SvpRjJOxgHu+ADevKD
         xTF3MddbfYP8zPbIjmZtJCOcfXyAb4BZKQULxU74IIsqZ62chQApGHG8hp6RoP7a/fhc
         GqaWqPaEIS5AoZDhnW90iox2CUvKk4jOqQ6OpWNV7w3kcXPUUi71MPzCu8Uab49Wpvcx
         6f3uDK9ZhDET1IQyGAp4vAoE/TAB9NErnqZmQOU1SPvbuZsmWjxRYaPMht+hedWRkwjU
         HnmQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/KnA1lkkfj43p8I3cuJ9jQp77dfGnBQIyXcjvDnZolM9o3WNzPF9f1fkZV+akyPfx0Vys5ckHavH6@vger.kernel.org
X-Gm-Message-State: AOJu0YwuR7THUBteozJFFNnz9L1Pb7N7B7/0Gg8JnPjeU9L4k/KeWHQ5
	RBDpOQ/miyfGFh1GDJtIPcFs7DjndRRf9YiAU5psU+xwPaiBBH7Vl2CoAr63Tg==
X-Google-Smtp-Source: AGHT+IEINpO4o8xwOCNrCh0RMflT1QvZim19vykwVlDpRWD2mxcSv4yYUaeulVY/t40l8zuo0u5EGg==
X-Received: by 2002:a05:6a00:92a4:b0:710:7fd2:c91 with SMTP id d2e1a72fcca58-714458b4330mr18935675b3a.26.1724851898012;
        Wed, 28 Aug 2024 06:31:38 -0700 (PDT)
Received: from thinkpad ([120.56.198.191])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71434316405sm10101761b3a.162.2024.08.28.06.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2024 06:31:37 -0700 (PDT)
Date: Wed, 28 Aug 2024 19:01:32 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Manish Pandey <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com,
	quic_bhaskarv@quicinc.com, quic_narepall@quicinc.com,
	quic_rampraka@quicinc.com, quic_cang@quicinc.com,
	quic_nguyenb@quicinc.com
Subject: Re: [PATCH V2] scsi: ufs: qcom: update MODE_MAX cfg_bw value
Message-ID: <20240828133132.zqozjegmbnwa7byb@thinkpad>
References: <20240828132526.25719-1-quic_mapa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240828132526.25719-1-quic_mapa@quicinc.com>

On Wed, Aug 28, 2024 at 06:55:26PM +0530, Manish Pandey wrote:
> The cfg_bw value for max mode was incorrect for the Qualcomm SoC.

What do you mean by 'incorrect'? I extracted the value from downstream DTs. So
it cannot be incorrect.

If you want to update it, please clearly provide the reason.

And if this patch is addressing an issue, then a Fixes tag should be present. If
you want to get it backported (if it is a critical fix), then stable list should
be CCed.

- Mani

> Update it to the correct value for cfg_bw max mode.
> 
> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index c87fdc849c62..ecdfff2456e3 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -93,7 +93,7 @@ static const struct __ufs_qcom_bw_table {
>  	[MODE_HS_RB][UFS_HS_G3][UFS_LANE_2] = { 1492582,	204800 },
>  	[MODE_HS_RB][UFS_HS_G4][UFS_LANE_2] = { 2915200,	409600 },
>  	[MODE_HS_RB][UFS_HS_G5][UFS_LANE_2] = { 5836800,	819200 },
> -	[MODE_MAX][0][0]		    = { 7643136,	307200 },
> +	[MODE_MAX][0][0]		    = { 7643136,	819200 },
>  };
>  
>  static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
> -- 
> 2.17.1
> 

-- 
மணிவண்ணன் சதாசிவம்
