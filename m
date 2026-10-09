Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA7C4A43F6
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 10:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791541749; cv=none; b=Bhvd5aMTNWGl+NZ2W8R8rtkiOjuM0YLSV9VfKaKVpn27oIg1lOQ8diHrOdm3AxkIGa6vba2+kBZZvb0d2ZxalJbiaWFzrOdHaQ+NVh9PEhX0AxubrhkgK+YeFW1LTjix6dKqDttKYtSyvo9+lG+39pDEXELi2D7f+EzLIW/MG84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791541749; c=relaxed/simple;
	bh=vUPMn3bxeRFEJEdZP1B+BUuNV5tvMVQg8taiABn2YJk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j9jNCITwlWLXg4JLaB848DyGma0c/+fV2AWfiGz3HgU0uVF7ycws0ZMVCpQeHteGEBFc//dBdkQGV4xhMqitNk/gNP6zILFiAEVzZzCeoHVPbkX1mwqgyVVKH7mNSJpKR1HUKPYdl7Hh05mci1TogQ1uLfGbtCcUOtlDH/mKs9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ekIO43Xu; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bhGmAKAd; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ekIO43Xu";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bhGmAKAd"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6998KOVx3977816
	for <linux-scsi@vger.kernel.org>; Fri, 9 Oct 2026 10:29:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HyC5W/PoIqu6z550EClqx3QgxQlgKjeDqKv8+Dt31DE=; b=ekIO43Xu9VoJb1q0
	nMjWZ7vnjEKk6cnOJ8GBh37vu/nVLK9/maUlsUXgPxzn4Oswkg9jqlcNiZ1pF2Qx
	fAo1MXm4NyMMNnTA+BBf62GZOQyykkn0ScspVTFckGMJmkpc9m9zDhFQ0Hj+JW2B
	utt21eeJ7aF3rq17tEUqcWDAmHaPYF5Ofl+aXa1vJ+9S47nVRHxZm8mxsGburaKz
	LLpAdCsYkGlVphpzoIqf94WQ9t18GzWqU0wrTR4XXgrDtMqOyrzfps0JPykBjtG9
	R9TwECnI7c4PsxSiKq/Guwa/6pz6fPyAMyHJnWyYP6GnBelddoccs1IHR4K/20rx
	lLnmrw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h6ev5bcvn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 10:29:04 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3510d0baf63so13355561eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 09 Oct 2026 03:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791541744; x=1792146544; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HyC5W/PoIqu6z550EClqx3QgxQlgKjeDqKv8+Dt31DE=;
        b=bhGmAKAdahxwTGV1UOWhfHOg4UQlnp7xsxyg5TJ2vzEbS5e6mKdC9F5sb+H0fowdzo
         2NBsrDAx8yt/Dotb96a5blkNWUJR91xR0BMB4IdEAN3WJ+xDHpmq61ZTxpJBASxELNhx
         Ufoe/Fx/wNW2sGzuuBgsYtd1qvZqkfacMxZIGkj6Lvi8RVDyUSIDSnhdiFgy6bo0Qcdt
         LPnHnhedq6eiQqdUsq+9igHlut3WzTbfEuCjb4rWytpmf8nf2hzSV/vVmCEDk7XFEgZs
         Sb2oJuDPGZ6xHmAYaFEofOMCfASwb2I3cMKAvfzQc/QDxCgOxbKBqO8nDT6iQt42jYm1
         1MLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791541744; x=1792146544;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HyC5W/PoIqu6z550EClqx3QgxQlgKjeDqKv8+Dt31DE=;
        b=sm7/TR2e1So1AmAsT+H9vnh2J1LnfcWpkLEq+QAcpfqXUuWQCF1vhk4KR6hoEfSPta
         ySM61mrZM0SsLCRByUnyverk1ithEk3y3ulR6Qu8oQeJ5cIgq8fvZ7FVgAnFkWAJeTNm
         /APJrzdvbjHESyPwV1A9RNWOOfmoKkJZGANCdocA8ymm8+227+DIPh37qpzDmaxtZEdW
         zgrWGSiZ+uPA+zrz7T9jvM7rnTZxbwsO9lSLiCnujQ93GEZNHULVPxqwIBpN0428MW5C
         TNVdfCFs/KN9ssmojAt3nyuej+y7N0Usz8g0TrW98YB3EU3rgCsp6rY/0M8sOS8JE0/4
         Zafw==
X-Forwarded-Encrypted: i=1; AKwUvBxVL/IHwIhl5vCcHbHKklNpjQh2Il/YwG7rqKquOUWx2JadihwbCyH7meHDzRLBFI9v8K7lDs6RJDVe@vger.kernel.org
X-Gm-Message-State: AFuF++lcAq0TAdxDpChJE5/87JUjv43EgDBOWNOn3B+JmUnNVQH2HDL6
	EHn9jq18LZctWbMueAFZG9tXD3HnNlJKd0g/pcRRjzsAhqBoW+CVFQgfS68H4CJ8mRqQyxRevMD
	goUn2Ft4KF3KGD9Q73qem1EJiAVitgEI5zid5O4lnzwLaOnBwx03gzR8Wd7vcLVdI
X-Gm-Gg: AYBFou39ZHsq/vEeCLQwXLnJAZRcSyt7zrFct03QOLLpXIZEvKQhs9r5aDy0xrTHGMM
	1jZW+q1W536I9VHi4d/dzondBzqo96qOOPh2bNH0bFwMziJ7kuq5PZBI8jIFW9rn/LvjjAtdTkJ
	r7IpR2Q6+1tGwek7tC3EhDsDY31k26wBftwA/ZOHVqxmhNRWU2LFM3Cg0n0xul4JhNLH6eODKP7
	zSd3ubd+RbQ+OMmtvM8wApFGmwbNFn/BCBQQkjiKSnVuJuQ5EgWkGjYenZRLN8upjvT+W/3C6ii
	bQUA4KwkHui/k7k12CsPBYVoVbCk8QiiXEsgJefPDthLFyPNOvP3Sz/cbaeZ4q0CDAmyuRVAIH1
	Yr+N2ukv3lscqKLIaXujQfHdwRRwe7mrr7kE3j8M1Og==
X-Received: by 2002:a05:7301:c015:b0:355:b9a5:c9c0 with SMTP id 5a478bee46e88-355b9a5ca6amr298338eec.1.1791541744071;
        Fri, 09 Oct 2026 03:29:04 -0700 (PDT)
X-Received: by 2002:a05:7301:c015:b0:355:b9a5:c9c0 with SMTP id 5a478bee46e88-355b9a5ca6amr298305eec.1.1791541743570;
        Fri, 09 Oct 2026 03:29:03 -0700 (PDT)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cacb61asm6406058eec.21.2026.10.09.03.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 03:29:02 -0700 (PDT)
Message-ID: <b46051e5-6ae5-4e3f-8cab-4f7199b9e880@oss.qualcomm.com>
Date: Fri, 9 Oct 2026 15:58:54 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] scsi: ufs: qcom: dt-bindings: Document Glymur UFS
 controller
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Vinod Koul <vkoul@kernel.org>, Neil Armstrong
 <neil.armstrong@linaro.org>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        gopikrishna.garmidi@oss.qualcomm.com, jagadeesh.kona@oss.qualcomm.com,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        nitin.rawat@oss.qualcomm.com, sibi.sankar@oss.qualcomm.com,
        Taniya Das <taniya.das@oss.qualcomm.com>,
        "Martin K. Petersen" <mkp@kernel.org>
References: <20261007-glymur_ufs_qcb_enablement-v3-0-84cf4f861415@oss.qualcomm.com>
 <20261007-glymur_ufs_qcb_enablement-v3-2-84cf4f861415@oss.qualcomm.com>
 <c2b6taguiyyeteizf5ohdsvmeyaybbs5pm5cuv5vqkklswmxv5@5ekurkmzdhjt>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <c2b6taguiyyeteizf5ohdsvmeyaybbs5pm5cuv5vqkklswmxv5@5ekurkmzdhjt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA5MDA0MSBTYWx0ZWRfX9WbCFXZUgGio
 tOb21ZMSLIlfCkN4SKZg0TIhdOLluAbdU8be8jF6mkAo+Vzv4Dnubuk0SrG7Q3JmFRJCbAizltg
 Ffd6cRwteVwaBVtzQ8j/Ak3Qsc1JUJc=
X-Authority-Analysis: v=2.4 cv=MMT1C8Zl c=1 sm=1 tr=0 ts=6ac8c1f0 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=_qIwb01vgd_s3mhA8LgA:9 a=QEXdDO2ut3YA:10
 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-GUID: lHicJQWmNeyxpYq9rJyKFPUCiR9T7uJ9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA5MDA0MSBTYWx0ZWRfX2uwkQFF1+7fH
 zViD1XmNutjvuLgkl0eN70t0flacgsTMaWTsR+98Dy8kCfmZMnioiqg62us0IMMg7fj4W7Q626R
 4Wk6tnycOwGkLDUTNhxMJ+elD2pFIPEBvDPzxrGWAf2sDM1N5RTNu9+wBNJpPF0TYXPv0xcdzl2
 xMCGojkyPVwPtNppRzMZ9eql28K/7ba+IHhtrABc7mlssNNzIA/zsfmW7h9YrX2UQUkIud+WSlB
 z6YgDyOvyJ4DH74+EhORERffnqIKOZFL+qpcRRgoiLkPFe1wSkTmkKPP0h1mNUKrHzgjwiTi0vj
 IkqvcIB8yKp6BjxNoTI+0vAGwY+vk/WqFdxBk/An+JOUeFhx80jMwAqMujMdS4gnRyp5A6nYw6I
 jGaCyvafBeC/m66ojEuZ1q5zHE4wvz5+qkvaBO1eEH7FJTuxxRKGxg/A0t30R5AYEbqzWlcOVnR
 B5xpzUppVIoIQeh4aIA==
X-Proofpoint-ORIG-GUID: lHicJQWmNeyxpYq9rJyKFPUCiR9T7uJ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-09_03,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610020000 definitions=main-2610090041



On 10/7/2026 8:54 PM, Manivannan Sadhasivam wrote:
> On Wed, Oct 07, 2026 at 11:59:35AM +0530, Pradeep P V K wrote:
>> Document UFS Host Controller on Glymur SoC. Glymur UFSHC has a
>> multi-queue command (MCQ) register range in addition to the standard
>> one. So, both reg entries are required.
>>
>> Acked-by: Martin K. Petersen <mkp@kernel.org>
> 
> This was a mistake. You clubbed both UFS controller and PHY patches in a single
> series and the UFS maintainer ended up acking the patch assuming dependency
> instead of merging the patch.
> 
> Please send the PHY and controller patches separately.
> 
> - Mani
> 

Since all patches in the series have now received Reviewed-by and Acked-by tags and have dependencies on each other, 
splitting the series at this stage would require waiting for the bindings to be merged before the SoC and board DTSI
changes can be picked up. The series has been rebased on top of linux-next, so I do not expect any merge conflicts 
while picking up the patches. I will take care of splitting such dependent changes appropriately in future submissions.


