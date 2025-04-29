Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4FC26A0CA
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2025 21:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745963096; cv=none; b=sT77NvhemUcleyaroBFhFrqGwVj4QYrIog5aa3TsqLxREEN1QErYlorvnus9ogJ/cOWMwMDxRiEUBRlOLsd4K1SglW88GAwh9pvxX+z+daTFE2D+bYMHkPoQ3D6J4IkN0gDX4yHND2zw7oTmfQXORUJwtxXTeDk4pjv20uzspA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745963096; c=relaxed/simple;
	bh=qkHp5l9+nz4MH1uJ3GUPU77Td56tAw1bQXg8N40pIXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oMNwiU6swVgCdx5Zm9u0Uor5PI1MMFvekDV1O5uGwjVVB8A8y5VytyYEBQGpdbIjwXOCVsAnwAcb3UQjoNIIa2Wq3jxlbw3A02LwcvIMntV7khMpLWicLo1T+6UA09oVxRs/VWrTjY+job/HvRd6x2mckhQaA47k4ZcmyMAcbTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Rxv5evRz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Rxv5evRz"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53TLaaqk029568
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2025 21:44:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SN6pjaM2etTBGja25JzheiP58CmaPRV1x4Pzl8D4/+o=; b=Rxv5evRzs7U0gFZa
	Y58Jvr8LRRYyRBVb0wvkgcfcrcLCQ2MO86ObiCK8lo7m41HSHK6F6b9hWrygDEGZ
	7SCYb24IWntAAT4Vowd3oOjvEghgr2VDu7H8+jMs8IFUCdmeBD/ae94PFm9B2oQL
	oki2d4F+qM7mNqng4AMekGQgJJdTQVWANIWNLmP1YdOyh6UjMVmMQiSfwPS7K6VF
	fftJyVr9KAiUH4UVl+EEXiTHHXm1+TlYdRI2OJXdSTV/BMzxuEm995RqklKCwGPI
	FELB6KZ9YyWfwV7ALLqfavax4IMvBrY1sJGhOTqNXxWJMFy2g9eGU+Cb53MneifE
	OpOD/w==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 46b6u7r0gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2025 21:44:53 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c552802e9fso109498985a.0
        for <linux-scsi@vger.kernel.org>; Tue, 29 Apr 2025 14:44:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745963092; x=1746567892;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SN6pjaM2etTBGja25JzheiP58CmaPRV1x4Pzl8D4/+o=;
        b=PwRucvReZP+lyX3BMAw1MpnRCmR9CIq30J+o6Fic27xGGlh/lEldY96IJiuaX0Gtfy
         c+R+4TnsO2GMu4gfiilIVZtFMIcOOb8BkGnfHzOvP5GgrKepC5B1F+P7uwunVJOLtFSi
         isNfWje2yjdeD73zCGLW3CnOlG/4XNstFxXOxYvU43420JceKKpL5+LYxq3K6tI4aumx
         VIto/m716uIlyhMwENa7bgPkXaY1u9qIDh8u2xsuysn9mH0qNhQ0DNdEmTnESmMzWrxH
         W+fZPlGQS/A68LouI34Pc5yT0px9/7JZCATlyBv9fAOz3bXAWV/V3z+4sdWc1oduooJ6
         WlJg==
X-Forwarded-Encrypted: i=1; AJvYcCUaEI7QLOQHKx9I0+GvG49gj0y+WNle2y9vN/cXsDy3IDghzevVe7YerT0vgaD0fBd+RTErLTR9zPlV@vger.kernel.org
X-Gm-Message-State: AOJu0YxRYoXLl46o6+t1jWPoY5iK/E6HlVkkocP0QRlb30WlblYEcKnx
	O83YdhKB8ATA9J7USbBRoOHELLQ8alQMtfBdJzdqMPLNjbAxg0JyQc7IqnzpdDBoanUY9gQge+O
	jT5o26F8mXKULOCTdE5USFavIUy1W4KgA36K3tcoDM/tBYHi8TwnNNRuJzmhF
X-Gm-Gg: ASbGncvCGcHzG6e42jmJwLeczQhW4zZ/cI0wH3t2WttEf5cvzohAKl+B1ryuroTQRMK
	Cx8khuP2LeURSodhwwBlCD25kbkaTVtivm9vUlpcZ6KA4cM1BU+XyS0ATGNSDyw2KnAGEC8w67C
	NpxRhzk521W65B/Mb4szC3R+6rV8olPIpZjAXDjF69DwoGFwaK1S81CD0cg+LQRGHnPVyD1wn8Y
	T3qbAnN56wJjEU+p0BkZvlszrbYh8NUUQprzhH59a+6O6eBmA9LhijewDXRaC7lvoDAWzzTJF7O
	tr45kCHcqmrsuUWv0Gkr10Iw5m7ouPufcI+Ru/CffRX/Rt2Le+HZtYaLZyczdnQ3Aw==
X-Received: by 2002:a05:620a:17a8:b0:7c7:aee7:b959 with SMTP id af79cd13be357-7cac884649dmr7297385a.15.1745963092334;
        Tue, 29 Apr 2025 14:44:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4U0UKZFlmd3TBQNHJ/q/KhcLsN4Pb4aGDLUgdr3LZ9oZ/GjbmxIHPsdffiOjq8p8tlXQqVg==
X-Received: by 2002:a05:620a:17a8:b0:7c7:aee7:b959 with SMTP id af79cd13be357-7cac884649dmr7295085a.15.1745963091773;
        Tue, 29 Apr 2025 14:44:51 -0700 (PDT)
Received: from [192.168.65.43] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6edb1d34sm828131166b.185.2025.04.29.14.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 14:44:51 -0700 (PDT)
Message-ID: <fd1d1962-82e1-4b24-abe3-2818c0965a5b@oss.qualcomm.com>
Date: Tue, 29 Apr 2025 23:44:49 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufs-qcom: Add more rates to
 ufs_qcom_freq_to_gear_speed()
To: Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo <quic_cang@quicinc.com>, Ziqi Chen <quic_ziqichen@quicinc.com>
Cc: Marijn Suijten <marijn.suijten@somainline.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250429-topic-ufs_sdm845-v1-1-faabce28a63b@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250429-topic-ufs_sdm845-v1-1-faabce28a63b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Ldc86ifi c=1 sm=1 tr=0 ts=68114855 cx=c_pps a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=EUspDBNiAAAA:8 a=YsRWGqPVQEfpbUtioscA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: mLv6tXH2aRa9BZGnEDYwQqZ3AhPk6iNi
X-Proofpoint-ORIG-GUID: mLv6tXH2aRa9BZGnEDYwQqZ3AhPk6iNi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDE2MSBTYWx0ZWRfX1QwmSE0mSl3e dgl02L6XjTfWrFCoMDaMZNsOLpkBJaU+zJcq3c2U/G0B4QKvtBtCXRuAoCu7Lct/eTZ23oYp/Ip NyYSEA8XZWvn1IigrIyRf/JXQ7BirGiMluVT0L6e4bE//e/JY6TSi8IdwQxIqhULTrj1mN5m5+q
 Xj2AiczN6J8ZYdbVih/6ROSi1lkBtCUTkxF3u9JsbtbA9+Y8N7RF1trgiqDZQxpl8TMzTrz2nvM PaFV535MrsSaiEgshLSf4Qr+QBmJLRAHYC4eOjQg7ef4iYrulMYDogC/E/cy1tANPrGznuBPW9L +K1U8J/XKlVgHfX69bWftP6IgYTiFYmqEvx1j2zNMGXHrt/+0jDAOQWPHzn0frLM2siU4IF3Tyk
 s1498VlZoKM9j/evV7e+bqHA2SOC5l7R7ATygIhCYTVXi79PG4ZYur47iU4rDe2t4N20t5jD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_08,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504290161

On 4/29/25 9:46 PM, Konrad Dybcio wrote:
> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> 
> Booting up -next on SDM845 results in a number of warnings like:
> 
> ufshc: ufs_qcom_freq_to_gear_speed: Unsupported clock freq : 50000000
> ufshc: ufs_qcom_freq_to_gear_speed: Unsupported clock freq : 200000000
> 
> Add the rates to the switch statement to make the check happy.
> 
> Fixes: c02fe9e222d1 ("scsi: ufs: qcom: Implement the freq_to_gear_speed() vop")
> Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> ---

Please ignore, I was informed that the issue exists because we're checking
the frequency of the wrong clock, a fix for which will be posted by another
engineer soon

Konrad
