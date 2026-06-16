Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2467C42E01D
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 10:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781606219; cv=none; b=jNbhej1PdDeBIx8Dd3/Vlm9fiHFQ6H+DWo5PWBn1ZP1nLS7x5ysqG5cCsCuJZEuXingY00EUOWj6EqdWwFZcmsFAOFpzLxiXL3QgV+bHB26Z/KdyHrGZOMTwKwk5wUEoITJJQDZ1xjC0bvEOwzEhHFclCt/N3he2HDVRjyF87sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781606219; c=relaxed/simple;
	bh=t7TbCSfJUQJcM1qDlJMidC/ZAT9aEaiAjnk4djiVG4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mecD9g6mkbEsMuBnnZBvRLBKECNZmNuT21g83pKdXZuDA1ia05/iNF0bFK8LzmBGb+NUGpdrs4DraMuHdi1qW9huDZ4aYlKhIqIrN3idYGVWNR74/bJ7jBLjzxds1R/d2VP6oqLaSwyhFE2raPEVlZPPHHAEg14wEqLns6TUI4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OD+wMKzM; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TgM4rxkP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OD+wMKzM";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TgM4rxkP"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GA9Q54249149
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 10:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	h92ax9QzfGBWcYim5kQ7lGmBpMf6d2C6CgXExpcTylM=; b=OD+wMKzMuPoWvXtG
	MlEQb5JiE3Nwmr5MFzzvqoD3ZlR6zyBelV6x5q0N1sZ18COkNBNGcM1JXh7yx4o4
	wiiY689zQO3pWTZo+I1XEGlGHtxexOUbnA3HwzDKhdnRXM3it53+E9BvoJcJUY7q
	+lKeM2JGW9MYWoqN3ZJygxZc5tmWjwD83sy9mqHWAo/TWMCO0LvMnb1Sl72b9uSA
	3faPA6lC1ivksbeW4NWz2UPDj+qa7mXk4HUE1I2t3owNqCLuQmYxQym9lt0xlQcc
	RC2FepbATUFUBKb/HIldkGLF6RhFWqhXhbK1SP6AZXbVjTbNtlBlxuoD54YhwUTe
	yEk6tQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eu2xs8guh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 10:36:57 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2bf08c2a24bso42489725ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 16 Jun 2026 03:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781606217; x=1782211017; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h92ax9QzfGBWcYim5kQ7lGmBpMf6d2C6CgXExpcTylM=;
        b=TgM4rxkPL4Gbyvtlay/3dJo5dCa0ZDz/X6bCcxjU1RMcUiJo8ExVx04p2aTz0Vjo3z
         JR6o9wXPf77+w14tsW8i8UabCClRI1aoUIIS16Nd3x0syjcgrLPoH9vSDcEz2rb3rFMU
         hwHpmjMmwH+xwHflfaSckVOuneaSlMBX45i1KKzH5y5A4joDtlApTmEEb/p/a2V79szn
         BNXEH6WGNbZaYBqowOA4EZ5zqhj5p1MjauaHe8spHvOCzBGE059z6sd2MUv9TQQGMuTx
         AiMKIRc0goo+EaJNiDKmkU5eCuAt6JFnaE2WPqGwSTyfNof32z14gVRiVSqEqGcGz3PJ
         eTVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781606217; x=1782211017;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h92ax9QzfGBWcYim5kQ7lGmBpMf6d2C6CgXExpcTylM=;
        b=G/LCsJz/RktjnTRscGnjeKZIgnNebzTCeJ4ULBzeX9ristmB7XvlRJIhnWY61rQzKF
         7X/TIUv+c1wJ0xCVsGVU3bNBvSP7JxkalSjlQIoVqOSn478JiTpBeoBh93H7/g0G00V2
         rUoRyqYQbiPwqODMuR35qnz1zdthwPkYt2J4ZE1qj86l9FQNLtG2HDoV5ih7LiN0nQdJ
         /zUwoSkYUgxJjMd37DFUxy5NFLbO5yqEgtqQQsBjIYc/bIqMyYF0+Vvww/O4X3K+d0Ib
         /DaBvqlwHhLLdMnUic01eF4jWOTWtM+LUBj9j8xND7WqmmlN5Opv8BHnWNba+6VK4KQ8
         mDVg==
X-Gm-Message-State: AOJu0YwhL1agyOE3f6nPu9q7YAIpN3JPwz8ixYEsp7Qk1PulC0LuSoHA
	/qCU3xVKqnPTRWESLbIDWw3F8+1I0UNEji+P2bnTX9/4VLNBeZVJIpuiR0ONMpdg4kyeK6w1mr4
	zjNDx8mq9/iRDxUutyGRcEiKEqRMUBoEeDSCVqv22kscI0cYk1SpuF51KcOOOLNbF
X-Gm-Gg: Acq92OF16Rbnn1hA5vIFof8kR6sn1UkyShJEZjeJqb3RAV5iKzWCCKGQzEbjODgvXRz
	tC+0v8RzO5eNj7I7H6Z8WKwduUhGACw8L57OsFPVwbfrrlHcJwxtjFG8QxXP33RmvYGOXnhWDPC
	WCcAvLJyzmh9t/871mnct59C9hKGc7zM0m4WVtDstgY6B7mWp1X8KhITGeLnLtGAbSc7fAfjwmL
	7eW2O9qSi+YFLlNSk0sxAP4LLc9Di67ckMXAMQ2Kv5fTAIkCGh/TU4MwssuvHDfLFnq3XNNjPFN
	OcUX18smf2iagCR2v6c0bv0tUpQ4nTxz8qzIGI4Tq6elDVU7iwoPN8+UNer1dL8dOsY2PUCu+qj
	yBVo2oF6rHqMzcjv1Q4n3NpROX01xDvBBoKylzIyFiGYfsP0k3r48H7ecJxyKLpHnmNlmHSs1/T
	1O22xH7gWJUA==
X-Received: by 2002:a17:902:f550:b0:2c0:ccdb:e031 with SMTP id d9443c01a7336-2c69a1289e3mr33908025ad.2.1781606216796;
        Tue, 16 Jun 2026 03:36:56 -0700 (PDT)
X-Received: by 2002:a17:902:f550:b0:2c0:ccdb:e031 with SMTP id d9443c01a7336-2c69a1289e3mr33907675ad.2.1781606216392;
        Tue, 16 Jun 2026 03:36:56 -0700 (PDT)
Received: from [10.133.33.52] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f7c91b2sm131124725ad.28.2026.06.16.03.36.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2026 03:36:55 -0700 (PDT)
Message-ID: <1ef3cf3d-b7c5-4b1b-9732-9f7c02d6a789@oss.qualcomm.com>
Date: Tue, 16 Jun 2026 18:36:51 +0800
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
        "quic_rdwivedi@quicinc.com" <quic_rdwivedi@quicinc.com>,
        "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>
References: <20260615132834.2985346-1-can.guo@oss.qualcomm.com>
 <20260615132834.2985346-3-can.guo@oss.qualcomm.com>
 <e4590bb7dcda6bd8b20af2e22a18111b998b9efb.camel@mediatek.com>
 <bf4d2fd7-2a8d-48cb-9f50-67b6ae4f2163@oss.qualcomm.com>
 <5caf0295b2a7c9ebf2076b7b7db3e0a94212a092.camel@mediatek.com>
Content-Language: en-US
From: Can Guo <can.guo@oss.qualcomm.com>
In-Reply-To: <5caf0295b2a7c9ebf2076b7b7db3e0a94212a092.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: i1-m_wqmw7J-XetgGyYBcK82ADXs-D_c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDEwNyBTYWx0ZWRfX61z2FViCeeU6
 8pifKQ7ltnUG6Rct25WsGt5TnMnlR/hW/4DyHW4D+92BgtWsVqWmOhqPAVrMoyePZmTqLCJmSZK
 eyScMJ+tmSGRMwYi3cYHWyWUZ+3Rq9kTB8vuAUY240eHW+R9uyGpiGAgQIkhy1jjL8Zt/MYhNRr
 lZ1G/tTxrMibKHvmsO/79FSioYDBlaGQdramI/CsJoYjVfXXh7gqR9ME2QLl5/ZilgVe5GbGx2V
 Asu7+ZiTlf8NGa2OgzVX1dFGNkJmmF1+LQbBYNbGytx1WHHeN3jV+ateF9siotdV5GZcea1aDwF
 stmWWCPaZ44wFsnsiJsedDbmQi3/ShffXKvDg9d79A4eJHVbDld2sQkNvLhTMGmIWxgKThAEk8k
 vBktPzzIowkaEDOCQzJMJ4Wbu7kqZbcgGcafJJz5dTu7imOiTneLCZl0b6d1FQXJPP3i6sn3xhj
 Hvh+J52yDPJj9WR0e6w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDEwNyBTYWx0ZWRfX9Yjgob8bmFdH
 FNiLrVuoq+DSc5671W2epWemfv2KRc/BGeJjeSfl7Uv/PZAGxEALwz1y9/BnLBmbexA0Bnz5lFQ
 mC3IPrJHdA2IK04ihrgo2QS4RgokHyg=
X-Authority-Analysis: v=2.4 cv=MdJcfZ/f c=1 sm=1 tr=0 ts=6a312749 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=lZOxv685zBznO1DyOMIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-GUID: i1-m_wqmw7J-XetgGyYBcK82ADXs-D_c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_03,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 spamscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160107



On 6/16/2026 6:35 PM, Peter Wang (王信友) wrote:
>
> On Tue, 2026-06-16 at 17:09 +0800, Can Guo wrote:
> > Yes, I pushed a separate fix to address the memory reclaim deadlock
> > issue.
> > 
> > https://lore.kernel.org/all/20260616090654.421850-1-can.guo@oss.qualcomm.com/
> > 
> > Please help review.
> > 
> > Thanks,
> > Can Guo.
> > 
>
> Understood. If you have made changes based on Bart's comment,
> please feel free to add my review tag.
Sure, thanks.

Best Regards,
Can Guo.
>
> Thanks
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

