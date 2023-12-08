Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ob4atZ98"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2327F9
	for <linux-scsi@vger.kernel.org>; Fri,  8 Dec 2023 10:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702058528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9qHbNmKCbRXKfDodfgnE19Rz7E5pNVFMc7J+Qm/f35E=;
	b=Ob4atZ98WJqfp2qd5kRMC3EO2egzErsA1+dS/0V/2xcpPWJj7bbBVbkfqEbLgViaeK+bHd
	oqbvOo3B6w+6fVsr7YwWUVtDFy61A0HS5anKgC8MXD7/pBy8gySbWqe9roYZuj0dWIWQnz
	uWMX4J3ShLsp4Vsoj7Kw3V43D6q9HFY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-0KIHDxoaMYaAwbOzCplzww-1; Fri, 08 Dec 2023 13:02:06 -0500
X-MC-Unique: 0KIHDxoaMYaAwbOzCplzww-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-77f37b54031so246953185a.2
        for <linux-scsi@vger.kernel.org>; Fri, 08 Dec 2023 10:02:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702058526; x=1702663326;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qHbNmKCbRXKfDodfgnE19Rz7E5pNVFMc7J+Qm/f35E=;
        b=s37imIKgjO/ro08mNQrFfQNLV7UCKw8AlNThhPRf9+K/tGcyAjI81MGwXvzJvhZ0jB
         DtPsril8ZdYsJPat0gh8FDd4ZkylDMj73toRqzut0RAnAD7YzawiTN15VmUk18GcSsAR
         5INabxiMAhD8Pa/xr1SOOedmKWgw2qZ3osNy8uX+4HGLXrKUs9t+l2B0CZYQrfJ6dbnh
         H4phKwnIDwufCyn+Hm81hgtrcLEmqSYxvuBwmnYEGjcIl+lko/Y5Jf84C+xJnNYq8xlr
         wV2+36hBk+jQK1Nbn77HxXbUoKUG4vswJwrb3nuDd9+YOYXstMIuXmQd3dOdLipHwwqJ
         JMKw==
X-Gm-Message-State: AOJu0YyM4WDQpqsUa9NoYfuAQaOl0n0U31+gIKFsGVBPXtVhblIWwXYF
	tumx0CD4F/QGD4wZEJi2B88TSFbviWxJENQiqrQQwdV/VplUu2oOvKOcSW2E10eGH69R+QDYhJN
	oOb/SrQ18Ck4sQ1apxu54JA==
X-Received: by 2002:ae9:e411:0:b0:775:f798:91f8 with SMTP id q17-20020ae9e411000000b00775f79891f8mr455358qkc.60.1702058525982;
        Fri, 08 Dec 2023 10:02:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMMPXI4Ku+pPrgDliP0bMlakUEM58/FoT0WzuMb0UiySdhc1l7/jjs5zDAT8p8KswgMfCyJw==
X-Received: by 2002:ae9:e411:0:b0:775:f798:91f8 with SMTP id q17-20020ae9e411000000b00775f79891f8mr455344qkc.60.1702058525702;
        Fri, 08 Dec 2023 10:02:05 -0800 (PST)
Received: from fedora ([2600:1700:1ff0:d0e0::47])
        by smtp.gmail.com with ESMTPSA id i15-20020ac871cf000000b004257afd873fsm978260qtp.35.2023.12.08.10.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 10:02:05 -0800 (PST)
Date: Fri, 8 Dec 2023 12:02:03 -0600
From: Andrew Halaney <ahalaney@redhat.com>
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: martin.petersen@oracle.com, jejb@linux.ibm.com, andersson@kernel.org, 
	konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, quic_cang@quicinc.com, quic_nitirawa@quicinc.com
Subject: Re: [PATCH v2 16/17] scsi: ufs: qcom: Use ufshcd_rmwl() where
 applicable
Message-ID: <wkykvnfc6qmrfy3j4h765gifm2scsrjmxs24nx2lkwakgt6jvv@k5lcdsubrb4o>
References: <20231208065902.11006-1-manivannan.sadhasivam@linaro.org>
 <20231208065902.11006-17-manivannan.sadhasivam@linaro.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231208065902.11006-17-manivannan.sadhasivam@linaro.org>

On Fri, Dec 08, 2023 at 12:29:01PM +0530, Manivannan Sadhasivam wrote:
> Instead of using both ufshcd_readl() and ufshcd_writel() to read/modify/
> write a register, let's make use of the existing helper.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/ufs/host/ufs-qcom.c | 12 ++++--------
>  drivers/ufs/host/ufs-qcom.h |  3 +++
>  2 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index 26aa8904c823..549a08645391 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -387,9 +387,8 @@ static int ufs_qcom_power_up_sequence(struct ufs_hba *hba)
>   */
>  static void ufs_qcom_enable_hw_clk_gating(struct ufs_hba *hba)
>  {
> -	ufshcd_writel(hba,
> -		ufshcd_readl(hba, REG_UFS_CFG2) | REG_UFS_CFG2_CGC_EN_ALL,
> -		REG_UFS_CFG2);
> +	ufshcd_rmwl(hba, REG_UFS_CFG2_CGC_EN_ALL, REG_UFS_CFG2_CGC_EN_ALL,
> +		    REG_UFS_CFG2);
>  
>  	/* Ensure that HW clock gating is enabled before next operations */
>  	mb();
> @@ -1689,11 +1688,8 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
>  		platform_msi_domain_free_irqs(hba->dev);
>  	} else {
>  		if (host->hw_ver.major == 6 && host->hw_ver.minor == 0 &&
> -		    host->hw_ver.step == 0) {
> -			ufshcd_writel(hba,
> -				      ufshcd_readl(hba, REG_UFS_CFG3) | 0x1F000,
> -				      REG_UFS_CFG3);
> -		}
> +		    host->hw_ver.step == 0)
> +			ufshcd_rmwl(hba, ESI_VEC_MASK, 0x1f00, REG_UFS_CFG3);

Is this right? I feel like you accidentally just shifted what was written
prior >> 4 bits.

Before: 0x1f000
After:  0x01f00

>  		ufshcd_mcq_enable_esi(hba);
>  	}
>  
> diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
> index 385480499e71..2ce63a1c7f2f 100644
> --- a/drivers/ufs/host/ufs-qcom.h
> +++ b/drivers/ufs/host/ufs-qcom.h
> @@ -102,6 +102,9 @@ enum {
>  #define TMRLUT_HW_CGC_EN	BIT(6)
>  #define OCSC_HW_CGC_EN		BIT(7)
>  
> +/* bit definitions for REG_UFS_CFG3 register */
> +#define ESI_VEC_MASK		GENMASK(22, 12)
> +

I'll leave it to someone with the docs to review this field. It at least
contains the bits set above, fwiw. It would be neat to see that
converted to using the field + a FIELD_PREP to set the bits IMO, but I
honestly don't have a lot of experience using those APIs so feel free to
reject that.

>  /* bit definitions for REG_UFS_PARAM0 */
>  #define MAX_HS_GEAR_MASK	GENMASK(6, 4)
>  #define UFS_QCOM_MAX_GEAR(x)	FIELD_GET(MAX_HS_GEAR_MASK, (x))
> -- 
> 2.25.1
> 

