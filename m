Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793027519;
	b=sIECMJe9Kdr4uDWHf3DxMLrkY8dkSJIvXwozjgLZXJKCpBs+zgBOV96lddzg9u90jhS5
	 by5T0Fk6HcxDXMOaYBio4N1fd7YN2McdttWd+jpFwsy2WRQOlp8WrDdy4dIHWbyBTFuqE
	 m+WqRakY/kZMcqolvHcfraP86FBQnOiAEcuOftiMffYJJm4nK+lgVA1wcd3RK5wAxlAr7
	 bQwhBs1XG0T1w0u8OP2W5zFHDMnAHz8XuU3YVB6BdSBk4QJ1kCIaOHlesoZBKWuh+DqFT
	 Oawtccpy5tdMEY9BXlx4q4QUWwYdI4vxT9ULnwvKzkB/asDoEPH12NDYXsJkB7zU1nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793027519;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=zI748uxWKPPDTZ/WsRErMlRZ+qLc7z2c01W+e2hpsZg=;
	b=m7F8dXt+X4GKo1fIRmBn2P+hVyYh6YFwTmUTVPp4AX5Nj3cQy1bJq1gSAyyyTHmGowwu
	 BsGRNtqk4lDjpSdPS7NY5v5mB5RT2uGsCtWG7s3oSrqmYr5yE7not9LaQIDkQ73RIZ71X
	 zAcRbW94wH6tnz6ag5bX2+SZ0xr47dpieHC2ijCslITVOf1o4soF3tYhCJC5a8yyDuqwR
	 StDKIX6+Yg3Dd+XEcxXdzkhPFDXOMqsb3WUUWQWnTioOsvtTDBM2FMwjn9zz4Rfmu/Siy
	 iZB0bHFI4LZa642h4WKrg2t5jqbH4hWVMb+jkVzp8UENSThgXRCDxBxZHqOPtJHM92g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DyWaPPud;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OItY+r7g;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C190606A31B
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:11:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C190606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=DyWaPPud;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=OItY+r7g
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69QEwSua2082549
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:11:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	zI748uxWKPPDTZ/WsRErMlRZ+qLc7z2c01W+e2hpsZg=; b=DyWaPPudMv5hXrWD
	yfOs0uowTvmp5SjVQGyCK1Xy7Cg0TbbU/L2fUVWIk6+PCjGCaCcbukFB8GkQONVJ
	Qa7Kqxbl0scWGiN5FKPbYLFr7HmQIMQxOIX4Xmd03gnCDF3YgVBJcRTX6kerdp6C
	kpMXU6j+wuXBIbiDOrB93tJqnj6ImBFNeLKRlRLq6wEJRIcANruTZRpySHyVkncA
	RNqmHEIm+6LPBQZPk7FBUSAD/H/qn6aDghRUg7D6/UG88DOoFycLG7WRaTfAPaE5
	aoWw8TlTd9PJWBSKvCaVRmN8GSQt4KHLePGSkJtQGtq9InN5mDwDpuQYCiKge8cX
	3oyqUg==
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com [209.85.221.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hhsgsu2cg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:11:57 +0000 (GMT)
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5eaabe26601so168604e0c.2
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 08:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793027517; x=1793632317; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zI748uxWKPPDTZ/WsRErMlRZ+qLc7z2c01W+e2hpsZg=;
        b=OItY+r7gTyWXjl/u0sTcwO6VnPryXe0YeKIQGQEhyBL9RTkH3p7fRiUwYg4JTLqqKT
         Q7hcTzXKFNoIdSwF0xHXmFD45lZME4hr+8KOl3L9BGgEWRQXIe5N+RgiUOib88KmKhGt
         TZ9QDj2pUk42l4/4L8UJpsvTB8uQv08zZJVfad0Wh/FAQBJxDVx4OwN5wCkydYlrfzgG
         uJ0ahMUhgPDPLHxU93TaiYZ8oH9P7RTfcP6QbeUSLnPuE6EThunrgYeDm8zUWYUYyaOH
         C12CsXzQ0b4EhcNTYnaYeeOuaja0oqKTZZ6XsD04IsgWuEWP2dGCpggiiPs43/WYxQKg
         L6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793027517; x=1793632317;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zI748uxWKPPDTZ/WsRErMlRZ+qLc7z2c01W+e2hpsZg=;
        b=HQWMaPUXlilzHwA3MI01bAUlfPI6E1keBuh59w0iS35CMCgyyDG62JUIZTQM7kyTb5
         M/WIPrSNvuXgseUHl+Oix1N3QBL/28k+7FffVeB5aJuBvPPQu0YqZKibEZB5Q4kZvXKg
         4qYukyVusJyDHR6K3Dj/2RV4BepFMLorcL7ZGoWsSrVkuaVx2UXIhH9v3DSveMMtNTu5
         qzlDI+sE8CFmk7aAIjY93j4ObL+7K7nSI6Lfv07X/TyaB2isoTFNlQqG0IoFN5eD1mEv
         0foqwIhoPWs73TfboP5PMEQ2HP285t88zw+jp14dLy1i9gTcS2n0XedvMDEdOQcmqkdT
         ZeIQ==
X-Forwarded-Encrypted: i=1; AKwUvBz1KqxeFQVlzEmDolZFUTwVnM/egIUoVb5XXHpew+1Rl2ovq/T3Rw9VRZMik8mTsBlVc1A6eCgdgGzV@vger.kernel.org
X-Gm-Message-State: AFq9FYKjB7L+P767EZ0Rf4yzLueqbjXG1POmNlDXlezk6LxarxAyyLDy
	hQVItAqXhFS5F+FezV8XFKxJm0fPa/DdSibj8hjudUpWVSa2ug4sIdYHQUhAEMT+DCwHJUBDj1U
	T7QMRg2M9sSNJxD0dB+87YRksxwG/WxOXN20LKMjbyn9JahXW7zSTcG9YSpNqb5oY
X-Gm-Gg: AYBFou0h0TNgyf5NyXWYPHT7dNt/yNBpcyFFMZOwV7S8uDMCzNGK01YHABz3ZeWyYIw
	Ul7S5C5sLRjRHXAkt4rhnQl0AhE0sSpLUwOQkETzZp1g5zbxdOCeQEf2Xp5v03gPN1pZRbh7VBD
	AfKX4kbJXtqyhPNjDQQbmXC4VlB9QxwIxrDFHFUUhGH0ppCwel240uCoCrcCXMqYY1OpN4xhNj0
	gaPtswVUpgPcZ0dVvZzvgokUzE+GoD+ndWbyqtByj/+SAXa0zUWhqUz4jB3PqWc1+SIo0FyWuv1
	krAtM6IQMVo+72RvvMGSow0RIyNB7kK0TgEcM53l9zaUZGxZaFZ4n+X3SMpM7qPiDDgvaAlAqUc
	82Uq7TXCZZwVzq2qCosVuow==
X-Received: by 2002:a05:6122:8617:b0:5ea:af6f:16e7 with SMTP id 71dfb90a1353d-5ec2506ae8dmr2821918e0c.4.1793027516467;
        Mon, 26 Oct 2026 08:11:56 -0700 (PDT)
X-Received: by 2002:a05:6122:8617:b0:5ea:af6f:16e7 with SMTP id 71dfb90a1353d-5ec2506ae8dmr2821858e0c.4.1793027515922;
        Mon, 26 Oct 2026 08:11:55 -0700 (PDT)
Received: from [192.168.226.26] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd66c6dbsm327506866b.59.2026.10.26.08.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 08:11:54 -0700 (PDT)
Message-ID: <3650f273-d361-497b-8db8-7d5ca96283aa@oss.qualcomm.com>
Date: Mon, 26 Oct 2026 16:11:51 +0100
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 5/6] arm64: dts: qcom: monaco: Add OPP-table for ICE
 UFS and ICE SDHC nodes
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
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-5-09271f583dc6@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-5-09271f583dc6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDA2MCBTYWx0ZWRfX2fX0IF4iULIs
 QDl9LiDz74dAaC8Rb8Zh601CCvIQkoWKXl+pnpayzGHu2Nn2KdAPuQjE/lMzHTMUM/6T6SQ7iIX
 zyaUX+C+pk2Im3QBRIiVDoA4Ww2oLsQ=
X-Proofpoint-GUID: 6eeKFPby_hYS9zU19RjhXYC93_3xyCYO
X-Authority-Analysis: v=2.4 cv=c+8+0h9l c=1 sm=1 tr=0 ts=6adf6dbd cx=c_pps
 a=JIY1xp/sjQ9K5JH4t62bdg==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=-W0wxAWcNmATYll7EfoA:9 a=QEXdDO2ut3YA:10
 a=tNoRWFLymzeba-QzToBc:22
X-Proofpoint-ORIG-GUID: 6eeKFPby_hYS9zU19RjhXYC93_3xyCYO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDA2MCBTYWx0ZWRfX4Ey6Z7ykZwXv
 XVpxMO0/RcA05UJrnMnVWVkpm4ckUNFY0WaCl5RrVlhIRiSV2QK7p/BPD6R0OIHMCy96hmX9oqu
 RYFbxQQSNb3z8mOQtL1e1s4Wg5oRxSjc8mvuhk1UKTprjYMbKMRl/qXCSwwaQWj61tjOctHpTH8
 L0fgVHs4ieI4mRDgEes32CYlBSojwijRu3zZ2Ox/6rSjqLzZLA8Z0y0P0asyDldzdb7BIwNcVsq
 vCBUnSdJFgUzjw1AjygD8LxOenByorvbEjy5xeebJEfC5EJIHVHPWqkJBk/xSqrVshv11klWbJg
 orL6asT2yisnBUe1lMGX9zkjj7j/TXyy1VjYmWaNo4HSH6mg23uP820290OF0HdAJpOlcuHHl5L
 EYnFhWQIA82KOT0uk2qunV/Uame24RNdQWZ2yTI07YSbSfzyQIwQhcrTxsltKauZx7ddyTpExdV
 iZJmXupW/rRifxnIaHQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610260060

On 8/23/26 9:47 PM, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS and ICE SDHC device nodes for Monaco
> platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
