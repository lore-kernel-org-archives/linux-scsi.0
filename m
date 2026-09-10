Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E043349E131;
	Thu, 10 Sep 2026 23:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082410; cv=none; b=s8pTeD15YtvfrXj4aty8skMECJBh3WRrgj/naCmpr0l+y9VhAeQUwJqbA3Q0Kg9RwZSs9hmBErhHl3S3EVlUa/SRocuxFdJDp5rEs0h3q7iHu+0HdkHctb/SXcebgmnq2qDgLBcXyIQS63Pe66NQwfPxBdI+vcELb6oq3KMzIZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082410; c=relaxed/simple;
	bh=7vWPQ0y0OpZ/s4znQFHMk6V8S2D30wUSa7YAiatJAhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hh0ECat/6hWTV8vTqmzS7E3utp2erGrpFxkKyARl/JkU7oAbYxpZbeupumQ6KjZQqyb8KQlxx7S4cDc3BEzpbN+eLTABPCkx4nDGG8EOwFdufamQ3LVaPDTuv3bXgsE9VDS2ijaDGrQjkbC6IhCE5KN15wgf+6gtGn8pEG8XbJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bS76UY82; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bS76UY82"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALViUP3937057;
	Thu, 10 Sep 2026 23:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=OtvH+Q
	KX4NOWMgIbivbUjvkeL1btBxw3QL/89Rvrt2o=; b=bS76UY82TMsrEwrYEgW5vi
	VzlkqR9/K/4XSqf5Qg7VFzgzFFe0mAJvpdD2efpnCvrWK8SWEmX16m6ebthMdUCG
	D3y3zB3ClwkTIYgAZliJNd6hU2Oc1heG3+HLyOdr0ojU+mC8eDf/wpB2QVafPefE
	TicZZvtgWrxUDo5mI4hVyQVbLwpf6NP9mZUxtPXZk4cohVWRCfDhUeRYvycfLbq7
	qMIy5Nhr4IIjii6KM0Ax1sGpJjEU3GexFK15+e3URcw9jHvKLrFRATET/BkCmCM/
	6LCUiIz9QXJQj4tDRwRH3Bep/d/s3wgsHuE6eND77EoCjTKGWiMeGBedJUNxySCA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8s81jd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:19:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALZ2Xi619451;
	Thu, 10 Sep 2026 23:19:55 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvvrb40p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:19:55 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ANJsWs3933070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 23:19:54 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A30658056;
	Thu, 10 Sep 2026 23:19:54 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E37DA5803F;
	Thu, 10 Sep 2026 23:19:52 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Sep 2026 23:19:52 +0000 (GMT)
Message-ID: <71bf34e2-3429-47e2-a097-a67aafc26331@linux.ibm.com>
Date: Thu, 10 Sep 2026 16:19:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/9] scsi: ibmvfc: extend channel reg/dereg helpers for
 async sub-CRQ
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
 <20260909-ibmvfc-fpin-support-v8-6-b27183b055af@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-6-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: osy5ktRx_WCKC_9QeeEeswJaShGH64S_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfXwn2r5NsfAqzp
 tRk8f5+b9QW4HCFMJWdfzOllGlwH5spEo7ZQEf941p7ExhL1NoSyW720spfoXOxo1lrraVAxGX8
 Ilk3PE0tHKHE0CamkAFE1aXxR8v1TxOwOIbIGvRIdFMX8F7RZCc683lY+Xuyx03R0LIiU9YmzP6
 9RyWFxX6devzmbv8UKBS/ewBtfhHWP9Shh6FpK/H/g8db4zZA21sExZLmdH+XqOxcL4Z9HU/G2a
 LOBHdK7wkKY6dflVMpwzzJsa1fBC0NgMFvr94j6NFwqUj6OT2MpWv/GcP4nmPJa7TvSZ0gOxCKN
 7IaQ2/VbuwR68BcazRgn4z8pqpZmHECYAtPypIx7UFt7uhhDHtO8o81lL7GN7I8U7rfIfIz5k0I
 gRMFkiLgR9l2vtIkh5c6TkrKK+S4baOlOz2TQN/+HczboLhK8SZNE/U40lA7hF6bbQ9hbbDCPvQ
 9cdR7Y4dUoxhO50uDrQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfX5yiUsYGgwPWD
 IkCqcK8UWveojKwyVIinPL8Fjjr7hU8Eozgq4tzt29gnIOJCHdgx+jYAdO5+Goq72tsPQea+X+/
 iIxD6P5u4HTgvpIBebWbKyZKVXKNpzs=
X-Authority-Analysis: v=2.4 cv=MpXHeGae c=1 sm=1 tr=0 ts=6aa33b1c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=bB-8jXNlYjG1cFA854wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: y_ZX6E70ouemlBVsGv4zk8JMgHleho5d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 priorityscore=1501 clxscore=1015 impostorscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100290

On 9/9/26 12:08 PM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> ibmvfc_register_channel() and ibmvfc_deregister_channel() previously only
> handled indexed sub-CRQ channels drawn from the channels->scrqs[] array.
> The async sub-CRQ (vhost->async_sub_crq) had no registration path through
> these helpers, requiring separate handling.
> 
> Extend both functions to accept a negative index as a sentinel value
> signalling that the async sub-CRQ should be operated on instead of an
> indexed scrq entry. When index < 0, the queue pointer is set to
> &vhost->async_sub_crq, the IRQ is named "ibmvfc-<addr>-async", and the
> handler is set to ibmvfc_interrupt_async_subq rather than the per-protocol
> ibmvfc_interrupt_mq handler. hwq_id assignment is skipped for the async
> queue since it has no meaningful hardware queue index.
> 
> Stopped marking ibmvfc_interrupt_async_subq as __maybe_unused.
> 
> Error messages in both paths are updated to distinguish async sub-CRQ
> failures from indexed sub-CRQ failures. Kernel-doc headers are added to
> both functions documenting the negative-index convention.
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
