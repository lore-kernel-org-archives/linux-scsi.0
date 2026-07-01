Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92C12C11E4;
	Wed,  1 Jul 2026 21:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782939849; cv=none; b=d9FMHxv+zyR70aMV94tU2Hb1EL6Gc4n129uWJwOVurINh6ooozRQAJUqp5ckCj+o5aEK7fBPfc8HrelEfQSJHM0noLxAtq2U+q3MCSUPGooIX6nGJLLA8ePWMaB3jeRetgMq8ASl3pRdI35gdiNKSz/+EIyFH1AoP08YlDMDXc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782939849; c=relaxed/simple;
	bh=5IZ3Hlp4SUTTRbnXqPdXLUk/g+i1vh45CeiAqEH/3qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zlms9kLKiwpzD0k7eXoO01wjzFjFrYuY03T+vyzy66kKWzN9l43r5WhYb4LkJayHzIsif8693SImFi7vV55/VGjQUBmOSX0Bfr8o5t3x7BN7JcVPtMJffv5c4OdR3quL5IUfGa6O0y8MCvOfzhBKncgBZMmFcuAFg+Ffx9/NSlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com; spf=none smtp.mailfrom=linux.vnet.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WY64u5a/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.vnet.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WY64u5a/"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 661GmujY1295582;
	Wed, 1 Jul 2026 21:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1VDKyb
	4hfkEidYsFL/cd//raprq8RDWIlv3fHWpGhio=; b=WY64u5a/AFyzrVdilgkvaq
	907M0wntbTa5HPR7+XOXjY9TR+sBqBN+wSwenOgbu3djnO8ske/zFjlhNmSspeSW
	Yu79eYCOxv0IPpvhWCiMvOwMr/wU1NDoCccueZ5jSP9DYHb20yQQMroZmblGh9eJ
	ZrEwdmnpQDiqlqEMb/ILEOqX27WXzr0sV7QNIBMna+czZfU+3oIO4u4dopp9SObS
	7xd9/Yciah1x9EFTqMRRjBuS1S9WrfgJUMb/YnoIhCP9SemmqWZivdLCsT8CLDmh
	Kp94jsiuulQtitrSfcnoura8UkCwOMw7nY7QS+VhRDXobwwnAauLeJMCn0tsi02g
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f26mjxc22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Jul 2026 21:03:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 661KnkXo007578;
	Wed, 1 Jul 2026 21:03:50 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4f2tbhh2h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 01 Jul 2026 21:03:50 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 661L3naq22020642
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 1 Jul 2026 21:03:49 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48F525805F;
	Wed,  1 Jul 2026 21:03:49 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 727B35805C;
	Wed,  1 Jul 2026 21:03:48 +0000 (GMT)
Received: from [9.10.86.145] (unknown [9.10.86.145])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  1 Jul 2026 21:03:48 +0000 (GMT)
Message-ID: <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
Date: Wed, 1 Jul 2026 16:03:48 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
To: Mike Rapoport <rppt@kernel.org>, Hannes Reinecke <hare@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, wenxiong@linux.ibm.com
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com> <akTjQVQQNdeO9M28@kernel.org>
Content-Language: en-US
From: Brian King <brking@linux.vnet.ibm.com>
In-Reply-To: <akTjQVQQNdeO9M28@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAxMDIyMiBTYWx0ZWRfX+mYB2HlymjP2
 yPRhfTewsppVy+1MUBoeaDu41OfCkIOp+/XqjbvkHVW9LVvdBX8CkEcvbfWHfwzSS8tZ413Ay9v
 eX/2dWOBELlA9RNOyPNX/JoHvqSAZlZnX8/Wt//PgFJKGnMCVU1bGfJ35caKcg4o45LPKHDSRpY
 fV3zzlTeEEtCKjan1BMo3j2XCc8bDcyPPswPuYIP3vCOhYa42CZMh1knQA8dZz6lbdoGSIdZEwM
 3X+226VyGBvMPMQjyw78iXqMS6maygtNy3heXV2ubA55BE0QQlqr2/wpK27Ksy34rTuSjUqGXS7
 HZhrZEIzDE1G51roYlg7s6t4VXi9cNdNeofAhNQKxpNzWbCTNg0Lej9PTYCFlP/gcSUUExEPlI9
 PkOfhLDgosekZdp3bHRmYQWS0Nkdi62m7WD789N+CqbaG9hceqBCqH+X41TzH+Wi+mXV4/zkh08
 vOtjpXX2icOdHHpEXsQ==
X-Proofpoint-GUID: fGLiFQAPdNgsIIfBmHmBu-BS3rXHmWNn
X-Authority-Analysis: v=2.4 cv=Z8bc2nRA c=1 sm=1 tr=0 ts=6a4580b7 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=KGr8QZ9fd1BJuHWSWhMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAxMDIyMiBTYWx0ZWRfXw6o1pIEzPIEC
 hC0cWWzr+9XLRxYyy9Tccopc1k2RjUuuqKh2F30/7OTqPD4uEinJrGtQoSQit/P8uguP71y5e4w
 sIGdloEefvQMfUBfOKYleiOvnV/d/cc=
X-Proofpoint-ORIG-GUID: fGLiFQAPdNgsIIfBmHmBu-BS3rXHmWNn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-01_04,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 adultscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607010222

On 7/1/26 4:52 AM, Mike Rapoport wrote:
> On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
>> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
>>> IPR dump machinery allocates memory to save adapter's crash dump using
>>> __get_free_page().
>>>
>>> This memory can be allocated with kmalloc() as there's nothing special
>>> about it to go directly to the page allocator.
>>>
>>> kmalloc() provides a better API that does not require ugly casts and
>>> kfree() does not need to know the size of the freed object.
>>>
>>> Replace use of __get_free_page() with kmalloc().
>>>
>>> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>   drivers/scsi/ipr.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
>>> index d207e5e81afe..5a212bfdeec2 100644
>>> --- a/drivers/scsi/ipr.c
>>> +++ b/drivers/scsi/ipr.c
>>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
>>>   	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
>>>   		if (ioa_dump->page_offset >= PAGE_SIZE ||
>>>   		    ioa_dump->page_offset == 0) {
>>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
>>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>>>   			if (!page) {
>>>   				ipr_trace;
>>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
>>>   	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>>>   	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
>>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
>>> +		kfree(dump->ioa_dump.ioa_data[i]);
>>>   	vfree(dump->ioa_dump.ioa_data);
>>>   	kfree(dump);
>>>
>>
>> I _think_ we can replace this with kvmalloc, and allocate the entire
>> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
>> to allocate separate page-sized buffers here.
> 
> kmalloc() performance is on par with __get_free_page(), but kvmalloc()
> would be slower if it falls back to vmalloc(). 
> 
> I'm not familiar with the driver to say if this could be an issue here.

This code only runs when the adapter has hit a fatal error, so should be
extremely rare. The memory is getting allocated while the storage adapter
is in a failed state, so anything running on the system at the time could
be stalled until recovery is completed. This memory is allocated and should
be freed soon after the adapter recovers. In order for this code to
run, the iprdump daemon must be running, which will then read out the dump
after the adapter is recovered, and write it to disk, after which time, the
ipr driver will free the kernel memory.


Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

