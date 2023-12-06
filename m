Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R7CY63/a"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9B8D42
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 10:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701886323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8GLvrKoKXfs9q6sXMVVNDve2BGCY9TgxYq7d8xwgVO8=;
	b=R7CY63/a30FnzPaLT6lC/2Pc+TslmQojSC5dzNEx10hvn2jv92xIX+nOjcqhRG0sWgXEo1
	1Fu4XCeN20JDJM0VThkX1X+273EVqfha6rdQLCe4i4GbVcJK3qN3J1JDKsQ4X25iAKvZcQ
	5doF7zOfxkaa0puX8g/N2BudAMCIA0U=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-r_nzzk4hOF61IxA5lx4b0g-1; Wed, 06 Dec 2023 13:11:11 -0500
X-MC-Unique: r_nzzk4hOF61IxA5lx4b0g-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3b8b8d6f94cso155197b6e.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Dec 2023 10:11:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701886270; x=1702491070;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8GLvrKoKXfs9q6sXMVVNDve2BGCY9TgxYq7d8xwgVO8=;
        b=vXB9ctyWABXEwOs/yG/w2qtIuvgPSsI5ntf1eyRaZDNP4UcXBmCqEmx6HYH7mDu+Tr
         fCw8wRQAEKh85HfzdCb4SFVtQW/8O++WGvNGI1FQZSs1TG+BpH+qFioLtamTXEQbPlnj
         JBRARHjSUZFv384AwI7N2T0weCTwyzAlpnfUWvscd8RoBAfRDBG/mEzhD8yli6knbGv/
         vmv7A+w+xAVaQidCUuvn6kZPwIu5SDHfsl/lZhy9OxgTYsVaSXNbfwko09YebCUj8mNm
         1++vQPdQIxAV80UM+3jBs6OWLKkmHodnDkDBBwS6tXEvvf7u9baxQxLfjKtn6uaQ7C4F
         OPpQ==
X-Gm-Message-State: AOJu0YxpAXFtqx4SzrYHwpxoQTg2P1cs0nd1iT7MVVESS/tKtPgBbQHt
	5o4u5CX6TrwnwIRPbR8KZ7xGa4J1lrHF9KP+n0HPK52hs6GSAqN3Z8djulB63KPs24Ud6N4Lrdo
	CvdqujaxqV7J9HBMxDic+SA==
X-Received: by 2002:a05:6808:a98:b0:3b8:b063:9b4f with SMTP id q24-20020a0568080a9800b003b8b0639b4fmr1237614oij.65.1701886270652;
        Wed, 06 Dec 2023 10:11:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrWCDztRBTCTdptmOIMb3QLVRY8x4frkDSfMXpFws1PJaXtsjQQA314rFK/H2U63UzkloaQw==
X-Received: by 2002:a05:6808:a98:b0:3b8:b063:9b4f with SMTP id q24-20020a0568080a9800b003b8b0639b4fmr1237600oij.65.1701886270419;
        Wed, 06 Dec 2023 10:11:10 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id p21-20020ac84095000000b004255a974865sm141189qtl.18.2023.12.06.10.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 10:11:10 -0800 (PST)
Date: Wed, 6 Dec 2023 12:11:08 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com
Subject: Re: [PATCH 03/13] scsi: ufs: qcom: Fix the return value when
 platform_get_resource_byname() fails
Message-ID: <zxubx2deqdjkxg774d2mbqo66t7hlapg2vlvrraqawoemlywof@c7rs3mnzjppd>
References: <20231201151417.65500-1-manivannan.sadhasivam@linaro.org>
 <20231201151417.65500-4-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201151417.65500-4-manivannan.sadhasivam@linaro.org>

On Fri, Dec 01, 2023 at 08:44:07PM +0530, Manivannan Sadhasivam wrote:
> The return value should be -ENODEV indicating that the resource is not
> provided in DT, not -ENOMEM. Fix it!
> 
> Fixes: c263b4ef737e ("scsi: ufs: core: mcq: Configure resource regions")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 852179e456f2..778df0a9c65e 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1701,7 +1701,7 @@ static int ufs_qcom_mcq_config_resource(struct ufs_hba *hba)
>  		if (!res->resource) {
>  			dev_info(hba->dev, "Resource %s not provided\n", res->name);
>  			if (i == RES_UFS)
> -				return -ENOMEM;
> +				return -ENODEV;
>  			continue;
>  		} else if (i == RES_UFS) {
>  			res_mem = res->resource;
> -- 
> 2.25.1
> 
> 

