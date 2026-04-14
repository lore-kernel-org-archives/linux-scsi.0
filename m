Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5B03D6CC4;
	Tue, 14 Apr 2026 11:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776167043; cv=none; b=fHPYePnmKu1BhvmG6OYoI0ZZnoF7aM9SmFggdDeWNSquT1M8Xe5aCCAbb5S8p/PSldATg+11TBfEn/8ye7rfHDfsLW8HCgCF+MWSeEwQ1KNSCg4VKZ/MtYNDDd0ZwsQ32Cyb+sg1ovHozEZAfWr5+mNPU4beOh22LEA4MmUZ6NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776167043; c=relaxed/simple;
	bh=f0Q18mx1UM+P+bOxo8gVE5wPOBGWiRBc7blhcclIEVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dP63x9HCfi19lp7kBP38kLa6xpsIhaxZJiXEHdVorOhnE8sEKh4+QxOsJ/Xs4iHnQJZ03rcbUxL3N/s2HLjQLQIGqkEGn1AZoHMQRqD/M/gFgrVzTHud12LpTIRArr5AME3I5AGQ3j4LsTqOmRk+/wDpxDg3zERK4CTRF+UCkJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ni5OsnV4; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ni5OsnV4"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLJCoU1844154;
	Tue, 14 Apr 2026 11:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UFZhnE
	97tWp4SlXf9g9qO9WSyADp8kccRJlgHM1Km8E=; b=ni5OsnV4krvqOjLRreP/Zh
	+wVlHTfF6sJyJovIEgpc0WxKYo4+yD27Citmjt0oX8pDsL/I4a0N76eFMewGL/e9
	0THpI5djmDGIFQrMBSfe/7JSyJy2hHAYpKBV2VaLJD7VjXX9CT7+kQJGQvVtTpiZ
	n7XGQTM8j5xSXe1lgarJltPKu/7pyF+jWtd6xFRXj+jL+WjvJW3TTk3Qfhycc7MP
	cDsEm4IeOu/cLLBAZtcndCrc5leBvK5r1xDUzycMU6f7CndxQaQQ5Jyx6idh/D6i
	EF28GnZQ9eXdTbwpt20uvKxfkcSx5JRue/1iGgac+v74X9jb+nac4/U4+YN3CQhg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mjfce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 11:43:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63EAxlQk025837;
	Tue, 14 Apr 2026 11:43:33 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujh309-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 11:43:33 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63EBhWgw1901506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 11:43:32 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8E035805C;
	Tue, 14 Apr 2026 11:43:32 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C20758054;
	Tue, 14 Apr 2026 11:43:27 +0000 (GMT)
Received: from [9.123.7.57] (unknown [9.123.7.57])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 11:43:26 +0000 (GMT)
Message-ID: <6dc8e0d7-9b2b-4867-9df7-6853f4b2fa05@linux.ibm.com>
Date: Tue, 14 Apr 2026 17:13:25 +0530
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
 <bb4df6e1-cd83-4a73-af67-f83c543d6e6c@linux.ibm.com>
 <bfd8c2c2-65f7-44f0-a4ec-01158e249505@oracle.com>
 <02288590-486e-4243-8352-c756c6879629@linux.ibm.com>
 <bc18ad6f-10b1-4a28-b88d-aed5754b968d@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <bc18ad6f-10b1-4a28-b88d-aed5754b968d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDEwNSBTYWx0ZWRfX9GlfcrJ7KBTF
 vWdYuZJHd8LLB2ky2gnHwTb4ELHi6MRrPUem9uKxukVqu4ceKex4ouhd/VFDQVbWaOX1KEqO2Hm
 QYfY2CTE7S/l/gExCh5V2hePcU0D+KiVOsGaDeKrpnE+Ld9D1sSHyKccm5sjrfgaHwLxJ8baMgz
 n8bgS6ptd9z+Vpu4913FKBfawlsq2fB1JRgLD9oo+C6SZCk3x7OHeLCOox7WB1zKNdyQAi6J4A/
 /I4lT1/QIc15zrtShDcLFXafw+VzQMARcAKXw/hzjeKGrYqKLwl3ZxXFZwtagU948dH35DbMG5P
 1gMVCTaXf8QRL+oD6RN6iJZt6iKKT1RuIBLuzNyG8gDq33nN/kvzlTqNF1DiuHk104ruk9kTB4j
 ydfjmgc+MJIftfNYefAs0vaBFo0CktfR8BqccgB+0+hbzO51ZGoGheazwi/Fm0Qurfs0MfrYHaT
 kXcxJDjwI2LL0qDuuXA==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=69de2866 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=WhhBK_UWijzhm2niL2sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: bwK6Oi9SGOSjV63HEJ0kuPcQqRbyTopC
X-Proofpoint-ORIG-GUID: bwK6Oi9SGOSjV63HEJ0kuPcQqRbyTopC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_03,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140105

On 4/14/26 3:33 PM, John Garry wrote:
> Hi Nilay,
> 
>>>
>>> I think so, but we will need scsi to maintain such a count internally to support this policy. And for NVMe we will need some abstraction to lookup the per-controller QD for a mpath_device.
>>>
>> This raises another question regarding the current framework. From what I can see, all NVMe multipath I/O policies are currently supported for SCSI as well. Going forward, if we introduce a new I/O policy for NVMe that does not make sense for SCSI, how can we ensure that the new policy is supported only for NVMe and not for SCSI? Conversely, we may also want to introduce a policy that is relevant only for SCSI but not for NVMe.
>>
>> With the current framework, it seems difficult to restrict a policy to a specific transport. It appears that all policies are implicitly shared between NVMe and SCSI.
>>
>> Would it make sense to introduce some abstraction for I/O policies in the framework so that a given policy can be implemented and exposed only for the relevant transport (e.g., NVMe-only or SCSI-only), rather than requiring it to be supported by both?
> 
> I am just coming back to this now....
> 
> about the queue-depth iopolicy, why is depth per controller and not per NS (path)? The following does not mention:
> 
> https://lore.kernel.org/linux-nvme/20240625122605.857462-3-jmeneghi@redhat.com/
> 
> Is the idea that some controller may have another NS attached and have traffic there, and we need to account according to this also?
> 
Yes, the idea is that congestion should be evaluated at the controller level rather than per-namespace.
In NVMe, multiple namespaces can be attached to the same controller, and all of them share the same
transport path and I/O queue resources (submission and completion queues). As a result, any contention
or congestion is fundamentally observed at the controller, and not at an individual namespace.

If we were to track queue depth per namespace, it could give a misleading view of the actual load on
the underlying path, since multiple namespaces may be contributing to the same set of queues. In contrast,
tracking queue depth per controller provides a more accurate representation of the total outstanding I/O
and the level of congestion on that path.

In a multipath configuration, this allows us to compare controllers directly. For example, if one controller
has a lower queue depth than another, it is likely experiencing less contention and may offer lower latency,
making it a better candidate for forwarding I/O.

Thanks,
--Nilay
