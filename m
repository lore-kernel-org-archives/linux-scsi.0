Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1DA21FF4D;
	Wed, 18 Mar 2026 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773875269; cv=none; b=cvRxUFC6nmDqmzdMCgJ6Dc12N6/MImtB5FKcLk0BB6QMYSYUuTlKSXr79z383GSTDFBwAjgV4k63ldbYh4J7GnaGjF230CnhJ0yX5UNX83YkaUDfDZvNQh0wnsdrde1NnNHpj0beGZOvH+rRjUlJKCVYBD55Z/6kcGy5LuMyoAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773875269; c=relaxed/simple;
	bh=drooDpWOKuKVxnnGTk4jKRcN/oYHUz+eWVsyj35gBJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o0cqtMZKDC3uMRgCul/QtxlpbXDztLHB3+tn8CGmx7InTtm3hGV2Ca1AOchGNd3qMXsy6nbcCGMjUh15S3sWc3F/WeDtSyJ7UrZ0mHuQ4LsqqVyoYmgxlCUwjRJkPg3ouJvcR/TKiWDiM5qYo7NT8OAAPLvNM4AWADwlGOX+Qo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h18FADAU; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h18FADAU"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62IBxsIZ1711869;
	Wed, 18 Mar 2026 23:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ZF4bZf
	6Rxe1DFcyKyradMe0NCTz86Il5zRa1wpXh8yo=; b=h18FADAUXBn+eNBBdeL5Xu
	xYvYiwsUlxBjU0HnFKE/InUM8N6I7ZFmdlIFtk2uMRsMW+CvC+xVpkBrB/GwW6iS
	CZqzjEik28oFyOg/OaxXNHyRbsevCYXYrXCu9fYXAu0H9gNSJhu9JGJNwfRVVq9e
	/T4KGG+rofd2TIhQNHZrsiAW+L8FJYNT5l+05J9GNTufLDwLorEV9NPx3kNwxNVo
	dAX988ThP4kmDW5OvTB8+LzYMzlvVw9gALb7AoZHx71yrcKMFMRCqLgwLG8zyERv
	NsZIHxisqLUPqkt02foz3wXEJQnRdDA+AJ6iS49Sx/2IzlZkwIg2uTXRxK5da3aw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cvy64vj8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 23:07:43 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62IM1WHj015662;
	Wed, 18 Mar 2026 23:07:42 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cwk0ng2b4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Mar 2026 23:07:42 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62IN7fjq33096316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Mar 2026 23:07:41 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5395558090;
	Wed, 18 Mar 2026 23:07:41 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0CF95808F;
	Wed, 18 Mar 2026 23:07:40 +0000 (GMT)
Received: from [9.61.60.95] (unknown [9.61.60.95])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Mar 2026 23:07:40 +0000 (GMT)
Message-ID: <1254b232-4a90-4358-ac56-b5ddb7585ef1@linux.ibm.com>
Date: Wed, 18 Mar 2026 16:07:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ibmvfc: fix OOB access in
 ibmvfc_discover_targets_done()
To: Tyllis Xu <livelycarpet87@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        danisjiang@gmail.com, ychen@northwestern.edu
References: <20260314170151.548614-1-LivelyCarpet87@gmail.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <20260314170151.548614-1-LivelyCarpet87@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: q8JaLfkvsnPKVMfmBWBzBYdM6wto0wip
X-Proofpoint-GUID: RZGef-NOlw3BFBia2_5CsGcs3HE8s8U7
X-Authority-Analysis: v=2.4 cv=KYnfcAYD c=1 sm=1 tr=0 ts=69bb303f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=LkpBXIlXgGA9wdm3QV4A:9 a=QEXdDO2ut3YA:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE4MDE5NiBTYWx0ZWRfX5W3QyUPtslvn
 k277MBtrH7cQCJq8h/HoisJii5VozPKqcTNnhwKNxDWQZebt3FhY712moDRsk2g3KRqAnXheDFC
 4vpeluMDuWru00jPVWJYyRXeYtsRQiKRIDtz8nY+YdTUeT6q8jcMURXCGQEniYVr9bgDasscHGZ
 v2Xqlhm3wSzhr6DutnHmiwHrOdt8wFvO3IFDqOgvznD6h10+02MyJ1c56OfOh1BKqidPPJaohSA
 Rd4cbxnaWzfA7KRCM9e2iDrItUdnf3Aybd85cUuFWlEWleJWRr2SgCrpQbxCNcu+d+Zv9TPdxOf
 weX0oY2MQ/Xg0IR/SbbvjhtHQK9193B43ISDavyApjlLwu9a/L6W+HVzq32C1P3GvAhCuO8KEDt
 cndJ7ztkr0NYMotKXSRzqMKqogu/R7tnDaFruiHHs8TrXCVwlDgZCi/a9f6+AEwj8U+e+1PJkE3
 7lfkrP5HIc04ALyHAoQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-18_02,2026-03-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 bulkscore=0
 spamscore=0 impostorscore=0 malwarescore=0 adultscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603180196

On 3/14/26 10:01 AM, Tyllis Xu wrote:
> A malicious or compromised VIO server can return a num_written value in
> the discover targets MAD response that exceeds max_targets. This value
> is stored directly in vhost->num_targets without validation, and is then
> used as the loop bound in ibmvfc_alloc_targets() to index into disc_buf[],
> which is only allocated for max_targets entries. Indices at or beyond
> max_targets access kernel memory outside the DMA-coherent allocation.
> The out-of-bounds data is subsequently embedded in Implicit Logout and
> PLOGI MADs that are sent back to the VIO server, leaking kernel memory.
> 
> Fix by clamping num_written to max_targets before storing it.
> 
> Fixes: 072b91f9c651 ("[SCSI] ibmvfc: IBM Power Virtual Fibre Channel Adapter Client Driver")
> Reported-by: Yuhao Jiang <danisjiang@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Tyllis Xu <LivelyCarpet87@gmail.com>

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
