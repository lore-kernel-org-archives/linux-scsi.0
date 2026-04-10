Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5032D39479E;
	Fri, 10 Apr 2026 10:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775818333; cv=none; b=UCc3bZ3kNdshNAu77N5e+uX+GDJfXJMJXS/9LloREAOIAjqUIxQCf7nFKFvTRbZ20QeJvXA68LRS7naJ9nrLMWjUQIc64KrMzBsj+cE6Lds3PHw/cnUkaQp2lucc8vFsMIACb8MKZ3LK1dioWD+HqwSSPwcYLX+lS7X8eEThMDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775818333; c=relaxed/simple;
	bh=u0bWkxkK6FnAmSnAltDmSv6Vt1LaoGe9qTmc62YKgnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y4hI1xfR7kx4Hf5i7TSvqIn/mk7UNEWyUpoiIxIJVvtr6M2GGfKfTRDz8RnnsYyf4fT0rSGP38/oRR132VCzqs/VZaMCQ0uZCcZuhYSVvbxKoFyWzSMZ6gWd2Esy9GEBbkbmNdrFsxqxZjbForCtSGQPAGy3ysAwFxY358V1wnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eMjsYncj; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eMjsYncj"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63A0swNj2211703;
	Fri, 10 Apr 2026 10:51:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=DbnG1c
	+UOY6Gc+/gmmngithYyqQg6PxOrsYb+WJZxyE=; b=eMjsYncjonhxKK/VPPKq6P
	GV2WXsJhN202ef0URASgxJU1lQL9GUCIjyhcupnrSBtx9un7BvRoYRMT/+WraZGc
	cGHGZ/LNtVT7v08ELCd3eC+5FSryjgsT2Hwc43FteTv6JxCv7XeMwnAQLpPqpJX1
	vdTY6gJPoBPXfJ3Im7XBIAutfdmK78w5mV2154YlddJbpsEkpre+VI03wyUDYUMV
	SinufMQFVz2u4FraPtSD/19F0ifLb+yExFIrWZwgdYZ02atiP/OeEUdZBjDtlsjW
	VDM6Xmdw4weLbnW40KJgaDqv53m3C7CNnRYEZxsUALZqkTVdHWd8qtgtAdZ6ws/A
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2hrddp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 10:51:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63A7XSu5018952;
	Fri, 10 Apr 2026 10:51:30 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9qn00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Apr 2026 10:51:30 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63AApTQX23069210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Apr 2026 10:51:30 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE59658052;
	Fri, 10 Apr 2026 10:51:29 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6BEE58045;
	Fri, 10 Apr 2026 10:51:22 +0000 (GMT)
Received: from [9.39.26.31] (unknown [9.39.26.31])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Apr 2026 10:51:22 +0000 (GMT)
Message-ID: <8502c8d6-2958-4c46-bdba-95b91c2ceb10@linux.ibm.com>
Date: Fri, 10 Apr 2026 16:21:19 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/13] libmultipath: Add delayed removal support
To: John Garry <john.g.garry@oracle.com>, Hannes Reinecke <hare@suse.de>,
        hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-8-john.g.garry@oracle.com>
 <bc006d17-22b6-49d5-9e04-02eab7dab729@linux.ibm.com>
 <74eb1f9b-265e-4264-9575-177de6c924a0@oracle.com>
 <6d7a4076-a4ad-4185-8e82-8e27d704d20e@suse.de>
 <c5334a6b-8089-4ee5-abd3-8340133db29a@oracle.com>
 <79725a83-3dc1-4398-ac86-c3e317e0e107@linux.ibm.com>
 <ccfc867c-e744-42a2-9b22-47245a6c06d7@oracle.com>
 <da2bfbb0-70ef-4c3a-a235-1343b4a02489@linux.ibm.com>
 <b77d5eab-d50f-4102-8bfb-f907cf39ca56@oracle.com>
 <a1d72045-7b0e-4354-8365-f21f03765659@linux.ibm.com>
 <8d9c2ee9-0c2b-4c64-badc-b5b0fc1eaf67@oracle.com>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <8d9c2ee9-0c2b-4c64-badc-b5b0fc1eaf67@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDEwMCBTYWx0ZWRfX1zmr8Y+bKRHu
 0VCf+ne85SY6PSHYqPMzklCYG/q51ZyieRloBIPXSH2/G7hv8FBa1041ki+sF2VyFsufdikJ30Z
 2fUpuz8/1NTuGTtQ0OIzTgjS/gjaREsDqcH7Ok20iwnXKXpC4ZJ45yk4RGWHWlpUHNw6AAU7ynQ
 LOQg2Yr5I4eS6yRG2gY5WhzGOxo2C1DM34OFU9sovEkOfyEYmjeYw2Dj4aX5k7Dk1bgBTF21rxe
 UE81Tt0IiLW6eVN/289EqRUWmvVZ1lrwpKd93y/tkWBFPKJXqymXFQ+OFMhHv1u6lLlob3kBsgP
 E4xkPt3b+Ym2uQQLNOPJxzbSlU2xkmjnPc3A+pLaP/OZ4jYCMUwyB5hRLWNuMHpAsbElcEa3heg
 gxZIXWyAIMyWhp6RVDDpfl0BM7IAxnOhqGtbq1xOQlUk76fMD90kLZbItdG4fIiAxPlvYDqo+Y1
 /4YqlUkqQst89R9RZog==
X-Proofpoint-GUID: gYUJSxx-wEK7G3lebYqOAEZB9s_8uhNr
X-Authority-Analysis: v=2.4 cv=a/wAM0SF c=1 sm=1 tr=0 ts=69d8d633 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=PvHNxMhgUDqV9Y64InMA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: gYUJSxx-wEK7G3lebYqOAEZB9s_8uhNr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1015 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604100100

On 4/10/26 3:19 PM, John Garry wrote:
> On 10/04/2026 10:09, Nilay Shroff wrote:
>>>> It seems there may be a race here if we attempt to write to $ns before
>>>> the reconnect has completed in _delayed_nvme_reconnect_ctrl.
>>>>
>>>> If the intention is simply to verify that the controller reconnect occurs
>>>> within the delayed removal window and test pwrite,
>>>
>>> Not exactly. I want to verify that if I write between the disconnect and the reconnect, then we write succeeds.
>>
>> Okay, got it — I think I misunderstood the intention earlier.
>>
>> So the goal here is to verify that if a write is issued during the
>> delayed removal window is in progress (i.e., when there is temporarily
>> no active path), the write should be queued. Once the reconnect succeeds,
>> the queued write should then be unblocked and sent to the target.
> 
> Yeah, that's it. Otherwise, the write will be queued but then eventually fail (for no reconnect).
> 
>>
>> If this understanding is correct, then this looks like a good test
>> to me.
> thanks
> 
> About the module refcounting, as I mentioned earlier it's hard to test this effectively. We could use lsmod to check refcount on nvme ko during the delayed removal window and ensure that it was incremented. I'm not sure if it is robust and whether the complexity is worth it.
> 
Regarding module refcnt, I think that's easily available
if we read /sys/module/<mod-name>/refcnt. We may not
need to parse lsmod output.

Thanks,
--Nilay
