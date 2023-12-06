Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QeReSFD1"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA039A
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 10:53:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701888593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2YDjLMepeuXQAOfLexw9wJ/G5xIz4DXfzdIVQzgockk=;
	b=QeReSFD1qSWnBZlcAiBbDi7WmqfaXD4ng0gu25pgl/IUmi2VecXhwEQQ+fIE4AYv7IGko7
	26UqS1FYQnBiMWR7jh1DjUyvCGp/4beVJtf10DwFvhse8m5FCh+Auuhdtgg1jQkryh51cY
	hSpYTewXPUt6iJi6WO03tnaqyGDS5hE=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-aapF-b4yPIS0FwgGDEoanw-1; Wed, 06 Dec 2023 13:41:32 -0500
X-MC-Unique: aapF-b4yPIS0FwgGDEoanw-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1faeac8b074so506838fac.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 10:41:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701888091; x=1702492891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YDjLMepeuXQAOfLexw9wJ/G5xIz4DXfzdIVQzgockk=;
        b=INsSQjRb4fCiSW4wGCNlgxOnfgjjRHlVMuD0s0nx5VfRrczgvEQrnK8VPLFybsweaM
         2lpv4c5YyCV6njQo8y51guugJpeJESz4hLKAjBVw7Ee8OiQphYj5fO1DbYji0iKokQtf
         NnP/fvqMjdaPZjLxCkk9mRoGfZ0KARE2gfN4mv8oCRv+3Iy3V3/d4/2qveUwP5NhV4wV
         IoutReGc1uRF8mCJ19hPxObQwNDVdT7fwYBeSqr1REhUnNn3vaYFH/bwlzsuz4CBpiY4
         MAJwH+ttbXdt0mvkziFMlCUPbiv+BHQB5/NNG+CxNN4ExEupIXiw5ulCe3KQsHT7Pri6
         IGxQ==
X-Gm-Message-State: AOJu0YwJsi3QfEtVGYaaq/Dy4MdM2kUTpBaiBm3yiaRYKfngER93SvO+
	lEXjeuySM+fgDze8U0aGy5ZFtMfWRL1gUpOe5uS6zGn0gaFDjGjrU+p5yHCUq/g7GIkaStHzjjq
	dBe7VB+fxNH/kF7c8nFGZCQ==
X-Received: by 2002:a05:6871:3402:b0:1fb:d89:48c3 with SMTP id nh2-20020a056871340200b001fb0d8948c3mr1475757oac.27.1701888091168;
        Wed, 06 Dec 2023 10:41:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEh12IvLMDJGznFqN4fzVBxPyYWXOTCG2Cau5TEzfYtnO6TcRlyHWdIYXkx8j3uxxYSu2oFjg==
X-Received: by 2002:a05:6871:3402:b0:1fb:d89:48c3 with SMTP id nh2-20020a056871340200b001fb0d8948c3mr1475741oac.27.1701888090916;
        Wed, 06 Dec 2023 10:41:30 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id r6-20020a056870e8c600b001fadabf6626sm91503oan.23.2023.12.06.10.41.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:41:30 -0800 (PST)
Date: Wed, 6 Dec 2023 12:41:28 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com
Subject: Re: [PATCH 07/13] scsi: ufs: qcom: Fail ufs_qcom_power_up_sequence()
 when core_reset fails
Message-ID: <iecwyzsamuwhatodicsfptf3dgl5nglrdqyennmhagpjz7yrtr@r72gejcvhi6w>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-8-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201151417.65500-8-manivannan.sadhasivam@linaro.org>

On Fri, Dec 01, 2023 at 08:44:11PM +0530, Manivannan Sadhasivam wrote:
> Even though core_reset is optional, a failure during assert/deassert should
> be considered fatal, if core_reset is available. So fail
> ufs_qcom_power_up_sequence() if an error happens during reset and also get
> rid of the redundant warning as the ufs_qcom_host_reset() function itself
> prints error messages.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 604273a22afd..4948dd732aae 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -359,8 +359,7 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>  	/* Reset UFS Host Controller and PHY */
>  	ret = ufs_qcom_host_reset(hba);

I noticed that ufs_qcom_host_reset() doesn't return an error if
reset_control_deassert() fails. Can you address this in the next spin of
the series (I don't think its in the following patches that I glanced
through).

Thanks,
Andrew

>  	if (ret)
> -		dev_warn(hba->dev, "%s: host reset returned %d\n",
> -				  __func__, ret);
> +		return ret;
>  
>  	/* phy initialization - calibrate the phy */
>  	ret = phy_init(phy);
> -- 
> 2.25.1
> 
> 

