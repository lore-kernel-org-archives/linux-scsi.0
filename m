Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59131EEA31
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2025 12:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754485020; cv=none; b=ahlh4MDXuYpdO5AUT20z4TJBWAtMwqVtiWq8XcgLTWiwQbASkLIhhrZ+n+cjRirEfLuO9OT+F4EERjv4gZ1WvUtUPuKlwy1DnzSSS9Dp4N2ZoBQTkZXAQTqpcLD5EkQ5CByB6JZk/TSQADRJiOJ0+9x7+onj0L/svMAZUnZEnwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754485020; c=relaxed/simple;
	bh=F3XHAgV/g9t9Pe4DihqURvItO9b3hVigjb6udFTYxTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lVwWaMmXgazsPcluj8M4ywwIZYKzJV8FhQe8zGgWRZwhVNcKSenaI+yryToFEIpclwZhpSnWUiOThURs7EQliqFj+MGnJkM95TyQAFp/M/c2a7MhDNq6DXTygVHaaZfxSSK3YW+vBiFumvFqWH/sBbycGriT0zsRVwW19iCqaac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z/xSjPjv; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z/xSjPjv"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5769eqVI032385
	for <linux-scsi@vger.kernel.org>; Wed, 6 Aug 2025 12:56:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	RegKPJzk3RnagfrkfnZuONX0t7ULdD8AHnZvaN8Nsuo=; b=Z/xSjPjvslBXRNWr
	UEpX/VOoqncvDHYoUTIcf2DyUIwIAWvmZXLNmJGnKZQpqw8WW+tKl7Qb5vlkut5W
	6unRVwBVXQbijrgLvf5uE6ctmNqjj4yQ6U20bdQx5Uppv94Xd6HfMOFnyt2ZFjXj
	nRPPNWsjq61r7Gy2Z/bc64BZpk8GsrBJ4XtCn4EbshvSyLHF95ZvGExbu64oviYX
	zkUEcPpspmXsU1oKTeC7fNfZ4300cASp4ibJVacrBdkuouTenJorZT/lVrDUZ9yj
	yhgjvELYml2UTYqGcnsQ2qdKEPh3JK9cDDZm4eIR6E3OKIFj61RcCdok3NrDioe0
	8N6AAw==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48bpw2ttdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 06 Aug 2025 12:56:57 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-7092ca7dae0so15449336d6.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Aug 2025 05:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754485007; x=1755089807;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RegKPJzk3RnagfrkfnZuONX0t7ULdD8AHnZvaN8Nsuo=;
        b=HP09dZ1RlMQ9XnFefex+SRlxTHUlTXKjCwHZEpBWSycxH41WT4gExe+RIjIfOl/yQl
         C6Ymk3n9l7IzwBgid7pAaMNK3+n+XktGM8XphQCY1PwiL80Xomr/t0pwRtR8RZlvQB1R
         1Hqr7U+nd6z261AgVM7TDIy6VsmS/kFjrWTTNrpK1zB+oxtc8+C2+IISb1sPdp6y8Pt5
         yRN4FyTL0KFJJ7Vm5oo3y5RPIfblVL8Ieq79Eb7bdhaw5BY1+FOHlJeWBUa0D7u0Ek3i
         Q4r0zfF+8rQt6NY6gig39Lu1DPilQ8wCwf+1249dhSiKPY2q2Me+OBHfDG47imhjW2d+
         bzcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcuuWyqDM1Vj3gqpcWCBlTp8EMGXNCpyXffcpryXYLbqUNZP1FqdXkOZyu2JyvlqAATKRORj+odQy9@vger.kernel.org
X-Gm-Message-State: AOJu0YzBdOttClJ/QWA/Jfi2zozJcOhgSCzVpkITyLQbycKQ/tPU/x0e
	KosizkMA3bubwhO+cUpEXcRID+FulXytR62Yj2nT80yBaj7nPgpmBfNeY1ijyxBWbVyTnA1BYgX
	6dSmFZuacB5GWXnyniO0+mTegsbcx22ZqfJTSMSRJAjpD0u5s5rkzfZIOIms1rBlo
X-Gm-Gg: ASbGncvtOWQn7F3TDhsdgWCxAwb4nqtzws+N1JGchdXfSFwikQpUuT03I0X9e+xrNkn
	h5qRxPLrMV2DroyfTmueA2MCHH4h/opOWBAAd3ZMau5E7svt2pZ/iKNEHXfWnsPe6spB1CMwXre
	nQaHWLurFnvBXfcldb1GLM7xv7WMFHSyheXzdCbGzplzgJCkCZPFAPJKsMH4M5sI9WADg62hUgp
	nw/CknWMvpfCrKOCAwz1E1zqdEC1opl0OTpbYsaMksT6tVLHJMKOkgZH+RcixNPKWA5umQmAJyU
	UgenSXxp9X4hscnxYe1jG1kWpTiZtndRfjakRGhjCrtujC+0x96zC93pVsU/jjYT0DynXf5tdTp
	YnCiv8rfBhcIAWAbRfA==
X-Received: by 2002:a05:6214:b63:b0:707:4dcc:4f56 with SMTP id 6a1803df08f44-709796abd94mr18722296d6.8.1754485006760;
        Wed, 06 Aug 2025 05:56:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFfR9Z4zfNZbubypCaNT4t6gxrEqBn7cwk8E5n1N8Nu8bR7i9WrLvmOe8gMbV59slrbJZLEPw==
X-Received: by 2002:a05:6214:b63:b0:707:4dcc:4f56 with SMTP id 6a1803df08f44-709796abd94mr18721716d6.8.1754485005351;
        Wed, 06 Aug 2025 05:56:45 -0700 (PDT)
Received: from [192.168.43.16] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f2d554sm10031187a12.27.2025.08.06.05.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:56:44 -0700 (PDT)
Message-ID: <c62c2744-0d07-4fe8-8d2a-febc5fa8720a@oss.qualcomm.com>
Date: Wed, 6 Aug 2025 14:56:43 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: ufs-qcom: Align programming sequence of Shared
 ICE for UFS controller v5
To: Manivannan Sadhasivam <mani@kernel.org>,
        Palash Kambar <quic_pkambar@quicinc.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com
References: <20250806063409.21206-1-quic_pkambar@quicinc.com>
 <ucr4imzntw6ghcvpeioprmva7gxrqnkphjirjppnqgdpq5ghss@y5nwjzzpvluj>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <ucr4imzntw6ghcvpeioprmva7gxrqnkphjirjppnqgdpq5ghss@y5nwjzzpvluj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Vbz3PEp9 c=1 sm=1 tr=0 ts=68935119 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=COk6AnOGAAAA:8 a=CykVZ_nljMR9ycAI1QEA:9
 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: cZ80nXKsBB9O6R2ccg8nG8YtKW4cE7f2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAwOCBTYWx0ZWRfX68EOub3cDl2R
 pWKr+LMh7ZLG+lUGz///auw+cEzdmGb4RnJD1XmKp1pndUs1xQWjdZS97DakwudAEM4oA4I2H+A
 gzCK+KpvT8oZT3dpMHSEGlsGYjNw0dgi5BFCazBf54z90NXS36hFCqC13GZaBalUUJWoVvbfW9k
 B1sp07s8BMQnnLzj5c/YDqROoKyUQ+xRVNtysjslqWTazmT25xet/Qmn6iQI+eB9pAnOKAibcF/
 Onnn48Om5wuFuHVKOq9icedya5BLF2KXRxWwIuvY1KfGYtlATeSYkK/CfWuYII7Enn6o5Ni8UWP
 WECsv1z7xlTmvNjAFgnCg2jCFrMlcT6jsBIjj40zrauYmbd8OEz+r/yhn3c7dXO1B8e3hiy4Ce9
 0S+QmQEi
X-Proofpoint-GUID: cZ80nXKsBB9O6R2ccg8nG8YtKW4cE7f2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0
 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508060008

On 8/6/25 1:14 PM, Manivannan Sadhasivam wrote:
> On Wed, Aug 06, 2025 at 12:04:09PM GMT, Palash Kambar wrote:
>> Disable of AES core in Shared ICE is not supported during power
>> collapse for UFS Host Controller V5.0.
>>
>> Hence follow below steps to reset the ICE upon exiting power collapse
>> and align with Hw programming guide.
>>
>> a. Write 0x18 to UFS_MEM_ICE_CFG
>> b. Write 0x0 to UFS_MEM_ICE_CFG
>>
>> Signed-off-by: Palash Kambar <quic_pkambar@quicinc.com>
>> ---

[...]

> 
>> +		ufshcd_readl(hba, UFS_MEM_ICE);
>> +		ufshcd_writel(hba, 0x0, UFS_MEM_ICE);
>> +		ufshcd_readl(hba, UFS_MEM_ICE);
> 
> Why do you need readl()? Writes to device memory won't get reordered.

I'm not sure if we need a delay between them, otherwise they'll happen
within a couple cycles of each other which may not be enough since this
is a synchronous reset and the clock period is 20-50ns when running at
XO (19.2 / 38.4 MHz) rate

Konrad
