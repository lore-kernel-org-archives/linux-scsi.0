Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD86309F01
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 08:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767686592; cv=none; b=sJmtmq8QkEVLhUABxkebe95V02oAhYb+5m7ZfqJ/iwYByTf2X2U8W82HYlGHWLtIH57bXi88AAzCzoMLbHnz2u4G/pD4yUpJzdg37LQy+Jz6Lit/uW6A8N4YyChb9GKN2eSiUj1TBAcOT1kXhFtDt0erwDAOUcu/3IdVS2taTEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767686592; c=relaxed/simple;
	bh=f5+U4bIkXAF6HhuAJ3mpf6QbgXiY+y9Yar7nApZbdT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgHWqyD4MScszf2Qsc8i2PXFXDlY/wiszb+k5onh6XgvyiIRAYsSQ7fJ9WIbdxG6ztMo9qFsu+mzEMuAfn2WX1HfTACldbXTAsw3/u86HpPaaDbGGc9e2de3t+tUroZouu+TrWtUgYLnTP/iNJ19vKnCYnP0jyDLHJLUhVSuII0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=bRzEvoPs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=amfuYU/1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="bRzEvoPs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="amfuYU/1"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6063QYL7529152
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 08:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	S3+xtUM3olagLh1tBmNWj8fPCCymvhiEGhTOzn8UdE4=; b=bRzEvoPsKdMbynUm
	lUycbMAVpL4+HrfVeB4OPF/nUQJdsubQB2O0bM3FK93ai7JEUBgeGTeE3KEgJYrP
	rnap/qAjw9X21KuTmiczvmoxBOkY12+HKNOZK0z2SSLLD/Ic7AF1TJweSEBhl4bm
	x5dstuyVD54m8zzPQuRAoNP2P767CxXnYFp1+1IKVicNpa9QWQezere/Vrr06bQp
	HoOQFMmyoJ6vogdg+XjIQxhbp/5Urgj5+hbOTOFJSVil1iFTjosBuaZn8kXQHoaE
	6WLF6ThOIxuLlI6fPEDXMM9CQKDShwm0QxuSAHg2mZedZzlHf+Xdi8+4FIR1IX4g
	+iKk8A==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bggqu2aqq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 08:03:10 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7bad1cef9bcso1609181b3a.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 00:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767686590; x=1768291390; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S3+xtUM3olagLh1tBmNWj8fPCCymvhiEGhTOzn8UdE4=;
        b=amfuYU/1RLaB229lVrkaduss+GUEMjwNBQ5K2C0MdPjX5T4s4QCGWaZatMvK0+LBXl
         Ke0K8T+zxOE4Qf1dMMBsXiqto/Pqw0GOkkH61H235VsGf4VpwNy+g5xq4P8sYUszYtHD
         RU4KVB1nbAb8DSKXKGVtlKvTjBqFURFoyr43YWa0ZcuQUMJXpaQVUi5ZKNNL+GnCZ2NA
         fOyQKLDvYkuvpN+3kL7FtZ/IyJf8UQijkV7vJJfeDsqlmqrWx8C9Js78ImV1a/+BexHd
         pGd1B1vo4sio7ULbMC/hmcqAaGjd6p4kGzgb6BdgZu5zsgia3NlXoI/A5Rx3DBdAdITF
         bSMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767686590; x=1768291390;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3+xtUM3olagLh1tBmNWj8fPCCymvhiEGhTOzn8UdE4=;
        b=ccKNmRDlEfVB5khakoHGQp591rb7WXr6gZJuo/PcbThVnNBFV6FOe7USN1k1gj9sFz
         oklp6OukN5Ng0e5+Man0No26eGo9nigndQUC1t8jEzOytiKV6oQxsMUKPtRj7RMU+3WF
         h4O/OhN2hlhMCdOHQp41fD6y7xxCagueeWZfePNb+KGHruySIAqV9Z1dAFnvKavFbBEA
         lviZOmdwkqLyRW1IROp9fgV1KxIoOTedlwuI21Z/I22W9RI5SRQPxhlGyM4anmxkS6zD
         rUowY35ya6GUGeaoUggjdXo0FM9XqpTjTYvWRdrytI9tdukJorRKPlPPWsuTyFLyMmUr
         f28A==
X-Forwarded-Encrypted: i=1; AJvYcCXsXJ52tT581zRvVnMt/M5sN16V1UpxPldlQgIuvfv8BDwSxgIsFyAMiN+zu4kTzJHFiSs+0VhYVZgE@vger.kernel.org
X-Gm-Message-State: AOJu0YzDC4kAmJtJkTWQtjxDMZxKhzjp0JTGsqKAmiFWh6n2Z2qyekxg
	eEmiLJ8jpMsfctCZUMvz2XE2OSi0hzXc+EiQE/DL7UkdQOqmLJdAZFvovGCJI61XqgaTuITE4nL
	GSJKv4xl03YPSnCm0EVlWgfSf+1Y56ymqXn4LM/iZCXIlaPn0l969FF/H1SDSzHXh
X-Gm-Gg: AY/fxX4Q1PQRNoUnx/oVW4At0wWOEp7hHoJosctSd3RQJ1iIv68RtgvlPMQJjqQeBp0
	Gjrc22RBD1yb5OYxnK+cvwyFWFi0/kqdPfXqYMtHSy7cxlrjuTwVj7cpmBHWnSNDVEPanB/R/GG
	qGae1c4jIJNSMJJolW5x9LJsrhwHHDtDA+1kuIMaQpf3D3RVsuZsUs44Puv59IrdCy+HFOu0Dco
	2AaQfAqHjMuanPMKwAk3wuJKbzg+bQj+s6JeP+tH3DvyPn7HqH+Yhz6PZhtJd8sAEyQFzrGkmy7
	lWloaTSx2NlBF/Ehurm4b/zOuxeCKekmJcjcPeQLg/INDEPU4Vag91W88TrpN5nBEuYRAian5X9
	eHjiADEpC2uST9mPK2rjVloFa
X-Received: by 2002:a05:6a00:4c0c:b0:7f7:1857:8456 with SMTP id d2e1a72fcca58-81882bed424mr2160897b3a.55.1767686589490;
        Tue, 06 Jan 2026 00:03:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG1StIk5ri+Xdk2XHSuW8HPE18xZLf09BUwEnyMKp00EvRdNGc+dY7FLMF1eltAoyBuNLC6+w==
X-Received: by 2002:a05:6a00:4c0c:b0:7f7:1857:8456 with SMTP id d2e1a72fcca58-81882bed424mr2160864b3a.55.1767686588964;
        Tue, 06 Jan 2026 00:03:08 -0800 (PST)
Received: from work ([120.60.56.175])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c530133csm1318334b3a.31.2026.01.06.00.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 00:03:08 -0800 (PST)
Date: Tue, 6 Jan 2026 13:33:02 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
Subject: Re: [PATCH V3 2/4] dt-bindings: ufs: qcom,sc7180-ufshc: Add UFSHC
 compatible for x1e80100
Message-ID: <ljaqrxazapkqvv5m5kxm2pq32dmgyupu3fzn7yhgvnvg72o3lm@5qiiuv3oizvh>
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
 <20260105144643.669344-3-pradeep.pragallapati@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260105144643.669344-3-pradeep.pragallapati@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDA2NyBTYWx0ZWRfXz7GMKKpe/qnf
 IMMc9JTicvxWK7+CSIhib/hniwO1yfeT+3SzSyoYNyzRFS3u9HAF4KrNAglU1omRWG686TMauLL
 hcPQcR1yoFK/k5cDEpgZszNpJN67tjZMmeX2ztcCwmZpsQFzeGBftjB7uQpa9DnoRTqN+mVNZi9
 3hTd8RyeOhltCWSAkQaJRFZ5pi4CaXRrIQTppgKxu8dYfnHxCfSZ2Cj1fDJYsJl4NHb1RsTGXOh
 4aSCO3sbm/fR9LpH+dMmricW31RGkw3Z1ZCl2CKlt32guSyIe/X1sh5d+yGf5oob2qXdzy6UmVx
 /GxGq0ooVJXF20kG21E0vR+Y4nuyiQpigE4oDASU+6qPeFPFoT3FzteC6HELwB7MMUrW4FFwhUq
 jaPmdOjy3HlLWQH/k0O0XTp2+ge66OjuTx/qNrNxrCEQiaKob4YrCckaIgjQcuxwO5M6NbHj38s
 SS3h1M3z7a3qgTE53Dw==
X-Proofpoint-ORIG-GUID: QRpgB_guOQdQZAWWHAymVH8BM0tUKuwb
X-Authority-Analysis: v=2.4 cv=fr/RpV4f c=1 sm=1 tr=0 ts=695cc1be cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=JR4DBjdY6jk8CmbmB73bTw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=I8-C11gq8jfHFaFuRmUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-GUID: QRpgB_guOQdQZAWWHAymVH8BM0tUKuwb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 bulkscore=0 clxscore=1011 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060067

On Mon, Jan 05, 2026 at 08:16:41PM +0530, Pradeep P V K wrote:
> Add UFS Host Controller (UFSHC) compatible for x1e80100 SoC. Use
> SM8550 as a fallback since x1e80100 is fully compatible with it.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

Acked-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

> ---
>  .../bindings/ufs/qcom,sc7180-ufshc.yaml       | 37 +++++++++++--------
>  1 file changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> index d94ef4e6b85a..c1085d178421 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> @@ -31,21 +31,28 @@ select:
>  
>  properties:
>    compatible:
> -    items:
> -      - enum:
> -          - qcom,msm8998-ufshc
> -          - qcom,qcs8300-ufshc
> -          - qcom,sa8775p-ufshc
> -          - qcom,sc7180-ufshc
> -          - qcom,sc7280-ufshc
> -          - qcom,sc8180x-ufshc
> -          - qcom,sc8280xp-ufshc
> -          - qcom,sm8250-ufshc
> -          - qcom,sm8350-ufshc
> -          - qcom,sm8450-ufshc
> -          - qcom,sm8550-ufshc
> -      - const: qcom,ufshc
> -      - const: jedec,ufs-2.0
> +    oneOf:
> +      - items:
> +          - enum:
> +              - qcom,x1e80100-ufshc
> +          - const: qcom,sm8550-ufshc
> +          - const: qcom,ufshc
> +          - const: jedec,ufs-2.0
> +      - items:
> +          - enum:
> +              - qcom,msm8998-ufshc
> +              - qcom,qcs8300-ufshc
> +              - qcom,sa8775p-ufshc
> +              - qcom,sc7180-ufshc
> +              - qcom,sc7280-ufshc
> +              - qcom,sc8180x-ufshc
> +              - qcom,sc8280xp-ufshc
> +              - qcom,sm8250-ufshc
> +              - qcom,sm8350-ufshc
> +              - qcom,sm8450-ufshc
> +              - qcom,sm8550-ufshc
> +          - const: qcom,ufshc
> +          - const: jedec,ufs-2.0
>  
>    reg:
>      maxItems: 1
> -- 
> 2.34.1
> 

-- 
மணிவண்ணன் சதாசிவம்
