Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22A21C5496
	for <linux-scsi@vger.kernel.org>; Thu,  7 Aug 2025 11:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754564822; cv=none; b=R9ci6I6b0CzxERBEuctFVwghEUHUxzuzjPSSoCxiBLD3ataVe9sMhl+eCgfiXoqXwEbZ9WuwWvnK87g8djJrAIoofmPQ0TLkLIYK/OEKzEGZb2W+PS6ZZVQ85Q1vstN3Y/skYoiUpAr20AeHLMESJqj0NP3d1nVLbEeNzxcKg5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754564822; c=relaxed/simple;
	bh=PWMkkhnX3vvqhja9YC5lzWekDzBqHRpC5OdRu/UEuqI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EoWb46LYdL8SsaLhWlO+ycVX8LjsNPBC3yqpK88ROsjWjBKepeMme3zyrK6jxv53kXcP6QsuR8yPhxLnfs3g3ikQoyeSXD1lN8bw/hc6JaO3hCYvEzfIOb8HgKoO8c+dnr/vMW3PzxN1/XH+BqDYVYIBnNCQCr4KMI8UaF35th8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=OP38KEdX; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="OP38KEdX"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5779D699008394
	for <linux-scsi@vger.kernel.org>; Thu, 7 Aug 2025 11:07:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	x5nNUQTMQ5AyDnKFFuuhfLnqvTm7neZssafyF8/oIwU=; b=OP38KEdXJyCzC8Uq
	eIQU3J5VlSiIv2cpj5hkLeTVBKSn8ssG1ncPfxyd/LqpavP1fZztoIlMDyoC/aAu
	iZXkoQQnd1PvRy2NE1MP/wLyU/fITiAA1O7FIO3ijqBKBRjoWL0CKsox2KYAjy/v
	Tn2vxGYIoMpCD5Z9yxSUngA79091COMdcMcZ/cOW49CIfkZPS3DvMPKOrYyRqZXH
	d4czasI8vQzPTAaPQR57H7M83qflq/xRHWYUgxU3qZ++TL70qadZD64itgciq5ft
	mAfCWGwcvFkH/vvbWvvNmezc8FSWeZftlqWNg1BOP0DChJkOfQ2dJsTLEHnfQqUb
	hI6bUg==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48c8u2325e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 07 Aug 2025 11:06:59 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b07ae72350so1654121cf.0
        for <linux-scsi@vger.kernel.org>; Thu, 07 Aug 2025 04:06:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754564818; x=1755169618;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x5nNUQTMQ5AyDnKFFuuhfLnqvTm7neZssafyF8/oIwU=;
        b=YMYb8w6iljetKkTQ/E1hg7Clxi0L2xrVfI2C0D1+QoXqIApZsmojkQ+++hhHQFSeI8
         qLWpDWPiqNWxH0/zD13NwshkcsJuDLOEgnBCS3b68dmNJjsLHoOSFrVUaeF6CFiIdQzB
         7UtOzEZXs640p9Ax/jBYmwl+E3FQ9apYHh1A+L6lz4HnRMizMDYGng4dePTvGTrlAs/G
         Hja/TMUe9/13MtnCegT2fVijRx8E99QhupyqpNYaDhOGeghTrGaTS6VP1sQafrAc0kgB
         IokN9SHRZ1Ogw1wLzcZXII0mpEdHtggNwDooGMJXwX1UQZFDDpcVj4CdOfJl9PByD4Fp
         aL0A==
X-Forwarded-Encrypted: i=1; AJvYcCU0HZVmFSCNPk3UTZX7wmjdZF4utJlAKmLuV+EfChRzn+pzHMN8Y9/kPcjVJ8+V1rIQVC7TFZ6u2ok5@vger.kernel.org
X-Gm-Message-State: AOJu0YyGJhZY8+E/ei3E/XQzx5qo8bNyFASfV0ZcT+pe2E8//3NkS/3n
	BNBq+YAEcTzlpfdkULFSXXHybqXv3RTU6Ef7Z9XCBmu95S23hMErOcGiCKojfufh/di65TfUBMG
	7KMmzujLi2xljhiRQjIvn/iVo3sm+IW69L3o/5ITxOTTUQwLdwQ+2s5ZY07rZhPSN
X-Gm-Gg: ASbGncsGg+hP+bjjhUjEq7cAnaXoz3mmWUA4qbxq3x8hId1NaMjHIgMizZin4QNn/xz
	DOgtb37xkutb+p6EOR2cNsd4/QeVw/ol08QmVnw3duk+C28HVCw/LL1dWMM5AeNbtONgL5Rc7z2
	f4aHKnnNbN3l7lGJAoOYtB+FXQ9hxzD8EBLtxFj/Yu3JZlkuwtMzH1Sd7Vik62cP3aBnMMJb6Yn
	uJcy1QrSbjVMUEyaGuzCr+APkBOaCgg7XX5egVebAqWPh+c++V2kxojHznb/xe5UQq2HFhQyQSC
	QslqFKcyipbM+AfpLupmH3snoK2YQgLtCAfArLPibGTngNetZsYZXAFUyQFGVFh6/XUGoAVyQDK
	1xq5SNGpVrCg7lcxg7g==
X-Received: by 2002:a05:622a:d4:b0:4a9:71b9:188a with SMTP id d75a77b69052e-4b091414bfdmr47817221cf.6.1754564818489;
        Thu, 07 Aug 2025 04:06:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFtc3EdN6HJ63OQb2yikwP4G5bxIWwDho2uGzgH9L+DpH3bfGDc/21pGOHr/8IdD4cEtKr8g==
X-Received: by 2002:a05:622a:d4:b0:4a9:71b9:188a with SMTP id d75a77b69052e-4b091414bfdmr47816921cf.6.1754564817979;
        Thu, 07 Aug 2025 04:06:57 -0700 (PDT)
Received: from [192.168.43.16] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a22057esm1281409966b.115.2025.08.07.04.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Aug 2025 04:06:57 -0700 (PDT)
Message-ID: <4aaa09b8-e944-4d66-a681-a3659fc203cc@oss.qualcomm.com>
Date: Thu, 7 Aug 2025 13:06:55 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: ufs-qcom: Align programming sequence of Shared
 ICE for UFS controller v5
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Palash Kambar <quic_pkambar@quicinc.com>,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_nitirawa@quicinc.com
References: <20250806063409.21206-1-quic_pkambar@quicinc.com>
 <ucr4imzntw6ghcvpeioprmva7gxrqnkphjirjppnqgdpq5ghss@y5nwjzzpvluj>
 <c62c2744-0d07-4fe8-8d2a-febc5fa8720a@oss.qualcomm.com>
 <mhridnexscaevsmssu6k3l4x276cj63gl2rlvypym23kj2kgov@pw323zkhqcrg>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <mhridnexscaevsmssu6k3l4x276cj63gl2rlvypym23kj2kgov@pw323zkhqcrg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 818rvNsAA1sSkdQBaJ_F2qzjgb4I6kyD
X-Authority-Analysis: v=2.4 cv=Q/TS452a c=1 sm=1 tr=0 ts=689488d3 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=COk6AnOGAAAA:8 a=ftMxJ0LbfJfX_HPbJzQA:9
 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: 818rvNsAA1sSkdQBaJ_F2qzjgb4I6kyD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDA5MCBTYWx0ZWRfXwvDLVwREu/zZ
 EqxblTvNc4YsVnCYABkgxjylQ5hAkUJ7x065WFp6zAYx4e1z2CrgX8q6QQXA5hjCJBP7GXOby9w
 yvTReGY1FVPmsIRJ/3y162GJxkac/ik3BgPZJHObVJ4RZb+ZKjQsxbxLQY2QEJ9Wq1Bz3U17tKR
 J7dCK1un3rB415kJpHjURiPbq/9rzsiodal8zEmdEOimGG5dS7EkdmBa3U/ibnUPbfReaofRlm0
 gP4WZo3ZFS2/Z2NxMxlM8SAPLAjOdRLPlwQeGpzTBFeplYaO/pCJy9YeBkzo2IyLMAE6fNNrLOx
 ZpMGizSPH0MZrnUx/KA0fe7sP7/KqFfU4njZVtBqBp2hhxLHmvbFtq0jFAVbHDrG8ZYBPuvAfGs
 RlFoxZ/3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_02,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508060090

On 8/6/25 7:39 PM, Manivannan Sadhasivam wrote:
> On Wed, Aug 06, 2025 at 02:56:43PM GMT, Konrad Dybcio wrote:
>> On 8/6/25 1:14 PM, Manivannan Sadhasivam wrote:
>>> On Wed, Aug 06, 2025 at 12:04:09PM GMT, Palash Kambar wrote:
>>>> Disable of AES core in Shared ICE is not supported during power
>>>> collapse for UFS Host Controller V5.0.
>>>>
>>>> Hence follow below steps to reset the ICE upon exiting power collapse
>>>> and align with Hw programming guide.
>>>>
>>>> a. Write 0x18 to UFS_MEM_ICE_CFG
>>>> b. Write 0x0 to UFS_MEM_ICE_CFG
>>>>
>>>> Signed-off-by: Palash Kambar <quic_pkambar@quicinc.com>
>>>> ---
>>
>> [...]
>>
>>>
>>>> +		ufshcd_readl(hba, UFS_MEM_ICE);
>>>> +		ufshcd_writel(hba, 0x0, UFS_MEM_ICE);
>>>> +		ufshcd_readl(hba, UFS_MEM_ICE);
>>>
>>> Why do you need readl()? Writes to device memory won't get reordered.
>>
>> I'm not sure if we need a delay between them, otherwise they'll happen
>> within a couple cycles of each other which may not be enough since this
>> is a synchronous reset and the clock period is 20-50ns when running at
>> XO (19.2 / 38.4 MHz) rate
>>
> 
> IIUC, the second register write is just reenabling the mask, so there is no

Yes

> delay required between these two writes. If that's not true, and if there is a

Yes

> delay required, then do:

We don't know if it's required, the HPG makes no effort to clarify it,
but I would expect it's probably not instantaneous


> 
> 	ufshcd_writel(0x18);
> 	ufshcd_readl();
> 	usleep()/msleep();
> 	ufshcd_write(0x0);

You'd still need the second readl to make sure the de-assertion has
gone through before proceeding

Konrad
