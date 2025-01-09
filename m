Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69F0215F57;
	Thu,  9 Jan 2025 09:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736413334; cv=none; b=Wzf3Q33Z8xD7rEQfBa5VnGR7c80tscIQhO5tRyiQJB4nUgkcXJqZBLFB3SiEoLM3pvaWKQZhXJ8EMpdgvhQ2wYA3gWDKGlRoErP1Q0a6idAVzE2ivufDlpsDVVU2yCkPnPeYv0px52v3bR7+ojWLjxqXEYIfEImKhx6c/496AnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736413334; c=relaxed/simple;
	bh=VFYYjUNgu/G6uU72Z/aK164nT3WABqdC9AcIHtox2gg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hRq/g8rymSdIxoIwTrf9jTrRf+JU8PclSfsdMwG3ZbRyrMJ1/UyqZ7V1xCfvEzH50E66XwD9GvS4WpA30KJMO6C3dNXEp1P18aT12L6AmVhCRTrT/FLgEOkd1972UdSraClMrtJRufuLNrqY48H0ynmuP++fDxVa8NWk8DdptPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CZaMxwNk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CZaMxwNk"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5093qUlO005304;
	Thu, 9 Jan 2025 09:01:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Mt7svN
	WjnS+/9gpPmbijyojfhnqpHdDHs3IaA1MReO0=; b=CZaMxwNkf6W8wdDpRbi9MF
	zBNkT23Xb36SMG4tyvJH4HeLnVxOjlRK7YTDFPTyWr7q+K7hwypMkSv5eYAFuf+0
	Jftkvm2GQONS4Z/scEifoxhG9NyHl5aVBOgL+jfKTsokeau8LY5wxZP9CdAJeiXE
	RLiPM5H9d4UQnCEgb+3EGU/cuZEi1awvWPF9Vj6pUdr/zvskKySEwazOEDb7Heqw
	cyvS7trdNNL/JClTDgisuAmJ0YWdZOYRrN/sjqoTGJ6cFp/o0/UCLJts2GPr2y7V
	H0rLX3Qmq8DF//hpiCYnuXpXgv0r5Zn7z7DpZN43kOMlyJAGn6kd0SkCoF1YnfKw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4426xc96eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 09:01:56 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50988l41008970;
	Thu, 9 Jan 2025 09:01:55 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfq04fq8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 09:01:55 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50991sM012780244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Jan 2025 09:01:55 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D48F058058;
	Thu,  9 Jan 2025 09:01:54 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16E905805B;
	Thu,  9 Jan 2025 09:01:51 +0000 (GMT)
Received: from [9.171.90.198] (unknown [9.171.90.198])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Jan 2025 09:01:50 +0000 (GMT)
Message-ID: <69605291-315f-423f-aa7b-ea26b50c1065@linux.ibm.com>
Date: Thu, 9 Jan 2025 14:31:49 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/11] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250109055810.1402918-1-hch@lst.de>
 <20250109055810.1402918-5-hch@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250109055810.1402918-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4OaTNShCEKjwsjjhv6lQJ1E2nKmW2JMx
X-Proofpoint-ORIG-GUID: 4OaTNShCEKjwsjjhv6lQJ1E2nKmW2JMx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501090074



On 1/9/25 11:27 AM, Christoph Hellwig wrote:
> When __blk_mq_update_nr_hw_queues changes the number of tag sets, it
> might have to disable poll queues.  Currently it does so by adjusting
> the BLK_FEAT_POLL, which is a bit against the intent of features that
> describe hardware / driver capabilities, but more importantly causes
> nasty lock order problems with the broadly held freeze when updating the
> number of hardware queues and the limits lock.  Fix this by leaving
> BLK_FEAT_POLL alone, and instead check for the number of poll queues in
> the bio submission and poll handlers.  While this adds extra work to the
> fast path, the variables are in cache lines used by these operations
> anyway, so it should be cheap enough.
> 
> Fixes: 8023e144f9d6 ("block: move the poll flag to queue_limits")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good to me, also with this new change in v3, I re-tested use case: 
When a driver announces the support of polled I/O during initialization
and later resizing the queue so that there's no poll queue left. Both 
these cases works fine. So:

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>


