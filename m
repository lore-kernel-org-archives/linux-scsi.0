Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5DA2D9EE2
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 12:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769604105; cv=none; b=EHV7dyGsyEr524Bdwhb3Y7QSkbCrfGvmUt3+hA70x7h/idFAW4Bj36BPoXhYj88j3/jfNlDYJaYOU3Ou6y/iKq5+sQXvApunF4jdMstvs3atnc1cP8tDqV1C6mTlmM8e0X0uIwoFl4riL1gIHe3CotavMrMNtFzz5quwAwifSVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769604105; c=relaxed/simple;
	bh=uVuWuI37UTgDyI8yZay7prPi/q4tr+m3FAWWTbZuIhE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MutYB1fPOInmnMYW49LEn2NOLE1XRqo5orwMwpqVTzyvG31dTeE9wVYCIYQ5UkyQy8Db6J2iH1fWMpM9AUC45Nl59++SciI3kweTYUMZ+70chRnaedhSRKUCiEZOpFvmWJqS8VS3y6nKHRm0uJzwkiiD5u832K1Ah92kXzTBYDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=NW7Cn3fH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=arUvvdEt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="NW7Cn3fH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="arUvvdEt"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60S938Hw3247497
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 12:41:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	+kKO8dd5rQGlLu9l3bcEKgOh4c+qRDDxzTu2b7/j6A8=; b=NW7Cn3fHtWCkTfEv
	xUSO3e2o/hTeDByXBhngZsPvUM5NT5K1lToWt0WwmVUnbat22ryjdfyHioN/4Btm
	T3P+Z+x0Mwm/bCjg9Q69qsFrReKAf7cyOjELivzRdNMnLkOD4d6J7sX5Fuw5Gs4U
	0xGfeggc9pGR8ctaiUfmExTyn2nY31Mbrv3x0OUjeJx9NYrlWoxj29bfcy9dCLyj
	b6vVomE3dGHYK27i7czbZvbV9d4I8otkxm7SF8qUz2GJXUo3E5piuYGAK2R+7Icu
	pPq3B33p5nSY9jjQVWkqBYLQwR3lveCb7H8ernH1H7jCG9ypSqPEVAXRRB83ZZnf
	mQ63/Q==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bydfk16pf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 12:41:42 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8c533f07450so187108285a.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 04:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769604102; x=1770208902; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+kKO8dd5rQGlLu9l3bcEKgOh4c+qRDDxzTu2b7/j6A8=;
        b=arUvvdEtuRaa3hg3As0DBaIzeBeT8bYkOP2zggfZV21fHDPnsY6xBMDk+xkUASrQRB
         f5DeNtRkvsYn17wCJ6oXgrgpsEveDqSBsel0eEDFBvqylxk5PS0IQa4cd2UjKQTUgoQo
         vzKft7ww7knxzk8a61y/f+3o2+u3Zq2FSsOoD/8G/0jaOXBrX9Bd+XmyE+GJA+9Orr0t
         vo10VqT3H41yio5ROAWQi20Yft4WEoD7gSz3UYxYXj2PigIglMydS5XgoD8q9r38DQwv
         yC6z0fbqLC3uchUI1zYMNFoLeEERfDx5kL00STVOGybPzTYqBPcvD7Pqyo7Qy8ZphfcY
         lfdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769604102; x=1770208902;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+kKO8dd5rQGlLu9l3bcEKgOh4c+qRDDxzTu2b7/j6A8=;
        b=koYHSVcRzEUK9brl2u03JM/T/taBzvdXQhubWVjKEqskleLLlBjrL8kB6g7CMp6zjk
         Mt4E3BxWsyIcpxGegWfj/fWoc9TSNu5AN9XU+ZgWKUjB8nC+GxCHp332aYlrmZ1fzdg0
         ndBJQ6xgS257yVK9RULGHzVv0Ih+Gk7Y6KKe9vIoI1EyvcLydkTyhx1a7iySSjRHT1nS
         018ms7YOUyHdy/U5DTR08PjubQ+0yxC3sy7X/URnaryn49opVqCQTLhWVWMx3MwajPLy
         5g3CoQOnrN669A/9mhO61Me2txSHwmMQ+z80aDYvQNnI2c4fSVb50AtDVn/FZktcTQFU
         G0pw==
X-Forwarded-Encrypted: i=1; AJvYcCVPjOpPoslEC/JoQMKbyaXG8GOdxB5vgksqtUTELybh56lkRXfEVav4VegHtZOdnWxg43dUzBIw60SX@vger.kernel.org
X-Gm-Message-State: AOJu0YxXJOFlUeewFHLdidRV6BgNg2ZED18mqjiNIHwjXuXNhsLi/8GI
	y9IOWGmL2Xk9h2zrGWLvy7JPJwjVxITkpkQXtf8PFhUBLp4V84twe4vaFgXAvJlI9fp3BNFfv8R
	eUUskn48dnhKAgU4MyQSwi01/Do/ansjS3TOjQ2b0vbUrGc4MONIp3MqMCRIwVUd8
X-Gm-Gg: AZuq6aIPRuOoJ05UNA9IVDCuquM6HaSumIbb26wrJzisg+W39gKqiAVlBXxejPdLUcC
	tD5VwC4fHasydfviapjKy6Ro7qj6ssKebOnGOHAEmjAub5Gb4wUltodcfjv8+fu8ilnyr5jfinP
	IT/TobDHGUDpi9KZeWo6KDVosbm64amKHjc5WC8pMC4/R3qKmlSpPDJg20fdRExHReYxXpFUvtS
	6+ZgiUT0LAO4yiqOaIyDPWOPd9EEOozNGD8o6vm/gIhy+QFJIX1uomqhU3QmAmCu7yEw965IQyv
	bsZ3PhV89nSl2DZgEF9Dg4XMBC4o8UdW6PPDBLHdbSY+BD1g85ilU/KslXAVeLWCX1MUjEE+j6g
	RbIRns5OASBL5PwOj3og3YEl2BTQsDibBuJKqQLYLylggc38yruKAsYIdKeH7k73ixIo=
X-Received: by 2002:a05:620a:46a7:b0:8c7:110c:762f with SMTP id af79cd13be357-8c71ac75eb6mr279885a.4.1769604102189;
        Wed, 28 Jan 2026 04:41:42 -0800 (PST)
X-Received: by 2002:a05:620a:46a7:b0:8c7:110c:762f with SMTP id af79cd13be357-8c71ac75eb6mr276885a.4.1769604101707;
        Wed, 28 Jan 2026 04:41:41 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b469e6b2sm1438238a12.26.2026.01.28.04.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 04:41:41 -0800 (PST)
Message-ID: <795c4862-de48-44b4-9af9-6d9185a3c3ea@oss.qualcomm.com>
Date: Wed, 28 Jan 2026 13:41:36 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] arm64: dts: qcom: lemans: Add eDP ref clock for
 eDP PHYs
To: Ritesh Kumar <quic_riteshk@quicinc.com>, robin.clark@oss.qualcomm.com,
        lumag@kernel.org, abhinav.kumar@linux.dev, sean@poorly.run,
        marijn.suijten@somainline.org, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com,
        simona@ffwll.ch, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, quic_mahap@quicinc.com, andersson@kernel.org,
        konradybcio@kernel.org, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        vkoul@kernel.org, kishon@kernel.org,
        cros-qcom-dts-watchers@chromium.org
Cc: linux-phy@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, quic_vproddut@quicinc.com
References: <20260128114853.2543416-1-quic_riteshk@quicinc.com>
 <20260128114853.2543416-3-quic_riteshk@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260128114853.2543416-3-quic_riteshk@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDEwNCBTYWx0ZWRfX1J19fmJTzbW1
 D0Xv/8mmU5y+7ClNX1BMIvRZK+QTDOK2vKXqlCwQRQyLrC2J2+QzQOSD1JVIT3ZPT/TKk1rdHAU
 Kp4RsIP4HiCD4elTQJPpJPPxNd07gAanUn+2zt/AzhuYNOopkdAdlK68c0TG8aMvLvoi8+Ib1Lv
 IU2NKYNV8dmUiFigh1ZWD4pDlqJIOyUT4VCCLyZ3KXU2sOr+UGY67q8pPYxSnBueM6tQf1xuzgb
 ZtdazO5o9HNOWqKv3P00r2cCHWhB8e/jFGi9TvNmaL8ntxvWgthHYSGzoLbtQU5RacAREBalV8M
 ayj5nDtazrPHlYiWe0N1O8dN9XoyMYeTKbPm71mqV/wBPGFjWwCMrO1VVz0pRwX2slpoKvVKV0J
 fxPJDn5XeuJMwV3wBgmL5eLbV6agMcJTvZELG5kU/tb/ivy4fNxoHjWCNPZjEfkeFai0vegsbpL
 ft6iAOzCX84XdXR7veQ==
X-Authority-Analysis: v=2.4 cv=XfWEDY55 c=1 sm=1 tr=0 ts=697a0406 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8
 a=3Q2R1SHny_ty92h1eiYA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: l0H5clUKLrzD3gr4SQuMGIGG88DuIolG
X-Proofpoint-ORIG-GUID: l0H5clUKLrzD3gr4SQuMGIGG88DuIolG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-28_02,2026-01-28_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2601280104

On 1/28/26 12:48 PM, Ritesh Kumar wrote:
> The eDP PHY nodes on lemans were missing the reference clock voting.
> This initially went unnoticed because the clock was implicitly enabled
> by the UFS PHY driver, and the eDP PHY happened to rely on that.
> 
> After commit 77d2fa54a945 ("scsi: ufs: qcom : Refactor phy_power_on/off
> calls"), the UFS driver no longer keeps the reference clock enabled.
> As a result, the eDP PHY fails to power on.
> 
> To fix this, add eDP reference clock for eDP PHYs on lemans chipset
> ensuring reference clock is enabled.
> 
> Fixes: e1e3e5673f8d7 ("arm64: dts: qcom: sa8775p: add DisplayPort device nodes")
> Signed-off-by: Ritesh Kumar <quic_riteshk@quicinc.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
