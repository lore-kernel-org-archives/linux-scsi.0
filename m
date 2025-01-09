Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827A4204089;
	Thu,  9 Jan 2025 09:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736413898; cv=none; b=c8nWVwHLUjbvJwWh5GvV3Cn89yZjCg8MzaHMj2ZgR/vJ0BXOYt3fVemvvLrTq1q6NKe9oWsVGXrccczMHIwFCYfgX8L3PYJYEgQkq9wVJ3Jzt8/NTm6IKAQhPK42MqgDln620gwj6S6t3ivWlvfnrooV/7To3szd6wHzvmgY3oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736413898; c=relaxed/simple;
	bh=MuR/76aJx4g0ejbAcPiA8tF/GmLlloRe5WZR5Rh05Vo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OCMCdYvUPbGAW5x57pw5Wnqqy0kxbkswKyZ6NyUAN9zMYMNEA5S2qQMOgi3MZaiSKNjLr4GzgUuzUHt5GkbuWsYWLtftWlAglTULf+rQ/YOCgzs6dwp1ZF1d8bsAYKD0lUZu10sHxTwS5po+4tUad8vCT20GWIcdi9YcadSo26M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ib2HN9zc; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ib2HN9zc"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5093qfso005381;
	Thu, 9 Jan 2025 09:11:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fWDrNg
	Xr2+5/tTHTTTWdIBrhC/f2oWLiWWPFVObpjT0=; b=ib2HN9zcnCeOaQ2F7+piB8
	RYJvYl44MIdXDatVwBfMBe/rjBXR5umnCVBKdsqpdFeCaZV/YOh2fDKA7zjFoZBH
	HSVPRZKx7fBehQfis38TJ3uA8vA9tK7YN1GalYehDdcOGcs764JcScQ02Lx/l0tO
	narbtz3nKyuulHvtP2HR1MS5xNi8v9NzeW9ph89xgxWN/kI2d2Gx0/rHFqujGlMA
	ux9R9wwnPv5cD/UI2jWhsQ8T1S+Wowu2Hjjz774K0lgKEdTyTnYGh4VV6yJuJ6WJ
	lPnnPSUsGFRd5EuhgLJChRxz03qjoYJi3IA4iYK16eNQPvBwpNkvNZU76f5EJ7Ew
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4426xc97s4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 09:11:22 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5095wNPO026195;
	Thu, 9 Jan 2025 09:11:21 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yj12c316-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 09:11:21 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5099BLvU47448342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Jan 2025 09:11:21 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E9E158058;
	Thu,  9 Jan 2025 09:11:21 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8FBA58059;
	Thu,  9 Jan 2025 09:11:17 +0000 (GMT)
Received: from [9.171.90.198] (unknown [9.171.90.198])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Jan 2025 09:11:17 +0000 (GMT)
Message-ID: <8dc9749a-4cce-4147-bd26-5fe61eee0567@linux.ibm.com>
Date: Thu, 9 Jan 2025 14:41:16 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/11] loop: refactor queue limits updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20250109055810.1402918-1-hch@lst.de>
 <20250109055810.1402918-11-hch@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250109055810.1402918-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uDxwUd2KbAVsvSlIR4Q5Puk9stf5a1bm
X-Proofpoint-ORIG-GUID: uDxwUd2KbAVsvSlIR4Q5Puk9stf5a1bm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=805 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501090074



On 1/9/25 11:27 AM, Christoph Hellwig wrote:
> Replace loop_reconfigure_limits with a slightly less encompassing
> loop_update_limits that expects the aller to acquire and commit the
> queue limits to prepare for sorting out the freeze vs limits lock
> ordering.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Maybe a typo: s/aller/caller/g, otherwise looks good to me:

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>

