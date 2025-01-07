Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C7941DE8AF;
	Tue,  7 Jan 2025 09:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736241846; cv=none; b=AvxW9VKDgJ8vA2GgvnV9uBRCuRXVNFnR+KE6MnjGpj3DkE796j6FliuNhtqZYKVULY48oKhNZ6GCSaWC+1UO4hLpjdjl1j2XVpXGzxpvdtahUuqi3jlJMUyJtbO5ep670J1eoHD+VgwhErjNIoLiu+L2yx0WCt3/GegdwzHb70o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736241846; c=relaxed/simple;
	bh=Leh+keWOAmdqPfU66Msbc/tl+LMHC5Lklhww/0aaMfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b17oORl7xqM6bSmo8oEWVDuE2W7ioHjsPl2cK5mx/0xr60irz6LzSZWvnx1IMhybNWhnECfOYZZHshP9IWSV0pX4JW1oaZN7FPYkkJBgSlsElxUfxruDf3gWJiUmzlS8oZEy7Phxu7r5Or3JvDVi2GzKrzJRvZiXkvWw3yyKv/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tEB/gtlz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tEB/gtlz"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50785iX5017803;
	Tue, 7 Jan 2025 09:23:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=hU44U5
	9ZPnTsKkBvwI3DzhStrcSw/HP28RyLvQxokUQ=; b=tEB/gtlz3VLBRv6TIjIeaR
	G/UoHyezU5tDf9KEiaaRTIMmOs4riVS8sX0OK8M+oHj8BXt/o2A2AfrInTAJBQEU
	97UjlEksGo2QQQ+VGPBcpM1aiX8Neond16uLrqW7yCn6flUw3nZthNzYrY26GBg2
	zuSr3YKLiD5cS2fRK8H9Q/GmyhYV8jovOKEI7oaVCGf0Okquvnwlv7fV5MWaG3XZ
	gUWJjD7oZk1ZbyJuFrNy9nvUmzJ1xfcz1C5tcfggQJ1qB6UA1eoR7BSH1S3AoADN
	Ew5OBziCAEKrqeyMFKYfmuWmJz6daZcqrS7DLvT7i++FBe8gKdzLqrJ+F2LKcPIg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4410f38a8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 09:23:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50758vfh016144;
	Tue, 7 Jan 2025 09:23:51 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygtksng7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 09:23:50 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5079Nosw31326774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Jan 2025 09:23:50 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4639E5806D;
	Tue,  7 Jan 2025 09:23:50 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FE3C58056;
	Tue,  7 Jan 2025 09:23:47 +0000 (GMT)
Received: from [9.109.198.241] (unknown [9.109.198.241])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Jan 2025 09:23:47 +0000 (GMT)
Message-ID: <90ae40c5-b695-4e17-8293-6a61648ed24a@linux.ibm.com>
Date: Tue, 7 Jan 2025 14:53:40 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] block: don't update BLK_FEAT_POLL in
 __blk_mq_update_nr_hw_queues
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, nbd@other.debian.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-4-hch@lst.de>
 <220cdd33-527f-405d-90af-2abaace36645@linux.ibm.com>
 <20250107082145.GA15960@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250107082145.GA15960@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eE9AB5kCacSOQMekbbKXzC7-ClDhEip8
X-Proofpoint-ORIG-GUID: eE9AB5kCacSOQMekbbKXzC7-ClDhEip8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=842
 spamscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501070070



On 1/7/25 1:51 PM, Christoph Hellwig wrote:
> On Tue, Jan 07, 2025 at 12:27:35PM +0530, Nilay Shroff wrote:
>> As discussed in another thread with Damien, shouldn't we need to 
>> move bdev_can_poll() to header file?
> 
> Well, if it was needed I would have done it, otherwise the code wouldn't
> compile, would it?
> 
I think, there won't be compile error because if we look at the show function
for "io_poll" attribute under sysfs, then I see it evaluates the queue limits 
feature flag BLK_FEAT_POLL and returns the value.

>> We also need to use this 
>> function while reading sysfs attribute "io-poll", no?  
> 
> This now reports polling support when the driver declared it but
> later resized the number of queues to have no queues left.  Which I
> think is a fine tradeoff if you do that.
> 
When I applied you patch on my system and access io_poll attribute
of one of my nvme disk, I see it returns 1, though I didn't configure 
poll queue for the disk. With this patch, as we're now always setting 
BLK_FEAT_POLL (under blk_mq_alloc_queue()) it return 1. So when I haven't
configured poll queue for NVMe driver, shouldn't it return 0 when I access 
/sys/block/nvmeXnY/queue/io_poll ?  

Thanks,
--Nilay

