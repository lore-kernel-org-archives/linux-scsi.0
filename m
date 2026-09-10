Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA67A36196E;
	Thu, 10 Sep 2026 23:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082147; cv=none; b=IttjxXpOpbhxQa3L2p0KJ4PJruyPzVJDbjVMD6Zc75XHnLYabwuAvRjhYzwE1CuCDq6vIXFCd0+R19f4E8IYjyUVIQpP8YEXqJALD8p/ntvt2nYH8UbIhT4x1vKxwVtp3qCWWsYHpCJ9iwK+LM5l8L09Aup97FfD/c97v36OIpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082147; c=relaxed/simple;
	bh=0etc8r5rbMFVm303y3aX+ler93NJyO3b3fvLKBZ05pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=egp8wjAjUBYSXtaFDfOwZajfACZ9wwU3/Ex2gwGSRFNw2YndYP31w57PABsfO8nBptBXtBepC5NkmBIzuyOmyV8Cst6PyUhvLcsCg3LtODDInYnBqTcZWk9Mq0J6ptIBogFIKIbCrIfjp/2pKyCxM+vGX0cRaxDT2X6yIptpMjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tDcGYnjk; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tDcGYnjk"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALVUTF4091807;
	Thu, 10 Sep 2026 23:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=l6JJku
	OB9aWSkFa9dJqo1EaMheDPIcwdZQw5+Ad8e8A=; b=tDcGYnjkH7qNLcdQB1feF9
	ex4AOijWASauBVoNFsibHR5XCaWLlAKkuKBYhGISIgxZEA7rTZf+MO4+PLOZmTXU
	Twnaf0t5UsdSHJ3zcw1NzYleqzcdydDv62dEIFmMbXXHhyuH0PTQuzkHGL70lkf5
	Ya8gGrHBTjo7jJR2N94l0rHTz7ctXmy7HLeAOcWmdVFlE7mPRuDDpq3K8mjsw6Mb
	YOyA71NG/keQMS5ZqaXIaYy/mMGzghLXktVZJiZpncODrWA+UNga/N1cSXrzMtH7
	b9wOqjq1YkRwA6TX+0jAE7udyW7P1Qdx88Z4dek6HQxD0jfWsWDtqV1Xb1eXrJQw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8qr3gf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:15:35 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68ALYwZY661933;
	Thu, 10 Sep 2026 23:15:34 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvnrk5w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 23:15:34 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68ANFXLt19202780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Sep 2026 23:15:33 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26D8A5803F;
	Thu, 10 Sep 2026 23:15:33 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 401FE58056;
	Thu, 10 Sep 2026 23:15:31 +0000 (GMT)
Received: from [9.61.103.123] (unknown [9.61.103.123])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Sep 2026 23:15:31 +0000 (GMT)
Message-ID: <0b66ee1d-62aa-418b-8912-4880f1163430@linux.ibm.com>
Date: Thu, 10 Sep 2026 16:15:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/9] scsi: ibmvfc: add FPIN extended flag and async
 sub-CRQ queue handle
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
 <20260909-ibmvfc-fpin-support-v8-3-b27183b055af@linux.ibm.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-3-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=SpUFe/O0 c=1 sm=1 tr=0 ts=6aa33a17 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=usRgD5Mj1TasghaAh74A:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-ORIG-GUID: sIXwTQUMon1xFmzzYmgPPIeGPJdg4yFr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfX6c+ayj4zPSk5
 tyGbf+Su/p0L+pQutgyeObrvdHox+ikjaRNHHkv5o1YAo3tN3x3DADNBfiK/PS9OfwVah/5/wTt
 ZH684xMISefOw5Ag4Yyos7ukJrXsiwwfJ4dCcQv7qynUExsLcDwbucDCRMvhH/6vZH3WBBo7bkP
 SCyPAAqo092xrVdJQgkIlnz35/WP7keZiCeA4B1TuPwdy48ucpdoJHnPoloc+vB1ax73mc128MZ
 BS1oU84CmrFx1Xdfad2WgdASYvsQH1fa0G8FvHh9t/C3sz+x9McXh+FBeT5QaXNwlNCC+/QLAYe
 zPIzZbXBAZI9plkKi36UmY+MbUSVT4skNOHqYWw9vTOQaFvWzafmvk0Gc7l9h1u0h3uNVO9Y2oq
 E6GZGQu1Dakba0LnkKLWNxxop5mCwO+Pm34QJD3xEeGNfMDvU6o3SesvzQ0/VI7G2P6waM/YQ1y
 J1zQS9tzb3OKndEywMg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDI5MCBTYWx0ZWRfX0sXfOBBQKMot
 7gu0bh5rWd8xmhO0g/97Mzw0MMmohsUwwxAmLTC+Fh11fJrbDGubwWU5NB2Sl1OZGKt6pDYoEY6
 dGjR7S/J9g8Rtmurjsv2LCEJ3tHoBQ0=
X-Proofpoint-GUID: y-L_hYDzUJ_zLX8lc15VyEUNBxU1HYK6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_07,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100290

On 9/9/26 12:07 PM, Dave Marquardt via B4 Relay wrote:
> From: Dave Marquardt <davemarq@linux.ibm.com>
> 
> Add IBMVFC_ASYNC_IS_FPIN_EXT flag bit (0x02) to ibmvfc_async_sub_crq.flags
> to distinguish extended FPIN events from standard ones.
> 
> Add async_sub_crq field of type ibmvfc_queue to ibmvfc_host to hold the
> queue handle for the asynchronous sub-CRQ, alongside the existing crq and
> async_crq queues.
> 
> Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
