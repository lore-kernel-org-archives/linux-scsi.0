Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3B21DD874;
	Mon,  6 Jan 2025 12:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736165243; cv=none; b=A1pT+JhLNn3Ay4CcBS9YyLauldmz8YJLzmS5/Jm4qTDGhbMYU/lV6No2+H6pyshImVCOkfvkZtyAeWG0sxA6UxkdPDPzkDvFYh8b7B0MCH09uDCwVNzCa8eZy7hzonGhsEIWyud41+VsKQdvcOo+snTgIpbFm9FZGv7/6N0Lvpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736165243; c=relaxed/simple;
	bh=E+BePA26lQ+3BE5R5hN21yCbrEw4ze4grrrgRck6UMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xn6V1GWeC1JOW9r/177FjOsYXigieCleIyF+5Xrc/+WJ8sucKIk6CacQGBM/5cciLKfNKCkssEuyeQtdWWldw9GaLmF8wjIqRTMNThxpK4/fUyc7nJI1BKyeZru4JUESsv1oGbsfIxQkrFrj7vUT1BRx0OJfZquSq6+Lq9KD228=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MmnwOSfr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MmnwOSfr"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50600EP9030214;
	Mon, 6 Jan 2025 12:06:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5VYWlz
	s54e2fOmMAsKWa3Enn7OneHP0TVzdAjmuEUBA=; b=MmnwOSfrasbMdxNoavd2+L
	4d7fSl3FOGZplpA4l0jmfDLoT9xlvB+sAsuxkdGIgqXdrZ+8XzudwBEaU6SRpvEn
	1uzFkzlm0CHPNoLibzdYj0GZLuGvNj8vgKYb64JZar11tcW3EfCoXL9rYebMJkHr
	TL1S2733SpeMdbLtDcSY6KjOxLLS1NOeodkCGC85+LwovgmIYUHHmivalelEMGPd
	bnPzz7e6mVBOIS6DRq6zVGgz6Mxc9Wckub2qUecurHEpV8fN3pZ0R0qIC4eRPksN
	gA62FgNVMFf6/gDTiGgv6dARaBzcBdmGVEIOMHflttA4tj6Jpo+AcwOrvvoMfuRA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44047haeuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jan 2025 12:06:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50696WKH003630;
	Mon, 6 Jan 2025 12:06:58 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yfaswspx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jan 2025 12:06:58 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 506C6vCc32244426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Jan 2025 12:06:57 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62C0258058;
	Mon,  6 Jan 2025 12:06:57 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F24FD5805C;
	Mon,  6 Jan 2025 12:06:53 +0000 (GMT)
Received: from [9.171.85.164] (unknown [9.171.85.164])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Jan 2025 12:06:53 +0000 (GMT)
Message-ID: <3fb212e4-8fff-45fc-9cff-f5b5eaff4231@linux.ibm.com>
Date: Mon, 6 Jan 2025 17:36:52 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, nbd@other.debian.org,
        virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
References: <20250106100645.850445-1-hch@lst.de>
 <20250106100645.850445-6-hch@lst.de>
 <4addcb5e-fc88-4a86-a464-cc25d8674267@linux.ibm.com>
 <20250106110532.GA22062@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250106110532.GA22062@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FGJElPxHemmUGQZFUCCrmUdflIso0Eah
X-Proofpoint-ORIG-GUID: FGJElPxHemmUGQZFUCCrmUdflIso0Eah
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=380 bulkscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501060106



On 1/6/25 4:35 PM, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 04:31:23PM +0530, Nilay Shroff wrote:
>>> +static bool bdev_can_poll(struct block_device *bdev)
>>> +{
>>> +	struct request_queue *q = bdev_get_queue(bdev);
>>> +
>>> +	if (queue_is_mq(q))
>>> +		return blk_mq_can_poll(q->tag_set);
>>> +	return q->limits.features & BLK_FEAT_POLL;
>>> +}
>>> +
>>
>> Should we make bdev_can_poll() inline ?
> 
> I don't really see the point.  It's file local and doesn't have any
> magic that could confuse the code generator, so we might as well leave
> it to the compiler.  Although that might be about to change per the
> discussion with Damien, which could require it in blk-sysfs, in
> which case it should become an inline in a header.
> 
Oh yes, I saw that you moved blk_mq_can_poll() to blk-mq.h and 
made it inline so thought why bdev_can_poll() can't be made inline?
BTW, bdev_can_poll() is  called from IO fastpath and so making it inline 
may slightly improve performance. 
On another note, I do see that blk_mq_can_poll() is now only called 
from bdev_can_poll(). So you may want to merge these two functions 
in a single call and make that inline.

Thanks,
--Nilay
