Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C101DD0C7
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 06:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742280268; cv=none; b=CBnDqCQ9BsdJxnVHQxtuR6W+i7ijd/7ng7dwWRIuiez5RsUnRhnD1J8RAI4+f85TtSKFhlxkTwdfJAI2LcryDDJoLsJschvh7bwIFqRezrdjMKLCyHbXY3c4qA6kzIO5zGn/kkzQBqh3V3V404frjAkxNrrHlqXmjWEex+9SL2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742280268; c=relaxed/simple;
	bh=SV9DG6e6mgA/lOSmt6NefQ8XUMo16/bUKqUU1uGTEag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epb1J/Uhmiif0xHEmp7k67hybmn123Y4dNiACiQaCaYK46OELDaBSTCyPzIzp8QfDN3GWCPzRyXOAjniXSnX4pwMdnDIB+1vUCIcKbVZaNQvbeyTjkX6MPqJ4X9RXyU0vRzlfnny1sKXv1QWDDvnvp659+HyHRk0w3Kx2TNYyc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aPvUm0i9; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aPvUm0i9"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22403cbb47fso95543335ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 23:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742280266; x=1742885066; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AXbeE+q9B8uny1O22+JXIAcL6hxd+XvgftLgch9dqZ4=;
        b=aPvUm0i9qEkd4ObL0B9xJC1M6DGa8vxK2pAqRj41rHCnSiv+XCqIs2HJsQPrhoue22
         KHMPOGwrqJC9oYP1liNOrukg0txEZV2nmbe8tgsyyLLKDcc4wzCBbjHTu+ABQM/XuAkF
         RiQDYV5ouBcsGxUVXKLIh44RJK3bbnhUPSOI1ayeia5YhLHxLvSuaPfP4T4PokFIfsNs
         Nvjczk3yLsNZxpsBC22a1Nq0LyytLX5f4Q1B5zVf25v3zDcESUxTAUy8FZMTubGraEnN
         Np4x0X/UudeauO6H6EtOqErJagNTutlI4gd7g9mrfp65BDdz+Wm20bn5OD8PMjmhOPjd
         gegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742280266; x=1742885066;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AXbeE+q9B8uny1O22+JXIAcL6hxd+XvgftLgch9dqZ4=;
        b=YiuLVOQqO30cDP6w1UQWyiOe6hGwzvOuPCObRcfQ+cOxSiBMsOSPNQ5SNlW6XaKNg2
         Vz8yL8iETiG4U6l6IZ+kQTK5gnvyScTjttdP6yz7+PiyICCAQrugKMkAXB6/iG85p3wv
         dz6OsYwzELh8aozqKn7wVOO3x56bmriNz/1OaoyH9tLDO4bFEMRdyChYwrYAJhmvNj/Z
         lbezffZn8MfddBaoAYJ4avkHyz5B/D8qX3z/esGYhv3zxP27NreexXwHKEAjZLLE3TzY
         j4V/KdBeeGXw1Bm61iuCiipQYvkAQzrtJL8FBhFjYKyeSkLBbrHb1eda/4u7i4outlhZ
         wXTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVB7Hzk7YhOfDFoCKM7ROF0gRsPD8wqAuzsbK3R9NI/xpa08hL1t4DOwzHuVk94CoVjRw3dEnYnKt0g@vger.kernel.org
X-Gm-Message-State: AOJu0YypVNDll4U6l9jARyzGoGeYVUbYmRtXuzOdDFmjDMCkyn/4Lhia
	HBn34JTHtKJboFu4BtZEaTW7QZA53wxogCgb66so3cjhHc1YuuEzJsINLzbDkg==
X-Gm-Gg: ASbGncsTqCVySEcCVZAXWQpRligSZs74M9ZV08IG1HFs5+ul4wNdOV5uAlzifT5ZZKn
	a7ashqP3epSDkAiSS666lBglV3OdHcs45NzTe/1c6vUPH5NRITyGuMHzNGrrK4pli3uLFgpxYJY
	tzl/8hbMN1nbcDNa+S197ANsLdVrLbzrhjWdVriERQuCFA7czhwXYGfSILwdjDKMKvuLQt1pzUc
	sgOw/+GdVO3HdsQKSUwAB4fEVJivpjkxcne8/prbxZLxH6zObgtA7GbEA6nxre8q+jBSaKKL2nz
	NyTtXZHmxMn5p37192dJ2fsQlTK8iMKhuS2skbiWq9ucktrlBs87EIKP
X-Google-Smtp-Source: AGHT+IGUoUDJ5vTYdSQ2RELO/IbV2/iGzzF3b1wNuHTa0nhz/p/MbaSJgXtRU6hyx2Anrag4ph7yJw==
X-Received: by 2002:a17:902:f545:b0:223:635d:3e2a with SMTP id d9443c01a7336-225e0a8f4a7mr180304005ad.23.1742280266436;
        Mon, 17 Mar 2025 23:44:26 -0700 (PDT)
Received: from thinkpad ([120.56.195.170])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bbebebsm86560405ad.201.2025.03.17.23.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 23:44:26 -0700 (PDT)
Date: Tue, 18 Mar 2025 12:14:21 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Manish Pandey <quic_mapa@quicinc.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com,
	quic_cang@quicinc.com, quic_nguyenb@quicinc.com
Subject: Re: [PATCH V3 2/3] scsi: ufs-qcom: Add support for dumping MCQ
 registers
Message-ID: <20250318064421.bvlv2xz7libxikk5@thinkpad>
References: <20250313051635.22073-1-quic_mapa@quicinc.com>
 <20250313051635.22073-3-quic_mapa@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250313051635.22073-3-quic_mapa@quicinc.com>

On Thu, Mar 13, 2025 at 10:46:34AM +0530, Manish Pandey wrote:
> This patch adds functionality to dump MCQ registers.
> This will help in diagnosing issues related to MCQ
> operations by providing detailed register dumps.
> 

Same comment as previous patch. Also, make use of 75 column width.

> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> ---
> 
> Changes in v3:
> - Addressed Bart's review comments by adding explanations for the
>   in_task() and usleep_range() calls.
> Changes in v2:
> - Rebased patchsets.
> - Link to v1: https://lore.kernel.org/linux-arm-msm/20241025055054.23170-1-quic_mapa@quicinc.com/
> ---
>  drivers/ufs/host/ufs-qcom.c | 60 +++++++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufs-qcom.h |  2 ++
>  2 files changed, 62 insertions(+)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index f5181773c0e5..fb9da04c0d35 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1566,6 +1566,54 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
>  	return 0;
>  }
>  
> +static void ufs_qcom_dump_mcq_hci_regs(struct ufs_hba *hba)
> +{
> +	/* sleep intermittently to prevent CPU hog during data dumps. */
> +	/* RES_MCQ_1 */
> +	ufshcd_dump_regs(hba, 0x0, 256 * 4, "MCQ HCI 1da0000-1da03f0 ");
> +	usleep_range(1000, 1100);

If your motivation is just to not hog the CPU, use cond_resched().

- Mani

-- 
மணிவண்ணன் சதாசிவம்
