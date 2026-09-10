Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC41355049;
	Thu, 10 Sep 2026 23:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789083791; cv=none; b=N7hbYGPl2Vj6Wgr6D3VE+fYkNoIX2I/5W/AlHAAGh7r5OlhBKL9FxIjMaPHU8oxZDXpgKCle7Pd4vexFJMSv3WRVLcuQVp7/NVKKriPwErnEHvGXlaT4DcA0sTnDSQARtN5cLMcRzhh+ZH/nhyzW0V/Ut34OtXPJLc0dz9uwFGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789083791; c=relaxed/simple;
	bh=hmUo4e0mq5Vxyxkb6wX2n4sKTysUvVuEnvqsMXpkDKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QtxbBf/PhsaXT9yseqyadwp1ScO656tP3nca/8ef9llRRL2j0lTvWVt420FItJFxjZIv9ysMBSPBkGFEGVEbQpw4MXFXB/bj1ubn9YKe0ydoRruunM513OcR6bg3SSsiPttGAU21Mh5RxIjI4is9nopE4jfPZb9NEiOYYAYw8Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I3FcLeoF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I3FcLeoF"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALVdHb2933154;
	Thu, 10 Sep 2026 23:42:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3F2Yw3
	nOCXv7w/CMLM2busPNdKjGC5C5TW+BFV2CHaE=; b=I3FcLeoFuOlelr3LJRXM9L
	CS+itap1YK/gpRvLrJ1HFOB5HzT3vgAs9qm/ytb26sAogBIS55jRQKmMW/GRMsej
	gY9QVLdEkfPMO/YBaJ4FlSRGZioNFPwMMgJE5ENqyPNnz/ejS4rVy0LpVwBFC5vC
	2r3unL/WXSkbFDVcLJ/Ka0Zy+Vx3HT4ukkb4IAsOz9mSlfRQUWcnr4qicxUOFbSu
	UnBA6NIgvk9oYoQTpmgHS+ksq3JxiPvC87K6lGrDAwOQh59nWit2NmuagShblSGN
	EuL/h6oDIWuI5+OkNRonM4Z4dQaAlh3CVRLpHt/VsYjoc+ubL+BE0zVoxw7oMEWA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8q855g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:42:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALYw78661927;
	Thu, 10 Sep 2026 23:42:56 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvnrk8v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:42:56 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ANgChm31392312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 23:42:12 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E3B058056;
	Thu, 10 Sep 2026 23:42:54 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4842F5803F;
	Thu, 10 Sep 2026 23:42:53 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Sep 2026 23:42:53 +0000 (GMT)
Message-ID: <1a30ba3a-47fc-401f-841f-208dfc86a20c@linux.ibm.com>
Date: Thu, 10 Sep 2026 16:42:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 9/9] scsi: ibmvfc: handle extended FPIN events
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
 <20260909-ibmvfc-fpin-support-v8-9-b27183b055af@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-9-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: QF3MhPmr0fyZz7JCm32WfOvD4vuubuVD
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI5NyBTYWx0ZWRfXyYxTeBJHFaRZ
 oa3UY/T0fy39msOynuxtMfj0TwCCIMEzfNYkFtnO74KLdEK4GuctNTPx8dLP9Ic4xnRMe9Q71Iv
 XmA3WUiOo1FOWbncqx4+IolueCZOOmY=
X-Authority-Analysis: v=2.4 cv=E/dYNqdl c=1 sm=1 tr=0 ts=6aa34081 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=16rendbthEUVxCf-jPYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI5NyBTYWx0ZWRfX0i8BrxN21Md8
 4Wx4JdYAX0Am43CyT8W+ZmuYWL5CEr4xEMa+QTCNNqKNUBZ6Gz4ORuFdKoytL8tKgfMfFWfKmWB
 haroosjaWxwfZ+MaP4P8jk7SW5ZElwMTVpgD4mvrcPS2nk6biru8FR8iCrJnTx0YOk2hwdc1rWO
 weHTLVtG4N83c7bWJkWL6XitIBYgO8UYwklb8duoCWMwSJb4F1Vp4CO5RnsaOPUlcZo6sJr7BrL
 phdLPLDAHdzJan5HxjToSM0iQaUybPk55Z4akNS8DWf8ZBl9hx1ty+Af3c2XPykDgpGwxRJrlPu
 hh+wiUXOvrbOiY1g6Rv0vS2mmLQA/+COtJRAikV9fsoQQ8dgtUDjU/DvBNrleTBGc6qh8jsw+pm
 y/FWogzuRDoGKrpLZeMTcRotCHaw1E8ooz7rI4NwP2mwYapNBYLQG77fHYT0UoMSMqnTCJa4PqB
 NXbEE39geQXOmMHTfQQ==
X-Proofpoint-GUID: 3NJjOQuiPjt2jf3N7KT1MknJNLhlwVv_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100297

On 9/9/26 12:08 PM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Implement support for extended FPIN messages received via the
> asynchronous sub-queue, completing full FPIN functionality.
> 
> Extended FPIN messages provide more detailed information about fabric
> events compared to basic FPIN messages, including specific event types,
> modifiers, thresholds, and event counts.
> 
> Add ibmvfc_ext_fpin_to_desc() to convert extended FPIN messages from
> async sub-queue format to fc_els_fpin structures with complete descriptor
> information. Update ibmvfc_process_async_work() and ibmvfc_handle_async()
> to zero node_name and dispatch to ibmvfc_ext_fpin_to_desc() when the
> IBMVFC_ASYNC_IS_FPIN_EXT flag is set.
> 
> Set the IBMVFC_CAN_HANDLE_FPIN_EXT capability bit during login to inform
> VIOS that the client can process extended FPIN messages. Also add the
> IBMVFC_SUPPORT_FPIN_EXT response capability bit definition used to gate
> extended FPIN processing.
> 
> Add KUnit tests to exercise extended FPIN event handling across all
> FPIN status and event type combinations.
> 
> struct ibmvfc_async_subq_fpin uses volatile on its valid and wwpn fields,
> consistent with the existing ibmvfc_crq, ibmvfc_async_crq, and
> ibmvfc_async_sub_crq structs in ibmvfc.h, all of which mark their
> hardware-owned ring-buffer fields volatile to prevent the compiler from
> caching or eliminating reads of memory written directly by the VIOS.
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
