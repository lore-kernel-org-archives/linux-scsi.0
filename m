Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9F941A799;
	Tue,  7 Jul 2026 13:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783430288; cv=none; b=IR75zmhenIXNrVA4WeW62RjQ8FiFIEbEkxIKZgpdnUb5KqsBOs6+NIIoozGSWOT8rR/Hg3SYBGjz8YdiFiZgjvmB880ZQ+wW945zaj9N6PljzF/niyUwz1N4J6j7R/+RSUZbvdBgosno0a2hVKpH9bPlvGH/pFYyM7rzA+L0X4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783430288; c=relaxed/simple;
	bh=yoaN0PnOTe+/mSnFKCTrlWEGk3C+dbjssf4Nevz9nmA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UNgWFAPYR8h79KHEehmaglRRbUW1nlUA9wIQurbiTRvTtBhGz2u5OfsaYqecYlL8tmU6biXgptI4AOKrlDC6FF+6ccemltsvvFqmLyhqSyMVOTshZQFYZ02BRTaH+DsG9WrfqLLNmzN6Tv0U4L7X8s/imOKzNsoTRypn4e0JkEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Gwi6RLZT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Gwi6RLZT"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667CIbQH3924245;
	Tue, 7 Jul 2026 13:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Bj4BfA
	E4+Dv9IF1clDBsHZf74FIuOd3gCFc+OmsYS4c=; b=Gwi6RLZT/jB7Eukpla7LGS
	bv7oIR+bteHwnnqDHpV6/cLnrRs8Jv+wjcLjWVCoM6ACFE7cDTdz1THAnJbBS2iY
	IQAXE6aPnnNmrPzcD+cr9xC5rDzXF9vpYjpCb5B7FbyD/67TsjYIsTiRFsyn7hE4
	oZtOA1Bo+D04cC1VDEXDMtmBk3zwHWZpg+F+UHqgEcooJ/wGK+0yK5BHe3ESsYk1
	4Viy9FpHBF4omb3VGsYoRLnSXvkd5iQ+PxJ+Fm1d25KT9qK1F+lpGZrXA8E7v05W
	hjPRFLC1wY8Ah7i6ye/pUFLDP4L8z3BXgyAgRTFjd8e/3X+sF54uyVJ9YSznejyQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f6qknf598-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jul 2026 13:17:50 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 667D4agi015718;
	Tue, 7 Jul 2026 13:17:50 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4f7cgq34vq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Jul 2026 13:17:50 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 667DHmRD14615238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Jul 2026 13:17:48 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75A2B5804B;
	Tue,  7 Jul 2026 13:17:48 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9CC6558065;
	Tue,  7 Jul 2026 13:17:47 +0000 (GMT)
Received: from [9.10.86.145] (unknown [9.10.86.145])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Jul 2026 13:17:47 +0000 (GMT)
Message-ID: <1d47de6b-f977-4818-bcaf-0c3c02e3292c@linux.vnet.ibm.com>
Date: Tue, 7 Jul 2026 08:17:47 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
To: Mike Rapoport <rppt@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, wenxiong@linux.ibm.com
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com> <akTjQVQQNdeO9M28@kernel.org>
 <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
 <akYLdBME5kgyi8Rw@kernel.org> <akdpddKBt7gV6po5@kernel.org>
Content-Language: en-US
From: Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <akdpddKBt7gV6po5@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Q/XiJY2a c=1 sm=1 tr=0 ts=6a4cfc7e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=czNtzi5osTd60V31_moA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 4N-KUEAOAj_OlVthmysnLUhsmPyGVqbA
X-Proofpoint-ORIG-GUID: 4N-KUEAOAj_OlVthmysnLUhsmPyGVqbA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDEyNCBTYWx0ZWRfX/L9QY95cOfPI
 WvCFkZ/0y4M4jcUF5upGruXAyFrb6kG0w76CrwtfcqEpjv6WpiKbpHc9QYUA1AlyOjq5V6eHeTQ
 bg59sDhD2FPCZVRP4hNHp10wAz0SvDU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDEyNCBTYWx0ZWRfX2LdwumiixgHq
 S7K1cmOxE2pP+j9Kq56QES+7QDe7hJZDUYlTMJBeAGredg1IJvvPagIzGldVSNplCkeEz5FCyQ9
 QGeem+QScMNFRjtH8nuZqrOuxPslpLtmcPvF2Zu+ru235YPZpRe+7RoxiWvPWfshFMoTRp47T/L
 azrnh8jinGduC8cCewzfkEyYNHb879VIJCnNyvHgs3s1fd79OdtCbggnw4QA0nlR4h3Fx6WhakS
 goUAfnzAGGGvv4Bvttm1JCcNRFSHySaMvInz+EzH8ejwerUS2/UpJ64zrYoaBHs7neZS1bSIQ7E
 mswIKQMAbTUCFWa3nYb7IWFE7dWnwxlWZymZQiDG1BwP4+yVgo/snEk5KWez3Hs7w7bbjOuLSv1
 wmQ+VM8mJaJFVwodgL9qn2/RODPrOdCpELdea3Nt/ac4lTqMds6ngm0hIKqks75txbcrDLX+xhK
 0/PNqYI+QdfATXdqJlg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_03,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 spamscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607070124

On 7/3/26 2:49 AM, Mike Rapoport wrote:
> On Thu, Jul 02, 2026 at 09:55:56AM +0300, Mike Rapoport wrote:
>> On Wed, Jul 01, 2026 at 04:03:48PM -0500, Brian King wrote:
>>> On 7/1/26 4:52 AM, Mike Rapoport wrote:
>>>> On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
>>>>> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
>>>>>> IPR dump machinery allocates memory to save adapter's crash dump using
>>>>>> __get_free_page().
>>>>>>
>>>>>> This memory can be allocated with kmalloc() as there's nothing special
>>>>>> about it to go directly to the page allocator.
>>>>>>
>>>>>> kmalloc() provides a better API that does not require ugly casts and
>>>>>> kfree() does not need to know the size of the freed object.
>>>>>>
>>>>>> Replace use of __get_free_page() with kmalloc().
>>>>>>
>>>>>> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
>>>>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>>>> ---
>>>>>>   drivers/scsi/ipr.c | 4 ++--
>>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
>>>>>> index d207e5e81afe..5a212bfdeec2 100644
>>>>>> --- a/drivers/scsi/ipr.c
>>>>>> +++ b/drivers/scsi/ipr.c
>>>>>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
>>>>>>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
>>>>>>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
>>>>>>   		    ioa_dump->page_offset == 0) {
>>>>>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
>>>>>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>>>>>>   			if (!page) {
>>>>>>   				ipr_trace;
>>>>>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
>>>>>>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>>>>>>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
>>>>>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
>>>>>> +		kfree(dump->ioa_dump.ioa_data[i]);
>>>>>>   	vfree(dump->ioa_dump.ioa_data);
>>>>>>   	kfree(dump);
>>>>>>
>>>>>
>>>>> I _think_ we can replace this with kvmalloc, and allocate the entire
>>>>> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
>>>>> to allocate separate page-sized buffers here.
>>>>
>>>> kmalloc() performance is on par with __get_free_page(), but kvmalloc()
>>>> would be slower if it falls back to vmalloc(). 
>>>>
>>>> I'm not familiar with the driver to say if this could be an issue here.
>>>
>>> This code only runs when the adapter has hit a fatal error, so should be
>>> extremely rare. The memory is getting allocated while the storage adapter
>>> is in a failed state, so anything running on the system at the time could
>>> be stalled until recovery is completed. This memory is allocated and should
>>> be freed soon after the adapter recovers. In order for this code to
>>> run, the iprdump daemon must be running, which will then read out the dump
>>> after the adapter is recovered, and write it to disk, after which time, the
>>> ipr driver will free the kernel memory.
>>
>> Thanks for the explanation!
>>
>> So the allocation is not on the hot path and it seems to me that
>> performance differences between kmalloc() and slower vmalloc() won't move a
>> needle relatively to the entire dump procedure.
> 
> I looked more closely at the code. Currently the dump continues as long as
> it can allocate memory and even if memory for the entire buffer is not
> available there still will be some data in the dump.
> 
> With a single allocation that may be as large as 80M
> (IPR_FMT3_MAX_IOA_DUMP_SIZE), an allocation failure would mean no data
> would be dumped at all.
> 
> I think the current model is better than using a single kvmalloc()
> allocation for the entire buffer.
> 
> I'm going to send v2 that keeps kmalloc() and only changes GFP_ATOMIC to
> GFP_NOIO if there are no objections.

Sounds good to me


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

