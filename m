Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F0A3B961A
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 10:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035482; cv=pass; b=B6k0mOEqmy4R8AkDrRwRoCxQztglaV7bFWgq3xkNCNBQ/M8ehKdH7vJeb1+7w7YgshLxHFOdIpNSQakEuzpsTfRcbj0s55WVldil+v6rC/Ej+pFzPvCe+x24xwmkLWOl7xPeg0hzQIZHcu+PDpeonK8kc50yWo75fIemsVIfbnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035482; c=relaxed/simple;
	bh=xJtlT+brubTDzcwB1LsQU2wH8jfhem1ycRIpQIZsMuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lf9fc/FBel3M1lNKrgAqGvVaIe1Cjy77J68oDtuVQrdKWWEtSTNd7gEbjiW6kbr1DyC1ZzU+Z8jtkhzj1wVXnlXD8g3wOCmAsnupvqzP2wNoYK3rO9+8M1Jb04Yd9fd/uW2WYdb735OhNl6U2+dUOfSNOBDrB2kP+nswzhdOKCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PGKqZv6u; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YYG7PFlR; arc=pass smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PGKqZv6u";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YYG7PFlR"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A8q61q4136852
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 10:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5o0LQq2H5NyuqhWcIAsOhclTasLhXE6zFp16BztH0tM=; b=PGKqZv6uqTxJsb4V
	yz/56PwDXoYI/+DTCIsMR3DS/Z1r3noojO+XzGn4dFF++mrEALLWcGYqgjyWe3WJ
	ZHYBaIZghgOs2KV0ThF9P+XHnCRbNDHS5d/9EFsz6fhbSRUpiEfy/fBUN9IdRTOA
	TW0teNVSH7BgXWyi7J4XQvW/RwS0u1vLSONrNTUqUcRTkuyenE4y8wVAhp7D12bc
	YYaBUeeCvKRDcdXwi9yU0Sf8UBVOV/8PTrIKBN9qSXquo7+Dyvmf6QsOlNPpf2Yq
	nah7yoUwbbBLZawcshuQMNKa5GbnhltI41cGg8CkvKkDjBxyHIp1j6SDVwjDSzKP
	JBStIg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gkcydua26-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 10:17:59 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-398fe469aa0so11629635a91.2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 03:17:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789035478; cv=none;
        d=google.com; s=arc-20260327;
        b=PDiSdSytLDVqZgmUbtKuEC4VK89tWefrQ6zkOXt2xTWvYxsqLqDH77h6jLloYkTZQm
         sNiVGP04Qzzb3lIeBStP2q7Br5VOiJruzcZXaJ3pPgFIuhhFH9KsZ1yuF7NDl3peHkFb
         V6h5RqAJPvpQmhFW+OfFkiJbE/jsjtlK9bQP0bYuI7iluGuF1roVMkeSy4nbOADn0Ffg
         HGXbnIjkGPxQUbr2ZEd5owSbzJ58FTEp0aWug+0aLfxf3tpGOft51sk4YPmUUIP7EPto
         FPA2IWPXm3DpPOHjAsFqIqyDAqZyBCRTPDJXsAY7lsinxv4ckn5X6Ietn3tpZE9tV+eN
         Oa+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5o0LQq2H5NyuqhWcIAsOhclTasLhXE6zFp16BztH0tM=;
        fh=oDlnttstuQvslo8CVhFLpzS9j6ke+nnCGE/XUGqDS1k=;
        b=sL8Cp2MKiKsnz8fw9ULMbVJXBzm8cTSKF3vvv9WZTYo8j5QyU99jQVP4XuZ66htLAH
         Bm8mkIaIqtBPlx06+OVy+EjpyUs4MSRsg65+/7pLLP72fwnpFJcONoPenBGhhLeFQcqJ
         hqt6quTv643kF+Lr5zqMx5fsczCkLPtIxAMSAaPlyKaCGcHA/hActGVmT5GcDLVO6B88
         Jwh0SrZJ8P+C+r3ELG1hUPzFWe5PMqSKl1LuGGi/HIYI0nEev/T38wgV+F8OaQ5tVHMg
         oPq/tiTjjvrxpu4yk8ECkYYYnUyckKH8KW+0NNz6wcsc9mewloup1yGvUB16O+PJbKxT
         2mIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789035478; x=1789640278; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5o0LQq2H5NyuqhWcIAsOhclTasLhXE6zFp16BztH0tM=;
        b=YYG7PFlRv/m7RtW/2T+N2DJNrZXsXtWKhFJOa1UdQ68pEJDuw2oDtyLTbu+wQWJqvJ
         ++i1ue1XoDSxWUvDyBIiYzS/frVNffrU9P9onZSrRwyVo6A3rY3Urmmj5kvDmf/X8W6i
         ektBJtxE8Zl+w6+R9Xsixdh5tvaKkvwfpmLOiEQHgVvxBsQnb/4j+iaQtMAQeP21m+HQ
         dZOmFs+ZhrWX0Rep3xscs+Worxc536G8Qt4fkbY/VeIxwx/6MmOr1WFKjnVDiHZnaj+P
         ibWw/LjhdjXtk1z5Uq5qcaG+NMejXFHerT5KsK26vYHQ8H1gRZZ7f7tnR4YQw6y4QfJ9
         N9qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789035478; x=1789640278;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5o0LQq2H5NyuqhWcIAsOhclTasLhXE6zFp16BztH0tM=;
        b=Erz4XXxsexmgdie2HsMe1vQZsFtS70YAuxIUisheVEpidWjnjrcLNMtBJ1WSfo8fjR
         7BoypAiVfGib8d38eJyzhs3A7VZEB2oHDLtN8ua/naI4hduGgajsrsZRVpsSnYqoqRhL
         0os2dfB+/7CrURL1Yo1iA3kYb9bjiDHAfzHt21RswHpx30n7LwdFq2lU30275z2UhncA
         cFV1vn9fSRIhTXhrkjEsQlkHfvr+V7d+2gqEuKNSkFomU54iOych1HUo8ojGPOHU3/ze
         g0yHkgHYufyHbTaGg+xn1ywv2YNWANb/lw5TY4VHZHc1mg7X7fy9Oe2kPqlUmkcw/rXC
         zCiw==
X-Forwarded-Encrypted: i=1; AKwUvBxD0U6u0TmD7sG/QqPCUnmSlhh7bdnX0RxCeZlNAWOxy+VqzU3wmkQY78VYL8VwcTFKvIwf6Fvid78o@vger.kernel.org
X-Gm-Message-State: AFuF++ntz0Cip2LL2ezVTFvFwkCSKCMkQ4tSX4SgTyHVgGzT4bUMhfHv
	0389auIt9umySDDyqR5Q5QiKM9CeplofqfTerNgLqe9NN9VEXjL7zPjBfjtudVslExbNI95U6nQ
	DmGQGyRY9+1pQHVTETckck7eKdHP+ZUgCfZrVTq7KWCyb7SdT2h2cBJVUFwCmCELu1twpwhpHRE
	yFlL6pjRhzE0xFxujgH/CEfaH9hg4rbeiRbeeaYRg=
X-Gm-Gg: AYBFou2XFgO66ATrhX4DBAOdL/TG3JMK7W3MOuSEBMuivTJA1i6DJ3iiNh+NJwg3j7Y
	srglEa4IoK+/RX1OOI4djNqxtE/k3n1L8No3E5eNR5wx7I7WY9GtdTbjr7x7FSMQeFH5kkVaz58
	Wt/zqkK1DAvM0VJ65BMl5/AlN9MFzwESsziSiYc7TSj3OqOgGodNRNUV+vZg==
X-Received: by 2002:a17:90b:558c:b0:38e:57a3:f218 with SMTP id 98e67ed59e1d1-39d70ae1a5emr10579643a91.13.1789035478535;
        Thu, 10 Sep 2026 03:17:58 -0700 (PDT)
X-Received: by 2002:a17:90b:558c:b0:38e:57a3:f218 with SMTP id
 98e67ed59e1d1-39d70ae1a5emr10579584a91.13.1789035478102; Thu, 10 Sep 2026
 03:17:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-3-09271f583dc6@oss.qualcomm.com>
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-3-09271f583dc6@oss.qualcomm.com>
From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Date: Thu, 10 Sep 2026 12:17:46 +0200
X-Gm-Features: AcwNN1VvsxYSlSneh1UTJxLDFcgkCYVDC7Rwi96BfcNazOVn_vX8zy2Sk9dMolo
Message-ID: <CAPx+jO_Ltc6Q+VdUgOs81azTiM5Vx12GH1z+CXt6NW=M601THQ@mail.gmail.com>
Subject: Re: [PATCH v12 3/6] mmc: sdhci-msm: Set ICE clk to TURBO at sdhci ICE init
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=IfsSymqa c=1 sm=1 tr=0 ts=6aa283d7 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8 a=QyXUC8HyAAAA:8
 a=i-sMpDq2_rzAXM5hadQA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: 9spi4z0vmoLSw44n37WH3Ix2ZeyZL9sX
X-Proofpoint-ORIG-GUID: 9spi4z0vmoLSw44n37WH3Ix2ZeyZL9sX
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDExOSBTYWx0ZWRfX7SVrkTzK5ueu
 l007xMpIIC/SkXAGlYQWomBrhP/tZSDVMBqmA812ujJY+jxNazrAN/N14phL0bDv5FRqm3ugwe1
 P/Gm9XNOh54tjZ/gSdIU66RQgN+cvrY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDExOSBTYWx0ZWRfX4YC+KU7gfk4g
 BM5m/tIIVbtUy7kWsGI88MPWVfR1jwuMhHNQYlzuFAb66X5v58xVXDDkpksl5LZqKfqgIZBVZPf
 L1sFVj3pLA4xfOdnzchOovkFCVLUuZc+SEO4aS4ZEKslr00AzbDa6eUVO7TCp9xYWyO1NVLCGY/
 WO+YeA1hi9j6+vVh+DRgBtPrpmxXSr1LSXtsDplC5WnhvWxv467TmevccBuN+b3AYcSO00oQ7cH
 p3JjOivd6wNlSDQ58FfMHT6cs8mEHKiCjRvfOPsYIpUDfS6GAmsRysXWucEDhRybxDjaLVjSPVJ
 fgHOjMiiWMOXnBIo+FOFSnl78ugVbunQwKcSXnmrTdhGG1OUTis4Zp1W9+heLhrWLttSUwHPVmF
 8mGxPxjzEpWjQBSdJRM8ty/2FHHogTs3txjTafyz0LIZobKZStoabXsnflfbLBTU8I92RBxTRzO
 Jph21t2gnltL3yhXn0Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 spamscore=0 adultscore=0 suspectscore=0 bulkscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100119

On Sun, Aug 23, 2026 at 9:48=E2=80=AFPM Abhinaba Rakshit
<abhinaba.rakshit@oss.qualcomm.com> wrote:
>
> MMC controller lacks a clock scaling mechanism, unlike the UFS
> controller. By default, the MMC controller is set to TURBO mode
> during probe, but the ICE clock remains at XO frequency,
> leading to read/write performance degradation on eMMC.
>
> To address this, set the ICE clock to TURBO during sdhci_msm_ice_init
> to align it with the controller clock. This ensures consistent
> performance and avoids mismatches between the controller
> and ICE clock frequencies.
>
> For platforms where ICE is represented as a separate device,
> use the OPP framework to vote for TURBO mode, maintaining
> proper voltage and power domain constraints.
>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

This looks good to me!

Although I have a question - should we never drop the vote? Like at
suspend and runtime suspend, at least?

Kind regards
Uffe

> ---
>  drivers/mmc/host/sdhci-msm.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
> index 0882ce74e0c9bdddd98341a67b97bcef74078e0c..1b4c276dce34d76dcbe75117d=
e37e09ea2002633 100644
> --- a/drivers/mmc/host/sdhci-msm.c
> +++ b/drivers/mmc/host/sdhci-msm.c
> @@ -1902,6 +1902,16 @@ static void sdhci_msm_set_clock(struct sdhci_host =
*host, unsigned int clock)
>
>  static const struct blk_crypto_ll_ops sdhci_msm_crypto_ops; /* forward d=
ecl */
>
> +static int sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host,
> +                                  unsigned long target_freq,
> +                                  bool round_ceil)
> +{
> +       if (msm_host->mmc->caps2 & MMC_CAP2_CRYPTO)
> +               return qcom_ice_scale_clk(msm_host->ice, target_freq, rou=
nd_ceil);
> +
> +       return 0;
> +}
> +
>  static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
>                               struct cqhci_host *cq_host)
>  {
> @@ -1959,6 +1969,11 @@ static int sdhci_msm_ice_init(struct sdhci_msm_hos=
t *msm_host,
>         }
>
>         mmc->caps2 |=3D MMC_CAP2_CRYPTO;
> +
> +       err =3D sdhci_msm_ice_scale_clk(msm_host, ULONG_MAX, false);
> +       if (err && err !=3D -EOPNOTSUPP)
> +               dev_warn(dev, "Unable to boost ICE clock to TURBO\n");
> +
>         return 0;
>  }
>
> @@ -2149,6 +2164,13 @@ sdhci_msm_ice_suspend(struct sdhci_msm_host *msm_h=
ost)
>  {
>         return 0;
>  }
> +
> +static inline int
> +sdhci_msm_ice_scale_clk(struct sdhci_msm_host *msm_host, unsigned long t=
arget_freq,
> +                       bool round_ceil)
> +{
> +       return 0;
> +}
>  #endif /* !CONFIG_MMC_CRYPTO */
>
>  /***********************************************************************=
******\
>
> --
> 2.34.1
>
