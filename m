Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E8533F8AD
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 09:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770715970; cv=none; b=nXx6t+HQR58KoM40gRKe9dmBFiXrdVtLP4BKepKH6KJa1JwdAHH2OiwVUtmnDBaM/D38ieH2rTUafRAwU0ShTIdRShjM5Ye/IfxOieXe7XwmVIos0g0uT9F7Dh4O7DuA0uIxVHcPWdiRNKtVYS//ixEdcur64K++y+ONrnnnK+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770715970; c=relaxed/simple;
	bh=lYXkrcgF/gfCqHIjWikYj3wuxE8pK3C+vUdP+nhK84M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OTgh4xpQ+rEkT3gjbUJyxS8xq2n46SiZG8whTYdefmd3UmCpdc0eq9hTCCJYYHMvssqrQ1x4xcV8CuijK3nC30xymuV1Oq4XpI8UY9tFoQqEIoVwde0t/hRj8Ct62pURzlF38TGvBCyvcTNqqCrIEQtVZm3t0hpxFzQlNIf7Pzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gyN0gdRF; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=YdEpLmsA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="gyN0gdRF";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="YdEpLmsA"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A3RfpI4102820
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 09:32:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rLgXJquVUyBesXKA8dBPnaFYAdLbpSuCrTyxZs6wRLQ=; b=gyN0gdRFUJ97s+ng
	w9doHsRyEqEf4htP5kOOfdDEkdnknJuhCgyZofYt3++5xG6Q2jj+j80gvIrXZXq7
	rIGMjNBgpOy8+qvhQgro+ixrsVEdGl6ypCUHzgLTqBXvlmMV6JFqr3H+YYUFpKhc
	XpzWvOy1t+q3Pi34ZcxXG5ZTPwpCVPW3UntEPew9+94OHzMQ+1IB4P0U2UcilQ+r
	AOhWY7sX/DOyNWmZ9U067LepU7sqIUhxVLjBiUkhqABGxIUriGFKhN9yW2dO7Jbi
	c2tYVWDQw60hbqFST2xrQEGMlUmq2PI66KzRdyxQDtqBepaFU1klhTEE525WgIR7
	BGn/uw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c7k61k1nm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 09:32:48 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c53892a195so102986085a.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 01:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770715968; x=1771320768; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rLgXJquVUyBesXKA8dBPnaFYAdLbpSuCrTyxZs6wRLQ=;
        b=YdEpLmsALwtK6Pa72IecphXXMk4NG/g9EeFodmwCoRne0USv7T8S/0ZrlwnXtdLRb8
         eWrKxCfpYFZSw6Lc5XI8ljOTOK+JkOCZh5Spyb4Sm58jeXn6GimUGrDSHslF4amjxRy8
         Skz8+XMYcYNkLQ8Odc2aolxnqg2uTY1AodPL0Vadf0yMs1+c35OGNwW1YILT1+KkrRCz
         vCoqizHUumiXo1zkt8ah3b4r1G4DBAaIxyLqXkgBCRUze/WNiHmuzmKRrjLvSnvxFb5Y
         E4/Dkcqo2Oe74/oIOIy8Onk8Fuq2hA6PJnRQvXKxatvQuwCDa7JkMJHV3eNunEajVx76
         Nw9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770715968; x=1771320768;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rLgXJquVUyBesXKA8dBPnaFYAdLbpSuCrTyxZs6wRLQ=;
        b=qSOBYd6VQuRyvAuZcI2dfvvYbWLFbrXo8EfYki7MTU0+SOFsDr+tSp0Fr4P2zpIIke
         qdr4SjkTWeVcGIOuECZMADtSFeJf9iQZYYCqViLDO+U7eoSB6hXbdNr1e4JuCg9BglYb
         IDFsu/St0loOJQ1FXJzFgGPfRYvQHZfC27gZTc1P5nTmoaPj3hyIuhqq8ixRSWnvw8Bc
         4nGiRe+GSJLpAa67nu//K0OeduWQmx6eOCzr+EpCM35y6WL4Mbp3IVlc3tnFb2wiIpAl
         OJ+iE22uYUpgB6t2vPOuLem19+ENwrM8+rlHiVl9PtQ/Pk698I0yandljy0Hywlx7yTC
         6EgQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiGMTCBjY9HB5++ZH4WM9ZpMF8TdOQ/4fhjOm9puJ3t+u36QwDHMKSxT7MxN9F/vTVIAx0Yw4r3TtV@vger.kernel.org
X-Gm-Message-State: AOJu0Ywa8knU5ll9m0psL32/jRewBFD5NQ2pEcsMBrWBr/pN3F7fLJAY
	q2XkcELOEEHDwh60mQLiGPNSunZF8XZdbKHdYXsdhKlZ9dsg99VvOS5bmJp3p5yg1bn578ouoQy
	RhfYgVbrU1eJog1g5eVzMj4+HhCySweL7vWBAQfemprGQ343GDSY5TL1W3dv2p7hui0qsbsoZ
X-Gm-Gg: AZuq6aJQs8khlzbqOipD6HH56n/16m6+qVfT4k9HNEYcYrDhJm3whQnL33OcWew3uqh
	QKg5myaUQnbr39EuYzJDa81T0mEvKZGFH2CGvZJxhCgxPrC9B30vTQuxW8+pa6PIVo4a5rw+wtH
	8EM7fK5/YD7U8Jm8wvcMCjh1jqvoQiyRvzFhfrWvW3XMK6Yv1zY8BAxzP4+vXJIOsiOyE25G5bY
	b1lqoDeRwD+/litXjqXxy4zNAf+j61pzD1GmlbMP0J69gxgAtrmGMPyUcvvTP3wyVw6/XcolQPC
	7CHbtSfIWRqlzpn+W6IbXAamwtmkgmWyNej9ywgT7fzEs+9F9oGPs4zMzPY8l5iHIo6o0yU270I
	VgDKbVjRg8/CyacYT+imA8La+d0agCZMaMNg2HBCrvEDgRYYp/P43kX3Iw4Vjd5dgNI0fW3rKm8
	EfmaE=
X-Received: by 2002:a05:620a:1a20:b0:8c9:ea8e:c55a with SMTP id af79cd13be357-8cb1fed996bmr108852085a.3.1770715967946;
        Tue, 10 Feb 2026 01:32:47 -0800 (PST)
X-Received: by 2002:a05:620a:1a20:b0:8c9:ea8e:c55a with SMTP id af79cd13be357-8cb1fed996bmr108849485a.3.1770715967474;
        Tue, 10 Feb 2026 01:32:47 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8edacb18aesm499346866b.41.2026.02.10.01.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 01:32:46 -0800 (PST)
Message-ID: <15b87c55-9dbe-4a49-b166-498908f174bc@oss.qualcomm.com>
Date: Tue, 10 Feb 2026 10:32:43 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mmc: sdhci-msm: Remove NULL check from
 devm_of_qcom_ice_get()
To: manivannan.sadhasivam@oss.qualcomm.com,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson
 <ulf.hansson@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Sumit Garg <sumit.garg@oss.qualcomm.com>
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
 <20260210-qcom-ice-fix-v2-3-9c1ab5d6502c@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260210-qcom-ice-fix-v2-3-9c1ab5d6502c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=M8lA6iws c=1 sm=1 tr=0 ts=698afb40 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=EUspDBNiAAAA:8 a=AC2hTCgHVLFjDka4hzMA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDA3OSBTYWx0ZWRfX+4jscNAZleDg
 Ok3N29W6Uy9H8QZa1pUPLzK500JsJoSGcQJxrTgS/Yo2pMt0yXKXiHHV/9YldzzUmdLEJDvx0NX
 R404yyzInKj3b4PKyjRZ8GpmJY20hwTmLjpftNJUJbf8f2blAzyc7bVcWpKLifSxCKOKSSsmJo+
 o7FV5VmZhWQbLSaEUCXjOurqNLpj1+M6VSUxQjdfDQ//NfbZ4PrLcU5/dMQb0iv9JaeWRXFuC+X
 vNjCowXw4gAbAVk/zohveLwYrS05xDEtNdwCl/Du6JCJS3AJ6p/XcBjUtdFPRNsnarT+NmrwrIY
 jDnhWgIW2tTGnGl/o0bqt60k0VOkNULRAloUaeEL2AdHRdKUK9wSt15682jZmjyXN7EeoDJZ22g
 O3eTenNJFYlOPqz2rmTIn2x0ppbYBLo6OqeJwFxTYN556TzYglxNfY2K/av+S56+4MB/fecx9pK
 Q2uc51eGGxGqgi/wqug==
X-Proofpoint-GUID: SfroioBE3NTOqB5F-o3icHbhTMzC4o00
X-Proofpoint-ORIG-GUID: SfroioBE3NTOqB5F-o3icHbhTMzC4o00
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602100079

On 2/10/26 7:56 AM, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> Now since the devm_of_qcom_ice_get() API never returns NULL, remove the
> NULL check and also simplify the error handling.
> 
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
