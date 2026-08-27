Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F12F2E7BD3;
	Thu, 27 Aug 2026 19:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787858965; cv=none; b=ReIVgcEAF6EPrbOQTNEWlcKhVPR3XlB08+qNvUzI4SlhfLeX7TROsqRhjy2S3BRrlFJ27H/ejXIZVAs1GyJ1VHd6oWmr0XfjVmHtU8wA5nYzjz7aRv7a6uPI9OkjcSZSXlFi+D1mxtjNvvbhcZCFKiiLFFSOCYRT60iFQSn3Hvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787858965; c=relaxed/simple;
	bh=cDRsxf56F3/Wh0iBqyEVjXmTW9i33bbc9KIh31iQkA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=djf8rKJRISdE00jxjke2/s+A8+jbd7Nc2t2eVTdXxy8IBQLTQpqCWR2yBGwgBJ/jzz7gRwhbQV8YWmec2qaViy9d42GVClhAmpamp143XdMchfH0bCEBn6OG/rxNvePEnxP4tM66rrUKoSkA5+9riB+GljjQz1KZNqScAKrXtsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kpwDZcmu; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kpwDZcmu"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RIVoRh3824687;
	Thu, 27 Aug 2026 19:29:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=5zyyYD
	J8PBPYhibpxZcUISlvmkVNE1cw9rtTDW5gtf0=; b=kpwDZcmu4ksMYxDLovsiHY
	JKnw2q1Gc5ZLZv2+WwR0/dZRplrRfgDLXMcNEFoPGbW0qw3pO1lFwR1tafvf2iwg
	voUIlN/3fCQHPODBJ6aW7ttQMcML5pt9TxemWBWKdSxPzDbUPh3MjngctBHrRR3G
	LEufocB9xaYvYLI2Q/WBG3B17fNpPpS1u8EG2LUeX5+g+eH/PSrmnOxh80VJ4iSz
	a7CAd4nzfDjn66k6p0OxL5+8mumZej5PsdaijPXQ5lkC0y/v61dsMk3fmbIt2BQs
	5WvWtZ/kIcjDcUFZg5ppCbPqM7zhIn0nlco957VRflLzm3OhnNh8bm9cSj5+dnTQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g73g57mvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 19:29:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67RJQfwL028855;
	Thu, 27 Aug 2026 19:28:59 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g7qkhhvf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 19:28:59 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67RJSIlO7078426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Aug 2026 19:28:18 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD86158059;
	Thu, 27 Aug 2026 19:28:58 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 935C058053;
	Thu, 27 Aug 2026 19:28:57 +0000 (GMT)
Received: from [9.61.79.161] (unknown [9.61.79.161])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 27 Aug 2026 19:28:57 +0000 (GMT)
Message-ID: <a63f6b54-a4a7-431b-83c6-5b2cfe6f778e@linux.ibm.com>
Date: Thu, 27 Aug 2026 12:28:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ibmvfc: fix kernel-doc name for
 ibmvfc_scsi_relogin()
To: Muhammad Falak R Wani <falakreyaz@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org
References: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
Content-Language: en-US
From: Tyrel Datwyler <tyreld@linux.ibm.com>
In-Reply-To: <dd866cf2321381694af027fbd726bcbd63ac3751.1787828961.git.falakreyaz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 6lCR_JcS947Y8iRtjtbRiAqAK3vLydjk
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDE2MSBTYWx0ZWRfXwZesvi40N05f
 ngB9piIM+60vtE3uJViotq/Wzitv3G7KrbexsIW8sObgYwePygPhRG7Jwf3HnuJT1dhc/Tf2LjQ
 5sxzFhUNMkyfPow/URLRriBePOyT0eA=
X-Proofpoint-GUID: ZT81G29BOxZNMqooJ7itfk-VDBVe5nLQ
X-Authority-Analysis: v=2.4 cv=JZyMa0KV c=1 sm=1 tr=0 ts=6a908ffc cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=TIRtq7bqiOsBIkxYvl4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDE2MSBTYWx0ZWRfX1Re3ZORJ1C4A
 FVIrIkwRyH1L0SeiTAYt86OCuywetN52nHzRYS4w7T1pl+708cbgEZtNIv2qtCir0y8jME3En67
 ZWHWyuJ4ZEAfMGAAsLsGm2TkF+LY/AZv2m/ICByxss1KZdVWAoN3xCHIAUJXrwRGR5oHYNWigoU
 FU2NFItb/CaBNIqHmDUuFjbPGNkSbs6qwpQ6NMA4xHAue4wTQul1HrB5kZWFqs4bxtIfkSq8Q/J
 95Mnemgfr30EjgjSIvP+NA2VohTJtetlVpebUUBB0hhVQLVdyeMyHMTd3SHixbwRatXbmVHQ36g
 YhfaZ08uUPVumgR8hktg1Fj2TVlywZEaSTLIBmgP4GH/hNOZCdfUAi6+URVZhdvnzFEWYEQQ/0H
 yRLFZYRjzDWXrlW4Owb+sch/6CRB9ZAwsHdItuPf6qiJDqd/QgrapuXwjI5uNSqWcLtAlE0cTrA
 RuKSj59VR2wRpgCq19w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_07,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 adultscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270161

On 8/27/26 4:20 AM, Muhammad Falak R Wani wrote:
> Commit e0fca728a89f ("scsi: ibmvfc: delete NVMe/FC targets as well as
> SCSI") renamed ibmvfc_relogin() to ibmvfc_scsi_relogin() but left the
> kernel-doc comment referring to the old name, so a W=1 build warns:
> 
>   drivers/scsi/ibmvscsi/ibmvfc-core.c:1901: warning: expecting prototype
>   for ibmvfc_relogin(). Prototype was for ibmvfc_scsi_relogin() instead
> 
> Update the kernel-doc comment to use the current function name.
> 
> Fixes: e0fca728a89f ("scsi: ibmvfc: delete NVMe/FC targets as well as SCSI")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202608271026.iMLmrwz4-lkp@intel.com/
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
