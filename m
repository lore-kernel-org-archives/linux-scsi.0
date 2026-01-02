Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A6913B293
	for <linux-scsi@vger.kernel.org>; Fri,  2 Jan 2026 03:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767325947; cv=none; b=jH1UhDhM3qtYD3Co7JlBeRINUnEnE0x2fic6POCuIWooNstDLXvSsMMcctHqSmlRLDcva1CamOwMST27acqkYRUmrsH6a6HA8i8MwDx7gI/0gZt0J/HM7sbw2DLkeTdsk8u46e8IuE/9BDcO3YHQHCdHvfSj8pF8ych90v6Vvk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767325947; c=relaxed/simple;
	bh=Rp+uBO5VCABx56c9L2JztalDnHvrp+oYJVAo/4zxB6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1WDP+T8Iprs/b3CxlTLESjw29l9ugHnxv2j9FNMq9fuw/W34VLdr8t6vDqTcjKDnR4ZXj3WMVox1RJNbI1M07b0HLFfwaspNUn/N05ai9JYt0x/kCngFl0rnHQF02kQy9PGIXG0wavuTrhtIsFoqIuHJYtafMnNR1jZ9Zs9Pgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=EsdGxvty; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=OqUnEmnZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="EsdGxvty";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="OqUnEmnZ"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 601NhkCm2771196
	for <linux-scsi@vger.kernel.org>; Fri, 2 Jan 2026 03:52:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	S61SjyiHBkIhWo/HAA8SDc3EP7YavRLTn5aWkirrCNM=; b=EsdGxvtyhsO3XTzz
	lMtW7AFOjv/2/3n9+XcrlezBBNytqIsqOgzo2q89u1tNvUw3yRBl7cBRTmYw6RU4
	cKtwBkbfzhdGMjeJaa7aRW5jd3TEcKghzFhK3SD0pAylfXlq9btoSCzF/UbxJbBY
	Jx9v4Vcs3eOqZ7j3Pf5DC0nCjVO9q+CIKFSb68X43+dk8mV1M127MwH71fNqPJcu
	7/posnD7wgh8MrvcHPf7Clo4b4JiNjgOJ4Ylnr/6qOvnWAfBOg3m/lMyKqpVPE28
	gY67g3GCK5QQ74RRTB+/cKm/7dunh9MvbK29Cz1GLBNulc72CtjsYmCS9/3uMhVa
	lup9Rg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bcx74bhpp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 02 Jan 2026 03:52:24 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7b9321b9312so24879850b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jan 2026 19:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767325943; x=1767930743; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S61SjyiHBkIhWo/HAA8SDc3EP7YavRLTn5aWkirrCNM=;
        b=OqUnEmnZBXcL/TtDWP3pcHyeNVDgsfZlE2unDc66zlJxYimlN5JJ8Y9eKQJwMjqr+M
         JBQnsgOkA6usQVPfHmxtpnO6cr66VilQE+berZO+yR9yN6vak0Rqif3cDWOUt3DfDB4j
         kSbkhg4d/ptvL6I/sgrnhDB0fT7mQWfUyc2JsvuRvrzw1PiD/bdZSBSAP2Z3avCaC5aG
         4KFuEjg250cv1FhL8s2fZZRzF0D6lWAv4WJmzE4VA/kj/iUHoskKtT5/TNdmxcycRbob
         HOsCvjH8pjj0PlOpXHNH31gTFvrDTaS/p25YabbPNN3CeP7HdFM4NYa65pVSQXX+zI+Z
         vijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767325943; x=1767930743;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S61SjyiHBkIhWo/HAA8SDc3EP7YavRLTn5aWkirrCNM=;
        b=WWzyWTDC1dxbQpU04owuuS/KzSfGN0W/MlxmbWATIS3CWqjh3yLzggLZP0XoKMNAUF
         h8NV+3IavkyU63Lnv5IDGu1m1tiPMGCCKAqGUOHdyBCFK5tRufn9GLmFyguLNUzDISZ8
         a7q2UdEYrTKYLJ6Pxnkfo/7/9Joqu6pD43sjO2FqeWECrEqWeZYrTM5wetCiRPFj4CCm
         SySLYYOfJI9bTyHKo91R54RYCCvXjlLx6UeIJuCbGiP6MigqLDQJ4kqj3u7ircZUT3ZJ
         tMwTT3VTSxN1BPUF0IpbpyPnUD2iJbFwYLnV9XtO8jVb1K+5O8R6EjobDwLn6wzG9D9t
         IZcA==
X-Forwarded-Encrypted: i=1; AJvYcCU8SMkeXW8bc9KmzdZBw09Ma6szzfXD0bx63bwoGiTQHKcJd3hCrGccsdHKkjKjKin9c+y4e6ICQCYB@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb5rvj3p5k3sRI+z52oQKkkSuaA/wUGhOAxTbm/XcHmVZ+YUcO
	1JS7DRiG/OVez8bo158QnXirq6XnhCABT9a5GfC0TDJzSVIcmg1YF+kM+ldWPKqOsOA0Lg7psp1
	pJAh1IZkyL+N0xKLVOhmjfuLM/0LWflr0GAY3lbLVCQH5C2qehO69FEOwLbZvXCJ8
X-Gm-Gg: AY/fxX7I3/vxvkTWghtd6qiFJTIr184JAlfJ1osocSeJjSP/S68HT52XkDjV6CsI8pz
	aKcIzB6EAnAqeOZtT54e16dRaAJStOcGyQhtBDbPdZuJPXDvRJNc797JmFwCYazq7/bREyinBJC
	Oz9hTCC+EMOiRh0mUk5ENRV2SeIkHXslywbdAiHRUjldWBQhUEge9WrTCaLE/xKn6D2epewm/ZU
	Wf9ihsX8ITj6KWB5YtpLAJhUtPw8pOfnIl77RtKSZZujkFnuexCn6ysBWmiutLr2jEiXdCHp9VZ
	90DT0YZ8mSepIGQDj/ncfs+nihjtkPvhVWmPN/fM9fBtBjlj5ZVFrj5PP5ln0mq9Nn/G0GWiOWm
	XSDW5b28YvzQfuv1CEW6z78GPYT5X7umLdVkvjw==
X-Received: by 2002:aa7:8e0f:0:b0:7ff:c6fd:d687 with SMTP id d2e1a72fcca58-7ffc6fdd6c0mr25749805b3a.8.1767325943072;
        Thu, 01 Jan 2026 19:52:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGCUiCeAS919Ljjowcde1IpwT1czKdpjSEIheCNC48NWCcuQPiQiqia/YF9M2MMiRl0VY40wg==
X-Received: by 2002:aa7:8e0f:0:b0:7ff:c6fd:d687 with SMTP id d2e1a72fcca58-7ffc6fdd6c0mr25749782b3a.8.1767325942574;
        Thu, 01 Jan 2026 19:52:22 -0800 (PST)
Received: from [10.217.217.147] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff77abe95dsm39061316b3a.0.2026.01.01.19.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jan 2026 19:52:22 -0800 (PST)
Message-ID: <93a90b3a-f083-4621-8a25-f3d1171c812a@oss.qualcomm.com>
Date: Fri, 2 Jan 2026 09:22:15 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for
 x1e80100 SoC
To: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com, andersson@kernel.org,
        konradybcio@kernel.org, dmitry.baryshkov@oss.qualcomm.com,
        manivannan.sadhasivam@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251231101951.1026163-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251231101951.1026163-4-pradeep.pragallapati@oss.qualcomm.com>
Content-Language: en-US
From: Taniya Das <taniya.das@oss.qualcomm.com>
In-Reply-To: <20251231101951.1026163-4-pradeep.pragallapati@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: SVSO8qpW8Jqj7lULA8vByTcbFP4qkdP7
X-Proofpoint-GUID: SVSO8qpW8Jqj7lULA8vByTcbFP4qkdP7
X-Authority-Analysis: v=2.4 cv=HNvO14tv c=1 sm=1 tr=0 ts=695740f8 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=gjJwvVq1TDH_Shb35fsA:9
 a=QEXdDO2ut3YA:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTAyMDAzMiBTYWx0ZWRfXzDH3FxX6C5oh
 YG6thT5JvycN9bNMz4fgGa0iGF/DtVtNwF6WmPonXhNqT0AmTuw8C8qLiUbXKfI+GozUKvdMPBb
 5Ki4/z0djcFSau9gD3aUcdIxnVPLgmrt/BwfhZcRX3IA4ppR3fdsNqiNsRROCfpZTB+aH/5sYAT
 icRJp20HJnh3gyG4TzWP4XBCJotqLzQhPl7HJ3b8/F3qB9QvXebuG8sEokOV0VoZh6rs0d0CzOl
 sKsl3NjCONEvoNxPqDEGbVuLWR8r90ir5TUBE5444uSxzzeNIvTRlBBmHDuKoLVTSZyVuRP1Pju
 sdJJgNoJRq4VKJfCC7AoCt6qr6xi/LOJAcsGxESRF/HEZsakghoo7fwfWLapqLulv9o4Oh3+WZX
 iIdvwirVQOtJIYeJcvmhVoCPAqSSum3hy9o+ZyjFyvjw8AfTSrM3WewuYf57mtHFochJAX0jmKj
 z/LiWExMp02YfcNYZ6A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-01_07,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1011 spamscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601020032



On 12/31/2025 3:49 PM, Pradeep P V K wrote:
> Add UFS host controller and PHY nodes for x1e80100 SoC.
> 
> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/hamoa.dtsi | 123 +++++++++++++++++++++++++++-
>  1 file changed, 120 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/hamoa.dtsi b/arch/arm64/boot/dts/qcom/hamoa.dtsi
> index 21ab6ef61520..cd7e2f130fe2 100644
> --- a/arch/arm64/boot/dts/qcom/hamoa.dtsi
> +++ b/arch/arm64/boot/dts/qcom/hamoa.dtsi
> @@ -835,9 +835,9 @@ gcc: clock-controller@100000 {
>  				 <0>,
>  				 <0>,
>  				 <0>,
> -				 <0>,
> -				 <0>,
> -				 <0>;
> +				 <&ufs_mem_phy 0>,
> +				 <&ufs_mem_phy 1>,
> +				 <&ufs_mem_phy 2>;

Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>

-- 
Thanks,
Taniya Das

