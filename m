Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F1C2A1BA
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992368; cv=none; b=sID0DxkuMZPcVnGBlLJ/LhwCoCbra9Hx1TpCR4HT+RhV5PJ45QXCIuBjE+z+YaHNX8BZ4v6oos3lyVWy4mnXQJbl3sjemf9IsQeb2gRLoUxxqHzmjDGK9lqmF/mHV+GhLDxbH5HmVl/DffMlIrgonMvlm/bMxTXREVRcciadgm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992368; c=relaxed/simple;
	bh=UArFT/K1nPlTDJiWQnFIAlmXUzoFAJFWuniA93+0gjY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HBUcNv2O+jTAE9VDJF5Z3MIoKLbmIZHBuU15FJLhtxcQ6MnlgyyAl3cerK3Vz9iiuKizJOSfiLrxvltYkVFfEWJe3+gA41/ly6mTcdjnIlj33w8ds/HbxyowAgiVLOvauMxPwdiUbrGaSbbS5QKeG5XU1TNV2puC4I8EDYTs/Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cTmkHCVv; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cTmkHCVv"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 568AAbB8031796
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2025 16:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TA2vLnQ8qEkrvWVMIaoxqMeWoxg9A2VtG7hX+L0UhSQ=; b=cTmkHCVvcKn7KmjP
	7aMsur5qvUNzNcXqRWKQ3FV1m5RYptT7LdRBfTtaj45/KLhRVEyYLEG0kLFrWAOh
	0Pn6paAxU214tf3LYovk2Jg2NB5vFwuMedDWPUNNryTAGfg5eSX4zQRG2IFwYSN7
	eDb1XKxVwXvIbttCAyop2q2fAMfRzC3CAR/wnG8JzyG6w1QbPdMlHBKkpJWxwFfY
	t6vpaIXXlcA/IkHTWLN1JB1SQFJrt+UkwOXtEZtcM0czUgzxUtZkeSwY+h2tSTHU
	ScHaXq0Id1RM5kRTq+I9hB7jVHKpiRvKJBqpYg9OYVdADtpLJ3zXjcM9ydDLFeDq
	Y+HtNw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47pw7qq4q8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 08 Jul 2025 16:32:45 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7d41d65f21eso34937285a.3
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jul 2025 09:32:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751992364; x=1752597164;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TA2vLnQ8qEkrvWVMIaoxqMeWoxg9A2VtG7hX+L0UhSQ=;
        b=ONz+RUPMlINiuFvWZRdEGYxKsPVNvJNspEUiiG/gequ/vq7neobjKmqF0oCqxJuaIJ
         0qr2HOUD6Hk8avyQw615E3G6qn1fUF2ZvydV0Fh9RQSRlSWcPJgyLrjIlU88PE0fDeM6
         Iy/+w66rF13H56/ct2EqMyPZ/7JmKlZUEBUaE0k4+iNb5MVF/YG3p5hTsRZI8cMI3wHD
         Kskufr8EpqIUamV4bx4AN2UA7DqKeZ0Qek9XG56OPiVd8BEHmBXzVzWvtApDf47C3Dcy
         GnSgEZw8uLPN4eoOxRRMJPsQN9esMf+qDD6eXh7JzxaY3hsLlBNzaMSsSoVnquPIAToN
         BaBA==
X-Forwarded-Encrypted: i=1; AJvYcCXIUFZWkGQAIa+KeJUZqRVJ1X28udQRxV/RC+NnX+EjIcamjMBkwaAwO3Ovu/8ao+XNHKSFCAP3AZo7@vger.kernel.org
X-Gm-Message-State: AOJu0YxTEZ0GO0e3GsmAHyB7u3n/VJflVzSXlW/caz6HGS349eDdfUbE
	4DsRxpQVOJzHwFml1t22AMMEI2bcWI9K93ozxaaVjxiSeoyk+H+GXgY1RXIJ6K1cSUOGhgHuVng
	pkvF7wCsmnRGPxB+6HrkGvbC/dqjwSorXgh0DAWGbKDcmM+L8Be2Zj7unqrwv1vk/
X-Gm-Gg: ASbGncsufeM9Yv3ycpP1g0Heg/gi+XMXyu8UCGW5gYh8sRdfIWp0vjoBOWhUvcnEVm+
	3E9oLzCXGlmht7rY0Hp2bcxQShbID2kZNBEAY2nvQ3cGniu6fudkgnAJmG82m/H483lmYKGXuPr
	qgV7Vp1UqXvAzYVYUXKCsab95/9LLam7UYUmfH43X5Jq7/mIh3wK8geTgsO/SGsAG1bmAHtHgIw
	R7hiJ0NHxn5x2tZ2PMqMwmnoDX897If0EPL6mdLY9u3WFd6gOO8RvSmjl08tr5hB3UfMdLhEm3S
	MuxnOldMdFHdoExfTFXKN/JXV8BSLVwHv/fyIHNkeGJKs+sVRKj8HfQszmUgzOt33I0oeDdk6Jt
	NIyw=
X-Received: by 2002:a05:620a:4710:b0:7d3:f0a1:2f3e with SMTP id af79cd13be357-7d5ddb31bdcmr940387785a.2.1751992364316;
        Tue, 08 Jul 2025 09:32:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsCFvoBAs8YJH6fp9eQtKsRuq1lo2bD+F8rQZPXJ7oJTlCEQ7nv7k9KIkw5nPgH4kxOBgd7A==
X-Received: by 2002:a05:620a:4710:b0:7d3:f0a1:2f3e with SMTP id af79cd13be357-7d5ddb31bdcmr940385985a.2.1751992363651;
        Tue, 08 Jul 2025 09:32:43 -0700 (PDT)
Received: from [192.168.143.225] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6b0336asm923512366b.115.2025.07.08.09.32.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 09:32:43 -0700 (PDT)
Message-ID: <e99c8094-68d2-490d-8ffc-53b601449b08@oss.qualcomm.com>
Date: Tue, 8 Jul 2025 18:32:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC/RFT 2/5] ufs: ufs-qcom: Remove inferred MCQ mappings
To: Manivannan Sadhasivam <mani@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bart Van Assche
 <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Can Guo <quic_cang@quicinc.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250704-topic-qcom_ufs_mcq_cleanup-v1-0-c70d01b3d334@oss.qualcomm.com>
 <20250704-topic-qcom_ufs_mcq_cleanup-v1-2-c70d01b3d334@oss.qualcomm.com>
 <7cdpetp3fuxpu2eeqctc5f7kytfpvoquopfsr7ea5non6bo74z@pu45jowjzwrt>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <7cdpetp3fuxpu2eeqctc5f7kytfpvoquopfsr7ea5non6bo74z@pu45jowjzwrt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDE0MCBTYWx0ZWRfX1azZKzwwSytb
 F4WLGr73pZPOrebkB10Y3EOoVRah6eh2pIYgMHuWSDhOsb/STIFioFDkkkU48BVWuX5bOwNpvSr
 l3sPE4HaD3WzTsW8LwRh/WJ3JhU+zTjzyU7G9CEcuekPSECzJ4gDGVl8E4dU/LuFg+VyM6ZTf6I
 AskJgPqi2NexvTKA7fpSINMXEr1U8kWSNmVDBsFIipEMBAWr2CDLyWjRW5j7AWIsXo1DdThuLan
 fY3npjBEurAIQyxeq5eZ+fiJE6Hn3DqCj6olGl+35usatjVMIuLguHMVkh12uQeIzY3KS8Fjoap
 fVj0O81V7Z0fTEMQrOUuQLyP8GURPCHHqpha//P+EVZqCDCNbW9ZbQplzqEVhwtGXUU7ScTos7M
 qc/lkJtkVA2geTLYjcD8R1NDRIG0K9uvXwAoMnrfXPqqxQCcGxq4sUn+XINmZzZEEjUQYtDO
X-Proofpoint-GUID: TJM52zMpSpaYYn3Rkd-8juvsv91d1MQr
X-Proofpoint-ORIG-GUID: TJM52zMpSpaYYn3Rkd-8juvsv91d1MQr
X-Authority-Analysis: v=2.4 cv=SOBCVPvH c=1 sm=1 tr=0 ts=686d482d cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=EUspDBNiAAAA:8 a=keaFY8-lOGZKNXLQRCcA:9
 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_04,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507080140

On 7/8/25 1:13 PM, Manivannan Sadhasivam wrote:
> On Fri, Jul 04, 2025 at 07:36:10PM GMT, Konrad Dybcio wrote:
>> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>>
>> Stop acquiring the base HCI memory region twice. Instead, because of
>> the need of getting the offset of MCQ regions from the controller base,
>> get the resource for the main region and store it separately.
>>
>> Demand all the regions are provided in DT and don't try to make
>> guesses, circumventing the memory map provided in FDT.
>>
> 
> IIRC, during the MCQ review, Can/Asutosh justified the manual resource parsing
> due to some platforms just having a flat 'MCQ' region. So they ended up manually
> allocating the rest of the regions based on hw capabilities.
> 
> So there is no such requirement to support those platforms now?

I read the spec pdf some more and I think that this series is wrong
(but the current state of the code needs improvements too)

The "problem" is that *all* platforms have a "flat MCQ region", because
the UFSHCI specification mandates that. We have a block of:

----------------
| SUBMISSION_Q |
----------------
| COMPLETION_Q |
----------------

register subregions, repeated 32 times, each block being 0x40-long in
total. They're at a fixed offset from the UFSHC base, specified in
MCQCAP.QCFGPTR inside UFSHC (i.e. ufshcd_mcq_queue_cfg_addr()).

then, we have an equal amount of

---------------------
| SUBMISSION_Q_DAO  |
---------------------
| SUBMISSION_Q_ISAO |
---------------------
| COMPLETION_Q_DAO  |
---------------------
| COMPLETION_Q_ISAO |
---------------------

blocks (although these are allowed to be placed anywhere). For
reference, the QC UFS block looks like:

--------------------
| UFS_PHY (QMP)    |      - 0x4000
--------------------
| UFSHCD           |      + 0x0
--------------------
| UFS_ICE          |      + 0x4000
------------------------ # "MCQ" start
| SUBMISSION_Q     | x |  + 0x20000
-                  - 3 |
| COMPLETION_Q     | 2 |
------------------------
| VENDOR_SPECIFIC  |      + 0x20000 + 0x4000
-------------------------
| SUBMISSION_Q_DAO  |   | + 0x20000 + 0x5000
| SUBMISSION_Q_ISAO | x |
-                   - 3 |
| COMPLETION_Q_DAO  | 2 |
| COMPLETION_Q_ISAO |   |
------------------------ # "MCQ" end

(at least on SM8650)

So we can't just map the whole ufs-adjacent region like (I would
assume) the spec designers had in mind, as the ICE is expressed
as a separate device and we don't want to overlap-map regions.

We could maybe map the MCQ region in its entirety though and rely
on fixed offsets within it, promised they won't change with the
next platforms.  I would hope that's the case (so we could simply
mimic what happens in e.g. ufs-mediatek), but I'll ask around to
make sure.

Konrad
