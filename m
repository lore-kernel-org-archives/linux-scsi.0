Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA3A348889
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094588; cv=none; b=uYGv0PTfrDFQ93wH6gnqYwbrlPB5ti9k767BYmvWMC46MgFQqlIB65xtyfaNqkZCHLOnDHxHqyGdjAdClZYyvnHzmgbIOlWtW4GMectYfA1lIwJVD4wZLRxGeY4G3Bjn3oNoVV4ss4Icbh38xXQvUth/yW/KszQb6kTKgE/ElzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094588; c=relaxed/simple;
	bh=sbE5PufeqT0RKnJMK69xNDsIF1LFlMLkOQuKUzGXezw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kO6mVZMIt3ODuybmFJa/phV3vVYjSR/iBgwKYMXbI2zKfRIwSX2YBFVQBZNPU3BBRsceJM22bbjnosXCu5r/EgMQl63ZqG/0ZwrdxtIy9h6DlhD+P0VCvUhAZW9F0ek8Lgvqf8y4oBdKjIWuz7JyAgahL+5pf6fb36dZwdkC3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wwi0fW2Q; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=U2fIL4Of; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wwi0fW2Q";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="U2fIL4Of"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60MDL4Ya3902115
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 15:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ZXAmimutHpoBcMO8lKrYN+CbkqYF9tLexxbBKbeEfH4=; b=Wwi0fW2QMu1zsVHF
	iCkej8GUvuF1gpj2Q+sCXrz13x9cDXuaKmXjeTp0ecm6QAUZXN78x1ke5ErN9C0e
	58/HnaauB4ZbrrfEMWXE8/GpXdrOsDdjKd366vjcJGV+SjJr2RKCzCwbbKndG59I
	ZzKIr+V7PxxmiyRq5j4IXg+bXdEPRdTaG1TYPUFOq7bOH2qJ/+9Sxei8YIXDzHUi
	t1n3Y1b38btaxLlVDENrX42EISyCCYovc649/6g6b4xl6wf3wpyLIV+PjapL9y1b
	d7qZoy+nsrZ1OhKWdjrtW+/0rtuOymJnPbANllpuabUImYVznVWKaERpP34oZWE+
	4g2g9g==
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com [209.85.222.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bu4khk9cv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 15:09:45 +0000 (GMT)
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-93f666131b2so170598241.0
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 07:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769094585; x=1769699385; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZXAmimutHpoBcMO8lKrYN+CbkqYF9tLexxbBKbeEfH4=;
        b=U2fIL4OfJFnNv8HOp/DDX/XwZgUbYTud2gPL2mR10OlLEag+7w1BrBRTWHSmZtvJAG
         /QX6wAPT7N0esYOZgmEqY+Db3thAeI8X3mvqxsvw/HGpEJzKQXuWCvmYEvtr3pCp95im
         hBuysXfjfonb8Cy7GvXg2rUYxUPTz60CHcrYsHdPnb5DD6x20vWp3rfnkVK3Hj2LSScw
         de0y6loVNLRYqoawUsf1WeOQ3A9+MXyUAubEZXacb6Zkb5gN+7EOlRXKvOZbWtaDX556
         ekT7uDkNwus/HGZoCzafte3c4e/mc+OSdm65kkE3WnVKTBbnosl6nTWnIsqeS2Bow4NI
         RmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769094585; x=1769699385;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZXAmimutHpoBcMO8lKrYN+CbkqYF9tLexxbBKbeEfH4=;
        b=G5UUbZmxOvtUgWMIQ4yv6wpHAa/xWh0qWe7/ESulWtbiMCc0V/QRqA1X+JYJTt+mg2
         4AymPrJ+eToL4Nv+oPkrK1X5qzyT0zC31Pq5dFs8lmAu/GXofhrjkMKi/8rw3Nd9bRw4
         tBSakUCYMSR8ukvJHWGrZnXFjD0ZdjsGops70KxzsGpVtB3Gob8YELy6kEZJjD86dvKH
         ccWM2EDHttImbji1SlLkOkDWFz+zACJfOxD/1oVS82rdmcW+RgBf8NJM006Xn/kzQvGh
         8UZzPUViBEeOiL/kW3NrR1+pSSIOBw553B3XryPk/0OtyV0ehXSsvtEhsBplxDTKsnMw
         b7Tw==
X-Forwarded-Encrypted: i=1; AJvYcCWBeOTzUfZZG0xGV+v1T8RXef75Pt9pJEgAD2uwziLV6O9HuF1etDXgcgLgrJlWoB3CktDbtxKoBSIg@vger.kernel.org
X-Gm-Message-State: AOJu0Yxg4nXgcHR+ZH15bglj1MbZqfriW2kpEPJV4y7+xFWZMzdydI0Z
	fTqi5cz3ylY3oPyn7RRuAinNQk9X4QlT24LgEFtXiEsSNV8Q+WJ1vSncwAO2K4qskMNpiOyhyJg
	Q62IZwjfaueC2phjk4DHKhITtfq1jwpIXH8eO7zB9r2sQL+HDX3iyPrYok4cwlnYc
X-Gm-Gg: AZuq6aICJ/7r8As8lptuwIMmRV46Q6FJyaio00p4/rMUFe/DPjSa2C3AZ8IxYxPwvq9
	wKMXnfUv4jkiVyBZeZKjWzv5LK9xjgnYiicMrlolP8vdhMs4GYexV9qRzKkgNMEYSXec2hDHVa1
	jCdtCdqGh+hmnAgN8hMRw7ievrPwB06slW8zofLH2TTVRa1fThisoymScRTekWs3zcTFzo7qRrQ
	/L6pjuvCjH6psa7IX6QkYgtJpTm/kWgJOafyjzTKvuB8pQuf5mJglWXiEuGXgvaIDYKylg/LRGc
	ZoEVfuVYhJK/mm/KTZ+E+TF2k7lymG1eknjSIsiW9NtqyezSHVHv1Iqb2VHn4MwbpyPc5Mrpbyh
	kHaAy3Sm6UsSPfa2+abGmIRfPmfSiDb0mLSmSbnLW+ZEjp6X9ENOg8mIjTcA/xfetH5w=
X-Received: by 2002:a05:6122:129b:b0:566:2275:c2 with SMTP id 71dfb90a1353d-5662f51f3cemr334945e0c.1.1769094584567;
        Thu, 22 Jan 2026 07:09:44 -0800 (PST)
X-Received: by 2002:a05:6122:129b:b0:566:2275:c2 with SMTP id 71dfb90a1353d-5662f51f3cemr334927e0c.1.1769094583999;
        Thu, 22 Jan 2026 07:09:43 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8795a192b6sm1700239966b.59.2026.01.22.07.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 07:09:42 -0800 (PST)
Message-ID: <883a2f40-a945-47f0-8022-20ad4146acf3@oss.qualcomm.com>
Date: Thu, 22 Jan 2026 16:09:40 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 2/3] ufs: ufs-qcom: Align programming sequence for UFS
 controller v6.2
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260122141331.239354-1-nitin.rawat@oss.qualcomm.com>
 <20260122141331.239354-3-nitin.rawat@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260122141331.239354-3-nitin.rawat@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDExNSBTYWx0ZWRfX6YOSgOO9yNbi
 Pm3M04Nf1yB48gIWW/UtcBz+zNMd5WRR6semfsCyCdlQJwJzhee5LmZwNNcbpBgvqpcAx6ZXJ8c
 kof80aAD8q9WXmpz8oiJ6gkcb596oJsAeANBHFtKBNTGUaoslk3vZlqvuQaALlQGkl4c8x7SF2C
 UnKN0XzBZni+/Rhr05GJop/0RLuXd0HE/tb9pdWkvXyvBJXx8uMgT8hSbCsWett+N87/r8zM3OU
 01M172H42tfWe4D0odmW32hv8tLN6rop16lhbJZ6/N3pHdEGF/5DXjOQqsKNMHO13L7h1GGeijh
 uR1tJExj9ODjhizKsAMY5Tvoo4dhlYxZ/D4Qk9gWPXZ47A6BhuqAsrnu81gpjAvN6OW4trmJiu2
 aV/Ij9pM8T/NtSZ8v0sxcneoFkPiR5ObW9pHRjmuxGGfu5v5MOhZygEZ8fcEwJkMy9/1PykiKYK
 TTFlQaaoS0qWjfcrUxg==
X-Proofpoint-ORIG-GUID: nN_e-mzSqosT5sLW377QWPoIUEmiStpP
X-Authority-Analysis: v=2.4 cv=UOjQ3Sfy c=1 sm=1 tr=0 ts=69723db9 cx=c_pps
 a=UbhLPJ621ZpgOD2l3yZY1w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=9Ji7Tjym3mbZabC91LcA:9
 a=QEXdDO2ut3YA:10 a=TOPH6uDL9cOC6tEoww4z:22
X-Proofpoint-GUID: nN_e-mzSqosT5sLW377QWPoIUEmiStpP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601220115

On 1/22/26 3:13 PM, Nitin Rawat wrote:
> UFS controller v6.2 requires bit 31 in the spare configuration register
> to be set for high-speed link startup mode, as per the Hardware
> Programming Guide (HPG).

Please stick a "Qualcomm" before mentioning UFS controller v6.2, I
don't think that is immediately obvious without looking at the code..

> The spare register value is read during host driver initialization but
> gets cleared after UFS reset. To align with the UFS v6.2 programming
> sequence, preserve the spare register value during initialization and
> restore it during link startup to ensure proper high-speed mode

I believe you're supposed to write the value yourself, depending on the
state of the controller, it's 0 at reset.

> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 11 ++++++++---
>  drivers/ufs/host/ufs-qcom.h |  1 +
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index c43bb75d208c..ab5aed241913 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -686,6 +686,7 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, bool is_pre_scale_up, unsign
>  static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
>  					enum ufs_notify_change_status status)
>  {
> +	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>  	int err = 0;
> 
>  	switch (status) {
> @@ -708,6 +709,10 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
>  		 */
>  		err = ufshcd_disable_host_tx_lcc(hba);
> 
> +		/* Update REG_UFS_DEBUG_SPARE_CFG to set HS-LSS mode in link startup */

"HS/LS"?

> +		if (host->hw_ver.major == 0x6 && host->hw_ver.minor == 0x2)
> +			ufshcd_writel(hba, host->spare_cfg,
> +				      REG_UFS_DEBUG_SPARE_CFG);

Is that a "only on v6.2", or "starting with v6.2"?

Also, I see that this register has more than just this one field, with
the previous question in mind, I think a rmw would be desired here

Konrad
