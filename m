Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5036536C9F5;
	Mon,  2 Mar 2026 12:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772454699; cv=none; b=TyICcZzkzQ5N+PUUdSM948MpaN1VfDAsB07zIEszLCWc4wd+9oZD851beVEWfaM9qqm93ZQSE//5/msARGJ7yvwxwNdIE2ncRjV8AttA1raVpiy5Cl5YScRgUwOZ6uAmc6spyBfF2O1ylvYRZ6Bkt2QGpWkBIRUJJCiriAgLE3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772454699; c=relaxed/simple;
	bh=dI5Mxdbi75BXnUs2IIQvU225KkUzJCQUIQ+EQFOLRhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X1lGlBAsXJ/CuLMyoeACVjMqwRDTDXDYlBLXh0k7gqc/IPJCsrvAKdJ+93eKDzL4rpGysbYh+90Ew+kC239O6Z0iIiS4ay53DRSTLI/WVugwlWd3WheYvBKaMIcPSunmqJdE1jFB8oCgSYpbgnfzA8Q/NhUbEmS0oXC65AnkdjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C0MzRvs+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C0MzRvs+"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621NS2nK2182589;
	Mon, 2 Mar 2026 12:31:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=dSLORL
	I/87grEANj2rM6SoKUGaa7FR3DqQSrzG22o4U=; b=C0MzRvs+Ma5tG+oDVrLlTb
	nhV7jsyM8Pt22n0J72AU+5XrQIF9hUMNoIv0CPgFFmF2ylgGd/7OyBClf5SpBSTa
	x9uhrSn5BgpP3WHQaxKO0lBoYTcrAH08VFPnV0Gi8nj1SR8vhcNy42lejTan/ebr
	eJxTAHBN/GKXTRtA6yRSQ0FhfIZYkumXxbmYf1eLo5xyjFH/bw6xTCRAnQBLhud5
	S6FX74Q0llgqyLLWUthWc/FBdTFpftqpKGuPpzlTfkmIJdgi9pjGcWrvm0+PyzoG
	o0MFLkjvgT+S63ZUMOqLw3dcQ8OkraKm2xxXW2eFb2RfNrD9/aUhovH+4OwCx3SA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskcph2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:31:13 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6229YM9X016756;
	Mon, 2 Mar 2026 12:31:12 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmbpmx0f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:31:12 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622CUoio27656756
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 12:30:50 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7D8F58051;
	Mon,  2 Mar 2026 12:31:11 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B7A058060;
	Mon,  2 Mar 2026 12:31:06 +0000 (GMT)
Received: from [9.79.192.112] (unknown [9.79.192.112])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 12:31:06 +0000 (GMT)
Message-ID: <98aa0bac-bf62-4e7e-b7c6-d2547ab34ef7@linux.ibm.com>
Date: Mon, 2 Mar 2026 18:01:05 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] libmultipath: Add basic gendisk support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-3-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260225153225.1031169-3-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2Y_9jEIfo6BzAy5XXTuJ_wL1KCY4A--T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwMSBTYWx0ZWRfX/523h69KuRwA
 GAX0BWVPkVFrq6JN9sCsOWeXwDYSsQux5R2LzyKPR3vFtra3jxWwfS1z9kK/d2kDMRuaW88sSzA
 BIr+tGZulUQiZVk2jF8iFHxeNRFwmf9fbljeimZzUNYxZc5ajUlwDUxXVvHlRMpoBLnCMv2uF5b
 B8oZmfXoSz/mPpt9LAEk6jLQoknnQDQ4FCsubtM1KGOFnNLe+K/ISAI4mAoCjxUbZFDb8beOQS8
 DGj1hi4hTrfR3ExdUDmnS6v6Z1bur6cPHYHjuigqBOWMx9KekFUubevQaiVPK+Q95Z9jU2d6rXC
 2JbrlffhjFTjaFQvJdqIa2OhDDGk8tDeBpIwqRMPL4dJ/4k5fkVHvlUr6LxpDErH7yRE/b1MQlx
 2Ped+uxdFNcw9Z4pYFlzQwZjpTSviYVyl3DXy6eJWqhnYRXGs81DmLavBWykql5B8YtPEyXsUwf
 0RTfe0d9Up/wyHiVQRQ==
X-Authority-Analysis: v=2.4 cv=H7DWAuYi c=1 sm=1 tr=0 ts=69a58311 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=yPCof4ZbAAAA:8
 a=rDq5FJpoOqKp8R3o3wAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 2Y_9jEIfo6BzAy5XXTuJ_wL1KCY4A--T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020101

On 2/25/26 9:02 PM, John Garry wrote:
> Add support to allocate and free a multipath gendisk.
> 
> NVMe has almost like-for-like equivalents here:
> - mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
> - multipath_partition_scan_work() -> nvme_partition_scan_work()
> - mpath_remove_disk() -> nvme_remove_head()
> - mpath_device_set_live() -> nvme_mpath_set_live()
> 
> struct mpath_head_template is introduced as a method for drivers to
> provide custom multipath functionality.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   include/linux/multipath.h |  41 ++++++++++++
>   lib/multipath.c           | 129 ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 170 insertions(+)
> 
> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
> index 18cd133b7ca21..be9dd9fb83345 100644
> --- a/include/linux/multipath.h
> +++ b/include/linux/multipath.h
> @@ -5,11 +5,28 @@
>   #include <linux/blkdev.h>
>   #include <linux/srcu.h>
>   
> +extern const struct block_device_operations mpath_ops;
> +
> +struct mpath_disk {
> +	struct gendisk		*disk;
> +	struct kref		ref;
> +	struct work_struct	partition_scan_work;
> +	struct mutex		lock;
> +	struct mpath_head	*mpath_head;
> +	struct device		*parent;
> +};
> +
>   struct mpath_device {
>   	struct list_head	siblings;
>   	struct gendisk		*disk;
>   };
>   
> +struct mpath_head_template {
> +	const struct attribute_group **device_groups;
> +};
> +
> +#define MPATH_HEAD_DISK_LIVE 			0
> +
>   struct mpath_head {
>   	struct srcu_struct	srcu;
>   	struct list_head	dev_list;	/* list of all mpath_devs */
> @@ -17,12 +34,36 @@ struct mpath_head {
>   
>   	struct kref		ref;
>   
> +	unsigned long		flags;
>   	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
> +	const struct mpath_head_template	*mpdt;
>   	void			*drvdata;
>   };
>   
Not sure why we don't have back reference to struct mpath_disk
from struct mpath_head here. Does it make sense to have this?


> +static inline struct mpath_disk *mpath_bd_device_to_disk(struct device *dev)
> +{
> +	return dev_get_drvdata(dev);
> +}
> +
> +static inline struct mpath_disk *mpath_gendisk_to_disk(struct gendisk *disk)
> +{
> +	return mpath_bd_device_to_disk(disk_to_dev(disk));
> +}
> +
>   int mpath_get_head(struct mpath_head *mpath_head);
>   void mpath_put_head(struct mpath_head *mpath_head);
>   struct mpath_head *mpath_alloc_head(void);
> +void mpath_put_disk(struct mpath_disk *mpath_disk);
> +void mpath_remove_disk(struct mpath_disk *mpath_disk);
> +void mpath_unregister_disk(struct mpath_disk *mpath_disk);
> +struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim,
> +			int numa_node);
> +void mpath_device_set_live(struct mpath_disk *mpath_disk,
> +			struct mpath_device *mpath_device);
> +void mpath_unregister_disk(struct mpath_disk *mpath_disk);
>   
> +static inline bool is_mpath_head(struct gendisk *disk)
> +{
> +	return disk->fops == &mpath_ops;
> +}
>   #endif // _LIBMULTIPATH_H
> diff --git a/lib/multipath.c b/lib/multipath.c
> index 15c495675d729..88efb0ae16acb 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -32,6 +32,135 @@ void mpath_put_head(struct mpath_head *mpath_head)
>   }
>   EXPORT_SYMBOL_GPL(mpath_put_head);
>   
> +static void mpath_free_disk(struct kref *ref)
> +{
> +	struct mpath_disk *mpath_disk =
> +		container_of(ref, struct mpath_disk, ref);
> +	struct mpath_head *mpath_head = mpath_disk->mpath_head;
> +
> +	put_disk(mpath_disk->disk);
> +	mpath_put_head(mpath_head);
> +	kfree(mpath_disk);
> +}
> +

The mpath_alloc_head_disk() doesn't get a reference to the
mpath_head object but here while freeing mpath_disk we put
the reference to mpath_head. Would that create a reference
imbalance? Yes we got a reference to mpath_head while
allocating it but then these are two (alloc mpath_disk and
alloc mpath_head) disjoint operations. In that case, can't
we have both mpath_disk and mpath_head allocated under one
libmultipath API?

Thanks,
--Nilay


