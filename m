Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4BD38F23B
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 09:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772443725; cv=none; b=W4pGNaVBvH7CjwdLR+cFSkwRNsJcBP3ZdVpNlOLx5jxidCGY72GmsDrYZwldR3Cc6ZamU3iEx7Ck6CAwVkRUYFVeJnnNLt5U4G+N25HN3LoLRwCQeSAWnwWuFTOY5DOJaDAxisw4sNR9VZR6+MBRWfGpJjBheipLac42Ag+XxkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772443725; c=relaxed/simple;
	bh=283ITlUTpw+pnnWf8GlTk3ilsVM0BLNnI2fU0ZTZpAs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JHhmhjLjzVlx1L4FTWqey5TNUpyvH+lnojlU7Co4Ktb1Oz65Lq1cP4wnTlFYc+sLUav+3SsJc9sTpBWpPUKeS+YFM7J9oJ7NKdERG5y5W7vHsq7r0HYGlCpuL5ZppsAEsvuagvTzYbSqYGQLw2++3OBjxhaOrq0bqQl5TbWTeCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GoRcKCM7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HAQXKj1L; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GoRcKCM7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HAQXKj1L"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6226vPJf2649150
	for <linux-scsi@vger.kernel.org>; Mon, 2 Mar 2026 09:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ht8a1jegW8k/H9PVxZasCwKoJs5NEx57HRzB+8Y1KVo=; b=GoRcKCM7831kuUhp
	I5iRKWUanqqzJFpMCKE4KqTqTkEiVQz8Oq4LpbM+OJtjJu9kqs+IqAq+aMB4u47h
	irngferz5Ea6YPaLiPrYNznw33L33vSJhrzYPzWFkAcWTSi43pfFnMj2s6KhKyPB
	VaJFxFU+CEoQpoGlVu9xQ6d8wyLzyjfL8WNDzUd1Z21CpgxFbFWwSmdso+1T8QZJ
	5syQ7xhsSAhJkuQ1stVjxQO1+8H5+EmoE/hiGDAiXU5FeyMPvf9MYsLRUeK0utc+
	ukYtUiRDUWhz0cYj82yh5zEG2xquF1tBGfaV3z07jNuGyAOIrFpU36Obt8ozCa0P
	Af823Q==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ckshkvy5a-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 09:28:42 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35449510446so3973128a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2026 01:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772443721; x=1773048521; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ht8a1jegW8k/H9PVxZasCwKoJs5NEx57HRzB+8Y1KVo=;
        b=HAQXKj1LZOf/bkOBpFO8RSxF3p1pu8TmGDm3kL12okUxlmnuF80uTwxY2M5gKNvY0X
         +pVhCJrmkADX04+Hk9zFILjk432uE2clk2fLiIxm9aYviPcHwKkshsA0gmsqwDoQHzVU
         d434cJmCi+Q53psdcOUMmIn7CNK+JqXcesvuKJTUIal/F8uxD2F7O/4heqsXdoTguPpc
         FjVoqL7a/C8gU/Lzz4p9KJHgesp5CUnBxfxlBbcpyeSX8xRmeF4a2QKNMJWFEJY77Hau
         vbcolF4tK6+p+S00PBsIoeXuwpN9aQGKqWnuCQA3siucghQdNsEMkYuHJiLrX/MDVRIH
         Yapg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772443721; x=1773048521;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ht8a1jegW8k/H9PVxZasCwKoJs5NEx57HRzB+8Y1KVo=;
        b=st5Ry1tw9lCYR9mYQcCEoDNHSkuUg8uWWBDpXdLrO5dFVbRjs/1VV2nd4VMJsZ4eqi
         ZWSpOyEsMfsPWv9A7u796xLoEVq/OtUXWJ2Pj7VcNrgchvN32/zwLrsR87z0HDOICfOL
         ST0mdpiyL+3wHrGztfNnJvB15AqEQvqOYl/IZr/jQ8YTH109Ko1nplA37SO2vm1N9oMc
         cyNSZRCf72+VJRDHJuLnQ1A6S/WS8zfIRRuu/21e5vpw3lx8vyCZKgSx3eU5W4TFxTJ/
         tt0KqYW49/0H8kL1NkaP/NJdKISYJOd28Nm12ha0GNlYkfFmT3NzI/8xb9hKIv8U5P6V
         gw5g==
X-Forwarded-Encrypted: i=1; AJvYcCWkLISBpZ5lpB/OVDM8EAJ1y+T+i/xC1ulc91ryE+42/N5CP2GNmQvmsJMEgtyvG5NoBjk+VW5rTrV1@vger.kernel.org
X-Gm-Message-State: AOJu0YzpyET8pxhUYZGwoOWRi4lt2SrooBLpUwA25wmZfweDLUgaqC8R
	SC5dADQpfjOqcZnlQyTOhQR7Kp3Qj23RtuWSlBn40jHJqaM1JJeQO/X1iG+oZeSsMjG6nKBxdXu
	iwIDQZYXl654be4yeK7ZC8hOESAzFujyvCW2aj++bEF4chQxQ9+0yIS8M+DRwv1qe
X-Gm-Gg: ATEYQzwrAH+R4a4hjwuEtwe+sGau0gW1MarBRtO2V+cgCPdlM99qgzLyzxCiWuWTj/b
	dtHxH5ziWlHI97Fv9S6Ag/FDYW8NXTvS0h+4BaCZZB/Gez743LA7bRRV7V065WQNXpE3Q0jV4En
	5UxMxtx+OJ+e/YOiRPGB/6JJPpZLl+Ik9qg/NYhhZlkMScCguz2yZA7xu2OIP53wuG+v8KaLoX6
	O4ZUpDilPYfP3vch6eeEmgnssMe/9XOKG3Imqvfx5DS61Pfir7As0aQq3skdcZ1UvPTf9cg7bPf
	IR3VFji9SLrAHaVPkMUEP4ubZxuJJReqFKSchXYZ1h82i3sLOk3Qq7Tnu5VdgEfRM3UwiMBkVDH
	ETDJM6X+lMP1MEKhT7bWc2WV908k/FgkXnytLg2vxvPNrIS4VCg==
X-Received: by 2002:a17:90a:fc4d:b0:33b:bed8:891c with SMTP id 98e67ed59e1d1-35965cc9d6amr10190630a91.23.1772443721265;
        Mon, 02 Mar 2026 01:28:41 -0800 (PST)
X-Received: by 2002:a17:90a:fc4d:b0:33b:bed8:891c with SMTP id 98e67ed59e1d1-35965cc9d6amr10190617a91.23.1772443720773;
        Mon, 02 Mar 2026 01:28:40 -0800 (PST)
Received: from [10.217.222.63] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3597dfea2e7sm6307474a91.12.2026.03.02.01.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 01:28:40 -0800 (PST)
Subject: Re: [PATCH v3 1/4] soc: qcom: ice: Fix race between qcom_ice_probe()
 and of_qcom_ice_get()
To: Manivannan Sadhasivam <mani@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc: manivannan.sadhasivam@oss.qualcomm.com,
        Konrad Dybcio <konradybcio@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson
 <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
        stable@vger.kernel.org
References: <20260223-qcom-ice-fix-v3-0-6ca5846329f7@oss.qualcomm.com>
 <20260223-qcom-ice-fix-v3-1-6ca5846329f7@oss.qualcomm.com>
 <h2uhrsjlvovjcj7k2ckpkgrhpuwm6biun4ueq7kyzcm4hqcsjr@y3iiqx2vo6s2>
 <lrhali5ukotcmxqp4yb2g2jvbrhlanpqc67cpvluex4l63skne@ln3j4xn6qfvx>
From: Neeraj Soni <neeraj.soni@oss.qualcomm.com>
Message-ID: <ea659db4-54df-1892-f04a-74a8f62c7dec@oss.qualcomm.com>
Date: Mon, 2 Mar 2026 14:58:34 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <lrhali5ukotcmxqp4yb2g2jvbrhlanpqc67cpvluex4l63skne@ln3j4xn6qfvx>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA3OSBTYWx0ZWRfXxCWcDRVFMysM
 Q6s+RQY2EszIoHkfBZOYGzmM1I1r22iouQ3yCCWwAweFRaakyutam/K2u9e9uScsfDUXA1aCQzK
 ETs9tdA+PgQvWWhthsfhbVQCwfNmKTa0h50FMY/+eqp/O4UQArdiu0Ytdq0KBDhl6Ry452F1wY+
 b8PlNZqKM8BJZkRucavrdFGq8hgPZjFVwB5rj7IRLDGwJrKOENeSfwjnc3eBoNxVXhlYTPpMpL0
 ITv+AYQ7Sl050gFvq5gC67FsFSc171sSeI8vwvToztWL6sZfGs35R3Pmn33hzE+7n5goqAydKSc
 hPbDkvrtjHbrMTbSEip3IhkHIUC0XlG+2bSAb//RB3rewjc2BdjRuQ3xSydOkXa/djvTzVjlPCs
 CyTgGa1u6VNpHVlWIrsMBnBGU19In5vLVzLjPTSHAy5PZmS+w3nqvsXt3UnurJUWWO4clA8wx8Y
 fFERBWkMZ15K+Gu+HeA==
X-Proofpoint-ORIG-GUID: 1QSNUoR6Mt_5a-GXu-0fkxSyQhk88O08
X-Authority-Analysis: v=2.4 cv=EvbfbCcA c=1 sm=1 tr=0 ts=69a5584a cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=xC54U6B0g8_6vy67BIAA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: 1QSNUoR6Mt_5a-GXu-0fkxSyQhk88O08
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1011 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020079



On 2/24/2026 10:16 AM, Manivannan Sadhasivam wrote:
> + Neeraj
> 
> On Mon, Feb 23, 2026 at 02:35:04PM -0600, Bjorn Andersson wrote:
>> On Mon, Feb 23, 2026 at 01:32:52PM +0530, Manivannan Sadhasivam via B4 Relay wrote:
>>> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>>>
>>> The current platform driver design causes probe ordering races with
>>> consumers (UFS, eMMC) due to ICE's dependency on SCM firmware calls. If ICE
>>> probe fails (missing ICE SCM or DT registers), devm_of_qcom_ice_get() loops
>>> with -EPROBE_DEFER, leaving consumers non-functional even when ICE should
>>> be gracefully disabled. devm_of_qcom_ice_get() doesn't know if the ICE
>>> driver probe has failed due to above reasons or it is waiting for the SCM
>>> driver.
>>>
>>> Moreover, there is no devlink dependency between ICE and consumer drivers
>>> as 'qcom,ice' is not considered as a DT 'supplier'. So the consumer drivers
>>> have no idea of when the ICE driver is going to probe.
>>>
>>> To address these issues, introduce a global ice_handle to store the valid
>>> ICE handle pointer, and set during successful ICE driver probe. On probe
>>> failure, set it to an error pointer and propagate the error from
>>> of_qcom_ice_get().
>>>
>>> Additionally, add a global ice_mutex to synchronize qcom_ice_probe() and
>>> of_qcom_ice_get().
>>>
>>> Note that this change only fixes the standalone ICE DT node bindings and
>>> not the ones with 'ice' range embedded in the consumer nodes, where there
>>> is no issue.
>>>
>>> Cc: <stable@vger.kernel.org> # 6.4
>>> Fixes: 2afbf43a4aec ("soc: qcom: Make the Qualcomm UFS/SDCC ICE a dedicated driver")
>>> Reported-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
>>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>>> ---
>>>  drivers/soc/qcom/ice.c | 44 +++++++++++++++++++++++++++-----------------
>>>  1 file changed, 27 insertions(+), 17 deletions(-)
>>>
>>> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
>>> index b203bc685cad..3c3c189e24f9 100644
>>> --- a/drivers/soc/qcom/ice.c
>>> +++ b/drivers/soc/qcom/ice.c
>>> @@ -113,6 +113,9 @@ struct qcom_ice {
>>>  	u8 hwkm_version;
>>>  };
>>>  
>>> +static DEFINE_MUTEX(ice_mutex);
>>> +static struct qcom_ice *ice_handle;
>>
>> Did we get confirmation that in the UFS + SDCC case, there's only a
>> single ICE instance per SoC?
>>
> 
> Right now there is only a single instance per SoC. But Neeraj told me that
> upcoming SoCs are going to have multiple instances. But I don't want to spend

Yes and patches for same are under review here:
https://lore.kernel.org/all/20260217052526.2335759-1-neeraj.soni@oss.qualcomm.com/

> too much time on *upcoming* support, but rather fix the current
> implementations.
> 
> Extending this to multiple instances would just require storing the ice_handle
> with node name/address pair in xarray or in some other data structures.
> 
> - Mani
> 
