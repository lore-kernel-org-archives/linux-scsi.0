Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7D429B777
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 08:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767084890; cv=none; b=gwMFINh/b+0kcBJRkogR8gyEiEXM4/8+YLTmb9RWvBtZxjnQoXcsTYptwIxdzIGbDqGDgzAf40Lgg93BX7YhOSyw8k8WaEIKclii/df4qKv87Fq5XnXSHR/qyXUZN5i8NMBmhD7Ts3Yj7A+CShDSnJnzUGJFa2EPeDBWwkt9UHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767084890; c=relaxed/simple;
	bh=Bl+DeJiCrf2CBeBAS1CiWo6LSlOAlbki/uPTNEgYuys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZWV1e7mUgvmprpkvV90YMU95+2c8RBjMGmbCZyro67Hl4GcK1LkbNpuLGmRigbvCxfw9XPM6tK5CLpL5yzRfElAuGwdAQ06+NcBBxCB4Cx5MkLNJdw2HgacijSTHZTsE+m9YRwLG09abuCbrnBHEvP1AdJ2RBUvcSeFACGiQ6ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=B6ivizDx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bBdclQlh; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="B6ivizDx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bBdclQlh"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BU0ie3O2670708
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 08:54:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	G+jm0hl3gTRtA+Ks1l6eXl5RaxvmTc+Ph+60AjfOltA=; b=B6ivizDxWyB4pPF0
	/+vHOJ4xm93zzLc5Y2HdHroZIBUQP6pDOtUCXMMCIG0n21O19XZipOaw+WB6bmoB
	nWz8bmGzWWif20uP1BS9GhDnW+FtKA6ScLwj733380bErI3t07iZvrwGxVzaECNF
	RiQD9vP8rTrH+vGX+etV4QVBNj2yYu7b4zLcgSZiviZlPJShBJOBpU8ePfFsxDkX
	M+V6Ar5V7+rgiePVOVeu8Eb4Wty5W+Hnp0LYzw5tUj9cQI5MJmuViZrsiW2jCgYN
	2fReF1Rki2zwCZhEDfj4QRpFhyc+t8KCJPliVjJnYPXBb/OSEgsBKQTwj9LTXzRb
	ygu9jA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bc4fcrycq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 08:54:47 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a13cd9a784so100970155ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 Dec 2025 00:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767084886; x=1767689686; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G+jm0hl3gTRtA+Ks1l6eXl5RaxvmTc+Ph+60AjfOltA=;
        b=bBdclQlhAXQTXU27aJn8pMRlUvM1wAiGN7sTGZFTLhQFHqQWsNDVYsgAzEY8lETcH1
         WnBa3alSqWpE8DY7WrGK+hSfDBSKTH8xGPfXOnLQA2ZCK4iRBduTpJ8MISbMaXlxhGJh
         OdKI2/UVTeTCdW0A4CD9vZsHNvUh8ub1XHkIg/yESRpymsEgMwabSVu/EKBedqJv0ZWE
         GJ/6gVN8UIGIVpvBJOUWnZh6bN4SK8gPr5urj5q/YQemu4CDq+yunTn4QTHWtFK4Fad/
         +8ZRI1y1LC+xURBe4NFSvA9YcfbdPXMvXI8JaKP0bxsAA3cwXeeVQvW0oKcMUFFolFOq
         hlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767084886; x=1767689686;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G+jm0hl3gTRtA+Ks1l6eXl5RaxvmTc+Ph+60AjfOltA=;
        b=HoaVqelWyxjy+YH+FObpeDHTArYtkkWKyj8XCGZ6rGNAyaZ6LWzBpff5ruicQeIeR7
         K804v8MHH98xPycBtBA3+xlcNTiOTx7PBYrSCFB986Xf2ECf1v4j8atXPDMUJ67W8AQm
         bczsdFLrfyQ2Np23B+0/JBYe1Itg4e/DPMOO2xGyQ+bfv9MR5jNphJtGiScULhPnaxar
         GY7FT4ALQm7XdjAPY1+8DSDemsQBB4rQP7lA6tnv9Ky1r76Na2QPJal2oozlNlYWWAYO
         mPCsRRtKuSsFCUW73pXQnbIoMGpdL2oFN/SH5Vdle1/7q+DczsTirZfMfELiw5Azh23r
         z7tw==
X-Forwarded-Encrypted: i=1; AJvYcCW/RUQHIC4xjSAJ0jkGjlw3dtqkfieMpl0GGG7X5E2lIzBLUQWppIUI6JB15JkZg9VPIH/sDBoFmXhS@vger.kernel.org
X-Gm-Message-State: AOJu0YzSniqnA/9qLEevlOwNH78X/Y1w0uP/XlnSUkXjfzAJN6zRxO40
	7CkdGFS5SXJjl4Ged0Yq6WGymqoWzvSU1tBR1EM47JNK+J6ZWCNUyLRTAjc1g3TvVuHsUSAplcr
	nubF9r/zTUjGGTEw8sDSPlstoauCkNe91/B1wgjXEQV4XJOTu2/oNdPN6ftNFLtpm
X-Gm-Gg: AY/fxX6asaHirAYvyBoJeVU7AsF2fOB1KsYX3Zipab+aiWdSNko6Mu+IPyatVrWRkiy
	rqpRNkprrzA7lR4jPmHasbjKWR+kuSEu/od5Se2r+Artgx6TQT+KSwEJLZSQujbyjaMneBshh9i
	dkyYYChTQGPe3N0yPk57SdCdfnKaTCoXkARdnxGZO3ZbcLZaOlm8HO3op3OIdL07YGAjPUKqxnR
	ojtL/40PoMY1tELSr31gasb/rk8W2JO5X3bX+Yt6TIg+Cx5nFZsTRQVAIo5i1+IfXd2BjYDTj87
	j6YCufX7zX7Iw7nW6qyLX8T/Ed1RjFe2j0FFWb+AE6fQbCe+aR2V1R17mc86zXNEQptneykvQMQ
	mopttbCPgby4C/XybbJJon1UBCYDGX2nMpbXR9ls9J8jURMTQfBI=
X-Received: by 2002:a05:6a21:33a0:b0:366:1a2c:6f91 with SMTP id adf61e73a8af0-376a76f8349mr32847444637.4.1767084886129;
        Tue, 30 Dec 2025 00:54:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFwKOGrZevxYUTYMiPED4sj5f4L1oVz4R90Qo6k6fwfLK/YR2I/UvYs/oQV3Hcy+bokhTyxzQ==
X-Received: by 2002:a05:6a21:33a0:b0:366:1a2c:6f91 with SMTP id adf61e73a8af0-376a76f8349mr32847421637.4.1767084885643;
        Tue, 30 Dec 2025 00:54:45 -0800 (PST)
Received: from [10.217.216.105] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7c627f3fsm28310735a12.31.2025.12.30.00.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Dec 2025 00:54:45 -0800 (PST)
Message-ID: <6031d99b-6130-49e0-873e-b44d0614e2e5@oss.qualcomm.com>
Date: Tue, 30 Dec 2025 14:24:38 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 2/4] scsi: ufs: qcom: dt-bindings: Add UFSHC compatible
 for Hamoa
To: Krzysztof Kozlowski <krzk@kernel.org>, vkoul@kernel.org,
        neil.armstrong@linaro.org, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, martin.petersen@oracle.com, andersson@kernel.org,
        konradybcio@kernel.org, taniya.das@oss.qualcomm.com,
        dmitry.baryshkov@oss.qualcomm.com
Cc: linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, nitin.rawat@oss.qualcomm.com
References: <20251229060642.2807165-1-pradeep.pragallapati@oss.qualcomm.com>
 <20251229060642.2807165-3-pradeep.pragallapati@oss.qualcomm.com>
 <9d3c21ad-c265-4e22-b804-ef8c39b7e787@kernel.org>
 <26bed077-8450-40ec-97f3-50b7771e4c9b@kernel.org>
Content-Language: en-US
From: Pradeep Pragallapati <pradeep.pragallapati@oss.qualcomm.com>
In-Reply-To: <26bed077-8450-40ec-97f3-50b7771e4c9b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 8UgO5OOAuJ3zbuTK3ZM7abwfKv247vBp
X-Proofpoint-ORIG-GUID: 8UgO5OOAuJ3zbuTK3ZM7abwfKv247vBp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjMwMDA3OSBTYWx0ZWRfXwsW8FucnzM3o
 C74TMZrZrxtob274/zGEfDmRH9SN8Fi5GQprtiEbWFHOEm6Q0WMxoTQ6Tv74OIfNmmZEwf0yZel
 ROqMrwrtrGE/7IUlm8A0YwZsqi70aMhvwBA7ljZfy+Mvp9c8q21ZDJ1BVEdkIzWrawAJXCYyzHP
 cc+aye35v/dn7SB1m13cbs+11rYgDsfQwOaO8EUgARnpQiW1G8anxb2QrSnhfmfrbGnbJthn3mS
 g+Ycm8s1FI/S3/cKyluUsVbbv4LbQCSTgpfn9PbHbFbspW/z0GyyS2tZl2B9TvBihO1NYzBr8kz
 1Hw+SeCNmJskvW8N47sOPKlHPPjl8r9iwaRWJtgx0JNGSjXgf9qxu6sv43KtWEH3GAsvBSlVlpO
 1qzFQg/rYas9PV5fDzLEKVP02il3aSg8olD0Ncw1+nmj3W6yEqXCyBcQP5soCym4U7maPMeyIw+
 YxE3HulkBD248X6RGOA==
X-Authority-Analysis: v=2.4 cv=foHRpV4f c=1 sm=1 tr=0 ts=69539357 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=uKld1MUROoZiouImdn4A:9
 a=QEXdDO2ut3YA:10 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_07,2025-12-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2512300079


On 12/29/2025 5:50 PM, Krzysztof Kozlowski wrote:
> On 29/12/2025 08:13, Krzysztof Kozlowski wrote:
>> On 29/12/2025 07:06, Pradeep P V K wrote:
>>> Document the UFSHC compatible for Qualcomm Hamoa SoC. Use fallback
>>> to indicate the compatibility of UFSHC on Hamoa with that on the
>>> SM8550.
>> Same problem.
i will update in my next patchset.
>>
>>> Signed-off-by: Pradeep P V K <pradeep.pragallapati@oss.qualcomm.com>
>>> ---
>>>   .../devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml          | 6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
>>> index d94ef4e6b85a..3b5a95db7831 100644
>>> --- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
>>> +++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
>> That's older devices binding. Why would Hamoa fit here?
Hamoa is leverage from SM8550 which is a non-mcq target. Hence it would 
fit here.
>
> ... and why even bothering with testing this? Every internal guide tells
> you this yet you sent it untested.
sorry for the inconvenience, actually i made the proper changes but 
missed to amend while posting the changes.
>
> Best regards,
> Krzysztof
