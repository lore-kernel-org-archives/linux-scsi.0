Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B973370EC
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 14:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570120; cv=none; b=QEeaXv9S5xgzORbMYqNuHw9P7pnRIg6Dwm3YIRm0Kc6x7GsigffdXzDeQcMZaChW6iUeZAOE9S6EdVEC6rFl0ul6j5sHYPdxZY+jl99EKDIL20w0x9X0SFgqdUZPS3Nso9l19Jx1YrY49/hrHQAmpyEBB1pyQKTJQ7qrtsOSfJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570120; c=relaxed/simple;
	bh=LFLlCZ6eo0An+zqE3d/JX6cVTgZD9Bf/pdv6Mf8v7Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZBeqKVBq2cZGi1c+n3YpwknpkL3VHzNdYX1zdgq0gF/KeyVwnT+w3H2wmI+183Z7PPTdqSpocOi1T651e4daI9qfK7yekIL1edYr9XZ6fbSKUrrkgQsCTyBjYa1AgSGQHXm8Ffl5l/4gJ/xid/k25rzp7PQ33IYIBBS7ywzZmJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mt/+REEc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IVR+NeoV; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mt/+REEc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IVR+NeoV"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68GEZ4tS3212612
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 14:48:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MClUT4TtavLkI7XCoEvk0+UCbwWQqhP2+uEc+y3ikwQ=; b=mt/+REEc4uj4Arpu
	s7vtuKUSHba5OAClDsfs6CGNm7/nRvrLP0LgtOa9LE4hRVDHvWtuulEZB6LY4sGS
	VtQS7D2mFYeOIJ2JbJ8vUBuWnFVxmOHco4w/XwSpWOEDQHDJyewbAvY1FsvWC9bC
	4houCnKE1u9gz2etICFZDjqsmCgU8jDvH2EROJtWI9R+AUYpZAdSxnNwna7yLoNK
	1mOiNUGKpMaq2zP4xluLwWZLy59+zViuX9ww0ADgX5Gi7cEJmE10Dv8ibdEvuxRW
	YdxBLiKNMtymqHT8hZ0g1NWP0O5gBIfe0mn9GE+bzND71F/iL9APNSfeyQuUlScg
	kOmUzA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqjcktwwr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 14:48:37 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ccb687f82eso78167385ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 07:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789570117; x=1790174917; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MClUT4TtavLkI7XCoEvk0+UCbwWQqhP2+uEc+y3ikwQ=;
        b=IVR+NeoV76uh9pO9qHWyOnve7qF6jUovXnqvADIlPP51r2I5BIOCLfZQiR8va2s43+
         9tflBWzrBTFlVX80VpfUCTxBO3RHGoh8Nbh5eNiJjNvHUGScuqEVyjUQVTbKU9X2WZ8c
         NxFiPSRc3JrrGJr9FxoWPmprR8d1eoZF5oeqBR9T5lK4XjKIIcdYzQwoq9X1iEuzwAGs
         w1s5YiI9wwa3XS0Qyb1Q/NfFQtIlgdeFL2sbCtz3hQgEGSKuS8YDeC8Oc3LAFRa0n2BI
         qOKkOC/hiy6wnzX3DCERuZDYAqg1IQNZuIIfV1xbNJ85aiSRG0H7pAAcObvZNba/kGin
         RRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570117; x=1790174917;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MClUT4TtavLkI7XCoEvk0+UCbwWQqhP2+uEc+y3ikwQ=;
        b=JWjNTOwCL5SOR/x4rNAEnCzcCl8v0owBgpzCvKpvVPK+wCZdnd4GZ2yEsEIYXfSuit
         zX6melZ08YSAos3EPVtTB18I0IGebqPkiocrH1CyTfHB4TZBZhqTrwqhE3XRgNBv9m4e
         gkdxpkyg3XAN4ZsEx5XJzBYha0T4ckYperSE7AXz1cShw+ZDiEU52ZmRcdU4f8GeTS2g
         X243K7kfkmmZWBYWq1PPS+UhBNhtQXAGbGqmGQ8I3Q+GLO+w2mFlB74FkyOJe7Fbf5qY
         rN9UHFeY3v/mOb6aPlSVHWiyiRLegRTHr790kTubstELYlAxn4nWt4/9b6x4z2H877v3
         WkNw==
X-Forwarded-Encrypted: i=1; AKwUvBwSbERzwLIu4p7JovpWnWYKFMFm5rrHx/JiLW0p1vlhprP+N6R+8QAGIPL2j2q1wfNbo2xnLzbk6+oL@vger.kernel.org
X-Gm-Message-State: AFuF++kNv1XuRNdJwsa8zTfZGbkHH5t1DMn25BhsvX/Pjdf4DClEs04e
	SQYCLr5Jnz4rDr1t3fZmxX4ryq+4QrlWpx8S41EnPf0JurQEzze49RIAqE6/7xcTfTrjbV/ARBP
	UyQl5ZR0wJuAYFrrMvJhcpOuDsJbvkDm/94n851DSQpJtluliPRgyrHOgC59l6m1g
X-Gm-Gg: AYBFou2wFHWYDWwSOPoge9K4PbrjgeCuJMkL+iQEyOexv0+BdO4ZeZQHCi5cOP8QTTN
	bJC0izQL6LietFB1qczfVAg2ShoAOUGCwcNT/i1j0HI0gAGjacaJEJH1Nj/9Euc1gs3NUhC0jQX
	fHNYKk7ACf+gFaz3+VJTVU75GM2lW3+5HnbM5R/vQjimEK/1sYofvuqbb1h6YFd4fme37O5VRdf
	1Av+4X9qt8678gC0p+8+dd/pMO/YnRhLoFcmU0i7de3gw0cnMNhvurR9VPIGmX+Ws8wwMpFjF6c
	aLnAOz1CQvR/C2mna0rPOcAkcrG0+nzy4XgdxrYjCFpEYdF+hnBxbKoQOF7+zI71bzUR3rjzfci
	B6XlrblOnAtrYZqysq+QmGGLmHqEbsIPnaBhPE37f
X-Received: by 2002:a17:902:d582:b0:2d8:d4d0:7932 with SMTP id d9443c01a7336-2dd8e7aa6eemr64251195ad.22.1789570116613;
        Wed, 16 Sep 2026 07:48:36 -0700 (PDT)
X-Received: by 2002:a17:902:d582:b0:2d8:d4d0:7932 with SMTP id d9443c01a7336-2dd8e7aa6eemr64250545ad.22.1789570116191;
        Wed, 16 Sep 2026 07:48:36 -0700 (PDT)
Received: from [10.216.41.130] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f02fc2sm13008905ad.59.2026.09.16.07.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 07:48:35 -0700 (PDT)
Message-ID: <db1414fd-2202-4dd6-a420-7dc505b91f77@oss.qualcomm.com>
Date: Wed, 16 Sep 2026 20:18:28 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] arm64: dts: qcom: glymur: Add UFS nodes
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Vinod Koul <vkoul@kernel.org>, Neil Armstrong
 <neil.armstrong@linaro.org>,
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
References: <20260911-glymur_ufs_qcb_enablement-v1-0-b9fc5e2ee99a@oss.qualcomm.com>
 <20260911-glymur_ufs_qcb_enablement-v1-3-b9fc5e2ee99a@oss.qualcomm.com>
 <chmhun7dqj5flvbkzpsoz3pdbjrcbplel5rqfvj3fc6ztaw2sa@4o55fods7yaf>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <chmhun7dqj5flvbkzpsoz3pdbjrcbplel5rqfvj3fc6ztaw2sa@4o55fods7yaf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDE5OSBTYWx0ZWRfX4wNCkbIcE2Uo
 T3yeZr585B8j4GGA6WQRy9sUZzatqMng1JPrQZM/G3PXDm1/N1Y2CX0tfNV00GHJRq+AZQZx2F6
 dKCcVxM3OJoQUZLr4IGG7Og1GeYMBPw=
X-Authority-Analysis: v=2.4 cv=PsIG/AM3 c=1 sm=1 tr=0 ts=6aaaac45 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=VTBryuNdlAkkI53dnxMA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-ORIG-GUID: Wy9hsSiX9PYsx7i3O7z9rGY0CAqqGwci
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDE5OSBTYWx0ZWRfX3IBHrexXtso+
 JWajjtLLDLKOZPa3JwjTqBe2+0e9KbSnhBZyBsyr95Df6+SooDJfNJ0I8FL0HXhOU3E0wk0kYMG
 X4OI8UeyktUAbGAoSLarMIF91z92lkETqtGcDX1yaD1p4Zx3MEBiR+MG6QT1P328oZpvyowfgtw
 ctIyLFzLSrKC6c3vwf6iJAo+FImNzddCVmBlgh/vZGOc92+yIZ4IhFwPrjTdjzpWLILqK9KviCM
 zK32dhiHPSWNxuPkptlp74YlROHSCkRTnnWxOF8FGp9BcaAqhs9+WWmtb+DplQWwFqA6PKodWvq
 3wpa+GcOH7g5MtRlExhxo//mKMsJP7hWwqqPl8xkJD7gK0wJ7UmyDVy9NmxeUEO75EdUW9P9NFL
 OAAyB5QtyQcsgVNTKiKU9iCgv8jT0F6vo6GNOpKcq6NNJ96rLkDTiZ0XdN5PQZfwt7l+QzNtn8F
 e/rTokfug8wwcWBb7Cw==
X-Proofpoint-GUID: Wy9hsSiX9PYsx7i3O7z9rGY0CAqqGwci
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-16_02,2026-09-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 phishscore=0 spamscore=0 clxscore=1015 suspectscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160199



On 9/14/2026 7:36 PM, Abel Vesa wrote:
> On 26-09-11 22:17:07, Pradeep P V K wrote:
>> Add UFS PHY and UFS host controller nodes for Glymur SoC.
>>
>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> 
> One nit below.
> 
> With Konrad's comments addressed, I think it looks good, so:
> 
> Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> 
>> ---
>>   arch/arm64/boot/dts/qcom/glymur.dtsi | 114 ++++++++++++++++++++++++++++++++++-
>>   1 file changed, 111 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
>> index 624a9edd602c..7bbc804ed340 100644
>> --- a/arch/arm64/boot/dts/qcom/glymur.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
>> @@ -812,9 +812,9 @@ gcc: clock-controller@100000 {
>>   				 <0>,				/* QUSB4 1 PHY RX 1 */
>>   				 <0>,				/* QUSB4 2 PHY RX 0 */
>>   				 <0>,				/* QUSB4 2 PHY RX 1 */
>> -				 <0>,				/* UFS PHY RX Symbol 0 */
>> -				 <0>,				/* UFS PHY RX Symbol 1 */
>> -				 <0>,				/* UFS PHY TX Symbol 0 */
>> +				 <&ufs_mem_phy 0>,		/* UFS PHY RX Symbol 0 */
>> +				 <&ufs_mem_phy 1>,		/* UFS PHY RX Symbol 1 */
>> +				 <&ufs_mem_phy 2>,		/* UFS PHY TX Symbol 0 */
>>   				 <&usb_0_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
>>   				 <&usb_1_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
>>   				 <&usb_2_qmpphy QMP_USB43DP_USB3_PIPE_CLK>,
>> @@ -4103,6 +4103,114 @@ rng: rng@10c3000 {
>>   			reg = <0x0 0x010c3000 0x0 0x1000>;
>>   		};
>>   
>> +		ufs_mem_phy: phy@1d80000 {
>> +			compatible = "qcom,glymur-qmp-ufs-phy";
>> +			reg = <0x0 0x01d80000 0x0 0x2000>;
>> +
>> +			clocks = <&rpmhcc RPMH_CXO_CLK>,
>> +				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>,
>> +				 /* UFS and PCIE4 shares the same clkref on glymur */
> 
> On top of Konrad's comment, I'd drop the "on glymur" part entirely here.
sure, i will remove it in my next patchset.
