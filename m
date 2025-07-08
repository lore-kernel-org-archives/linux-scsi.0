Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBC62E090F
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jul 2025 15:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751988408; cv=none; b=E4721vDL11Yv2xhw9Z4Ckze95GzSt5m7a6M3WtVEoM47P2GwFh4543tVLOVBn+kO1KsUrkzVPNvPDwMfnvx7ZhesSNlpTfSQdwVleP5cxTTEQJkoSqlyPIb1Tq4dkVZAxhLQ7k7fS3HVwmxwUZw2dw36LE8sJNDOlkGjVShQfLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751988408; c=relaxed/simple;
	bh=gnFcMWECjh8hfQ1yd2SfwpGlHMixNNs4Ef61UrfZ4Ew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HcGyZyH+4dN7VRi+cbGR3S1Dz0oDcrQlY+eXzNJ6tDN1SgwVmhS/OcSNc4d+zMyWIn34uc9mckcH3dKrRjCVi/1vyFwbHhRCjDp/G4NwtiHupdLIUjJRz+Ti4KDwwRbVSyAZkaab0BmjKAFzvKAdn7Z8eHT+dN9WtGyXRxJyulc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=f/8PXRlk; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="f/8PXRlk"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 568AAaiH032649
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2025 15:26:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uJ5c4Ex4V45uMVfmn0t7vnp2Sk7utC6FuBuCA5pmFFw=; b=f/8PXRlkFNlBlCHp
	WrOESPyefV136IgZp6GGYZMhFvcuUHSleRcq8k5UVr2eeZvnXNyHTy9kZ+lSV1lL
	ZmwprIZUtHF9f/iRw+bgTdrMkimobRdrkF6PJnmD9LD/KJC1KmkQDWNqYMd1wUhm
	cJB7cz36C/6HxAPNJz1kC9tnLWI3g7Fgu5QJkFJLVE02x9koCMtCkuAZ2RUHULyN
	sxzPlHw45raust6sGM5jBsavnl7KBhFNT5oMjGuJCkHbMaJ10B9x8CprmDzCCmHj
	kRXqDwLQ9/ktVVTYM5DfmTpfDUyuuhMAd+OGh9dJa053cFz2KxmbdEv2mC+6PnDN
	b04qkg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47rfq31ff6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 08 Jul 2025 15:26:45 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7d09a3b806aso40946885a.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jul 2025 08:26:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751988404; x=1752593204;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uJ5c4Ex4V45uMVfmn0t7vnp2Sk7utC6FuBuCA5pmFFw=;
        b=G235qlOBI2bw6NhuYStlg0IKtfKvqs3IcSBGnCwmqMdQWLS48fvuCh4aZDgY7gJG6m
         Jv0YFb3w3G6ZoqrTNEd2v03pH7eXPu/xvD5glQhmHIiSSRVKLIXf8He/x2on2iqt897E
         zxqBj6DANiOwddZ1xUxY7NIxBIKcomTIyW4XQ0GRcnRDM9i4KWtX0ys7OJx7VF+IY/35
         PqFOfxgNrs6cOkLECHVYoySvwJIN/cookanmr3kAwq6Kgqr4Z7UqlfjqzcENyx1IG+rx
         P5/SAApQhDtcuV1Dqo0t1eUN3xDtR9r6tWwqCg3R4nA6ODP41+nwvSd9XpqRTFU51pV6
         Q8Mg==
X-Forwarded-Encrypted: i=1; AJvYcCWaWInfqvtSOfyFISYPXQzPIqSZvCJ7M4XSZcwpMbMBs/z2gd5JH+mfvdp59UxFrrQWtDcA355xgDgi@vger.kernel.org
X-Gm-Message-State: AOJu0YxhgRhnUzUmTjZnHnuokKYvEjX6a3gVVrCBcSad3kJY3BPXodCU
	yMEnysYjhzspIWhj8ExjGcU6iwwGXYYu6hAkuAko1lefDbi/kMMqf6/Y1mtXMWO2ea5yFb4jw3U
	v1QEz3NOjxj8SR7n4yizXCr4DdNmCeFITmiCHya28PhZ7N+eyz4Ohh62Uk3UZbK7X
X-Gm-Gg: ASbGncud/EoWbseGFdVk8/hmP4jRoBwjdTjzWSzKprMrecVdw+fSUTxKQJhvNXsTML4
	hvPAI9Pa8SGlJPuUnH6LEcsWk8UG4zsPuosOdOXthcHPy6wpk9bBGVTHcOZXPv8g1gcMb7ieLRE
	Joot8QXz2f6hkxITjIfQLPRT3Ho/ISVLz/z6n/VpLtRryr67lkUBI07Q563N07pi4gBYZseFAW0
	HZKzpu+NBg7dpuCFWNrAiciSZSWRbZ2qQQeF/ZuI3l1kebUWXdH4PrETHTfGpEm918em/1qzcSB
	XI89KSckvuDra8EXDH3+SaqKSRbJuA0Mn9nsiXV/OrJV7NJz/dPfrFkVHihpaQA5OAD0jyl7bGF
	FsgI=
X-Received: by 2002:a05:620a:440b:b0:7d4:5cdc:81e2 with SMTP id af79cd13be357-7d5ddc9bdd4mr851143585a.13.1751988404383;
        Tue, 08 Jul 2025 08:26:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHV+dx63so/JwFVhtlOU36hB2+dvDxeO07jXcJX9Do3uuZjKu3CTF/zKenMN3RLFlcDYfZZiA==
X-Received: by 2002:a05:620a:440b:b0:7d4:5cdc:81e2 with SMTP id af79cd13be357-7d5ddc9bdd4mr851141285a.13.1751988403905;
        Tue, 08 Jul 2025 08:26:43 -0700 (PDT)
Received: from [192.168.143.225] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae40eaef164sm701281166b.136.2025.07.08.08.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 08:26:43 -0700 (PDT)
Message-ID: <595c73aa-17e1-4d00-9cbe-abfff813546d@oss.qualcomm.com>
Date: Tue, 8 Jul 2025 17:26:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC/RFT 1/5] ufs: ufs-qcom: Fix UFS base region name in
 MCQ case
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
 <20250704-topic-qcom_ufs_mcq_cleanup-v1-1-c70d01b3d334@oss.qualcomm.com>
 <xujhcaw2nj7mzb4cspjsxem75lqfwa7ivnfpzccor7npdu5d7c@xad5hx4b2m4e>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <xujhcaw2nj7mzb4cspjsxem75lqfwa7ivnfpzccor7npdu5d7c@xad5hx4b2m4e>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA4MDEzMCBTYWx0ZWRfXzxRnEJPIikDD
 ETaRZ0AP7ScIX/YOsaBYqXW7rJPGIPV1vrcPgOtWWIq41YdBQ/OWiaZiNlcsskC7iuAZvVTamrX
 fF88qqFWslJRh/l0aCJHUsR1HeHUAt62Bx1UG5+ToKemLpc/6zqoBAdIvFLxgJUx/dXd/YYdzCc
 xo+OzmhKc+06gTXV5pbGy3kdc/6pFZgxyAPe+NgFwYtzvHM48mbdwJqfWruz9jYWzSW7tLIipVi
 3lwK2sv5TKgTNq2vdFkjWRtPpMZQAPokK/lfcxsjGH+sPaVCA/kd92J4zuBLG2XAbKUx9Zn+cRz
 zOKelUSf/i5jeW+6wM53hdGMIkDS0u9Z35X8LDcrglQVDXa0QGCSBATvsHIXZjw8qfA73wCE8+M
 sp1UbPv/LVOXKPDY9EnHAIt5zqBWQx3e3Iy92c8ygR7rpEQR5j4sz0NrgvvwmGXyiuuqdHv9
X-Proofpoint-ORIG-GUID: H_f4BF7qGCH-jC8evtuRPib2gGIJlWZ2
X-Proofpoint-GUID: H_f4BF7qGCH-jC8evtuRPib2gGIJlWZ2
X-Authority-Analysis: v=2.4 cv=SOBCVPvH c=1 sm=1 tr=0 ts=686d38b5 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=EUspDBNiAAAA:8 a=4yQetZYTsztc79A-kMQA:9
 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-08_04,2025-07-07_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 malwarescore=0 bulkscore=0 priorityscore=1501
 adultscore=0 mlxlogscore=994 spamscore=0 impostorscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507080130

On 7/8/25 12:34 PM, Manivannan Sadhasivam wrote:
> On Fri, Jul 04, 2025 at 07:36:09PM GMT, Konrad Dybcio wrote:
>> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>>
>> There is no need to reinvent the wheel. There are no users yet, and the
>> dt-bindings were never updated to accommodate for this, so fix it while
>> we still easily can.
>>
> 
> What are you fixing here? Please be explicit. "std" region is not at all in the
> device memory map? Or it was present in some earlier ones and removed in the
> final tape out version?
> 
> - Mani

I simply failed to describe the issue.

As of today, the MCQ code refers to the region that our bindings call
"std" by the name "ufs_mem" (which this patch fixes).
Totally same thing in hardware, but it would obviously not work without
DT changes (which would be rightfully rejected as there is no reason to
change the name).

Konrad
