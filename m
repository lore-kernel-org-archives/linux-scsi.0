Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0CC19D06A;
	Wed,  8 Jan 2025 10:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736333698; cv=none; b=h3460fg7pblGVp432Eu9vCmAt4mVpgDwQ8uj0Yddgh1s9ObNVt++pR4xqQ4HuUwPTJf1EoUu3JSkq1ao2/4LYjLiO9vgkSCKx5NI7tjxjLDgPFBjUujtq0Cb0RdTxCvscMzYcEA+qtuvfBuuUHJS0DcN2IILG5AoJqcznHdzc84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736333698; c=relaxed/simple;
	bh=MbJLleRuFn9zNHSYZnPeHlkUXoW2YYBS5NamUCAszBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GEOLjdVFUh7N/wvZSMcGi1zRP8/uy+b6pcowty/ioxCm0fWOkQFd0O3aWW/ekn6b293al+MFPT/N2ESBe/Q23NbAnX2IJO+zCONJyAIRA05hfjz7ayqV+kfMSkdFYYWmag7p9JO6YFjhHmXYX4FqHS7MV7Y5nUv3Z4d00JkipWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M5uiYDHV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M5uiYDHV"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507NwcRG023766;
	Wed, 8 Jan 2025 10:54:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5hG07b
	68UgfFh1mkQipWBlv55l2zeHeSTf1bLkQkuos=; b=M5uiYDHVAcYe7VHhAa6Cw3
	kJG4bcYArFb+R4QqhCAQ0AqkGIB7NhCE3bFmLUTCorU/EdwO4qGom/nWVttv3qoz
	l2upbtAFyZGEMYw/G+IcZTWbqXbhrbIrglRJpWTbBEYWnVrkeq8maOVySGRmhBHr
	sN0kKkyiy1JiV5eB9ckj4hWdL5SRqVnyElZ4O0Ciu9hzLcOjhUeqjB2ey538fTke
	dBau4lJxssPqAzN2kVIChFUwzsdA80aa2iEoNSbPsnuDBCOI3NS6L61ulIbZh33n
	SoRcdpIuG/Hl02J05cWIiT83lMDlRMRin98x6gS1m2/pXAkZxPRoPrpmH/jdKMYg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441edj2f98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 10:54:41 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5089NLGU013648;
	Wed, 8 Jan 2025 10:54:40 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygany9se-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 10:54:40 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508AsdSd19071504
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 10:54:39 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2C555805F;
	Wed,  8 Jan 2025 10:54:38 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E932658043;
	Wed,  8 Jan 2025 10:54:35 +0000 (GMT)
Received: from [9.109.198.241] (unknown [9.109.198.241])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 10:54:35 +0000 (GMT)
Message-ID: <2413a086-db69-4e55-a3eb-6f5850628132@linux.ibm.com>
Date: Wed, 8 Jan 2025 16:24:34 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-4-hch@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250108092520.1325324-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 4g16UznjjYa-fYLp2nneAuxFsf-shWbg
X-Proofpoint-ORIG-GUID: 4g16UznjjYa-fYLp2nneAuxFsf-shWbg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080085



On 1/8/25 2:55 PM, Christoph Hellwig wrote:
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

Looks good to me:

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>


