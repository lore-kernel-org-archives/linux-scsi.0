Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E468286417;
	Fri,  9 Jan 2026 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976452; cv=none; b=E7kk6uTLFU/VaBGa1iLG6LArVqGsqKzKKxGJfBq1U7yLGqwIGWVZUohjCFsGKqwQrRkP/boxpezkXW3oO9HFRwWBbSVRbJquLa+wMxTjCGz6spq6f5KsQJzZbmu3IgFc6oDpdVJC3aK5MHQoyY/7G8aHfRYOrxLKvB7fCh/YMfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976452; c=relaxed/simple;
	bh=LKzPivLPWiUjD8+xzFrmPi3gb6G1yTT4QfGzgP1BAUk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K3C90w/oM/5IVDULhRAvQFp0MmJg0/mN393uSiHGJMM5yJXHFw8JBtoTjpK/PJEBVnGGA/P94HLJMyLl5Q5kPl9Vd2clTCVOkTwM00/0Nz2YAk9o93VYtDnXVlGuiBBk9N9IyXmj2ICFPNs8JOouk8pfJjvrgJl9/m9WRhnAIOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GDKut9Jt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GDKut9Jt"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 609BY0dt026533;
	Fri, 9 Jan 2026 16:34:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HsDjOl
	7wPBdfxH8FUr/COlkksvGTqfTYTRYHTY5f954=; b=GDKut9Jt7BpUOBEp3yVBsO
	+x3UH5Z7saY0bt01c0Zq0AAeWKOxEcqyCvCMT3oVw4gIsNjByZm+FE95b5lvm9YA
	FHWkrF9TZDjihlGVYQkaqTFRiBLulkT5/RXvBibhNiaf0WEBJWWblhBYdvEixlfJ
	AZtpJ50Qd4qnvFSIV6/SfZgzeB+FxlFaE3zrUzfujo7UOuAbGWi+haDSxgV4BnW2
	kiWq5UNEKnT/X1jBCXHpRMdpue0MfUCQjX7mspR04YxOf9Qh7F+wYIXcdvWKqisB
	/egM0D1tKQmeaE9yInHPNmKi20XPKPwCfw45EnIYFiBpTizeoa5lwsG88gOD3O+Q
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4berhkjxbg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 16:34:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 609GKvB6023528;
	Fri, 9 Jan 2026 16:34:01 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bg3rmthtt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 16:34:01 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 609GY0Xm61669760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Jan 2026 16:34:00 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7641C5803F;
	Fri,  9 Jan 2026 16:34:00 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D8875804E;
	Fri,  9 Jan 2026 16:33:56 +0000 (GMT)
Received: from [9.61.242.45] (unknown [9.61.242.45])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  9 Jan 2026 16:33:55 +0000 (GMT)
Message-ID: <bb5f2037-3ecc-4f97-accf-1de96811df39@linux.ibm.com>
Date: Fri, 9 Jan 2026 22:03:54 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [next-20260108]kernel BUG at drivers/scsi/scsi_lib.c:1173!
Content-Language: en-GB
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James.Bottomley@hansenpartnership.com, leonro@nvidia.com,
        kch@nvidia.com, LKML <linux-kernel@vger.kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>, riteshh@linux.ibm.com,
        ojaswin@linux.ibm.com
References: <9687cf2b-1f32-44e1-b58d-2492dc6e7185@linux.ibm.com>
 <aWCYl3I7GtsGXIG3@infradead.org> <aWClEA6KuLP6E1cP@fedora>
 <7382f235-3e42-4b77-b18d-c38661816301@linux.ibm.com>
 <aWDspG-J1a3iyIqG@fedora>
 <b7624213-65e5-41d4-81ba-e95f885018dd@linux.ibm.com>
 <aWD7j3NR_m6EyZv1@fedora>
 <ab7635d7-70e7-4906-bdcf-90006d7edf85@linux.ibm.com>
 <aWELGGBf1Sl3RK6k@fedora>
 <4c85df85-58f7-4e44-8201-2f0562f93439@linux.ibm.com>
 <aWETXSLwAYOVdB9J@fedora>
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <aWETXSLwAYOVdB9J@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=P4s3RyAu c=1 sm=1 tr=0 ts=69612dfa cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=xuj4pbDJ7MHCKTmK_8IA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: RknvHdCHU8HrINxbokdFmjA9hjN0mgY4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDEyMyBTYWx0ZWRfXzaJq7CtRDkLo
 dh8F6hS+SzwpaUzkspph5GNhnTRUW6cdcl0RFy9hHX0UzlTMG5l58fAg66uuaHjQ9IwQpeMdhPg
 ACaGmUfbdhyl9zEsJcMyzQNGUSViLqgFojqBsPoF4c41Tx+okl50nNoel3cA9hEBvTJ8lK0LhqE
 JsGrtQoDcsyDaxASiUDYWjjf34QNvrVlzbAgRvRSSigevVy6Of2hV3rda9UgblYrwF06VSWPznD
 YkjknT2vy9j9nGNFBbfO+Upu4vhE9fzORhPKxHNW4AzgXvVLZUSH3rLdobhNAFKtTdUWFWAcKD2
 vSJGcb6iZYqFufjzUBpZzeJT5AyCFLHizR/BnLwNXPQAOz6AA1VRFhmLOLQ+TIrpmeQBYXIvZyH
 U61H7NrBziiDSjRybkLuoG2nZyTb6jwx/8VNigfAofhrbRX8kes0HGIGxc+RtF1ebayEsY8ym5b
 cUoHkA/yL1XRmAPsg4w==
X-Proofpoint-GUID: RknvHdCHU8HrINxbokdFmjA9hjN0mgY4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_05,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601090123


On 09/01/26 8:10 pm, Ming Lei wrote:
> On Fri, Jan 09, 2026 at 07:53:00PM +0530, Venkat Rao Bagalkote wrote:
>> On 09/01/26 7:35 pm, Ming Lei wrote:
>>> On Fri, Jan 09, 2026 at 07:26:01PM +0530, Venkat Rao Bagalkote wrote:
>>>> On 09/01/26 6:28 pm, Ming Lei wrote:
>>>>> On Fri, Jan 09, 2026 at 05:51:15PM +0530, Venkat Rao Bagalkote wrote:
>>>>>> On 09/01/26 5:25 pm, Ming Lei wrote:
>>>>>>> On Fri, Jan 09, 2026 at 05:14:36PM +0530, Venkat Rao Bagalkote wrote:
>>>>>>>> On 09/01/26 12:19 pm, Ming Lei wrote:
>>>>>>>>> On Thu, Jan 08, 2026 at 09:56:39PM -0800, Christoph Hellwig wrote:
>>>>>>>>>> I've seen the same when running xfstests on xfs, and bisected it to:
>>>>>>>>>>
>>>>>>>>>> commit ee623c892aa59003fca173de0041abc2ccc2c72d
>>>>>>>>>> Author: Ming Lei <ming.lei@redhat.com>
>>>>>>>>>> Date:   Wed Dec 31 11:00:55 2025 +0800
>>>>>>>>>>
>>>>>>>>>>          block: use bvec iterator helper for bio_may_need_split()
>>>>>>>>>>
>>>>>>>>> Hi Christoph and Venkat Rao Bagalkote,
>>>>>>>>>
>>>>>>>>> Unfortunately I can't duplicate the issue in my environment, can you test
>>>>>>>>> the following patch?
>>>>>>>>>
>>>>>>>>> diff --git a/block/blk.h b/block/blk.h
>>>>>>>>> index 98f4dfd4ec75..980eef1f5690 100644
>>>>>>>>> --- a/block/blk.h
>>>>>>>>> +++ b/block/blk.h
>>>>>>>>> @@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
>>>>>>>>>                      return true;
>>>>>>>>>              bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
>>>>>>>>> -       if (bio->bi_iter.bi_size > bv->bv_len)
>>>>>>>>> +       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
>>>>>>>>>                      return true;
>>>>>>>>>              return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
>>>>>>>>>       }
>>>>>>>> Hello Ming,
>>>>>>>>
>>>>>>>>
>>>>>>>> This is not helping. I am hitting this issue, during kernel build itself.
>>>>>>> Can you confirm if it can fix the blktests ext4/056 first?
>>>>>>>
>>>>>>> If kernel building is running over new patched kernel, please provide the
>>>>>>> dmesg log. And if it is reproduciable, can you confirm if it can be fixed
>>>>>>> by reverting ee623c892aa59003 (block: use bvec iterator helper for bio_may_need_split())?
>>>>>> Unfortunately, even with revert, build fails.
>>>>>>
>>>>>>
>>>>>>
>>>>>> commit c64b2ee9cddcb31546c8622ef018d344544a9388 (HEAD)
>>>>>> Author: Super User <root@ltc-zzci-1.ltc.tadn.ibm.com>
>>>>>> Date:   Fri Jan 9 06:51:19 2026 -0600
>>>>>>
>>>>>>        Revert "block: use bvec iterator helper for bio_may_need_split()"
>>>>>>
>>>>>>        This reverts commit ee623c892aa59003fca173de0041abc2ccc2c72d.
>>>>> OK, then your issue isn't related with the above change.
>>>>>
>>>>> Can you reproduce & collect dmesg log with the bad sg/rq/bio/bvec info by
>>>>> applying the attached debug patch?
>>>>>
>>>>> Also if possible, please collect your scsi queue's limit info before
>>>>> reproducing the issue:
>>>>>
>>>>> 	(cd /sys/block/$SD/queue && find . -type f -exec grep -aH . {} \;)
>>>> Hello Ming,
>>>>
>>>> After applying the patch shared via attachment also, I see build failure.
>>>>
>>>> I have attached the kernel config file.
>>>>
>>>>
>>>> git diff
>>>> diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
>>>> index 752060d7261c..33c1b6a0a738 100644
>>>> --- a/block/blk-mq-dma.c
>>>> +++ b/block/blk-mq-dma.c
>>>> @@ -4,8 +4,75 @@
>>>>     */
>>>>    #include <linux/blk-integrity.h>
>>>>    #include <linux/blk-mq-dma.h>
>>>> +#include <linux/scatterlist.h>
>>>>    #include "blk.h"
>>> Hi Venkat,
>>>
>>> Thanks for your test.
>>>
>>> But you didn't apply the whole debug patch in the following link:
>>>
>>> https://lore.kernel.org/linux-block/aWD7j3NR_m6EyZv1@fedora/
>>>
>>> otherwise something like "=== __blk_rq_map_sg DEBUG DUMP ===" will be
>>> dumped in dmesg log.
>>>
>>>> make -j 48 -s && make modules_install && make install
>>>> [ 5625.770436] ------------[ cut here ]------------
>>>> [ 5625.770476] WARNING: block/blk-mq-dma.c:309 at
>>> If the whole debug patch is applied correctly, the above line number should
>>> have become 378 instead of original 309.
>>>
>>> Please re-apply the debug patch & reproduce again.
>>>
>> Hello Ming,
>>
>>
>> Apologies for back and forth. But I did apply the whole patch. Below is the
>> git diff from my machine. Let me know, if I am missing anything.
> OK, the patch is correct.
>
> But you need to boot with one good kernel(such as, distribution shipped kernel) first
> for building new test kernel against -next tree with this patch.


Booted to a good kernel and applied your patch, and build is successful 
and it fixes the reported issue.


Also, tried with the below change, which was first suggested, and with 
this also build is successful and it fixes reported issue.


diff --git a/block/blk.h b/block/blk.h
index 98f4dfd4ec75..980eef1f5690 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
                     return true;
             bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
-       if (bio->bi_iter.bi_size > bv->bv_len)
+       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
                     return true;
             return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
      }


Regards,

Venkat.

>
> After this new test kernel is built & installed & reboot, you can start your
> kernel build workload, then the issue will be triggered, and the log is
> collected.
>
> When the issue is triggered, `WARNING: block/blk-mq-dma.c:378 ` should be
> shown in dmesg log, which signals you are running the test kernel with the
> debug patch for collecting log.
>
> Please let me know if anything is clear.
>
> Thanks,
> Ming
>
>
