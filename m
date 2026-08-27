Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505F2351C13
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 06:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787813232; cv=none; b=sdEmxReCKCpWITo3i36j27YbBeLV2HzEQlIW42FaBX/IFTjAhfIRzSs1V/Nad5bWM7Tbnn1/E8hDuLy0CvP2/M4MhltlLaU+0ondggQhK2Enw9RWh1hvaEPl2FibdvCCcCpKzyTXURE8yowoJg7yNN5tlM6ProiFk9bfIpqZHcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787813232; c=relaxed/simple;
	bh=9cU4U+BdT0JcM3/H9SU4/WioDrfsF7Fo4dffAPzaix4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qgAN6SGKf8GukhxUWyHwvvd/X4rh1tfmUIeGdglGDSh/nmS2W7R/JaLxxgEhAoBW5KNWiCdqUlkE91DQhLhQFtKe+vnLXmfZqjnswWBCdzyA9oBuPedW21ln6YNZWikN9bpxz5Vd2tnW72DoQbrzGUr3Al91zPoqfF4bjAVDYfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=chv4SF9s; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CTNvi5R3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="chv4SF9s";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CTNvi5R3"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67R6RHq43592094
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 06:47:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	b/AhrSXNQms8JbMbrVJXa9I6QwNAo12of30xAmlbY7A=; b=chv4SF9sagsZtzY2
	BilGCN4MtUUf3vXNv0d2blfxOwCcpMXezUvkX8MSPx5v51R4X742Aeqd46RJPgsP
	8mmOo+G/5rn3T/L/qmf6xgFlcoAW54Nt5ToSJBDyvfauy9zXHwyzzQL6KSRpBCvw
	vQOzZfplf2lLnGeO1w73x7GexWui8fhWzmteQsybpG7w2yd+s/3zGEFqVi8N6uJ6
	QZzv5BOIRVjIsa65YtahCEzpdt39IWVlfSVnZ7ZSKGuS26DQqJI3vbsdrDZHc3nv
	8qqEg3MYKmpI+N1LpHE01vk0V6yEGJXMv+vy+Cqpt6ZnU6rjVa7Nm8ztShNuM3S1
	RKbAWQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ga4egjebw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 06:47:10 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cc6dd43737so28825175ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 23:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787813229; x=1788418029; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b/AhrSXNQms8JbMbrVJXa9I6QwNAo12of30xAmlbY7A=;
        b=CTNvi5R3KlWab4JlwHldsIekHpIDPmfCosi4fKNyayqPh0SGcLGSI5s3Z5ThDPDg4T
         jas18jK76lE0fqw1NGPNKf1cqpRF0EwOf3avPtTVKMURfDQI2SVoWo2ytPXhMkz9SmMQ
         9uZbEVSIAkRh21DT320KHNl7Q+zMnnCcvGfQAV4E0xI6t1U6l3LPCfkgOEJyz8BQXv7T
         fE+lp1UOKnWK5clhHbRDPvbXzC2no6V3yLQn7YM7Mzzu+C87VZQSiLiBOGabflG83hXa
         cOrK9ZRowkDlJSDXRLmrFXkjW1N9mfkbZacqitTKktJo5WWIlQORyqYsK6lTrz4MOHS3
         hpig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787813229; x=1788418029;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b/AhrSXNQms8JbMbrVJXa9I6QwNAo12of30xAmlbY7A=;
        b=sfj8f59yETTuPqoUG+j5zCMYRilMVNPaBmwlf3RzKPJSFdXAi/dLNwyGxLuXCMaK7N
         m12AxjSwfAw7wqM6f0L35XtRD+fWRke9jwf+pBxdScCMFMYhDe5D53b91HlXkmNnyw3a
         Sb+6wp2lJ+dQWXUKPO+8I6M9gegAvvQxtgJAt2FB9CRk0/umtAquP8bLxrBOXfUNb//S
         qXSwk2cmR5ng5gUGqustidTyEOPD7kCby2MKkGzd3nyG901s7ccG6Gm68KJchTmq/Z19
         3zgaCI/JnHOzyHrZ32z32SvqU61iHTCl1TxZAWVR+gVPKNU5I2lecmuj5z49/dQU/4hj
         5ABA==
X-Forwarded-Encrypted: i=1; AHgh+RragZXgrFAhbwfEYfz1d+8NdAEWu40b5KM8/tc3osHw88VcrGk9j8E8lJRNIcDBu6SSnKsDRkdZCaoV@vger.kernel.org
X-Gm-Message-State: AFuF++mhHvSMboPJW8I3KbUPrHVW4duZQ5PqNWRxVyzrT5Ox4AMkK6bl
	Y7Sy3d8WWjGv8mIDpSkla/YTpNKDC9tPA9aWiEFbLcAP/OESKJw1+pj2GJqt1sw4GFeNsQ7jt62
	Ux0oYJvy4mDIrrCtfbs/qfRX5zH4fp2KtJO9BFIJVjtf/DFOb2y1fvrKfrK4XfeJc
X-Gm-Gg: AR+sD121RTy+DgAxnmdhkYwy6QxbIbhq0bbvVi8xLQ1C1mVGHRV3pVy5rv7TgsV20lB
	5EnNAR7eT2+j/8rHE3eHtGtt2oH7cfg3a/FHG8SgBQB9SOJ+l5ULdQlCEYph/M2HaA/XBTmPyhU
	p2M+0H9A7HAEx3tkFt366aGMiW20zQCE8lT1BVHhPuD1FVEKQUlF9lxkPK5ENLrV8dEQOTxEtzS
	ij5ClFINx3zcKVXIo+WrtacG+GG142lQecHt8vzjhQ39z243qQRHJlQAa9FsMobSC87UAjs3W/k
	ubhW/5XqPnlFRAYYavlB4g9LVqCxZpJmm3asF+ILt515iL21k1EDHNEumg9d3dQAZi6lLhi+ezs
	zvetWzwX90JxSpI9JF/fF+UAzc9NeYgw=
X-Received: by 2002:a17:90b:4a50:b0:392:b509:b1a5 with SMTP id 98e67ed59e1d1-3966d48c3e9mr23462910a91.14.1787813229264;
        Wed, 26 Aug 2026 23:47:09 -0700 (PDT)
X-Received: by 2002:a17:90b:4a50:b0:392:b509:b1a5 with SMTP id 98e67ed59e1d1-3966d48c3e9mr23462842a91.14.1787813228830;
        Wed, 26 Aug 2026 23:47:08 -0700 (PDT)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1123142sm1486827a91.15.2026.08.26.23.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 23:47:08 -0700 (PDT)
Message-ID: <d8304387-ecff-42d5-8cc6-d3b4526fb294@oss.qualcomm.com>
Date: Thu, 27 Aug 2026 12:17:02 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 1/6] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
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
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-1-09271f583dc6@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-1-09271f583dc6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: Oy32WNro8bSAr7iLqg36CsAW1cW4iaWA
X-Proofpoint-ORIG-GUID: Oy32WNro8bSAr7iLqg36CsAW1cW4iaWA
X-Authority-Analysis: v=2.4 cv=DsRmPm/+ c=1 sm=1 tr=0 ts=6a8fdd6e cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=WeR_djdGDpRL5iHq6P8A:9 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA1NCBTYWx0ZWRfXw2QOzXXFHEjl
 9iZy9qTCZs6WpnwTm+IiQL0LyLeEyoVmWOjBTVQUEvQzuJy2nB8nHDK2y2vUdxYQxGQ8k5rY3e4
 4zNx8ueUG9fHDjs/1HyntC07Ly2AaMU93A0PFoR1rNEnKWjK12Ufo9T2VfW00yRe3i0p9cADDai
 udYKRNJ6GTgOQy9rRT7RU8NiJRR1l94SmDLkYdv85vj+GcewXZgf6VYrD6Lux/+7QT0FcxvrGr6
 r/i9dV+sdSuswUtJaSPGsTCuyLvJgF9haBgh5O3hpK9rZipVutxoo8M8mvq9xEqA3O+VT5p072A
 fCKfjphfrYmkJGVzkkLpynD7H6JE+GrGkZtvn0JxB3Ln+TnYtKeBv56Xfoj4+Yj4ytsNz3woThA
 ec6D6O/uSzNUQD141BXxcL//4Wi9CGR3jvzl7RApiId/FLouStHI0Z+PhF0Uy9oz1QKyuNhDzNS
 YSdfGXG55YV0X9mKWWw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA1NCBTYWx0ZWRfXx9ttmD3n0FFj
 FaMBaSl2pKhVZ+X3hoG9RDOqw0ax9O6L1c6MvAknGd6y5Dssu6E8xkYsDqSaASZVOLXv6s5A3q6
 S0rsphz8LjNlmzqkBJzhKiE4GxUFeJ0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_03,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 phishscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270054

On 24-08-2026 01:17, Abhinaba Rakshit wrote:
> Register optional operation-points-v2 table for ICE device
> during device probe. Attach the OPP-table with only the ICE
> core clock. Since, dtbinding is on a transition phase to include
> iface clock and clock-names, attaching the opp-table to core clock
> remains optional such that it does not cause probe failures.

iface clock and corresponding dtbindings are merged for v7.3 and your
change will land post that.
We can drop this from commit message?

I think we should scale only core clock and for iface clock should rely
on ufs/eMMC controller maitained frequency.

-- 
Regards
Kuldeep

