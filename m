Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DF3267AF8
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 11:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745407325; cv=none; b=pqxQUCOl0tJnZ/IIlqlZM+/zCCWuRR5xbxomALQm5AQzom3amp9X4R563Db+SyTzXFB3A+18kzkh6uvFosduGJ57UrhK/SmGnjWroAxu9XOndRQ7SaDX87sVxHJio42vGQt3OK4abSVY9yEOSH9em+r917so8LAl9zAZp+R9q4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745407325; c=relaxed/simple;
	bh=A6Nv64R4J37upv3XPP09SN6JfR2CajcENYQ5shp7dVU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=L3Kro9uvld4jsf/D4O+1L34OTNM1Yw0Y22crow43TEHem8hkoiTD1EqJ/IzDnjSdf4HhMpiKJJQVu60OdPwQXcTd76Q/V+QCwtvcBbLbB30ES0kUnMPJles5UH8ngkXQVBO8jwJckDTfzzEpBm0F5sgYgoGNhTIZQhjgKplW95o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VmR7sYdt; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VmR7sYdt"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NB3hOs013403
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 11:22:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MBmXqa3SqlfHGu6HskzaGqDayNYdwR8418JrZVuGd1Q=; b=VmR7sYdtNY9sPQrD
	o5/hBpQ3whiCmYDAGqlFyXL1PZ37epsHRQd2ARf0znrzHPXJk7xmpsJ9BwYR3Lgp
	PC+guBZ2pr+XfmVry6HiEcJ96Si35YlSCdwGFjAlsx0fLNJivjAD3D9sEncByEF0
	JYYINkRFRbuUFTJTW4dGr/neApAfZOGURdzbHuQssG2hCDUVZ2n8kULLROX7Sdw+
	ILPUEJqxf7byQyGHIJOvMPB2lmUuGTW1NCrL+C41KSlwkKlyLEguh19Uj9LgoYCA
	Eq0xo0aLnfKdx0AUK+YXlkDI4vHQ9XkaPDu98C7sv0OMh8FO32ERhAL7KtxcXM3K
	PNbw0Q==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh39wmx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 11:22:02 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c552802e9fso119879385a.0
        for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 04:22:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745407321; x=1746012121;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBmXqa3SqlfHGu6HskzaGqDayNYdwR8418JrZVuGd1Q=;
        b=YJ/b4dwOq6j/L8/eclX0r3CbHotyszq2s/gSeJ5HmFz7/KdA3YckcCgoMHEGgmu9Tr
         EMz2kPVOTtRpm0sbPf2OrUUxSA6kER8JS4roDEKxajRR3r3cf25tZ/2Cw6dUeOVqWuYD
         0LUze/FqhKLfFIDBfAFXphJKo3Y2sS7L8bndqhfqTKMRVCf3zgDAgjeEoFtTTeGrWR40
         MuiUWVz/TeoH31vsFKHJYRzCfug84LjSBloefnvlKXsXnDzM723uQP5Kn9EB+QnRmWq4
         Z4IgfTxoW5gn1ls+XBzViwX7W8I3+yRmmTlELsa9wgVg/JoHr+ppLh3QPfARQvkg0bKU
         bXWw==
X-Forwarded-Encrypted: i=1; AJvYcCVbSo3TD52qea8qGZRbe1qfAZ+0tWPi995ES/yFl/TLQmbUfxFemtyXPFlJMLTU2HB4ht+kd/Kf1xWU@vger.kernel.org
X-Gm-Message-State: AOJu0YxgDTtIZdqh16V/UTZmNT0lpmhTwBcSCeabNlrblXgEBm6K4GIS
	F7ZULtQFLW5MIK3q7UgDA6NwfVPoDcgYQyOx4bFWyCN/A47u67e7W5i7ugolUipzkK06UTO8d+V
	c2RCu0TAVkLRHt8GJGoRYlKvQBiEhdjNKQD4Lywz2lPhYsxqTxBkLLM/vyk/B
X-Gm-Gg: ASbGncvgontlElYThgFPCr7Rf2zSToL+hL5JuOGieKcYJRk7XGiLcLn70gHj1OXEGff
	VmZfKeMPeYtEQwDRZuHFrAuas2uv7NMKGMUwyEz22uWay2RKgyBkSKwLIN/xXE3VclTNVKyiw/K
	4XgIpNL89BSHD/O1f+qefW4b/RFtBL+AQ6IHH0uxGHocnUwsZGHH2qG2UI5wsmU152xPTFg0l3K
	0eJdt4eBDsHGuaK2cOQmSapMQoMBQWdU9lrNpB/PItvHWQLFvC702wPZdmf/S3PF6ospUejmzhc
	rFMav2ow4Wq0EkOQVcfqeKohOdHTafXfvsWp3KnQLatjaXD5njw/8aSPy9CsETQQlSg=
X-Received: by 2002:a05:620a:17a1:b0:7c5:8f37:5eb8 with SMTP id af79cd13be357-7c94d2cdeb6mr159763685a.12.1745407320910;
        Wed, 23 Apr 2025 04:22:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmyvrF5d9qIzFP/diTkGdauGMkGsqby79Vk6CQ3T9WYIeciMXk/85jv8urHP/tvgBFaRm55w==
X-Received: by 2002:a05:620a:17a1:b0:7c5:8f37:5eb8 with SMTP id af79cd13be357-7c94d2cdeb6mr159761585a.12.1745407320483;
        Wed, 23 Apr 2025 04:22:00 -0700 (PDT)
Received: from [192.168.65.183] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f6258342e5sm7324599a12.60.2025.04.23.04.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 04:22:00 -0700 (PDT)
Message-ID: <7a0eb7bf-d6d9-4e8e-829b-2df726651725@oss.qualcomm.com>
Date: Wed, 23 Apr 2025 13:21:57 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 4/9] phy: qcom-qmp-ufs: Refactor UFS PHY reset
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
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
 <b7027077-e9a3-462b-92a8-684a42d23604@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <b7027077-e9a3-462b-92a8-684a42d23604@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDIzMDA3OCBTYWx0ZWRfX8rqqtNXXZLXa oiqmQP51yGlLakaZaztvIeh/auRHApGwHYZM1nh4Tky3zU0nzYIlXf0GtcDSyGzqfXJCRldaioI kFVTqdlfo0z0RaJxZ5TW0tRFwUd841dIETkAN2YjzQBsdCxmbseO+DDOZpPV7eFeBtn0Q2NtEUu
 tDVgkE0ENXdPHhStI9QoIZGk2CqwiIBHARCJjpdplWE7/YXRDOzmSdoJ5l4dzeKbpGvk4G8UHhh I6Eb+nFgyIjWedCKuscxIIX/4Sg2ynLtpBl8WHSf1SH93iZrCfu9n+rWrN3nLPucrVyqdqiUk5P vApS04K921lushQvqevX354p0tt+1D2epyCVEJKojdXr97iHq5AvDPhpqDv8nXVTqlUkcJykVfB
 EobH68DU7XOtKkkW9UFFMUSsd9afT0vsbS4kqkQM7UxqxbifG3wwGb7WgVnFYJQbUcjCjPgU
X-Authority-Analysis: v=2.4 cv=bs1MBFai c=1 sm=1 tr=0 ts=6808cd5b cx=c_pps a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=COk6AnOGAAAA:8 a=S3RF1rwLzzbCZMsKAAoA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: J7Zi0LDc_5-e_xXASCsF6Nv_q1B3Bq56
X-Proofpoint-GUID: J7Zi0LDc_5-e_xXASCsF6Nv_q1B3Bq56
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-23_07,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504230078

On 4/23/25 1:09 PM, Konrad Dybcio wrote:
> On 4/16/25 2:26 PM, Nitin Rawat wrote:
>>
>>
>> On 4/16/2025 5:43 PM, Dmitry Baryshkov wrote:
>>> On Wed, 16 Apr 2025 at 12:08, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
>>>>
>>>>
>>>>
>>>> On 4/15/2025 2:59 PM, Dmitry Baryshkov wrote:
>>>>> On 14/04/2025 23:34, Nitin Rawat wrote:
>>>>>>
>>>>>>
>>>>>> On 4/11/2025 4:38 PM, Dmitry Baryshkov wrote:
>>>>>>> On Fri, 11 Apr 2025 at 13:50, Nitin Rawat <quic_nitirawa@quicinc.com>
>>>>>>> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On 4/11/2025 1:38 AM, Dmitry Baryshkov wrote:
>>>>>>>>> On Thu, Apr 10, 2025 at 02:30:57PM +0530, Nitin Rawat wrote:
>>>>>>>>>> Refactor the UFS PHY reset handling to parse the reset logic only
>>>>>>>>>> once
>>>>>>>>>> during probe, instead of every resume.
>>>>>>>>>>
>>>>>>>>>> Move the UFS PHY reset parsing logic from qmp_phy_power_on to
>>>>>>>>>> qmp_ufs_probe to avoid unnecessary parsing during resume.
>>>>>>>>>
>>>>>>>>> How did you solve the circular dependency issue being noted below?
>>>>>>>>
>>>>>>>> Hi Dmitry,
>>>>>>>> As part of my patch, I moved the parsing logic from qmp_phy_power_on to
>>>>>>>> qmp_ufs_probe to avoid unnecessary parsing during resume. I'm uncertain
>>>>>>>> about the circular dependency issue and whether if it still exists.
>>>>>>>
>>>>>>> It surely does. The reset controller is registered in the beginning of
>>>>>>> ufs_qcom_init() and the PHY is acquired only a few lines below. It
>>>>>>> creates a very small window for PHY driver to probe.
>>>>>>> Which means, NAK, this patch doesn't look acceptable.
>>>>>>
>>>>>> Hi Dmitry,
>>>>>>
>>>>>> Thanks for pointing this out. I agree that it leaves very little time
>>>>>> for the PHY to probe, which may cause issues with targets where
>>>>>> no_pcs_sw_reset is set to true.
>>>>>>
>>>>>> As an experiment, I kept no_pcs_sw_reset set to true for the SM8750,
>>>>>> and it caused bootup probe issues in some of the iterations I ran.
>>>>>>
>>>>>> To address this, I propose updating the patch to move the
>>>>>> qmp_ufs_get_phy_reset call to phy_calibrate, just before the
>>>>>> reset_control_assert call.
>>>>>
>>>>> Will it cause an issue if we move it to phy_init() instead of
>>>>> phy_calibrate()?
>>>>
>>>> Hi Dmitry,
>>>>
>>>> Thanks for suggestion.
>>>> Phy_init is invoked before phy_set_mode_ext and ufs_qcom_phy_power_on,
>>>> whereas calibrate is called after ufs_qcom_phy_power_on. Keeping the UFS
>>>> PHY reset in phy_calibrate introduces relatively more delay, providing
>>>> more buffer time for the PHY driver probe, ensuring the UFS PHY reset is
>>>> handled correctly the first time.
>>>
>>> We are requesting the PHY anyway, so the PHY driver should have probed
>>> well before phy_init() call. I don't get this comment.
>>>
>>>>
>>>> Moving the calibration to phy_init shouldn't cause any issues. However,
>>>> since we currently don't have an initialization operations registered
>>>> for init, we would need to add a new PHY initialization ops if we decide
>>>> to move it to phy_init.
>>>
>>> Yes. I don't see it as a problem. Is there any kind of an issue there?
>>
>> No issues. In my next patchset, I would add a new init ops registered for qcom phy and move get ufs phy reset handler to it.
> 
> I don't really like this circular dependency.
> 
> So I took a peek at the docs and IIUC, they say that the reset coming
> from the UFS controller effectively does the same thing as QPHY_SW_RESET.
> 
> Moreover, the docs mention the controller-side reset should not be used
> anymore (as of at least X1E & SM8550). Docs for MSM8996 (one of the
> oldest platforms that this driver supports) also don't really mention a
> hard dependency on it.
> 
> So we can get rid of this mess entirely, without affecting backwards
> compatibility even, as this is all contained within the PHYs register
> space and driver.

Well hmm, certain platforms (with no_pcs_sw_reset) don't agree.. some
have GCC-sourced resets, but I'm not 100% sure how they affect the CSR
state

Konrad
