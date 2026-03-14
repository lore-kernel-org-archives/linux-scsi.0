Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E5029D29F
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 08:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773476380; cv=none; b=CbeB8NidpiGJGPp2DRs9d/sGdu+ON+KwwAI5AzyMznCCn/vZeUoIYvELIdiTa9+sUJrPTSFMWVfAf36BVvxhoebyXj4E6Eo5tIzWp+N4ExcapHzrzwxohdkIEpEQ7CmcHBY92jw1U1WC5BxhA5eZIJSUewlT8miGom3vnV84+xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773476380; c=relaxed/simple;
	bh=yL57mEjBppZAhUsI12YY/enfvU2Ir84udGgV3hciYH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ONSf9u8T6pY60vp9Kqg9KXA85D6qCVvEolLSnEX5Sdrib/l1Yi8AgFDAVNgmv306R56p/aNuX2b7pC8VXPK2LQWyVXQZ7M8nmTj2B8v3pwRjInLhFqJn3rb6eg6w074c6k4ZQj2aXrShZxWyS3ouUPzjkgu4nIDA9OaxdoKD5pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=pqHs+MKc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kCii8r9I; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="pqHs+MKc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kCii8r9I"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62E3nkJc2000235
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 08:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	2GKqjWkJCf/SFXEAPiGWvpOX9aXVYHPgP7iT/euqkP8=; b=pqHs+MKcFLny6c3l
	ob2sS8LVQfT2dSXIifyHkb4lzBQEV3ndLS+ox/1lLY4qdEaTpfeZOsxMh+ZV2U2L
	CR5EGrARH4k+YSgYYacwI31tQ7ndNEV9S+vOR0gnzofkiAJRWtf4rp6dumI7UpOS
	zdWFhaG37b2EneQXNHGnDxGKonTCOmIIXUorXcJj58PMiuAHKKqRydb6f3mQEvoQ
	mxskyWg/SQ5nFP/KnzMHJ6T+hmv5E7g/Ftt3Cof/7uW3zHepQMBaA4h3ICfBm2BC
	/UU2NgyLdDBwx8xLqkVq8NAVOpl4vE8o4wzgp0jkHh+nJCfCINX9AaqtQTQMaz+r
	7Cy7aw==
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cw0420d09-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 08:19:38 +0000 (GMT)
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c738563e61eso1710038a12.2
        for <linux-scsi@vger.kernel.org>; Sat, 14 Mar 2026 01:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773476377; x=1774081177; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2GKqjWkJCf/SFXEAPiGWvpOX9aXVYHPgP7iT/euqkP8=;
        b=kCii8r9IT5+y5u6FNmBy7c6+K0uaNSvo3DcYC+TcdPFjtgGnhXCplBrHzCR5beEQdd
         RG5WdfY9Be6mJWxamMIGJBRNWIZUv85HnmeQO2buFRj43No5M55Var263ZhBTl5kPHCm
         yR8iyK4UGzZNqCJWsKL84Kl2mtAjSqLnwWBpyaepqO5FhSOmHoLtyIdC0nJEBs18Q9M4
         +VcyVa/e0x5scHot3Fo5toLF1cnowAAUypWWdlq8HRhnvgBf3uDVQ8xVQnlYMFrcYBml
         YCa/fVTrcavlsGgIaAPsiaYp/XBQ9eqR1tKTB6qgJiv32SLHxWOS8ln8Ib4Q5Cc9RmKP
         kbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773476377; x=1774081177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2GKqjWkJCf/SFXEAPiGWvpOX9aXVYHPgP7iT/euqkP8=;
        b=sOfevYvS4ZfeOLsGXx4FPkZrOEvQjgCZdoJ43NcPyY2JrZ7JKvYGayfjtv7/1nvEQB
         aqAvW7WFbnJ7RwgnY0gZk+0N8/qboEHJg2u7M5TSFGLgnvC3x75pSSbBPoxsK9UL6Jc6
         kkcnbt+HfjIkkySeCKXu4dE0tI5zcERqO/uj6bjK5x+Svg/4YC+EGBJoFzbOBMbJ0tnr
         u5k9hui7rvsLhWcaVom7+0kQgPlbrdP5+ex+5x3XB+7sU2IRhWfdQktmaPHDD9rreTlq
         wdlKlyxZ0MUT5Um4TlSPIyQQkgYTreWe5XLkdlRq0+4KP3XsM1F7GranJa27KlpZDAIR
         TO4g==
X-Gm-Message-State: AOJu0YycWEEQk9stNriLXCJ25TA7xom9r2WzBF6o4I+khliAUojID9JO
	SQKNObUI8IpiVQcIkfZEJPbJJ3YQtHxP9+SJlEriEeHXS5/77q07osLs5rQ0FFbSU3GM+Svoakr
	PwHpLrS5X1ZTsRbQzx4qkw08THRKFKs/XQAi1tiGH7BVdWSrXXl1WSjUUzofCj7Xa
X-Gm-Gg: ATEYQzwYxHIWLFv2md8jHFsXa15z1GF6SDmITL60OlFqbWDF8tV1Xbkl8XcNVjVGf/y
	tt4WOlxBWHP1JrwGR0mf4fjjYF9Rcu2B4u95ALbsP1vhqYmfcCMqLTvZyLzEl9q4sLjZou/iUNf
	pFlMbhh+eZ8bxHg0wlGadHjnHUFDRWQ8Eho1LplSCdUsUdPK0sjFVm7OS6+hh3pncscopNYBMkK
	J/6XVzHKOL1m91IvojzjPDL6lfiXQ4uJoP4VtkxOG/9loRrx70ugLpoL4DXZ15bYUmhI2vgW0Xh
	o1IG5V56OmB4yMN2QjwalawdfzpVQJ1U/12ulGL4j7NjDw1tdC+nfW3K7wKFqdma/ryB+PKijNE
	f/ZqaWQe7qpDE2DbgS8aKBbiuvzV2oCsUg/Y6tirsD27h/DmWxxgBqxaLbFMBavZ5BZsaI0u38e
	2+sasl0tePtQ==
X-Received: by 2002:a05:6a00:84c:b0:829:86a5:d30f with SMTP id d2e1a72fcca58-82a19703a46mr5506926b3a.11.1773476377374;
        Sat, 14 Mar 2026 01:19:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:84c:b0:829:86a5:d30f with SMTP id d2e1a72fcca58-82a19703a46mr5506906b3a.11.1773476376928;
        Sat, 14 Mar 2026 01:19:36 -0700 (PDT)
Received: from [10.133.33.24] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07366974sm8005672b3a.48.2026.03.14.01.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2026 01:19:36 -0700 (PDT)
Message-ID: <f88d9fc6-4227-4cd3-a124-0e93122e1d85@oss.qualcomm.com>
Date: Sat, 14 Mar 2026 16:19:30 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/12] scsi: ufs: core: Add support for TX Equalization
To: Bart Van Assche <bvanassche@acm.org>, avri.altman@wdc.com,
        beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-5-can.guo@oss.qualcomm.com>
 <c44cc56f-513e-457b-96de-203d4b534496@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <c44cc56f-513e-457b-96de-203d4b534496@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE0MDA2MyBTYWx0ZWRfX8ABVG4LD21lj
 uSAfgkigRyzEgjrdoK/X9LV3yad6Kx2LmyYOHyUijJD7xg7JaUVHY5UovimP0eT7id//qeW84FF
 UsKGCY0Uli80XT28K+TJi+5mZrvnlo6ri/KKzmuoUUzle1WUZGaIaiipCRo5ksYvZBq0Gch9v60
 zT5mkuC4JRiaWz3oRJfzoqz8qcblRxFbV6f0YRXQ9I6WeI3Dcc3/rZCQ6VV52TQOovORryEjwHa
 TdyXCyM9dtm1Yfsb9rPCToN/2gsHjp2D4P8l6k9f6YMEsTHvxcz7bSzUqwiaL3nzMlQQBN7g0xl
 j03WyKSVMtSGELRus0XhBNV/eEb6EdjwdYpq8yc0aqEYRpW9O2WnB+J886CyzNfIZF4qMaIIThq
 hjUCtpbP/tL5ziaw43zAL0ZaCcX46NdEI5fWfoRpOssTVPdLpF+UMXrP/G/03oWRXP9ZFSF/L17
 GZ4l5F4BJstEXftia+g==
X-Proofpoint-GUID: 3vrOmfMZ3YfqP3kzzEJpD00nl7R86eav
X-Authority-Analysis: v=2.4 cv=SJJPlevH c=1 sm=1 tr=0 ts=69b51a1a cx=c_pps
 a=rz3CxIlbcmazkYymdCej/Q==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=FkDJwfnGEHPz-odBGkUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=bFCP_H2QrGi7Okbo017w:22
X-Proofpoint-ORIG-GUID: 3vrOmfMZ3YfqP3kzzEJpD00nl7R86eav
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-14_02,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603140063



On 3/14/2026 6:19 AM, Bart Van Assche wrote:
> On 3/8/26 8:14 AM, Can Guo wrote:
>> +static int txeq_gear_set(const char *val, const struct kernel_param 
>> *kp)
>> +{
>> +    return param_set_uint_minmax(val, kp, UFS_HS_G1, UFS_HS_G6);
>> +}
>
> Why UFS_HS_G6 instead of UFS_HS_GEAR_MAX?
I will use 'UFS_HS_GEAR_MAX - 1' in next version.
>
>> @@ -955,6 +1045,11 @@ enum ufshcd_mcq_opr {
>> + * @host_preshoot_cap: host TX PreShoot capability
>> + * @host_deemphasis_cap: host TX DeEmphasis capability
>> + * @device_preshoot_cap: device TX PreShoot capability
>> + * @device_deemphasis_cap: device TX DeEmphasis capability
>
> Please either explain the meaning of the bits in the above four new
> member variables or add a reference to the standard that defines the
> meaning of the bits in these member variables.
OK.
>
>> +#define UFS_HS_RATE_STRING(rate) \
>> +    ((rate) == PA_HS_MODE_A ? "A" : \
>> +     (rate) == PA_HS_MODE_B ? "B" : \
>> +     "Unknown")
>
> Why a #define instead of an inline function? Aren't inline functions
> preferred over preprocessor macros?
Let me change to inline function in next version.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

