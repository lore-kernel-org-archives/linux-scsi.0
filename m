Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FE11F8906;
	Wed,  8 Jan 2025 10:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736333892; cv=none; b=e2dv8Pe8FRN9KdBLZCrYuuuP/tmH7H95rj9A+rL80apdopDpzSkhnLKjUGfZYz2TnG4S8orHo4LqKzxTSwpwS2tilA9oWV1gNpj7TAimIalbUcua9k/dtSsff6oZ6mUJ8JNEjFbqbKBl3S7x5tmBPFeeTWgaZzK97Var+2lCOp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736333892; c=relaxed/simple;
	bh=m2iA4hXdMu/gLQ7gGoX+PKsO1hGyorHRIDHOTEx3cko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l3Q8bIWtrZJWJuUUHxMD4QpFFs2lQNuQCMxsPzCKz4xCbSlvGQFiC0CfhLmU8DJVis/RjUfFKpphZWfHE7NVZ8CAUsB4twQ8uKErkcwnxr8xtCxipeyYfaROEjeZMJ7YQJqClCP7NNi9ped3yxc4fjQ/lwwcMYOPLjHberQ0FRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BzlkOVGx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BzlkOVGx"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5087eDN9007055;
	Wed, 8 Jan 2025 10:57:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=qzEdvd
	aNe/NaMS8/dlTwh4LN3q7PPGH2drrrm0YbKwM=; b=BzlkOVGx94f52UyfeKtmX/
	35Ov2RxMjukEeuNABzY/pbTXpCVjmmxeAUfbAbMh9OekLXvdhR5/FoauHQiwVJSP
	J0QrLi5EyIkJN3JQX5MzILj/ssMjo01EsffPyJ3qw+Ri0BrAHN2It9hBQZS13b49
	wexCNt4JCbc+Qs82ObOyHldF3ikU0vky+LrNkkNw92rYKB//ab6ejC+LRPL29CDE
	jHfmVdrUN/LlLrQaL6SH0TSIOOg1WuI6vbMeypEP1EGhlw59GN3BQhoaqn0sdcZs
	o/oDVG+OErpyHn7L6Jo9gjnDqgAms+9qhG8YdFn32UX5rLeejrKtP2wnQGS4nvAA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4415r54wfg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 10:57:57 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5088YQAe008870;
	Wed, 8 Jan 2025 10:57:57 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfpyyfaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 10:57:57 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508AvuXO32375394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 10:57:56 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1A7425805D;
	Wed,  8 Jan 2025 10:57:56 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B7A758059;
	Wed,  8 Jan 2025 10:57:53 +0000 (GMT)
Received: from [9.109.198.241] (unknown [9.109.198.241])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 10:57:52 +0000 (GMT)
Message-ID: <7a867d10-923e-4c9b-ab34-9d084474d499@linux.ibm.com>
Date: Wed, 8 Jan 2025 16:27:51 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] loop: fix queue freeze vs limits lock order
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-11-hch@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250108092520.1325324-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s-XVh3kn9Vi8c2_S9D4wxUMbkILVJPtf
X-Proofpoint-GUID: s-XVh3kn9Vi8c2_S9D4wxUMbkILVJPtf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=620
 suspectscore=0 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501080082



On 1/8/25 2:55 PM, Christoph Hellwig wrote:
> Match the locking order used by the core block code by only freezing
> the queue after taking the limits lock using the
> queue_limits_commit_update_frozen helper and document the callers that
> do not freeze the queue at all.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me:

Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
