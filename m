Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6507E148FE4
	for <linux-scsi@vger.kernel.org>; Wed,  3 Apr 2024 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712153529; cv=none; b=nNqqhHzCi+4QfSmprzO4US/KVHhyWJQUwNUyVxnYnlnvomjGw7IzVei3Ls2F8pKRcD5pUV5OepuaEckSlMyjZLn95NJMq6WMCEl7YQrtPIUrgKNyflM87GyOCAUh80bY1IdLPY1jB0Ayw+wvJC4uWqWl02GjAzQegOfeDQDfTBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712153529; c=relaxed/simple;
	bh=qCIolQRct0+IbGGd6jjPbW1ixYlGS5R/m+dU02mINLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebODO0XJS0lUsgCDvJ/5DDxnQaVU4xGJkmDhOdf35yeU8uPa6aFmXNOIpfGMozYpnQq9pu4F34bQGO5kpOS4nxzploTsEx+n1RUSegOUgFwLfue48SX3g8d0rO52V1bXquW4DXaReZnpL2fWdRn262aR7T1QPO8+kShZsjy4pQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lo/tyxa6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lo/tyxa6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712153527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r8o2fhiLcGwGsiCE3v1KVrR6VF/PZtpQmnAxVeKoH1c=;
	b=Lo/tyxa6QuY93qBcmkitP34oUd//GzJ4Q7kx5TgXIZaiH/2t5qrAfv4NMyBckchG50SRXw
	pTeoqcQFjG54DDLMISx0oImyMIBovNNbjEb0YYVUmNImyUx3KmkP66gEvQqNoTV0lYuOFU
	69Ps4nvTdolzmOHmVO4MUn5n6jf0E2k=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-SJReeuq6OluXqPueSFatew-1; Wed, 03 Apr 2024 10:12:06 -0400
X-MC-Unique: SJReeuq6OluXqPueSFatew-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-69649f1894dso76803456d6.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 Apr 2024 07:12:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712153525; x=1712758325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8o2fhiLcGwGsiCE3v1KVrR6VF/PZtpQmnAxVeKoH1c=;
        b=vOm6NY/ZX96inr0pYvrOaQUvljEnOM2rZsB6Ao3RsqJbskET520vMEXRKUbINhvN1b
         XGo3or+YPGj1UUT41rTJKn4UPtHbLXh3mqPYwhIEhqj3v9vdj7xjaYeHbxO/8MMkjwin
         h+6yR0bsumX66pyohwbv8lKhJWMHsMlHbDlIk6aDgdZyI49o6IEkTo4nGJGo5yA4T3ms
         pgr3YlH4TkiTtvyw/hX8Ve7lbOJHwNqBJjrJzfu99ma5VLb/MH9a4Rl690NkBgfHh/RI
         FUPh1K+6fgW+spBSc8pKfE1X81i5247EFioapGWxItHYDWCz+177CARQ18Dy4f27MSO0
         T7oA==
X-Forwarded-Encrypted: i=1; AJvYcCVq3ncfpUptBpIeS4ZId4IHkkeKnwvi9FrfjMbqCkHTJqkYb0i8ys3e3LdHRNyJg1Fs+Fdmg1zlfuUV6YzMRA1Pu7zg335IRozWgw==
X-Gm-Message-State: AOJu0YyCJ5ugBgm3BNk2qckOMKZaGquxTeDqW5/o54brgDkN9VvMDjlv
	2xQfzOz8a/3JRuPhLzf6Vhvr3qKKU6bQo6ob3W/YSetLmHdS0RG2L2TiGrdzniwhKrHlvGPLmor
	MAV5NqTH7sNjF9cN7g4o7v159jhWVgeyLwmoCotSZ7R/a/X9QjU4Dkw9187GCmaX95pk=
X-Received: by 2002:a0c:aad1:0:b0:699:1ff2:9a09 with SMTP id g17-20020a0caad1000000b006991ff29a09mr4124323qvb.24.1712153525089;
        Wed, 03 Apr 2024 07:12:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmph9CKAQHSAqdnGjo5kwoTYNhHOASdv2YNX6Z0heyycssEot4MPfxw4tGswUcwCvzRjjiGg==
X-Received: by 2002:a0c:aad1:0:b0:699:1ff2:9a09 with SMTP id g17-20020a0caad1000000b006991ff29a09mr4124299qvb.24.1712153524689;
        Wed, 03 Apr 2024 07:12:04 -0700 (PDT)
Received: from x1gen2nano ([2600:1700:1ff0:d0e0::33])
        by smtp.gmail.com with ESMTPSA id 11-20020a05621420cb00b006968a6fb010sm6531118qve.91.2024.04.03.07.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 07:12:04 -0700 (PDT)
Date: Wed, 3 Apr 2024 09:12:02 -0500
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs: qcom: Add sanity checks for gear/lane
 values during ICC scaling
Message-ID: <ju2shpvxlc5tkazvclggdrqtfxa2r7yqdz7i5lc4hpjlfw7wvg@fp34s6mvncm3>
References: <20240403-ufs-icc-fix-v2-0-958412a5eb45@linaro.org>
 <20240403-ufs-icc-fix-v2-2-958412a5eb45@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240403-ufs-icc-fix-v2-2-958412a5eb45@linaro.org>

On Wed, Apr 03, 2024 at 06:50:04PM +0530, Manivannan Sadhasivam wrote:
> Let's add the checks to warn the user if the ICC scaling is not supported
> for the gear/lane values and also fallback to the max value if that's the
> case.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 696540ca835e..79b4ce05f7c5 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -696,6 +696,16 @@ static struct __ufs_qcom_bw_table ufs_qcom_get_bw_table(struct ufs_qcom_host *ho
>  	int gear = max_t(u32, p->gear_rx, p->gear_tx);
>  	int lane = max_t(u32, p->lane_rx, p->lane_tx);
>  
> +	if (WARN_ONCE(gear > QCOM_UFS_MAX_GEAR,
> +		      "ICC scaling for UFS Gear (%d) not supported. Using Gear (%d) bandwidth\n",
> +		      gear, QCOM_UFS_MAX_GEAR))
> +		gear = QCOM_UFS_MAX_GEAR;
> +
> +	if (WARN_ONCE(lane > QCOM_UFS_MAX_LANE,
> +		      "ICC scaling for UFS Lane (%d) not supported. Using Lane (%d) bandwidth\n",
> +		      lane, QCOM_UFS_MAX_LANE))
> +		lane = QCOM_UFS_MAX_LANE;
> +
>  	if (ufshcd_is_hs_mode(p)) {
>  		if (p->hs_rate == PA_HS_MODE_B)
>  			return ufs_qcom_bw_table[MODE_HS_RB][gear][lane];
> 
> -- 
> 2.25.1
> 
> 

