Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFCC319871
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 08:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781597140; cv=none; b=U42GiMUTGNokA+bW5G7YOdim5J7aPu4zDptwag8Zi05vdB2vDuPlFrOsM6WBNM27xriVj9PAys16eBO518KuyIlA3P9WqOlyVqqIed8G929qMgqpxz/TclbJ//Xf71ghnTPybmrlnqq1ZstPn4V15q5SynxWfcVoCwrW7R77snU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781597140; c=relaxed/simple;
	bh=LH85bdQfVmzgrqpeuQMNParDNf5GJDQCKxnh6gYkn7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P7EN6ul5M+bATOlYjFe9vv4f4VMWuT4LBKoKSiHRB0oKUJQJ9GCmaphz3JEpJyGzhSD9WMBXqd5cCgiTZrlsLr937ri9npZr3R+/Oq8OmpuO2kmODYqtkaFAoZHxgnwzHUpDAUmVPFhh960Eci4v7wvxJJjS+ZN4a2gm2NVkUiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gy+xzCTt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=W+vsnyRw; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gy+xzCTt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="W+vsnyRw"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65G64Ppe850872
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 08:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LH85bdQfVmzgrqpeuQMNParDNf5GJDQCKxnh6gYkn7I=; b=gy+xzCTtVI63Ep/E
	FUadRmYKzfYsdAzJngwpzbvavI6W5Yigma98iLsB3CxCn4UWkj96g4EDK9NmOiPV
	BH7nFGLo674pUfOhRrKmULHe8dYUjqO4DIX++ttT3NsPrvkitYl+HV9An76x1Yfw
	+UmTPOC2We1B0DLDShKD2OgY2RVhA5rY5z5cJGQKTDWy6jPotoafgXh3dok2b1uu
	aZYPmOTNsZUuyKwaRE6/wehuUtEgJ2q1RoyAxMHPBw363znecda2G0CTBBOxEsOD
	1lQbugRKtv736xlUwVkgTCYBOJIeakC4Tp2uWATh04pfe5kmnliOj0xgC2fAb9Fr
	jMTVoA==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ete985rvg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 08:05:38 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2c6a3ece0d8so1635275ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 01:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781597137; x=1782201937; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LH85bdQfVmzgrqpeuQMNParDNf5GJDQCKxnh6gYkn7I=;
        b=W+vsnyRwUuTg1TbrbE5lKLKcYkDrxprYXYvXRi5U67v3KnsOe49RK1XcGLbvWXUq/Q
         SYhJsK+JBfIrUqQfPXDtZCwT/LdQqjI58LpxSE+Ivc4kFNDaDhvbvPIxiamyIm3pMfk7
         LBIvrSbmLc0qmt8UOh9O9fVz0cay/Nrt5mR5nisN2HLswHEY5I1m4q1OFk8TtTv0g3zx
         lOg8GeY/9RIZ0UAIsuLE0vej7E/ni4fuH29r1E3p2UPAbvCIv9IQUiO4p0Qae5YcdWlf
         6i/QxZvMQX08txcbf1OcptzC92+RpAGwCbwymttI0Y9ZwEzvTUbMLB4G5VPUBKGBQBIi
         78HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781597137; x=1782201937;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LH85bdQfVmzgrqpeuQMNParDNf5GJDQCKxnh6gYkn7I=;
        b=KI92Y1ust8zNQy6uoBW18rftzXXVN2bl2U91GqY4PIHb27eiOjnMLjFaMgT8/ekDiY
         SsW/ILHSlq/TnkXCllvUIM1sNlT55Me04jMb8E+bRtFUSS2D2HsEDD4g6GLp+gCFS8i0
         +jm+bVVcNGeTnUbeUyNxcZurWX6MvpV+PJppOMfyD31S7sOgNup2QZezDl6hpk9Qh6sy
         cdJn9yRd7qyAhemQ1C30iF8moRMMwv6U+3jcEEdFlVkfFNmLwh5iQSIf29xOuEdsJ+t6
         fQxGc/eZSNJeI3kr9fSgmHJozL67VTUdee1rsXDvozA/bUS/laK7pECel8Gl0enOkTXy
         JuBw==
X-Gm-Message-State: AOJu0Yx2Ruq+b2e91xvUORv6FbBYzbEDQxJIRH1o2B3DWmn4lP3SBLDc
	tQobWrDifN2E934ZK2qVvyUaGp49HXCxJYnKF2NS55gFIleUOhIrxT7RAiRmEkJsPMJPDhWjbqm
	QzeNNrOQb7GbqhvvCrrUEzbeaCn7fZs4vdzfV35LbELTwsnhTFp36gFXzwQ4mK7h+VYnnm37dq7
	k=
X-Gm-Gg: Acq92OHkWY+x0CJoIcA3U2fFRfeO8kRjmhCTRX7Gf1sJOT4dLb1zFrpf451eNjD9GSi
	QX8dX2ab+wWfgKD0Ibffn22toFn6HqpcCqV98OPkeNWwA8MaSDBmXSO/8BgE0EoYJG2Uz+Nwz3K
	IzUqhkJkKqK78BG6OGNWnEA4xDPK42vxTB9OtQMtRQjJb3E+Yxr4i1MYl6Fg/lXPC/UFa8yXThR
	FQqrTTDAnlrA7WmtZ8YQ5FSPn04qb1dfMNPZHIFNQeqeDzyFjpzvbCCwlz7rUEq32vWxCmla4lv
	g8rn9ZITJN2uwUWghYi2Til8bXiFJa93qzPCPgcJvsywi+iW8y819w7ckCuHyNbmP94nGRvlBKZ
	USK596mbiNFixsYMkAAsMJWQvHhC7hp3shizvi7JeIL2bfFLltZzKvTlaBLgQztNvmyUWDDlinA
	vjnM7m5cjshg==
X-Received: by 2002:a17:902:f54a:b0:2c0:a746:7aff with SMTP id d9443c01a7336-2c69a186b1amr27844485ad.24.1781597137472;
        Tue, 16 Jun 2026 01:05:37 -0700 (PDT)
X-Received: by 2002:a17:902:f54a:b0:2c0:a746:7aff with SMTP id d9443c01a7336-2c69a186b1amr27844095ad.24.1781597137038;
        Tue, 16 Jun 2026 01:05:37 -0700 (PDT)
Received: from [10.133.33.52] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c433369c8asm126370745ad.73.2026.06.16.01.05.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 01:05:36 -0700 (PDT)
Message-ID: <f33d6b99-9358-45c5-82b4-08519f557370@oss.qualcomm.com>
Date: Tue, 16 Jun 2026 16:05:32 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: Bart Van Assche <bvanassche@acm.org>, krzk@kernel.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
 <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
 <35a67c82-f71d-4a20-8560-05c2b1361b06@acm.org>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <35a67c82-f71d-4a20-8560-05c2b1361b06@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=V5tNF+ni c=1 sm=1 tr=0 ts=6a3103d2 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=eY37RKT_pTjDV0uVlbAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: tKgQEeDMHD8ImPuSn3PP4cb-QI6FJ_FH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDA4MCBTYWx0ZWRfX+rmmVYpEkLJL
 0otyvsd+MToVNzyLKDV90kGji2fIK2PEjhqLens2VSZb9crnTtJr/HvGWkz0flTolTTZzw6TZJ2
 lCm83r6H0I7LyVu5dq74mynqQ0WQzLY=
X-Proofpoint-ORIG-GUID: tKgQEeDMHD8ImPuSn3PP4cb-QI6FJ_FH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDA4MCBTYWx0ZWRfXxLO04etvLB7F
 5XbSf+4mQ6NbMFyoFG/jdOIZtUuSOf1T3LzIP0BlhjbPMWWt+0NWulmk00pCI1KCTctM/J9fMHD
 oQ6IAN5dA2ikfeSuz5edbRcGvr8Hr1S6NoSCvsrv46HV7IkRy0CFoNS776eGZ47Q+aXgpXCosEX
 7LGz9lFzK54+Mzfo4N6gd13fii0nRxLZriK01uNGeAs2RJKwcv131z46SrOLmHf21b61Ujo4rQ0
 TxAgxwluAbHm0h9uVeOPz8qrQWxqf525HsoolKjFMZWTCXbvhc/yx7HpPDpQjyr7zQYSxVA4N41
 bPAt7MvQmnzeZX38TS0I7NIroCm9vvp2+INCZi9QQAO3j83gD5JaxAlLkihoEWeImWdKzx5DrDc
 MG/F8/BjLcc8bslcPfXpjmvtRWEMKoJBMimmKEXbkAVUeJQp0tv0EHJvgXlptY50enehjANmhT4
 5uj7SEkUDN6BG8YCpDQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_02,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160080



On 6/15/2026 9:38 PM, Bart Van Assche wrote:
> On 6/15/26 6:28 AM, Can Guo wrote:
>> +    prop = of_find_property(dev->of_node, prop_name, NULL);
>> +    if (!prop)
>> +        return 0;
>> +
>> +    count = of_property_count_u32_elems(dev->of_node, prop_name);
>> +    if (count < 0)
>> +        return count;
>
> Can the above two of_*() calls be combined into a single of_*() call,
> e.g. as follows?
>
> count = of_property_count_u32_elems(dev->of_node, prop_name);
> if (count == -EINVAL || count == -ENOENT)
>     return 0;
> if (count < 0)
>     return count;
Sure, will do.

Thanks,
Can Guo.
>
> Thanks,
>
> Bart.

