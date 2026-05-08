Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20B62F8E9C;
	Fri,  8 May 2026 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778251127; cv=none; b=GR2mZlMXX2qACkd2u5ed++Eub8Yz6wCA4gipe3IqDhRD+BcBQMP1tXD2eu7/wNLGsEW+6L7Z19NmTVoh30UHkYjD9n6mpgdd7Xck1pccmiq/sCatfvp7tOOF0E4dzUen3ft9XVt3sjs0O03AfIrNvg+ZBtBYk+BeNPmliUAs1tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778251127; c=relaxed/simple;
	bh=yGaQ89U095t6+bFprkRGY398feiUFWX6DGYa0bSjfXk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=oLxxhacS3PvlsBsACtRgwtqK5L4JtG0H9c/z8FcJiY6Aaap8hdtKPKQHZFN31skfusYAsI4oE0fa4VJyfx/tj2vCre5odjwHQFi1p2XrR/Y5mtNKN1UGTgO7ySOMzJBicbMadAI+07NE1aTWlKV7/q0LtB5C0xbaRBgL/Ogid8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SISgIlJV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SISgIlJV"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6480xjaF2577247;
	Fri, 8 May 2026 14:38:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=RXHh4OkTlgVUfYlT8QNRojbDHOMsEu
	F3j/SgfQCtKj8=; b=SISgIlJVPCq4z3/ByEe/tf8PVKYJDLHDpf2SIs6CcbaJDz
	JoE1132Vv2OJxRbjZvAZnEBGnEjB0MiyMc9nr9vrKftmMWAsFZ+xZY7uR5htcvzh
	lXvLgi5aUCCQxU1/XvyDNjKdp6JTn5K93RpS5H8ajpOoiFw0nbCGF99g4WKkSteq
	yIQrgI9jupnIR8Z2UGO/fx5MJ824qi0kTMpNFYKC2hmqJDmvYR3DSQSMbif2DaxA
	yXRS6gx7avUeV3uUJbmJAAlNkfvREYPNbccvqd9xCBmJasxlS3vmQ91l1QQ7bl7v
	eWUOOBGKQdR9FYvjiwFA+xihQPjceA8Nb0bFergQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y52uys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:38:23 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 648EOldB003733;
	Fri, 8 May 2026 14:38:23 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e10073kwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 May 2026 14:38:23 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 648EcLt21704622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 May 2026 14:38:21 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29BBD58043;
	Fri,  8 May 2026 14:38:21 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E85A758055;
	Fri,  8 May 2026 14:38:20 +0000 (GMT)
Received: from d (unknown [9.16.41.19])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  8 May 2026 14:38:20 +0000 (GMT)
From: Dave Marquardt <davemarq@linux.ibm.com>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin
 K. Petersen" <martin.petersen@oracle.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas
 Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King
 <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch
 <kmahlkuc@linux.ibm.com>
Subject: Re: [PATCH 5/5] ibmvfc: handle extended FPIN events
In-Reply-To: <8ac414a6-b4e9-4fd9-b316-3738b3229664@linux.ibm.com> (Tyrel
	Datwyler's message of "Wed, 6 May 2026 22:48:08 -0700")
References: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
	<20260408-ibmvfc-fpin-support-v1-5-52b06c464e03@linux.ibm.com>
	<8ac414a6-b4e9-4fd9-b316-3738b3229664@linux.ibm.com>
Date: Fri, 08 May 2026 09:38:20 -0500
Message-ID: <87h5oij7ab.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA4MDE1MCBTYWx0ZWRfXw2ZMVzT2JGZX
 2wQojrRfs9jwp/xnoGTwxfeVBpIHntydW5nhfGZ0v6gL3ssRV97MBwoT0pjvGIGqm7fwJRR0B2w
 WiJDHdAhzoofwgZ6YMH0TeH8vFmHmFC7uSAWkfrC+JChJ0zOD6VRAarINWZhDXNwF6Jz2v6XVYw
 NO28JnMR/PsJZAknSNgGO0wWm1UAMaeconmIPVU9qD8ozpiXyFnlzwQh3GoygfNj8Q6XMaa0JLW
 CRZLZIcT0+WnzZ8zGXP1AaLLKyi11MWo7RVvCj8SeMff2a2z4I6chS/FdZnlQ57FYluGcrEzgfn
 1jvKaYeekBU2VrJhtO0XfjGIUS40lpFpt3CVX8G2mtCmlYvJuZF39SPIjme35hsCwgBxb6psf1O
 KooD+Yl7FEFRUqM/cIIXpoIp28XsoIdXoKYHLZxmbzW/rgadvuh6qDnKNhlbwM5JqYj1m3kurp2
 g4fiN4sKUn59F+HoKgg==
X-Authority-Analysis: v=2.4 cv=J4GaKgnS c=1 sm=1 tr=0 ts=69fdf560 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=1SDrLXVDyJUjgw-k9W0A:9
X-Proofpoint-GUID: 3xP5O9r6Any7I7_jUwvY3TDpNxOIcOTm
X-Proofpoint-ORIG-GUID: w1j5ox_0X6a8GePy_w6rIt8acBAu323x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-07_02,2026-05-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605080150

Tyrel Datwyler <tyreld@linux.ibm.com> writes:

> On 4/8/26 10:07 AM, Dave Marquardt via B4 Relay wrote:
>> From: Dave Marquardt <davemarq@linux.ibm.com>
>> 
>> - negotiate use of extended FPIN events with NPIV (VIOS)
>> - add code to parse and handle extended FPIN events
>> - add KUnit test to test extended FPIN event handling
>
> Same nit here as the previous 4 patches.
>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvfc.c       | 45 ++++++++++++++---
>>  drivers/scsi/ibmvscsi/ibmvfc.h       | 31 ++++++++++++
>>  drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 97 +++++++++++++++++++++++++++++++++---
>>  3 files changed, 161 insertions(+), 12 deletions(-)
>> 
>> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
>> index 26e39b367022..5b2b861a34c2 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
>> @@ -1472,6 +1472,9 @@ static void ibmvfc_gather_partition_info(struct ibmvfc_host *vhost)
>>  }
>>  
>>  static __be64 ibmvfc_npiv_chan_caps[] = {
>> +	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS | IBMVFC_USE_ASYNC_SUBQ |
>> +		    IBMVFC_YES_SCSI | IBMVFC_CAN_HANDLE_FPIN |
>> +		    IBMVFC_CAN_HANDLE_FPIN_EXT),
>>  	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS | IBMVFC_USE_ASYNC_SUBQ |
>>  		    IBMVFC_YES_SCSI | IBMVFC_CAN_HANDLE_FPIN),
>>  	cpu_to_be64(IBMVFC_CAN_USE_CHANNELS),
>> @@ -3370,6 +3373,28 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_subq *ibmvfc_fpin)
>>  					  cpu_to_be32(1));
>>  }
>>  
>> +/**
>> + * ibmvfc_ext_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
>> + * containing a descriptor.
>> + * @ibmvfc_fpin: Pointer to async subq FPIN data
>> + *
>> + * Allocate a struct fc_els_fpin containing a descriptor and populate
>> + * based on data from *ibmvfc_fpin.
>> + *
>> + * Return:
>> + * NULL     - unable to allocate structure
>> + * non-NULL - pointer to populated struct fc_els_fpin
>> + */
>> +static struct fc_els_fpin *
>> +ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin)
>> +{
>> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin->wwpn,
>> +					  ibmvfc_fpin->fpin_data.event_type_modifier,
>> +					  ibmvfc_fpin->fpin_data.event_threshold,
>> +					  ibmvfc_fpin->fpin_data.event_threshold,
>
> I see mention of threshold and period previously. Why in this case is it just
> the threshold value passed for both?

I'll look into this. There's no obvious period here in ibmvfc_fpin or
ibmvfc_fpin->fpin_data. It may be more appropriate to use a default
period.

-Dave
