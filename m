Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2B2359703;
	Fri,  9 Jan 2026 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959111; cv=none; b=MtFHfCEcUREtRXshcFXBYIaMJ2G4n4a8rIn8T8nAaSqXsyHBSFdvaj/oVD5V5uHfFDcjJdWn4UdWG1iqp79a4kF2fRmw28RtKS2MKIj1z6PHhtwT4kDFcj3fj7OqvuF3KVzBW45rCafOa6qPhQKcQQTop7F7TjHDFLLoNdQWJoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959111; c=relaxed/simple;
	bh=mhA2WE5YdbYpKiWrWkc0wQLOiZBlC2lm2ta2o06KyvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KB139cwRIGMW53AFqCOUQH/plhYtcoAor/xN+LKwHMxMbzQB7JkNJIn+d4b0QaWR8QoZVQBnnPTa+pVOejuOQz4eQ8e6wVHAgJ10c4/AtSmCA48Mgdyzr1VPyl2BDshCRJAGJK0+EeHAe5bD/mpgoIpb7+1NR8699kMUxd86HQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X49H/2SJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X49H/2SJ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 608N21Lx020447;
	Fri, 9 Jan 2026 11:44:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eVJkrR
	IlPlNE1u8PhIsCmWB8ASvcmt1zU3e0QFsnlq8=; b=X49H/2SJoXrhpm5zE5B3O3
	vShz+oQuQdS7kuqhj9Ugsl5obxWfiI4BQc78YTZQG2X28VsVgFBPmqt13jdbdsjt
	WTIAsHgQjIrqPB1goneRLUJcN/4yVTxcvPzwryY7nMZsSqWLIQLLQHOl075Ok2SA
	cueRcCJ0bNpJ8TIEt7vgUUerxbQiBfD/OOPyDr1b67SfY4Sjg3KAak3bb/wP3EYj
	NIiyOb96E1KUVJPcAXRPoCi5wM42nPKrXlTyMhmKcoZJ0MF5azw0WIJsCs30m7tC
	1hvInhjoSpNOr7/CdZQD03GBuU7AQw6dtFNwQqL2hOHXsxV+hpqKAgMtgR4fIkdQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm7k5b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 11:44:45 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 609ACmMH005250;
	Fri, 9 Jan 2026 11:44:43 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bfexkmhes-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 11:44:43 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 609Bigar8455152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Jan 2026 11:44:42 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77F065803F;
	Fri,  9 Jan 2026 11:44:42 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1E685804E;
	Fri,  9 Jan 2026 11:44:37 +0000 (GMT)
Received: from [9.61.242.45] (unknown [9.61.242.45])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  9 Jan 2026 11:44:37 +0000 (GMT)
Message-ID: <7382f235-3e42-4b77-b18d-c38661816301@linux.ibm.com>
Date: Fri, 9 Jan 2026 17:14:36 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Content-Language: en-GB
To: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com,
        leonro@nvidia.com, kch@nvidia.com, LKML <linux-kernel@vger.kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
        ojaswin@linux.ibm.com
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org> <aWClEA6KuLP6E1cP@fedora>
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <aWClEA6KuLP6E1cP@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OdmVzxTY c=1 sm=1 tr=0 ts=6960ea2d cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=ZSwmDl59XQ3ZRDoAEsAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: RnskR7Mg3oAT6xLZs4W7yYcXR9OpnEwb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDA4MyBTYWx0ZWRfXwZHD4QCCvvJr
 ki4+y98fpDlLknhJ1pE4iu+ma0HKsDDUyMhuDyet+H7GeeyZNjxBTjJu14sS/0w1ayTIMunV110
 9Chw3RQTlMOkJ6GdozssizXYAPxpDUlroFrx2ounu/H2fit/taiKNqmjgqSluFOI3kcGI0lQTlv
 bUY78YZtFTOCszmWzyLegsD+4lvkwC7H3jkeZyi3LQc5pksoRHmzdlCQPLlg4HcwDKXIBQBSqTU
 jxMXXT2DUwCgFnsK5TUf2+QD/Jh187NjGy3k6SaiQ37EiWb9tKHIlJ5vXwR9bH6vu8ty3TiMC9h
 itsQlCwbsL0RMNaJDn1mM5iWY3ZEA9sBW3IbTXwlXCmSEmyP8iLhK/5GhOUAjRWYzFz2OuhkzVk
 dCvhq+wA0yuZ/leSOnIWQ6xbKdoNKK3/Xopey2mxasirEnAfEeZxXhtDFOHx9K8ZGMzQtz72TCN
 /2EWxM5ry90mlZUcbeQ==
X-Proofpoint-ORIG-GUID: RnskR7Mg3oAT6xLZs4W7yYcXR9OpnEwb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601090083


On 09/01/26 12:19 pm, Ming Lei wrote:
> On Thu, Jan 08, 2026 at 09:56:39PM -0800, Christoph Hellwig wrote:
>> I've seen the same when running xfstests on xfs, and bisected it to:
>>
>> commit ee623c892aa59003fca173de0041abc2ccc2c72d
>> Author: Ming Lei <ming.lei@redhat.com>
>> Date:   Wed Dec 31 11:00:55 2025 +0800
>>
>>      block: use bvec iterator helper for bio_may_need_split()
>>
> Hi Christoph and Venkat Rao Bagalkote,
>
> Unfortunately I can't duplicate the issue in my environment, can you test
> the following patch?
>
> diff --git a/block/blk.h b/block/blk.h
> index 98f4dfd4ec75..980eef1f5690 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
>                  return true;
>   
>          bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
> -       if (bio->bi_iter.bi_size > bv->bv_len)
> +       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
>                  return true;
>          return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
>   }

Hello Ming,


This is not helping. I am hitting this issue, during kernel build itself.


Regards,

Venkat.

>
> Thanks,
> Ming
>
>
