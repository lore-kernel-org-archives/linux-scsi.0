Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eW396pJb"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6685D10EF
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 09:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702057575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eK8WutytSz3F60Rl2nxPhK1kwwDpKHRRkbGPCAgiMXQ=;
	b=eW396pJb0QzEBA7QieC8dp7ixoqFeAIcoP2dlElcvdW/vQj6NJ9CwT3up55LMHjBR9UcEH
	Ujc0KdcR6A7Gdlo89d7VgVGdh6mYIiURAQIO55CSZhsd5+A/+32URp2iAl7dUhwOznjkm5
	WzTcPWcH7XB1tRWCTg4YPM05+VWVk1c=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-sDrLJrwaM--rPYSOanDBrw-1; Fri, 08 Dec 2023 12:46:14 -0500
X-MC-Unique: sDrLJrwaM--rPYSOanDBrw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-77f38f2f6fbso348064785a.0
        for <linux-scsi@vger.kernel.org>; Fri, 08 Dec 2023 09:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702057574; x=1702662374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eK8WutytSz3F60Rl2nxPhK1kwwDpKHRRkbGPCAgiMXQ=;
        b=mGvS78rVZ7dJncp4500SoYJeQIAW0sWfBcLZ0808e+04bL2rsEfz6mzPYMbhGyuauO
         QtOwPHxIlFJ0VhjBAmcVXZ5A4X/OjDuwf4Hh1PPI2mCVsWe/M2IXRYBRPI2Bc2yRsq8M
         zR/0mOgJUL9tdJgYBhpqruAb2l2AFRMSIuiwPCTQAgShyXM1/w2aRqdUHgWJA5RC0ynL
         T5eeIgFvQdopXs2Y+N15II3g3CuxwOtieWi98vbasl/lH1DCFWWAx5Sicrm3KwuR2SJg
         8GXl48+iCJsZj5Tf/MYtrSuZeRY+Vc1BxQBqVm2UT+n3vLqDPRhhdTWs1HtsDUr32n4/
         MPvw==
X-Gm-Message-State: AOJu0YwP/Siq26qVbVdsQiYUUBrAY15L1A+t2FMBVbVlCHC719XvQi7m
	CAaDNBSO3nMYc6bWZi0KqXz4E7wrd08oqFEcdoOQqCJUzNzRB6B2FeHjfW+JQADnDoct+kCOWmD
	Wyx3KYkTErQqH5KyQfMggsw==
X-Received: by 2002:a05:620a:24d6:b0:77f:56f7:8a8a with SMTP id m22-20020a05620a24d600b0077f56f78a8amr1178693qkn.20.1702057573957;
        Fri, 08 Dec 2023 09:46:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKpXkgN5JW84WjaqfJ/Jad2WtjBPYW0HrpnzHhaUBDSgtALPzLuH10yyRlapWlhpBegIs/HQ==
X-Received: by 2002:a05:620a:24d6:b0:77f:56f7:8a8a with SMTP id m22-20020a05620a24d600b0077f56f78a8amr1178678qkn.20.1702057573706;
        Fri, 08 Dec 2023 09:46:13 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id i19-20020a056214031300b0067aa164861dsm967730qvu.35.2023.12.08.09.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 09:46:13 -0800 (PST)
Date: Fri, 8 Dec 2023 11:46:11 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com, quic_nitirawa@quicinc.com
Subject: Re: [PATCH v2 14/17] scsi: ufs: qcom: Simplify
 ufs_qcom_{assert/deassert}_reset
Message-ID: <uz6ely7fzsejqnrelmqtqt4lofjvcfxxywro6ae2lfbrfnqtpl@rnyneul7eazo>
References: <20231208065902.11006-1-manivannan.sadhasivam@linaro.org>
 <20231208065902.11006-15-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231208065902.11006-15-manivannan.sadhasivam@linaro.org>

On Fri, Dec 08, 2023 at 12:28:59PM +0530, Manivannan Sadhasivam wrote:
> In both the functions, UFS_PHY_SOFT_RESET contains the mask of the reset
> bit. So this can be passed directly as the value to be written for
> asserting the reset. For deasserting, 0 can be passed.
> 
> This gets rid of the FIELD_PREP() inside these functions and also
> UFS_PHY_RESET_{ENABLE/DISABLE} definitions.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

Reviewed-by: Andrew Halaney <ahalaney@redhat.com>

> ---
>  drivers/ufs/host/ufs-qcom.h | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index 53db424a0bcb..a109d3359db4 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -92,9 +92,6 @@ enum {
>  #define TEST_BUS_SEL		GENMASK(22, 19)
>  #define UFS_REG_TEST_BUS_EN	BIT(30)
>  
> -#define UFS_PHY_RESET_ENABLE	1
> -#define UFS_PHY_RESET_DISABLE	0
> -
>  /* bit definitions for REG_UFS_CFG2 register */
>  #define UAWM_HW_CGC_EN		BIT(0)
>  #define UARM_HW_CGC_EN		BIT(1)
> @@ -157,8 +154,7 @@ ufs_qcom_get_controller_revision(struct ufs_hba *hba,
>  
>  static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
>  {
> -	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, FIELD_PREP(UFS_PHY_SOFT_RESET, UFS_PHY_RESET_ENABLE),
> -		    REG_UFS_CFG1);
> +	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, UFS_PHY_SOFT_RESET, REG_UFS_CFG1);
>  
>  	/*
>  	 * Make sure assertion of ufs phy reset is written to
> @@ -169,8 +165,7 @@ static inline void ufs_qcom_assert_reset(struct ufs_hba *hba)
>  
>  static inline void ufs_qcom_deassert_reset(struct ufs_hba *hba)
>  {
> -	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, FIELD_PREP(UFS_PHY_SOFT_RESET, UFS_PHY_RESET_DISABLE),
> -		    REG_UFS_CFG1);
> +	ufshcd_rmwl(hba, UFS_PHY_SOFT_RESET, 0, REG_UFS_CFG1);
>  
>  	/*
>  	 * Make sure de-assertion of ufs phy reset is written to
> -- 
> 2.25.1
> 

