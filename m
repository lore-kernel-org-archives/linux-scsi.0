Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016FD328B7A
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776938501; cv=none; b=lUsRDnW3NWsB6SxKuKIR7q19P+nQxNYXxPKS0bZnZrbMmTpYpBQkmzbT+bHygdJErA1E853D1WJdg7ndDMPvPJbmlQiK8eHprVPlmPbKew9QrUFARnJx5Mx+YqNyTblkOhIu4YTymqhGY+Mh852AAEmpqqoLPvunWJgB5QB0R7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776938501; c=relaxed/simple;
	bh=S8f6+ehUtJMx81AZ6koB32qCI1+M7p7cO19QQ1odyvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bKqFH4ZlGnnZs79dH9zkrdz08xpLf9+qli86eO0gyxmd5TkAKO1EWdGVBAzorSdfx1km/e9tPYhH6MWX9SHlS17ZRQZ/sU4C84T7grqBAjplp4p9eslmTzOz3GdYoJBEVi0KkEkk7sjCYM9iY/5yK/15wZtB6Eij0Rio5Zg86/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=BYJPKyMq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=FJ2O0ixZ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="BYJPKyMq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="FJ2O0ixZ"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N8uLKm987831
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:01:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	HTAImua58OKvf6hsofV3JDzOzX9CCnQSyZAKqQ4qL4c=; b=BYJPKyMqgjk/t3KX
	BFNyIjnQOuPOH/a7sYtFtPdwUEcma/Gv/OBImajy2/k7MseMBEtHpswBbXbrOW14
	6Xl9R7lhVL0/16EjvOAuwcW1u2LdQPFwu5P0FHYjEdJdDZAWC8A9+pmY6OZXtUfn
	r8N+rxqnk3l6ALSaMArtwWii5vXzR7R6qx39yP/rl7g1xU2BratkVglgS8iwg2Oo
	10U4x3qOGEKcQXr/yl3OKtUTdjYuqHxnzpmkbRrknQ5IfEzZxTvzKCT1YH1IVA74
	5BpIlc7/zlDzvWvTfp7/qBMUcV5aFSDnF3/5izc1lyUDbr11ralZVNfQpd+n8l3h
	jo/1Jw==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dq16q3cu9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 10:01:38 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-82fa5ecd760so3098274b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2026 03:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776938498; x=1777543298; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HTAImua58OKvf6hsofV3JDzOzX9CCnQSyZAKqQ4qL4c=;
        b=FJ2O0ixZrcwp6G2PJxcciK28u+LGZdx6jeOLl9uFeno+Fttlocr/16PNm7AdAMaZBJ
         ZSYKQPUOZrVbIftYXvNHXisd9dPA1WaFVv6Oig8ZmRyXpVQIOqIRrpACAZ/Ghz3EydlW
         RYuZt7fg6zLadWIWmIcK8YWHfvFjbaXDiK5q2Wa7Zph2L2Z4HrL5myE1eNtBqqK1NDZz
         jrpkxdzRuWyN+jmQpqUXH31f6+CsDzPCNz5JcnKiRhKJkoZViEWBgA323LKorv01gh1+
         wJIXnJGIz3XfHKfjlhHv5jLSjd+OVro0Oz85nrz/ibXJYIXUr6SxhxqWaU/1WthGd4jF
         2mzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776938498; x=1777543298;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HTAImua58OKvf6hsofV3JDzOzX9CCnQSyZAKqQ4qL4c=;
        b=M17gg7c0mKQ9udWB04zpNm7cEXrYnxgePHz1E4MYzc4FJW+Y2XhMn4rI4QJKNlYm9o
         0uKfMpG3rlDNGnixD0jJ1DVI6dLWSqeeYsv6ehO9C4lxTIIpIDAfHnCWqt3BnSEVfInm
         N0tLTP22XzKa6/8DhcuuIfsbHvmoJMdb57AlHjpiP3xLZev3uIvPrI5LUf2n0tkv9f/9
         bcnTRU01j33Z3Y5Q4gnPUfDyHcT/7sY+Fk5fmbWb8AeyS2D8ZF1KCf9mWy/dmYDChiYP
         leXXyHhOAJi9nYMJjiSfPTZbVcb+UDD7De/WUZQDvID4YLRKZM7QCTJ19Et5YkDFlqKh
         PoWQ==
X-Forwarded-Encrypted: i=1; AFNElJ++gMvH3UKdRbY8lAzItvrzaWBq5QqCs29MplT/NhGRL2tpcIUMyl+9J7cDK+g9gEkh7zHjj657CU6n@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0tiQiCjko/ZVNDoaMAtJtSeerjrLRpIob1rqexXEpbUK5Rebt
	bkIRBh5ch4xy3BB+nvoa7EGHz1r2vz0CETMJhTl8G+rJTGiVW8atQn5JFTMMW1EaWwixqahnGX6
	Qp3P1VykNDwSTehbPkV2QD3u0Hy7LwpueyQf6qgmsKm7HKO/ARHJRU6FqcbbsrbQl
X-Gm-Gg: AeBDieusnNULdSA9kd4+Nm/JD0mtbl77RZfDXOqd2PsXa4IGzltiM+iPD4rUVedW8um
	ChlHPBUryA1nPeTr5+ph+BoOu0MPbiSsIGKZBUJvHVvjXpUotM5yAr/bo+8zDQcYlc4Pnl9uZ0p
	tVcdjadQVu3gHc5Xe85dMTww4ptTd6f0yjLVH4nyLT8WD8fiaYU6GajDhuMAODFCa88frMSVPHy
	tLnqkDnYb+wwmovTbKh9DIjYeHz+ymUYY6Ym9flaEKooGHnmkX4N1+rPzUPQAUhSIxnLQSFfDaY
	LhJj6m9pTEx3fuQe8wPcQ0/7g7XtzYPwK6mawsaZ3+FMO5Hq5qFjU+VDNN2P+5EzlsVxmKILcLn
	OfgQ2k3lPEBfuVPPiUUU3ysMwlJQHKnsi3xKYh9J8Ryiwe1nG5uswP0QoMsoQHEQ=
X-Received: by 2002:a05:6a00:3cc6:b0:82c:db50:ef77 with SMTP id d2e1a72fcca58-82f8c98c45amr29192063b3a.49.1776938497669;
        Thu, 23 Apr 2026 03:01:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:3cc6:b0:82c:db50:ef77 with SMTP id d2e1a72fcca58-82f8c98c45amr29192004b3a.49.1776938497025;
        Thu, 23 Apr 2026 03:01:37 -0700 (PDT)
Received: from [10.92.175.180] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ea0098fsm19522390b3a.24.2026.04.23.03.01.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 03:01:36 -0700 (PDT)
Message-ID: <722eb005-351e-40a1-af8c-c6cd01fb168a@oss.qualcomm.com>
Date: Thu, 23 Apr 2026 15:31:31 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 1/2] ufs: core: Configure only active lanes during link
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        shawn.lin@rock-chips.com, nitin.rawat@oss.qualcomm.com
References: <20260423055914.3566684-1-palash.kambar@oss.qualcomm.com>
 <20260423055914.3566684-2-palash.kambar@oss.qualcomm.com>
 <we5guwh4bayq2fertkfsh27ykkzz4h2owzt5wjiezn2yzfjpni@77a3xpe6in2l>
Content-Language: en-US
From: Palash Kambar <palash.kambar@oss.qualcomm.com>
In-Reply-To: <we5guwh4bayq2fertkfsh27ykkzz4h2owzt5wjiezn2yzfjpni@77a3xpe6in2l>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=KPNqylFo c=1 sm=1 tr=0 ts=69e9ee02 cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=N54-gffFAAAA:8 a=s8YR1HE3AAAA:8 a=VwQbUJbxAAAA:8
 a=Db-oeYxN4i5GQM4S5YAA:9 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
 a=jGH_LyMDp9YhSvY-UuyI:22
X-Proofpoint-GUID: TQb9zzu3lPmiXW5b4SY3J_I-8vo6fk5L
X-Proofpoint-ORIG-GUID: TQb9zzu3lPmiXW5b4SY3J_I-8vo6fk5L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDA5OCBTYWx0ZWRfX2inxRNXESadA
 PePO7UF0ZTaNcFk11m7YZ1nttKHEy/HsuE7BgG+HxjI8hyuLB6i21RG1f9ayjgI2AkhuHcrKfaZ
 GYSxykDQHrp9Zi6sRdmj0hjWAmkfmV3oGRb9yi8NRt8w5DOryT4thnfz3Ba27a27wr98LeBZLhC
 w2QcwXAZdIQLU2PnnRHGtzWjNPOOqPYPEomRG1LQEz3JzAI6oZ14ZIldp4twCLgqVde8ItCxbW7
 GAS7A4YHdyQVEqm4yGgSzCjdBytsgzaR72yqmLYLKOiGLisxubZpkzSXnNWkFT9NaE+n+EAcp6a
 GzfXjgrktziwuZmvdRVRhZaHlTB4AI3aXflO+p8hcMIz5TFy/3WjH25dhzT0FLFbzCHsWpfMNKO
 5ueskeG0riyQB9xOexd6H6Nx5ndaRpK8Ftfp9xsDFaKf3IoxI7rrLasbkCrpFxDcMnSxJRgo3jR
 rHaWzUsdCuNwIrBIfcA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604230098



On 4/23/2026 1:34 PM, Manivannan Sadhasivam wrote:
> On Thu, Apr 23, 2026 at 11:29:13AM +0530, palash.kambar@oss.qualcomm.com wrote:
>> From: Palash Kambar <palash.kambar@oss.qualcomm.com>
>>
>> The number of connected lanes detected during UFS link startup can be
>> fewer than the lanes specified in the device tree. The current driver
>> logic attempts to configure all lanes defined in the device tree,
>> regardless of their actual availability. This mismatch may cause
>> failures during power mode changes.
>>
>> Hence, Add a check during link startup to ensure that only the lanes
>> actually discovered are considered valid. If a mismatch is detected,
>> fail the initialization early, preventing the driver from entering
>> an unsupported configuration that could cause power mode transition
>> failures.
>>
>> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
>> Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
>> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
>> Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
>> ---
>>  drivers/ufs/core/ufshcd.c | 35 +++++++++++++++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 31950fc51a4c..fe5bc85c6870 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -5035,6 +5035,37 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
>>  }
>>  EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
>>  
>> +static int ufshcd_validate_link_params(struct ufs_hba *hba)
>> +{
>> +	int ret, val;
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
>> +			     &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (val != hba->lanes_per_direction) {
>> +		dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
>> +			hba->lanes_per_direction, val);
>> +		ret = -ENOLINK;
>> +		return ret;
> 
> Really? If you had spent a minute in reading the patch after writing, you
> would've seen this obvious mistake.

Ok Mani, will update this. Thanks.

> 
>> +	}
>> +
>> +	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
>> +			     &val);
>> +	if (ret)
>> +		return ret;
>> +
>> +	if (val != hba->lanes_per_direction) {
>> +		dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
>> +			hba->lanes_per_direction, val);
>> +		ret = -ENOLINK;
>> +		return ret;
> 
> Same here.
> 
> - Mani
> 

