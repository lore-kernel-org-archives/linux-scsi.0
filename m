Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4149364EA6
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 06:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787812934; cv=none; b=lIVzuXCOyNxxtrR4Mqo67GGJRgH1Wa4NMg6zY0eyNHfYGe3AbDPJckMX85AtBfWZV2O88q/BMjz5A0SsV4dCJdKcMC0FA/FDO0yj52c3ZtF5aoUT4vvR6sl8mNAEy4ZIONaSd0q3sHiQ7wzBnnujcUbyd4APn8m8txegmWCUj90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787812934; c=relaxed/simple;
	bh=VpRfMjkDIVgIG1IpVnvWLbUY77m9BHwbtWthaup4Qr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PkwYOAgU/JXLHrtkG4/vhZi1Ts8gThwaqLkS4AEgBIzvCG89Vx2uhZ34yRG8vrGGKAr/xovMHZgNqH2fGwP7NpKYnMq6op5Y7XZINE00HXcawnUJ4eoeiC4BdFWIvP5zhdlkN7kZTVpJqHUaohlEnDjrcTVeJVUKVvFnFsbgp4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=LxBIQfcR; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MLT9JVAM; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="LxBIQfcR";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MLT9JVAM"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67R6RGr92075130
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 06:42:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7ShQA2gHtvOv/7C4MRutuVhaIXxmOVy4BCMu2y+jIWc=; b=LxBIQfcRVtlQdTrO
	UOJQyP34Uz5/HuqMwLc0TRaw9/nYqDj5/YaKBkc4CAryllu5s0jpz+LpkEgeU0b+
	M7ao4WkzbCSvIRL6VHELrNKYjXS8g9vEjalyqDHEk1TdJVmtUb9RRtZ2NEnEUpUx
	8b/4aQA4wrY4Pwq/9M0CpiZPofrYncG8HHAKHjqxCcHPxdGpyRdBWZ2D4orhxsy6
	IHxW5I7KPaWy4yoxlvAYKqmfHnJW3DCsNbkvsC/ZH98zeJiGj+IiDJLaTWc8OtG5
	JL6BzHqTB5ar3VGPYWw1xlcvATeYHdyxBlVEoiEm0LSnTRhORWghymSku2v/uTKl
	rRYkbw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gaa3bh6yq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 06:42:11 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc1a439db36so2179699a12.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 23:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787812931; x=1788417731; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7ShQA2gHtvOv/7C4MRutuVhaIXxmOVy4BCMu2y+jIWc=;
        b=MLT9JVAM+c7tmAbZa8q0+CvHdFGq/Ka6efIlpSbxJ7XfIqNvp77A646kjOW75vxhUj
         mW85svNTamDLRhRtFgnWsFNA/AS4zH0CSBEQdZutpy5b4jlpQJkXIhwBHM/H+t0H9SZ/
         SVSdYIqWauTXzTQWMgxP2xJRkSlBec5r/3HbubTGmJprkqOhtFUsJeK1Quq/rEb87BKt
         wW3DL1WaVz6wkHHIrjWqBOITVRUtaNnisOfa3bTjwVtqPuXWVcagKNVS7OXoG6hqVzzb
         DZhqaEWghbdWM8bnhM2q7YhNujTVPS7owUM+OE1276QCfsF2ZCyEbEUAMUDfVj+ioRmU
         h6Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787812931; x=1788417731;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7ShQA2gHtvOv/7C4MRutuVhaIXxmOVy4BCMu2y+jIWc=;
        b=hcyiMPreOE9owQmBbauR7FogHX6zqwfJmgbK+zxvBtCT3z8pHbs/+mDSY6NSyM3ifG
         DEuT+w462C6gGvz+ylYj4i5JJ8gruVqYY864nq16Nl8jCC8Rx1EnUoPyLDwxLYf5M+Gq
         sD28DeqRlNSYKkt3AploYOz5WtYtAT1mXHjd2/lt1t2uJmaWdC4eZUuLG21QxsrcYwr7
         AbWO6nL10eiTH9bAseIt5GsV3u1OOW8acsyUYngpHwMTfpC8+UTJ0BR6u4f84Eee6/pt
         5qmeJNm0+ikZ+CFgF/J/YjGKRkR5oThPdAuXRUyrJGfPAeHgqh5WJpYVQN1FRfZRkuP+
         s1sA==
X-Forwarded-Encrypted: i=1; AHgh+Rp+GB1xpAq81+ZDe/vbqyZbEn+wTyLvIyHpMOvEpBjkThHQpmWaJjKABUVnshyi36QX/ma2cIv8bxmy@vger.kernel.org
X-Gm-Message-State: AFuF++n3+pixUF+m2F7/zxgSGKB0XOAVhQWSlsWCAaZ48k69txFB2/k5
	kpcPuQWUUxQQzGFDnycXL3QPp/9u9++gmovk6CDILfZ+AmKv6P1eFMCd/hjBPiSjbagXNGoE02I
	u8NF0fP3ZZnAt2N9oceCOPX8nruDoVbkQYEhdI97cOgTnPal+ZirRg8wI29tt0H1x
X-Gm-Gg: AR+sD10rUava6FRWc5qHYm5iD7qC2stOd8QlSuinoNAaU4uyu3EQMNmpcRfhtiFzOWd
	37s1PQAl0JYpNgzMxhaRusPL4SfCCujLfNdt7PnP5lIsIpljD++mhBmVsn6VeWc31Nf9Lnr3mYP
	B106ht/Co833VaF7Ju8NqDi8+tAOGg42L3QXT4SXLSMqu73RdrKenNLVxELb8WgZAIxIbGzk7hg
	DLZacZ8D1LOfbuo9U/aBhslhV9iftXK6QREMXFYTU+UT+U66ORxwT0wyTO8Ndf0uyXyTp5bQTbr
	ELHtoqF8dWHtDosiyIj/RHlaaaNgh46k4rLbIK+EJ66Z54PuYT6SH8PEiZrJ5eqrZODkuKCDVTI
	siKVMnapS4HQ0wsrDqnpKuL9laOV3L/s=
X-Received: by 2002:a05:6a21:4593:b0:3bf:9b61:f7ae with SMTP id adf61e73a8af0-3cf8413dffdmr28629369637.14.1787812930920;
        Wed, 26 Aug 2026 23:42:10 -0700 (PDT)
X-Received: by 2002:a05:6a21:4593:b0:3bf:9b61:f7ae with SMTP id adf61e73a8af0-3cf8413dffdmr28629279637.14.1787812930531;
        Wed, 26 Aug 2026 23:42:10 -0700 (PDT)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1bec80fdesm1693669a12.24.2026.08.26.23.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 23:42:10 -0700 (PDT)
Message-ID: <167f6b2b-a838-4563-99b3-39ef8077ee9a@oss.qualcomm.com>
Date: Thu, 27 Aug 2026 12:12:03 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
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
        Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20260824-enable-ice-clock-scaling-v12-0-09271f583dc6@oss.qualcomm.com>
 <20260824-enable-ice-clock-scaling-v12-5-09271f583dc6@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260824-enable-ice-clock-scaling-v12-5-09271f583dc6@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA1NCBTYWx0ZWRfX2SBlFUyENOz1
 MaAdKbUuQjEwf5JQZAhpU1JYJCeW4j+GNfH0L9aDeH0ObooVXH+l9uZIrNP+Pe6pkn3ri2Svd7V
 lQczZGgQ/IiSerev9dJJZ2t3Lsy4My3tkFju+0C43+z3ms2R8pnJNEodS2YJKUN8I4bUiTgQ36o
 O0WwA4wSNSMVufxe/sX331x/e786dXVbSbeprgJmaAIsxaJnuzVvxzX5V4rViJEH7JWFJGC7BTW
 eN3L8ZmfATG1KWS0uSfJ/l9Lso8L28r5b1S7mxEKY1OMr3qd5HriGSTBexyybuO0MMLDWBWWEN8
 xCoffuiBHdFXffE/w46sBkPjDVH1UO2WCGfCbm3u1X26xGwv34x/Xvd51O2r2de3KrAv1855Jj7
 I+BO7fsGxNpZx2YwHsgBrtjeBgzhWTAzNvp1Pf1NHmiPRoanUDow9H2iIcq70ma+TCHMeKetMx+
 +HzqLanIV2OhM+euthg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA1NCBTYWx0ZWRfX6Ad7RIC/3Swu
 UcgtbTm9/8VbXwiunVzv59H94MJ+KE/pzMazK88wCddyf+TD2ln/rpz3NK6IJUicKgmfmHl4ju+
 M7vIwhTo9yHxXoIhayetJQJ2uKdn70I=
X-Proofpoint-ORIG-GUID: xI7rznfzJCkPSy8zvr9s5dwzHVDo4DrE
X-Proofpoint-GUID: xI7rznfzJCkPSy8zvr9s5dwzHVDo4DrE
X-Authority-Analysis: v=2.4 cv=KbfidwYD c=1 sm=1 tr=0 ts=6a8fdc43 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=EUspDBNiAAAA:8 a=-W0wxAWcNmATYll7EfoA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_03,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270054

On 24-08-2026 01:17, Abhinaba Rakshit wrote:
> Qualcomm Inline Crypto Engine (ICE) platform driver now, supports
> an optional OPP-table.
> 
> Add OPP-table for ICE UFS and ICE SDHC device nodes for Monaco
> platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

