Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6695390998;
	Tue,  3 Mar 2026 12:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772541588; cv=none; b=t9Mm3YUzm98H+fvFmgKDqmHK5ogSlJpzhUO6jyqxQTD4ZyZM21r2t5FhaOeORM0g/4ZJq4vfpWnQ1Yw1BmogLMN/TzMyWK4y3ugTd2F3VYVywLvit/9GbL+L9Nrvesw1tVd6eSTxtwDnu79srJwKGc3Tz9NbcvjFz7dwwQNgvUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772541588; c=relaxed/simple;
	bh=C24BlsUkxjEwUPGD9q2LVFhzvOjC6WjQcMGConb38Ok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MXwf0r0s+I15iF4Qenfn8KPV8uv6scnhmRn7OagpEWHJevd1VlmeF/TLWLzKO2258Op076LFzOQ9HEpBLluNQWyzetsW9WsG0sK+jvMMsp/AoYl7xpqqnlchcUa+zMgRSwdFVVqOGKTmK2iZX8EfNX6QdJaEr4EdMw+zDbzXvT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nAUYFXut; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nAUYFXut"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622MA6Lu1358746;
	Tue, 3 Mar 2026 12:39:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=C2+xLJ
	jOrf0mHMOsfXZ0W791mVgLj8b0uA1iAPlTtro=; b=nAUYFXut0E4t+gIrg3IzHX
	H/R5QgUUZkamCxSaA2Jh27O0tATAQ8TAkrNwwA80C4wHpaw83b6Y5bd6+3wT+WEF
	A4NN4XwdJmvy2UwUInAxs+bPLQd1/YzVotJ8FE8hlr5THRkirgkqj0Gi8g4+TM5l
	p9nniGxcr0lAgPTIkSZ2IHSKoZN7VqbOoyrPQPxzlZbP+1+RR0T8MbyiE3jEdrSu
	/A4O6YcvC517dmSq0piC7ry1MhP1JJhZGzdqL+sDKXEKmdHD9fyrCet45mzy4Ov8
	QYVpVf4f4aP5YJme2oS8OEqd+nwCJwE87KSwh3/1zOhPWtogoWAcjmZ9Z5nfIsAw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrj2wx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 12:39:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 623979km003266;
	Tue, 3 Mar 2026 12:39:16 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmb2y2ahk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 12:39:16 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 623CdGTt655928
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Mar 2026 12:39:16 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F2DE358052;
	Tue,  3 Mar 2026 12:39:15 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3EC3B58056;
	Tue,  3 Mar 2026 12:39:10 +0000 (GMT)
Received: from [9.124.211.174] (unknown [9.124.211.174])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Mar 2026 12:39:09 +0000 (GMT)
Message-ID: <09240997-29a9-4463-9b6c-3e3ff30c8756@linux.ibm.com>
Date: Tue, 3 Mar 2026 18:09:08 +0530
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
 <98aa0bac-bf62-4e7e-b7c6-d2547ab34ef7@linux.ibm.com>
 <50b1e223-9c4d-4db9-990d-089540215953@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <50b1e223-9c4d-4db9-990d-089540215953@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69a6d676 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=f8X4eGfyVMaOK4ZuT60A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA5OSBTYWx0ZWRfX4As9N9xFuhgN
 TS4P4dIrrlQqoK++SZ4qsuDVYDDhXoVHE7WKTtsOz+3Dtk83z83AYzoQd0uOatdeNzwjNWrJI5Q
 PaEVtUgrC7VTF99RR/jJOmrfCbLz9E28Ml/ZTYV8YYSbBVOGSMy/yquNBLn7o+lS8INEmWCv9q0
 RH+ZUpTLMjhEtNFXMI0lYTp9kPtjGQY44hHqK18TqHGmwxU7mWLT9V7bTfQ5o/88L4ZxHlNLs/t
 9Opvm1yonXLfexzMrOrcUM3wNhBMogXsJDFoNvsAxSJ6+0zA1AXTCX53jwI6o2Wj7p1ArqR9jwO
 eWf3wnn9mWmCvmHUes2i3dW1DauTrmTb+M/2Fiyb30qfYdObM+k3g744dwFAfS6EdUVjVsHXVhq
 2eQbspyQKtUFE4HMkdeGXpjMfMvMpZ0Vjmbg5Iod2Voe7uIx3nJkNHd9XRpYgpRqyGk7Nsh8BLl
 Hv62EMLQdlNtvo0ddSA==
X-Proofpoint-GUID: Kgh3duCwqeI4OttrJVqyY6rmNBobK2aN
X-Proofpoint-ORIG-GUID: Kgh3duCwqeI4OttrJVqyY6rmNBobK2aN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030099

On 3/2/26 9:09 PM, John Garry wrote:
> On 02/03/2026 12:31, Nilay Shroff wrote:
>>>
>>> +#define MPATH_HEAD_DISK_LIVE             0
>>> +
>>>   struct mpath_head {
>>>       struct srcu_struct    srcu;
>>>       struct list_head    dev_list;    /* list of all mpath_devs */
>>> @@ -17,12 +34,36 @@ struct mpath_head {
>>>       struct kref        ref;
>>> +    unsigned long        flags;
>>>       struct mpath_device __rcu         *current_path[MAX_NUMNODES];
>>> +    const struct mpath_head_template    *mpdt;
>>>       void            *drvdata;
>>>   };
>> Not sure why we don't have back reference to struct mpath_disk
>> from struct mpath_head here. Does it make sense to have this?
> 
> We can get away without it.
> 
> Some more background info .. so the concept of separate mpath_head and 
> mpath_disk is driven by SCSI, which has scsi_device and scsi_disk 
> classes. The scsi_disk driver (sd.c) controls the per-path gendisk and 
> the mpath_disk, and these internals are hidden from the scsi_core (which 
> controls the scsi_device). SCSI having this layered approach makes 
> things more complicated. This is unlike NVMe, where the core driver 
> controls the NS gendisk also.
> 
>>
>>
>>> +static inline struct mpath_disk *mpath_bd_device_to_disk(struct 
>>> device *dev)
>>> +{
>>> +    return dev_get_drvdata(dev);
>>> +}
>>> +
>>> +static inline struct mpath_disk *mpath_gendisk_to_disk(struct 
>>> gendisk *disk)
>>> +{
>>> +    return mpath_bd_device_to_disk(disk_to_dev(disk));
>>> +}
>>> +
>>>   int mpath_get_head(struct mpath_head *mpath_head);
>>>   void mpath_put_head(struct mpath_head *mpath_head);
>>>   struct mpath_head *mpath_alloc_head(void);
>>> +void mpath_put_disk(struct mpath_disk *mpath_disk);
>>> +void mpath_remove_disk(struct mpath_disk *mpath_disk);
>>> +void mpath_unregister_disk(struct mpath_disk *mpath_disk);
>>> +struct mpath_disk *mpath_alloc_head_disk(struct queue_limits *lim,
>>> +            int numa_node);
>>> +void mpath_device_set_live(struct mpath_disk *mpath_disk,
>>> +            struct mpath_device *mpath_device);
>>> +void mpath_unregister_disk(struct mpath_disk *mpath_disk);
>>> +static inline bool is_mpath_head(struct gendisk *disk)
>>> +{
>>> +    return disk->fops == &mpath_ops;
>>> +}
>>>   #endif // _LIBMULTIPATH_H
>>> diff --git a/lib/multipath.c b/lib/multipath.c
>>> index 15c495675d729..88efb0ae16acb 100644
>>> --- a/lib/multipath.c
>>> +++ b/lib/multipath.c
>>> @@ -32,6 +32,135 @@ void mpath_put_head(struct mpath_head *mpath_head)
>>>   }
>>>   EXPORT_SYMBOL_GPL(mpath_put_head);
>>> +static void mpath_free_disk(struct kref *ref)
>>> +{
>>> +    struct mpath_disk *mpath_disk =
>>> +        container_of(ref, struct mpath_disk, ref);
>>> +    struct mpath_head *mpath_head = mpath_disk->mpath_head;
>>> +
>>> +    put_disk(mpath_disk->disk);
>>> +    mpath_put_head(mpath_head);
>>> +    kfree(mpath_disk);
>>> +}
>>> +
>>
>> The mpath_alloc_head_disk() doesn't get a reference to the
>> mpath_head object but here while freeing mpath_disk we put
>> the reference to mpath_head. Would that create a reference
>> imbalance? 
> 
> I think that what I done can be improved. If you check 
> nvme_mpath_alloc_disk(), when we alloc the head the ref is 1, and then 
> we rely on the disk release to release that head reference.

> 
>> Yes we got a reference to mpath_head while
>> allocating it but then these are two (alloc mpath_disk and
>> alloc mpath_head) disjoint operations. In that case, can't
>> we have both mpath_disk and mpath_head allocated under one
>> libmultipath API?
> 
> I would like to have something simpler (like mainline NVMe code), but I 
> have it this way because of SCSI, as above.
> 
I understand the intended lifetime model due to SCSI, but the current 
flow is somewhat confusing.

In nvme_mpath_alloc_disk(), mpath_disk and mpath_head are allocated
separately. However, during teardown, both objects are ultimately
released through mpath_free_disk(), which drops the reference to
mpath_head via mpath_put_head().

Since the allocation of mpath_disk and mpath_head happens independently,
it is not immediately obvious why their lifetime is tied together and
why they are not freed independently when the NVMe head node is removed.
This coupling makes the ownership and reference flow harder to reason
about.

Additionally, I noticed that nvme_remove_head() has been removed in the
NVMe code that integrates with libmultipath. IMO, It might be clearer to
retain this function and make the teardown sequence explicit (after
removing mpath_put_head() from mpath_free_disk()).
For example:

nvme_remove_head():
     mpath_unregister_disk();  /* removes mpath_disk and drops its ref */
     mpath_put_head();         /* drops mpath_head reference */
     nvme_put_ns_head();       /* drops NVMe namespace head reference */

Does the above example makes sense?

Thanks,
--Nilay
