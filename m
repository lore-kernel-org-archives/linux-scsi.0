Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6579635CBD6
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781180618; cv=none; b=XKUnMSr2lj6tYobfM00GG0ZgUuW5E5N83+bWwroT7u6MM8raM1C4TyoGJg2BgxPLOfQW9qd4156W1ZjJ6JIACx4IiJrEbS2AYq50hPUAEbqI6OODpMYrN1WKAKuxdcJsl6wI+ZoOQnaJG3noG5RW8N1M7aRfNb4vr+6las6Lkgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781180618; c=relaxed/simple;
	bh=Up0TGC9AUDlVL81y+b9nF57+0CbKx535aaKX2JXMVYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHc5K0WEBCMGsnfngNL9szcYqWXbyhrbI2WGuqsKDfShi594wkN2cmcMkbOj3b2kzIus1qQ8j7bAo+sRl7qcCXu6l+Ss9zrhn+YmjH/vfHou6hzzEkA4WqJDdfMOeUPf5Pa4Q2kaaetusNyqrEatb27Sc0UgzT2Hse/hKg/OIno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CR+I5iQl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=a4GPVmlR; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CR+I5iQl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="a4GPVmlR"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65B9xRcu174141
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:23:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b9p98jHioztL+apkrbpHDu4L/Zphbn62xjE/pBSrzbg=; b=CR+I5iQlPQdsXKSe
	LO84UORERhKbegjou+maJ0fU6W/qzZG1kuXZsnBXKFhxvrm9Ngti5U88QrcgQvVv
	YEEQPgMwcJLKhbY4nSOi6kiBSWokRV/6nly37BjAH4EfJY+VRMQwE+eXqqYwrGSB
	8X1RCleRgSCjjz+01my7k5LZyteMLSPCsTv9wlNNRkDWcFtYIZcMuDRm1ofHgpm+
	gAd8lftZOsQf86LKTmGLD0c3WMeYnOYTH91Ez6xXCOupdUDbr6pzdR4zhZ+/LNmd
	8ExXIi2yDX09Ghg8XYW94O+EaG/RqM8iF9WRlvpiYZHKRzhTPmF4BX1oA4T2DaGb
	8M2fNg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eqe6vb9c0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 12:23:36 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2bf1dece2ecso79957285ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2026 05:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781180616; x=1781785416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b9p98jHioztL+apkrbpHDu4L/Zphbn62xjE/pBSrzbg=;
        b=a4GPVmlRj3oHWri/Ne9fzytcqGum69H39RSF0Go7Fuwgbu6vBOaknwn+OVrDrj9nJ5
         EVr9LGtq43oaGsqGxMJbFHSr0TW2vCa1M6yUvn5Zz8QSkPumFde0khv5CGT40PubWnmD
         9Io63r13rrOo5NZise53BCjM38/THTVat0jhXvg/zfYTncSAA2sac4X8O+0mgM5w1/E4
         7os97h9Sd/h1BBy5hJBL/xpi/l2IQMJMJLIUj0pL9OKFkxp8vD6W1292LXZYDo/IuT8X
         Xjc2hdQRP8N8xFHXjsIji4PcFQMhYp9YnF+y0j6I8Cin0u7zAu3ZPpQSXXMONepameVK
         FMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781180616; x=1781785416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b9p98jHioztL+apkrbpHDu4L/Zphbn62xjE/pBSrzbg=;
        b=OEnCj+PUgsPboiR9jkXeU8e7H9/T6d5RkdAQM9FSPyw4kMcyztl4Vn8pfBUz2ZRe/z
         KQXfWM6sT042uZqZMmlfl22qu//ugdZRKBsAbxTa9P9hqy83ziMxXbH+d1G/r1pBWnPt
         qD7zpeW3z7Uno48zRBiQbPb0cmpPkBsyljb2HzDH0YNAmGuNYziOCm9Diqa5qbhzaIrn
         HyKoOWcdcOUe5J/A0AFWb9+H6tJE9w0w/knYAmKjh4/THbjyAlBE4J4KKDJpjVK157Eh
         sVWAb2xEhZ+UU9nAn+V8bFiewYgjq1soy0ES/N/d0SqZcf9VmHAxw9njHC8TKSYpinX5
         ha7Q==
X-Forwarded-Encrypted: i=1; AFNElJ+XB3Y3JbNwW9d3Jsg0Jg6eCZeDKsVDU1K/9lgYGwMlYtnZuRQzGezqTH6U9vghkqgdnsuBq6LMBHLp@vger.kernel.org
X-Gm-Message-State: AOJu0Yz070Zo+M+CFSYFQevIzxylpaTTOlokdHUC7XVeR0tcl7buwa4i
	Qm9M/UoVihS2doirfCD93r9mINpqQUBdmimvN9yMj5gcp+TTzpTrLHQJWT4d2OzRR+VH3taKpMx
	QeC7JJIcqPteb0WMcx96GXbjyInSutb1fnZUzoxvvl/g/WD7AqKb8GFjmWcNmhKni
X-Gm-Gg: Acq92OHH6c/4tMSrPqY1ECi+dhe8jni5ez9YvJAdcnxpzN0ShgaTZ4cPV7Smm8R3N2f
	2xoUCZB+UM+47vTinNdLnDHtD0BGAgQznIoYZJ5MQLdzpf1GdeY2I+dyOpA6igZAfjHh9enhWwu
	syZKHbg7U2i1GiXPnXQ2LqApvH87qJIBpX/RsceUzkLr2H4/bfaxl+vn8BG9kw34Ef0jKrye/sA
	umxbNVjZuGkovx1CSqkFlAldXcCtCmlZi2vi8JbcEMsBqE2AzX87WcmFpCOxoka3KCpH5rqKv0I
	GtwqfATtPWEQdjDU4H+eg2cSJaNzRhfK9SQ7SlsFEARFz6cWcji7z20vOeb25RtxwzKV2IVpVWk
	O36AI2TEF5wyt02HrZB1JSn4L6X1sQF3Zc+UQSY220tinTsjadLr+cgEEtiyqs7w=
X-Received: by 2002:a17:903:41cd:b0:2c1:737:bed9 with SMTP id d9443c01a7336-2c2f298049cmr28064515ad.30.1781180616113;
        Thu, 11 Jun 2026 05:23:36 -0700 (PDT)
X-Received: by 2002:a17:903:41cd:b0:2c1:737:bed9 with SMTP id d9443c01a7336-2c2f298049cmr28064005ad.30.1781180615613;
        Thu, 11 Jun 2026 05:23:35 -0700 (PDT)
Received: from [10.92.167.195] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f70660sm277319705ad.11.2026.06.11.05.23.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 05:23:34 -0700 (PDT)
Message-ID: <9661cc21-7f3b-433a-86e3-d1593dfbebd1@oss.qualcomm.com>
Date: Thu, 11 Jun 2026 17:53:28 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 6/6] arm64: dts: qcom: lemans: Add OPP-table for ICE
 UFS device node
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Ulf Hansson <ulfh@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260609-enable-ice-clock-scaling-v11-0-1cebc8b3275b@oss.qualcomm.com>
 <20260609-enable-ice-clock-scaling-v11-6-1cebc8b3275b@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260609-enable-ice-clock-scaling-v11-6-1cebc8b3275b@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: L2rlCiPTdrFojw093VcCJAKTdGDEkkzd
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDEyNSBTYWx0ZWRfX6X2ciO+GIA+p
 alTjvKE4cwL9NVuQ1GS+454umDen5IoElFR+I3kH7ZJMGXgvyDuEDGcCvd+nF/GnCcZDYUsbyq8
 uirjnei6/HkOfGhzXrnqZ6C9uiG+8Wc=
X-Proofpoint-GUID: L2rlCiPTdrFojw093VcCJAKTdGDEkkzd
X-Authority-Analysis: v=2.4 cv=UsRT8ewB c=1 sm=1 tr=0 ts=6a2aa8c8 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=xhZcOr--89cURCpmMK0A:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDEyNSBTYWx0ZWRfXxSjK4cQzJj0r
 ctyGVADc+lKk9r7hIuwuKrhRJipJ5SPaTZZmyh2cq7EOxbphtTRZvv1wp7OAZsPe4b/mt40/4q6
 fL0k1/dYyk9FoUG4M+wusSiQ2JAZDByoocZDQPO93HAP7gWcJN3o34W5ui26dDC+VF5NwzP6yJk
 NjeiwJI1fFQ7OVYqHnyUMKSGYA8dVsB0tHEVaUHQCkzfhGTiuswlVbUQig1unfsggPssXM7uoR+
 /MWlfuTtBeaRpxRV0WPLaeFcX+3Yxeym7OrGuc7jUZuXIEbI0prknSj3YB3fUE78PsDOcnV7hUJ
 LASxGZWCFmuRCkrJSKeda5E6jwieNVTXNvqUZDGE6ggZ5trZXQQBCBR+VE+wpRw3AvBve8kFvTT
 VKvSrrY3zEDTrdvlgh8aVsTeTOjVq0n3gU735al/ot192pkv7VmoGeTRGREA9cc3xqglgzvuVXO
 K/dDvEBqXw1b78anMLQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_02,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110125

On 09-06-2026 03:17, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS device nodes for LeMans platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

