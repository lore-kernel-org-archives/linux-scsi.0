Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37D234DCD2;
	Mon, 28 Sep 2026 22:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790634627; cv=none; b=ODXOMxMdE9riIXYVeyvaU7dCVqFBc5yifx9QZiGV/lZ5Olmvpqes38qGUgCehH8xTODIIoAxAQulHGvRsdbR3Euop9293cwNCnhf6Wd5Yafnn/jly8RC9XrP7G3CWpVjP/OYTm4vMYZU1YnjC+978fvf30iHnMCXnWKZJUYILug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790634627; c=relaxed/simple;
	bh=zp8K5ZPapjlT8OgD9hqnw2nUc2jyh4F+GnbjP9PWxwI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LUSU4s86ntrg14wSamEdXhI9oNR6+m7Y1NYlvUZC5jNQspOZjyki/J5T2iX+PauYO1zXed/v6rxsaWdn5lM5mL4w1LvZJxoPKqaZPrrEaJ+vOe6xo92vTS/cICEaz98LnvWDfdwlKEdVjPju8AI6Wvjb+xKFdjr13rxVys9UQJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bC/uzXuH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bC/uzXuH"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SLZwEJ2251660;
	Mon, 28 Sep 2026 22:30:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ov16wgpG1/bBp758Qshp67YYZX0XVv
	sxpIdhjePyJx8=; b=bC/uzXuHmL9TboXmzRExfYetlwgCyVxDa+hZDjVKoswhS/
	gVvSoKQkUMR02pWNqtqRA0ec6peUbUQRD6tPRX/gGXI/BOy/iYyPwhHrYnxJGJ8W
	qhF37RN+EV4JFAAkGTFX7GBbjLmIMYZp4ueO1SzFXyiR8nZulXlWdeutn47iPGj4
	b7oK5qknEHIyl3u9mDR3lxJ4bvZOfdvq5XbwgNepnncPAU/5Es76wFonvyehMnXR
	o+z9ZMzZdlYb7kmqbD5f/nk5rkFWrhPG7DOyv4p6RRfc7S6UL0C0umVkq7M1Ywgf
	3GxZTrJrOOBSAuChbabvGSOEZwDo0TnZCR9D9CPg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5s542e0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 22:30:23 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SLWavt700114;
	Mon, 28 Sep 2026 22:30:22 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsck76sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 22:30:22 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SMUMFk15532690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 22:30:22 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1031C58060;
	Mon, 28 Sep 2026 22:30:22 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2A6A5803F;
	Mon, 28 Sep 2026 22:30:21 +0000 (GMT)
Received: from d (unknown [9.61.160.252])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 28 Sep 2026 22:30:21 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: sashiko-bot@kernel.org
Cc: "Tyrel Datwyler" <tyreld@linux.ibm.com>, sashiko-reviews@lists.linux.dev,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v11 10/11] scsi: ibmvfc: register and use asynchronous
 sub CRQ for events
In-Reply-To: <20260925050903.EEEC21F000FF@smtp.kernel.org>
	(sashiko-bot@kernel.org's message of "Fri, 25 Sep 2026 05:09:03
	+0000")
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
	<20260925044900.414340-11-tyreld@linux.ibm.com>
	<20260925050903.EEEC21F000FF@smtp.kernel.org>
Date: Mon, 28 Sep 2026 17:30:21 -0500
Message-ID: <87a4p157r6.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA4OCBTYWx0ZWRfXzfCwrWHjPwEn
 EfmnxENKaCzgrFGRf7/Me0ZhiTSGufgnaT/Jbn7cWQaFlRt3QuDO+XJKT4b3UhKqCaS96UFoCBB
 YOkO8BYpYUAC9lfi3TRDSekIAWcjNOk=
X-Authority-Analysis: v=2.4 cv=HJ5WhYtv c=1 sm=1 tr=0 ts=6abaea7f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=bepc-JlDGLegi25DsoIA:9
X-Proofpoint-GUID: oEqGYczEyqIh5R6e2-cwJQBjZpM4lqkc
X-Proofpoint-ORIG-GUID: oEqGYczEyqIh5R6e2-cwJQBjZpM4lqkc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA4OCBTYWx0ZWRfX39Qcj3scf7K3
 dtZYIs1sEBLTztijVtk6yYDjqoD+tMEdug8DwDiOCzqvhMlbBg/DD3LsBroi1Ze6gVdGiFDuxG8
 RyTLK6lz2hJyaL0sFNthXfAAJoYgsbDmg7wa84p4k3PSkGsef8Cnbfrt2whcS136YpmutDC3e8h
 5NW86UhiHWOsEaQj0HNZcmD4fGLOjvdxHvef6tjC+EEyQOl4C9DVdnS7j3bGpDggwRxb+BdmeEf
 a525v7JvRRWJT31EJs/BQqoQQ+P5hL1V5yPzapH184jilQqH28IjsPNdC5aPzEgae95HFZ5eq/i
 y09EN1tRlhsCc3Nx4QKHV1aIa19hn8Pkgus5mNwxbLGLJvnmaMO7sRx3D8rJAB+ISENJ3Bh6thM
 VxFsaIKpYWS1c2LLVAB6MGHEIaNWpG5Vq9rg2o+Iaye31dV1zdCjon9G8xSAwhugllUwJR2rJRm
 JjwOvyTy+KbZcGv0Zgg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_06,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 spamscore=0 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280088

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: ibmvfc: double registration of scsi_scrqs and missing async_scrqs registration
> --
>
> commit d44dbe8300fc3639dbfcef8f1950443462606f5b
> Author: Dave Marquardt <davemarq@linux.ibm.com>
>
> scsi: ibmvfc: register and use asynchronous sub CRQ for events
>
> This commit wires the async sub-CRQ into the sub-CRQ lifecycle so it is
> allocated, registered, and freed alongside the SCSI channel queues.
>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -986,6 +987,7 @@ static int ibmvfc_reenable_crq_queue(struct ibmvfc_host *vhost)
>>  	spin_unlock(vhost->crq.q_lock);
>>  	spin_unlock_irqrestore(vhost->host->host_lock, flags);
>>  
>> +	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>>  	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);
>>  	ibmvfc_reg_sub_crqs(vhost, &vhost->nvme_scrqs);
>>  
>
> [Severity: High]
> Could this introduce a regression where scsi_scrqs is accidentally registered
> twice instead of registering async_scrqs?
>
> Because the first call was added as ibmvfc_reg_sub_crqs(vhost,
> &vhost->scsi_scrqs), it appears to skip the async sub-CRQ registration
> entirely. This leaves the async sub-CRQ permanently disabled after a CRQ
> re-enablement, which could prevent asynchronous event handling (like FPINs)
> after recovery.

Yes, this is broken. The added call should be

	ibmvfc_reg_sub_crqs(vhost, &vhost->scsi_scrqs);

and will be fixed in v12.

> Also, wouldn't the double registration of scsi_scrqs cause
> ibmvfc_register_channel() to fail? If H_REG_SUB_CRQ returns an error for an
> already registered channel, this will abort the registration and clear
> vhost->do_enquiry = 0, functionally breaking multi-queue capabilities during
> standard operational recovery paths.

-Dave
