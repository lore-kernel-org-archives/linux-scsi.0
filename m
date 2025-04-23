Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB704202978
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 11:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745406572; cv=none; b=ceruNIhPxj9o1RZPvAPuWaT8UEIlH72pfnN70mf3TEpzmAnyZdg1WC/Q9N/M2nwjRnw38Lc9JCC7RcpiMeChUVQSA0o5NZ9r4+fwwPxNEtJgRxUYNINmsyi2CEWd/RjHzIk6g+iqxmD3+ACU9tG1lM/AS9V4U3UvIUgHc2AXpZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745406572; c=relaxed/simple;
	bh=yYkyb+EUkaB7iruBXQArN8V5Gx5hk+6OjIcFf6LQfTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o4bz46+KtYFn3j8YJsHSY360c9Rn7ebj9x6bv7tJr1RBSdWFW//7DU5N6MkxhHXK1B2YpENEdzssPahlumeCSCNWccNpKK+5ZDUbsrXCL6qX8c6ZPjIYIbvcA2INgNNUsTma54qcX4apLv0buSaAkcQsK+lh2HzN/5RCOrN5O20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gbgs5Pmb; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gbgs5Pmb"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NB2AaK007647
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 11:09:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rd3YHcBC3TYtyVK0LNqsKsNH4Ca1SUDlk/VqAbaBYrI=; b=Gbgs5PmbS8Rwe2pl
	Dq6Am/mKNhrlPfQGhW8NJ20qN/u2MfsTbMt9JKfTsZsriPgCrD1ZJH6fyBdkpHSu
	jdoV1xiMyokzvwCwhb84EVPK+qC/ms8DuOjyZ2u4k5Ie//6MviheNXJIR5BE6Hlx
	XZznHFV/OYdCeG/heni3kCKt45iziHEyIsWRyKiFtmUxqlC6L7KT26gWzDXWwYyD
	SKbu5nLgMhry0zDGxU24KWICXm+VTEokewsAax3Pp0KBl8UwFiC/c6fvmx1zyq0u
	DAP9S1arRjzHfhq+Rhf64cyydOfzx1PvSvdLg514Bdlkkw8JkIxoax/0SwlUhYOP
	pH6qqw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh59whb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 11:09:29 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c53d5f85c9so132684185a.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 04:09:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745406568; x=1746011368;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rd3YHcBC3TYtyVK0LNqsKsNH4Ca1SUDlk/VqAbaBYrI=;
        b=wT3R+QzWxFhpwdlzz9qOXFYzXFthepR79XwOvfeRAw7MLBg26exguqGfllRLdc3uOh
         SfLFQuucA8EOWgBnFzyco2rHoxy2ig7o0ce6+KIb7no1VQRKkmMVpUkEkgkWHOdh2hSP
         lM5whSFW2S4ma86PiC51TNoFd0krtrVUDzLFiSaddssaYxRfg8wx1iXA7lyqrljrjqR4
         5+pteeEDagjjvFkaIqSYcQpi5EihXHDCqywo6egvkyKNMxJbFee3ULlM9Rd/xnecgf5z
         BLDp/2z3exbLW8SUcZ4nOAcMIbhU/+31Z0UDgvRjJrVP4uY41zZ7Md4Qm4oMTIKGzY2a
         Ifag==
X-Forwarded-Encrypted: i=1; AJvYcCVyaY0e+Q1v1/xLk53emz7xeBf6PfLiliNdh3SPLdZ8JV0WGwIce1RBUTgLUYdj87ILsMiElm1NaB0h@vger.kernel.org
X-Gm-Message-State: AOJu0YyEqXjm6F2cHzY50NpiRI1h04EgoDzYo+bKj32oV9SEbnbRlULp
	HwVZ5ftLRz2/HWmQGXaZxSsB6h/uv0vyRtOWoxdHBPNsu/BQeoA+2vwgnsCIIc6l5AonewQJ8Rv
	mVCXJ+Fd2FeIt9MlNJtXlCn0+2jWsSC/w1w0UIFO/7oe8DxcAvevG8nLQ1myl
X-Gm-Gg: ASbGncuXTOlLR+PzoLHrNRoCKmamQY3V38zGifZ72KLElcNfvJCvOu05ThJnJQRxqy4
	MUbDHJJIoaGGMPvPioqByFe/vv+Emm293qdUmfK/On5Hj0pVqM+lji5RLZLc5QW0sAdlqyVmisI
	glOM841GS/2rXs57NEZGwDm5WTCdpQL6Opjnsp7if26HEwDXCuUv+TP1npzy9izP8ki9h7Q3E6Z
	/tYHvlPjeSsLC8IdXvoMG5wMah2JfKaHSmF1ZS6QzBvKF6jZ5wpJV/sVjVDTlim2JV4t8ksi3bQ
	kDzfglRkFW9UNqRf43vf7KRxyyvbkuzo+c4x4RxPJMLgJvtjQ7k4gGphekRskyuXKSA=
X-Received: by 2002:a05:620a:d8b:b0:7c5:79e8:412a with SMTP id af79cd13be357-7c94d243c53mr169135885a.2.1745406568543;
        Wed, 23 Apr 2025 04:09:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiZEnn54IflaB3i4pqXC7ZrnER6o9bw/syciNUcOHoqO5HVrimc4sTg7qhgrFutnZVRtO8kA==
X-Received: by 2002:a05:620a:d8b:b0:7c5:79e8:412a with SMTP id af79cd13be357-7c94d243c53mr169134385a.2.1745406568049;
        Wed, 23 Apr 2025 04:09:28 -0700 (PDT)
Received: from [192.168.65.183] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6efa5c5asm784078066b.166.2025.04.23.04.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 04:09:27 -0700 (PDT)
Message-ID: <b7027077-e9a3-462b-92a8-684a42d23604@oss.qualcomm.com>
Date: Wed, 23 Apr 2025 13:09:25 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/9] phy: qcom-qmp-ufs: Refactor UFS PHY reset
To: Nitin Rawat <quic_nitirawa@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: vkoul@kernel.org, kishon@kernel.org, manivannan.sadhasivam@linaro.org,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, bjorande@quicinc.com, neil.armstrong@linaro.org,
        quic_rdwivedi@quicinc.com, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20250410090102.20781-1-quic_nitirawa@quicinc.com>
 <20250410090102.20781-5-quic_nitirawa@quicinc.com>
 <pur4y63xhfmqlyymg4pehk37ry4gg22h24zceoqjbsxp3hj4yf@4kptase3c4qp>
 <317faeaa-3130-4e28-8c5d-441a76aa79b4@quicinc.com>
 <CAO9ioeXnnbNzriVOYPUeBiWdrPfYUcMk+pVWYv0vZpJbFeByoQ@mail.gmail.com>
 <2820908b-4548-4e0a-94b2-6065cb5ff1f3@quicinc.com>
 <c2ec6b7c-421d-43c3-8c0a-de4f7bdd867c@oss.qualcomm.com>
 <a24ff510-2afd-4aa7-a026-199fb6d87287@quicinc.com>
 <CAO9ioeUDzYLMvqmsOQ-VfgLQLavHqn=QVYxyHzetjSfmhjKFjw@mail.gmail.com>
 <1a623099-40bb-4884-8d93-132138a4150b@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <1a623099-40bb-4884-8d93-132138a4150b@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA3NiBTYWx0ZWRfXyllNQK5D0SgJ uy+vBhNXMZkdmHD+9qUWocP1D4R2HAe7j+xn76uWfGcGhr0xWXZpsqm3XKaqG3L/wywkXnKm0c4 NRwYp9xTo8TAvgnqWTWV+zYVORzC8tXatk53X9g2KVZ36OYfnfEZDRMEnzzqmlN3+zTSKHki8kG
 T7Vbosb9pHV5qM6dzQnrpsRDAgMcTtWXrCEwOgVN5b2qZehl39U0D168BdDxGTEZoFFvSV/3UnJ 7LYxEO4efti2xaDlEY6/wB+T0mxPPujDGPWa1iI6fSBusoQ4MTOG8sqroWbxtFNqnsQu8BjkqnK /2d8f4oEJ791+Dd9fDZ8BmEwqKTu6Z+3x376FtHno06UaKkB0/empM6F8LVxsgI4ju27raK5EFx
 VM0qMZLKm4upSEY6IzX72BGwLr6FKmCVveYPtFBKHs2sLu6VKNCnOtNFpvXCjIkNf3wwqFlu
X-Proofpoint-GUID: TVzSCPME9iqxyp_ZrqL-KQ1fTHq1eo7q
X-Authority-Analysis: v=2.4 cv=B/S50PtM c=1 sm=1 tr=0 ts=6808ca69 cx=c_pps a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=iCsAco6G6QYzM88_SOEA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: TVzSCPME9iqxyp_ZrqL-KQ1fTHq1eo7q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_07,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 spamscore=0 clxscore=1015
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230076

On 4/16/25 2:26 PM, Nitin Rawat wrote:
> 
> 
> On 4/16/2025 5:43 PM, Dmitry Baryshkov wrote:
>> On Wed, 16 Apr 2025 at 12:08, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
>>>
>>>
>>>
>>> On 4/15/2025 2:59 PM, Dmitry Baryshkov wrote:
>>>> On 14/04/2025 23:34, Nitin Rawat wrote:
>>>>>
>>>>>
>>>>> On 4/11/2025 4:38 PM, Dmitry Baryshkov wrote:
>>>>>> On Fri, 11 Apr 2025 at 13:50, Nitin Rawat <quic_nitirawa@quicinc.com>
>>>>>> wrote:
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> On 4/11/2025 1:38 AM, Dmitry Baryshkov wrote:
>>>>>>>> On Thu, Apr 10, 2025 at 02:30:57PM +0530, Nitin Rawat wrote:
>>>>>>>>> Refactor the UFS PHY reset handling to parse the reset logic only
>>>>>>>>> once
>>>>>>>>> during probe, instead of every resume.
>>>>>>>>>
>>>>>>>>> Move the UFS PHY reset parsing logic from qmp_phy_power_on to
>>>>>>>>> qmp_ufs_probe to avoid unnecessary parsing during resume.
>>>>>>>>
>>>>>>>> How did you solve the circular dependency issue being noted below?
>>>>>>>
>>>>>>> Hi Dmitry,
>>>>>>> As part of my patch, I moved the parsing logic from qmp_phy_power_on to
>>>>>>> qmp_ufs_probe to avoid unnecessary parsing during resume. I'm uncertain
>>>>>>> about the circular dependency issue and whether if it still exists.
>>>>>>
>>>>>> It surely does. The reset controller is registered in the beginning of
>>>>>> ufs_qcom_init() and the PHY is acquired only a few lines below. It
>>>>>> creates a very small window for PHY driver to probe.
>>>>>> Which means, NAK, this patch doesn't look acceptable.
>>>>>
>>>>> Hi Dmitry,
>>>>>
>>>>> Thanks for pointing this out. I agree that it leaves very little time
>>>>> for the PHY to probe, which may cause issues with targets where
>>>>> no_pcs_sw_reset is set to true.
>>>>>
>>>>> As an experiment, I kept no_pcs_sw_reset set to true for the SM8750,
>>>>> and it caused bootup probe issues in some of the iterations I ran.
>>>>>
>>>>> To address this, I propose updating the patch to move the
>>>>> qmp_ufs_get_phy_reset call to phy_calibrate, just before the
>>>>> reset_control_assert call.
>>>>
>>>> Will it cause an issue if we move it to phy_init() instead of
>>>> phy_calibrate()?
>>>
>>> Hi Dmitry,
>>>
>>> Thanks for suggestion.
>>> Phy_init is invoked before phy_set_mode_ext and ufs_qcom_phy_power_on,
>>> whereas calibrate is called after ufs_qcom_phy_power_on. Keeping the UFS
>>> PHY reset in phy_calibrate introduces relatively more delay, providing
>>> more buffer time for the PHY driver probe, ensuring the UFS PHY reset is
>>> handled correctly the first time.
>>
>> We are requesting the PHY anyway, so the PHY driver should have probed
>> well before phy_init() call. I don't get this comment.
>>
>>>
>>> Moving the calibration to phy_init shouldn't cause any issues. However,
>>> since we currently don't have an initialization operations registered
>>> for init, we would need to add a new PHY initialization ops if we decide
>>> to move it to phy_init.
>>
>> Yes. I don't see it as a problem. Is there any kind of an issue there?
> 
> No issues. In my next patchset, I would add a new init ops registered for qcom phy and move get ufs phy reset handler to it.

I don't really like this circular dependency.

So I took a peek at the docs and IIUC, they say that the reset coming
from the UFS controller effectively does the same thing as QPHY_SW_RESET.

Moreover, the docs mention the controller-side reset should not be used
anymore (as of at least X1E & SM8550). Docs for MSM8996 (one of the
oldest platforms that this driver supports) also don't really mention a
hard dependency on it.

So we can get rid of this mess entirely, without affecting backwards
compatibility even, as this is all contained within the PHYs register
space and driver.

Konrad
