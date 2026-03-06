Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0042F1B4257
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2026 12:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772799949; cv=none; b=p3ZFB72tfSbg7hKI1NN+TBg/pzxJY/HFy2FVRfPqzPEliLFCwWoo6lrAh7jtoYsTywJRxEJs1qT4VQiCi5cx5Xr4KwINh3MdOOLHqtPUI6JJjKZpiFgFy01wVL4LGkK0KlDUdKwSJEpYT+sOjyimr7PmTW9BS0JNUX5ouM3ia+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772799949; c=relaxed/simple;
	bh=q1mpQNuvkguIV3yJYO03VFzF6mQ49ojmlZq1IbYRwws=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P4Kb2E+l0AlNCcLa86UTO8g+LfHXgbyTJNujpsOXCOXlDEXnBJyJHylNgVsF9pPYUxHlh5bsnFVTURGUiUtsF7VYuGtCpv0Q20KP6QdGP91C6Q445yL/XXR1jhvHVklENdag80aZj5QsEnSMEOjCHlCW2UNAkkOYtfTAfSTZ3v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eLCnNkmL; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fddOS3wE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eLCnNkmL";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fddOS3wE"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 626BawDh3406376
	for <linux-scsi@vger.kernel.org>; Fri, 6 Mar 2026 12:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	NUkRbAo0c0S2TlWvB7t+iwi/GOepW+rNCNuvKtI+MXU=; b=eLCnNkmLsPJYxYtg
	qdJjU55/C4Mu8i+8CIxARztWS2jZUyolOBZ+nrPYrQFKlh62Im5f1/+YO5gzJER8
	jQ9kXAJVS5N00YlYWuzMa9yjLabWlSw4OS6VUjSSbKaWSZ8O/HRSNI50q6waRQkj
	uBSo0noKVLjeGoe9rPUedr668o0PBV/t/FJ1it0dbYuWvPGqg6oS33rOUJZdJRg4
	FjtmB6HGIBk3WSqx+fo5KZSppwIbyp+2t7YJmUXRkNBp3sG6NkAJEwWym8EBiEsX
	VvswcYq8jUmZ/bpwPTh66Pzig/sCmPA72DVhfEeyTDE+Um/Nd+KBDdVFHK+/DFAl
	BzSMzA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cqv9u8h2q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 12:25:46 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ae4f27033cso56995955ad.3
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2026 04:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772799946; x=1773404746; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NUkRbAo0c0S2TlWvB7t+iwi/GOepW+rNCNuvKtI+MXU=;
        b=fddOS3wEeZmTc69zuagJBDroXx9CGW1CfAbhxENcpnI1vCkuIbDQNq6GoFvk2EblXf
         jTZqqKWNrPU/gVkWPRrxXa2mjuT6Sm10zlLe6iXNL3lWcUx3Z853J1/6535Kt9PHmcL4
         nQpvSnYrk6RNCm191JEpW3kF+oHY26w+9pYY9xGickFGC82qfPFS2W+6ARxyJUYw8wdi
         rbvUHcEa/xsImNyVV81rIFrQETbl3CRHMpRLT1+xdvUr4q7r7VNCrH+FuJu77vATv1Qa
         cu1it421P1efquylEKxadAHwX5GRP+0nzaRubTZw8MvyIk7ezvA/P0aHVxO8jRXBdp3F
         8q4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772799946; x=1773404746;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NUkRbAo0c0S2TlWvB7t+iwi/GOepW+rNCNuvKtI+MXU=;
        b=s7lWbeRwwNYWS82fs5amAQ40DP8ck73kOXGihGRvdj8LLZ/1pBJSxBHQxBZZxSX6r+
         Y/8aF57ac2kBQpqyqjvbXlDcnhdJ6BDuW/AsMbW9NG6J8T8z+Qaj7swaoJvEn3mJVgpa
         27ZAo5y1XieVb5W3dO8ngmVLtg76ReN32Ruu68yQ5DK4fcMD+0SPHBl3eo5yWkrup84F
         GRP5IALx6wIoCaHRj6GM99D+WT65aDlwwTlAK0DX9mAPDhHB6TvwBoBRIT9gwOnDWGMH
         qrBrCz2xm7vGVUlU+QJifvyFjA/+MATCiMLEmrxXREyv6kLyababHkfPIWEPNLnpTi1d
         FjsA==
X-Gm-Message-State: AOJu0YyejGsxt71JLus0PZpcItZuo7Vdw6gbXACAOsg86Z+SKGHQFksK
	4VOB36ECQ9Sxc/lwRnbDGRmsK/FLwgYv+pf+hg+doXs789l1SSWplqHIzwZXIk6MNkW96Drd+zA
	BYFlUiJzmYHj5hxr1KUHNjq+4RPmhH7cee47yTbM+OnEPhZS5ZSwqCTnW6XIkMb50
X-Gm-Gg: ATEYQzzM/aND3pyUPeETf43n1R13tEv66NllF+w55UHeCK61I5SVWzIhA6TKIAs9VgG
	bClJP35+WRmOY3EDNjNGp5VqZx7tbsKalQM9NHqVG9xO9ffdTjL36segHdruM9WnOVJb9h8SNyj
	S2FIMwhcmp4FN2OsZ6xrLVQ+yItU6VK3hO7GmR01IBsgCQcbO877lk0V5HnbbZD6ZwtZHK9VuDL
	TuLT8azqgpr/PWy3RKWwuBjwlhrtzo1mqRfE+oTTX3HCc5QihoxT8uaW4zpyY3Xc7RtBTa/w3A/
	MQLEcmL298QPzkQ0okdIgI51mrJKCI8nVbVYh7sVDSLXSkpVuilDm1xaEvvIE4imkju7Zit3Z7e
	W5ymYRxl1kfRxqv2YJbVKxZ/LIpAZhJmQzrMum5+/YXEe+QLkFJY5HaXDi3OLbBsywYHDt96s0X
	CgAfxsteIJu/Y=
X-Received: by 2002:a17:903:f86:b0:2ae:3f3f:67b8 with SMTP id d9443c01a7336-2ae82382430mr20485395ad.15.1772799945437;
        Fri, 06 Mar 2026 04:25:45 -0800 (PST)
X-Received: by 2002:a17:903:f86:b0:2ae:3f3f:67b8 with SMTP id d9443c01a7336-2ae82382430mr20484965ad.15.1772799944923;
        Fri, 06 Mar 2026 04:25:44 -0800 (PST)
Received: from [10.133.33.226] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae83f74e4fsm18940945ad.58.2026.03.06.04.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 04:25:44 -0800 (PST)
Message-ID: <2ffc06fa-002a-4058-a78f-9ff60da9ed22@oss.qualcomm.com>
Date: Fri, 6 Mar 2026 20:25:34 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/11] scsi: ufs: core: Introduce a new ufshcd vops
 negotiate_pwr_mode()
To: Krzysztof Kozlowski <krzk@kernel.org>, avri.altman@wdc.com,
        bvanassche@acm.org, beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
        Ajay Neeli <ajay.neeli@amd.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Chaotian Jing <chaotian.jing@mediatek.com>,
        Stanley Jhu <chu.stanley@gmail.com>,
        Manivannan Sadhasivam
 <mani@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Archana Patni <archana.patni@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-samsung-soc@vger.kernel.org>,
        "moderated list:ARM/SAMSUNG S3C, S5P AND EXYNOS ARM ARCHITECTURES"
 <linux-arm-kernel@lists.infradead.org>,
        "moderated list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-mediatek@lists.infradead.org>,
        "open list:ARM/QUALCOMM MAILING LIST" <linux-arm-msm@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-2-can.guo@oss.qualcomm.com>
 <8bfda6d7-f802-4b44-858a-f52ac8c051ac@kernel.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <8bfda6d7-f802-4b44-858a-f52ac8c051ac@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDExNyBTYWx0ZWRfX91SnTdtPzYpL
 cKHXJkhFn1Y4e0NEZoIV8OHUVqErtiUJGw9BPZefiWTsTNQVwR/3XStsggDdnWT+/MvQ8okSr4g
 jhFqHaBiF++ONgUZBA0lbxpIdJishn2c8MLrWugvBeE+DNREbrcSBBagf9/miCKcLlGbSw+6YV0
 AsThSobADbnpc6/f91jH1iKI0+Rb6LHic0IkTMx07idueb2OJX1WcU+qskC7SY/TAM5nWmhegHz
 GokVM5EA16Q359KzvQHez+7YeeYgtL4/4TFjB50nlHYvnnJjE2t8gxT2jp+TptFSrmedKkRhRj3
 5pcyXgIFdTC0kY66KOu5eudt+KEOvQHHb0MnpJrEOBRV1M6AxD3SPyCdWOWjaQE+QNKqcbxPvax
 1s/MPnYdf5ScaVo26XzKTn7+BwolapP77CINjCezi/PgseuY+AAg1989tEq2+5pZ4XW+q6n9qlv
 sJ2vMLbsRPHTIhGJAdg==
X-Proofpoint-ORIG-GUID: vyUb37s9bGbvZj8I_YPc6gfJA8UH5Zb3
X-Proofpoint-GUID: vyUb37s9bGbvZj8I_YPc6gfJA8UH5Zb3
X-Authority-Analysis: v=2.4 cv=eJoeTXp1 c=1 sm=1 tr=0 ts=69aac7ca cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=bBPRlu2x3IQPgS2CUtEA:9 a=QEXdDO2ut3YA:10 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_04,2026-03-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060117


On 3/5/2026 8:53 PM, Krzysztof Kozlowski wrote:
> On 04/03/2026 14:53, Can Guo wrote:
>>   {
>>   	int ret;
>>   
>> @@ -4747,6 +4745,22 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
>>   	return ret;
>>   }
>>   
> Missing kerneldoc.
Will add in next version.

Thanks,
Can Guo.
>
>> +int ufshcd_change_power_mode(struct ufs_hba *hba,
>> +			     struct ufs_pa_layer_attr *pwr_mode)
>> +{
>> +	int ret;
>> +
>> +	ufshcd_vops_pwr_change_notify(hba, PRE_CHANGE, pwr_mode);
>> +
>> +	ret = ufshcd_dme_change_power_mode(hba, pwr_mode);
>> +
>> +	if (!ret)
>> +		ufshcd_vops_pwr_change_notify(hba, POST_CHANGE, pwr_mode);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(ufshcd_change_power_mode);
>> +
>
> Best regards,
> Krzysztof

