Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3A93D7D94;
	Tue, 29 Sep 2026 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790696008; cv=none; b=pQWUF9/mRfdGrhS12wCGrTJurtBNEre401j/gP8l/NO+qddphUKhAfMnSZrLAHpL5ykFunaEQnmjB4l3pyI77U2fQNEp+ksXT44MXge3NAywQncHLP8CVzGDvJlQ19cTZirFx31MKS47/IgdowC+Pz/wS26rzbbXWo5ErTlxKjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790696008; c=relaxed/simple;
	bh=cigZ80+8+q+9BMKi9FwSNiC3z3eLiNZDSw6eUBsoWTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mzTBWVsLTTLToVKqjtOcoa7l9wxYlDl69f/ZU7+XpygDpjDyxCzUfHhEiXA/0Kc6SxRSlL/jW91XUhr5fsQKrdksVl0h/ntumUvtEHrtECFkTeOoOr5qIhgYEaYP/TiZoOjHbTgJ3Qpx+eMgFJ3x6g6W1KnV+nb/rQ44ZvSVNxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=c1izC6k1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="c1izC6k1"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68TB5d9t4017642;
	Tue, 29 Sep 2026 15:33:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5AclAy
	en8c5KNNg7Ubb6G80Gn1XHE6FWHqe/kKE9Wzs=; b=c1izC6k1g/QqfdxHhqQ580
	fHTT5mkZAOP15+0nK5MdZ4RnIAWdna8fDguRra/Dcqf4UAd+L0eexInAZypRSXS5
	txhi3pf50zGSWfue9nUzie2yiC5HSsp0lCaw5cbcZNV9k3dr8prHJHarog+8M9ab
	r+SGWaQIDfxSaV9a9rDjDEhSLkQy35Mlwqt66a0i6sseaDLceAaAzqHqWlixg+0B
	h5lqollpYn/BAi/bjVgL+oXdPZuzyht+HgQQAAHwoaL5qZL/1gJZxhreB3jsABdZ
	tDS3ZwLGGBHXmlbq1UfayPicbvlV7DeGY0eSy0Flymc2egxzrzdJ3AlPkcAdl5Kw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5pt72wc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 15:33:24 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68TF1xYP1657703;
	Tue, 29 Sep 2026 15:33:23 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxrcptgfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Sep 2026 15:33:23 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68TFXN5Y22807072
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Sep 2026 15:33:23 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 435EE58056;
	Tue, 29 Sep 2026 15:33:23 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBE835805E;
	Tue, 29 Sep 2026 15:33:22 +0000 (GMT)
Received: from [9.61.145.13] (unknown [9.61.145.13])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 29 Sep 2026 15:33:22 +0000 (GMT)
Message-ID: <2c024860-4799-4410-ac57-f67a434cb5ee@linux.ibm.com>
Date: Tue, 29 Sep 2026 08:33:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 10/11] scsi: ibmvfc: register and use asynchronous sub
 CRQ for events
To: Dave Marquardt <davemarq@linux.ibm.com>, sashiko-bot@kernel.org
Cc: sashiko-reviews@lists.linux.dev, linux-scsi@vger.kernel.org
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
 <20260925044900.414340-11-tyreld@linux.ibm.com>
 <20260925050903.EEEC21F000FF@smtp.kernel.org> <87a4p157r6.fsf@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <87a4p157r6.fsf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: svXTy-bW_Ge31vp4N3IGwyxtR0IRTqyL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI5MDA2MCBTYWx0ZWRfX3fDSwhUurHhH
 0hACeq9Sw0Hf4czK3fhsaU3jbi+vu2pg138eSA6avfwTPI1msF+S09VINmRMo5W14uoSnYz4EmW
 YBh+C57IdMiQWO+uSF/maCnkU5Jaijp7y9maC1nyP8nLCZ9s4ikaD1xtP5v7foCuBSQxKm2eiHJ
 ks8hB7e697i5ZhISx2CbHpqpXtLf3NGR8DqErDPggzs5pGvinKeYtQUaBTDxd8BTGz+prWSl4V4
 d5y3U0qkuEK5f+C/LTmWxrGEhdjpmcgIsgXObGHDeISip7KnLvF21cTmu5xihzgNR16PEf3Mb6S
 9vaLK7cmTgpLPyj/5dM8NbXzQscmOFlQ7FEr6JzhadDFt7pvYiPkUgEdKpzYQrEVgzoDEH0o2hV
 mpyt5wpHABjnbfYa2gQVx5oXzBatVEfnyr65qBUO04OjatOPwj9woaCKFTy0ZuYZWnBmcDkdUTL
 haN+m9Gq91k/PBJZN7w==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI5MDA2MCBTYWx0ZWRfX5hQoN49BH+ip
 VtwcNyLlC8s41j+ktMk9wo7x4io1aSU1TpQthQ/BVPxeERC37UQKKxd4IHcaANqnQOsIOksTfef
 ntTnlJizpjL0Cfo9BOKSd/QYFm1zyGA=
X-Authority-Analysis: v=2.4 cv=EY5d0/mC c=1 sm=1 tr=0 ts=6abbda44 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=BAGDUCPmOm5mR4Ag3-sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: svXTy-bW_Ge31vp4N3IGwyxtR0IRTqyL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-29_04,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609290060

On 9/28/26 3:30 PM, Dave Marquardt wrote:
> sashiko-bot@kernel.org writes:
> 
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [High] scsi: ibmvfc: double registration of scsi_scrqs and missing async_scrqs registration
>> --
>>
>> commit d44dbe8300fc3639dbfcef8f1950443462606f5b
>> Author: Dave Marquardt <davemarq@linux.ibm.com>
>>
>> scsi: ibmvfc: register and use asynchronous sub CRQ for events
>>
>> This commit wires the async sub-CRQ into the sub-CRQ lifecycle so it is
>> allocated, registered, and freed alongside the SCSI channel queues.
>>
>>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> [ ... ]
>>> @@ -986,6 +987,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
>>>  	spin_unlock(vhost->crq.q_lock);
>>>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);
>>>  
>>> +	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>>>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>>>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>>>  
>>
>> [Severity: High]
>> Could this introduce a regression where scsi_scrqs is accidentally registered
>> twice instead of registering async_scrqs?
>>
>> Because the first call was added as ibmvfc_reg_sub_crqs(vhost,
>> &vhost->scsi_scrqs), it appears to skip the async sub-CRQ registration
>> entirely. This leaves the async sub-CRQ permanently disabled after a CRQ
>> re-enablement, which could prevent asynchronous event handling (like FPINs)
>> after recovery.
> 
> Yes, this is broken. The added call should be
> 
> 	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);

Still wrong. s/scsi_scrqs/async_scrqs

-Tyrel

> 
> and will be fixed in v12.
> 
>> Also, wouldn't the double registration of scsi_scrqs cause
>> ibmvfc_register_channel() to fail? If H_REG_SUB_CRQ returns an error for an
>> already registered channel, this will abort the registration and clear
>> vhost->do_enquiry = 0, functionally breaking multi-queue capabilities during
>> standard operational recovery paths.
> 
> -Dave
> 

