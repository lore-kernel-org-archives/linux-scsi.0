Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B207A47B425
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788361451; cv=none; b=eoqtsjfyqpKaEy65OZHAYDHLtSI6tb0X+C1VDShQ5HeCsVXnhlcPWdkFamS9a1LD3QKUdyowhUlySbI1LzuA/OQ8iTSGn/LKhAvLME+78zLdXKCqIA7+f+Hzw1uitOTDCjRZGeYB8bKTxh/96Qf4PU4My+n3F9bOH9rxQgZWhUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788361451; c=relaxed/simple;
	bh=wCCHaHjAyebRsmsmEX2icSW1s+oMksjOOy7EFoGCWjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g9n7uIqM/4Jf8EmlvTXCVDgo/wczOhdTT3m4jwnfWtvXW7WGSySVtdDwQg10fv0yp85hANBeHwiMJ1AwbWAO1/sNVTNhtk7BDf8+cDP72eOemmbOBoqXUeJ7gboZ8mnfE0w/5WVihmZjFH9vJxnoAbuGdT2TmyexW1QZbViZ/aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gslt+rWg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QLL7R71v; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gslt+rWg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QLL7R71v"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682CRJUM1491392
	for <linux-scsi@vger.kernel.org>; Wed, 2 Sep 2026 15:04:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8d/HYLVaYKgSu6VLD4TUXAuT+WMimsoAlFLEDX6rbHM=; b=Gslt+rWgaEkn8Wtt
	/GY4xVCimRHa2DbrI8POvL6E7qeLQdytf4vC+D7M9SyKb63Zk/egQ/aHObhm5XSu
	34V9wJoSKIIdXswfhBcglWSNWtlppU0yMF0W8bzoiG+2wlczpOXtKelwdMeoD7kG
	d2XmgIofGoxkaz/bwRWU2k0qB2J8ejlZxWBqPkI9Ixy6ZmNh3yRWAZ43JOXZ+/Hn
	ORx3Onu4LCsoqeCGG3G6B246sbXK2ZAX9tO4Ur3C7Qn/lcj48kj66sch0Cd5xSB0
	JlKyaBGQHkbbv7QF0r0IxAZU9Hy5IWzu3aVlynpWBl4F4bzz+a15q0OtyyAOOMPc
	y+04jA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4geb562qxd-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2026 15:04:08 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso1662171a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 02 Sep 2026 08:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788361447; x=1788966247; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8d/HYLVaYKgSu6VLD4TUXAuT+WMimsoAlFLEDX6rbHM=;
        b=QLL7R71vk+9dM6BX418uUmxUvVjifKFKHpa7akYe3DcSLr8z7gRRd3D5IjmCyPfQyc
         trLKA/KfiUXR+Z4Z7ZecNA7vfj8SrmEHjMz8ZVMMiG1m6WsnndCnQdO05zf3gn0nesUQ
         tOLKYY5Bj5DMUX57LYcxUPqgOCfj+jurg+HWVKHzrrbvjWLo5c5REAZIcB3zKjkaJae0
         E3w5gDBEa5LdY+fOEFY21asg3wvEYl6QgG/+Mfhq+O54jynKC1FsTqY363Lp/ZZBvq1O
         +oPDlLjyWmae4CtN5KufKG/dI2RmQibic76TDHTA6O06dQ5R2FGPqs0DgogZsyJZtGCM
         EDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788361447; x=1788966247;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8d/HYLVaYKgSu6VLD4TUXAuT+WMimsoAlFLEDX6rbHM=;
        b=BHbMKv0EXxEzTODJuZcLmwVZhbJ8uU4ESPp/N628QLftWB2E5oc+sQ9teg0Fe6ytt2
         BfcbOWUFPDgXx1ebw3ieGum7wRR1P0BOTSPHtrghCqfs2FQBZHGXRK/Gn6ubmyyfe9pU
         /qQZGTF6pgz1xAmKbjZHflS21ogpa4D5afb2gUCs38KLhSgs+xww2J6pU89DMfa1yVEX
         sP/CGWHZSaQw/zxIFoidDH8MgZrmNxPdcOn0E6sPhZXo6xtByQXPOE8FjjlM3UktFDG4
         26tsYvsE8M6VrGLpsXTj4b+dh0o/oDHoq4Sb1IOGH0nkUHsyb0bta7hBNV7hJh4XVD3J
         qU/Q==
X-Forwarded-Encrypted: i=1; AKwUvBzIPv+1gu2HjBInifJQnZiaDkN597YoCJko6+YgGUPgLrfBq2IYC14d0ALDLwTLmFaLnUg4Wjv13UbP@vger.kernel.org
X-Gm-Message-State: AFuF++kudmoK8QtMrpKMInQ9YlAvt+JkwOq+C5CYp+iia+xZRnG9JVG1
	rEWZE+byxqazIqTToNfYy8qesJYNZebRO/jj1RreMgE6kBhUuUq/h+CvHzJ2hELFd6r7BUVYcPC
	9RhXnlVa5rMz8aNDpb/cXlT41fWnxkWAelRi4vsi+oxq0ZM6BvaFMb0qhfjAyg8nv
X-Gm-Gg: AYBFou3txhAbNIZ9SvO2mzJDSuvj+Jy2Wq43UjVzAST6w3W8mv9x5ODFTeiPxkXBCNd
	cpItIO6eLDIXAsnbskneBlKrZ5wA8PdiZm4DWc0AhyvEx8Rpaf1ZAjy38iyVfzG45peTbUe7af3
	ZwUSE1oTkP8aZmW9lopmnk45zwCSQqoa1+iwd599giQ6zLe/D91wcdBFk1xKt38x1xAxQtz9fX4
	AAA+0CdJ7OLAXVhvL0hYqMAtNag+wgkLDy9tedkRJxHM1HGeMdwh1pO9/JZd6IrnDnbc0mwfSnu
	/TypCyQWy1pBCTl64+b9yIZCdyqs6mDW91cyPzwsOxP0kkopFe80430A0LLcayhz6uJ+Airdg80
	DLEFLAck6KBR4/L7MQC0I0UBqV6xl+uKnrHYQ2/XW+vDMGDgl4tH2cLxZDw==
X-Received: by 2002:a17:90b:2ccd:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-39aedf77333mr8400154a91.11.1788361446270;
        Wed, 02 Sep 2026 08:04:06 -0700 (PDT)
X-Received: by 2002:a17:90b:2ccd:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-39aedf77333mr8399969a91.11.1788361445459;
        Wed, 02 Sep 2026 08:04:05 -0700 (PDT)
Received: from [10.110.114.54] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f079f1f4fsm7552713eec.11.2026.09.02.08.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 08:04:05 -0700 (PDT)
Message-ID: <d530f962-4fd0-4897-8022-c7335167f450@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 23:03:57 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/11] scsi: ufs: ufs-qcom: support ICE keyslot
 partitioning for guest VMs
To: Krzysztof Kozlowski <krzk@kernel.org>, ebiggers@kernel.org,
        axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-12-linlin.zhang@oss.qualcomm.com>
 <046e4b62-6d25-40fc-baa3-2978eb96eb70@kernel.org>
 <b571ea8a-4434-45e0-958f-20b2f83ced24@oss.qualcomm.com>
 <ff869d8a-85d1-4148-b19d-af3a70fcc904@kernel.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <ff869d8a-85d1-4148-b19d-af3a70fcc904@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDEzMyBTYWx0ZWRfX7ZtZNAgUQvxp
 AifG8W+UyH9l9NKgCAhknIhJ2GgYLMhmAjozuX5OkbBzSG40KA+MXCqOrVoVOKmA/O8Top65kmy
 G628SQTATElShBAEgaThnVNPoRpcwF3b4JXCkc/gZejwc6kP3ivTpMnwMcuhm/bLfXw7ObxdDym
 Y4pL34uNS4eZE/oualabdUqELYAhJ2TOJWssLz4ob4vQoQRrnR6k2z+AoUEWMUF2BDfkb8Dus8P
 3K7tZSn8oQ2KSd/Lv+LIac+I3hrwArCRwd4SWhFAqqPsgVOO+qKGIB4s/XIkTzeZOHlx82ByBNJ
 w2KXTDka3XMka59/+LpysqoWNlvD/1RI355LHWd+bwWXiYW/A2vOIK4DCWt8aT0KLX6Ssx6MaWs
 T8+uBZG4qinZscpMJTbZI43IaxpDiQnciZc01UVQr78YUyaudCl/WSNL4NlBVcWWYN/1qC9oEr2
 hwD45M1aurJYXoL98bw==
X-Proofpoint-GUID: ydzH9DRIfuKqmeq_TGYcHs-V-SQIXTVv
X-Authority-Analysis: v=2.4 cv=D8N37PRj c=1 sm=1 tr=0 ts=6a983ae8 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=Vihkso_W4dyqxCYGQKUA:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: ydzH9DRIfuKqmeq_TGYcHs-V-SQIXTVv
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDEzMyBTYWx0ZWRfX/5Ag5kb6M/UH
 kZ0QmsDp5w+yHvagkWVwbfAdxTf/hSmfcrruQQVNSQ7K22ep8laxPCDeOzHHpD4nCs9tvKaqRsZ
 VCoPYBoPPOIzaVJ89S3Ru5+fJLub6L0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_03,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609020133



On 9/1/2026 10:02 PM, Krzysztof Kozlowski wrote:
> On 01/09/2026 12:54, Linlin Zhang wrote:
>>>> +		u32 off, max;
>>>> +
>>>> +		if (of_property_read_u32(child, "qcom,ice-slot-offset", &off) ||
>>>> +		    of_property_read_u32(child, "qcom,max-ice-slots", &max))
>>>
>>> No, there is no such ABI.
>>>
>>
>> ACK
>>
>> This is submitted for visibility. It may be revised in a future version to use
>> a TZ SCM query interface if current out-of-band key operation in the guest is
>> approved.
> 
> Don't submit downstream code for visibility. It just clutters review and
> wastes our time.
> 

ACK, thanks for pointing that out.

> Such code IS NOT ACCEPTED to upstream, thus posting it is absolutely
> pointless.
> 
> Best regards,
> Krzysztof

