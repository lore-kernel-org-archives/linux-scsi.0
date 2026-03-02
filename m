Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B501A374730;
	Mon,  2 Mar 2026 12:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772455339; cv=none; b=nRNfgsE33S/vKK1vN05l+KCsBKgtpUqSDt14oxbYejHU2Qwtn8yo9M2idZFCVQd6LYr0WmtFncKBU6hYX0jhVfgPJum63//VaJhac5sVpxRf/1Vltx1LGAjGIHY0is/y3KN0Q5YP+a166mPbuxYF/Oo8mx1E3u5i8A5tmHcwF8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772455339; c=relaxed/simple;
	bh=VrSGnRZY+i20wtMIUl23OGbCpKp/5zTbfT+8LgnZZSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mFOOY2X02BVOXJcet1hRkRFcD6Y0JjTSzJhnCrzQZsrS24d9YST5puRWZneVN1ny2nH6U1xVfbR8HZx1N54Z0WybKO0lTcJNMUQWuMN164aEI33yjkO2+yqeKaEWNSpdeHin0hDTyIUT9yActtjpQexpWLG+p0DrrBj5VgCyGgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Adl4Lk8H; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Adl4Lk8H"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621NTPpl2526381;
	Mon, 2 Mar 2026 12:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1cfpdh
	7d7NUiRFapA4ZsGO5pLPzSlIoo90Hv5YAkRik=; b=Adl4Lk8HGgdHc4sW5TiXGI
	rdxYAlaigo83Ilup9GlNZk3mVOpeRSqOzzbV9p3tGGVvYLLVZnjQkPq+02A3AQ93
	ped35zlnMFEkyCLlXTAPp415NbM8Ot3/5LeyYga0wqkxOG6iu5ghl2Z1we3/5s7M
	OSpHU46YlQjcSmDF5F/vI2WM9DWpML/PzFcC/3QN4SSni3Uxud9OLcJiULcB+L6e
	iO/6tuOILB+cdQOPVZHvJHCD2cJbeeaLjtQHNpWCfHNXRGbmTYjJqMkPMMXum3z6
	VjqP/8z3cjwFCT93uNDvFXq3LdGNKJ/UW5LFPdMN1Gv1Jn883Diji0bWvwX6WdkQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrhxjgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:41:54 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 622BIPQW008803;
	Mon, 2 Mar 2026 12:41:53 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmdd15rr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Mar 2026 12:41:53 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 622Cfr6710027598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Mar 2026 12:41:53 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1052958051;
	Mon,  2 Mar 2026 12:41:53 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 044D95805A;
	Mon,  2 Mar 2026 12:41:47 +0000 (GMT)
Received: from [9.79.192.112] (unknown [9.79.192.112])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Mar 2026 12:41:46 +0000 (GMT)
Message-ID: <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
Date: Mon, 2 Mar 2026 18:11:45 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20260225153225.1031169-8-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69a58592 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=yPCof4ZbAAAA:8
 a=uE4UKmjsR-ftdXZgRNoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEwNiBTYWx0ZWRfXxNEYoGBOR8mq
 nNNYmrfu5pwJljSnyFeHmCwl1i1Gxf+s123X5sgU4y/RdGmt5cTtPDSeIljklIkk/yiuX5LuOWw
 eRu3m6QsGoatM/QbIMHEr+bYoPU/Yjw9UNjYbfDn6fvxm6U3ddQbTWW5UbbHomLcbyXgy2MAj3f
 An+29kpDIHfx1NJelkUU3A4aKEnVS6ggRtCUGulLQQFbRIwp4RbUgn0d+FJD+8/1LZ2Mg+N05lN
 416Ugvh9UTOUhbtF96ni3QpJUCcxAb2GM065/UMoW95zFKMXKgeR8wns7pVvovBCPiyAfLOadNo
 1ArID+lNH4mSul+9BZLl/tIMcOrLrXQXTinLuDrnJn3Q6z2NBzlb/Bs9yjUeFoHiuIRD6gPHSVf
 0L5vrfe2HRvFi6dIgMSQ9XGd7CNob0HWlXYH6CdNsjWHLWTK60/YPymUUl55Aw4kpedNgqfeJQe
 IFoiDe/gWJWDzO6y/Yw==
X-Proofpoint-GUID: MvmzdUVSct1f-_SUU63tp8YSD5KLJmBA
X-Proofpoint-ORIG-GUID: MvmzdUVSct1f-_SUU63tp8YSD5KLJmBA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020106

On 2/25/26 9:02 PM, John Garry wrote:
> Add support for delayed removal, same as exists for NVMe.
> 
> The purpose of this feature is to keep the multipath disk and cdev present
> for intermittent periods of no available path.
> 
> Helpers mpath_delayed_removal_secs_show() and
> mpath_delayed_removal_secs_store() may be used in the driver sysfs code.
> 
> The driver is responsible for supplying the removal work callback for
> the delayed work.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   include/linux/multipath.h | 17 +++++++++
>   lib/multipath.c           | 79 ++++++++++++++++++++++++++++++++++++++-
>   2 files changed, 95 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
> index 0dcfdd205237c..f7998de261899 100644
> --- a/include/linux/multipath.h
> +++ b/include/linux/multipath.h
> @@ -66,6 +66,7 @@ struct mpath_head_template {
>   };
>   
>   #define MPATH_HEAD_DISK_LIVE 			0
> +#define MPATH_HEAD_QUEUE_IF_NO_PATH		1
>   
>   struct mpath_head {
>   	struct srcu_struct	srcu;
> @@ -81,6 +82,10 @@ struct mpath_head {
>   	struct cdev		cdev;
>   	struct device		cdev_device;
>   
> +	struct delayed_work	remove_work;
> +	unsigned int		delayed_removal_secs;
> +	struct module		*drv_module;
> +
>   	unsigned long		flags;
>   	struct mpath_device __rcu 		*current_path[MAX_NUMNODES];
>   	const struct mpath_head_template	*mpdt;
> @@ -132,6 +137,7 @@ void mpath_put_head(struct mpath_head *mpath_head);
>   void mpath_requeue_work(struct work_struct *work);
>   struct mpath_head *mpath_alloc_head(void);
>   void mpath_put_disk(struct mpath_disk *mpath_disk);
> +bool mpath_can_remove_head(struct mpath_head *mpath_head);
>   void mpath_remove_disk(struct mpath_disk *mpath_disk);
>   void mpath_unregister_disk(struct mpath_disk *mpath_disk);
>   struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim,
> @@ -139,6 +145,10 @@ struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim,
>   void mpath_device_set_live(struct mpath_disk *mpath_disk,
>   			struct mpath_device *mpath_device);
>   void mpath_unregister_disk(struct mpath_disk *mpath_disk);
> +ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
> +			char *buf);
> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
> +			const char *buf, size_t count);
>   
>   static inline bool is_mpath_head(struct gendisk *disk)
>   {
> @@ -150,4 +160,11 @@ static inline bool mpath_qd_iopolicy(struct mpath_iopolicy *mpath_iopolicy)
>   	return mpath_read_iopolicy(mpath_iopolicy) == MPATH_IOPOLICY_QD;
>   }
>   
> +static inline bool mpath_head_queue_if_no_path(struct mpath_head *mpath_head)
> +{
> +	if (test_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags))
> +		return true;
> +	return false;
> +}
> +
>   #endif // _LIBMULTIPATH_H
> diff --git a/lib/multipath.c b/lib/multipath.c
> index ce12d42918fdd..1ce57b9b14d2e 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -52,6 +52,7 @@ void mpath_add_device(struct mpath_head *mpath_head,
>   	mutex_lock(&mpath_head->lock);
>   	list_add_tail_rcu(&mpath_device->siblings, &mpath_head->dev_list);
>   	mutex_unlock(&mpath_head->lock);
> +	cancel_delayed_work(&mpath_head->remove_work);
>   }
>   EXPORT_SYMBOL_GPL(mpath_add_device);
>   
> @@ -356,7 +357,17 @@ static bool mpath_available_path(struct mpath_head *mpath_head)
>   			return true;
>   	}
>   
> -	return false;
> +	/*
> +	 * If "mpahead->delayed_removal_secs" is configured (i.e., non-zero), do
> +	 * not immediately fail I/O. Instead, requeue the I/O for the configured
> +	 * duration, anticipating that if there's a transient link failure then
> +	 * it may recover within this time window. This parameter is exported to
> +	 * userspace via sysfs, and its default value is zero. It is internally
> +	 * mapped to MPATH_HEAD_QUEUE_IF_NO_PATH. When delayed_removal_secs is
> +	 * non-zero, this flag is set to true. When zero, the flag is cleared.
> +	 */
> +	return mpath_head_queue_if_no_path(mpath_head);
> +
>   }
>   
>   static void mpath_bdev_submit_bio(struct bio *bio)
> @@ -614,6 +625,29 @@ static void mpath_head_del_cdev(struct mpath_head *mpath_head)
>   		mpath_head->mpdt->del_cdev(mpath_head);
>   }
>   
> +bool mpath_can_remove_head(struct mpath_head *mpath_head)
> +{
> +	bool remove = false;
> +
> +	mutex_lock(&mpath_head->lock);
> +	/*
> +	 * Ensure that no one could remove this module while the head
> +	 * remove work is pending.
> +	 */
> +	if (mpath_head_queue_if_no_path(mpath_head) &&
> +		try_module_get(mpath_head->drv_module)) {
> +
> +		mod_delayed_work(mpath_wq, &mpath_head->remove_work,
> +				mpath_head->delayed_removal_secs * HZ);
> +	} else {
> +		remove = true;
> +	}
> +
> +	mutex_unlock(&mpath_head->lock);
> +	return remove;
> +}
> +EXPORT_SYMBOL_GPL(mpath_can_remove_head);
> +
>   void mpath_remove_disk(struct mpath_disk *mpath_disk)
>   {
>   	struct mpath_head *mpath_head = mpath_disk->mpath_head;
> @@ -711,6 +745,47 @@ void mpath_device_set_live(struct mpath_disk *mpath_disk,
>   }
>   EXPORT_SYMBOL_GPL(mpath_device_set_live);
>   
> +ssize_t mpath_delayed_removal_secs_show(struct mpath_head *mpath_head,
> +					char *buf)
> +{
> +	int ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	ret = sysfs_emit(buf, "%u\n", mpath_head->delayed_removal_secs);
> +	mutex_unlock(&mpath_head->lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_show);
> +
> +ssize_t mpath_delayed_removal_secs_store(struct mpath_head *mpath_head,
> +			const char *buf, size_t count)
> +{
> +	ssize_t ret;
> +	int sec;
> +
> +	ret = kstrtouint(buf, 0, &sec);
> +	if (ret < 0)
> +		return ret;
> +
> +	mutex_lock(&mpath_head->lock);
> +	mpath_head->delayed_removal_secs = sec;
> +	if (sec)
> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	else
> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
> +	mutex_unlock(&mpath_head->lock);
> +
> +	/*
> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
> +	 * by its reader.
> +	 */
> +	mpath_synchronize(mpath_head);
> +
> +	return count;
> +}
> +EXPORT_SYMBOL_GPL(mpath_delayed_removal_secs_store);
> +
>   void mpath_add_sysfs_link(struct mpath_disk *mpath_disk)
>   {
>   	struct mpath_head *mpath_head = mpath_disk->mpath_head;
> @@ -793,6 +868,8 @@ struct mpath_head *mpath_alloc_head(void)
>   	mutex_init(&mpath_head->lock);
>   	kref_init(&mpath_head->ref);
>   
> +	mpath_head->delayed_removal_secs = 0;
> +
>   	INIT_WORK(&mpath_head->requeue_work, mpath_requeue_work);
>   	spin_lock_init(&mpath_head->requeue_lock);
>   	bio_list_init(&mpath_head->requeue_list);

I think we also need to initialize ->drv_module here.

Thanks,
--Nilay

