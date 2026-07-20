Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DADA330D29;
	Mon, 20 Jul 2026 07:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784534141; cv=none; b=GRwmMXzni6GS7qcuxu+s6xH7ruqv82NcTqv0cPBLyaVCriEm/a16wIKpdfn0nVmiFAIQ2gL3Z+SfTk9QDLTyyQrCN6GnbigKDGMYpCrQmjE/DTQlRJtUzdL0qQOm5Vw87v9J7lIep4S3bvlOUADM0KxZkYsJGzNq2DzTICKXvvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784534141; c=relaxed/simple;
	bh=r4tsRZEbUF6HXhLPhR/ZnIYYwBSqqDtR+r/gMLMvZdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZDl+kjFUXDHXxwy8ZqJBAMZdGLbnf5VasItr28NRcQWvMcMCuRvy+eCfTfU6iKIvjk1kcZLO/+WSoVCmH4dVCuARFzEVaPRD2cOBRq1QkYLYZW70WijPMd8d8PbHDKuYXi2+1lTTnm7WNXS9XqvmozA30Z0LqwByBvl7n3sa0E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ldlJCwsM; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ldlJCwsM"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K6fslY1381829;
	Mon, 20 Jul 2026 07:55:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8cZdCJ
	FlArZN60sE5iwXWYyLpAkSWdvVzbq6C08177M=; b=ldlJCwsMkj669jfiTRhT7n
	iueie4DGMKEFWxw462xULnZJPm6E1fEtJ2p4UrNOIoT36JRp+PRLrEgSO80Rp0S1
	nrwv+SQihtWOu/R9y2amsXXY/wnRtk+/CtkRbcwAYLZ/eZlQAhZlcFC8zsOdRrhE
	pvffGCCLwOY2uqVkojug5JRuO432uOrIuchNsSEaI83dA6yS6qfJ1n1+P4v4BNNW
	Pn/AHZPj1f6Am/D95ETO/KZGtpgOqZxFMqmZ3C7arcdgCUynAgV76ho0cCbKgJF8
	NiNryeGADkxgcq2CRT/+TFW91Gjl4mEEP+4a8UplLB3k+aEXuFvueXquN5a3yEMg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg77jx5mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 07:55:38 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66K7nnSt014862;
	Mon, 20 Jul 2026 07:55:38 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtjmmn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 07:55:38 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66K7tYI245613506
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jul 2026 07:55:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5550B2004E;
	Mon, 20 Jul 2026 07:55:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6B1E20040;
	Mon, 20 Jul 2026 07:55:32 +0000 (GMT)
Received: from [9.124.218.199] (unknown [9.124.218.199])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jul 2026 07:55:32 +0000 (GMT)
Message-ID: <7c25d2af-d224-4d23-98ba-e2e89f7bdf95@linux.ibm.com>
Date: Mon, 20 Jul 2026 13:25:31 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] fix memory leak during adapter release by destroying
 gid_pn_req
To: sashiko-reviews@lists.linux.dev
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260720072736.3381816-1-niharp@linux.ibm.com>
 <20260720072736.3381816-2-niharp@linux.ibm.com>
 <20260720074027.649FD1F000E9@smtp.kernel.org>
Content-Language: en-US
From: Nihar Ranjan Panda <niharp@linux.ibm.com>
In-Reply-To: <20260720074027.649FD1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HJXz0Itv c=1 sm=1 tr=0 ts=6a5dd47a cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=IWXOrLfZgRw9ZWNs2HcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA4NCBTYWx0ZWRfX5Fkx1LfIuOdv
 lkZcwpbdTumL7OqdLZL74F8t84vzeh43TdqXgzyN9SqYWqc4xF+DMlqbk54rWJvQxnm9e+UEAW0
 KfFq0H0HvFzjFq/B7Aqpn5VynhVpNHm8aDvLmmesWGGAlNwVpcTKthYRqWP9yioR8AdfGJU7FWn
 4DOz0zm90ycyOxPlyC7l1gpOhhrryCf8DZcM42SfRKByb7wF9TlqIGBeLcvVFh3d9fgm14zdMs6
 Q8SeyD7TZSI2HOscFZF4604BfDKXX7vLbHvBMoEA1mxz/5w/9n8QmaoBI08i4UJ+PgSqL1CzU3z
 VUxNDuJBGq9D22eEhu/tDbwSA6fJpyCUABVuDGquQf7Aw5bQmWcNQmVVUBgkhPWZWP1F8i5kLy8
 9J7Be3+Qj0oKJhwx+wHkwm4T5k5Ae8hRVvtnbdMHrsoXEu5vt/XsC83MEinnic6lJY3Qvcf6kDH
 +o83e65l80hdSO5ClKQ==
X-Proofpoint-ORIG-GUID: wuPOzjnP1_rB3_pRw-NvE4My7KWy3Bup
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA4NCBTYWx0ZWRfX78ukUg/02s3B
 pkPLSxWU3ts3p1cuZ/QQdW5KHxdV5s4EhsjA3x2o0LaC8m2AXE1/hXoo3NPOGHptQQmndHUfXgv
 t0T0Mp5DpPfe9rwU7G9Yfystz37drlk=
X-Proofpoint-GUID: wuPOzjnP1_rB3_pRw-NvE4My7KWy3Bup
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 clxscore=1011 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607200084


Hi Martin and James,
The bug reported by the sashiko bot is a pre-existing issue and was not introduced by this fix.
 
Please allow this fix to go upstream. We will create an EWM ticket to address the bot's finding in a separate patch.

On 20/07/26 1:10 pm, sashiko-bot@kernel.org wrote:
> Pre-existing issues:
> - [High] The error path in `zfcp_adapter_enqueue()` calls `zfcp_erp_thread_kill()` which unconditionally passes `adapter->erp_thread` to `kthread_stop()`. If adapter initialization fails before the thread is created (e.g., during `zfcp_allocate_low_mem_buffers()`), this results in a kernel panic because `kthread_stop()` does not handle NULL pointers.
> --
> 
> --- Patch [1]: [PATCH 1/1] fix memory leak during adapter release by destroying gid_pn_req ---
> commit 5b4668bd066d14a43f77f6f0301f8c98cbb5069c
> Author: Benjamin Block <bblock@linux.ibm.com>
> 
> fix memory leak during adapter release by destroying gid_pn_req

