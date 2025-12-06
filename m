Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D521B25B1DA
	for <linux-scsi@vger.kernel.org>; Sat,  6 Dec 2025 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765033649; cv=none; b=sranO4jf6ZfFqaaKCgI3VS7tOTuXli+1IwcBLRBSomzWywZKft+2tvsGW9oxkArnE9xlyiUEikn1vKPdrLcfmb8HGT1yw1XNj5ZMnTDPp/QamaC4ugm9JgHmhKRpcHMqwx5u6QyyaoBzZZTKYtE+tcybZOMli0KUILod51tMRWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765033649; c=relaxed/simple;
	bh=J5LTKtahs+LqfmjUvLy+nFLz1lavil59ERW34LG0JeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FWJNo9CRUEE91RHOhX2JiPaiWXmh/emh+wgs1hMETpdDyCbnNAmwqe9TUHYxpPg0QlunMG8DtTXYAKDO/2rM59b2/3pHjyc3GsEtzQyGheWyO/clGIwrgDxridOq4ucBiEOmWhzmmcegmfuwDC8DVG9s+Ta0PipJ5+0vcHPNac0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mjMZt6lU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Gj8zj97G; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mjMZt6lU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Gj8zj97G"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B65Z5hj2642159
	for <linux-scsi@vger.kernel.org>; Sat, 6 Dec 2025 15:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7POYpI/JQpcYcHKEfkjwMvxfyzAGnIcHYlhKUvFYBIE=; b=mjMZt6lUXTDh0YO3
	7g6XiZJaSKAAR5XrFrAUPcy1WUmBPwyhXQ5Aiumv6W7dQCONwphjiBq64yYA2jM2
	DPoj4s06YhQ/kpUhvaV3D/HM34qRxsgOizuXaxW2XV0v8jjbHzB//dNGcZHQ4W4J
	tUXUllJwoVmTUb/Co4fj/g1TxjXWdgYpxb2EZeB+G4O6ZUyqXCdfg9eaM9umsBGI
	IM5ygGwdWKpnGe9E3ENjyKO/eQQ8iNvuzb3fL9nXTSJMSE5vwSadudbisNX3vOlQ
	j6Q0wYe82VsIodtfCw7gUvngUP8GxJNe33Q0SyXFhlGWBcqh1FGkHoNnJOLl8HAq
	p55fNQ==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4avcndrw6u-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sat, 06 Dec 2025 15:07:26 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-29848363458so60327235ad.2
        for <linux-scsi@vger.kernel.org>; Sat, 06 Dec 2025 07:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765033646; x=1765638446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7POYpI/JQpcYcHKEfkjwMvxfyzAGnIcHYlhKUvFYBIE=;
        b=Gj8zj97GSCiWQMmcwLkdyUG9YTjmx96K8IsrFqRR1n7ZwbKvP1p0efXNRA15rHrIeZ
         MxV3mShRJC0tKKHDRVAARKesRz83SqtRrL7+WfXRdXeIM5vlhCHCkgKcABhkf/bFzVXO
         /b1UPuX7DXEaVZ7GTPu7oF2ID5x0ENOKnOb+DmyExtT/NfsCM36qxVi1tJ8NC70qB2Sy
         lnHt7Q5RDr8TCIxTSd0Y3ZztIRxQQaR0OCGXKzv3XuF1reCbQxUlYVz+1E/CRrG7QVyl
         iwn97175MevuLZY7UFNnvkYE3U8SWUco0N4ah+9kz+L25e12LKVirLONby/vOnRIIO9F
         qQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765033646; x=1765638446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7POYpI/JQpcYcHKEfkjwMvxfyzAGnIcHYlhKUvFYBIE=;
        b=CSjtVGKyKlwISqyzXcsMM2jczqSVwdteCPdN5Y+a+JqasfIPSPEVfUAkkLfR8uqkuA
         HnTOZosF/5l54829GYtPIACctjX8tXNmGpLRgryCKWPHfonioS16gfAKjzJ6AcwQvavO
         78/OHcH13/kMQJ1Q9fbjo2BHJLPeNFCNuv3JsZRV6ZnPhf+uc3dALQfxawSSMDzTvOsS
         uBeq6/98RPQG/C84YSPeShNqCCs3shthC2TMr50AjYWOdhZOPsDKkNfg1zpJepVDOavm
         myi/8u8XhAfz47tkUF6dUGZJpWqpuTgGwVJoAvucZvqIDiP+VxnEuowI937ORIwMRN/c
         4ErQ==
X-Gm-Message-State: AOJu0YxFcpzSs6GvY60Sx1/VRrGuZpx3mDwraxRp2QrdgS0sdy2UEaNW
	H5iy0pMTZkAvBv8cKp7o7ww9AFzMZVm9WaFCaU5V10NYCOlFpJQsM6/G6zsabrwQ3ImdRp+yXNh
	ABS8+QgP3aFZQSIIZ4pUlanwNW9w0b3V9WLrANzMXei2H/GZ2Ra3BxEtYfEdZn24K
X-Gm-Gg: ASbGncvAmOoIJo7/qxkF36b/SM8PW9QyJ+teYiF/0uqKjQOkBF4t8diPuWDYZjSofvb
	lUuJDHKtm69zlyofN/hIHlhi44ru0p15GeVhRjTfX+VTKTJQR/JcI+EJ/PUoBXPyf5KAMXkTrBH
	x8liLVLnk1Fz/JWA8eOHoSE80DHc0DrB9lJ92W8zQJ7QjISOOPJD8K1EbeZFQpeLsyixW94xBc9
	ezzxjyi1DjV87AQMKeHfGhs9qxIpmF57a72cAwUA4JKGb0uKMsJOTqP7Q5ax0Of6vIFE/3ZegNa
	qw646vgFk0PCn3sWkSnf45IWU4eYB4HFxNlideT6wOtaLP5MOoHDdtKMuGYIUfS20M0uLsC9YsZ
	oJ1hUOTotNl3sMBlDVeB1zxdM
X-Received: by 2002:a17:903:4b0c:b0:298:2e7a:3c47 with SMTP id d9443c01a7336-29df5e08275mr23666665ad.42.1765033645653;
        Sat, 06 Dec 2025 07:07:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGdyfDk2jnPOgdZRWOczWEfAF38w8GS0CcuiI7QkclDudyuiZV/A/rBRvtahmmeKhdgDlYIyg==
X-Received: by 2002:a17:903:4b0c:b0:298:2e7a:3c47 with SMTP id d9443c01a7336-29df5e08275mr23666275ad.42.1765033645123;
        Sat, 06 Dec 2025 07:07:25 -0800 (PST)
Received: from [10.216.13.19] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae99eaa9sm79322895ad.53.2025.12.06.07.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Dec 2025 07:07:24 -0800 (PST)
Message-ID: <7502bbe3-45fe-4e2c-83fa-f288d3bacfe1@oss.qualcomm.com>
Date: Sat, 6 Dec 2025 20:37:18 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Fix a deadlock in the frequency scaling code
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Manivannan Sadhasivam <mani@kernel.org>,
        Roger Shimizu <rosh@debian.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20251204181548.1006696-1-bvanassche@acm.org>
Content-Language: en-US
From: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
In-Reply-To: <20251204181548.1006696-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: keh1JWVlZWRYQQXHjahx_Xml21ZauKk0
X-Authority-Analysis: v=2.4 cv=baJmkePB c=1 sm=1 tr=0 ts=693446ae cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=xNf9USuDAAAA:8 a=EUspDBNiAAAA:8
 a=N54-gffFAAAA:8 a=sJ-Jyz2vAU5NxIBvXxgA:9 a=QEXdDO2ut3YA:10
 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-GUID: keh1JWVlZWRYQQXHjahx_Xml21ZauKk0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA2MDEyMyBTYWx0ZWRfX2SmTJn0HAKe7
 NLzl77mX2JNp+bVg2519G1OJlNvkbGZ5cgBzD5awHacUNB3lDPrkFAxI1u+C3+KjJbJjeBa9NQ2
 earJuAL/uHRAwQcdH3TbaHvMhv2TDThoVj4CW6rxPYCjEvLRypaICZ5h1woRXsEuYt7OHddCRhN
 q1gMZhzp5Hs0QvEacT25QvZ6EJGo40la3p3x8HQ+Qln3FBhLMZwpZE6GHfDqGRgf7AKpa0zAyVK
 O3+RYSeXIgYUUOqbLX+/pWKj69DHpAQ9N/X+J8fpazsmbFp9EopEuGtobUrwDnpBQzVFRVTLhcV
 3cS4xUs8qdrAgWPY7r6ZvtpY9CNplF/+8gLxj6Qxzc0lozZTa+lf//rbNuSx/2tZFUFxS7ugL8s
 G2YbKUSXghANDla7GD3shGqnCaHZ4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-06_02,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512060123



On 12/4/2025 11:45 PM, Bart Van Assche wrote:
> Commit 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
> accidentally introduced a deadlock in the frequency scaling code.
> ufshcd_clock_scaling_unprepare() may submit a device management command
> while SCSI command processing is blocked. The deadlock was introduced by
> using the SCSI core for submitting device management commands
> (scsi_get_internal_cmd() + blk_execute_rq()). Fix this deadlock by calling
> blk_mq_unquiesce_tagset() before any device management commands are
> submitted by ufshcd_clock_scaling_unprepare().
> 
> Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
> Reported-by: Manivannan Sadhasivam <mani@kernel.org>
> Reported-by: Roger Shimizu <rosh@debian.org>
> Closes: https://lore.kernel.org/linux-scsi/ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow/
> Tested-by: Roger Shimizu <rosh@debian.org>
> Cc: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>

