Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B015C3876D5;
	Fri, 11 Sep 2026 03:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789098823; cv=none; b=MdHmWj3NqAQ3+v9w5MlL/o8k6B+SNvII53jorwTFulprBwEMcJRYt36pFz3Z8fOXtrJm9xkFZk8umDqWIr7xFcRpf+roL8brwmtWNPySIzXKpKMm73kxnC5zutqHkMNSh2aUKdMS6K5BdgxQZFKHTdZnAKvw+ArGtmAEWCRZ4l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789098823; c=relaxed/simple;
	bh=1S0infcIJCSHpPOmP/AhiyT/XsJf4lehWJdk01Q3zMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lx8h5W3p9CexwFGWZrfSclCT803wp19Vhv6ktPlRdYgK6lQphMIXiie8Q4Jg1crlxhTT78G6tteyMlxnwqL7idJRNvX+f+nvKgutD4Ifh3xNVSQPL0qOB71g9Qciv26wZwGtt3dbBrncGFjVnILjqD0Py/WD2T99oFLGSdEClJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AxtZHwIz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AxtZHwIz"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12JK72632217;
	Fri, 11 Sep 2026 03:53:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=PEhpIH
	FRWlvPF+yjVIMIHkPbfyd5purfG0FTWg5ZZ1g=; b=AxtZHwIzQyHtvXOx5RZBQy
	ATFS23SQGL0YV/w82fq/+ktivNVEZVfau61OgydXuvIYs6uRaOILLmjl67W1VJkz
	r79IvNv7+/EPr+fL6mm5f0RP4hJl28cgRayyHtTpgYLAq5fDR8u9iZgTuua9oKzL
	IQRwUIPK0KrVjtFefIDofiALW+JcO4P7t/bhIFXyk2E90ll8SolBr8QyvfOghGMr
	LJVs9IoPFfG78pWpgUKt6aXHwr/RVbS+gLia2ndgDxwHPlHiwjB40zye62w/frsN
	qC0W+19BCUNbFU34iiO3390LxogTAn3qGFYWS9rWPvqJxjfX8dHO8WcY1Bu1s0lg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8n948y-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:53:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B158PB872147;
	Fri, 11 Sep 2026 03:53:39 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvwk459k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:53:39 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B3rdZj25035358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 03:53:39 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E29E58058;
	Fri, 11 Sep 2026 03:53:39 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DA6E058057;
	Fri, 11 Sep 2026 03:53:38 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 03:53:38 +0000 (GMT)
Message-ID: <6db82d74-2251-416b-8a29-7caa9301c2c5@linux.ibm.com>
Date: Thu, 10 Sep 2026 20:53:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 5/9] scsi: ibmvfc: add interrupt routine for
 asynchronous sub CRQ
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-6-tyreld@linux.ibm.com>
 <20260911024419.047191F000FF@smtp.kernel.org>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260911024419.047191F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=NMVAaE6g c=1 sm=1 tr=0 ts=6aa37b44 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=teEPZJ_9TZz4PRgMrrAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: uu-qWeONm0HTpkVK3I6hDLfIUpBFj7_y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfXyisOqxM2j71y
 mfZ5tvhYFqj3/LHp3hO6LUtcNZNSPyrPK8DaLO2w3Qn8NFqi3qpGVt9QwFymyW1yiiRBM7rpNTA
 cWCfTZeiKL9hoS9IFOvA7g26E35aINmfVSFV/yjg1JbSTHyorsBmrW12suURA7QK2cx/0c1hkrV
 xt1DHcRH09EM3sMnmkda9QkQTjDY/OxgaeYiVMHkMMKieWynigVTSyxmX9V2pZ5l1u4CLV+VZte
 +xnvyOMDu3iu1JM46AfstwW5zhN1o2I0XeB/c+qTe/+tLHllVYAAv3j6sH8b31Ru06R7mH/d4+c
 agcdsFdkyLTyI4JwyfazvAkCxVKQKvlMSRuplgmZ26NYmRqfIq0dTAb1LYZ60HSJwI1HPxu72Mn
 dO5LfJjuZ9fqUDH4OkyKrpiG4/xVACWPEvhBaCE1yaeozmkrgjkrpXoUxlq8SNMbs4eVHFNWr+b
 uC49tvxBBQS8RyrDb+w==
X-Proofpoint-ORIG-GUID: uu-qWeONm0HTpkVK3I6hDLfIUpBFj7_y
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfX6wXUARvgF7/b
 hA6JBnfcWyfsBBxqo+fIkqgRdx6UIo+M7OJMGnGHRaVhPZG/+6idgcOON981Dam5juJkIh888+w
 xR1MvxG+ZXmO4XRuoaMsMGhoH8QkaGc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110045

On 9/10/26 7:44 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] Missing address-of operator (`&`) when referencing `Scsi_Host`'s `host_lock`, causing a fatal compilation error.
> --
> 
> commit af3cb177b633d7c7bd704888c846393f549edaef
> Author: Dave Marquardt <davemarq@linux.ibm.com>
> Date:   Fri Sep 11 02:19:05 2026 +0000
> 
>     scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
> 
> This commit adds an interrupt routine and a draining function for asynchronous
> sub-CRQ events. It handles disabling and enabling IRQs to process entries
> while holding the queue and host locks.
> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index daec81f48857d..553fca31cb3aa 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> 
> [ ... ]
> 
>> @@ -4376,6 +4376,60 @@ static struct ibmvfc_crq *ibmvfc_next_scrq(struct ibmvfc_queue *scrq)
>>  	return crq;
>>  }
>>  
>> +static void ibmvfc_drain_async_subq(struct ibmvfc_queue *scrq)
>> +{
>> +	struct ibmvfc_host *vhost = scrq->vhost;
>> +	unsigned long flags;
>> +	struct ibmvfc_crq *crq;
>> +	int done = 0;
>> +
>> +	spin_lock_irqsave(vhost->host->host_lock, flags);
> 
> [Severity: Low]
> Does this code need an address-of operator for host_lock?
> 
> Since kernel 5.14, the Scsi_Host's host_lock field is an embedded spinlock_t
> struct, so passing it directly to spin_lock_irqsave causes it to be passed
> by value. This regression will result in a compilation error because the
> lock function expects a pointer to a spinlock_t.
> 
> Would it make sense to also update ibmvfc_process_async_work, as well as
> ibmvfc_async_fpin_test and ibmvfc_full_fpin_test in the KUnit tests, which
> appear to have this same pattern introduced earlier in the series?
> 
>> +	spin_lock(scrq->q_lock);
>> +	while (!done) {
> 
> [ ... ]
> 
>> +		} else
>> +			done = 1;
>> +	}
>> +	spin_unlock(scrq->q_lock);
>> +	spin_unlock_irqrestore(vhost->host->host_lock, flags);
> 
> [Severity: Low]
> Similar to the lock acquisition above, does spin_unlock_irqrestore also
> need an address-of operator to pass a pointer to host_lock?
> 
>> +}
> 

Again, as noted in patch 1 this breaks the build. Will fix in v10.

-Tyrel
