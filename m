Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E10389452;
	Thu, 10 Sep 2026 23:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082331; cv=none; b=W8t0/UAmz18EyAmG/X6o1fSIvev2bVwJs0DdzQeWkXLYPvr+vwAVZeDgmn1gF463LGbb/J86HhbUkyNAVZliJLcEmpVsRdVeFoMs962TlE0ZhPQlOvkjX+JSAbkaF5NIa/vI/ABgl3T7iAFJ/Dwt+W3jVl0otjFyKekp+ZGJS8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082331; c=relaxed/simple;
	bh=0Qk6C1cH6vPvKzLMjCpYrRs/QqcSAWsFIK8Nj8xi2sE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jQ+GaoHOTeAIZUi8cKYU2NKVTBzSVdEbW6EkaFVlftEzMDLtYxFW7R94H5sQ12tzsKMeWrvg9/ic+UDgpILLq1COVjZbhvRmUIVUpB0ApR6fj3/bHYbK8FKk77Vs/v71HV1Q3+sUXOQkyF4GYSRG6TQwkQ9Um94S6LXdS/cXt1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=AvMXOPaL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="AvMXOPaL"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALVgWb2933391;
	Thu, 10 Sep 2026 23:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0vh/nd
	gGruwOCOxFg5Xs5we6Z/COY92CFArYobQ9kks=; b=AvMXOPaLzZ99yau071Vt84
	dPntTs0abpkZWv7x4zUs4l/fSI77ct6N3QS4CKTDwjF3gVIXVskBWVtaVy1m2/JL
	VyEykTtdTDFq71Z0kJyltj01OAbSwuueYq+NXmM8GtQ/wSu0koS3DjjdHeIo/HzV
	j/eotc+YcWOu9KkKMwKOmhhZrk2IbmchXGQ+H58NxCXIa7+Cl16UmRvacUF75NHB
	RGuZv/0tnhdl+kHCoZbndn7i1yhf4UBwycj8ZX/PHJhElTXYtBL+PgEivfb4hKJt
	EIuj4pDcD2CPFzewmBva4jclok9mClnECJOhETsCefWf4qWCD1Wsm7bLKVvWNDxw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8q82hk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:18:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALYwv6661923;
	Thu, 10 Sep 2026 23:18:36 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvnrk65t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:18:36 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ANIYIT26083976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 23:18:34 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E88858063;
	Thu, 10 Sep 2026 23:18:34 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A7215803F;
	Thu, 10 Sep 2026 23:18:33 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Sep 2026 23:18:33 +0000 (GMT)
Message-ID: <e0ca951f-9d3f-4416-95aa-0fdd13802c09@linux.ibm.com>
Date: Thu, 10 Sep 2026 16:18:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 4/9] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
To: davemarq@linux.ibm.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>,
        Greg Joyce <gjoyce@linux.ibm.com>,
        Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-4-b27183b055af@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-4-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: rfDstqMTIJeowHZliutveBLc6i8LU7nc
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfX1t3M2KPU+Wmz
 JcF2YMK2chRWusQeEX5CQAYZZNT8SJpwFQ8ZGQDmkvLDFxrsCzPAS0Mzf26g95PWFGoQjHFTX0z
 6eAOQgNoFW1ufAyEiyvdpt1vhVmBvHI=
X-Authority-Analysis: v=2.4 cv=E/dYNqdl c=1 sm=1 tr=0 ts=6aa33acd cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=tcYJ5KbJpfk06CSn7sIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfX1TUhSoTlrwHQ
 qrey/kA5BRKrosUVZmVMD5PhcFeZyxmvkYQp4GFJ/PmIP0GL2PpFcw6Mrcm83MRP19hfMBTn690
 LogcJjmHapk69AscIjM48Udvo6z/UHc5mzvqGZIR9BV1eL4vsuqSYksWKZdPgw7O4lL6ombBT0Q
 G1sHi3YI42Kv+5NkI0Jd+ETudSeGqbIj74cSrRpVAqQPuplQTXcgUz+BBAtZ7sJwnsNDBu8feLE
 x+Uc+QAUgVY1SMHXpFNq3L9prqEqT0ZnZXQmfL01/Xhfs2kg0Rt101yoG519MLzppahWX/TjxBA
 m7yfUj4ls360/GrERDkezAAEGK1rGYgyQS1cH8W/8TMloL4ebobFjOD6G24ogcnu1Qip3TYUdlj
 hY5jntPC6whUyXU/8I/oX/CiyVNnwc5XbhNPqRfY/TVns5aTFAU3JY2RJff2VlsBsV5goiaaJ/L
 jXJ0/o0QJI6S3GYqR0A==
X-Proofpoint-GUID: wR9ftKM3aGsNvk2YnS6MaY1321u8G70A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100290

On 9/9/26 12:07 PM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Refactor async event handling to support both traditional async CRQs and
> new asynchronous sub-queue CRQs.
> 
> Introduce struct ibmvfc_async_crq_event, a tagged union that wraps
> either an ibmvfc_async_crq (main CRQ) or an ibmvfc_async_sub_crq
> (async sub-CRQ), with an enum ibmvfc_async_crq_type discriminator.
> Replace the ibmvfc_async_work bare union and is_subq bool with a
> single event field of this type.
> 
> Modify ibmvfc_handle_async() to accept a struct ibmvfc_async_crq_event *
> instead of a void * plus a bool flag. Update ibmvfc_process_async_work()
> to dispatch based on event.type.
> 
> Add ibmvfc_full_fpin_to_desc() to convert full FPIN messages from async
> sub-queue format to fc_els_fpin structures. Update FPIN processing logic
> to extract WWPN, node_name, and scsi_id from the appropriate union member
> based on event type.
> 
> Update KUnit tests to use struct ibmvfc_async_crq_event arrays at call
> sites.
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
