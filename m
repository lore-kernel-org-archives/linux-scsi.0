Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBF919D06A;
	Wed,  8 Jan 2025 10:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736333831; cv=none; b=Lj83wbamYtnCVo5GT2KPubH8JYaF6Oa2ThhSKX/xS6oaD01bUA2LGYjFkoIonh8U+ywlQE1J02+Ct+bTisiEKmNxitDrAdBkCmZtyifJn7/Ah7d+gKhAVP8nb29K/QXQjxqtGCmLLsvy6p7M4Yx40AU7zU78tT1hn9K2+9T0w5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736333831; c=relaxed/simple;
	bh=R8gG714XgLnBsd4qVfsWpG27tmknVXw3lB6sGoZMKds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oS/oulKZEbQARv+FWd7KyszGOi2+Sm3vwBU8ovmEpYqdZ4Y+pEA7aj34lf9GC8n51T6aAsRAGDH403B/l7QjxzE7AtfW/usi04dGqRSl5Q/nuyZ0dlWl39Cuah1YSQQjY6GWaT/Fo03RJiTDm4dQCZGwVmm+Bi7r46Tu+hOL6jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WbKbzw8k; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WbKbzw8k"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5083rHMl007005;
	Wed, 8 Jan 2025 10:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=R8gG71
	4XgLnBsd4qVfsWpG27tmknVXw3lB6sGoZMKds=; b=WbKbzw8k0CYgwjBovEBpZC
	aVdnNC0UAVJRmzZwl/Tt04OcxcnYuOC60+GU5qls34cOPihOTEBXkX3CPewJe3sf
	frMtESlUFM/f/jKWEm8Uu1RSPZHeSuySB5PYbsCf4mBGDjrslVneLw541fGASsjo
	3riFrTNP0g3yxXrWdsI4zwKirCao5CHp+PqV/GiEAb9JIcapeZZALZSxZSgsKf4f
	2vST3QCBKSUZsZs/QA0GoCZpHlYBtOIvcKorEyiQWYCpBw+UoiPWzm7Ean77M8Vx
	3YhlEpL/iS0mPre6ju/xCODNqOZGhUhORq5XxqXAivP3RbIrEGcK2enRVzmFk8Mg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441hupss69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 10:56:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5089ALDa013645;
	Wed, 8 Jan 2025 10:56:55 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygany9y9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 10:56:55 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508AusXR6554354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 10:56:54 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1DE758043;
	Wed,  8 Jan 2025 10:56:54 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0000858053;
	Wed,  8 Jan 2025 10:56:51 +0000 (GMT)
Received: from [9.109.198.241] (unknown [9.109.198.241])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 10:56:51 +0000 (GMT)
Message-ID: <17172fda-7a31-4392-a2f3-2babb81d0100@linux.ibm.com>
Date: Wed, 8 Jan 2025 16:26:50 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] loop: refactor queue limits updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-10-hch@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250108092520.1325324-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lGhuSiRXskbWIaHFliShr1O62v9f7JnB
X-Proofpoint-GUID: lGhuSiRXskbWIaHFliShr1O62v9f7JnB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=732
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501080085



On 1/8/25 2:55 PM, Christoph Hellwig wrote:
> Replace loop_reconfigure_limits with a slightly less encompassing
> loop_update_limits that expects the aller to acquire and commit the
> queue limits to prepare for sorting out the freeze vs limits lock
> ordering.

Looks good to me:

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
