Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89CB34F47C
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769094697; cv=none; b=c/WIOTBwYHhQ9LEqC0tQKRJY058YituemLpM0pFdnONSUUNkGsErJ6Khi6rj+iiR2ThFgsxE5Dbolemn2N5dc9kuVpOC2Lc73E+W40DAIvqX090ZCPWtvYzA1bHIVPWKLCBN5n0a9JQk8XpbsP5375iU/CCRY6xsuR1kJEFiQS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769094697; c=relaxed/simple;
	bh=H5ThibAWvoajrZPKGPBvO69JSuR2rsvAoFuAmH4XUco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WN5+aCM+iwUIZG0yX1c4BPCbi7GLqFu+8Cn4cFltAnNQjS6NlhWmdlNY9QT84HbLnEeihqCs9oFz2qOUx1+3i2Ng3Ux1+WgX7y7YBSlRgdS86pOhz4LCPmTbuP++9ZFI7nxYd/9IfwWt8WO81Poh2Tep93zHmbEcbnXySpJTva8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ecrd/+Og; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=W034MH4a; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ecrd/+Og";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="W034MH4a"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M82CV72278771
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 15:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	E+apXPPkNURrNT1i45k0NbCCo3UvVpz3ZhqjBzyjoTY=; b=ecrd/+OgSZBX7q1n
	SdzeAj471Tuy2Hd+3FbAQCJnpCFUAMaoFtMohm5SVM5aslmM7jh5ljKmkr4chqw0
	J7UNIoU2xwVV/rMBFW6tF7zexKMeoxhZ2rBzSHout+er3sQkTwiQ2fEPpc97soRA
	ugSZ3u0CWTGxWgpQo6k8TALn3H00nBbgfL6THP5wUa8AYF6OhFvi+4eCktJVvGVV
	oLM6c2cxQFqY6sekNv2JHayyNIKVDuv6rGQ+JcunpOWJkIVEOvECJAu2QKgjwBgl
	GS0O6EQ2YA9QAFve4BUNqO/YUn0xK33cPn+OV8Dt5l4+yJrhN/7CpxaMxmRcvi/Z
	yeZrsA==
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com [209.85.222.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bu7fatrxq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 15:11:34 +0000 (GMT)
Received: by mail-ua1-f70.google.com with SMTP id a1e0cc1a2514c-94807fe6f62so95204241.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jan 2026 07:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1769094694; x=1769699494; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E+apXPPkNURrNT1i45k0NbCCo3UvVpz3ZhqjBzyjoTY=;
        b=W034MH4ai0H9x5LkJyHV5v5kGmT7sWeNc3VrnGbYLhS0KOttlQ6giJqoOKf7Tu41sN
         lDHRb7U1QEAGIA2isLBHTQsplf+B+X94vXpwLlXZQO01Q/0hCqgfUHUtYxRs9zUBGy+n
         cwxRYLPlKfKlxttNoC9TsP0gfNZc+EZbmPBSMrviGWtWQkKAL8qZQ9kM0gYhETjhCy56
         jhV0x6dfyfCuWe3g+TS9n2wLKZaOCiLotknES6IXBTYUh/9wlRydzQdTzAdL9iyKRE9S
         mQxfdd2Y9dIVdg3LkFvLC8Y2MmKqE3O8Z1sczJSpl83Qn9e0BJCIXDRx1jS2+Wnk19Lx
         nMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769094694; x=1769699494;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E+apXPPkNURrNT1i45k0NbCCo3UvVpz3ZhqjBzyjoTY=;
        b=bO/qdzm7v7zvXTel4rbdZDO9ASRoBz4WmiUqV+RYJlr9of6iaU+nfYkizYQ58Bn620
         mtAjjcNOwq3iAvDLH2UUTLbijDB2TB63FfLsrLVzTwVMYMBrkykQ0tieATdhXJJGn5yQ
         6VUr20T+rKwuXoTENVp2CBpobqNJFd/Zz8X25MbIDq5ZQV1MbDAGdAOo7FOL+sToSUKP
         QWwAeNK+haQmABe1EW4R0AISD7NrgWW8YZmPdZqX5H5pUGPOvsqAcQuF7IKUYG8wUTBP
         hmfpk4MbNk4OU205YCdqWT3XzEc3T1NwELFPULCWzNcIxrc3Ayow6WTgvXsfVTvQipfr
         PjVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOcGQhztRhJ+e32EHun03VM++C+PWl4RkyaRxICYCQ7HCbK5696Xpu5gbPxm0QQN6MghImUxj3Kare@vger.kernel.org
X-Gm-Message-State: AOJu0YwxKlfcqpuffmCWBfU13dnW4eGBuVp3lEhUPVyXG3uaxnhUGg2y
	FC0ALwrg5LWtmxqb9f1XzUVzfbldHA3N8Yy9DTkWAT3Id6LFKAPseFuWkw7OnhTjCuEC96beGc7
	RIqEwiXEEgL/GPOfNqRJjOkcKXHfKoUJPOfHsVKt8weydR1nlEqpOi5u2qhJ8CzNf
X-Gm-Gg: AZuq6aJT1jyLxXXSwZPFveLHKao3JnAZGEYuD8jkN642dEyoGy3dF0vmPITGS0KOQ5P
	KVVChaLRp9o80tRqh0vGaxkyYvsGfJDfh1lXV48O7CKL6N5z7XNjCSRVQdk57ZnfSP+bCcCVyXF
	YFNCrzRbFo0G+a/NmB4NAjwMmGk1mwLkVPP80CKFNj5zfxuiYIc7HgKv3p0BMZV2WuAGXo6rHWo
	aGrWqu4ktaKCD0Aj7cFHPx/gERaw1LGb22LnqeybxMV1q36sRuITC91wITM04/2aMxMCkYMVcIj
	MZ0/w+BmCZh4K0uFqf+/nu1Gb9v+kd5vgVCwRO3Jhzevdm3HcyMGsgQRF4dUKcaGK9Y/C6vCTdA
	4Q8eVPiiWdxKkI7mowdzjg7M7iRmgqtJtfYQhIjOOtIjKsNb6o8bZ5lK7do6trlfeFek=
X-Received: by 2002:ac5:c5d1:0:b0:559:a30f:1d47 with SMTP id 71dfb90a1353d-563b5c689d2mr3193463e0c.3.1769094693730;
        Thu, 22 Jan 2026 07:11:33 -0800 (PST)
X-Received: by 2002:ac5:c5d1:0:b0:559:a30f:1d47 with SMTP id 71dfb90a1353d-563b5c689d2mr3193454e0c.3.1769094693292;
        Thu, 22 Jan 2026 07:11:33 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-654535c49f4sm16293405a12.31.2026.01.22.07.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jan 2026 07:11:32 -0800 (PST)
Message-ID: <4aad22c3-a720-4d88-baa5-aead6854a771@oss.qualcomm.com>
Date: Thu, 22 Jan 2026 16:11:31 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 3/3] ufs: ufs-qcom: Fix sequential read variance
To: Nitin Rawat <nitin.rawat@oss.qualcomm.com>, mani@kernel.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20260122141331.239354-1-nitin.rawat@oss.qualcomm.com>
 <20260122141331.239354-4-nitin.rawat@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260122141331.239354-4-nitin.rawat@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Hrx72kTS c=1 sm=1 tr=0 ts=69723e26 cx=c_pps
 a=R6oCqFB+Yf/t2GF8e0/dFg==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=EUspDBNiAAAA:8 a=qSU9NBqPYLnPsOZMscYA:9
 a=QEXdDO2ut3YA:10 a=TD8TdBvy0hsOASGTdmB-:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDExNiBTYWx0ZWRfX71RNbpnDd8GJ
 g5hLOtHMalq27K9JcbTzX2MilyX0mPb/R+LqoFm6EvtW62awWEdGj9MQRvxo++rIQWqsg/ruPh8
 ap5m+10qctHACm7fjj89tXhFOTr6iUREqis5b5YZeEL6OwHtHo8PqJpc0kDBstXDvWFyn5Er8WJ
 w+x6os3Du/D1Sgh1Arw/PvT3PcEYaet8uOnkXaEdZbDsyuZqT1XJgyRvDRH21KIK8abEQI5aKOB
 e4r2Vg/0H2dgkDsBLzfKlX3DpsFP/kj4WVJ32z6MjZ8h2nbyF989/4SirN7gkNvx83IiY7v+hhb
 huBHaal3AFOIAgtihvIutao8i8L2ghTO9cMwuklbOQbY4Jp4tVV03qvYFftDm0rN71r3YVHll+C
 /vccOUnSXhtyIN+NB8H/vmY0sqRsxJHR1+x4CMGSW0RHe6ueJ93xu1hr0mMlug1BkrmEEukk9GT
 873Aw15zSv9fcc4COfA==
X-Proofpoint-ORIG-GUID: LIgPFazB5ZbGXXWB5Ctn9NGMPdMuQuL4
X-Proofpoint-GUID: LIgPFazB5ZbGXXWB5Ctn9NGMPdMuQuL4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601220116

On 1/22/26 3:13 PM, Nitin Rawat wrote:
> The current devfreq downdifferential threshold of 5% causes overly
> aggressive frequency downscaling, leading to performance degradation
> sometimes during sequential read workloads.
> 
> Update the UFS devfreq downdifferential threshold to 65.
> This widens the hysteresis window and prevents overly aggressive
> downscaling, ensuring that frequency is maintained for loads above 5%
> and scaling down occurs only when utilization falls below this level,
> while scale-up still triggers above the 70% threshold.
> 
> Signed-off-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> ---
>  drivers/ufs/host/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index ab5aed241913..5ef810b95b72 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -1962,7 +1962,7 @@ static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
>  	p->polling_ms = 60;
>  	p->timer = DEVFREQ_TIMER_DELAYED;
>  	d->upthreshold = 70;
> -	d->downdifferential = 5;
> +	d->downdifferential = 65;

FWIW I see this is the value that's been shipping on android for 
quite a while 

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

