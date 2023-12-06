Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J7kxsOcJ"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E58139
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 10:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701887806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KvnpSQri5arb6xwcBFDZQI0HnLnuARbU/naBERSZQac=;
	b=J7kxsOcJmbw8hvlEOmPPESWUvXkIl0cnei4GDFfz449w4msCzJREp+IAYyYNKZKkN1DF6R
	wOZwQcQyNr6T+e7UJ0t4nEZJPyyaJJ9+oxK7UVYpDijGJCeVI19LkWFeL2k9bm6iAIuIy5
	vqwpNcwss0iXszEBD19i+nhczW9MM0g=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-389-Nnl6CuEJPPyEIRK-6uIxdg-1; Wed, 06 Dec 2023 13:36:45 -0500
X-MC-Unique: Nnl6CuEJPPyEIRK-6uIxdg-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-58dad14ab40so55601eaf.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 10:36:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701887804; x=1702492604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KvnpSQri5arb6xwcBFDZQI0HnLnuARbU/naBERSZQac=;
        b=wfQPXPqjn3YxQJeFugmTH4mtYNw4IytZIsDxR+f0wfYEQH7gVsR4KdN+DSPvOEe+PZ
         7aK2QxP2iOOWp7NxShQ8AHghw09Oie5esZOOtQLuXeNkRzmZpMHY2jGeZxzpywig43QG
         2SEqMvWlJeKPhYy+JjMBUD6xQX50Vk4mZQ+F+9551V76KHcvHQfWxNHR6q7Lbmhmyzyy
         R1dWtHHfXNg7Fy/T//X7XjoRwAsmwpQ8R5EMyoP1CQunI51bRqWT51ZC8d8x0qNTf+y0
         LiHZKF1U/RATEHZ9EIsPYpoEyTKq/hwfJx9PihMVnavSgTDxlgxcBVkBjpRPKGHcbuK9
         zd9g==
X-Gm-Message-State: AOJu0Yw2nTVWweMa7p7Ym0zp54bdybpUc6Y9WbvjdRa1hG0083l8P+Oc
	1rkmNeOG7mByisw35eoazC8Ebt2EpJkU5QzhsGdV2CX3qAWeqEPK9HiDAJQp10lSgwNiNhgSmqo
	8/GjkyrAnP289m9KrFpCfmA==
X-Received: by 2002:a05:6358:7206:b0:16d:fe33:4c63 with SMTP id h6-20020a056358720600b0016dfe334c63mr1635755rwa.24.1701887804315;
        Wed, 06 Dec 2023 10:36:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVXVpDI2N4zq6TmLP+46EyCJXTztwSBXqvdJFhrfnSKXRuRptwKjhGCPJ0XHZcWj52RCTA0Q==
X-Received: by 2002:a05:6358:7206:b0:16d:fe33:4c63 with SMTP id h6-20020a056358720600b0016dfe334c63mr1635747rwa.24.1701887803917;
        Wed, 06 Dec 2023 10:36:43 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id g7-20020ac84807000000b004258264d166sm149989qtq.60.2023.12.06.10.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:36:43 -0800 (PST)
Date: Wed, 6 Dec 2023 12:36:41 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com
Subject: Re: [PATCH 05/13] scsi: ufs: qcom: Remove the warning message when
 core_reset is not available
Message-ID: <ru2zdpls5tx2wjt3oknqndikuc4we7d3haeawzrdyl7cbsycti@clx55b27nzvn>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-6-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201151417.65500-6-manivannan.sadhasivam@linaro.org>

On Fri, Dec 01, 2023 at 08:44:09PM +0530, Manivannan Sadhasivam wrote:
> core_reset is optional, so there is no need to warn the user if it is not
> available (that too not while doing host reset each time).

What's the bit in the parenthesis mean here? I'm having a hard time
following. Otherwise, this looks good to me.

> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/ufs/host/ufs-qcom.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index dc93b1c5ca74..d474de0739e4 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -296,10 +296,8 @@ static int ufs_qcom_host_reset(struct ufs_hba *hba)
>  	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  	bool reenable_intr;
>  
> -	if (!host->core_reset) {
> -		dev_warn(hba->dev, "%s: reset control not set\n", __func__);
> +	if (!host->core_reset)
>  		return 0;
> -	}
>  
>  	reenable_intr = hba->is_irq_enabled;
>  	disable_irq(hba->irq);
> -- 
> 2.25.1
> 
> 

