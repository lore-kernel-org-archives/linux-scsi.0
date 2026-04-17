Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB4839F18C
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 13:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776432732; cv=none; b=Aq/fvTA5XR5hanQoZtMJE+hTX17y6X4i8Mzfg+50FTqLOfbxpKUvRH+9m95QmiahXskw8BXdv1O/gMmWD+oytAQf80xkkjLQlO+f+c3MdTLtcMuQHT0CO2mx8rmeJhZD8z7Un5ggyXfsPLnEC/mGx9nTPq7MoYPmp2cceBw7vGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776432732; c=relaxed/simple;
	bh=RFvWEcHs09Ac7BQ/P1ahsX/rY3bcE0CJB0jwJ6qDepU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=exCFXTaFjOFqTBukahzyMbOsaVv3FWK34Vxn+/z7XjeP5tLf1r9LuzNvM1olp6x7LM/LVA3oYp8diDeiQ7AZRb8qZ4miPOdaicdBJGa9PWsx2pUDtVcNDFOW36YnT4kVZBbtnhTzqL1R3XcxdqokT+GBzYAWVaDrEym85GdXAGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=d37InmBs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=E603tFxi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="d37InmBs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="E603tFxi"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63H8nrF83100238
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 13:32:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/evtMQvA7PUd4sSb8YH73FDCN+57LuBUVGM3HCz06NI=; b=d37InmBsPomDCzSM
	ZYZXfMvHTOTytDN1t+lwSMuU99e3aSTq1U7Ay0qJETDRPlEZXEhivd9f05Bflkn9
	EotbJBH60D7i6u+VIoWu/404y7iDQLdR+KKoEu62CDw2XwKdVE1lKC3anMlSsY16
	D8gy+UJwaTRNAzss0UdEg3zYdKIUuY1vP9Dqyisiiuc1xt0LJD866Y5eQtWPFiFC
	RNcDJiw7Y321zOTskc9TukPKqRCIbEzrA0yewDLqp14ADJfdlsUYHjajXIKXlWfk
	gJjw5pYRemmKQ2dAjJ6HOm+ERi7TkkOlfxKMWRfYyyAMpE4IT+T4bLx4ooPofYy9
	pP7Y5w==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dkhpu0xcv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 13:32:09 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-82f896eb6faso856851b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 06:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776432728; x=1777037528; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/evtMQvA7PUd4sSb8YH73FDCN+57LuBUVGM3HCz06NI=;
        b=E603tFxikMSp9hnNnl5YMGR1ua428BD3FQM7M9J292C6jp68jlx9JoRG8uPcffR1Pz
         UizhG/HVoyBU+tmGzjs1OGp5v8h9+WMoMucL225R8vbu0LAj9Y4YGT8Pr0IqBw1ZoKYE
         XznV/CGRmsS6dM4MXQTNxMVVeLb+W2fxMt1P8IgCPqqQj8BVgpQNii0tzXotz1nwtLja
         dZcrVzKCAwoxwAeZcBHhPvbkvjuy2vbyjlFdDVzFQVUyeEkw7lP3zMaDDZ0UmW5p1y2h
         JsgcNBAvMutVrpxP2iMD0pUEUOH24sL5CYE/gHVLymKb22SgAA2YZRqsDXBYxXgM4yT9
         cg/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776432728; x=1777037528;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/evtMQvA7PUd4sSb8YH73FDCN+57LuBUVGM3HCz06NI=;
        b=grIjfRhduHBg+wv8vGrQwaQ104Djb0kNG8huinc5tGQ1HLKnqleuG/rpeYCvDcanUq
         Pl362h4i0EkLjrJOck+0LDNmaxcRsj+A9haB53fmC0boynrEnXGIIQzCGHMygIY2/uy+
         lkAVqtA325PUL8tDHpxXoCeQv1g/SxYRspVgJcu61ZTgg9owEVZ0+w5ZNI2yMe/ch3tw
         o7ZHGB9G6XN2EzKv9JQSrX8Gd9OvlLID3mw9YST4/I4W1mNTZYLObkYZqTa9BOTP3Z/P
         MBYOyRW+jL5s/m/LHScyDiPmZTekwhAriWF5VjO3oe7smZPpgFCNiyKMokB77SFCRjBD
         Hj3Q==
X-Forwarded-Encrypted: i=1; AFNElJ/bz74o9c1Yqd4/Quz+1zbNezq8lPXcs2Ef30iJHN+ObITxAOLGVRUO7jxISkZzBLSpGe9CnGffAG9I@vger.kernel.org
X-Gm-Message-State: AOJu0YwHpT4aWOlLU96FQNczMHYm2pU0kw+jNVvoLSJSMLS7bxfDqECu
	TD+DVUo3ViN9/P9iyWbM00S7aH9xKbKvgYP8TIfwrhI7qLntDzErbLHFW1zpe4R3fEo1fnxhyQU
	SPOh8UGtHvg5gEcutlzE2+5rVTQ2KXRrRJyLpqGeaRNrKvYt7rc7FCLuUoAEyXD1h
X-Gm-Gg: AeBDietTKWDT0xNm0b4b47zZ+0NlEGkNIuCqEAH670orOs/MfA+Q0pqtXie3hmJzOGM
	kEZAGMha/9kaQG2X/dl/uW0axN+KgFoKxbdXZxAz/l4XbDUP6aX/cm+N+Q90E4T2+YYGG63z5P+
	i53TcW6/mhZAt1+CgIxUKkkhG3Q4CzhhikDWFO0eCAjJXhk0e7QVAFZxW+Uwmiyt/ygd6mOGM9D
	hS94t2KrNFWcXxfo0RWy798wJ4ldf0sRYqonpz9fitBeQEF1NcAXgJPbUu91wTwzn4jxxoCeTv8
	hF/b8Q72+NArzjel0SJ+qCpDnDpxG45QnWMfL2db/XcZ0D8pmw0G7NmZhslEfispuNr335INZ8L
	U3xMFMOeSPY6nKf9PKq9MjJHNh7p2OZpgbMFJh47LlHOzTCjkkIoE/cxun0lEuQ==
X-Received: by 2002:a05:6a00:3498:b0:82c:20be:57e6 with SMTP id d2e1a72fcca58-82f8c81273emr3064736b3a.11.1776432728088;
        Fri, 17 Apr 2026 06:32:08 -0700 (PDT)
X-Received: by 2002:a05:6a00:3498:b0:82c:20be:57e6 with SMTP id d2e1a72fcca58-82f8c81273emr3064679b3a.11.1776432727437;
        Fri, 17 Apr 2026 06:32:07 -0700 (PDT)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8e984f20sm2306640b3a.8.2026.04.17.06.32.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2026 06:32:06 -0700 (PDT)
Message-ID: <a2f1112b-86c3-46ac-9520-bf49a399a98c@oss.qualcomm.com>
Date: Fri, 17 Apr 2026 19:02:00 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/5] ufs: host: Add ICE clock scaling during UFS clock
 changes
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
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Rob Herring
 <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260409-enable-ice-clock-scaling-v8-0-ca1129798606@oss.qualcomm.com>
 <20260409-enable-ice-clock-scaling-v8-2-ca1129798606@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260409-enable-ice-clock-scaling-v8-2-ca1129798606@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Kd7idwYD c=1 sm=1 tr=0 ts=69e23659 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=moC-RjrLiBHrLYWkWSAA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: FebJvLApesidqn-WLZNTEIKR12C7P3V6
X-Proofpoint-ORIG-GUID: FebJvLApesidqn-WLZNTEIKR12C7P3V6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDEzNiBTYWx0ZWRfX8v1IF2zP3fTz
 5boueDNc5OwuZP1kJQepJ1cj8wDbKhiB6gS5D93qNXnk1msruNflfXETuUDwedBJinPbKSt+prT
 6HFKEc1OSYp1jPeZoCcgSDv3nsd5ogzLMXeUcEmJl/HWkx9E4k1FSN7C23DEFB2h6az5XDkJWP/
 hfQcq3u+6GIBZJzFxyZVvlYBNNMcmzmWYlh5deTYAs9EmVG0z/EkkvaAoevqkAh4T5q3pxoMlnC
 4H324XJLWiLTtRfHEwpxA+DXNx2OKmT/UGqea5hDRziPy83siw4D1eUjzyPqM1Yc+bTLKEpVlhU
 OAMV2x1VFX8JQ04Dp6kcOuzH09mXrosZcRn8pgcq+py8S+c8SqJUs4yMfgbYvAsYJ890z8GoU8P
 JqjbG/OlYrcuUGbawr0n7d8JaumQ2yAdqCNi+vpSXvvJrRtW73obRM2X+oeM8/imQi3dBKkK74Q
 VD9FCCoYQzj3/gaXClw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_01,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 adultscore=0 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604170136



On 4/9/2026 5:14 PM, Abhinaba Rakshit wrote:
> Implement ICE (Inline Crypto Engine) clock scaling in sync with
> UFS controller clock scaling. This ensures that the ICE operates at
> an appropriate frequency when the UFS clocks are scaled up or down,
> improving performance and maintaining stability for crypto operations.
> 
> For scale_up operation ensure to pass ~round_ceil (round_floor)
> and vice-versa for scale_down operations.
> 
> Incase of OPP scaling is not supported by ICE, ensure to not prevent
> devfreq for UFS, as ICE OPP-table is optional.
> 
> Acked-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---
Whoops, I mistakenly replied to v7 of this patch with a Reviewed-by, please
ignore that one.

Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Regards,
Harshal
