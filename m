Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2FE837B01F
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 06:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784010708; cv=none; b=o9lund2Ev87Uc0oh//EEMBaZWl77cY1KYCqRsAmhHA+VNiLKj7SK91FrMsjitUkfy/UqxGmB/t3aWT4jvSHXyeKOpi4aCMNy2cz6u6jVCYXYyVrmDpwgI/mzh25Mu5t+OEGeq6hnN2MPe7yWmkryHuBu919/Z3l3rg5JH7kGh4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784010708; c=relaxed/simple;
	bh=M8bbw3hB1QccYW9YyMJ2o45p5E7zrrSy0cxjuc3xWXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=egMTxK+60/JxNTm/0uAyL8U/mV/5gkI9Y4ZmtAXWEDnUebOSyh9QdCBYY0glcpRUaa18KS1zk3q8gJEvi/jJNWnyOK/Dci3a0wc75IRs9PjV8SnDskjLZnkCG1sZTg0DOdEwoWfUhsEVE+ekZ30eow86Wkgc7EYFVV1CIT32lrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SgiGSxLE; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TQB0XXHW; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SgiGSxLE";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TQB0XXHW"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6SQUe3912687
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 06:31:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	LvbBLSiulMwfLH+VelHo3jpxmqAseAmLVR/do0Gwl5c=; b=SgiGSxLEkh6wlKdE
	txnd5TiPysv0zl5dieSRzInRXzIxl7ia+wjPbPDNYZsCZLkxlYIwXOiUYqlqrvXR
	U4o3UIzhLonPcrDPuJms0xJGIjvqfPbkr+c3RfPNQKqV8E9hQO4eqWw2dyuL+Mo7
	P4YrUwTA5EnjCPXr/2tP7Rqj/6m7scI03Zz/GaQaJxgJ8bN8pFEYOxLISC5fpEwA
	G/bxN5F/2IRoqpMdxpzoORtq3Tj98muC/A1zOTGu+d7qxRUfjeoKDlPGYxuckeWY
	3QizUFFCN4khATa0YvhdSyEzhasxkRCKG3HhlBr2u78iUN9+h2XsfHvyJKNoKuV+
	DdSM5Q==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fdeu4g8rn-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 06:31:45 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cc73f47bdcso69383045ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2026 23:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784010704; x=1784615504; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LvbBLSiulMwfLH+VelHo3jpxmqAseAmLVR/do0Gwl5c=;
        b=TQB0XXHWtWgee6NgEQiNkOcJZ1NrY03V+vU/H/TnRuKi/75SxzhNwuROxWYsNbm1wU
         cA52rXnUPTkScFzwYhRGrviV5ORNb1xv1zWdYqHk92Yzt7DyjcSeodriOP2jyDsxJleG
         tSLBcWRWVK3f0HrjdlV2/6dBXDSBKIbRz20YFPnpFf9r/vdEtREapha9tnySWhYqDA6o
         lFrovkrLZWaNafwAiC8IB1TVS7Xm+jdZCQjHr9vf41+eS4Sqd4ZbzsINCIN44CaU5kKV
         TznEpH4pqRUekty8L7hSNVu/p4NbUYNILH4+FRjm66iIcNdhnNfRGNCQzcH/RU/sP02e
         K5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784010704; x=1784615504;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LvbBLSiulMwfLH+VelHo3jpxmqAseAmLVR/do0Gwl5c=;
        b=nu36wSXzvwu45xv34rUBksL1zmEalAhlJv//dNkI06glS/glko+3Lg+XcOh13r9o7v
         mEWxmnBOoQxpddOhBDa46RUQEGbWuOdNF+YguM1ajZwvTaMOsC+wsXOvy+UTMGiK+ALw
         DIMNBfu3D0XRL1z0EpYQcvmHSK96mAgNeYrlWJKs4ZYQuGUIyCZcQsp3FHlj7cBkIQW0
         oXxeq7LXbQ7uwF2tw57+s7oGuDMb5VpMU4j9ahZtFFrkZcr9wisDDfHXvMQYuWf33xmy
         xcLS43ZGSIZx/Aj0pQZZ+GjTqpgDd91ES+S2EB5/hxol0QR8rPPH5R2GZfG9VQCwhJbG
         8d5Q==
X-Forwarded-Encrypted: i=1; AHgh+RqEWz7EOE+926PRK1Gjf0FV0EkNH95x2st0YpVzm0AQtAEKp/AjMqOEabf2l8MLuLadBDTogpf9kqjK@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7QQqTBQVIsUtGS20GW90HhKXNZ9GPrFF4vjRCHCvegO1n4G4b
	kW3h9T7fMDJR2w8ZIYjT5SYGilwSrOkkj5kQLFhZ1soBYYU6rCNh0Ojj15pkqd6C8l+fdMzb3m+
	sK05/8fX1TXwLSwvi0C8mLnVys+U7sVzr8fxH8MGe130d9ygoB9eZ1E/ziec4zeea
X-Gm-Gg: AfdE7cnGBCpnVM4+/DfhIsx8dVKedM4XVwI9q8FhJSmJImmfDiMUcDYbvj05VNHH3W0
	asqlrQ29gQW/UPM0/Bsk4NLrpforY0DT6dKSTt/SBcSFnPYtxVSyWxjR+LdT0vN9cxqng98y70V
	1JElQ35A2TbfsNgoY7gp1Xdhl7sQ2CfJB8qrv0Fu/oD9ESBeKt7OcKyAHEP9AtUK0JdKa5Tzmur
	j2Ylb4I/At2ZaoRoheBfpIOUQ9VU/zqgTXSSssQt5+1eQVuJOoK9fEdKw/ibxKO1fRicO+Fz02E
	fPtjllQ9CkN4MwEHp0C3J7YW93xV15a5NYn4TfeOMiMzMoF65YEUPfHIhn5I81OOF7GwkQ0AJ4L
	8K9EWa/qod9GS4wP3Z6QaGysGkc7SD3ZkJck2TA==
X-Received: by 2002:a17:902:f60a:b0:2cb:14b3:4cfe with SMTP id d9443c01a7336-2cef14eaaa4mr12590575ad.45.1784010704438;
        Mon, 13 Jul 2026 23:31:44 -0700 (PDT)
X-Received: by 2002:a17:902:f60a:b0:2cb:14b3:4cfe with SMTP id d9443c01a7336-2cef14eaaa4mr12590165ad.45.1784010703989;
        Mon, 13 Jul 2026 23:31:43 -0700 (PDT)
Received: from [10.218.7.247] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ce95e001b1sm54470675ad.66.2026.07.13.23.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 23:31:43 -0700 (PDT)
Message-ID: <8fa9c1b4-9a42-4c46-9c44-520e79540819@oss.qualcomm.com>
Date: Tue, 14 Jul 2026 12:01:36 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1] scsi: ufs: dt-bindings: Document the Maili UFS
 Controller
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: krzk+dt@kernel.org, robh@kernel.org, andersson@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, avri.altman@wdc.com,
        conor+dt@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260630220536.3803984-1-nitin.rawat@oss.qualcomm.com>
 <20260706-curious-festive-ringtail-dd8fe4@quoll>
Content-Language: en-US
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
In-Reply-To: <20260706-curious-festive-ringtail-dd8fe4@quoll>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: aIbEr8Ji2BKewlK87DadZ3ztmu-uCBbN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDA2NSBTYWx0ZWRfX5LAfzIgaJbnc
 /2EDgpjvNuNDyr8IL0KDHz2at7MWuWbzq1nKk4Zgx0zIwDzrYSHH9YSzIytFlCq1IVlExPR4Cj5
 /DyLfuLrY9ArD9Vf9XhBmk7LAg9Df7tNZFLMm3wAku2EsFoQrlAac2knFMSffsGjvspvRu5Xiex
 bVjmTEH4ToxF5wpwWHfTmZ9/Ydo/A2ilxbxy4J5+JLetjF/EEmfpV0Ka2oM8iFyd67CcVc50iUF
 My27UystQ/Ud+1AQl+t5w0cG9PmwlP85nn85gnu1fiqF8QKSOV+FhFkTSNZ0iRzrsAv0ajqOMgK
 Ug3WpI+5M6bqRyy4elbDxtn8z89dc8kUqD0avkARXobvWXqEb04OvfG9c6mJHEhQ2Unu4FExz06
 4uI5Fy5VGfTynLe+h1fdgP10LH1PJy/yl3bCRVoFTUw8IBIr7Pq/2G9NWDbCsC5fJpt++0YMPk4
 53C3Mi2M8qIJqG3SZEA==
X-Proofpoint-GUID: aIbEr8Ji2BKewlK87DadZ3ztmu-uCBbN
X-Authority-Analysis: v=2.4 cv=cN3QdFeN c=1 sm=1 tr=0 ts=6a55d7d1 cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=E5xm5Jb5eINjpAnLFd0A:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDA2NSBTYWx0ZWRfXwO5jQ2jWG0iD
 ptzYz4JdkruaHbJiYVO6iZeFA9Cu7i/0oj03xBQRZsd8ebTN2zs7nq0UbnZrJMI2jDbraODglmW
 qJ52nB25gKvOYBOkw2/GPUfvQChlsws=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607140065



On 7/6/2026 12:13 PM, Krzysztof Kozlowski wrote:
> On Wed, Jul 01, 2026 at 03:35:36AM +0530, Nitin Rawat wrote:
>> Document the UFS Controller on Maili SoC.
>>
>> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
>> ---
>>   Documentation/devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml | 2 ++
>>   1 file changed, 2 insertions(+)
>>
> 
> Why is MMIO address space size flexible here?
> 
> A few previous Maili bindings had the same problem - your Claude vibe
> coding just looks at one piece and you do not review but trust that LLM.
> 
> So again the same comments as other Maili bindings.

Thanks for catching this. Since Maili supports both MCQ and STD register
regions, I'll add 'qcom,maili-ufshc' in v2 to the allOf condition that 
enforces minItems: 2 for reg and reg-names for MCQ targets.

> 
> Best regards,
> Krzysztof
> 

