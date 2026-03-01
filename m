Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B101DF25F
	for <linux-scsi@vger.kernel.org>; Sun,  1 Mar 2026 14:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772375196; cv=none; b=k4AGE0zp8Hqg3uJE2qBr2ER+RdOB7rx7fE1QOPTUdOPZCd+CGRP586XeQ/opvKyRYu7G8bikuRmmrKY4cI1yePtcxsosb7QjqOwNjqEKf4oS8Rb0MxnV8O5BN1a17X1NwBsFdOf90rwrx7UltxxLA+g5Wzwjt2ywLbVJOe7J+ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772375196; c=relaxed/simple;
	bh=4K5uDwmOGHHAE2v0HwOM4PoClT+fHAn38D2q2GDRMgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=riAaaunqMharQ8uwcuaBGRpcPyK3PqtWz5kgUH7NlD28Vf8NVLrS/76LBvQc7oef004Ftnm/IPstWyI2W0EhQV1hbjELwcVBi4iASXROc6m7Jr7LiPiq5TzDd2c8K+TIcwUlwpt+KuaT+S1Iq7T9Q1R3nSzhfncY6brWvBHzGww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PRT2g4dK; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=j7Udp2w6; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PRT2g4dK";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="j7Udp2w6"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621AviXk118739
	for <linux-scsi@vger.kernel.org>; Sun, 1 Mar 2026 14:26:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	KNX4FPcc10deSSmvIUjJw33Ay9Bm/BfMEU3pVvCYS6E=; b=PRT2g4dKb8MUvpUT
	6EeF4Yc+YA+y2s29jjszN5/MbgmHBMMEJ/InzQOW+QAacc9SDBScBPJk+DGdwkBZ
	PjCfggr8Dvrxl/LmbHk57xnPko3poAgrmQ9eG01odwv3xBbAsDgWi0bcbgw0NTvG
	Xn8yWNKhdoG88Vu2VMAbkzFb25QyZBn6tXICwtqUCQn0zxd1oOcsMJpTqORXFIAH
	O7uT+kyxTc1B0yfz2eCunEXApBujjLiTnYhc5GOzmb8pTiNPaCaYSV/g8/wxUcOp
	lNvGS5lg/qFVeErnYC/eRNAf5uA+JDNu4pR9ZnQE7tc+zELpcfFzJUsPh67Tcok/
	LNd52Q==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cksn42tkr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 14:26:34 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c70eb09daefso2087824a12.0
        for <linux-scsi@vger.kernel.org>; Sun, 01 Mar 2026 06:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772375194; x=1772979994; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KNX4FPcc10deSSmvIUjJw33Ay9Bm/BfMEU3pVvCYS6E=;
        b=j7Udp2w6/FDDzIxefqZFAQD/ZxLTGJ8iUzcyfils0rY1HjpUTIeEkC5RlA7YeQ3Acq
         Qtq8sqpGp+aS1B+zk8YyHnG1gpXGplpAZR0XvRhedIz/2/J67IhNFNRRcWwAPfOkEGxx
         xPxkvtsTCznlRWF/uYQEkfw9oDXzKfPRdgDwGNh9C5c+PprszbS5ARWjhTVt6Z198KmJ
         cmEod5jFvRP6jP2Ls6w2Z5RMccoqPjcKqfEWuvMVwT2CH6vXR6ELcvsb9do/tHDJgxNa
         QOekZhE7QnhWXOyeCq6t3Y1zkhiJKiT568KGAHAhYzNAi3kVhWDwtDwmZqBA5h19Bi8Z
         QiVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772375194; x=1772979994;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KNX4FPcc10deSSmvIUjJw33Ay9Bm/BfMEU3pVvCYS6E=;
        b=kMZ0T51bVPaqNoUc8TQnkNH0Hml5qp15nx3FM2SnSwlI6KsM66E8Q3nSeR9n6ncqB8
         7EF7B3Zq2O6hn3h4+cOMp3NNk0nIJh1htffgWqSfl8MWtS+bs9Sp5gWU0GMyh/Cs29uH
         YFvxQHTqfEWj7ucGSklfZh/PvWrv/BUwPWjyIkKf0g+rrIolOsmJIgO6mqxvscDFOqUK
         l4aYIeNZExPDZe7RWNeFv3/mgzVuQmzm6LOo8ISPRkOqhklHGT2eHMNOjHT34R7rOHHp
         DAhWmQeNyQDChJbA6n5wKlG9Hjfg/7tNmx2KPU4vWIJrZGGyR04WmQCa3jahvj5Dck7a
         y/jA==
X-Gm-Message-State: AOJu0Ywo3xYjw6jf98a3qraCWTirrxPfbaUdzvsR1EVYcsTiPRNeT/fC
	oC/Qhw0gttNvIDaz3R+4bBe0uZx3rzDofx2O22NiCvjcAQSQC+HPY5l0nRovGQM7n9qj1KcAiYB
	E+QWe0BX5MHDvQzWgZwuJ15nS2cBr7/2wEGFNnBBMnDs63V8mIGauBkA617cUS325
X-Gm-Gg: ATEYQzxudMdm3NbtYqVG9gitvjk04mtaeD4s8A1l26AJWAICwtqxO/Lhk7tFoUKrC+k
	x6b/7fb/nC08jvDRxZiRQ31uu5bnKLiMiAuzC/rDP5llilgjaTD4i+aWn71/7Uvk/9pUHK1AtcA
	7ZQHPpOtKt/lAD963jlAa3a3cCliepUeUaPyZPL52MBJ5wSTbiP1H6c7/nnmxOaVWnEsAUeywIY
	6IZQlMfQV0hsgZh6BH25MnB8hd9LFK0RVHLfrdKqghbgK9QcOuoxcgDoUX0kXMweR+IhL1zU7Zh
	mKvpcZRDKki6SkT/mvEBPut0ABfEkTirrmX3tVS1Io5zxxxFbGxBWeuhcXJrQXyCMbTbjzqjxxL
	oc+ol6wx8m0e0UYC9/ZX+VEoGs0FFSNuT3CsLNquzibGUnnI=
X-Received: by 2002:a05:6a21:730c:b0:364:be7:6fe9 with SMTP id adf61e73a8af0-395c3a75434mr8553254637.32.1772375193646;
        Sun, 01 Mar 2026 06:26:33 -0800 (PST)
X-Received: by 2002:a05:6a21:730c:b0:364:be7:6fe9 with SMTP id adf61e73a8af0-395c3a75434mr8553232637.32.1772375193170;
        Sun, 01 Mar 2026 06:26:33 -0800 (PST)
Received: from [192.168.0.102] ([183.193.18.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa5ea0dcsm8925971a12.3.2026.03.01.06.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2026 06:26:32 -0800 (PST)
Message-ID: <5a2961af-dada-44f3-8e57-119076f10750@oss.qualcomm.com>
Date: Sun, 1 Mar 2026 22:26:20 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] scsi: ufs: core: Introduce a new ufshcd vops
 negotiate_pwr_mode()
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
        Ajay Neeli <ajay.neeli@amd.com>,
        Peter Griffin <peter.griffin@linaro.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
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
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-arm-msm@vger.kernel.org>
References: <20260227160809.2620598-1-can.guo@oss.qualcomm.com>
 <20260227160809.2620598-2-can.guo@oss.qualcomm.com>
 <9d975881-7570-495d-94ea-085e2012a9af@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <9d975881-7570-495d-94ea-085e2012a9af@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=Tq3rRTXh c=1 sm=1 tr=0 ts=69a44c9a cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=4/OApUm1v7sVY8kc7hZvWg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=Z9vnt9DBQu4Rfwh2U9cA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-ORIG-GUID: aezCAIGnIUWcjj8P1fiqObVFpw3ZU8Qj
X-Proofpoint-GUID: aezCAIGnIUWcjj8P1fiqObVFpw3ZU8Qj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDEzMSBTYWx0ZWRfX84ZOhKL7ooun
 BcXw2lczP2OjRgiDrN191RnG7z7X84v10akETF2sLVifi3N6ttvem84QhjE6ApAT3yXIcjQHl2O
 sfggaD7IiTpCfjLvGaoZxmTAM+HkTTYfxptnIIP3U1v26lpcDU1Oj0dWg6JZ/Hxshl0/SNrx2An
 3gL3XotWmK4aJ/ymMWc76ApalmKIOarXHJnNUJ/1AMbk9zMdVgUBhxHiuUePowFbVBHyG3DPKOW
 +W1EcdgCyjY1We59ZziMxJm14UOSk4kTXNqUPp8LhjLEU1oDXKpUeWEoygCP7YmirJ0GCmO2Gin
 6PlSAmZjV4ke7OJl50ZOnL428/vxx0/t2ppEkdEYSZpkWDA9AfYnuV683TxX0nxv+v8fev/Zz6S
 K9DN2qNa7aqMln4fDP4jJZdG7VQC4/1mfxMO5LLYZrLmvwVe/EnXye44RpawoBKIip2rFCXULi6
 +YLEhPvcYweFi3ZkvPQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-01_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603010131

Hi Bart,

On 2/28/2026 3:31 AM, Bart Van Assche wrote:
> On 2/27/26 8:07 AM, Can Guo wrote:
>> Before power mode change to a target power mode, TX Equalzation Training
>
> "Equalzation" -> "Equalization"
Done.
>
>> (EQTR) needs be done for that target power mode. In addition, before TX
>> EQTR we need to change the power mode to HS-G1. These cannot happen
>> before the vops pwr_change_notify(PRE_CHANGE) because we don't know the
>> negotiated target power mode yet. It is neither approprite if all these
>> happen post the vops pwr_change_notify(PRE_CHANGE) as we are going to
>> change the power mode to HS-G1 for TX EQTR.
>
> approprite -> appropriate
Done.
>
> Additionally, if "neither" occurs in a sentence, "nor" should occur in
> the same sentence. I don't see "nor" in the above sentence?
Will improve the commit message in next version.
>
>> Introduce a new ufshcd vops negotiate_pwr_mode(), so that TX EQTR can be
>> done after vops negotiate_pwr_mode() and before vops 
>> pwr_change_notify().
>
> This patch does much more than only introducing a new vendor operation.
> Please make sure the patch description is complete.
Done.
>
>> -    return -ENOTSUPP;
>> +    return -EOPNOTSUPP;
>
> Why has ENOTSUPP been changed into EOPNOTSUPP?
I got a warning from checkpatch.pl when I add the new vops, so I changed 
the same for
ufshcd_vops_pwr_change_notify() too.

WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
#59: FILE: drivers/ufs/core/ufshcd-priv.h:178:
+       return -ENOTSUPP;
>
>> -static int ufshcd_change_power_mode(struct ufs_hba *hba,
>> -                 struct ufs_pa_layer_attr *pwr_mode)
>> +static int __ufshcd_change_power_mode(struct ufs_hba *hba,
>> +                      struct ufs_pa_layer_attr *pwr_mode)
>>   {
>>       int ret;
>
> The double underscore prefix is typically used in the Linux kernel to
> indicate that the caller holds a lock. That is not the case here. Please
> choose another name for this function, e.g.
> ufshcd_dme_change_power_mode().
Done.
>
> Thanks,
>
> Bart.

