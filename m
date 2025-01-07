Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E543B339A1;
	Tue,  7 Jan 2025 07:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736233344; cv=none; b=amGuk8g8zly+A+/lejncjjo+x4/yHt1USq1RJlk8Ixif15ht02RCKHoX8qz6AGWKdHeEETgeXw9uMdwQQxo37VHrOded5uqSIH6WDAE9C4A/8SRdk+tSSfsNrrCQr2+QKy0DLwtHMQ2qRKEZDMZGoSg63nRf0viUBQrRDjKsrCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736233344; c=relaxed/simple;
	bh=8g/jj6tKQpbkUxpLIvotKa2w8L4bdVNRscYhFlIHlhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AoR/oxjEfhvT5q23NdDo/0hgRvqATPStI1p+RRaJzXiot7HwK7jcqjkC7Juv4mGC5ndcofC+cRLtQCyMB3pEMABJtfs5MSPiEetW3wY/ZGD2UTU+LZVYkK2ALTtcpUrpVclarvnsNR+/a8xbL6DTGzPxP3+pLD5laAQhhJvxFeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RTOhc78x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RTOhc78x"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 507593Mv002225;
	Tue, 7 Jan 2025 07:02:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iDpzfo
	PchipFD7MbgtJksJ+hOvAk54MTZjHHogr6pis=; b=RTOhc78xA9LBe5ufFwC5aX
	4ApeYlFmb37Inn3KhdkomDi8gVxw86hsG8NLq0OuLLL0/uv3Mw9+tTN+C29Y0SZT
	jsPu3Qx/thvofnt9P3dTXdR5arCSalkiwgZdyPpFnTpKRImxyJ8+iLZ7aBypWX3K
	sjcIuRhvSQvgiwwCg6/dmwmhcr1mAunuPLbAvgfzIbKyM+SF1XpnaqUkeXPmKchC
	Q0oBXuiheimPQFWmV1xSey8Sb/MlDS9Y4sq9BSS4hPhapV4k856YAQVW5a4CiW4C
	sCnjoABqpYNHRqNLvLZOEiLejOL+T8uF1dY8L4Cz74JORa/o8FMJylrHX7ilvpFQ
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 440gn53je6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 07:02:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5075Ic7b027938;
	Tue, 7 Jan 2025 07:02:04 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43yhhk132y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jan 2025 07:02:04 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 507723Ko44237136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Jan 2025 07:02:03 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7879D58056;
	Tue,  7 Jan 2025 07:02:03 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5487E58052;
	Tue,  7 Jan 2025 07:02:00 +0000 (GMT)
Received: from [9.109.198.241] (unknown [9.109.198.241])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Jan 2025 07:02:00 +0000 (GMT)
Message-ID: <668698f6-98d9-4e23-9ea9-ce78bafe64a5@linux.ibm.com>
Date: Tue, 7 Jan 2025 12:31:58 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] block: fix docs for freezing of queue limits updates
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        nbd@other.debian.org, linux-scsi@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-2-hch@lst.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20250107063120.1011593-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pkJ2b0c5YF9oHYd8-ypYLNMBlxg7CFnd
X-Proofpoint-GUID: pkJ2b0c5YF9oHYd8-ypYLNMBlxg7CFnd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 priorityscore=1501 phishscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=823 spamscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501070056



On 1/7/25 12:00 PM, Christoph Hellwig wrote:
> queue_limits_commit_update is the function that needs to operate on a
> frozen queue, not queue_limits_start_update.  Update the kerneldoc
> comments to reflect that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-settings.c   | 3 ++-
>  include/linux/blkdev.h | 3 +--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 8f09e33f41f6..b6b8c580d018 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -413,7 +413,8 @@ int blk_set_default_limits(struct queue_limits *lim)
>   * @lim:	limits to apply
>   *
>   * Apply the limits in @lim that were obtained from queue_limits_start_update()
> - * and updated by the caller to @q.
> + * and updated by the caller to @q.  The caller must have frozen the queue or
> + * ensure that there are outstanding I/Os by other means.

Maybe typo: "ensure that there are *NO* outstanding I/Os by other means"

>   *
>   * Returns 0 if successful, else a negative error code.
>   */
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 5d40af2ef971..e781d4e6f92d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -944,8 +944,7 @@ static inline unsigned int blk_boundary_sectors_left(sector_t offset,
>   * the caller can modify.  The caller must call queue_limits_commit_update()
>   * to finish the update.
>   *
> - * Context: process context.  The caller must have frozen the queue or ensured
> - * that there is outstanding I/O by other means.
> + * Context: process context.
>   */
>  static inline struct queue_limits
>  queue_limits_start_update(struct request_queue *q)

