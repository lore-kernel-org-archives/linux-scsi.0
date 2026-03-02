Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1645B430BA1;
	Mon,  2 Mar 2026 12:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772453333; cv=none; b=TkGAJVrZpRU8MmfPuHjr/EF3Itk0IxL18rFtoWm+Vy89OtOvWrwfXiO8ltKDVm4S+ZNK/+eR2UDtwSfqA669KjRCC5arLbVV68vT4q14HzWt9slA9gff6IMPPmdq9txBSpS6BpJSCRU2oGoQvhGW0LjplKSO/XuFHVSO3asXLDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772453333; c=relaxed/simple;
	bh=sla8cojctKUiwHPKgk8N4G+wW3LNNSyUFXZog3BOabw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m7nsDyGWYJY9djL8u6oXLeKUA98kxHwpkOZ73k9kuONpK9YjnsInqOabjNOIgxFV0veSfZYa2CRi8VjSYiSmhVZNIK3fO8IFnj5iX4v+j23uzYirEN1MoW1OzfmyQaYq/Z+zQgHJUvlzvNVoeSllTXYpakknw4asQnldAsjaL0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZEpYMunG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZEpYMunG"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621HZfPE1875826;
	Mon, 2 Mar 2026 12:08:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=+6wgKi
	boEuRhujtj6K4i1c0td5216fd90e8Ko+/ZwV0=; b=ZEpYMunGM/7RnMHEx6o6HE
	WoC3VAw5yjPhB33RMvMrQ1zs30EkS4W/17FyaRtuijaynZOkh8yprFJobJiyfHUG
	Q1Uosbg38QMgLg2K87WyAnTFqGNw1r5W5QYFwE8yHV9EEVUNqQCesMQCh+vXzg73
	8ECROJOK64wRwMT0shFnYfz5Yuy7OXw8wSrpfiGJNXCF9dU0ubPiH+fj+BDhwIQz
	qzUNxnUwZ5OMla7BT0tGhDO+s73y+sjaA4z52XS7pPcWcrUl6QXjK73efXAYyqGJ
	6efucI0CgHGEpvjPQ1rfRUKQJvNpdTXzRhRerQEDkRQRS/K2T+7QaFN4Q5fC4/2g
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrhxdj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:08:26 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6229YM2x016756;
	Mon, 2 Mar 2026 12:08:25 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmbpmwwat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:08:25 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622C8OPN25887464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 12:08:24 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 759C65805A;
	Mon,  2 Mar 2026 12:08:24 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E728858051;
	Mon,  2 Mar 2026 12:08:18 +0000 (GMT)
Received: from [9.79.192.112] (unknown [9.79.192.112])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 12:08:18 +0000 (GMT)
Message-ID: <fec9dcff-b824-47e2-a5fa-bbc493d62b0a@linux.ibm.com>
Date: Mon, 2 Mar 2026 17:38:17 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/13] libmultipath: Add initial framework
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-2-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260225153225.1031169-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69a57dba cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=yPCof4ZbAAAA:8
 a=ipGkAlj-h5eCv5jo-WsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA5NyBTYWx0ZWRfX10vyWKWe9S3H
 32/dSDHmxQSlvD3F0zBx88ZzvX8QFVrqkRFbzi70y8O31FOsIMk4o/PEbCic/rgtELA8+RJPmn3
 wxh/nYPfQWPdPzLewdVW7qpt+fHKsNudS/yQZ36fsLcLQ5+GnBe9Zbo+ee6+9mvTVhQwwd/baXf
 A5OjRBXzdekGjZbiGjZCXkWOUCZH1o0k+EGTh/Iu7Apt+s3Mh8TefcgNUn2u1jbQmuXyIXRjAIs
 +Wc63V02WZMQXNA5M5G5cueIswrrEdq/t4dj4ULGg7hSqRwZV28r8Kp1yX0ZHP/yQG1qGiy/9QG
 43SsAV/OmglMx8q6qsHMSH5gqV9cisXh8t7fKTtenuN8celtUjwSLL9jX9jcQb7ZoYJ3HRp8j9p
 OzOOB/FnjM50PVVNuv2AuGE9K2rq0H14y5pViTBsr1/Z/TDsslX67orWbmVJhrjYvpw/jWEh0pd
 ig+NDSJDWTtfThA5nBg==
X-Proofpoint-GUID: b3UupQHymc8PL0cFXZ2oDgvX-8hnY94k
X-Proofpoint-ORIG-GUID: b3UupQHymc8PL0cFXZ2oDgvX-8hnY94k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020097

Hi John,

On 2/25/26 9:02 PM, John Garry wrote:
> Add initial framework for libmultipath. libmultipath is a library for
> multipath-capable block drivers, such as NVMe. The main function is to
> support path management, path selection, and failover handling.
> 
> Basic support to add and remove the head structure - mpath_head - is
> included.
> 
> This main purpose of this structure is to manage available paths and path
> selection. It is quite similar to the multipath functionality in
> nvme_ns_head. However a separate structure will introduced after to manage
> the multipath gendisk.
> 
> Each path is represented by the mpath_device structure. It should hold a
> pointer to the per-path gendisk and also a list element for all siblings
> of paths. For NVMe, there would be a mpath_device per nvme_ns.
> 
> All the libmultipath code is more or less taken from
> drivers/nvme/host/multipath.c, which was originally authored by Christoph
> Hellwig <hch@lst.de>.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   include/linux/multipath.h | 28 +++++++++++++++
>   lib/Kconfig               |  6 ++++
>   lib/Makefile              |  2 ++
>   lib/multipath.c           | 74 +++++++++++++++++++++++++++++++++++++++
>   4 files changed, 110 insertions(+)
>   create mode 100644 include/linux/multipath.h
>   create mode 100644 lib/multipath.c
> 
> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
> new file mode 100644
> index 0000000000000..18cd133b7ca21
> --- /dev/null
> +++ b/include/linux/multipath.h
> @@ -0,0 +1,28 @@
> +
> +#ifndef _LIBMULTIPATH_H
> +#define _LIBMULTIPATH_H
> +
> +#include <linux/blkdev.h>
> +#include <linux/srcu.h>
> +
> +struct mpath_device {
> +	struct list_head	siblings;
> +	struct gendisk		*disk;
> +};
> +
> +struct mpath_head {
> +	struct srcu_struct	srcu;
> +	struct list_head	dev_list;	/* list of all mpath_devs */
> +	struct mutex		lock;
> +
> +	struct kref		ref;
> +
> +	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
> +	void			*drvdata;
> +};

Can we use current_path[] as last element and flex array (same as what
we have today under struct nvme_ns_head) so that we don't need to 
allocate array as big as MAX_NUMANODES? With flex array we can use 
num_possible_nodes() which may be much smaller than MAX_NUMANODES.

Thanks,
--Nilay
