Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B064224891
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 05:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767158395; cv=none; b=AM9rIyxREVg3gzV7CLQazvN/xriW/2q6DE6ZLJRNNN6u/BwHYYUrODZKHfW81zgwZbmpJfjKJWBtN7bSAlYfCxvqvlN2eaku90HkJsT3sZWNWhORY1XdxM7cCck71xrrMc5N+1lCoJtlzRefjk1O896sxnMs8lR5DJoC58/3Byg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767158395; c=relaxed/simple;
	bh=Tnd03SeHSblBmICbICc1rJVhRKXPHHsr6lscmLdYyLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCp2v5nZk2wrujvMaeSUgPMunB1HF5s0ovWDNGHXLH1a+FibpLrmH8LU5XIY0PGS+bDAoleTbzt/XkiBusjP9lBvaKgpEI8kpIH5yO1Pzc7FIsdteQyT9EVG4gSYbs3jEDKuJPqdV3Yajz86mWanP8rjiNE4OjvRZ/1l1E0+1Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hGth7NqB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FBanTQ1f; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hGth7NqB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FBanTQ1f"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BUNZYhm1286319
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 05:19:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	E1xGN2zrEApKTfUGasrY25ZakIX/76v/M3IaDtOqOQQ=; b=hGth7NqBa33Enw2V
	E8GKiShuylBdjziOorxs3p7T9Y28DN0vz/ciDWm5NyDZEF7HrLQeaxJxUmw3nyQm
	J2NawsZy1F5F2yOwfNt9HKx1lUHVtSru+3B9D0f5rFWTr5XGCcbW5DXEVSPx/kaG
	XJrlNc72mtiHEwk+9hGFqV1lcOwydYvUWnCC4bDL+HfwEp29DgCESQ5ru60lw+WZ
	sdqu8eQPdzaeEI4dnfJ8TVdV6KR8UqTajAo5Avm+voSXuAEsVXgUwum3Egcz7ajj
	o6WlbpgVWBLBNuItTtTIBViUoFEHhuGsnXlEp/SFDrXAtDexcwBIZqKhh3DyAYu6
	6dOSwg==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bcdky1xn7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2025 05:19:52 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4f1dea13d34so255488461cf.1
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 21:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767158391; x=1767763191; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E1xGN2zrEApKTfUGasrY25ZakIX/76v/M3IaDtOqOQQ=;
        b=FBanTQ1foMgqdhPd3rYO3rAXRpxP39v/vfuC6tlFsr5XSe5snJemh0g7C/xZPeN2UP
         x+3S+8nnxuOKq+gvxEyyCQZSrvkCGXO/zsWLv3pcWsD/IBZVyRNtjB7UfR2wtNJ5wlBK
         ohNSNu3IZyEV10NKkEtClxskO0mgU9jyoSGzd/wqYT1ilAujAySE30kOrXNz93ph45hr
         q8gDOscm6tjao7WOeK44KjJklvJOjaGHvB6s+0BoXsDxKlpqxqkRlFR/3x4NPPlXGh2j
         0eeFYCl0+pId7jVItXomRpuPI997S+2pBvqdNM2czpqBiXSmzMh1iVrf6+o+y3ma9exN
         ItyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767158391; x=1767763191;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E1xGN2zrEApKTfUGasrY25ZakIX/76v/M3IaDtOqOQQ=;
        b=pNGgS+ZpnfQVxtzm1IcM0SjlfQWWa54ejKUtOkiHU0qtY7cYynMWBBT36GGJbUM2d7
         rNvtPtATPGHMbtY8e1fxN7+IFCClhXzRj/q9Fg7gvruVhbV5mvhBbXP0abI4KcnT2UMi
         lpRYYc+gJXYKwyledBxFiWHF8Iy+yjhiyVsZ4S5BxmI2SQUHpqk46YsTL7EBhZAlwfYR
         X8d5QIyKStcL92dsDVm4aQzYt4F/rzvxR5voDdNUH915HlUDXyvapZBGs5OkoPkG/cdN
         8nd93sG7iV+LPXwGHh1CQ4vhlq1Gu/RCSYYamoLfNvjNgXN78IGcPyFNVqeUllcEzCdh
         5cRw==
X-Forwarded-Encrypted: i=1; AJvYcCWdf69r/N3K9HWUHQGZGr+pydDgEqtN/SBsWnHiQl1yJJ9zSnEAfawU1nSMXzkfLV6bC7cEuYrML/yb@vger.kernel.org
X-Gm-Message-State: AOJu0YxKDqzNvVi4lpBtgJEfwnT23xKGs/fjstEuQWdxDveoofhkE05y
	wbD6EG/07OqLcuGkCdnZe7JrZOHMF+KYf2AdLYlBrbdXGbl4KMS9GBgCI8DBw8G3COfAdwB1IUQ
	DpSFsmBOXIvqJWQkBWv0z9ITEOATgQSkJMA4erYXeHD/7fiEvi5kSlifE57lOAiU1
X-Gm-Gg: AY/fxX6GQet8rHdcUm34WE/kWIRgdeqXued7iUvg7X333ys180xFCv1hbP03P85EyYw
	zLb56deBa23UYvhww+D34QJWpiuj0GR7YpY74cWz1ZKntqkW9zENLrLNW8WAEgY1v5/gTOKRue6
	v9xBCirrb61kjU1prX8nlBx9YjrjYkxvs9yw4UQK0EVrfDB6SFfRR7vNBfqpnWyt9c4hAAJYFuf
	i545RYgx/l2gmZvQSa8JZeL4SbYJ3BLOSnlhDUpu+A6TZ6/U9jq0LXpGRy/1WvQcwJZJMQMK9fN
	o3nLvLX9N9nkPqTwuAt9t/uFSYfEi9aRqIQnHNWQ6i9Y9zqhLuk/S6bjqiUHHK42zMvs0nAt2dI
	MtQmA9sLWi3jUBnAA5EBJDrmANCyhTh2Qucyhm3Nx1n9Xh0VJULws+tOnMZeYNIdn+Y1Pu2PeTV
	RoC55ChSYW0Bbf1PqBz2UuHVQ=
X-Received: by 2002:a05:622a:5a15:b0:4e8:b4d1:ece2 with SMTP id d75a77b69052e-4f4abcf3831mr561542191cf.18.1767158391281;
        Tue, 30 Dec 2025 21:19:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGKFKoJm27t8xI1H3Ei0r+lIm0m28X2cssif0m/ROwGs0/pHyCtk45EViySb1qIrUoNgUgw6g==
X-Received: by 2002:a05:622a:5a15:b0:4e8:b4d1:ece2 with SMTP id d75a77b69052e-4f4abcf3831mr561541931cf.18.1767158390614;
        Tue, 30 Dec 2025 21:19:50 -0800 (PST)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3812262b36dsm101143511fa.30.2025.12.30.21.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 21:19:49 -0800 (PST)
Date: Wed, 31 Dec 2025 07:19:47 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
Cc: mani@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
        bvanassche@acm.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, James.Bottomley@hansenpartnership.com,
        martin.petersen@oracle.com, anjana.hari@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/4] dt-bindings: ufs: Document bindings for SA8255P
 UFS Host Controller
Message-ID: <4mq5a4lhboymigbaruphlhip4zvmxl6xusvqrqb57bhx3yirt4@mgxdlr5onl6l>
References: <20251231045553.622611-1-ram.dwivedi@oss.qualcomm.com>
 <20251231045553.622611-3-ram.dwivedi@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251231045553.622611-3-ram.dwivedi@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMxMDA0MyBTYWx0ZWRfX1nYtKZDPfke2
 NVyC+fh9mtFMz+STzS+ZTEjoqshBdYYYfkOrU3AfYifvfMk9qF/SBWAdzAfWnGaByZttgxdLaQs
 d/0htWUnQqsc0ItyGXPKV2U9r2wHFzRBYxpNOmKjWwNADZip/m6Ljm/ARVT9iHzpUyFDVUdIXCO
 WLWZNB7Hd+oMID8xzkZTZw5Kp36hcdsdCqpY917xnBmm6tdewcu0y3UCqjRoXFQsy2rGjgs8EGQ
 VtxfbJJef863StF1BC+Wkcs71edD17DduysZfd5GW1fx+0rOpOnTmq8qJx2XFh1P5eiVD9FAyV9
 4TWhABRYi04/K2Zjlz6niWdwh54b+2N8SQWj91qtG1Ig6vPGCyVH7Qij4Pb9Xkyd6YKLkwDbsQx
 A4rKkwtfpNbu3Dsg83aEXHK7Y6+k1pnA5RTDFAA1+02N23AaUFcQb8wc1oAoOXogZDww9JecZkl
 6ljlLua50lAeCQHXVoA==
X-Authority-Analysis: v=2.4 cv=Wskm8Nfv c=1 sm=1 tr=0 ts=6954b278 cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=ZEv58NsGN1HZl9ZWw5EA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-GUID: 0B9Ky_WTH0SaduZG2s5ChMUrxsudbGOR
X-Proofpoint-ORIG-GUID: 0B9Ky_WTH0SaduZG2s5ChMUrxsudbGOR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-31_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2512310043

On Wed, Dec 31, 2025 at 10:25:51AM +0530, Ram Kumar Dwivedi wrote:
> Document the device tree bindings for UFS host controller on
> Qualcomm SA8255P platform which integrates firmware-managed
> resources.
> 
> The platform firmware implements the SCMI server and manages
> resources such as the PHY, clocks, regulators and resets via the
> SCMI power protocol. As a result, the OS-visible DT only describes
> the controller’s MMIO, interrupt, IOMMU and power-domain interfaces.
> 
> The generic "qcom,ufshc" and "jedec,ufs-2.0" compatible strings are
> removed from the binding, since this firmware managed design won't
> be compatible with the drivers doing full resource management.
> 
> Co-developed-by: Anjana Hari <anjana.hari@oss.qualcomm.com>
> Signed-off-by: Anjana Hari <anjana.hari@oss.qualcomm.com>
> Signed-off-by: Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>
> ---
>  .../bindings/ufs/qcom,sa8255p-ufshc.yaml      | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
> 
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +    soc {
> +        #address-cells = <1>;
> +        #size-cells = <1>;

This didn't really improve. You don't need 'soc' node at all. Please
drop it.

> +
> +        ufshc@1d84000 {
> +            compatible = "qcom,sa8255p-ufshc";
> +            reg = <0x01d84000 0x3000>;
> +            interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
> +            lanes-per-direction = <2>;
> +
> +            iommus = <&apps_smmu 0x100 0x0>;
> +            power-domains = <&scmi3_pd 0>;
> +            dma-coherent;
> +        };
> +    };
> -- 
> 2.34.1
> 

-- 
With best wishes
Dmitry
