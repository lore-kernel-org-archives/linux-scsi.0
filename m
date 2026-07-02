Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0864B3803C1;
	Thu,  2 Jul 2026 22:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783029922; cv=none; b=pwDXYSxjrGzE5ugJP3jlC/6BSx9RcviDKaF9O7YgPpA5VmppWyNgIHooJS6dZhRgDOyMIwGl3w/u4+RirucTQJNOPClAXjeGT2he8XjeT/vhLRyRbI9vGNjggg5pPk6GRoIJI4Qh1F+QxH6W8lSMnNIxmTpgU5Nu76x4HxUv88s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783029922; c=relaxed/simple;
	bh=FxiJuZojI0eKnprUNXFg0guAW3yMBTA0Za/ymXWExYc=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=q87qyb/lKMMoPmix4pNfcDEOaHDyVVXuNU0lgIiAjffx5hfVxbFEgcGQLv/oVuvHBQA7pt5otHEcK6kWhM8hEf7XPezl7cOYDGcbkN8yYsqPNNaahP+d9OL1kCK1zn6ti1qDzYwjqC3Pv8/hQF3MaZ8+oVndpUVBOZcaxMNl8dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oiopEJ92; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oiopEJ92"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 662JICsb589782;
	Thu, 2 Jul 2026 22:05:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=tWbKec
	O/Sdy/sI7WeY/MoFz9BeLH+k1o19XP5U9Ao1E=; b=oiopEJ9261dd6ezDz1rQ7K
	Ni+OzhalrQU0pVw9BXzEzLwn4vfJxN+h/NgOaVzXmdjgc8sqpOZn3uxiaLmEtrV6
	6AtYKO18yYHOHPOOwumNQaGMt9X6D8opXhsWXAAynRy9r69Rf0LrFDDqXDUZKUIu
	vS/1D7xsq+n7bDT37xMV4LY9k3eR7mZhrON4J5BW+Kw4f8766oz0Bqs1tGLE81SB
	xV4gmVVvvpjpLE5b3T2bS2MUj9NzGZE4zMKZmErKsTX3ZYlgv7HzoUv4lbhdIBN+
	kQMWd47+TfGjqvmoT6nTv4KUi8gqaYfpjekL6hEheO72U6yHo8649LUA8Pz4LIHg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f26pec9ry-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jul 2026 22:05:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 662M10Hw011388;
	Thu, 2 Jul 2026 22:05:00 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4f2u2gnuby-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 02 Jul 2026 22:05:00 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 662M506E18285150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 2 Jul 2026 22:05:00 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE6F358059;
	Thu,  2 Jul 2026 22:04:59 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7FF35804B;
	Thu,  2 Jul 2026 22:04:58 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  2 Jul 2026 22:04:58 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 02 Jul 2026 17:04:58 -0500
From: Wen Xiong <wenxiong@linux.ibm.com>
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Mike Rapoport <rppt@kernel.org>, Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian King
 <brking@us.ibm.com>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        Matthew Wilcox
 <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
In-Reply-To: <05bd4fe1-fbf3-4849-96ca-930d04710903@linux.vnet.ibm.com>
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com>
 <akTjQVQQNdeO9M28@kernel.org>
 <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
 <akYLdBME5kgyi8Rw@kernel.org>
 <05bd4fe1-fbf3-4849-96ca-930d04710903@linux.vnet.ibm.com>
Message-ID: <9eb64399ea51461aef8188ad5cffa9f9@linux.ibm.com>
X-Sender: wenxiong@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WNdsdVtpHIQyUudr2beV1suYvfyVA3dG
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAyMDIyOCBTYWx0ZWRfX+RpcbRKJNNKt
 gKCxLu/0D7fhBYJMfq+k83fcYk+RQ3QYSCYNPlPZ+IrAp5hRlxpF0lMThe3Y78J64erNp/LJ//4
 Dfv8564Ny7Mw7Bl3kIOWXZTBEq3DT/4=
X-Authority-Analysis: v=2.4 cv=edsNubEH c=1 sm=1 tr=0 ts=6a46e08d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=0BNHoLoJkjV9DPgUaycA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAyMDIyOCBTYWx0ZWRfX6h63RbjHUs3+
 MMUd05bqiMu+CN476WSuC/OLph4RaPyVeCdvvN4srqQlRD1hphwJX3x+ZoXVfcapV2Tzfd/EQVW
 4C7WinzeaKNLAawkl4juNjFqfIxLwsZQxynt1WyPiQDvgJmpV4D97+3Ug4UxZmRj18xTQFqQim4
 qt37nGpoyeogka72yyjg/ed/r4W0+QJSTglMBQFctSrYZtPB7AAi1ZUgwn6yILW+pbI1n673RGO
 u+LsCf8JEiOhenAcXw0dlabGcQi0ce1jdHOSW7jOciHNSJkiisHv1xvrHy2f74DxXFlrMRFPtpf
 ZBzJuSE7X2aOqjKFInpARPpzZbo3n4EE57OUsQl6f1qMYMq7rOqAeBO+JzRdRJaxdHWfP77e5ea
 JU+vjqJ1MW9jAXvlpi1UPnK8uf9E+QL/hIRByW36d8FsGMDeuWMVSIVSnrzxrblf90X7UqrczR2
 Lc/+riA3tTf82F4xf3A==
X-Proofpoint-ORIG-GUID: WNdsdVtpHIQyUudr2beV1suYvfyVA3dG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-02_03,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 adultscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607020228

On 2026-07-02 14:56, Brian King wrote:
> On 7/2/26 1:55 AM, Mike Rapoport wrote:
>> On Wed, Jul 01, 2026 at 04:03:48PM -0500, Brian King wrote:
>>> On 7/1/26 4:52 AM, Mike Rapoport wrote:
>>>> On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
>>>>> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
>>>>>> IPR dump machinery allocates memory to save adapter's crash dump 
>>>>>> using
>>>>>> __get_free_page().
>>>>>> 
>>>>>> This memory can be allocated with kmalloc() as there's nothing 
>>>>>> special
>>>>>> about it to go directly to the page allocator.
>>>>>> 
>>>>>> kmalloc() provides a better API that does not require ugly casts 
>>>>>> and
>>>>>> kfree() does not need to know the size of the freed object.
>>>>>> 
>>>>>> Replace use of __get_free_page() with kmalloc().
>>>>>> 
>>>>>> Link: 
>>>>>> https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
>>>>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>>>> ---
>>>>>>   drivers/scsi/ipr.c | 4 ++--
>>>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>> 
>>>>>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
>>>>>> index d207e5e81afe..5a212bfdeec2 100644
>>>>>> --- a/drivers/scsi/ipr.c
>>>>>> +++ b/drivers/scsi/ipr.c
>>>>>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg 
>>>>>> *ioa_cfg,
>>>>>>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
>>>>>>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
>>>>>>   		    ioa_dump->page_offset == 0) {
>>>>>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
>>>>>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>>>>>>   			if (!page) {
>>>>>>   				ipr_trace;
>>>>>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref 
>>>>>> *kref)
>>>>>>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>>>>>>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
>>>>>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
>>>>>> +		kfree(dump->ioa_dump.ioa_data[i]);
>>>>>>   	vfree(dump->ioa_dump.ioa_data);
>>>>>>   	kfree(dump);
>>>>>> 
>>>>> 
>>>>> I _think_ we can replace this with kvmalloc, and allocate the 
>>>>> entire
>>>>> dump buffer in one go. Once switched to kmalloc() it's kinda 
>>>>> pointless
>>>>> to allocate separate page-sized buffers here.
>>>> 
>>>> kmalloc() performance is on par with __get_free_page(), but 
>>>> kvmalloc()
>>>> would be slower if it falls back to vmalloc().
>>>> 
>>>> I'm not familiar with the driver to say if this could be an issue 
>>>> here.
>>> 
>>> This code only runs when the adapter has hit a fatal error, so should 
>>> be
>>> extremely rare. The memory is getting allocated while the storage 
>>> adapter
>>> is in a failed state, so anything running on the system at the time 
>>> could
>>> be stalled until recovery is completed. This memory is allocated and 
>>> should
>>> be freed soon after the adapter recovers. In order for this code to
>>> run, the iprdump daemon must be running, which will then read out the 
>>> dump
>>> after the adapter is recovered, and write it to disk, after which 
>>> time, the
>>> ipr driver will free the kernel memory.
>> 
>> Thanks for the explanation!
>> 
>> So the allocation is not on the hot path and it seems to me that
>> performance differences between kmalloc() and slower vmalloc() won't 
>> move a
>> needle relatively to the entire dump procedure.
>> 
>> And it seems that GFP_ATOMIC here is a historical artifact rather than
>> actual necessity. ipr_get_ioa_dump() runs in a workqueue context 
>> without
>> locks held so nothing warrants GFP_ATOMIC.
> 
> Agree that GFP_ATOMIC is not needed here, but we probably do need
> GFP_NOIO since we don't want these allocations starting I/O as the
> storage adapter is not in a state where it can handle I/O until
> the card is reset.
> 
> Thanks,
> 
> Brian

iprdump works with both of GFP_ATOMIC and GFP_NOIO.

Tested-by: Wen Xiong <wenxiong@linux.ibm.com>
