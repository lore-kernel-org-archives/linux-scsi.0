Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08A040FDB7
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 09:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781600957; cv=none; b=LXeBYeHnDk494pFc3whxf7QN7ekSwCYJvr2NDKt2wftFAQQUpHGaqm5uxk511EjT03PxB92EkPUwsSXPwt1UlLZVG/T5fL0iAUsFwG2yL0UPfTp022jw7WpVm+faIbJt8NCpwrDhe9Inqxa+JHMI/ks45Z/gm8/UPBNdtpRFozE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781600957; c=relaxed/simple;
	bh=Ih6jeq8wPPjziulVsHkz2i18GZmjPdSfbEXqLyxqvv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c1L9S+LBXm1ucLQKyr9PLH4UIJNX4VHMucO/JgSAT0uRDQxRdci5l/hfZCbQ35XLfeDLt2lP4grUr4iRHvQ1ZBIhLVOXzAr4BT2kojEVZnAgmWwk3pobiFRGv4KeQU6t4WpzhNcuN6rxVvGO//Hk0q3YMYz03lPdhl3ANsIHL7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ROsV5Jy3; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VxcQactk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ROsV5Jy3";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VxcQactk"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65G65RGZ2850117
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 09:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	tF8QGDLALBCYPdqex0XcjlP/aqvAXjPOLvPPj6ruw/0=; b=ROsV5Jy3TdJPHVRu
	Wh4BBmLwk/uud2DbnPr9z+dhI/eGPXYjSDGNsLmCaWbt9KzD8k5inhdq7Lzes6PK
	SGcc91GGqkelEdHyw8dR/5yC2q9U05buqzYQijBuHckO2Bm//Rl83s44r7DPHNuJ
	WzGmj2HW0e3KLWj4SqYkjwIJus1uMqp2q1y5+/7kV+sTagu5O8CAF2nYH3RYuuv2
	zjMHBJkpDdw9eKBabihqJiw2xKfNYbq8NDpOSphPt4gi+586VO+8Wrl2EYx3ZXOe
	VoDGBWywcoJL7zPvBo9STb+3kl2H1UX67ev3qlJn5W2G49UBe/dRcs7DhefQj3vV
	Ut+upQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eu09g8xwm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 09:09:14 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2beff6b6e74so57180825ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 02:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781600954; x=1782205754; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tF8QGDLALBCYPdqex0XcjlP/aqvAXjPOLvPPj6ruw/0=;
        b=VxcQactkiAyFeKbtn6XXJ9ZITb8j/b/P59Fw/vEyWai8ZNNy0te2c0L5qwUcQXIdnc
         KwES1GY0pNWnTjIbyXaFstZb+n1F2VDYFT81RfU4n/u7wHI4iEXocF6BRLIrG7SSgDZg
         Rd1zfKwVSEkWU7aXC5AdVgD/IWMmwqPL6g/1cOVhYmqPQGViC6zvaAc/b6xy7K6a0Npd
         z82pwUYePhn9TQdDgszFOeRfAwMvhUv8wY4qdTtT/XzV68pT/kFpe/X5gPt6r9ydPdwA
         T5VHtuTs3o6gIZFin/6LTOzt90vw1c1B0XKJENSfVAHTs8BbmxfTt9HAS7ibHU+fhjDF
         jxOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781600954; x=1782205754;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tF8QGDLALBCYPdqex0XcjlP/aqvAXjPOLvPPj6ruw/0=;
        b=Vjg5q3M5hlkJdZR5uUmW6XRGpltWb407p0QuiMZ6nJ8XDJSpFUr2ONdkbx8VoWTwLl
         YpErfxp2eG0lomLq3N+mKuaJ5UXNas99XWD6wjvPY8QIWtnV6j3Ec+qOBcLkkXUiLMIk
         /i6MnxPbJpiVQrIbmb+tkZ43bWtXY4b/H40A6WH0TfpIaf8BdzH09ihb8L0ncOEYTGQY
         kwRo31lFLDNgC3LM5bi7ZPOmjiVgYLpcAC1SX3y94hah2pPiBl4/lt6xYYrUlQYwdRnP
         gkqUkUL+ye2Mb4NpAoY55Sa5NC4r87T9XBKIWrrw8IhOuPZCzuYchRoBu+PPo16nHD8Y
         1CHQ==
X-Gm-Message-State: AOJu0YwACcKaCMNobvV/RmGAGsu/NaVYhue+oLtSSiuK1voe0+lB+H1L
	sM/czqGpj2MmDdF6sjazUxyMZHMjsLwsTjBxwuSohcrFbEhwe8KdiEOfG6u7HdU+wuWp6IbFtNH
	zgZkky60HCXLDyGjCTfsS0yyciKi3M2gVir3ph8+FUe8M5dxtdYbigfhyTkKRXTSZ
X-Gm-Gg: Acq92OGEggi0hEzT08NR9aMVxHxloBYYuDNyEnAbSfugwpLyLeLApbaCz1gpCRoM4nb
	9fEd1tujw5mO9wrtMg/ZsVqSeUrYzeeWAUYMBTf4Z5UYDiaPKnnFjwfivqUeSGpls90L6xDJs2A
	NtWDGw7utKYjkiIvGOAsQ0fn6ZzJtoXvNM6TC3h5J4yPk2u9u3hGqSyLuefaQ5JQ2dfhmlb8Ltb
	Swl+SPXLkttW+7M3eid9bI3ajVo2CSvQt9YOL1/4Tn4jD+yqBFnximeNqR8R07VG0PYMEYRkHjc
	CDVBKYVJD87dboEh/+2KqgIdyJGIRyoANzyyBnh79Gx1FkZP6qMA7+OieVbbP4ybsBl0NCjkYDh
	dh/tAS24edMlwWLRbJah9YuMRQPkrM0XC/Whq1raG7E/eCD8ExrUN3vxdjbsNybt3YHI+kfMRjx
	zpIZDG/LXl3w==
X-Received: by 2002:a17:903:1b67:b0:2bf:172d:ef7e with SMTP id d9443c01a7336-2c4135e5c1cmr209319865ad.34.1781600953862;
        Tue, 16 Jun 2026 02:09:13 -0700 (PDT)
X-Received: by 2002:a17:903:1b67:b0:2bf:172d:ef7e with SMTP id d9443c01a7336-2c4135e5c1cmr209319425ad.34.1781600953373;
        Tue, 16 Jun 2026 02:09:13 -0700 (PDT)
Received: from [10.133.33.52] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f7c651dsm124810995ad.26.2026.06.16.02.09.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 02:09:12 -0700 (PDT)
Message-ID: <bf4d2fd7-2a8d-48cb-9f50-67b6ae4f2163@oss.qualcomm.com>
Date: Tue, 16 Jun 2026 17:09:08 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] scsi: ufs: core: Add support for static TX
 Equalization settings
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "mani@kernel.org"
 <mani@kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "krzk@kernel.org" <krzk@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "quic_rdwivedi@quicinc.com" <quic_rdwivedi@quicinc.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
 <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
 <e4590bb7dcda6bd8b20af2e22a18111b998b9efb.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <e4590bb7dcda6bd8b20af2e22a18111b998b9efb.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDA5MSBTYWx0ZWRfX0up83blkxJxW
 epH55tAVHQyyQGYYRWwND0FxIVH7qJnVU4sK1z3pQQ1J0/cbcoZAUDP481OlAMevh6w6VrBSAJZ
 odtpT3SDb1J2xf5uF1bGgJkah8BZCf1bcseL+zXJod4pgwjeTvdWdwL1BjwhBigG521QK5g1iRW
 NBkU2lTwoX/Of9tTsgsJ4j+nEhRc8QbAH7ZhM7QYFl4gLqkDvx8YPKjlTSTdu6Zpp7cpZoceXcn
 nTUuaVSMPHzWCp6UmJDEu5fP5VvJZrW2DdrrMSi6F02Wnr34+AMdLW1cXEzlyssAFtJMemv78Yh
 8JA795yKJdIUnetadCw6ssQgY5EJbinTSHZQ3sF8cD8ZEtQHfNOBx52SPL7/ZjUQ5EprjaBLwVl
 5tamP19q1JgzUEpmMtFmZ9+S2RTETwHYvSJ0iHlWSszRPxsvRF2DO44z7ITtX4g1CXgvIY5oZbR
 jM8YC1PccWImcmSff1A==
X-Proofpoint-ORIG-GUID: fBd-ROtkv0sH1tTLY5UbSnruK24SfjZv
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDA5MSBTYWx0ZWRfX5UIvnjNxdQ1I
 w2juDMf08VrTdrjekG+PCWf2rPNNh6swlCfV02uu4VnZnygrk5voKbpHrln+0QjFsruBf9JLBhq
 eWANzldPuo+uSQEbYtcvPa/kS1pTm+M=
X-Authority-Analysis: v=2.4 cv=DLa/JSNb c=1 sm=1 tr=0 ts=6a3112ba cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=R3sHXq4109Ddd7yNOpYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: fBd-ROtkv0sH1tTLY5UbSnruK24SfjZv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_02,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160091



On 6/16/2026 4:04 PM, Peter Wang (王信友) wrote:
>
> On Mon, 2026-06-15 at 06:28 -0700, Can Guo wrote:
> > Parse board-specific static TX Equalization settings from Device Tree
> > for
> > each HS gear and store them in hba->tx_eq_params.
> > 
> > Parse txeq-preshoot-g[1-6] and txeq-deemphasis-g[1-6] as per-lane
> > tuples:
> > <Host_Lane0 Device_Lane0>, [<Host_Lane1 Device_Lane1>].
> > 
> > For HS-G6, parse optional tx-precode-enable-g6 using the same per-
> > lane
> > Host/Device tuple format. If provided, it must contain values for all
> > active lanes, and each value must be 0 or 1.
> > 
> > Introduce from_dt in struct ufshcd_tx_eq_params to track whether TX
> > EQ
> > values came from static Device Tree data.
> > 
> > When TX Equalization Training is used, static settings are not final:
> > - If valid settings are retrieved from
> > qTxEQGnSettings/wTxEQGnSettingsExt,
> >   those retrieved settings override static Device Tree settings.
> > - If retrieval is not available/valid, TX EQTR runs and trained
> > settings
> >   override static Device Tree settings.
> > 
> > No behavior changes for platforms that do not provide these
> > properties.
> > 
> > Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
> > ---
>
> Hi Can,
>
> I agree with Bart's comment.
> Regarding sashiko-bot's comment, will you have another patch to
> fix this pre-existing issue?
> I think force_tx_eqtr could potentially trigger this deadlock.
Yes, I pushed a separate fix to address the memory reclaim deadlock issue.

https://lore.kernel.org/all/20260616090654.421850-1-can.guo@oss.qualcomm.com/

Please help review.

Thanks,
Can Guo.
>
> Thanks.
> Peter
>
>
>
> ************* MEDIATEK Confidentiality Notice ********************
> The information contained in this e-mail message (including any
> attachments) may be confidential, proprietary, privileged, or otherwise
> exempt from disclosure under applicable laws. It is intended to be
> conveyed only to the designated recipient(s). Any use, dissemination,
> distribution, printing, retaining or copying of this e-mail (including its
> attachments) by unintended recipient(s) is strictly prohibited and may
> be unlawful. If you are not an intended recipient of this e-mail, or believe
> that you have received this e-mail in error, please notify the sender
> immediately (by replying to this e-mail), delete any and all copies of
> this e-mail (including any attachments) from your system, and do not
> disclose the content of this e-mail to any other person. Thank you!

