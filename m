Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FE135BDC5;
	Fri,  9 Jan 2026 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767968603; cv=none; b=UbP3hjSZkbc/hTG8SwC+pmoR5ydTQzQ59wPCh3mi9UHCzZk1bhrTkexnjvWC+5cyLerWn87mXzEqM3VCVaLf44eK6W3gjfnfXPSpI2Jz4qJ1IJ8aXyj80tru8zmBnRFZvAW6ssczOg9lA9zTNiMZZCOyWzgOWI8MjwSQnAbZPBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767968603; c=relaxed/simple;
	bh=f4ji5JrNYjJnK+7tpf6U7XrXgVpUnmoBOAlj02bvLkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gkFM2pCJnGkalAhGM181/mmBq+uQRDZi9cgeyVvQE1mLde4FTKcVHjknO3B6eMGbO3AdeqqYRoGNM09Q7nWJoIt/++X5eRZccMH3J1PL9dg/UlZ1tVn3D7eYefEFVSIB9KBRnfTjDlvDTbOGQlqR4MLqmoGV6bztqJK/l3Kf3ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=A2ouo9V0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="A2ouo9V0"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6095WvDS011131;
	Fri, 9 Jan 2026 14:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=59/r/a
	I5K0OoqEgyLLnv/he4CAfW4XER6FAmy42xHLA=; b=A2ouo9V0gKEPEgoWVHJvDp
	q+gwPh/RanNGx6zfztNZBTKTpol/CPuZUt2Pc+6ZKllzWemia/LNbFsgPar/TnzP
	1BK+URodFp90DVfbMx/9BLnz+NetA8Hhh2jszlG43vg+/x7BzxjHZxzhWWh+Rb5d
	4X2pR8h+o7CvOByognZsbpxamM4keXulW1TGshLhdAu89qCbkKmQXyabyyegF96f
	aJsr/YKbtUP+VKKTtjMYqlsKAYJXJ9+K+RDh87Dn40QvT/XW3vkA7Xg08DPShY6h
	Xamxju0SL5IoFKYoy1pehiSPrhKZodwZYxCdaT8VuhVmabpLj6My2xPCfuEZzF4w
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betru24er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 14:23:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 609E4FOG019166;
	Fri, 9 Jan 2026 14:23:10 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bfg51mykh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Jan 2026 14:23:10 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 609EN8pJ54722956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 9 Jan 2026 14:23:09 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE48458055;
	Fri,  9 Jan 2026 14:23:08 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 744DF5803F;
	Fri,  9 Jan 2026 14:23:02 +0000 (GMT)
Received: from [9.61.242.45] (unknown [9.61.242.45])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  9 Jan 2026 14:23:02 +0000 (GMT)
Message-ID: <4c85df85-58f7-4e44-8201-2f0562f93439@linux.ibm.com>
Date: Fri, 9 Jan 2026 19:53:00 +0530
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
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
In-Reply-To: <aWELGGBf1Sl3RK6k@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=aaJsXBot c=1 sm=1 tr=0 ts=69610f4f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=X3QFjKk-CQe5qUynDdoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Fulruqw-BvHtuLrNBuUVfIF-1hvvfMDo
X-Proofpoint-ORIG-GUID: Fulruqw-BvHtuLrNBuUVfIF-1hvvfMDo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDEwNiBTYWx0ZWRfX9f0PBCb3FLp8
 NsbDl1VcrMB7sPkb5czoFSNuJ4SRjiFuk43g1PhHPhUpjED8fKOg4GItTPlZ+B0aKYRcvHEfZst
 9P9qVGai96yMyqARR9D/E1m1eU+wbeWU5NUZTo0Rog4+cCBgFfP21+zMxwz0J+9Gr9ufm9XpfFl
 g3Fnmk4aN5dpAJUZAZSUMJS5Atvp5M0zObowy+8RbhuAvWR52sgREinL/NMexs2FoACxiFEWNJF
 rtuVx4Cg2hvbRKDCztm221by4esWHRntXNgclyqNe79HR4MsjewM6aSgMaBKzTt17WJDeP/yP9H
 wiPeQXIv1uQmZ/Pl1Yj6lmiZXOY/5NiGJEe4KYuDANKnt8ZG95uvOptz6qZx2fHIVFevpH6EQFt
 vwcCJxtqnY1O5c37MoqxW8Pq4VV+K1q86tKjQDuvYav1evCCf+nSuQwLLAUE9r4vOkFf9ejZQ80
 VJ9M4wgdtscCxa38jPA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601090106


On 09/01/26 7:35 pm, Ming Lei wrote:
> On Fri, Jan 09, 2026 at 07:26:01PM +0530, Venkat Rao Bagalkote wrote:
>> On 09/01/26 6:28 pm, Ming Lei wrote:
>>> On Fri, Jan 09, 2026 at 05:51:15PM +0530, Venkat Rao Bagalkote wrote:
>>>> On 09/01/26 5:25 pm, Ming Lei wrote:
>>>>> On Fri, Jan 09, 2026 at 05:14:36PM +0530, Venkat Rao Bagalkote wrote:
>>>>>> On 09/01/26 12:19 pm, Ming Lei wrote:
>>>>>>> On Thu, Jan 08, 2026 at 09:56:39PM -0800, Christoph Hellwig wrote:
>>>>>>>> I've seen the same when running xfstests on xfs, and bisected it to:
>>>>>>>>
>>>>>>>> commit ee623c892aa59003fca173de0041abc2ccc2c72d
>>>>>>>> Author: Ming Lei <ming.lei@redhat.com>
>>>>>>>> Date:   Wed Dec 31 11:00:55 2025 +0800
>>>>>>>>
>>>>>>>>         block: use bvec iterator helper for bio_may_need_split()
>>>>>>>>
>>>>>>> Hi Christoph and Venkat Rao Bagalkote,
>>>>>>>
>>>>>>> Unfortunately I can't duplicate the issue in my environment, can you test
>>>>>>> the following patch?
>>>>>>>
>>>>>>> diff --git a/block/blk.h b/block/blk.h
>>>>>>> index 98f4dfd4ec75..980eef1f5690 100644
>>>>>>> --- a/block/blk.h
>>>>>>> +++ b/block/blk.h
>>>>>>> @@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
>>>>>>>                     return true;
>>>>>>>             bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
>>>>>>> -       if (bio->bi_iter.bi_size > bv->bv_len)
>>>>>>> +       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
>>>>>>>                     return true;
>>>>>>>             return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
>>>>>>>      }
>>>>>> Hello Ming,
>>>>>>
>>>>>>
>>>>>> This is not helping. I am hitting this issue, during kernel build itself.
>>>>> Can you confirm if it can fix the blktests ext4/056 first?
>>>>>
>>>>> If kernel building is running over new patched kernel, please provide the
>>>>> dmesg log. And if it is reproduciable, can you confirm if it can be fixed
>>>>> by reverting ee623c892aa59003 (block: use bvec iterator helper for bio_may_need_split())?
>>>> Unfortunately, even with revert, build fails.
>>>>
>>>>
>>>>
>>>> commit c64b2ee9cddcb31546c8622ef018d344544a9388 (HEAD)
>>>> Author: Super User <root@ltc-zzci-1.ltc.tadn.ibm.com>
>>>> Date:   Fri Jan 9 06:51:19 2026 -0600
>>>>
>>>>       Revert "block: use bvec iterator helper for bio_may_need_split()"
>>>>
>>>>       This reverts commit ee623c892aa59003fca173de0041abc2ccc2c72d.
>>> OK, then your issue isn't related with the above change.
>>>
>>> Can you reproduce & collect dmesg log with the bad sg/rq/bio/bvec info by
>>> applying the attached debug patch?
>>>
>>> Also if possible, please collect your scsi queue's limit info before
>>> reproducing the issue:
>>>
>>> 	(cd /sys/block/$SD/queue && find . -type f -exec grep -aH . {} \;)
>> Hello Ming,
>>
>> After applying the patch shared via attachment also, I see build failure.
>>
>> I have attached the kernel config file.
>>
>>
>> git diff
>> diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
>> index 752060d7261c..33c1b6a0a738 100644
>> --- a/block/blk-mq-dma.c
>> +++ b/block/blk-mq-dma.c
>> @@ -4,8 +4,75 @@
>>    */
>>   #include <linux/blk-integrity.h>
>>   #include <linux/blk-mq-dma.h>
>> +#include <linux/scatterlist.h>
>>   #include "blk.h"
> Hi Venkat,
>
> Thanks for your test.
>
> But you didn't apply the whole debug patch in the following link:
>
> https://lore.kernel.org/linux-block/aWD7j3NR_m6EyZv1@fedora/
>
> otherwise something like "=== __blk_rq_map_sg DEBUG DUMP ===" will be
> dumped in dmesg log.
>
>> make -j 48 -s && make modules_install && make install
>> [ 5625.770436] ------------[ cut here ]------------
>> [ 5625.770476] WARNING: block/blk-mq-dma.c:309 at
> If the whole debug patch is applied correctly, the above line number should
> have become 378 instead of original 309.
>
> Please re-apply the debug patch & reproduce again.
>

Hello Ming,


Apologies for back and forth. But I did apply the whole patch. Below is 
the git diff from my machine. Let me know, if I am missing anything.


  git diff
diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 752060d7261c..33c1b6a0a738 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -4,8 +4,75 @@
   */
  #include <linux/blk-integrity.h>
  #include <linux/blk-mq-dma.h>
+#include <linux/scatterlist.h>
  #include "blk.h"

+static void dump_rq_mapping_debug(struct request *rq, struct 
scatterlist *sglist,
+                                 int nsegs)
+{
+       struct scatterlist *sg;
+       struct bio *bio;
+       struct bvec_iter iter;
+       struct bio_vec bv;
+       int i;
+
+       pr_err("=== __blk_rq_map_sg DEBUG DUMP ===\n");
+       pr_err("DISK: %s\n", rq->q->disk ? rq->q->disk->disk_name : 
"(null)");
+
+       /* Dump nsegs vs expected */
+       pr_err("nsegs=%d nr_phys_segments=%u\n",
+              nsegs, blk_rq_nr_phys_segments(rq));
+
+       /* Dump request info */
+       pr_err("REQUEST: __data_len=%u __sector=%llu cmd_flags=0x%x "
+              "rq_flags=0x%x nr_phys_segments=%u phys_gap_bit=%u\n",
+              rq->__data_len, (unsigned long long)rq->__sector,
+              rq->cmd_flags, (__force unsigned int)rq->rq_flags,
+              rq->nr_phys_segments, rq->phys_gap_bit);
+
+       /* Dump each SG element */
+       pr_err("--- SG LIST (%d entries) ---\n", nsegs);
+       for_each_sg(sglist, sg, nsegs, i) {
+               pr_err("  sg[%d]: pfn=0x%lx offset=%u len=%u 
dma_addr=0x%llx\n",
+                      i, page_to_pfn(sg_page(sg)), sg->offset, sg->length,
+                      (unsigned long long)sg_dma_address(sg));
+       }
+
+       /* Dump each bio */
+       pr_err("--- BIO LIST ---\n");
+       for (bio = rq->bio; bio; bio = bio->bi_next) {
+               pr_err("  BIO %p: bi_iter={sector=%llu size=%u idx=%u 
bvec_done=%u} "
+                      "bi_flags=0x%x bi_opf=0x%x bi_vcnt=%u 
bi_bvec_gap_bit=%u\n",
+                      bio,
+                      (unsigned long long)bio->bi_iter.bi_sector,
+                      bio->bi_iter.bi_size, bio->bi_iter.bi_idx,
+                      bio->bi_iter.bi_bvec_done,
+                      bio->bi_flags, bio->bi_opf, bio->bi_vcnt,
+                      bio->bi_bvec_gap_bit);
+
+               /* Dump each bvec in this bio */
+               pr_err("    --- BVECS (bi_vcnt=%u) ---\n", bio->bi_vcnt);
+               for (i = 0; i < bio->bi_vcnt; i++) {
+                       struct bio_vec *bvp = &bio->bi_io_vec[i];
+
+                       pr_err("      bvec[%d]: pfn=0x%lx len=%u 
offset=%u\n",
+                              i, page_to_pfn(bvp->bv_page), bvp->bv_len,
+                              bvp->bv_offset);
+               }
+
+               /* Also dump effective bvecs via iterator */
+               pr_err("    --- EFFECTIVE BVECS (via iter) ---\n");
+               i = 0;
+               bio_for_each_bvec(bv, bio, iter) {
+                       pr_err("      eff_bvec[%d]: pfn=0x%lx len=%u 
offset=%u\n",
+                              i++, page_to_pfn(bv.bv_page), bv.bv_len,
+                              bv.bv_offset);
+               }
+       }
+
+       pr_err("=== END DEBUG DUMP ===\n");
+}
+
  static bool __blk_map_iter_next(struct blk_map_iter *iter)
  {
         if (iter->iter.bi_size)
@@ -306,6 +373,8 @@ int __blk_rq_map_sg(struct request *rq, struct 
scatterlist *sglist,
          * Something must have been wrong if the figured number of
          * segment is bigger than number of req's physical segments
          */
+       if (nsegs > blk_rq_nr_phys_segments(rq))
+               dump_rq_mapping_debug(rq, sglist, nsegs);
         WARN_ON(nsegs > blk_rq_nr_phys_segments(rq));

         return nsegs;
diff --git a/block/blk.h b/block/blk.h
index 98f4dfd4ec75..980eef1f5690 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -380,7 +380,7 @@ static inline bool bio_may_need_split(struct bio *bio,
                 return true;

         bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
-       if (bio->bi_iter.bi_size > bv->bv_len)
+       if (bio->bi_iter.bi_size > bv->bv_len - bio->bi_iter.bi_bvec_done)
                 return true;
         return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
  }
(END)


Regards,

Venkat.

> Thanks,
> Ming
>
>
