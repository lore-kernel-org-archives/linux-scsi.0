Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795620283;
	b=q95oRO1J6CEFXIzNCa0EDsRToq/i75i52QNRkx/HliSUJ3pjAujiIpMWL0zGFpVTO7sD
	 8N9w92hdzSuaFgGdxjL+6lPBh5EJ4mUAVSyemjCaswDcCkiDDZR79ApFrD1Bmjj2N98vy
	 VfQNWwpgxBunEiqXkiOc6xJXuVgYpk8/pfN/M3i2v1IRhF7/I2qmoEdxXSftIlyICAv5G
	 80C8fIxm50q1IPUmrvt3Av+W6tjvLdkh/jjUF2r4uBOdrBdX/LoiIqgwWZWeYmwBY1Bt5
	 4LPk/rQF4d9L8An6S9jYm3cKaXu+2YxaKDyj1+kMdtRViBefQ7gPiYu5NO++vtnLs5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620283;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=;
	b=esQhLV5DPTZmvzPaCRCrDFutDY4PbCmEfgsmNomTL9ReDmadyFyRaG5ct1bK2Sp3oku+
	 OAv7qHIWJ1hy1T+xH4yOpWc1oooegQiJqRzlGd5NaRQKvNe9bmAwg8A2UcKeGduRCw0Y4
	 2tkfqWvH/zKIFURJUNuGklOYnLKwh/5eXIZsuvTpRp8SL3NJ/I9Roz5Z4vJPgpndMMc3f
	 sJYh2alfCMV6uGKFpmclVlU/MTP/AJpDIuACvk3ziEbOuiGmEiF0L+NWwitDzhkN0U7S3
	 MW74eRv+450haBWRNawnaVog0hEpyFhlRimOg7FazVeYK8j/UwxOf0ferNgiyWr7vOA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="OpB6FU//";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cJM3cew1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D31F606A32C
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 15:24:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D31F606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=OpB6FU//;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=cJM3cew1
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6APEM3t6047572
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 15:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=; b=OpB6FU//8xOqb7OS
	5fVG54KpU7ZjNVKjctadQgIBzM1pOMtfT+p8RLJQKyYAAI7DZyJ5qt+UOaP/9pq4
	u8sBWRPln3bzRSPYJOuCVV7hYFjGloUQUfoatqf+FTAUdrFoUXI8IRA4nJgD5hO1
	itivGuWNLrBgEQ4KnYHzi73YpEIkNS2hpwNeAhy7ZKl8SxdU6IFb+LEhb4BFL6GZ
	DmcN5Y+58aqVqcFdGV9uBwFeAW+ByxC0qjFbCfgk8N4RUZhVJhAGLOUIiB4jt5Kz
	fAq9A5IwNKwk2eFTo41CSn49JtybruJZBKPkwkWdyxqWMvEUDUxgC06m1qXnG5Yg
	jtr1nw==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j5mc2bgxv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 15:24:42 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1cdfb337eso3477807a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 07:24:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795620281; cv=none;
        d=google.com; s=arc-20260327;
        b=cXmPNM6zWWVZ4uTYqMW5yF7fOke6oD3fQtcKOLFJLlthgaRQNrRBjvGMFOsQhd7DeJ
         vhPeAjfMJoQ5H1nckZ3oVPzIm2wB+JadLVDFvEO+wEIDgMvmOPQiK7UXfXlzZ+52BN/E
         Vvb1XVcVD0mpP4myCpc7iNz2SpjLsJtl03SDagUeEoDbzgT/BtYxMhF08M1ZFV1YA62k
         BXAZ49EH8JivCMf6nH6QZ7DqLe2f0WgjYsztZXDmL/RKGYDX4DJ0UPdZVsbcEzG+Xnsx
         EULscgsiFzLcuNtk8Z9dJsdGWaGB2KDgpsBglfO3WoF+R2qT94Vp/SoaO0RwJUrX6w7b
         ImcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=;
        fh=CNAzhxBNcABeKYOayxtCam2MoRYFmfKxEoKR7EpCkgw=;
        b=r8qkCbHBF/UuEPU2+oqsJr8/J6Cy/iCAqhhlnPUwlgOBqZispLEzV2JDxM+TyWGED0
         Otsggz+CZLO1FQJpRIlhKxNWh/Hli5vUMr+ZBI8K+5uuCyo69ZTtpB/2HjCHr7VOYm+K
         rvPA1tkGhbSCCce2veU3R2FMhOqc+90eUNlyTUXd77nWy9cpJhegCbOao3Bo2RcCH6kS
         ohprd9EMQUL/HStj/8J2nQWEom447qnAybD1e3fkTY0DgAZPi1wDpch6vv8ah9f7LGlz
         yj8xoVrxu02pOCJh+H+DTEQ5ES8He1ithFSl36VNDqrRS+AGcl8ildPbZLdNQ9rqFnTp
         Zu6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795620281; x=1796225081; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=;
        b=cJM3cew1hkvYIyL1ViCsj3kK76klrSGicdUUgE9mOCNL1W6o5ORm0MgbmkkbZ++ky/
         2vUkNgT84tLjE6cV8KtUcoRzbEb4AngRs2uu2ze3e9psU18rHrty8zOfx2nTRki6hsLi
         ntrpPDqvdLM4Wo8v4CGdX4tcetEwGUIhKyej55Krwtwr4kzuKa6iIn6MVOxmio/d6kwT
         5b4N2UeS1wwaV3RF6Zb0f+T2aTYGrOhSSvPL+aVi08R7KJALyVVCmJEa0Ui6lQZvUKQM
         ArdimzhQYaG2Y4q3n+7rcEbhRmBce9JUP/ag7s9govOUlGhur1nxeuCr65eOi75ajjRT
         pU5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795620281; x=1796225081;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BWI0oTPS6UWP+KHreqzTyFzt/bLKfNI1fMUEgGA2TjQ=;
        b=hrUPfA35Gz1IRMfb+g/YK9oAN/JyxHWqX6ou+ho00gHPLqNyGfuAVgfu/r+wXiSWzW
         ko19/H0upd93OyRMUpwrkIeKJ+yjS+xUJqmHPAikJg4Zh71uEK9T3ADD9c1S/XVwCzAq
         Ixw7/90quahOmonIjyGGY/NqcdNdIWYyhRex7v7XjBWijse5Th2DFXdiUgK2wpfiV2r3
         Wokwskdbz6F5SsoOLKmcirWur0tP2lt1PXcpMXoA0nKNGX4duxNwjpuhdvZ34R6am4c3
         VtotQ0TBqgc3z8YxLgKimaNfzlCTqjGXBqUCsjMgSRsvW2u1UkXBUnHlWKTy+W+M/UwL
         96fQ==
X-Forwarded-Encrypted: i=1; AL+hErEwpbAsrxn+6ESPPoyCcS84MvG61gTTXrPN0gbwiqypu2t+5KaJxs/0ybcgOheLLm4bLgJP3EYMO7V9@vger.kernel.org
X-Gm-Message-State: APuU4Z/u3wBaWcydhT5ZX47gKwx4nBk+9ZxMOT4yb6fT7V0ij01YplHR
	DIg17VeVZPBQFzA1hCrP9aqV3ClzSKXf1VVUsvfLDIGexymQBqc61DP9BTJMwfsbPywhEvf/exa
	vEJEqqqtXgFGGJg1Jd7iu7TcA0MOqMF5UN63ABHl5gEZCIHV93okkrW8Se6ruFk16VVPG2T7D/x
	VWYgdGiN9eS6sf876BgBCJNKwcNdLuUc+VIiSWwlw=
X-Gm-Gg: AZFdTZdxtpFZ+H07PcGMDr1AF6UZD894/slCqLec/vMg8vqWWipMfC5miXVLEJOisvU
	V2mDf1OjD7WNR6fMLa1y05DX/S0Un4wJbyk8lVfcslkHgbWb8A2sc3UFZqkMGmx28XLiy/xwZ/J
	+JXRq8Es1aMA3sAy71BEzBW42EOvJMOyAqETsaH9uo2n+ppFzbpmSDhHwXKQ==
X-Received: by 2002:a17:90b:2ecb:b0:3ac:8446:c1a5 with SMTP id 98e67ed59e1d1-3b41c988620mr15762977a91.48.1795620281126;
        Wed, 25 Nov 2026 07:24:41 -0800 (PST)
X-Received: by 2002:a17:90b:2ecb:b0:3ac:8446:c1a5 with SMTP id
 98e67ed59e1d1-3b41c988620mr15762922a91.48.1795620280668; Wed, 25 Nov 2026
 07:24:40 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261125-halliday-dts-v3-0-5c8311c0b70b@gmail.com> <20261125-halliday-dts-v3-2-5c8311c0b70b@gmail.com>
In-Reply-To: <20261125-halliday-dts-v3-2-5c8311c0b70b@gmail.com>
From: Ulf Hansson <ulf.hansson@oss.qualcomm.com>
Date: Wed, 25 Nov 2026 16:24:29 +0100
X-Gm-Features: Aa3M54pQyww1I_PbdCBse1VupHYmzcQQ8jGP2HKCbG8YvURb7jcXXUW3MJhTLAI
Message-ID: <CAPx+jO9aHqEwVu3j5CdVTsfrhk8cMRawA5rj51EA7AdVtn-U+A@mail.gmail.com>
Subject: Re: [PATCH v3 02/14] dt-bindings: power: qcom,rpmpd: document the
 Halliday RPMh Power Domains
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>,
        Guru Das Srinagesh <linux@gurudas.dev>,
        Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel (AMD)" <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Georgi Djakov <djakov@kernel.org>,
        Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
        Ulf Hansson <ulfh@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=aPJlOr9m c=1 sm=1 tr=0 ts=6b06fdba cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yx91gb_oNiZeI1HMLzn7:22 a=pGLkceISAAAA:8 a=EUspDBNiAAAA:8
 a=yRSEYQ9GznzmN70rNvQA:9 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-GUID: CqWf4BUS2afRBrUYgddiO63voV4d1t8C
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDA2MSBTYWx0ZWRfX73Rl5hb8CWFn
 L5YeT5tRCN1JfJabkU6KzgtpRJyukOkph6mf59izK45pf0FtL1mVavI+vEvny/PMaxMNOdPnp9d
 vuItngUVG3mnEOdF2GekY5pmdXqWgYb1MmxaI1wRe9NTjjGZy31BINFsDlJ4s3KDAobMWOeLIcR
 p4iPUqkCkejZx0CAzW9Ui9fxT6MHAW9pNFECf6eD2lkG5f0LjRR0+6FSE54qe+KSLguVJp7Cqrp
 n3J+tP8k30sWKE8UJyD6qjHLEvAyqWJHYHGdwHVkYLRO+gJYomoMibqOCljWSD6WpFB2yZ+381i
 N/gVF7rCHMMlHCyizzT7udXkokr2cxOWLWTOLrPRNSQ7bUJ/Xgns68WgIdYfxPvfG6YnCNObfhR
 xlfEv9FrNxPrIbPZi/ojVWzKq86DGbUmgr2DBzSrSew3oBGmmKl54XNX8uc7upaHM0c3L/Qnb2t
 AmAAYOAkOdROVaPRptw==
X-Proofpoint-ORIG-GUID: CqWf4BUS2afRBrUYgddiO63voV4d1t8C
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDA2MSBTYWx0ZWRfX1+0e3mRJGwdk
 8u+UMNImBP0CaFK+Zda7sUiR+EXa1Kc3u1P2uPMNZEOQlJW/PSzc0/bEpQPNeh9e+96hDnzYhfE
 p2nskSPWZz3Qoa+Ga1xnWUl1nPzTUBk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-25_04,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 clxscore=1011 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611250061

On Wed, Nov 25, 2026 at 4:44=E2=80=AFAM Stanislav Aleksandrov
<lightofmysoul@gmail.com> wrote:
>
> Document the RPMh Power Domains on the Qualcomm Halliday SoC
> (SXR2250P). Its command DB has the same power domains as SM8450
> (CX, EBI, GFX, LCX, LMX, MMCX, MSS, MX and MXC), so use
> qcom,sm8450-rpmhpd as the fallback compatible.
>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>

Applied for next (available at the immutable dt branch as well), thanks!

Kind regards
Uffe


> ---
>  Documentation/devicetree/bindings/power/qcom,rpmpd.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml b/Do=
cumentation/devicetree/bindings/power/qcom,rpmpd.yaml
> index 8ee1c25a7c9d..663baae9cc64 100644
> --- a/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
> +++ b/Documentation/devicetree/bindings/power/qcom,rpmpd.yaml
> @@ -82,6 +82,10 @@ properties:
>            - enum:
>                - qcom,maili-rpmhpd
>            - const: qcom,hawi-rpmhpd
> +      - items:
> +          - enum:
> +              - qcom,halliday-rpmhpd
> +          - const: qcom,sm8450-rpmhpd
>
>    '#power-domain-cells':
>      const: 1
>
> --
> 2.55.0
>
