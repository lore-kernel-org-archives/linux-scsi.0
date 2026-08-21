Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E0738F94F;
	Fri, 21 Aug 2026 22:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352398; cv=none; b=cwjLXwRYh51VBBjol4yJOVGWpRmHwRYRC+d/k0+87LJ7+Ty1yq9bq3lo2jW4fFOnqlFJFSvWx24jf6j8SMs0Xj9hWCx/EolXMMlNtzuIsXXtDMACKxdJaQacBEdws/+cvCN8BCuOyCWOFbUBnodDnwM0yZQ3jY0F0v+sSfDzZKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352398; c=relaxed/simple;
	bh=56JEwv36N2jImwv77Sawypjq/venfK1iwiLw5CgY4pY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e7RWWY8PvJfwSGT3ATiFOaweCFJutW9llRrZEoCr4FIoQmKZTrJlDqaAGZSyStj8AOQl790+Cm2YVSgf244LTjtffo5m0fcG50DafYBlVp7TaonBXVOU2ReGd41Tnv5vQtzhYFQ8zxEXbqLRrsl1lkgEjnLJQTps87SnbONqfRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U0GefJvU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U0GefJvU"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LIVVsR2314678;
	Fri, 21 Aug 2026 22:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0L75nX
	lFEC8XRnTslyoIJQz0Efxfw9SzcspEKJMQRhU=; b=U0GefJvUK/s7GY720orkBk
	cBu9cIUTDnc2yaBB4bfMqKX/EewB7l3Undgttt/LB0+3iOFhUsS624pSs4y7h9U4
	36vv15suRBZ4RYQaqUSgvu9Se8UtsRkl301KzGBYxyuxULdeg3b8kQTsBm52dUQ6
	HRLwFP48HKiQX+huTD4YN+1Vb5FqHvEORN3QmcXNsY5RmJXy2+DnzpVw83conLjo
	fRVoOFEip+2FV/8NLBz7qD2SQBQYPVSPlmvpz4vhwbNWYQzolfjhjfKlAIJ8cLWf
	pzAkbSQFjl0AHRLq2k1G2XJerYOT2xD2/7DtQnJZPesLo5zinXQkYuF30twGcxmQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g4yu1vmfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 22:46:27 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67LMfHmp026606;
	Fri, 21 Aug 2026 22:46:26 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33ekqds4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Aug 2026 22:46:26 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67LMkP3t61997472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Aug 2026 22:46:25 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C83965805D;
	Fri, 21 Aug 2026 22:46:25 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45D7958056;
	Fri, 21 Aug 2026 22:46:25 +0000 (GMT)
Received: from [9.61.9.186] (unknown [9.61.9.186])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Aug 2026 22:46:25 +0000 (GMT)
Message-ID: <7a8fbc90-3086-4026-a3ac-b683d4c38d28@linux.ibm.com>
Date: Fri, 21 Aug 2026 15:46:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ibmvfc: Fix use of uninitialized rport in
 ibmvfc_do_work()
To: Nathan Chancellor <nathan@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20260817-ibmvscsi-rport-wuninitialized-v1-1-0fdfb27a5f01@kernel.org>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260817-ibmvscsi-rport-wuninitialized-v1-1-0fdfb27a5f01@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=LsCiDHdc c=1 sm=1 tr=0 ts=6a88d543 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=VxpQeIyN2eE5DkSZRDsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: cLZl4OKhtRLSIq0VgK7kfEd2Xzjozdn5
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDE4MSBTYWx0ZWRfXxHi+D1JP9NXT
 Vkdx7rY/JEktYFfbV10IrR6BpXZTh9farFPfNEO+qAnIvfxuBIHUX/UbiDVTMcXemgzKtuh5kik
 18XP5f6e3b82kEIrisBSHeA34wSUr/o=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDE4MSBTYWx0ZWRfX8Naul4E8hyTp
 HdmGA72P3g4ZoUQTPEBxG3pwiYPjb9jooy7g2aNf7aIMiqajPd41gRtmOuZkTcZIVoPoeKLY7wT
 FyNN2c0rDfV7Q9ayBE46SEUpAkQyotj8y9uFY0oQ9eYSxY++BXEzXa/mZAwc/5wH3UWBHhx++b1
 xE41+ZDC1wBWl6vPeBkmym0hGgXPLzCQhcBryhoIeL5E/0MsUQMIhaMuRmIz7IuJgUN+hqmU2Lx
 0E5LEymxxmqPwHVkxJJnDmOoZPrNscNWCJcidebyz6hCh501tf7NVIhQZa32stm70jZ4vehsZU9
 ZTufiu6LRBh5oh0W+eqqM2F85/31MK8W0+s/uaVslE75OgykjFmLFXLqtrDTIExq+2jUKv0Vw3y
 MrYWQlq6PRdADG8mo44xT8XbX9nJY3e829upFW/WsO4cAFeXjtYxMejnIGx/3KOTFYo3BWxEFFM
 LGKwOYX8WnBwdT6XVcA==
X-Proofpoint-ORIG-GUID: cLZl4OKhtRLSIq0VgK7kfEd2Xzjozdn5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_06,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210181

On 8/17/26 12:04 PM, Nathan Chancellor wrote:
> After commit 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work
> thread"), clang warns (or errors with CONFIG_WERROR=y / W=e):
> 
>   drivers/scsi/ibmvscsi/ibmvfc-core.c:6154:15: error: variable 'rport' is uninitialized when used here [-Werror,-Wuninitialized]
>    6154 |                         } else if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) {
>         |                                    ^~~~~
> 
> The check for rport is unnecessary in this block, it was accidentally
> included from copying and pasting. Remove it to clear up the warning.
> 
> Fixes: 696d1cc2aaa2 ("scsi: ibmvfc: process NVMe/FC rports in work thread")
> Suggested-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> Link: https://lore.kernel.org/6ccbe8c5-beb6-483f-bfa4-c2d3819ad5f2@linux.ibm.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>

