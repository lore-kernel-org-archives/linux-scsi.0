Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72093340DAD
	for <linux-scsi@vger.kernel.org>; Tue,  6 Jan 2026 13:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767707527; cv=none; b=VsBxyNVJMgwViHrjKAPh62Th4v9T3IyqrzAoFF2WUMatslkEk+3f4cSvsV1tkx7U77EkDiUcqjV1+B+U19DL4+HSCMr0/QAawTi7IXBbZykrvOI1CFEulPQ4UeDReYYU1A+iyHp13QMLsDaHAv2x4bb4vUIF8jSCCivnn56F2p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767707527; c=relaxed/simple;
	bh=OBoZUtYp1pyvsSPWyYMJDxR3CK71tt6pz+QXMpdi1lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GKrR51rAh5Cb1PTG2K2+04JsxoS26RBK93gHwlnMeWN0IzPbgLIBZZwn3s5inzvbneFad/4RIBN+Tnt/RWxZuQxULkt8NcGuAP+YTGdXZ7d8srq4SOY3n9GIsBtCEfA7CzVGE8xH1e1ZWGeb3zxQeNPG95Fdb402VWUemFZMgLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B6YcFU3O; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=KF68GIF+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B6YcFU3O";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="KF68GIF+"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606AchXP3272123
	for <linux-scsi@vger.kernel.org>; Tue, 6 Jan 2026 13:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	u6lF3KhAVrhZgm1oiHIcVh0zoeDhAavjS6Fgzafm+Xw=; b=B6YcFU3OIMcttdE4
	Zsm2Om0w/Wv7q9EPBwS2Txfli2t/fjziQUoisF+UEBH45BkDyATac99tVfF82TU5
	Xt81hl06HSijzdnCbgv+/iO95m1ZXexbFBlLlY7/hdwjJLttkeekEeucywGLGndA
	cr3kv2PTA3HiZndoW6dN3ERlarU2ryL51ZADdU0GwY2plmLviACTUraolXSvmeGP
	ToOESv7W3QqPF8DfwgErU1eS4T269JfRizr3KkfyeUmar4sktexTeqB7Y6oe4wbP
	f0etdRnLLksQhKzqY+t7s5wLaOYqc0CSltczgni0PLFe/9Jj9tj15SuHlHWyJVyl
	CZ1IFA==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bgfv03fnw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 13:52:04 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-7b8a12f0cb4so1199890b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jan 2026 05:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767707524; x=1768312324; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u6lF3KhAVrhZgm1oiHIcVh0zoeDhAavjS6Fgzafm+Xw=;
        b=KF68GIF+qsqCW/RNcQQ0TWQk5dY2uJZgYWMjdUsg8Ru1OhIPhr+5A+sz6LQeLDyRAs
         ZCZjR0yB+UoJSL+w3gr/o2bwGl4CVQSdEmbM9tbDG1yl1jVgcGBIYeK92wHRe9QaaPRD
         TN6UJPGrxKqE6MfvBYI7GjE5kuIW5xSN56g7ZkLZlBStm//HAR1CHdeXE6b885WVwoU8
         Yaz/k4Nr+aU9kj+kSMdwutIZ6+R918rw/BLd//LFjSeKctf2y9v/aQ8KVDjkhQ66QvpY
         R4khLpGdM4tDAeyBFvKA8w2Dne5ngUEI5WPKFNF1WxGtMwUh+3XAKBMwBXOC1bBrUdXC
         IAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767707524; x=1768312324;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u6lF3KhAVrhZgm1oiHIcVh0zoeDhAavjS6Fgzafm+Xw=;
        b=tLp7fbAy0m1T5mtQ8nTSfE34pKPBhZeS+gyD8CgzkT3MoVMLcWEn0VzxbS2qfOSJ85
         iZCzVqucQFNS09CG+coDvIZZQlxGAebcwkFqYjqCYnIkc2uEk8IxQo8sBai0+zRlAUnh
         2RYsqPblFQQQ+8WWJf8qrZcfwA/pdHHQMIHZeKLm32mM1guMqbtzvF71Vap/6mjdeMng
         5gaCS1r2M7f9QHQZ/u9KB6ANdy1qchCBrGpZllLwbsjvK0hQDK9wMoWMgoYp05dr4bcc
         QwcRrIPTBgsoNdvXm/icH7mTz5e+IXUYfrqJuRzSuYmwcuQC0LIUpEn33nuI35O4hAAa
         yMyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNc2MxniqEw0bQxf6+gU1PuciQoEckYkz3f6332mLZo6hw4knefwr/0AMVr8hdUd5j4eerrYYASc8p@vger.kernel.org
X-Gm-Message-State: AOJu0Ywf9zwFr5wyQW7VRUyiuMVnOd0zk9B2N7mO++C/2/7fTipx+wyc
	hNAWUrN8Hz3Dts1e3yRhIT7xOssIn5XtCHyPEwjRB3QayWjL+OzKPA+r6ErwYMasCbcK1RPITok
	n1wN0jaHehj+UylbavCjlepWnkbA94CA9xpPkMZ4iCzDgP7dzWSB9udwkyys5coO4
X-Gm-Gg: AY/fxX6zNKzYpZI1LX/K8wT08R8uLoCwEi0M9G6PWjWmxSWPkkxTkNthZA/8k2ja2ER
	ol/qsmVUYaJ1zmT+3ESOYuI1aDLuDYvMelp/A4g7U2q/GxN/XcL1X98T/xjs0X0tdRGdAgaqZzI
	+R5Z2fMeywMa42N5iBf41NkwwgPgPQgnnAKwFwdg1Xl288He02dxN1BtkOoVpGOIG4+uqUCUrEX
	x10wX+biWUSqTJnf/euXsnB6aduqndMx0jW81wS4eDIy7kzDef4kmJEGtp1j43yJKRPvGEVwZzw
	7+r67jlPAUiO6wSXvxJzUmFbK6DlRP3ZNN2QtV4yPFy5pD47DdkNKLTzgRnioKYJhChGandkIVU
	Gky6g9iXY3t6uVN9KrO2FkTPKPSu5MrprrsuDsogcjclkMiK+zVs=
X-Received: by 2002:aa7:9a82:0:b0:7aa:8397:7754 with SMTP id d2e1a72fcca58-8187d7eaf10mr2504087b3a.2.1767707523951;
        Tue, 06 Jan 2026 05:52:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1PLCYM3yMbIJ7mWUGjJVx1eRKVE/ZWrl57XGXEdDOj75CPBnr3pvZOxSj+KPyMyLNKexWFA==
X-Received: by 2002:aa7:9a82:0:b0:7aa:8397:7754 with SMTP id d2e1a72fcca58-8187d7eaf10mr2504049b3a.2.1767707523422;
        Tue, 06 Jan 2026 05:52:03 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c5de6405sm2343404b3a.61.2026.01.06.05.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 05:52:03 -0800 (PST)
Message-ID: <362fd6bd-c7a8-4c2f-8a7a-26c867848162@oss.qualcomm.com>
Date: Tue, 6 Jan 2026 19:21:55 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 3/4] arm64: dts: qcom: hamoa: Add UFS nodes for
 x1e80100 SoC
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: vkoul@kernel.org, neil.armstrong@linaro.org, robh@kernel.org,
        krzk+dt@kernel.org, conor+dt@kernel.org, martin.petersen@oracle.com,
        andersson@kernel.org, konradybcio@kernel.org,
        taniya.das@oss.qualcomm.com, dmitry.baryshkov@oss.qualcomm.com,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Konrad Dybcio
 <konrad.dybcio@oss.qualcomm.com>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>
References: <20260105144643.669344-1-pradeep.pragallapati@oss.qualcomm.com>
 <20260105144643.669344-4-pradeep.pragallapati@oss.qualcomm.com>
 <7gi7sh5psh5v4y5mrbgln6j2cjeu5mogdw2n3a6znjtqyjcyuk@kxpe566v57p3>
 <e396bef2-e5bf-4e6d-98f4-37977d5d93ec@oss.qualcomm.com>
 <67fd0c34-0ea4-461c-8586-4eaca678ccb3@kernel.org>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <67fd0c34-0ea4-461c-8586-4eaca678ccb3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=e9YLiKp/ c=1 sm=1 tr=0 ts=695d1384 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=4L7KDLdBDqiEQCf4QIgA:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-GUID: oXUoE8mk5MxAt9pym00lcWuG8oS8tRAP
X-Proofpoint-ORIG-GUID: oXUoE8mk5MxAt9pym00lcWuG8oS8tRAP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEyMSBTYWx0ZWRfXxVVUrt3Ml4Zb
 B5+ybNtX265QokeHETgvujoEIkihWdz4uEc/bRyCE9k5Ks615VBQEGZMQexv7CCiaHWQApuENqo
 QmtLI7YR2jpSX8ajwJRzWTg0A31e81OU6Xwmkaphd8IWbYLyfndMtA0I4B7O/vdzl8ftdkD1bc3
 KwfHpiSGgkMlTNAuFc3Wabdh056lvhsiVKNinrGrAa5v5HDMz7gTUA4muyV+EIHxh08R0+19586
 3fkDo3KwrrD66m5Y7m+fPH5OxGwixw18BnEsHMFD5Zn40ts40Ms6e/TnR2x5uus7/xqoFw3aX5B
 OP9/tscWVzKyYchxa5HmJtRvqoXbi8gmXLuzwBwMNu7f1WJyh7XP4CH4ctog3VbgR6U93rxKbaQ
 tgz5aULcRwp7A/fXRAs2xyaMgrrglTuYSzWM6BS57I6/rMYaT60itsD3AFlwS+l0yPwybBMFMEj
 XLo9OWeOnmRDWNGZdfA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601060121



On 1/6/2026 7:10 PM, Krzysztof Kozlowski wrote:
> On 06/01/2026 14:00, Pradeep Pragallapati wrote:
>>>
>>>> +			compatible = "qcom,x1e80100-ufshc",
>>>> +				     "qcom,sm8550-ufshc",
>>>> +				     "qcom,ufshc",
>>>> +				     "jedec,ufs-2.0";
>>>
>>> Drop jedec compatible as Qcom UFS controller cannot fallback to generic ufshc
>>> driver.
>> "jedec,ufs-2.0" was set to const in dt-bindings, dropping now will lead
>> to dtbs_check failures. is it ok, if i continue with it ?
> 
> No, it is not ok. You cannot have errors/warnings and I think it is
> obvious that you need to fix everything, not only DTS.
sure, i will update in my next patchset.
> 
> Best regards,
> Krzysztof

