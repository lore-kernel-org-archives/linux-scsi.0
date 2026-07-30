Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CCA4749DA;
	Thu, 30 Jul 2026 23:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453464; cv=none; b=qHTMcwgJd5SPX0e2wQxam8MqgLJ7AE2+D1DSPjPgZy57I1/8cg/lQvbGZBDSFWMUqsTs9s1VmVGyoKAXnwdnr83xLLaez6Q8MCcjpi3EEos+Z+bfJnBuRS1yiUet3RV6d76qHY1DW8rjmQiP6v8cdIsgVPxvEpHpAEwcwjlF+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453464; c=relaxed/simple;
	bh=AYhHZfGJIPg9R2wGjzlSbVK/g8ETW7smm4MBRtQobzU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bzd+DXLIrq7wMaq+tTqFwmHVQL1mtr8+Ny/TXLO0hgS1Ga8C1MuB3fMdcgjOpjx4CsIuTofcsQwIi2bqqMJIKKjDMynuHXGFUDGwqJajycwPSWKi/aLIUCehXGaq6PklgDUmgQuLr0vdx1uNwodSJWX228RItFY1xH8KKT7yeLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nGMcYB3m; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nGMcYB3m"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UJlqaj3875013;
	Thu, 30 Jul 2026 23:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Q871/b
	dlqNQgMMpC1Od00LldPvFVAq/cc4OUkNn2D4U=; b=nGMcYB3mDVYKaFSmaFCusJ
	7KqezQ7IQ+q7ay9g0GAMWAKXEw0JcJ6OW7zBCkc39onnNVvNUg33dyICJEtGtSAo
	m6Fstj1OapomyLUU8apasiZusE9GTuwUeBZrAqiALsmkVml+TmTzlU28u4YaUDud
	ogkWCUMQ1fZze6BF0cVW5BrEwoXhgwyRNYEtmTVZdFYg7xSf0aYVjBsAldQf/Lu4
	zMV8zJZFD1+PuOz1QBpWQxRvgYmMC6FqbukBPTjGhRWydv4TsxpJmzfx1GdGGEvb
	E1FJ9oen+oIsanFAt2wtRe/mmzIhZ90k/ZWnNi4w4rL79WqQaL1n1fAjdj3t08Og
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyjhcq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:17:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UNBUYH022303;
	Thu, 30 Jul 2026 23:17:32 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn9pgndge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 23:17:32 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UNHVTe27067020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 23:17:31 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F07D58056;
	Thu, 30 Jul 2026 23:17:31 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D71DD58052;
	Thu, 30 Jul 2026 23:17:30 +0000 (GMT)
Received: from [9.61.73.28] (unknown [9.61.73.28])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 23:17:30 +0000 (GMT)
Message-ID: <057d275a-d386-4208-b3d5-dfc037e751d1@linux.ibm.com>
Date: Thu, 30 Jul 2026 16:17:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 30/33] ibmvfc: implement nvme-fc IO command submission
 callback
To: Dave Marquardt <davemarq@linux.ibm.com>
Cc: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-31-tyreld@linux.ibm.com>
 <878q6tzl79.fsf@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <878q6tzl79.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDE2MyBTYWx0ZWRfX2wznhYCM/sFw
 gDNtdlzB7jz8d9alqXwejGIqp5zdJyKqFND+YC1vfHD/447EQdgJR3lHuwfuOM9OrJ01nru37W7
 ePHBPNmBd9laQrrY/YwbEYHvvzUD4ho=
X-Proofpoint-GUID: 0QE6lIWqac8B_Sqy7fZc6bRRFFlUo90S
X-Proofpoint-ORIG-GUID: 0QE6lIWqac8B_Sqy7fZc6bRRFFlUo90S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDE2MyBTYWx0ZWRfXwm3hpfM1nChX
 1boNdKAu94vpZFZyfxbabF4J06XTJuucnyX+HUZlWFx4sGmNgWuxlsn2Q7ju0wUtt3h9Fk1sz1t
 nF/LNvIe4gZVY7G+P10bmJGOwDAhyckakM0IdE8QFtsyZKACQTdT3ESCtIUor4TBSGH8RL380qv
 aKQThu99H5+WnyFHGJ/E6GSYBVSfCh98+1rAT7U2upVmdXncKEWQ1ykOS6wQInl6SltGhRooO0O
 qRlI0mRVwWwSU06LtXts3y+jyBH/xx29wPvaInq/8ksOw0Iy/0ibbFb2NzjVfaHZxvURagEh3Wr
 D8cQvYYKREormn974A87kN/+09pLk6IkGdwiWGA8Rn/sOjhulZETxwcqYyDNEgdnNDegAJZkYLd
 4W6sAohnpYBEcW5N23tDPC0Ppye0+PRUaIJbaz6AoZotiHdH/9VzzGLxl8h4aA5qmNz785bSEX3
 0x9FV5xGs6uWtTjXq5g==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a6bdb8d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=0WC_OVg3zCjHYRykeTYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300163

On 7/29/26 11:48 AM, Dave Marquardt wrote:
> Tyrel Datwyler <tyreld@linux.ibm.com> writes:
> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 45c7bcf69201..bc975f632da2 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> @@ -1539,7 +1539,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
>>  
>>  	login_info->ostype = cpu_to_be32(IBMVFC_OS_LINUX);
>>  	login_info->max_dma_len = cpu_to_be64(max_sectors << 9);
>> -	login_info->max_payload = cpu_to_be32(sizeof(struct ibmvfc_fcp_cmd_iu));
>> +	login_info->max_payload = cpu_to_be32(sizeof(struct nvme_fc_cmd_iu));
> 
> Do you know that sizeof(struct nvme_fc_cmd_iu) >= sizeof(struct
> ibmvfc_fcp_cmd_iu) just by examination? I was wondering if using MAX()
> here might be less prone to future breakage if the structures change.
> 
> -Dave
> 

I confirmed at the time I wrote the code that a nvme_fc_cmd_iu is bigger. Off
the top of my head I believe and nvme fcp command IU is roughly three times
larger than a standard fcp command. I had considered wrapping them in a union
and doing the sizeof the union.

-Tyrel
