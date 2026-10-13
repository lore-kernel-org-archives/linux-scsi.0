Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7E648094E
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791888121; cv=none; b=YWSef5ChLzh+csMw2rIcnSoRiZRFdrY12Rl/IcgKgt7ZG1HP4DA3gMdm/gDZr6p9wm9+idaisGG1A2qAfpGWC8+sRsQX0ZsZKjTh92VF1Z2K4now55pNLNzR1GyRPmVDEb7Sl/Wz4ri8ixQoonnPT0fdmgZ+lRHOmNBBPQ1Gazs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791888121; c=relaxed/simple;
	bh=25t5Shm8jjOBY7bq5UJ8UnAaGLeRkAXQC+r0by3Ebbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AniVXGn5AcVNvnK8yQJFlspk7sCRLHKh95RVX6vkhGa3s2ALK4/YWTPYDFqFjqF5wx05PO3vI4uojPhcadB4jdGph08Utjl5OSkPWvwYAzR3coVIL1uatlIk9mtoxstZQ6uxAdFIg23Hwq17t6dyf+mR0oO7BV7qHDd03I6ho00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f3c4v/xm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Z/rCz8CI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f3c4v/xm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Z/rCz8CI"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69D9cmBh3475941
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hYm7ffZ6kkZ9ZrD23lf7fbY8mVfzcRmka0qHDZVc8vQ=; b=f3c4v/xmL9JnOCRG
	vrDzx9NatQFDk3vf6tHQu8PFSkZXjNMjFpHg5tbvt4OWdCznRP3FZuWe+ALXl8YI
	SLAhZJCEV8EmC4q+aUI4KpspOqC9Q4j+MTj9R2AJnTiIvGmXbb1GAaRHrb9VWs7k
	AnxX/NvEL8YGLzizBrhQks/+T9AzWtpeJgJB9gskD0f2Bq/hrImUSeWBVSHws98O
	u76kbfNQCGxF0RV4HvhKaZSFl5KDC2N0qtm5nBjIHupM9+ngZ0APaBrbL2Rj0Ect
	Uh7uXfTIBnHcZRXJeiz5EMKWEZ8YyR7lEo9W0xzYsFgguM3X4z+NNrv7hQrpcvrw
	yaDqcg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9d7j9kme-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:41:59 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5350173dc7aso6186221cf.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 03:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791888119; x=1792492919; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hYm7ffZ6kkZ9ZrD23lf7fbY8mVfzcRmka0qHDZVc8vQ=;
        b=Z/rCz8CIvF+PmFQKxMMejblCAGIwRfa3+dZ7KisDWaD2Js/XLQjlq+5VgrBq8qBskm
         vgter0chsXQOblfT51l/bg9paOqRW/bV29m5xQHGfnK5yjeda6paGgwL+DdTrZe2Qt5p
         QvE+aRSImuSkyc6s/wfIHrB1NXJs26No0IxVlUiHg5N+9pm3cqSxRSX28DlB0abYWsyO
         Y4VmKxlXl6DgksuoywPGbnAbZvpllkEuqd8m+RKRfPKNH7bbU0IcMSR7l0ijjn1vPB/s
         fYLnYt6nHAew5aTstrskn4Znni4My4IrCvYwOdwbHtkYurmHRJWvH3FDa3modJGeKDZa
         dVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791888119; x=1792492919;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hYm7ffZ6kkZ9ZrD23lf7fbY8mVfzcRmka0qHDZVc8vQ=;
        b=1hWYBHdvh45X0u0GaNXFaCcQ/J2d+a3EgiZt5TAUjIxqIiROl+VfpEDnzNHNnFAw7M
         vmFHT6zsjIHav+PDotW0/QDk407DXJjzD/SXNJn7TdoaN9k3FfTX+fGXu+i9aYyhldwG
         L/bOgWZHIQGYmpiY1cNWBKsMq+xK6aP+TeMJ9nDkHZ4fIQwXp8xi5btPtpS3T97ONRp7
         ICKRSgwzPIKWxE64XWhWUW1rFnH7ciwTSmKR0U17ZwmuYDf2fewd0XUOohs0CV67ziog
         jswPy9ILu2QG7E8ExVb8V9+uTllBigF8Ng3m9C+BjLrW7e4sk9SuVOc04hkHcbzosJyQ
         n8ng==
X-Forwarded-Encrypted: i=1; AKwUvByc9IsIAx+0758V81HaDAWXSA3237E4lu2bFnqxRQDuqa56Bu6Nr7gdPiDtj4Ja2IUOopo58WvIJP7o@vger.kernel.org
X-Gm-Message-State: AFq9FYJP9YNZGLVKUYuACHU1CaoXj0NoDXi4GvpPs7ieZBOvk+6wxUF9
	eI7ar0DgMUvs2GRPVZqZLTWQHWhAVNgtw93hqIYLzO9rg5anzQFkB9NE5iEqd4Ch9eMCQX74Q9g
	8qAevud5iOgnx/z/sBBgPex2NrgbH5gpIbjXSC8JQsCSMf3MO2g89jCj+7sUJUXov
X-Gm-Gg: AYBFou2FANIaw0tz1JpXIEsaURyWJSIorbhehvhHNcRxsiJRHR5DHbb49EsiM8JwhOV
	R/GmlOkTVqtpiwe0gtOf+lJ58x7aB//mpS9bNjLBhOw7cwezb9g93xNkbTV+yQy0OF02jDXHMco
	hjE8DTqhpQi/sxFT9Vqj196DKpGhYlL7BZNpNIpy0ewcbbV+K7Un2pkr51XhQxDVI7fsNIvMV6b
	URfjPPG/NLh6C58w9aSn2Tu6y0PIKHeE8ixw41c6MLTtGcpBSQWdSRVeWc1w4FFv0q6AAN9ya4c
	LRv6/fLOiN/3hh3n8FR8QZhCsDxjnzFIVAwPcEk906V3DVJ+hdo1cQG2RG1c9GYmr4CZqzP3qo4
	GBFYMk4qE7ZAgeQK22DD6AQ==
X-Received: by 2002:a05:620a:19a2:b0:93e:54d2:2283 with SMTP id af79cd13be357-93ebd2955edmr2149896285a.6.1791888118826;
        Tue, 13 Oct 2026 03:41:58 -0700 (PDT)
X-Received: by 2002:a05:620a:19a2:b0:93e:54d2:2283 with SMTP id af79cd13be357-93ebd2955edmr2149893285a.6.1791888118286;
        Tue, 13 Oct 2026 03:41:58 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c34001fbda1sm293208166b.66.2026.10.13.03.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 03:41:57 -0700 (PDT)
Message-ID: <ff148816-f24b-476f-ae79-5161a8e7d8eb@oss.qualcomm.com>
Date: Tue, 13 Oct 2026 12:41:55 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] scsi: ufs: ufs-qcom: Don't define variable in the
 middle of the code
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Martin K. Petersen (Oracle)" <mkp@kernel.org>,
        Can Guo <can.guo@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20261013095924.959455-1-andriy.shevchenko@linux.intel.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261013095924.959455-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: ZVlPGE8FMt2heeco3Br_WfOlwv7u65U-
X-Proofpoint-ORIG-GUID: ZVlPGE8FMt2heeco3Br_WfOlwv7u65U-
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDEzMDA0MiBTYWx0ZWRfX/TdNk+1BWx8t
 BiYbMMIhDWCvm9J7HKRxHMGr1hhAb8ImdPCACvQyGTY2qnpt3kL1TAx9Ad9OEcre+E7NgkjIUQu
 K3fdoa0oEqoiV0TQZns3bYVFnCpRxJI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDEzMDA0MiBTYWx0ZWRfX00VILnXL+wUl
 La+b0rmKAQFYIT0FPyO9JkGHdcX8MzVP3mWC7MUrSemZlV75W6HTXmb/xbQ8/B+Ddj4th8zCxEK
 Wsv9ygH1PY9i61aOApNE+7NCvFHoce97cR3vuVJnmJGaRF8/qPzkxT/cn/fnf2Q5bELYPPrDwML
 zDeBva1y+ECQZgHhVhaPsy300WqMAbXaFrnouwd9fIB9zb8TAaYIZvZi7iI+TqKI41+5wi5iuyB
 DBkLMZBQbcAFjn/h4MxljRYlc/K0J6lJO1gVpDfXEtLbqtv2L4Gjduq9fYwZOGjDKZB/RG4X+Mc
 4ocaE1fMcqopwBcrE+FtM5My+6xXK3rHlszxpYM/EF1OgbdAmJZLGw44OHReOJf0SYEHUa32D1S
 caPriThPwaqwj4VargOpEeztzANXu2eOMLi84h34OabyIbe2xJoYE+r6LW4yxGycDmyYbH4BMuC
 G5Tpn2vqp5mFq7lOUSA==
X-Authority-Analysis: v=2.4 cv=PMGaavqC c=1 sm=1 tr=0 ts=6ace0af7 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=bd1Yv5s-Whjvz_XX:21 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=VwQbUJbxAAAA:8 a=bLk-5xynAAAA:8 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8
 a=LrPPbbfl5yCxfJx9f8QA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
 a=zSyb8xVVt2t83sZkrLMb:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610130042

On 10/13/26 11:59 AM, Andy Shevchenko wrote:
> While the C11 allows us to define variables in the code, we do not
> do this style (see more at [1]). Move the declaration to the top of
> the function.
> 
> Link: https://lore.kernel.org/lkml/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.camel@HansenPartnership.com/ [1]
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
