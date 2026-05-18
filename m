Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B13E4C6A
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 09:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779094877; cv=none; b=WUpSGVJ/mN7v1R9G6rdXb671RUwl/VhHvt5B1xfLuToOhdnU5rQaBSQGbA70JTpPB5eSvLxQBc/xqY9hoH3deIumj2eatNm7iLRsRqc8A+tO2Qr4qIXOlkOZChy3odVZQpMq+CzoyySe1Fd10fjbwbuXhc53BHRpv57L8A63K6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779094877; c=relaxed/simple;
	bh=RSPCH3qc3Xy4iGF8ehWaeSsdARYzSnxswqYM1yeqbyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U2pMoVl4uaYORPDH1VwbBexylB00zQ4r2B0/+fzkdWpN0JadZ5xOVHVHWiUNYTkWc6fThKKHJfSPTHvBCbP33QC7mP7ZGE8crWdT65XXOxI4K86l6u9K3Bi/TndO5elQlu+0/9FxpywYtZk80JBIiv3fM3uZbQvkUFrPgOtX5OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=juEfOYUW; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Jo7O/4Qw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="juEfOYUW";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Jo7O/4Qw"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64I7e8hD2892872
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 09:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ex/iHFRwmPF119yQVv1TrHAEiQaMqDN5Tz27AKPe7hg=; b=juEfOYUWJv7H9jrd
	+XKDfYTw4cSbssi3/VCmUNSBIBMjwbTHBz2Q2wKO6vcg+xnpWDhqNihY/WmQKZS8
	j5AeKtLgUkG5bQoMv7XJ/MHUl9B4k11EsCJlC1DKtFONj2kT9QEMMCyJc4IhVhVb
	RclNluKpcMYANOBc5lthhFirpQimBb4I7d47QwED6wmKLuHBWldD9kOTg7HXno7z
	ZrV2mOnNhpkpe2A7aPAAdXTYcjdE9h4sSCh7MzzjA0h4qVoIsnDEeS9z6axlRKCe
	4ceUDrKGKmLHlmCsUGYfQMW/SCCb8fA1jhZLOb5tu6uixuCjuCNExhwRSO8X/qC5
	c+2hZg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4e7xk18b94-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 09:01:15 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-36865d109dcso1735812a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 02:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1779094874; x=1779699674; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ex/iHFRwmPF119yQVv1TrHAEiQaMqDN5Tz27AKPe7hg=;
        b=Jo7O/4Qwa0YOA6BCC4owwWPm4lg8i7ajVL9VybCDnPYXledGSdEW+qKVhNb0Ks1IRI
         lVNcqgzKcHdwTf9YpBDT+kXLvKsR5AoMUnZ++e0RKSnIf/zxIQDTiiaDnsU9dwqR1Ibq
         R3tQ7KPoP8OjSABJNtP8fwFMlTMGcGNKfx95UUe7JQI4QrhQow8RJZEN4J+06L9YmIBA
         K127JOyBDRXG41JjKOmyLomYnCI4cajgrzh5/kA3dcy+MTwx2N2rO2XIhMAmGY+aAhA0
         oJCZXbDcyoQHhVI1U7zgbyPQsdraoujycUFv2NSRw7GOUDU+FrKcDQaanLafWScMywBW
         Jacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779094874; x=1779699674;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ex/iHFRwmPF119yQVv1TrHAEiQaMqDN5Tz27AKPe7hg=;
        b=Zu532Wv/xe3UVWq8IsLBElhnoclSz+KUlcklF3+1/w9HHFUv6ji/cRg8N8Qyaufw/C
         ZthGmLNejM3nuIxJQjNqa2kPZ4nA83rhcaPjgNU2sQq97/Yf/Wn7eyvA0zYNs2PPRAh4
         6OR1FU0LRXslD1PggXWcvPGKiM8q2STP3o9xYcVQfoq9rg8GFgEioyI5uNdo59vrXOUm
         /tKnVKL40NE1uc6bf4QZ7181xfhe1m+tQxglIcH0MPtySBowerKAYkH82pkhsoCP3Kci
         vl/MjSQRNc1dFrYpsyXGStGUxokraXT/MH2plzNfm7DnPiyMP65QmdsL4ACF6R791PQI
         UUrw==
X-Gm-Message-State: AOJu0Yx3oSbArNDdJCSmkroLPVw3FX4YJPIVozih+l9vluBo+q24arDr
	bZvkOT8zl/ECfshbAXWS//z6kDGsc2/T49159XSXiPf34j6O0TLC6+A6+y5SrGC2Jzo/ihpUzN4
	9pRrNeOJc3/JGpTLq3eq0hk8bQon+9zyPkDer6DXyK7MS+jBpvhNwM/GF+rzqpZd9OwUNBzK69l
	AQ7Q==
X-Gm-Gg: Acq92OGPH0+Frsi0VBmzqYA4vFYO0kl+JJ4Sng12+V7wVEjdoslOvaJ6XV8gbYLHYbV
	amMbp0aJN81fxf2A8GSjT36djOAJr1aba5Ub1UhWrScEtffaslHNodZGhZOPpXKYtLMHKpLzDEs
	aPYY+sXpq/pUTx4EncWyq88bdeQzq3mQ6vMaN2sCIYC5PeBROC+yGB77YXiXcLxM8sVkynmpQov
	K2GA2hjeqYNsE7bzTjjRwtCCO3wMpW2Psr/mlzU7wIVlgw1shE+1GhpqJlwULU+z/zfFhHRKN42
	5o1zuwZwmR4RdV/N9hGKf3SPQgF2H0oiRrgOz3kkbZ4xb6ewQho9/PnVm7bzNCqmmCpp7y7HUIK
	V1E7AymfKHykifMwQBRoRuSUyqyxXowHCg/a0nhjH6KF6BdC2yCZMkDiYQ/F6nY4S8BU1sR8gyL
	IAopwxMDnDyqTx
X-Received: by 2002:a17:90b:3c8f:b0:368:ddd7:abcd with SMTP id 98e67ed59e1d1-36951c9a01amr13690178a91.27.1779094874444;
        Mon, 18 May 2026 02:01:14 -0700 (PDT)
X-Received: by 2002:a17:90b:3c8f:b0:368:ddd7:abcd with SMTP id 98e67ed59e1d1-36951c9a01amr13690138a91.27.1779094873918;
        Mon, 18 May 2026 02:01:13 -0700 (PDT)
Received: from [10.133.33.94] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-369512424c2sm10476510a91.4.2026.05.18.02.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 02:01:13 -0700 (PDT)
Message-ID: <504b3674-283c-4fb2-bc5e-4a66220b894b@oss.qualcomm.com>
Date: Mon, 18 May 2026 17:01:09 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: ufs-qcom: Use quirk
 EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
        bvanassche@acm.org, beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
 <20260501131641.826258-3-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
In-Reply-To: <20260501131641.826258-3-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: llyeqsGNZyrlRZO4oq6wolwso5Jv6qw5
X-Proofpoint-ORIG-GUID: llyeqsGNZyrlRZO4oq6wolwso5Jv6qw5
X-Authority-Analysis: v=2.4 cv=BICDalQG c=1 sm=1 tr=0 ts=6a0ad55b cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=ojIT_3mfSX8TM-jzfhEA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE4MDA4NiBTYWx0ZWRfXwPzcuUuODcCx
 C7n20ZyDSeIIjZYwj0HtzRg5fK6F8fcS4oDlLJuZje2JPIVZIgGeEGslY+J2bdZ3FALo/gW43z6
 oqfUCDjhArvjj5u0NKdZmCxPwrChJsUP6lsKIjXKwV+JkOqBhq0D00iae77sqci+4bSARvwrg7c
 FdM2et065cHuhKYXZESN7JNhY9FH/qGJr2QhYxbGZai1QCpUi73Zas5Qbp7SeBEx4YVA298Q2NB
 MY3Z+F/sJzrhgN9om7hLydbGoK8vOH+P7nEVBt5kjKmCa0TJdDimBdXXfiIhiVG33zn/nePNCM4
 kWaiXu/r9QPmvEiQ6o2iS8ED2VpLhsLAe7K+xJfSdRHBUvjPA+gBJyK02bnu0UBnLI+bbzN2WM6
 wE5VtgpYLK+DSOx9dCgD1ZC1nuqYcEh/gXw8sLEvfZ6aLYr3/qdGtlK/UQmY2pEIBmfx95CqfMs
 wjuHXpwa27A0VPZfK9A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-18_02,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1011 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605180086


On 5/1/2026 9:16 PM, Can Guo wrote:
> Use UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3 for UFS Hosts
> HW major version 0x7 & minor version 0x1.
>
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> ---
>   drivers/ufs/host/ufs-qcom.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index bc037db46624..7b6957ef164b 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1305,6 +1305,9 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
>   	if (host->hw_ver.major > 0x3)
>   		hba->quirks |= UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;
>   
> +	if (host->hw_ver.major == 0x7 && host->hw_ver.minor == 0x1)
> +		hba->quirks |= UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3;
> +
>   	if (drvdata && drvdata->quirks)
>   		hba->quirks |= drvdata->quirks;
>   }

Reviewed-by: Ziqi Chen <ziqi.chen@oss.qualcomm.com>

