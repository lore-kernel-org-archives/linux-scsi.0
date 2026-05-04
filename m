Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF3E14EC73
	for <linux-scsi@vger.kernel.org>; Mon,  4 May 2026 03:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777864342; cv=none; b=ONxAXgisOXGAKtfQtzP7ACYuv1DlDUoDBuLjhK53Glepo7Xk0H+haM3TrfxdOOcw9TG02lZmtyphlqzQ/N7SMIQPOxiweLS3xiM4O1Mk3t0GIXUlmUrE2MV9s96iiGNP5991EJnZ8f9lZ1SToaLlsUl4bC9+5Vqfa326W+CXM5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777864342; c=relaxed/simple;
	bh=P68befhhxhqcTzhcRO7ofjaz4zEoUjfNa4QebSgS80E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sGzpzC08ptZGoUvxwtoeWDLY5FjFTWITYb2ygoaMqeWpKoWVAYxU3S1cK3a3GQW0LwXYuWNlnFjMl+mmVVD/8ox+i1JyeGNYk7HhllRr6BHo8bT4gVq6eUhfNOiahl5lvVJzDB48jiMl8/1xLfnt+6/MHlym4YRiZAN/Xf4xJ9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SxiaRGK3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jil3vgi7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SxiaRGK3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jil3vgi7"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6439altp1818608
	for <linux-scsi@vger.kernel.org>; Mon, 4 May 2026 03:12:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BGVcsn2zQo2wT3xqfjcUl+aUiGrUOA4rifEuYnlFm6s=; b=SxiaRGK3/1KidHkw
	vSJf5FbwtMACkComTtQpHYaM4D+W3qIEE2aa8xke3npFHbuKhA3nadryqaYd6Gui
	6RudaMp5V8tUOseIMJdJzmu3m5wC/GD8U+7jqduseyG0t4/0QSTYLCw/XlrcwDZE
	SbfUWcBi3XTnR1pVgkrf3L1/AVe2qh+8iLdZxRXG+lLkuZiat1k5QQ94PHCR3xn1
	tvihEjUZquZD/OpBhKbtJU2DWrC17IRayq/mXFTgt//utcq3j7P1XBjwb6WL7JOf
	bqfRo0JXgPu3PeUYyVsvzttzal5ikZJcXuwoNLiz8DZpqLibLBpcaBPk4fuaHP29
	J+Fjkg==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dwaejm08w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 04 May 2026 03:12:20 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82f756ebd0dso2125132b3a.1
        for <linux-scsi@vger.kernel.org>; Sun, 03 May 2026 20:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777864340; x=1778469140; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BGVcsn2zQo2wT3xqfjcUl+aUiGrUOA4rifEuYnlFm6s=;
        b=jil3vgi7u1dsQM+LmMoG1xN9sVNDqF1KS5Ha542rMefX0eGLYyW4ujA/tnpd8jeYW9
         0B1PFZjIoLXEtCM78NzfRpAnIQbLk7O339ufv6te1h5z8ZAkGyGo4ndWSycrH3YIxVQs
         cVtoGKuUc2T5g/2E0XBP8ceiJJm6t3vlsnfhdcZXdgJZPE3BhoVIUdedGjBJGey5BiZN
         NZdulvteMw5VUKy3/lGou+W1sdlgIHOqjLo7htQ4xHSwviLrJ1BcZDCRHUmU3F37eKH+
         xih21b/j9rkK95lIN2kB9JpDq6lUBOOHsS8lS+FKaYVTLmHhi++3UJHnV4uzNSrAbbFN
         ouow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777864340; x=1778469140;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BGVcsn2zQo2wT3xqfjcUl+aUiGrUOA4rifEuYnlFm6s=;
        b=P3hdoiEaNJ60uKoe7i7b8fjWq5AX8XuzcrpcVMY1Q1IYNSTvkFU85YyKyjfh5IbBVO
         8yF4GaNf2iuiUCKI+VybMxxOKie8bz33WH1melgeK7QIObL5kmf/z37h1/xNbkvDajQy
         KR15o6E74ZNA3nrZtdShsfVY1YvUGcxsdubZ4r9/Rw4uebBezJceYYweFm+PzQDBEqGh
         SxkWOeT4cGIhLIpcYG0b6XCl+Ps5W87J+VjX8C6m5PkChL7xHaRumhbOnoQplt5T6jSL
         8WnBhu+zEx4kQnFJb6lTmxvpuc0noxYSQ5EsMqIyX1SelsDPj0qc/H8QZElqpMWLD0dL
         UNVw==
X-Gm-Message-State: AOJu0YzrIjNF/uQLotnFCE41CY0WY7bdEM9iimDj8nDIEeJRGT1PurWX
	pquyso1UIADNBjrBIxyxMoaqCuWHf+PwR2FRX9MpB4ZX/r2ITRI5pf4b6NgS3i3EOdjjUq8LQUO
	wUIo+s7D/RZCnQaKJp49mApyV9epivQVeOx9B5VTn0opzJTB5VhLM6kbKLagwZEL7
X-Gm-Gg: AeBDietc+1KDKP7K/WDKDkJJLEDeQUi1wc6ZMxh45wKQ5bHtb2Kit0tX2yaZ7KyowYW
	0Ynpzi15mvWOigheNm3adbbs6inAwT7sm5Gqb0H5CXEAajlhJQP+Kw/qU9af+JMV3hqlp/Q4pyV
	w3LPHqHRrW3iCBafMz60x9ZkJOX4erQQ9JPOt/sSgz+XxLbl+R4vNcIq4FRa0wrWNzX3Xqr2hoh
	Swq/dTwAOSPgawXx9urOfUxmtCsdAMpD2ZmWt6wGsyZKE+yyaUi13zPbjSucPWZH2JyqFOYuxVd
	+tDJQNchZKMKdR/EbhcoDaUt1q/bhRgG5LpaiD6k9EXw6sV/+qcoKCDC4/5EJhSLn9mD2LVFnCE
	BrkwdeFpJo95GdvBnnlERDNpwjZOgtKTWsncku3UXLs0AsdFRvcSbaQTCveLqDfy9Tg3T2oKJx5
	VgqBo/2+P33m+xlQlZyAOoTw==
X-Received: by 2002:a05:6a00:ab89:b0:82c:9cd2:fee5 with SMTP id d2e1a72fcca58-8352d02559amr6977720b3a.7.1777864340212;
        Sun, 03 May 2026 20:12:20 -0700 (PDT)
X-Received: by 2002:a05:6a00:ab89:b0:82c:9cd2:fee5 with SMTP id d2e1a72fcca58-8352d02559amr6977689b3a.7.1777864339734;
        Sun, 03 May 2026 20:12:19 -0700 (PDT)
Received: from [10.133.33.164] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515b4f7c1sm9994115b3a.51.2026.05.03.20.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 20:12:19 -0700 (PDT)
Message-ID: <5c2c0f79-3dbd-41a6-b0f6-fd6b7b14b2a2@oss.qualcomm.com>
Date: Mon, 4 May 2026 11:11:53 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: ufs-qcom: Use quirk
 EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER..."
 <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
 <20260501131641.826258-3-can.guo@oss.qualcomm.com>
 <326ac80b-c433-42a1-a18c-3979f7abf1fe@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <326ac80b-c433-42a1-a18c-3979f7abf1fe@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDAzMiBTYWx0ZWRfX+eo9cpmGx3H/
 omWhjFq9xIIqvMJ47DBah34pw4Y6JpGKZTSn5cp/lSovs7Q1TGPwI8BF2KTtjGe1oacVfg5QEw2
 NTEgxDWVeQb/rCNfXnU++oC2MRwqQQkTm0Rm3kSu3vFf0MwvY72jAMUbu+4Kw1NOpTAWBZ5Pt5T
 YP7ZY5L5XqAWYgRlFEuSR6+fEMGDKyifcTAeOJu8+DHW9In49kcLVZEmfWIHmgnFf/uTni9ljYb
 hHhTMjTqVb9egsJ+oPDIAFHZEf7sx240gBGW20VnYfpTCseUNqWbxeiLSkQW6VpAQxiKRq44BjY
 X2hVx0sxziNqs7WHOlJEdEUefkZ347i1ZeMze7pNavtWx7m6cxiVRoQTzt5kSR+0tnWg0/muA3d
 oMmpb2zJ/gc5d0n8WaDsV5vcerstA3kFGQ4UZauy55FDW4yjuPIDOAlM5YX31LKEuRdTkcubLrI
 pFbXRzcBxt64l2JuVfg==
X-Authority-Analysis: v=2.4 cv=Wa48rUhX c=1 sm=1 tr=0 ts=69f80e94 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=M61v9sag4nB3bsDLzKIA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-ORIG-GUID: fjkTg8SW2z1MpjrWXSR66rgZgHldyVoT
X-Proofpoint-GUID: fjkTg8SW2z1MpjrWXSR66rgZgHldyVoT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_01,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040032

Hi Bart,

On 5/4/2026 11:06 AM, Bart Van Assche wrote:
> On 5/1/26 3:16 PM, Can Guo wrote:
>> +    if (host->hw_ver.major == 0x7 && host->hw_ver.minor == 0x1)
>> +        hba->quirks |= 
>> UFSHCD_QUIRK_EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3;
> How about future versions of the Qualcomm controller? Will future 
> versions support this feature?
Minor version 0x2 might need the same Quirk, 0x3 might not. I don't have 
a real HW/silicon with minor
version 0x2 or 0x3 handy yet to verify, this is the best I can do as of 
today.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

