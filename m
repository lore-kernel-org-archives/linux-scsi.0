Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6947B18EAB;
	Tue,  7 Jan 2025 18:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736272894; cv=none; b=CFwy6Fa7AoO14pfiX1WqWapxmArRM9nOBX51rB7cogzZLtgEIAMThphVkf76+b6dWKrXYJC3A+6nbRwBX35DcYPFZC4abd7ZxZGKR3xJG771DO+Mdk4Gebdenxksu2Ig6CfbG0bIFXg6yFSFm2Xh5u9gRa9nHMh8QU5tXGqgeCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736272894; c=relaxed/simple;
	bh=WV+TLZuDtrq0vN0L2SGNhb5nPcib4hM5tam8yfuu2ms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fM5RWXo8ftc1q/PSX6iqr/Q62QCgGkniuJiksZSpfg8uguTdzTg0mjjb9XGfIhwJmYNxKX6jYgKNoeY//oP2MhNXuUNlsIsfLS0rcBjEfK7pNrb+J8FXr6kp0WDrqU+QgF4DbVjh3XK1sWoqzHLDCPz9/FrjuW2IxGVEsjKv3lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QiGypGw9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QiGypGw9"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507E6Msw015736;
	Tue, 7 Jan 2025 18:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WV+TLZ
	uDtrq0vN0L2SGNhb5nPcib4hM5tam8yfuu2ms=; b=QiGypGw9DRJh2cVxPaDB6x
	y3B5BBAe67jUNjVwwRIoZO6T2GgF+CkRMmbHqj1a+ls/9wIFlPZmL+mGgxOQJiFf
	MmVVWzVqCKwE9ZimHSn3lSsW93e+qaJDD/LS3KByxf8WAghQ1+Osf/2OB/aqJMsX
	AyZ3rM5jaNm/k4dt6twbgKTjYeoGzcPp/jOUbTYs1/B04yNOgDnjz74M7RLE+Y3n
	W53CJXFyVdKb0KieeUl+6Wy9R9G6eirB+268XblHLw2wY3oLCokX6yRmPB/g1JjL
	zl6rbz5+7+PSv8nKLHSfdqYg+5jvAv5IPwCowAIlPFG3LFL4EpeKq1uPM8cmtQQw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4415r516h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 18:01:19 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 507HxGnW026189;
	Tue, 7 Jan 2025 18:01:19 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yj123f8e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 18:01:19 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 507I1IXL25362980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Jan 2025 18:01:18 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E88058063;
	Tue,  7 Jan 2025 18:01:18 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 39C3858056;
	Tue,  7 Jan 2025 18:01:15 +0000 (GMT)
Received: from [9.171.94.59] (unknown [9.171.94.59])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Jan 2025 18:01:14 +0000 (GMT)
Message-ID: <efa97d5d-49db-4f5f-9d3d-516c44ae4b16@linux.ibm.com>
Date: Tue, 7 Jan 2025 23:31:13 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] nbd: fix queue freeze vs limits lock order
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-8-hch@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250107063120.1011593-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QqOBvFfPzQZOsbRCkZDQfSEPuqyBq1cl
X-Proofpoint-GUID: QqOBvFfPzQZOsbRCkZDQfSEPuqyBq1cl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=534
 suspectscore=0 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501070149

Looks good to me.
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
