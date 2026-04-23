Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7183876D2
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 12:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776949151; cv=none; b=K+kWKsIkVNd+9HzV7sXnl35jjl+sk2r65/HflxyC0TLYVOHiPd9+VI6cydK10jx4NNiPAJsFgNxxUKcT6oxRMWdcKx0qd4r+vllaN70dd/imoquZ4zFnWBk7jXnTMSbKjGAnbEP23t6dNPTkbXkUOKS8/63ssc7Bhq54p1QuHRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776949151; c=relaxed/simple;
	bh=OsI1m7bmguFYLsOilvXfOIKS7Ehn5i/JY54eFqXkK7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DchkYpUs/N5fhJhn3ohfvOPGmO5flxAeYlB1zBdKGRPlVwS8QzStioCd3QOXwCS3Kwa1MaGv/lOn8VJIebGe2dy89BRxiKCEWCf+OD51PhimHxP4ivwaNADE5WdC9WF4H3RGckdGuDNolJPJEjYlNwPrnlnCcJiO/QrRsMpLHHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=IZkaP6OV; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MrAiu++4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="IZkaP6OV";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MrAiu++4"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N8uOLZ1565871
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 12:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	bv9bbK3CKQV4FRe3nxG0ooKvJtI+iyyOSwnESk6M1pQ=; b=IZkaP6OVsVbNMI52
	6Zu5pQTF4POab3jMfmKbS2z0fWqdwQktsDw8oPstJOp/TWMQsZFQaGaDDnn0Spvi
	TB9jCwBXMVsdbAQxY0XDfXkv2eRX/fNHF9j6zIUoXgILUqJFzGGailjlsRX6PirO
	Nk0piNxfu74byXz9mAgn4cii47l9IcMjlcjSF40X9vozX5AF9aAQcnEiVlovLSc0
	PS6b7ExhK/3G61iwson7Bo3O4zQSnWnDfbKkJdHhfINgdchVmeGgOpBcgQ0zU17W
	+0a5j3vQFJ0JGFM3WSPKR5e6z9qxCYe8T1wl/f3nL9NwACpxPWQwGOXRrVK1no/3
	AtqCUw==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq16wv41e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 12:59:09 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2b24e9b4d82so68637055ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 05:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776949148; x=1777553948; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bv9bbK3CKQV4FRe3nxG0ooKvJtI+iyyOSwnESk6M1pQ=;
        b=MrAiu++40049P9P/pxcZ3PBkeiZemGnyRkEv4NR0eA7JIhHUHF6pzBxHBqcFCECw+w
         q6ZKRZA/jlWr1XtKtti+9g2EyCTwOc7OsFu0/iN7s4KvpVBdK6LbKN3V4EvWSoyhszdK
         mTOy18KDwdYlwBtNpDujupYZQ+H/1335dxq4HlTwRVPStLLqBdFgp85QSwz6csZjTQkG
         d4aEkp2raPVActLgmtYDqDGPPaqmsAJAFU+h1ZD/7624bIldEbGFv//W/H5ym849JxYK
         q+beTIyr1xjg9Q2+jaoMpFpBbEUGsY2NHM/EFbTJfk7D5i00ezhvNpYK8pNDTwxlaTkM
         nqiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776949148; x=1777553948;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bv9bbK3CKQV4FRe3nxG0ooKvJtI+iyyOSwnESk6M1pQ=;
        b=e520ydP9zPWG58beEVdS8x5LAB2i2DqOp+K4Tod/ctTCH+2nv0dttPnMSl9DfWKfqG
         HDNqwWh4YwvcVqjXfX/XJ5qesYM3vnjr8lYbvznUxSQX+5tuUhhdj4XprRVwZXVuAQmv
         btd8dFHIVzE7dNGlKUK5dc9wAXiyFwcIau+hqlGdGo/v1qnt1p8g+1Ah+qgdbCCVMpgm
         5NkgOXEEIxddO8wq+YGUGF9BzT8QwKpz8XR9uB8bSszWVUcR6HWBHGMM1lghZhpoQAHf
         iqRIdW8CchEhDODmfKQ1C+qyOuinACBHR4haA6dF0MDbKO7Bn2ZvuyNYybFRCReK33Oo
         cp3g==
X-Gm-Message-State: AOJu0YxS8jPSrU+YYDFIbgzgdjDoXN3NtdhMRzZ4jGCDqW8cuEmP69SC
	ypzV2bJ4/oYLzcjfBZInxfAPimT0FKyWYgyXTc8qaomORTQctJEzVLgtvhsd+lKpAQ8OQemwLuJ
	hgPsJpHTw4R/kxvicU2RW+MKtpFPXcDk4ulGF6cV5+4C5Zw2ooKU4NvY1ka1y1EqQ
X-Gm-Gg: AeBDiesd80oqEkqdP8/d2aePhPH5oWgh6mC0BMyNSJCbtLUuXkAGopPqxRB/CWpsFja
	UyAWzcqMLsWkE5aGgmkSCcHQ8MnQx5+1qi4vealDArLpoXf/oENhiyMidb/4dY9kgrDNw3NkqDb
	WaVa+eXKN8ESMHq86S/+w0d938uvVEPaULI2BYCOw5GRNC4+jhahFPnynAgU7usD1T93K+V5RtB
	bIAIA4ShpQ6sIRYBJW87uvwpoV4zA+fgC8QuY55E5bzGKEkZjZGVMjHJw95qmjp1SR1t1jzaoP4
	bj2HBR5irJc1sXdCaTZVAI3PILQLGhlmhq7vDR7es+JG2fs0XiECMJS1GW1XkUS5KRPgSJjQRTi
	bpbFWozmylQhgbMeKh9MFmL5weixexY9l/gRmzkUFK9fuAnoG6fckUooknRU5hCKSEmXF2u8IkA
	C66AHlQ4ksbJciCFzdVyVg
X-Received: by 2002:a17:903:3d4c:b0:2ae:cd8c:bd04 with SMTP id d9443c01a7336-2b5f9dff810mr171174755ad.10.1776949147879;
        Thu, 23 Apr 2026 05:59:07 -0700 (PDT)
X-Received: by 2002:a17:903:3d4c:b0:2ae:cd8c:bd04 with SMTP id d9443c01a7336-2b5f9dff810mr171174425ad.10.1776949147410;
        Thu, 23 Apr 2026 05:59:07 -0700 (PDT)
Received: from [10.133.33.37] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab0cd18sm208610625ad.45.2026.04.23.05.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 05:59:07 -0700 (PDT)
Message-ID: <8dc34d3e-65e8-429d-9f68-b4cbd0d4b789@oss.qualcomm.com>
Date: Thu, 23 Apr 2026 20:59:01 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Introduce function
 ufshcd_query_attr_qword()
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, peter.wang@mediatek.com,
        martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniel Lee <chullee@google.com>,
        Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Huan Tang <tanghuan@vivo.com>, Liu Song <liu.song13@zte.com.cn>,
        Bean Huo <huobean@gmail.com>,
        vamshi gajjela <vamshigajjela@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260419135229.1036926-1-can.guo@oss.qualcomm.com>
 <20260419135229.1036926-2-can.guo@oss.qualcomm.com>
 <316c8b28-9e93-4d14-b6d6-e8d593b8627c@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <316c8b28-9e93-4d14-b6d6-e8d593b8627c@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDEyOCBTYWx0ZWRfX1PBoVlEg/uC9
 qod8uyKsm3JuxuAj+L7GWIRrY0/jXU4axgUw+088xERe9M6xqF1vi84CN9hLPhj0PtJ3c47ZgJo
 VnObHIL1WZk5EL1CLDn7NroikA+VXqnaGNI5jnzxQHtx38yk1y8/bMRGkkAGLgRNr4gD+fH9TEA
 l7isJWcy4HQBnX28/i7DeNPs3w0k4IwUVg7cw5H1O3ctq08XGhfeFoi5HHlNB2lIxc+2Cgynomb
 mUp3UgBg8/ltyRjv9k4Hkekl6YLHmL+LvytDhn6n1JICPZF1zfyI+NQivI6s+S+w7yfNypghycf
 TYGZKncOeAmTw0yNvPumHwERrQ3HXXBUF5l2bbl6jjkWtzBwO7NTV9zFwReYFdJpHyxh2cj0J2h
 mZga3XHB/yu4Bq93uWlpaGSjZGHYrFggOBOre7KBcRHQ/MZ3ipmGDjaYCL5G2FAz+BbUED+ebow
 BZYpyoFuNJyl6CR9kmQ==
X-Authority-Analysis: v=2.4 cv=dL+WXuZb c=1 sm=1 tr=0 ts=69ea179d cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=V8bx_qqBVzzULFL9Z2sA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: Z3TIZMExsUsN8HMZnTnpcJnRCTMuKgtT
X-Proofpoint-ORIG-GUID: Z3TIZMExsUsN8HMZnTnpcJnRCTMuKgtT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604230128



On 4/21/2026 12:58 AM, Bart Van Assche wrote:
> On 4/19/26 6:52 AM, Can Guo wrote:
>> +static inline bool ufshcd_is_qword_attrs(enum attr_idn idn)
>> +{
>> +    return idn == QUERY_ATTR_IDN_TIMESTAMP ||
>> +           idn == QUERY_ATTR_IDN_DEV_LVL_EXCEPTION_ID;
>> +}
>
> Please change "ufshcd_is_qword_attrs()" into "ufshcd_is_qword_attr()".
Done.
>
>> +/**
>> + * ufshcd_query_attr_qword - API function of sending query requests 
>> for quad-word attributes
>> + * @hba: per-adapter instance
>> + * @opcode: attribute opcode
>> + * @idn: attribute idn to access
>> + * @index: index field
>> + * @sel: selector field
>> + * @attr_val: the attribute value after the query request completes
>> + *
>> + * Return: 0 for success, non-zero in case of failure.
>> + */
>
> The word "API" is uncommon in the first line of kernel-doc headers.
> Please remove it.
Done.

Thanks,
Can Guo.
>
> Otherwise this patch looks good to me.
>
> Thanks,
>
> Bart.

