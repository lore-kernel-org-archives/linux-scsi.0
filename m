Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FF5396B82
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 10:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775818665; cv=none; b=sbhAnphgCzpJR9/RBq1md5BwgMI4NAx6SdK5qXhz+sRjnUIhUL/sr4cm4jMzso6kPYJRuFCpstL2zIAQzp3NjDImldx2w72fzR5pPOP48uBSlnue01dQw7SLVtvNoAtFd2LSP2AlrBBiFcrBhbb8skVUSbq6Pp/McSadRmRRDfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775818665; c=relaxed/simple;
	bh=+q+1OhDdzvPZ+krF5hp5AKstKd3Qe2GUMwhgQ5xgalk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LMJoXB3pAN3Avw4/mrdvh8qcqoyyLDMirHQoz2bD4M0fqPDXe+GsU/n3qe1RK8zI2Ft6aIgRZupouaeI/thxI2et7lqHmRwV1JB2UU5gOwD0Ax5qxRvXD6SP/71DnR0qv2LkJgrEcR4oJj4FXbB598YPJ25Q8qNohcDIxA2pmQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CkdTtaf2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Xxsn6grA; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CkdTtaf2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Xxsn6grA"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63AApA3c3742959
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 10:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	A8SRtNLpNrKw7SKWjiRL/dpR0Kq7TCMarVsjksXHNUo=; b=CkdTtaf2nqO2xGy8
	Bi410T3HIY9W7ZVvMQzBUGspYTiLWjE+ICQmE2j+qe8fXz6QfmQZq7xrJxg9Aeqg
	1bHek48yjW6VfugcMLvj/et5eBFb7eFe2wGQIuJIOwTu+hZBmyIPk0AfWLTyX/vF
	VR7SQ6b286brkyvfzsnCzb5VCVFnwm2luRlVBf1/XfJTz+Wl+IegnsHWtTotUQjk
	1LEqvY635IeSOn0pkb8E3Tx97EwT9YDMeO0fZWwWUAo7L1OnFHZmo6TdO82fCGjX
	aR5wLwGCm34fPAgZheTJFKeYYLdbOSnoDEFBUoio63nlLy7/E7gi3eGuLD42OTOD
	zd8cbA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4deytng0gq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 10:57:43 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b0c30b51bfso34006125ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Apr 2026 03:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775818662; x=1776423462; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A8SRtNLpNrKw7SKWjiRL/dpR0Kq7TCMarVsjksXHNUo=;
        b=Xxsn6grAo6ebetO+WFMc1Xf0DJQU0m8YRVLRhiJPb8w+8iAeGuON5nJW4SfQXAzCDT
         KBIvFU25YN+K1l2UlbBp3QTXwEAGyA/lekiHSPDOPPz2Jvu9bcftPT42KdP6S3W1MhTm
         bJC4uxhYiVZKQuVPJwTmEvxlfDyFQfAbcmeo8LWnQj7QgylsLhX96VDwtLeKYdCm+Uih
         sy8beDsbsWPRpH783VLkeiwEfmFvIAubjTI0KArO6Bka/ALD9tqSGDKYpccs+BHim5OE
         hvaD+BKMJc+ylVebSxzGgKRMJV6o+s4DKkTlaPoOxzzoJgzChlFvTkhOAtjdrkCgjJnd
         LC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775818663; x=1776423463;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A8SRtNLpNrKw7SKWjiRL/dpR0Kq7TCMarVsjksXHNUo=;
        b=jpdhF34g6mAQiOjSB3cv5vo28EcKu+kiYdpLaXsRB6Wu08Q+Ns7yi073sZdBVeJsT2
         C6l57oc8kaIrgYLZRdjePDyuJcTKLHl3ytLUNBmkY2TsMm9DrG/bZ4zO1HsZAJBx1VZ8
         TF6ftW0HTeoGCWI3JtwYkFFz9x4zQoppFDEtG+yrLuZOaD85iAK+ZE1IeXtVGGKfc2fH
         T8t7/BKxijuxtzihtXzQmcCM/XUqaPhdRC3Nl+1KgRZ8D3bDeDr/lmucmlxS4WrnfHkW
         LFnq8Ie/XL0/TZQXL97aFR6p9hhjvllzvHXODXfsMgH+ElxbcVn4pmg2hC3KMZLkZc73
         INTA==
X-Forwarded-Encrypted: i=1; AJvYcCW4di22s+/F04j79qaViEzwXp7kzR9FdgVnrdxcKZXvs73fdPJOY1pl+0802kUZQxKeDR/F/0Io8L0/@vger.kernel.org
X-Gm-Message-State: AOJu0YwE/V4ywwOCnn8xA6rdAeilESSweMgB4zNSZ0MK6bZ1wdVKN6n1
	S12qoN6YCY86f+UXrT5mWyNQy7oeq7VwqfW2Ppt1Qxa29NNJ8r71TxBZUgD3I2DaJFgha8i7/eu
	0ekj8BVNIOggA6RKpPla/ZRVG7K6fWlzo5nu8Zy4fq8RhUcJ9bIw1vAggfiqV6Ro+
X-Gm-Gg: AeBDiesd3FqJgVu7a9WUNI99okFvnAMsTjG59vQlRc4qJR80KAcX29FVTZukpGXXRTP
	WXpqhKiBNSfAzTCdk+AdJftaLEQFJqa2J81PDf9m0uV4Cw8fa07C4/xGsOGsHhzX1zUW4SFMh/F
	QntQUXGVU+x5KnwK289wMlFaijnkGSv5cQLTlhjmgqcv8rJMeOYm9WihAv2/tw7waequWeIqzIm
	oYsinOVVjpDN+pXAW92/B86lDSP7ZL37dY6YHDId1bKqKoql9GOVIrNniZ4tqXI4wuUlhyiM9m6
	QFMZfAH05B11Hv3A7qO6W+L/86fM840XhIyYUYw7USkAoO79umqir5PM1rSHQE5y+PChEXGk3Dz
	EC3ZT6rY4gEKJAAMQR/M0ZpVDpLLPPIu40ocIN2j88WmPd1rCXIBE
X-Received: by 2002:a17:902:b101:b0:2b2:5491:e32b with SMTP id d9443c01a7336-2b2d5a2a296mr20063565ad.23.1775818662533;
        Fri, 10 Apr 2026 03:57:42 -0700 (PDT)
X-Received: by 2002:a17:902:b101:b0:2b2:5491:e32b with SMTP id d9443c01a7336-2b2d5a2a296mr20063225ad.23.1775818661968;
        Fri, 10 Apr 2026 03:57:41 -0700 (PDT)
Received: from [10.218.44.178] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4e15f71sm27075985ad.34.2026.04.10.03.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2026 03:57:41 -0700 (PDT)
Message-ID: <71c6c453-4a6b-414e-a039-80f36e948489@oss.qualcomm.com>
Date: Fri, 10 Apr 2026 16:27:35 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/5] arm64: dts: qcom: monaco: Add OPP-table for ICE
 UFS and ICE eMMC nodes
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson
 <ulf.hansson@linaro.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
 <20260409-enable-ice-clock-scaling-v8-5-ca1129798606@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260409-enable-ice-clock-scaling-v8-5-ca1129798606@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 8L7yC2RfCMYYkHJAY8urP01TzRBDYS6D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEwMSBTYWx0ZWRfX3tP07Hp5SZUY
 Gd9LBbYr5Kv5tLrns0JNMDhOfubnVo7PtVVKacj8Tsh8ZJEjLA2YX4+vL+TcuzbaXgDUHEIvfOI
 e6xetY/PmOF6pJb28W9jjYQePJevdeuVILiuP4W/ogVmMxrivbLpAhZJnQyV5ew8NC203u/osBe
 tm+XlPq9gSZKQI7AajV5O6U8LRGOTLcLAfKtiKRYDUfsO8yYPndCaxZirY2NSS08cY8+R06F+gc
 U3Gbd5Q5LHzCTSMU6tHB7odOtVxSbNgLrPyukPLm4n8cH8EDsfFbbe6+44eJuv9WAHV6d40i0Jx
 QckAg4VUih9JRsFGVMf7rqYGlrVmY2vRrMzDI5FShkyKr3mZ5dTo4jtGN/kXQ49/7TQTrAwhKTq
 3wsWGRwA9b59JX5TJn6hfLUd3DbSuOWeTqYOwf6EhuzBmlKWp8gF0welDN5sul8WJn8esprjfwS
 f++72Ccel2PofYAf7pw==
X-Proofpoint-GUID: 8L7yC2RfCMYYkHJAY8urP01TzRBDYS6D
X-Authority-Analysis: v=2.4 cv=crGrVV4i c=1 sm=1 tr=0 ts=69d8d7a7 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=QRdWpJMrku1fmPn5X40A:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100101



On 4/9/2026 5:14 PM, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS and ICE eMMC device nodes for Monaco
> platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/monaco.dtsi | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/monaco.dtsi b/arch/arm64/boot/dts/qcom/monaco.dtsi
> index 487bb682ae8620b819f022162edd11023ed07be8..cb0e554e94d237b0adccb55fa9ed967bae9eea05 100644
> --- a/arch/arm64/boot/dts/qcom/monaco.dtsi
> +++ b/arch/arm64/boot/dts/qcom/monaco.dtsi
> @@ -2730,6 +2730,22 @@ ice: crypto@1d88000 {
>  			clock-names = "core",
>  				      "iface";
>  			power-domains = <&gcc GCC_UFS_PHY_GDSC>;
> +
> +			operating-points-v2 = <&ice_opp_table>;
> +
> +			ice_opp_table: opp-table {
> +				compatible = "operating-points-v2";
> +

75MHz is supported too. Please add that entry.

> +				opp-201600000 {
> +					opp-hz = /bits/ 64 <201600000>;
> +					required-opps = <&rpmhpd_opp_svs_l1>;
> +				};
> +
> +				opp-403200000 {
> +					opp-hz = /bits/ 64 <403200000>;
> +					required-opps = <&rpmhpd_opp_nom>;
> +				};
> +			};
>  		};

-- 
Regards
Kuldeep

