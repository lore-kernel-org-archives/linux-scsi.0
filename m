Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBF31E0081;
	Tue,  7 Jan 2025 08:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736239528; cv=none; b=i2OdC0fXqIg7xCFoq24l5wmu7tz6UoL4Mur9KR/4oMHUYzSJrKCxXybkmehciDjByWRuqCZWr8ynzxLMUNm2HujFQUGErPWY2Mj63dExuK4VR4oHD2dYlaz93ZR3mdSNWiEbwqbPgOu3cZzeOt1CEe/QKQ6q7X7v9qBpz1AgMlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736239528; c=relaxed/simple;
	bh=jxxCY7iZoc1GEaQiBSefQAreSbXJuci7rGPN3NCol7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Raau/hCY1pOGpuf97Nxkbmu5cfSV9WcVTd9LbeAfLNCKHpKEqMjQpiws1W1t+r2FrezZleMwWVgPGTIJZ/Uw6i/Wr1WRyyOMb+505oR8+zbgMkN1LDLEw/N+2DFjbZSjG5oKPWHjD5+oxRmk3GWR1MaOiHsey43RUFTTLsEsSzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HV9jqXTD; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HV9jqXTD"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 506NxA3J024138;
	Tue, 7 Jan 2025 08:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=An/7Yw
	PguZdZtal5mzGdVsZ80ntnWORr30SjufRrII0=; b=HV9jqXTDog6DuJXx7UQuNn
	1lWXprILaAQdnkRIw/5lvBf9mOi9NdXSspgz6UYADush991ZiPFzbYG9Co++eE5o
	7SFxIp7I5TSqQr+gJBjqGD2kPWpf2vEdAzqHExb3Alj0gkemXg/0w/WciXzLh+Rp
	RYbzMlffDTVGx7KKyy8rTHUWJduWUxDLvCWFF3+tvgIWkFujeQhE0vw6C+CRGGNr
	qRGbhi8bI/iMd7fVRppwqCby2jRVEPvlDxoC7cDR/wVmiALdmRbCfO7+QisdoJTH
	BkbAQKGy2eY2rORPYdZ29fbYlSPZ+FEtEdbqPpfbRy48+LawCyingz4eEwghPuTA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 440sahhucs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 08:45:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50768hx9026171;
	Tue, 7 Jan 2025 08:45:10 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yj121bdf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 08:45:10 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5078jAkh16777844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Jan 2025 08:45:10 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29F7F5805A;
	Tue,  7 Jan 2025 08:45:10 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 147D758052;
	Tue,  7 Jan 2025 08:45:07 +0000 (GMT)
Received: from [9.109.198.241] (unknown [9.109.198.241])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Jan 2025 08:45:06 +0000 (GMT)
Message-ID: <263963d9-ac40-4f87-b38a-edb4202d294c@linux.ibm.com>
Date: Tue, 7 Jan 2025 14:15:05 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] nvme: fix queue freeze vs limits lock order
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, nbd@other.debian.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-7-hch@lst.de>
 <96c48ba0-3db5-4504-a456-e57440aa1b56@linux.ibm.com>
 <20250107082224.GB15960@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250107082224.GB15960@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: M2dqWYWIBMLItYkJibPc5ndXAo2l1a2P
X-Proofpoint-ORIG-GUID: M2dqWYWIBMLItYkJibPc5ndXAo2l1a2P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=536 impostorscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 spamscore=0 suspectscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501070070



On 1/7/25 1:52 PM, Christoph Hellwig wrote:
> On Tue, Jan 07, 2025 at 12:28:29PM +0530, Nilay Shroff wrote:
>>> -	blk_mq_freeze_queue(ns->disk->queue);
>>>  	lim = queue_limits_start_update(ns->disk->queue);
>>>  	nvme_set_ctrl_limits(ns->ctrl, &lim);
>>> +
>>> +	blk_mq_freeze_queue(ns->disk->queue);
>>>  	ret = queue_limits_commit_update(ns->disk->queue, &lim);
>>>  	set_disk_ro(ns->disk, nvme_ns_is_readonly(ns, info));
>>>  	blk_mq_unfreeze_queue(ns->disk->queue);
>>
>> I think we should freeze queue before nvme_set_ctrl_limits(). 
> 
> Why?
>
The nvme_set_ctrl_limits() sets certain queue limits which are 
also used during IO processing. For instance, ->max_segment_size
is used while submitting bio.
Also, if we look at the code before your patch, nvme_set_ctrl_limits()
is called when the queue is freezed.

Thanks,
--Nilay
