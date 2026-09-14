Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CCA4718F4
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789394804; cv=none; b=kHGpP9A/25fAtIY4Q4g4HsFveFM2Bq2gK+/qEKs+CmGwVh7xfLH4hsVhuym0zTqzWMjcGsk0U4R7iF4c/sKEp9gwLSSKCZZfRBcOfHDkSwZn22LCaVDDG+y95uvO8t+ztg/h1SLuPHytjujzCdqWwSHghE9WpvQuycL6SP/oFgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789394804; c=relaxed/simple;
	bh=M1jhzEngeUQmZn4epgWhZIt5mhVknLgHn2qil+s31Nw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2KMW0fNpXG4cUTBzLZJN7T4XB1PA5ENdeDp38K/McN/dRxYEP+J1pYLbxRW4cTzPSnwjrFswwmM2AUFJJzmny4ZDPGVUVk3XdOiu0n4+LwBzZ9F6EeC1/DTHA/DF6hinI1L9+oWeVXlaKKT+74r+I9QG4kYUzZ+O0IYsddx4Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eqIGYLXY; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a9Jn3cCr; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eqIGYLXY";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a9Jn3cCr"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ED0PqP674411
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:06:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=Gnji4ta6O43OZz9qRSk1IXl6
	BaqNTU48rGVf9Qgbt2Q=; b=eqIGYLXYh1Nrbcio2AowZkZ9hL1O7bP2EEQyJ99k
	Hm01vqRYf/BPLVbXrx+QJMlWOsKsRycWjiILJBeKLBbiamFDONALt1GJnzPwPUb/
	EEek1Zjl9uU/W7FIvbHmhRS2S9so8eH8UwDlMV+vxpz8E55y9jn0cBKqvrNf43mJ
	GSNOWnQ94bNjLsGqG8yAYQMk+/StYthr3vy1tiNqQy6B5k5D/8w/qwHY4tf7ryf9
	Js40TADRP59yyOo6rCUV7cNALp73oTnky/mWCCcRBybjXKX+9IvfWR9Zm/nv2Eit
	NAr19HPKiRzrvB1rog0SKpa7k8TZsUt5KmwEAl9F4pPqRA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpecs9258-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 14:06:40 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93a1d44c437so171387285a.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 07:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789394800; x=1789999600; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gnji4ta6O43OZz9qRSk1IXl6BaqNTU48rGVf9Qgbt2Q=;
        b=a9Jn3cCrkyeE071B4+IVnlmTIMAD+jmzmDf6upC2/NDy8tucPU8iDqD61sTbgI07Nm
         WbguLt2Plt/hqUNRney99FjFhGjZFNQqzui2Gn8O+6vqWU6mLq7lWGVbg9BBsReT0uGT
         b4tmMmPYIZcXjjlV7E2PravhOhulZvsEzSuK33kw0tPBGqADGvRZaFmmtt7F+LOg3VkE
         CdCpVDNRaLM5kDx+k3n5qPJp1EJxNkG/vS9YH+wHSHSPEiW0g15zUDIJKn6reCWlE10c
         3oBhdiXhmqFsxGh+c2djuz5+xKLN93R0AT1ncKwzegFkhUEzUXww52aCf7jUhIheOvC7
         3xDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789394800; x=1789999600;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gnji4ta6O43OZz9qRSk1IXl6BaqNTU48rGVf9Qgbt2Q=;
        b=YJL1j5ClRBw3YIflZScPDSF6czePendSzQBo2ejRcSoWPKfoZCdrsyKqcFwwMfjEqs
         3wjmmnqaiZ9BL7h1veNPhJr7CoPNQbDAWAmsio9qGauvvaD9BY7EcYC03Q40kkd+NsDE
         vgR8EFa+J6pVFnzScT1QgRoortE3x8zMJuDI1PCaHLJqXYLj80G4cQF4F9wNB4i7Smhe
         EvV7iPZJLCZmpqqGEbxMhM7Sal6pyeS2ZgRHmSSohg/aMm6+vdNnt39Mku3HVT8JInhx
         5+UBkaDwmkcBQuGQ7cEVGPDgrOzLsAHmFqRhw7Rh7B1xareHauOGfaQAo2HRtzs6ky+w
         bQMg==
X-Forwarded-Encrypted: i=1; AKwUvByH2mUfzWt8A83zVjqRag5MgfbKZW738CUZh06j9AAYjYW/gyTGTvsgfUC6+0WQzBLBz9daRAf5HtcQ@vger.kernel.org
X-Gm-Message-State: AFuF++nCCWJFReBq4TtLhAsDg8k6DHq0NOAINswyNYULYhXVdLfx8H6m
	/jTzDL+dC6m0MRKYsdwK1kCDfIideaexeojNSVsSvXjUXkqCZXKeRJBa6baVOn5CTpdnex9mq7Y
	L5hPi3eEW5i0UAL7bsbD6ePlYkoTYI9GZ4ttoM44GNppdepd7OjWAOm2h3hOl7rNG
X-Gm-Gg: AYBFou0oZcsZjHsiO4kSza18QqPAiA+mKi0LZgJaMg63VqydQuM72rxjmXPDGz14ipE
	yifOY4LLi/QCBi7qCNTeUkUyuVx7HshRWk3RqhNlkIYO4sBboa8Yxsi4ywBwscjNgw9QQjYuX9U
	0fnzLDjb8QQ/8Pr7TFR6DsvEbCB08JzP1bKQ7S6fK0/00I8ASCGABV6wYG48cYgVPzlm0SWsGag
	2yKKz7k4NORI1lQSkhPJb7fIyRR9/PnD89kO5Afmf5vlT7trDMuLi0aYqqEuyOQzhOrMEznCxDv
	ohtJ8I4Gs7Nd3nmx8NgHmWv9UM3f8vcqPHjCUgta5GkXdPWo8KGPcjeeKwbo0b4r0lx0pVvaQ0t
	KauX9d430F61oIqU=
X-Received: by 2002:a05:620a:640b:b0:939:6de6:9517 with SMTP id af79cd13be357-93a29a92a0bmr442389385a.46.1789394799410;
        Mon, 14 Sep 2026 07:06:39 -0700 (PDT)
X-Received: by 2002:a05:620a:640b:b0:939:6de6:9517 with SMTP id af79cd13be357-93a29a92a0bmr442377585a.46.1789394798784;
        Mon, 14 Sep 2026 07:06:38 -0700 (PDT)
Received: from oss.qualcomm.com ([86.121.170.232])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c1bfb5sm432396285e9.5.2026.09.14.07.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 07:06:37 -0700 (PDT)
Date: Mon, 14 Sep 2026 17:06:35 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>
Subject: Re: [PATCH 3/5] arm64: dts: qcom: glymur: Add UFS nodes
Message-ID: <chmhun7dqj5flvbkzpsoz3pdbjrcbplel5rqfvj3fc6ztaw2sa@4o55fods7yaf>
References: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
 <20260911-glymur_ufs_qcb_enablement-v1-3-b9fc5e2ee99a@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911-glymur_ufs_qcb_enablement-v1-3-b9fc5e2ee99a@oss.qualcomm.com>
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDIwMiBTYWx0ZWRfXzLcFpWJuvdlZ
 m/Hl7UPj/t0w1efaq1BRJxp4kOh7SgGhSzskIOMfLeUVTylJqMDBRtMtXDfUOZCGC1Cen9xyW3V
 XdzNtLJfYMfCQa/Mp9tZpowp/c+p1bs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDIwMiBTYWx0ZWRfX50vyejgC5oJz
 zDJ/rgMKmQYlCT95ngaEM58WJ7Fv1OmFYA8sqzFkTFaP996DJNtb5SnMbsZuVBd6bI8O4xNQdg7
 xH2UhEwFDfiL05vrq0NHSRn6BsF3/p77XhRpnJu9Zoc7Ya7Plth/UaGfrq8Ay2sSX6O2TqPmrqW
 y3gisK0VCWHtFKbZPFu3SzuLdqsa7/NbtQ6Vno+Ck/GbBeft148VXfNih8pZiPtw05ZV/Jy5r80
 Xo20dQy1wmwm8TB2hmHz+Zfi4nI6pXIDzFR157GIPc8n8F4MAA7dbiY2B6zCB+1MW5y6ES5UV/G
 whPlNetoXZ7i+lTp+3/5BpYO6P9oqx7T5ydK25DcpMOUXPn1S/pRw3nNVfHnyZkgvQrtvskxTgr
 cfaWhCh0d7taTiVmCb4wJ6wASAsELoc5wBXzHoKQpWQPZJjJXC4mSb7PgbgY1ORWskeeOIMfFhV
 5sDrjMUvUL3/Ouj6vSQ==
X-Proofpoint-GUID: 3SVSnvwq1pyd2rk_EopwAGmNfSbpazKe
X-Authority-Analysis: v=2.4 cv=b/cncdGx c=1 sm=1 tr=0 ts=6aa7ff70 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=po8fGBi+ks8MzcVQGuqtFQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=ucACzhYzkOUm8HD49FUA:9 a=CjuIK1q_8ugA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: 3SVSnvwq1pyd2rk_EopwAGmNfSbpazKe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_03,2026-09-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140202

On 26-09-11 22:17:07, Pradeep P V K wrote:
> Add UFS PHY and UFS host controller nodes for Glymur SoC.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>

One nit below.

With Konrad's comments addressed, I think it looks good, so:

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>

> ---
>  arch/arm64/boot/dts/qcom/glymur.dtsi | 114 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 111 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
> index 624a9edd602c..7bbc804ed340 100644
> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
> @@ -812,9 +812,9 @@ gcc: clock-controller@100000 {
>  				 <0>,				/* QUSB4 1 PHY RX 1 */
>  				 <0>,				/* QUSB4 2 PHY RX 0 */
>  				 <0>,				/* QUSB4 2 PHY RX 1 */
> -				 <0>,				/* UFS PHY RX Symbol 0 */
> -				 <0>,				/* UFS PHY RX Symbol 1 */
> -				 <0>,				/* UFS PHY TX Symbol 0 */
> +				 <&ufs_mem_phy 0>,		/* UFS PHY RX Symbol 0 */
> +				 <&ufs_mem_phy 1>,		/* UFS PHY RX Symbol 1 */
> +				 <&ufs_mem_phy 2>,		/* UFS PHY TX Symbol 0 */
>  				 <&usb_0_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
>  				 <&usb_1_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
>  				 <&usb_2_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
> @@ -4103,6 +4103,114 @@ rng: rng@10c3000 {
>  			reg = <0x0 0x010c3000 0x0 0x1000>;
>  		};
>  
> +		ufs_mem_phy: phy@1d80000 {
> +			compatible = "qcom,glymur-qmp-ufs-phy";
> +			reg = <0x0 0x01d80000 0x0 0x2000>;
> +
> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
> +				 /* UFS and PCIE4 shares the same clkref on glymur */

On top of Konrad's comment, I'd drop the "on glymur" part entirely here.
