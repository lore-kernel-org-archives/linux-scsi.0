Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D7777F29
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706104527; cv=none; b=p2I3Folv1IdKdOPcWju3UPJAJZYIsE+GIpQEWrea4VQy89ab/7TkSAxyS+l/VLiD1X1wXH20kdtiKEefEUjT0C7BD/v8rYwsk6EqzziLh/Xszekgf1UxOgzjYxHAhs+yhlwZI1XzlW+UaxbOu4S3Qd6XfjyDoQdPHqXOEZoOwqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706104527; c=relaxed/simple;
	bh=uO6XYeao3+ERbDLbaGJYNsqD7iMh0uqxQitnp3GG0EI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ao/5nJflTqZRRUSWAwLptwRrpJVAzEqVS532FvCn61wlJrqLUvnFUlF5tS7TdtTv1ShLqByOiohd+RRnjfepzhdy60olKZ5SEhYMCQAdbs1jXVgIhtv+VRlvsAfyEkyIYJ6ofGxuC2sgXuWqQs+5BjR7QuhdUJn8HJffNvKXMao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OTM6V7ya; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OTM6V7ya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706104523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X2HNODfBS+JrHafscRLbwZLG2NmbTl5ZUi1igtTA3Vk=;
	b=OTM6V7ya17OWM2HIHSeqa1zalAGUkLm2g5OUfZhcxHd7Xbk1hgQ5UnukyWOM6YU2V8thGX
	6XCVKys9KMVcjcdVcxxnDq+0MgSyQM+iPVdXsyNYEDmm20Lzx/crwofVvNTPYehnKd0DXt
	S8SABQcCGYEaLcYKk1jNBYTyXChPoQ4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-7ua7ohG1PgGUVN_TDDU9vQ-1; Wed, 24 Jan 2024 08:55:22 -0500
X-MC-Unique: 7ua7ohG1PgGUVN_TDDU9vQ-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7831be985c0so833039385a.3
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 05:55:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706104522; x=1706709322;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2HNODfBS+JrHafscRLbwZLG2NmbTl5ZUi1igtTA3Vk=;
        b=SVs79Q6Xqc4+kRaUZwItC52xFB+FlsLyCMg6jd3JXmIx02WdWqQIVS/7WJkd9hAziv
         KECHET62VBDvVWG/1DcoyouCELy4fUCan3BW1HPyCdcB4lqedvZgwPS2smnOQoy79p2l
         /MqbJp6C2JDG44kH5dahcHxIF04IigHgOgojp9KD4n/83xRM8Fa5A6AujXJFsXwSP98r
         /nN05MvXk1eosufDjy16i1MSDv8EFrH5qmre3QYnqj/KQ4j3ln9xjCsVpACCHZoSJU+4
         8D2OH64HzK/jKw/qrmg3/kVq2HFqlZnM+r8H5Y6EJ308WfFGAl11rL1xRUKvCX7oSRZL
         OYGg==
X-Gm-Message-State: AOJu0YxMDKn3PE5/1jAKKmZolzgQFH1gH8NVlD1zc6dIW/HScafJYQSV
	zEAM/IvRALhrZc+0NVlMgMkak03xVs8EZS7L0lIL06L4qpr2qTeQOUDFfxmTtkxyCTWb4nLAEbh
	7lfr+sPyUfjQbM98KNuXFRDnW4T0bizkDQQrHwH+OreYwHZfqkLte+3ijYBo=
X-Received: by 2002:a05:620a:610a:b0:783:8071:2473 with SMTP id oq10-20020a05620a610a00b0078380712473mr8341380qkn.61.1706104521676;
        Wed, 24 Jan 2024 05:55:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGTtQXSI1MSoTfgWJ8tVH7siOJkHn3LOGpV6BWnWln+S7PK+ANFnpN3awurbecqz9jTWq6izA==
X-Received: by 2002:a05:620a:610a:b0:783:8071:2473 with SMTP id oq10-20020a05620a610a00b0078380712473mr8341369qkn.61.1706104521402;
        Wed, 24 Jan 2024 05:55:21 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::37])
        by smtp.gmail.com with ESMTPSA id m26-20020ae9e01a000000b0078392eacfd4sm3940574qkk.80.2024.01.24.05.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 05:55:20 -0800 (PST)
Date: Wed, 24 Jan 2024 07:55:18 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: qcom: avoid re-init quirk when gears match
Message-ID: <mzfbayn2yz2egmtv2lankxn3h7p4pglaqxallczzmcevkvnp5b@jplxt7yu6xae>
References: <20240123192854.1724905-4-echanude@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123192854.1724905-4-echanude@redhat.com>

On Tue, Jan 23, 2024 at 02:28:57PM -0500, Eric Chanudet wrote:
> On sa8775p-ride, probing the hba will go through the
> UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH path although the power info
> are same during the second init.
> 
> The REINIT quirk only applies starting with controller v4. For these,
> ufs_qcom_get_hs_gear() reads the highest supported gear when setting the
> host_params. After the negotiation, if the host and device are on the
> same gear, it is the highest gear supported between the two. Skip REINIT
> to save some time.
> 
> Signed-off-by: Eric Chanudet <echanude@redhat.com>

On the sa8775p-ride I have I see similar results to what you mention!
Thanks.

Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8775p-ride

> ---
> 
> v1 -> v2:
> * drop test against host->hw_ver.major >= 4 and amend description as a
>   result (Andrew/Mani)
> * add comment, test device gear against host->phy_gear and reset
>   host->phy_gear only if necessary (Mani)
> * Link to v1: https://lore.kernel.org/linux-arm-msm/20240119185537.3091366-11-echanude@redhat.com/
> 
> trace_event=ufs:ufshcd_init reports the time spent in ufshcd_probe_hba
> where the re-init quirk is performed:
> Currently:
> 0.355879: ufshcd_init: 1d84000.ufs: took 103377 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> With this patch:
> 0.297676: ufshcd_init: 1d84000.ufs: took 43553 usecs, dev_state: UFS_ACTIVE_PWR_MODE, link_state: UIC_LINK_ACTIVE_STATE, err 0
> 
>  drivers/ufs/host/ufs-qcom.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 39eef470f8fa..f7dba7236c6e 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -738,8 +738,17 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
>  		 * the second init can program the optimal PHY settings. This allows one to start
>  		 * the first init with either the minimum or the maximum support gear.
>  		 */
> -		if (hba->ufshcd_state == UFSHCD_STATE_RESET)
> -			host->phy_gear = dev_req_params->gear_tx;
> +		if (hba->ufshcd_state == UFSHCD_STATE_RESET) {
> +			/*
> +			 * Skip REINIT if the negotiated gear matches with the
> +			 * initial phy_gear. Otherwise, update the phy_gear to
> +			 * program the optimal gear setting during REINIT.
> +			 */
> +			if (host->phy_gear == dev_req_params->gear_tx)
> +				hba->quirks &= ~UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
> +			else
> +				host->phy_gear = dev_req_params->gear_tx;
> +		}
>  
>  		/* enable the device ref clock before changing to HS mode */
>  		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
> -- 
> 2.43.0
> 
> 

