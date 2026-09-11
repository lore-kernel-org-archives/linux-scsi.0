Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECED3EEADF;
	Fri, 11 Sep 2026 03:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789098115; cv=none; b=kPWT8WXk3AzEhZ+wyimYeZYUV7dp78XvIPzsKShQeVaCQ7LcvaN4yVWGZ8LHsdhXb0TwUBjcDTjlky/gDLmwZAfv7lEtQZvsiL1qtn0/4X2a1eqtiNq46tQ6rpW7VaKbYa0iSJqKfQLdA3hWOUhQaVNiM6o0Gpph+P8QFSawJIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789098115; c=relaxed/simple;
	bh=fhmiyKTA6ux8+LGn8xxlmZZr9149noT1u4dhOHOo7UY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HzLFv6c2ncs7DMAaVcHMD+H75VsYcY3eTtTIOHRixH2Eb7Cmz3uZxLH2l0ycsmW9AddqlTw4O167ZdhPVNIrrbI7Jk9PmzRNRuPxJqjKfW2DKSpQrTPFELCFE15TCsBiXsfbkO7/lGg8+7j4yuVN4VHpig3STNEYtwVAaDsnM/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DDHxh247; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DDHxh247"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12gWp348570;
	Fri, 11 Sep 2026 03:41:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=j8BXsS
	ELzOJ9f5oepM47ml/f655CyNGYQBtZdXk52js=; b=DDHxh247CGT6FHXzbWh0Tu
	jjm1nOFGO/2sxz9J17NHNInS21m7TRE45NluIO8PFgieaO/JlxDbxfZeHsI6/rpK
	YyLGuW9HPwd9YyrDTKaEfKSLtlEgYBkDxftqUxZ95cZcAa1y6XDHZypMCQLF0dRm
	hx+b7mVq+Phf5FmfXJmzOYsPEB/AzxBQmr6LmDt9j3wfPqUfCxG2tFl5Mv+F2bXS
	NgGY/dh4Lr7xn1HDKFcOMvn8UZ4ossYuy5JaUqrLv9Z1zOCc9eHN+GjpuX3G7EzP
	ytXDDGmtTXr1fE2YPdKUx9v0lfhgjKXq5L20fNN9gbQ/O+JnQpu6SzN+LFeG1yCQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8t10r6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:41:52 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B15LeX872408;
	Fri, 11 Sep 2026 03:41:52 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvwk445c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 03:41:52 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B3fpQe29753936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 03:41:51 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97DE45805D;
	Fri, 11 Sep 2026 03:41:51 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EBF658057;
	Fri, 11 Sep 2026 03:41:51 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 03:41:51 +0000 (GMT)
Message-ID: <74de72f4-a896-4944-95ac-015bcf5d9498@linux.ibm.com>
Date: Thu, 10 Sep 2026 20:41:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/9] scsi: ibmvfc: add NOOP command support
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-3-tyreld@linux.ibm.com>
 <20260911023107.AF63E1F00898@smtp.kernel.org>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260911023107.AF63E1F00898@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfXxU4hnDpUdyN7
 TaipUeaGtXUalgdL9ppLvn2yLZ/Nux2lzPral5xoEs16iAB3ndsP3tKeBFDnHp98ZefI8CvPIRM
 k8/9VNamc0MA0EKSM73PpOJ5breiRuc=
X-Proofpoint-ORIG-GUID: Y7oNbHAaVoA-S2DlFMaHvnMi-xJhu4qF
X-Proofpoint-GUID: Y7oNbHAaVoA-S2DlFMaHvnMi-xJhu4qF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDA0NSBTYWx0ZWRfX/KPP213JUjzc
 e+mPkeMbLAUhvE6Zms9ltA8IHRG598st+7qYDy447iGBKKwlPBT4n2VmYSH2YT0fXjATdtFjVAZ
 P63NpaNKzTd3tqQMCxMrJm/tAA7eWIUy6DmCO3bPyR5VIbJ16NucHIJCTHLV16kVqDbo8kbdlaW
 hWmZk4r29N0Bwlyp8adTREg1NMiNYCKZX88Rc7inb113P2JkdkrTSyaZ4vlvVxrWhQvBQnm2kYr
 TqCs9/YGeT68pWIQWfWnKUKtUSLWMSqrGHCvhPSaHoIyG9CWKuOd0cZgERhqLEX5X3jhnbBU/AS
 B96d+OWKogiKiETwYXMTOmCPdLuVDIye2ycXHpWbrKPX4+i7jSI+GZmlC/yC+Qdql2F8meMAZaN
 E7kGgrPNG6YUrIRETPm8PPXhxQRFDIjabHI2E9Lr8qaZG0rChWMI1q8EFS5ed1EJo9aL0O/Ipm+
 kGtlkAExFb2DnBTGddg==
X-Authority-Analysis: v=2.4 cv=PIGaavqC c=1 sm=1 tr=0 ts=6aa37880 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=uN6AuqMkTzWAaZc8BfUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110045

On 9/10/26 7:31 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Untrusted hypervisor input (`crq->ioba`) is dereferenced prior to validation, leading to a potential unmapped page fault (kernel panic).
> --
> 
> commit 186cace34a3b58dd32c18fecc8f7d21b71c9763c
> Author: Dave Marquardt <davemarq@linux.ibm.com>
> 
> scsi: ibmvfc: add NOOP command support
> 
> This commit adds support for handling IBMVFC_NOOP format CRQ messages from
> the VIOS partner and advertises this capability during login. It updates
> CRQ handlers to ignore NOOP messages while logging rate-limited errors if
> the partner did not advertise support. Finally, it fixes a typo and adds a
> null check for event pointers in ibmvfc_handle_scrq().
> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> index 5259a80958ce1..6b2eb82ceb98d 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> [ ... ]
>> @@ -4225,7 +4235,20 @@ static void ibmvfc_handle_scrq(struct ibmvfc_crq *crq, struct ibmvfc_host *vhost
>>  	case IBMVFC_CRQ_XPORT_EVENT:
>>  		return;
>>  	default:
>> -		dev_err(vhost->dev, "Got and invalid message type 0x%02x\n", crq->valid);
>> +		dev_err(vhost->dev, "Got an invalid message type 0x%02x\n", crq->valid);
>> +		return;
>> +	}
>> +
>> +	if (crq->format == IBMVFC_NOOP) {
>> +		if (vhost->state == IBMVFC_ACTIVE &&
>> +		    !ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CMD))
>> +			dev_err_ratelimited(vhost->dev,
>> +					    "Received unexpected NOOP command from partner\n");
>> +		return;
>> +	}
>> +
>> +	if (unlikely(!evt)) {
>> +		dev_err(vhost->dev, "Received null event\n");
>>  		return;
>>  	}
>>  
>>  	/* The only kind of payload CRQs we should get are responses to
>>  	 * things we send. Make sure this response is to something we
>>  	 * actually sent
>>  	 */
>>  	if (unlikely(!ibmvfc_valid_event(&evt->queue->evt_pool, evt))) {
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but does ibmvfc_handle_scrq()
> dereference the unvalidated evt pointer?
> 
> Since evt is derived from an untrusted hypervisor value (crq->ioba), if the
> hypervisor sends an invalid non-null pointer, evaluating &evt->queue->evt_pool
> will dereference evt->queue before ibmvfc_valid_event() can check if evt
> falls within the legitimate event pool bounds. Can this cause an unmapped
> page fault and kernel panic?
> 
> Should the implementation bypass the untrusted pointer entirely when locating
> the event pool, for instance by passing the actual scrq object from the
> caller?
> 

We trust the hypervisor/VIOS to provide a valid IOBA to the relevant evt structure.

-Tyrel
