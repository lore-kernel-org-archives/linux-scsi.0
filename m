Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2091898FB;
	Thu, 12 Dec 2024 22:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734042065; cv=none; b=L5YeO5CMHA325+b67IKOy+m/4ov/1ZSXHUvPDI3Mc2wNF8fA6gJ7EwdbpVraCkeZ4iQBZsh7dBAltRJqNbm2RtpSETvENk6rLbdiutf3n1V/aOKOFGlw9+rNo5+kMqg6+QG9U45rJdxhQFkNhna7fz76Wob1e3uy6vstqCeIZbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734042065; c=relaxed/simple;
	bh=fbcp7kRVdrdG/+lofIHykddjUrr2VdJGhMH9O/gNX2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZnYtZbq15J3d53JO/P3X+LE+ehPE8zcjS7jmybjW56T0YNJdGHT++sKTMO9gebxhTg9e9nh1YvSQmjj8V5qn2k6cryRSmu8yxFlGatQMi1C7FHt0A+yLjiw/5xJtmaVmrb1+9uLTIzlA/B4LCF2L7vFlvLnBtj8DHabD1Nutbts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.2] (unknown [95.90.243.58])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 0AA2861E64786;
	Thu, 12 Dec 2024 23:20:46 +0100 (CET)
Message-ID: <1e0eb9ca-6edc-4ce7-b62f-d34ca254fe52@molgen.mpg.de>
Date: Thu, 12 Dec 2024 23:20:42 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode
 directly to 1
To: Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 James Bottomley <JBottomley@Parallels.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20241212221817.78940-1-pmenzel@molgen.mpg.de>
 <20241212221817.78940-2-pmenzel@molgen.mpg.de>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20241212221817.78940-2-pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[Remove non-working @lsi.com addresses]

Am 12.12.24 um 23:18 schrieb Paul Menzel:
> Currently, the code does:
> 
>      if (x == 0) {
>      	x &= ~0x3;
> 	x |= 0x1;
>      }
> 
> Zeroing bits 0 and 1 of a variable that is 0 is not necessary. So
> directly set the variable to 1.
> 
> Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
> ---
>   drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 87fcafce947c..2cd0bb606d88 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -5629,8 +5629,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
>   	if (!ioc->is_gen35_ioc && ioc->manu_pg11.EEDPTagMode == 0) {
>   		pr_err("%s: overriding NVDATA EEDPTagMode setting from 0 to 1.\n",
>   		    ioc->name);
> -		ioc->manu_pg11.EEDPTagMode &= ~0x3;
> -		ioc->manu_pg11.EEDPTagMode |= 0x1;
> +		ioc->manu_pg11.EEDPTagMode = 0x1;
>   		mpt3sas_config_set_manufacturing_pg11(ioc, &mpi_reply,
>   		    &ioc->manu_pg11);
>   	}
