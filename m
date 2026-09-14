Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A754C41D208
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789377250; cv=none; b=W671d4eVWrJyc4fd4q3zkiLY8zdM7oET+lZZeh3v/lNea3w89aVjhiwiwps751Nsk4br7dqGdpQ0Jh8WkjGxb9co2hXyhgBv56bedzRNqkP+swTFhOtt49KlaAy8B21wfTIcK4LovOS1rnI/Xid6ZU3UizizzTdkXUSEMXGg+pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789377250; c=relaxed/simple;
	bh=U+cJ/1BKoeCdFn/U2zPCDc6LZkZbVVMWzpvjm0ovy50=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XMmW7CFPeJ4t/4wxoM2EufpZKZHvhQxPA/8V7KnkQzz8lwJNSQ8SNiMVwzWwg5GiysGZkLLuXCk11NZc7aA0g60sDNx6sNMO6CmIa3dQYLZDXasgHAj1gYBi09oywB8sAf9LRp1s5Yb+zM3aG8Ai8soGVz3n+INdfXwwu9m/erw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=i02qEmAt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XPuqnkRK; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="i02qEmAt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XPuqnkRK"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68E8Kh7F403854
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:14:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZG9wl1M74lgDTaTfHkBv64HRev6yjML1GUvpwSVAtcI=; b=i02qEmAtCReWHuXf
	PV8RoA7hS1OM7zLF14PeNOkQk/eyewJ6Sc6ErzaoTOl1sGlljFmif6f2h4hHhV0S
	b0LtC6OEwbNfYXc2eJw/akOU031MRtodGEqA8ep06uu4XdPjji4c/R0EId5rR6/J
	0xMB3iyTkbbByGmrbWUB0UdqUqlVyOpnfr+0x4xzJ22vfPXUYWTycpDpNlBPeq83
	GPsb4iVt/PTMiUigDPfmFPXgC8Bt5G+J6RFTHKqBrzmepBWusY9HrF2Ib6Dcm6ap
	dxepQI1jSPUSFADDalSKRle80DyhKhIje83OlMS70M5xd5yOtYmJ0Obar4rDoZbq
	ddLxAg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gpdb5r5kn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:14:06 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9375d92d0caso38257685a.0
        for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 02:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789377246; x=1789982046; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZG9wl1M74lgDTaTfHkBv64HRev6yjML1GUvpwSVAtcI=;
        b=XPuqnkRKVg6gVjF2QSUgLqssflIlpccHue1bWE4+rRaj1Zf3lSEv4o8jXyHk3id7wD
         cPWnvRPccEWT/QVtwnOMp37U6fHJRozTPHi+thL5pkcAtJrpglvyVybRAc44Oz1UJxHB
         5G4+0bY6oUSN60RM1caqmNtRdvvLTDpsY4E+rc66jkvAXOcfT5BgXUssTCeA4PoPT+xk
         aM8SwYrz1kzmN3o5abnaJjKO5jpwXI+pdBMF8r/tVluLifrQ8rikjLFh4aXpJxMg6Wc5
         Al0IVJtSqY19Rslh+/bxgMl/lZQI0iK423BgvAg0TvFjsnQj8MyMm3hgl0m3ITqlL3Bm
         A+bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789377246; x=1789982046;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZG9wl1M74lgDTaTfHkBv64HRev6yjML1GUvpwSVAtcI=;
        b=PNG4ceof3X9AGoKGLDqDS+mh83tM0f8QEDbt4q2a1VyxhPku+aRiykGXSGfy4qzExq
         31tijIKwkkYSwT1/Qjnrvy9DSZdQS/TNvFl7osNCNdVwEvfYkzBSWLgtzTBBkDV6wC8p
         NfehP+Tr9C05X6mBLnkVyP67Roa4KNpKihlFbujhdYMcIwxmo0UztDxlQUMAkqowseTJ
         a3Drcpwtv43/zyGnZho+qIFCk1r2/z5sW7I55LCx8NOgr3QevC1Tk4WZ3ypizJg91YEm
         krXR+MTeqS/bQG5LaNx3pzIaI7ot8USDSj3Nw/Mz24O6sFdmidN5F2IksqDjt3r50Vez
         VbxQ==
X-Forwarded-Encrypted: i=1; AKwUvBxcRpz9SqTMCSx2L3n6vUvpzedxoVcftZ9berQ0Q4NeXqlKbmud0uO0xqd3CBFhGyTcblys8GN65GNi@vger.kernel.org
X-Gm-Message-State: AFuF++k76KzZ9KyoN+DK4O60TpMqIfKga81wpbJB9zvvIz4LJ6QL7slM
	Ozbj2ZkfWnIBRjHIiXAtD49eca3jwv262AZ5/1q5KwDs+DkzRMnD3F+ssJRTTYIv+tBqnDofoDm
	/Ab94Apr+gxc22xFKSTNpX9He3OESiW0MGlp/VA3PndqLi7I04l4qY9+RVt0fhbXZ
X-Gm-Gg: AYBFou1wX4Cu5/567VDuLjEJtk7CHzI7JV6cHva4UnUvznQ8ic8O4mioxYXMkC7CUYm
	n2ULND1RCKG286MMy2KUhyAyMynEhO+Q4nZl4UNO6jTFITkDAtvNQgKNvtZk8tt40mV8pqCFmq3
	oFhrgAwD+FENzHSBBiLqV/5IJ3SxwaIThtg7zlGEiaeNkXAsdwVKUmeexrkSBTlSODVyN96i6mS
	cVo44VFO9j0OJ0zaK21/pPQMmXQ/vibvjC7mM5xr+36slB7f9M/LTPWQ7NlnptV2pYLGCI/jV2B
	14TsQZPgPsY6bR+01p0YEshfZGnYhugS2eSS53iea6C6zLqJWPhEsc8T2vHYOEJK4tiTLOytMvu
	jx2L0BD9k60W2Ztg/apInpA==
X-Received: by 2002:a05:620a:6018:b0:939:47f4:935a with SMTP id af79cd13be357-93a29c955b9mr163371985a.5.1789377245686;
        Mon, 14 Sep 2026 02:14:05 -0700 (PDT)
X-Received: by 2002:a05:620a:6018:b0:939:47f4:935a with SMTP id af79cd13be357-93a29c955b9mr163369885a.5.1789377245246;
        Mon, 14 Sep 2026 02:14:05 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c29660219ecsm393573266b.16.2026.09.14.02.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 02:14:04 -0700 (PDT)
Message-ID: <381607db-0e7e-4d27-a992-64cd722c23fc@oss.qualcomm.com>
Date: Mon, 14 Sep 2026 11:14:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] arm64: dts: qcom: glymur: Add UFS nodes
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        sibi.sankar@oss.qualcomm.com, Taniya Das <taniya.das@oss.qualcomm.com>
References: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
 <20260911-glymur_ufs_qcb_enablement-v1-3-b9fc5e2ee99a@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260911-glymur_ufs_qcb_enablement-v1-3-b9fc5e2ee99a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDEzMSBTYWx0ZWRfX9zwhD1k7inkA
 aEo/YCc/Zr/5gfbu+OtCZPU3GBi2nQMIHTeAYEaKgbWk6teH/YqFLl+kACFOkdls1JVyTYc1nyo
 8Cl+ZRqbmnan8ljLWq/GD7COAqjXSOs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDEzMSBTYWx0ZWRfX+YnuGEfX4L+o
 rx7Mk2PamqDnuaz1MJfyfVSUnOK/ZhjsMyw9AgJ9lj+c25xaU+0Tk+fQF5fdCTxWwUqE3jqTMCZ
 cuE/4ywr3/Z0hVQAqefkzp5Q4Ip6fXkf4TrBbdwuzKiXCeySAQyP8R3nn0ZfjY2sqxueM4khGlG
 oqCXUgmZaJUA61U+VNy2Nf9F9RZyleBN+V8PrNWXWuqQSBbYEngecBVuuDpMoI1njHchG71m4dh
 TRhl+aNZDYpprL0FJDdRu/xaKSVTrTdKdDNwIEm2U1iixMCzPSSLyLKM6c3rKZC+LQcw0wONJRh
 olefS1GNYJ8KBYhtp5agxa+JW6LwXLARK1hSZew0drC4AaquzM8oTt/wFACngYc1Wvvc17KN51R
 X9ZLsaofH9ob789ZH/26OHIGLHtI9qzA1VNvm8RF3nVE3O6X3NX6OA3w5PPTjLqbJY9PTEWbnxA
 63sIWS7KngSEF4narvQ==
X-Proofpoint-GUID: yx_fY-mEvga3eqB-Jlb0TNdiGunfARLa
X-Authority-Analysis: v=2.4 cv=Ie4Symqa c=1 sm=1 tr=0 ts=6aa7bade cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=Xzt-r8i8nvNm0dTu8BUA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: yx_fY-mEvga3eqB-Jlb0TNdiGunfARLa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_02,2026-09-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140131

On 9/11/26 6:47 PM, Pradeep P V K wrote:
> Add UFS PHY and UFS host controller nodes for Glymur SoC.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
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

The comment is no useful, please drop it


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

s/shares/share

> +				 <&tcsr TCSR_PCIE_4_CLKREF_EN>;
> +
> +			clock-names = "ref",
> +				      "ref_aux",
> +				      "qref";
> +
> +			resets = <&ufs_mem_hc 0>;
> +			reset-names = "ufsphy";
> +
> +			#clock-cells = <1>;
> +			#phy-cells = <0>;
> +
> +			status = "disabled";
> +		};
> +
> +		ufs_mem_hc: ufshc@1d84000 {
> +			compatible = "qcom,glymur-ufshc",
> +				     "qcom,ufshc",
> +				     "jedec,ufs-2.0";
> +			reg = <0x0 0x01d84000 0x0 0x3000>,
> +			      <0x0 0x01da0000 0x0 0x15000>;
> +
> +			reg-names = "std",

Stray \n above

[...]

> +			ufs_opp_table: opp-table {
> +				compatible = "operating-points-v2";
> +
> +				opp-100000000 {
> +					opp-hz = /bits/ 64 <100000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <100000000>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>,
> +						 /bits/ 64 <0>;
> +					required-opps = <&rpmhpd_opp_low_svs>;
> +				};
> +
> +				opp-403000000 {

There's another (201.5 MHz) OPP at SVS

Konrad
