Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41DE3911A1
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 07:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782977250; cv=none; b=FdASlYQXUL6qrX9P3Yibmkq/UFvr5Vb8XMrIrEbsb5ZtNl3ugi8t55Ah8Boq/zJgfXlulj3q0yiyQ0JkKV8mgGN9C8QeDl/osa3db35xGr/R8ajVRKiQRom809ch2znsBAHAtyT6qDxZKW/N3rKv2kOFbht9raV2SFEeXFHADfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782977250; c=relaxed/simple;
	bh=id6GCT9z7R1KgPTaO8+j0tou+U+JDJCUdzhKbDCachc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qm7xw32mpdbLzxRMsYd/wByNiKV5bwQMcHMDeRvZZgR2WQ7rAHxItK4TQBIRnzwK8Q0LE4bQDiFftBw+pSQdB4gv6x/n2qHE3+IXct62e5ojOzEijNs5VRlxzAyPh3OkGghHE27NSmJ5fwGgyMttS4mRRiMsDupUJCwRxcqHuXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f/2A6QeN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZLQ80Fxh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f/2A6QeN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ZLQ80Fxh"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6624lo0I3486171
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jul 2026 07:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	id6GCT9z7R1KgPTaO8+j0tou+U+JDJCUdzhKbDCachc=; b=f/2A6QeNanUi4LOk
	lI6xi/L2HWbI1KWaDCN65dqkS3m3g2mxhCaDD968/ggxjpD+BJuzXafoqtctj9zl
	w3v+4Zn88uWVDjsizy338zVy60/ZFm773eH4wz6B/AezCcA8Ywe2UYzXMKsONxHe
	A02oA/P/BorKOYRlxE8g8u5jpAfmmy1wv3eY9q7NDH3Y3BHP9ZvxrpGRqOE1viDk
	KwVNVSaJFGm0SKIC9ChKwTYWlwwKsQJd7eG26llRHZHWBgTS8jRGmS+6/vCOgW8/
	tIfGfV2unqx1JQsS+Jpd9fyyWauXpM59gpvPE53VqVdP5qCZALe/sNu2QFMWj3Bi
	fbaHMA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f5h98ggvw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2026 07:27:27 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c88fc985a65so1889000a12.2
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2026 00:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1782977246; x=1783582046; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=id6GCT9z7R1KgPTaO8+j0tou+U+JDJCUdzhKbDCachc=;
        b=ZLQ80FxhrRtI4hpATJ3NziZIpoWXgGrXb0w/AbK3VgewyD0Vj3tr8WSmZvSut3xOTG
         9HGGI2l5xKSGjBqn5RS2Ud/tTlWJFASX6yefLJn3d8U8HyEggWeVp6bM40hdqJjHRiYf
         fSa/7TNRlcFvDY/qTFqmu5OphBfANo4MmHqPhIwnxbYkMyrcG8EmXqJ2w/wmgljduYrv
         hmk6pFziL4UjbjtsV7TLqVkYjvRaPwvGg0dHFVTZ9xXU5n0f27BueQrlYkpg8Qkb/0+x
         3XN+r/Edz1UZiEeVsCLYuwu1SNHu7b6cGDw14/00oQB2bIeUebgwxEETT3B0+lj/jOMT
         eN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782977246; x=1783582046;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=id6GCT9z7R1KgPTaO8+j0tou+U+JDJCUdzhKbDCachc=;
        b=pkceTYrgCz993H2VDMXqUlBMN04mLLwFboY3cDgc6dMShOk2cOcQ/kpTcI4dPDqtN9
         uUEdae+noQCVEbRLPJqYmt18ySh+iU4CR9cP0sR/d+TTInPvft9cvQeb0Ra0DZsV1+dL
         L21KuDclDluCVGH/QwBO5kzNLmdTAoAOpT0/z+oi8hmPze28X74gLL78W0GGIBAg75GB
         K6lrlUN9j2Mgew5LKxW3LVcntZKvQ9se+dPsum1gmvfljjjmtuo/bbSYCx+8aBpKjPJw
         JRe4g+ZxGGALLVEmrZf8YWIG91VIpJEngIWC1/XU7JvYJgqC4D+pxfA4mD1EAy3Vmnwe
         eYkQ==
X-Gm-Message-State: AOJu0Yz8JAWfwIbo1KFwyGhCOyF0chfnrY7YuX6JAFn64T1Whp/SWEPP
	iXKv3DSKW+xJDmgr/2ErpJ9Pl2h9z7cf8pFA/tiZhVVpfWwSYx0kN8TepeQKKLYcqlFnqn8473R
	Ii2pUFqiQ9OObfDnb7QynYKOrfLGB6uQm23/wg57dMAmvdmE0TnchBCrvaoWCU6FFzyQCk3j0bA
	E=
X-Gm-Gg: AfdE7cnbatYnXz5WW6hdH/RyEPLOxMg+xndyp+k+xU6beEbc6uKoaZ2M8QdB7hVXtGK
	6kHsmZsLtnXkrjQfOOKENf6xbpT+frKMBtIKnhzUJRnPv6XTuvyiQ5H2k4bX/3nRFWOwTuUrAXg
	f5tbv94ODSBFh4yqfdzVJnfSy3hERKfuby4+dZ4ZfKT96zCmvQn+A6GsGP04h5Mft+K3s6zEzYN
	u6SRifregOkDyG5SkFFIPnGY1ssbvk0ja0GxmU+twYm/pWymTaJWSWYcphpWQU//p9L7YCqyaHR
	UOOC5Y/huiZryxK6+/2YIrjQ8hG1liYAojkJ4qpcxImTiN9jbux23HuSZWhRREjnKETecdEIdFn
	15pCCCHs4c7Z9yV9ZK4RFLt6CrBOibmUQIwzDaNjw6w8K8k96pUB3RrglDCa3gacd
X-Received: by 2002:a05:6a20:4320:b0:3bf:6c08:fb88 with SMTP id adf61e73a8af0-3bfed4b9441mr6003389637.56.1782977246473;
        Thu, 02 Jul 2026 00:27:26 -0700 (PDT)
X-Received: by 2002:a05:6a20:4320:b0:3bf:6c08:fb88 with SMTP id adf61e73a8af0-3bfed4b9441mr6003338637.56.1782977245854;
        Thu, 02 Jul 2026 00:27:25 -0700 (PDT)
Received: from [10.110.61.213] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0b813cd9sm5738214eec.8.2026.07.02.00.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 00:27:25 -0700 (PDT)
Message-ID: <251bfb63-b182-4bab-8aa0-843bbe6d82a1@oss.qualcomm.com>
Date: Thu, 2 Jul 2026 15:27:21 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Avoid possible memory reclaim
 deadlock in TX EQTR context
To: Can Guo <can.guo@oss.qualcomm.com>, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
In-Reply-To: <20260618140941.902000-1-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: ZP-prdNTRdvKL6KykC2E-WSybC6j7Ctv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDA3NCBTYWx0ZWRfX0ecYzdiG9ZiR
 b8U+wjKmzQLALf6tFzIvkP3fCMzPZhvRwPfdq8m9t/3fNrALDudrTpyD6fgFIvCu882UPys68BL
 oXE7Qtfcgd6niev4436Kt4TRoW1+bFzlHI7CFxaTwNJJ9lWDyCDZJmhjJQ615byFAzb8Q1e7QjT
 jkkzWhm+lVLSLSssVkVByidy4zIavKx53/dflFc+8C6i0RwlGDJcHM5e8olf8KvavA7CFsEeOy4
 G3OtQPMvdW5wSvBJXDZbZXQnDnV77OFSMuk7/vdQc+VZKhsQxswcmVT+Cpdym4Fmxf46psLvDIG
 8b0nmdJdl4TUq+S52ZGgwxXFr0DLNWC68ooZqTJGO2GHaoUqNMkpkwWzdDRLBKYekl5zbQhiLwz
 zpDa+3QLpK3M0pNw7KXJTQ0V5sh0dMlNY5GOJDUe2tZ3N+JkAxtDQpgoCuhtGoXCXGJIaCWXrKV
 hZ/2WNPusdMopQSW5RQ==
X-Proofpoint-GUID: ZP-prdNTRdvKL6KykC2E-WSybC6j7Ctv
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDA3NCBTYWx0ZWRfX2RfbRkjd6wtX
 6jx1af5k445h8M9Rk+5GNUsZr0VQzY1gSKffVlwZBfmY/cd4yqODnWSFSAKhMvE5BfBPE9ccUvL
 jFiYkSKvrhItSc+Lr2iMt/A9kn9elCo=
X-Authority-Analysis: v=2.4 cv=bdFbluPB c=1 sm=1 tr=0 ts=6a4612df cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=c92rfblmAAAA:8 a=EUspDBNiAAAA:8 a=R9x_4WNvQgkm2tspPPEA:9 a=QEXdDO2ut3YA:10
 a=3WC7DwWrALyhR5TkjVHa:22 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020074


On 6/18/2026 10:09 PM, Can Guo wrote:
> TX EQTR may run while devfreq gear scaling has quiesced the UFS tagset. In
> that context, functions ufshcd_tx_eqtr(), __ufshcd_tx_eqtr() and
> ufs_qcom_get_rx_fom() allocate memory with GFP_KERNEL. If direct reclaim
> is triggered, reclaim/writeback can depend on I/O to UFS device. Because
> the queue is quiesced, this can cause deadlock.
>
> Use memalloc_noio_save/restore() in ufshcd_tx_eqtr() to cover all
> allocations in the TX EQTR call tree, including:
> - params->eqtr_record in ufshcd_tx_eqtr()
> - eqtr_data in __ufshcd_tx_eqtr()
> - params in ufs_qcom_get_rx_fom()
>
> This is preferred over tagging individual call sites with GFP_NOIO, as it
> automatically covers any future allocations added anywhere in the call
> tree without requiring each caller to be aware of this constraint.
>
> Fixes: 03e5d38e2f98 ("scsi: ufs: core: Add support for TX Equalization")
> Closes: https://sashiko.dev/#/patchset/20260615132834.2985346-1-can.guo@oss.qualcomm.com?part=2
> Signed-off-by: Can Guo <can.guo@oss.qualcomm.com>
Reviewed-by: Ziqi Chen <ziqi.chen@oss.qualcomm.com>
