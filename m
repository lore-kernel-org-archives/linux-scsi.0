Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4E53DA5D4;
	Tue,  3 Mar 2026 11:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772535705; cv=none; b=BL3d9OXqRZyuBG9A08PVT4/7WNGYlFNNZ3XunYNkvww8xbvsLngUkRoO52Ywr3GQRJKKulie2QnUozwSCo/z8IB55rXJyGyJJKE/cjfn2gFebJyR/jV9EZWT1+nGpgtdshpb+az8DNe6upU2JapjlgBzzYKPAXRcDBAg3q+w+bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772535705; c=relaxed/simple;
	bh=c75Czd/WuSxAxL7HBZ8ph01D/n6FrkUU+B9CLkB8dnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AlxnbhhnQTSWmE2ohRkLRTQiKeJs8Re+SD0J3Y+J0YxVvUUrtxzqfz+s6lnCtc5ZswjhpdMDEMaxXmFBXE2ziZd/ijrWJqa64TR9pjI90YqF+tXyumflYQ6qOgPG32BXB6xcj0qqQwSkryqGzVsMkKd8ADyxwelLJzgiKQSlWB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=dIvcPKEM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="dIvcPKEM"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623545Tw2063768;
	Tue, 3 Mar 2026 11:01:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Pz6W5X
	TViXjXNBWwPK//f19ZN9+SGTRlKphirex+vPU=; b=dIvcPKEMfH9L0VHBAgRYG5
	+uV4X1rg853lkKGtgmXizAJX4L3E17/Jy6G62ZbGzJERnspyzC+3i/FZ8SVChuOz
	C0Gf14bw8zV5SjjmMNwwO52KRZ9LSAi9HyE1pkleCrHMiaayMInM0nitlGXsyaIN
	1fzvCBZ0Gt3qHO5jkd6VYw70PZZu/sQAq39r6j24a1S9gvLSR6eyBw+1Mau72dip
	6FEjDf7b6dNpk4nq3yX24psYbebMrSJzJ0VE5FbYyufTlaKWeI7i0tKs3x7dMgRt
	udZbfKnZ6EF7PdxSUNjqplsiSRUd0Sbcl7temn1oEmcBX1EMDRSbFItwfGJt+15A
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ckskbtaf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 11:01:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 623AYo8Z010335;
	Tue, 3 Mar 2026 11:01:08 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmc6k1thj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 11:01:08 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 623B17RB30016112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Mar 2026 11:01:08 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9329580D3;
	Tue,  3 Mar 2026 11:01:07 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDA51580D2;
	Tue,  3 Mar 2026 11:01:01 +0000 (GMT)
Received: from [9.124.211.174] (unknown [9.124.211.174])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Mar 2026 11:01:01 +0000 (GMT)
Message-ID: <bb4df6e1-cd83-4a73-af67-f83c543d6e6c@linux.ibm.com>
Date: Tue, 3 Mar 2026 16:31:00 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/13] libmultipath: Add path selection support
To: John Garry <john.g.garry@oracle.com>, hch@lst.de, kbusch@kernel.org,
        sagi@grimberg.me, axboe@fb.com, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-4-john.g.garry@oracle.com>
 <775dd360-ea41-4e27-9690-e0633e0522d7@linux.ibm.com>
 <f9fb6d73-9b90-4c11-ae1f-3f2e76773d7f@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <f9fb6d73-9b90-4c11-ae1f-3f2e76773d7f@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 112SSYPwvQ1fPTytZawkBdxWb6kjkNkm
X-Authority-Analysis: v=2.4 cv=b66/I9Gx c=1 sm=1 tr=0 ts=69a6bf75 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=yPCof4ZbAAAA:8
 a=ZfRzAisczin3gzfXZHYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDA4MSBTYWx0ZWRfX+DiNchBZqfTc
 AQzx2tFHh2mKaWkBpjsnPgnxf1RmrBcae8G6vPT2+hXFFFm4sNwgIftrCwT/wW2h6oUb8BXDxEA
 BP7NCiM332PYNcotWMQ9GrpJMb3gEbLdKqfk4S6fpYWx8uhST3iW1sl99w4UILs9JcLxphDCwbS
 zmbeHao3nfMncErfISA8fic58zaTyXmjYPH1h2GInfNkR/WKhswtzI8RpV71wuZsU21g29F1C5d
 WDPCLA9CzCz6XJ/e3sKmGjmjzM96YzFbSns9utKY1mpW6N1iXQzOlbJLNSgGOXg24kQTBTleXFo
 X78mSOVN5hYjjQKnx+X9K31RSe/qNIrR/jQAePmHiDQq71KYoY+DURlF2ze3j7So8ftVkPttUte
 tBQD7hEqYx3uTrrTD23nPU+5+tq5UGZzinWUZ+6WxURbumThWDMu3yyPpi3Hy0HtLkZ2fWFL2/7
 LK5vkGpBrq6+qrRTXsg==
X-Proofpoint-GUID: 112SSYPwvQ1fPTytZawkBdxWb6kjkNkm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_05,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015 adultscore=0
 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603030081

On 3/2/26 8:41 PM, John Garry wrote:
> On 02/03/2026 12:36, Nilay Shroff wrote:
>> On 2/25/26 9:02 PM, John Garry wrote:
>>> Add code for path selection.
>>>
>>> NVMe ANA is abstracted into enum mpath_access_state. The motivation 
>>> here is
>>> so that SCSI ALUA can be used. Callbacks .is_disabled, .is_optimized,
>>> .get_access_state are added to get the path access state.
>>>
>>> Path selection modes round-robin, NUMA, and queue-depth are added, same
>>> as NVMe supports.
>>>
>>> NVMe has almost like-for-like equivalents here:
>>> - __mpath_find_path() -> __nvme_find_path()
>>> - mpath_find_path() -> nvme_find_path()
>>>
>>> and similar for all introduced callee functions.
>>>
>>> Functions mpath_set_iopolicy() and mpath_get_iopolicy() are added for
>>> setting default iopolicy.
>>>
>>> A separate mpath_iopolicy structure is introduced. There is no iopolicy
>>> member included in the mpath_head structure as it may not suit NVMe, 
>>> where
>>> iopolicy is per-subsystem and not per namespace.
>>>
>>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>> ---
>>>   include/linux/multipath.h |  36 ++++++
>>>   lib/multipath.c           | 251 ++++++++++++++++++++++++++++++++++++++
>>>   2 files changed, 287 insertions(+)
>>>
>>> diff --git a/include/linux/multipath.h b/include/linux/multipath.h
>>> index be9dd9fb83345..c964a1aba9c42 100644
>>> --- a/include/linux/multipath.h
>>> +++ b/include/linux/multipath.h
>>> @@ -7,6 +7,22 @@
>>>   extern const struct block_device_operations mpath_ops;
>>> +enum mpath_iopolicy_e {
>>> +    MPATH_IOPOLICY_NUMA,
>>> +    MPATH_IOPOLICY_RR,
>>> +    MPATH_IOPOLICY_QD,
>>> +};
>>> +
>>> +struct mpath_iopolicy {
>>> +    enum mpath_iopolicy_e    iopolicy;
>>> +};
>>> +
>>> +enum mpath_access_state {
>>> +    MPATH_STATE_OPTIMIZED,
>>> +    MPATH_STATE_ACTIVE,
>>> +    MPATH_STATE_INVALID    = 0xFF
>>> +};
>> Hmm so here we don't have MPATH_STATE_NONOPTIMIZED.
>> We are morphing NVME_ANA_NONOPTIMIZED as MPATH_STATE_ACTIVE.
> 
> Yes, well it is treated the same (as NVME_ANA_NONOPTIMIZED) for path 
> selection.
> 
>> Is it because SCSI doesn't have (NONOPTIMIZED) state?
> 
> It does have an active (and optimal) state, but I think that keeping 
> NVMe terminology may be better for now.
> 
>>
>>> +
>>>   struct mpath_disk {
>>>       struct gendisk        *disk;
>>>       struct kref        ref;
>>> @@ -18,10 +34,16 @@ struct mpath_disk {
>>>   struct mpath_device {
>>>       struct list_head    siblings;
>>> +    atomic_t        nr_active;
>>>       struct gendisk        *disk;
>>> +    int            numa_node;
>>>   };
>> I haven't seen any API which help set nr_active or numa_node.
> 
> I missed setting numa_node for NVMe. About nr_active, that is set/read 
> by the NVMe code, like nvme_mpath_start_request(). I did try to abstract 
> that function into a common helper, but it just becomes a mess.
> 
The nvme_mpath_start_request() increments ns->ctrl->nr_active, and 
nvme_mpath_end_request() decrements it. This means that nr_active is 
maintained per controller. If multiple NVMe namespaces are created and 
attached to the same controller, their I/O activity is accumulated in 
the single ctrl->nr_active counter.

In contrast, libmultipath defines nr_active in struct mpath_device, 
which is referenced from struct nvme_ns. Even if we add code to update 
mpath_device->nr_active, that accounting would effectively be per 
namespace, not per controller.

The nr_active value is used by the queue-depth policy. Currently, 
mpath_queue_depth_path() accesses mpath_device->nr_active to make 
forwarding decisions. However, if mpath_device->nr_active is maintained 
per namespace, it does not correctly reflect controller-wide load when 
multiple namespaces share the same controller.

Therefore, instead of maintaining a separate nr_active in struct 
mpath_device, it may be more appropriate for mpath_queue_depth_path() to 
reference ns->ctrl->nr_active directly. In that case, nr_active could be 
removed from struct mpath_device entirely.

Thanks,
--Nilay

